Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1CUKTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:19:32 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44302 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1CUKTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:19:30 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, pb@linuxtv.org,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 1/9] [media] vp702x: cleanup: whitespace and indentation
Date: Mon, 21 Mar 2011 11:19:06 +0100
Message-Id: <1300702754-16376-2-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300702754-16376-1-git-send-email-florian@mickler.org>
References: <1300702754-16376-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some whitespace, one linebreak and one unneded variable
initialization...

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/vp702x.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 7890e75..4c9939f 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -36,14 +36,14 @@ struct vp702x_device_state {
 /* check for mutex FIXME */
 int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
 {
-	int ret = -1;
+	int ret;
 
-		ret = usb_control_msg(d->udev,
-			usb_rcvctrlpipe(d->udev,0),
-			req,
-			USB_TYPE_VENDOR | USB_DIR_IN,
-			value,index,b,blen,
-			2000);
+	ret = usb_control_msg(d->udev,
+		usb_rcvctrlpipe(d->udev, 0),
+		req,
+		USB_TYPE_VENDOR | USB_DIR_IN,
+		value, index, b, blen,
+		2000);
 
 	if (ret < 0) {
 		warn("usb in operation failed. (%d)", ret);
@@ -221,7 +221,8 @@ static int vp702x_frontend_attach(struct dvb_usb_adapter *adap)
 
 	vp702x_usb_out_op(adap->dev, SET_TUNER_POWER_REQ, 0, 7, NULL, 0);
 
-	if (vp702x_usb_inout_cmd(adap->dev, GET_SYSTEM_STRING, NULL, 0, buf, 10, 10))
+	if (vp702x_usb_inout_cmd(adap->dev, GET_SYSTEM_STRING, NULL, 0,
+				   buf, 10, 10))
 		return -EIO;
 
 	buf[9] = '\0';
@@ -307,9 +308,9 @@ static struct dvb_usb_device_properties vp702x_properties = {
 /* usb specific object needed to register this driver with the usb subsystem */
 static struct usb_driver vp702x_usb_driver = {
 	.name		= "dvb_usb_vp702x",
-	.probe 		= vp702x_usb_probe,
-	.disconnect = dvb_usb_device_exit,
-	.id_table 	= vp702x_usb_table,
+	.probe		= vp702x_usb_probe,
+	.disconnect	= dvb_usb_device_exit,
+	.id_table	= vp702x_usb_table,
 };
 
 /* module stuff */
-- 
1.7.4.1

