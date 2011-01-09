Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1AIXDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:03:35 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35077 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1AIXDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=troWFePgo7ysIMqWnS1qo8GkWIdjJGHyYPAwUzpm0J5LReUpFmnHmG3GboXa8AFO59
         ZxIpeM8wtKuPkglqFkJBX+dsm7G4zkt4IBhkakBfJCHwysCcEVw0w02TtO1WBdKKS0vl
         s+Unlq/uML3VEyrrWfb0ArRX2HF4kpvnzglo8=
From: ahern.michael.t@gmail.com
To: gregkh@suse.de, u.kleine-koenig@pengutronix.de, julia@diku.dk,
        nikai@nikai.net, morgan.gatti@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mah <ahern.michael.t@gmail.com>
Subject: [PATCH 1/5] Staging: comedi: fix line-length coding style issue in usbduxfast.c
Date: Mon, 10 Jan 2011 10:03:12 +1100
Message-Id: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mah <ahern.michael.t@gmail.com>

This patch to usbduxfast.c file that fixes warnings found by checkpatch.pl tool

Signed-off-by: Michael Ahern <ahern.michael.t@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   54 +++++++++++++++-----------
 1 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 5b15e6d..be4f5ec 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -453,14 +453,16 @@ static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
 	/* 7f92 to zero */
 	local_transfer_buffer[0] = 0;
 	/* bRequest, "Firmware" */
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
-				VENDOR_DIR_OUT,	/* bmRequestType */
-				USBDUXFASTSUB_CPUCS,	/* Value */
-				0x0000,	/* Index */
-				/* address of the transfer buffer */
-				local_transfer_buffer,
-				1,	/* Length */
-				EZTIMEOUT);	/* Timeout */
+	ret = usb_control_msg(udfs->usbdev,
+			      usb_sndctrlpipe(udfs->usbdev, 0),
+			      USBDUXFASTSUB_FIRMWARE,
+			      VENDOR_DIR_OUT,		/* bmRequestType */
+			      USBDUXFASTSUB_CPUCS,	/* Value */
+			      0x0000,			/* Index */
+					/* address of the transfer buffer */
+			      local_transfer_buffer,
+			      1,			/* Length */
+			      EZTIMEOUT);		/* Timeout */
 	if (ret < 0) {
 		printk("comedi_: usbduxfast_: control msg failed (start)\n");
 		return ret;
@@ -477,12 +479,16 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 	/* 7f92 to one */
 	local_transfer_buffer[0] = 1;
 	/* bRequest, "Firmware" */
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
-			      VENDOR_DIR_OUT,	/* bmRequestType */
+	ret = usb_control_msg(udfs->usbdev,
+			      usb_sndctrlpipe(udfs->usbdev, 0),
+			      USBDUXFASTSUB_FIRMWARE,
+			      VENDOR_DIR_OUT,		/* bmRequestType */
 			      USBDUXFASTSUB_CPUCS,	/* Value */
-			      0x0000,	/* Index */
-			      local_transfer_buffer, 1,	/* Length */
-			      EZTIMEOUT);	/* Timeout */
+			      0x0000,			/* Index */
+			      local_transfer_buffer,
+			      1,			/* Length */
+			      EZTIMEOUT);		/* Timeout */
+
 	if (ret < 0) {
 		printk(KERN_ERR "comedi_: usbduxfast: control msg failed "
 		       "(stop)\n");
@@ -504,14 +510,16 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 	       startAddr, local_transfer_buffer[0]);
 #endif
 	/* brequest, firmware */
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
-				VENDOR_DIR_OUT,	/* bmRequestType */
-				startAddr,	/* value */
-				0x0000,	/* index */
-				/* our local safe buffer */
-				local_transfer_buffer,
-				len,	/* length */
-				EZTIMEOUT);	/* timeout */
+	ret = usb_control_msg(udfs->usbdev,
+			      usb_sndctrlpipe(udfs->usbdev, 0),
+			      USBDUXFASTSUB_FIRMWARE,
+			      VENDOR_DIR_OUT,	/* bmRequestType */
+			      startAddr,	/* value */
+			      0x0000,		/* index */
+			      /* our local safe buffer */
+			      local_transfer_buffer,
+			      len,		/* length */
+			      EZTIMEOUT);	/* timeout */
 
 #ifdef CONFIG_COMEDI_DEBUG
 	printk(KERN_DEBUG "comedi_: usbduxfast: result=%d\n", ret);
@@ -1436,7 +1444,7 @@ static void tidy_up(struct usbduxfastsub_s *udfs)
 	udfs->ai_cmd_running = 0;
 }
 
-static void usbduxfast_firmware_request_complete_handler(const struct firmware
+static void usbduxfast_firmware_req_complete_handler(const struct firmware
 							 *fw, void *context)
 {
 	struct usbduxfastsub_s *usbduxfastsub_tmp = context;
@@ -1577,7 +1585,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 				      &udev->dev,
 				      GFP_KERNEL,
 				      usbduxfastsub + index,
-				      usbduxfast_firmware_request_complete_handler);
+				      usbduxfast_firmware_req_complete_handler);
 
 	if (ret) {
 		dev_err(&udev->dev, "could not load firmware (err=%d)\n", ret);
-- 
1.7.0.4

