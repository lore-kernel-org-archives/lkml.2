Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2FTTBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:01:43 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:3121 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab2FTTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:01:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1340218892!12009461!2
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/8] staging: comedi: usbduxsigma: use module_comedi_usb_driver()
Date: Wed, 20 Jun 2012 12:01:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201201.28234.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/usbduxsigma.c | 49 ++++++++--------------------
 1 file changed, 14 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 28f41e9..e430882 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -267,7 +267,7 @@ static struct usbduxsub usbduxsub[NUMUSBDUX];
 
 static DEFINE_SEMAPHORE(start_stop_sem);
 
-static struct comedi_driver driver_usbduxsigma;	/* see below for initializer */
+static struct comedi_driver usbduxsigma_driver;	/* see below for initializer */
 
 /*
  * Stops the data acquision
@@ -2331,7 +2331,7 @@ static void usbdux_firmware_request_complete_handler(const struct firmware *fw,
 			"Could not upload firmware (err=%d)\n", ret);
 		goto out;
 	}
-	comedi_usb_auto_config(uinterf, &driver_usbduxsigma);
+	comedi_usb_auto_config(uinterf, &usbduxsigma_driver);
 out:
 	release_firmware(fw);
 }
@@ -2828,12 +2828,12 @@ static void usbduxsigma_detach(struct comedi_device *dev)
 }
 
 /* main driver struct */
-static struct comedi_driver driver_usbduxsigma = {
-	.driver_name = "usbduxsigma",
-	.module = THIS_MODULE,
-	.attach = usbduxsigma_attach,
-	.detach = usbduxsigma_detach,
-	.attach_usb = usbduxsigma_attach_usb,
+static struct comedi_driver usbduxsigma_driver = {
+	.driver_name	= "usbduxsigma",
+	.module		= THIS_MODULE,
+	.attach		= usbduxsigma_attach,
+	.detach		= usbduxsigma_detach,
+	.attach_usb	= usbduxsigma_attach_usb,
 };
 
 /* Table with the USB-devices */
@@ -2847,34 +2847,13 @@ static const struct usb_device_id usbduxsigma_table[] = {
 MODULE_DEVICE_TABLE(usb, usbduxsigma_table);
 
 /* The usbduxsub-driver */
-static struct usb_driver usbduxsigma_driver = {
-	.name = BOARDNAME,
-	.probe = usbduxsigma_probe,
-	.disconnect = usbduxsigma_disconnect,
-	.id_table = usbduxsigma_table,
+static struct usb_driver usbduxsigma_usb_driver = {
+	.name		= BOARDNAME,
+	.probe		= usbduxsigma_probe,
+	.disconnect	= usbduxsigma_disconnect,
+	.id_table	= usbduxsigma_table,
 };
-
-/* Can't use the nice macro as I have also to initialise the USB */
-/* subsystem: */
-/* registering the usb-system _and_ the comedi-driver */
-static int __init init_usbduxsigma(void)
-{
-	printk(KERN_INFO KBUILD_MODNAME ": "
-	       DRIVER_VERSION ":" DRIVER_DESC "\n");
-	usb_register(&usbduxsigma_driver);
-	comedi_driver_register(&driver_usbduxsigma);
-	return 0;
-}
-
-/* deregistering the comedi driver and the usb-subsystem */
-static void __exit exit_usbduxsigma(void)
-{
-	comedi_driver_unregister(&driver_usbduxsigma);
-	usb_deregister(&usbduxsigma_driver);
-}
-
-module_init(init_usbduxsigma);
-module_exit(exit_usbduxsigma);
+module_comedi_usb_driver(usbduxsigma_driver, usbduxsigma_usb_driver);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-- 
1.7.11

