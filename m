Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1FCAds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 20:33:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46151 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1FCAdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 20:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V+0yyxJkNHrIWhGE9CH21AgXk3ooGalTJ1bcMtdh08l9Ppv2nv8VIlIXOPp+fNJZ5d
         KVKy3Bo95j+V1qHI9Pf3niFZ3qjaxQVKFAsE6RD/PwA6qtthHZW4qhgOVGX8ehAw4yQu
         qYONgdz5cWaL4Yb1TKUWmHVmR+Fasb5iOIX4w=
From: Curtis McEnroe <programble@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Curtis McEnroe <programble@gmail.com>
Subject: [PATCH 2/5] [media] tm6000: Cleaned up code style in tm6000-dbv.c
Date: Thu,  2 Jun 2011 20:33:31 -0400
Message-Id: <1307061214-14837-1-git-send-email-programble@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced usage of __FUNCTION__ with __func__

Signed-off-by: Curtis McEnroe <programble@gmail.com>
---
 drivers/staging/tm6000/tm6000-dvb.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index ff04c89..0e0dfce 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -98,7 +98,7 @@ static void tm6000_urb_received(struct urb *urb)
 	if (dev->dvb->streams > 0) {
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
 		if (ret < 0) {
-			printk(KERN_ERR "tm6000:  error %s\n", __FUNCTION__);
+			printk(KERN_ERR "tm6000:  error %s\n", __func__);
 			kfree(urb->transfer_buffer);
 			usb_free_urb(urb);
 		}
@@ -111,7 +111,7 @@ int tm6000_start_stream(struct tm6000_core *dev)
 	unsigned int pipe, size;
 	struct tm6000_dvb *dvb = dev->dvb;
 
-	printk(KERN_INFO "tm6000: got start stream request %s\n", __FUNCTION__);
+	printk(KERN_INFO "tm6000: got start stream request %s\n", __func__);
 
 	if (dev->mode != TM6000_MODE_DIGITAL) {
 		tm6000_init_digital_mode(dev);
@@ -145,7 +145,7 @@ int tm6000_start_stream(struct tm6000_core *dev)
 	ret = usb_clear_halt(dev->udev, pipe);
 	if (ret < 0) {
 		printk(KERN_ERR "tm6000: error %i in %s during pipe reset\n",
-							ret, __FUNCTION__);
+							ret, __func__);
 		return ret;
 	} else
 		printk(KERN_ERR "tm6000: pipe resetted\n");
@@ -185,7 +185,7 @@ int tm6000_start_feed(struct dvb_demux_feed *feed)
 	struct dvb_demux *demux = feed->demux;
 	struct tm6000_core *dev = demux->priv;
 	struct tm6000_dvb *dvb = dev->dvb;
-	printk(KERN_INFO "tm6000: got start feed request %s\n", __FUNCTION__);
+	printk(KERN_INFO "tm6000: got start feed request %s\n", __func__);
 
 	mutex_lock(&dvb->mutex);
 	if (dvb->streams == 0) {
@@ -205,7 +205,7 @@ int tm6000_stop_feed(struct dvb_demux_feed *feed)
 	struct tm6000_core *dev = demux->priv;
 	struct tm6000_dvb *dvb = dev->dvb;
 
-	printk(KERN_INFO "tm6000: got stop feed request %s\n", __FUNCTION__);
+	printk(KERN_INFO "tm6000: got stop feed request %s\n", __func__);
 
 	mutex_lock(&dvb->mutex);
 
-- 
1.7.5.2

