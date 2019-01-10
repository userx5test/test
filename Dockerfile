FROM graviteeio/java:8
#MAINTAINER Gravitee Team <http://gravitee.io>

ARG GRAVITEEIO_VERSION=0
ENV GRAVITEEIO_HOME /opt/graviteeio-management-api

# Update to get support for Zip/Unzip, nc and wget
RUN apk add --update zip unzip netcat-openbsd wget

RUN wget https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-${GRAVITEEIO_VERSION}.zip --no-check-certificate -P /tmp/ \
    && unzip /tmp/graviteeio-full-${GRAVITEEIO_VERSION}.zip -d /tmp/ \
    && mv /tmp/graviteeio-full-${GRAVITEEIO_VERSION}/graviteeio-management-api* ${GRAVITEEIO_HOME} \
    && rm -rf /tmp/*

RUN addgroup -g 1000 gravitee \
    && adduser -D -u 1000 -G gravitee -h ${GRAVITEEIO_HOME} gravitee \
    && chown -R gravitee:gravitee ${GRAVITEEIO_HOME}

USER 1000

WORKDIR ${GRAVITEEIO_HOME}

EXPOSE 8083
VOLUME ["/opt/graviteeio-management-api/logs"]
CMD ["./bin/gravitee"]
