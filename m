Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab2EKKkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:40:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63800 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab2EKKkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:40:37 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 07/25] Staging: comedi: fix printk issues in usbduxfast.c
Date: Fri, 11 May 2012 16:07:55 +0530
Message-Id: <1336732693-7408-8-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the usbduxfast.c file that fixes up a printk found
by checkpatch.pl tool.

i.e. WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
     WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
     WARNING: quoted string split across lines.
     WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 3824d51..e9c556c 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -499,9 +499,9 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 	int ret;
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi: usbduxfast: uploading %d bytes", len);
-	printk(KERN_DEBUG " to addr %d, first byte=%d.\n",
-	       startAddr, local_transfer_buffer[0]);
+	pr_debug("comedi: usbduxfast: uploading %d bytes", len);
+	pr_cont(" to addr %d, first byte=%d.\n", startAddr,
+		local_transfer_buffer[0]);
 #endif
 	/* brequest, firmware */
 	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0),
@@ -515,11 +515,11 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 			      EZTIMEOUT);      /* timeout */
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast: result=%d\n", ret);
+	pr_debug("comedi_: usbduxfast: result=%d\n", ret);
 #endif
 
 	if (ret < 0) {
-		printk(KERN_ERR "comedi_: usbduxfast: uppload failed\n");
+		pr_err("comedi_: usbduxfast: uppload failed\n");
 		return ret;
 	}
 
@@ -1401,7 +1401,7 @@ static int firmwareUpload(struct usbduxfastsub_s *usbduxfastsub,
 static void tidy_up(struct usbduxfastsub_s *udfs)
 {
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast: tiding up\n");
+	pr_debug("comedi_: usbduxfast: tiding up\n");
 #endif
 
 	if (!udfs)
@@ -1588,13 +1588,11 @@ static void usbduxfastsub_disconnect(struct usb_interface *intf)
 	struct usb_device *udev = interface_to_usbdev(intf);
 
 	if (!udfs) {
-		printk(KERN_ERR "comedi_: usbduxfast: disconnect called with "
-		       "null pointer.\n");
+		pr_err("comedi_: usbduxfast: disconnect called with null pointer.\n");
 		return;
 	}
 	if (udfs->usbdev != udev) {
-		printk(KERN_ERR "comedi_: usbduxfast: BUG! called with wrong "
-		       "ptr!!!\n");
+		pr_err("comedi_: usbduxfast: BUG! called with wrong ptr!!!\n");
 		return;
 	}
 
@@ -1607,7 +1605,7 @@ static void usbduxfastsub_disconnect(struct usb_interface *intf)
 	up(&start_stop_sem);
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast: disconnected from the usb\n");
+	pr_debug("comedi_: usbduxfast: disconnected from the usb\n");
 #endif
 }
 
@@ -1790,8 +1788,7 @@ static struct usb_driver usbduxfastsub_driver = {
  */
 static int __init init_usbduxfast(void)
 {
-	printk(KERN_INFO
-	       KBUILD_MODNAME ": " DRIVER_VERSION ":" DRIVER_DESC "\n");
+	pr_info(KBUILD_MODNAME ": " DRIVER_VERSION ":" DRIVER_DESC "\n");
 	usb_register(&usbduxfastsub_driver);
 	comedi_driver_register(&driver_usbduxfast);
 	return 0;
-- 
1.7.0.4

