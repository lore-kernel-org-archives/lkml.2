Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab2EAEHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 00:07:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33404 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2EAEG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 00:06:58 -0400
From: Preston Fick <pffick@gmail.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: preston.fick@silabs.com
Subject: [PATCH 1/3] usb: cp210x: Corrected USB request type definitions
Date: Mon, 30 Apr 2012 23:06:48 -0500
Message-Id: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original request types in the cp210x driver are labled as "DEVICE_TO_HOST" and
"HOST_TO_DEVICE" but the actual bit definition corresponds to a request to the
interface. This has been corrected, and the actual definition for the device
requests have been added.

Signed-off-by: Preston Fick <preston.fick@silabs.com>
---
 drivers/usb/serial/cp210x.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index ec30f95..e67ccf3 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -188,8 +188,10 @@ static struct usb_serial_driver * const serial_drivers[] = {
 };
 
 /* Config request types */
-#define REQTYPE_HOST_TO_DEVICE	0x41
-#define REQTYPE_DEVICE_TO_HOST	0xc1
+#define REQTYPE_HOST_TO_INTERFACE	0x41
+#define REQTYPE_INTERFACE_TO_HOST	0xc1
+#define REQTYPE_HOST_TO_DEVICE	0x40
+#define REQTYPE_DEVICE_TO_HOST	0xc0
 
 /* Config request codes */
 #define CP210X_IFC_ENABLE	0x00
@@ -286,7 +288,7 @@ static int cp210x_get_config(struct usb_serial_port *port, u8 request,
 
 	/* Issue the request, attempting to read 'size' bytes */
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
+				request, REQTYPE_INTERFACE_TO_HOST, 0x0000,
 				port_priv->bInterfaceNumber, buf, size,
 				USB_CTRL_GET_TIMEOUT);
 
@@ -340,13 +342,13 @@ static int cp210x_set_config(struct usb_serial_port *port, u8 request,
 	if (size > 2) {
 		result = usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
-				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
+				request, REQTYPE_HOST_TO_INTERFACE, 0x0000,
 				port_priv->bInterfaceNumber, buf, size,
 				USB_CTRL_SET_TIMEOUT);
 	} else {
 		result = usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
-				request, REQTYPE_HOST_TO_DEVICE, data[0],
+				request, REQTYPE_HOST_TO_INTERFACE, data[0],
 				port_priv->bInterfaceNumber, NULL, 0,
 				USB_CTRL_SET_TIMEOUT);
 	}
-- 
1.7.5.4

