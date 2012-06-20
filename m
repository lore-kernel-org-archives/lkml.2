Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab2FTTBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:01:32 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:15156 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab2FTTB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:01:29 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1340218867!6452328!32
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/8] staging: comedi: usbduxfast: use module_comedi_usb_driver()
Date: Wed, 20 Jun 2012 12:01:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201201.15042.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the module_comedi_usb_driver helper macro to initialize this
module. Rename the driver structs to follow the pattern of the
other comedi driver types and add some whitespace to improve
readability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/usbduxfast.c | 57 ++++++++---------------------
 1 file changed, 15 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index c713620..8c8e4ec9 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -196,7 +196,7 @@ static struct usbduxfastsub_s usbduxfastsub[NUMUSBDUXFAST];
 
 static DEFINE_SEMAPHORE(start_stop_sem);
 
-static struct comedi_driver driver_usbduxfast;	/* see below for initializer */
+static struct comedi_driver usbduxfast_driver;	/* see below for initializer */
 
 /*
  * bulk transfers to usbduxfast
@@ -1458,7 +1458,7 @@ static void usbduxfast_firmware_request_complete_handler(const struct firmware
 		goto out;
 	}
 
-	comedi_usb_auto_config(uinterf, &driver_usbduxfast);
+	comedi_usb_auto_config(uinterf, &usbduxfast_driver);
  out:
 	release_firmware(fw);
 }
@@ -1757,12 +1757,12 @@ static void usbduxfast_detach(struct comedi_device *dev)
 /*
  * main driver struct
  */
-static struct comedi_driver driver_usbduxfast = {
-	.driver_name = "usbduxfast",
-	.module = THIS_MODULE,
-	.attach = usbduxfast_attach,
-	.detach = usbduxfast_detach,
-	.attach_usb = usbduxfast_attach_usb,
+static struct comedi_driver usbduxfast_driver = {
+	.driver_name	= "usbduxfast",
+	.module		= THIS_MODULE,
+	.attach		= usbduxfast_attach,
+	.detach		= usbduxfast_detach,
+	.attach_usb	= usbduxfast_attach_usb,
 };
 
 /*
@@ -1777,43 +1777,16 @@ static const struct usb_device_id usbduxfastsub_table[] = {
 
 MODULE_DEVICE_TABLE(usb, usbduxfastsub_table);
 
-/*
- * The usbduxfastsub-driver
- */
-static struct usb_driver usbduxfastsub_driver = {
+static struct usb_driver usbduxfast_usb_driver = {
 #ifdef COMEDI_HAVE_USB_DRIVER_OWNER
-	.owner = THIS_MODULE,
+	.owner		= THIS_MODULE,
 #endif
-	.name = BOARDNAME,
-	.probe = usbduxfastsub_probe,
-	.disconnect = usbduxfastsub_disconnect,
-	.id_table = usbduxfastsub_table
+	.name		= BOARDNAME,
+	.probe		= usbduxfastsub_probe,
+	.disconnect	= usbduxfastsub_disconnect,
+	.id_table	= usbduxfastsub_table,
 };
-
-/*
- * Can't use the nice macro as I have also to initialise the USB subsystem:
- * registering the usb-system _and_ the comedi-driver
- */
-static int __init init_usbduxfast(void)
-{
-	printk(KERN_INFO
-	       KBUILD_MODNAME ": " DRIVER_VERSION ":" DRIVER_DESC "\n");
-	usb_register(&usbduxfastsub_driver);
-	comedi_driver_register(&driver_usbduxfast);
-	return 0;
-}
-
-/*
- * deregistering the comedi driver and the usb-subsystem
- */
-static void __exit exit_usbduxfast(void)
-{
-	comedi_driver_unregister(&driver_usbduxfast);
-	usb_deregister(&usbduxfastsub_driver);
-}
-
-module_init(init_usbduxfast);
-module_exit(exit_usbduxfast);
+module_comedi_usb_driver(usbduxfast_driver, usbduxfast_usb_driver);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-- 
1.7.11

