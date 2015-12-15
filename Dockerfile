FROM node:0.10.40-wheezy

MAINTAINER thewei

RUN apt-get update && apt-get install -y git curl python

ENV WORK_DIR /var/www
ENV METEOR_DIR /var/meteor
ENV METEOR_RELEASE 1.2.1
ENV PORT 3000

# RUN chown -R www-data:www-data $WORK_DIR

# Install Meteor
RUN curl  https://install.meteor.com/ 2>/dev/null | sed 's/^RELEASE/#RELEASE/'| RELEASE=$METEOR_RELEASE sh

#RUN npm install -g pm2 fibers

#RUN meteor install
COPY . $METEOR_DIR
RUN cd $METEOR_DIR && meteor build --directory $WORK_DIR

#RUN tar -zxvf $WORK_DIR/app.tar.gz -C $WORK_DIR
RUN cd $WORK_DIR/bundle/programs/server && npm install

EXPOSE $PORT

#CMD cd $WORK_DIR/bundle && pm2 start main.js --no-daemon
CMD PORT=$PORT MONGO_URL=mongodb://$MONGODB_USERNAME:$MONGODB_PASSWORD@$MONGODB_PORT_27017_TCP_ADDR:$MONGODB_PORT_27017_TCP_PORT/$MONGODB_INSTANCE_NAME ROOT_URL=http://localhost node $WORK_DIR/bundle/main.js
