Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab2FTTBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:01:06 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:25618 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2FTTBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:01:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1340218862!22998957!2
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] staging: comedi: usbdux: use module_comedi_usb_driver()
Date: Wed, 20 Jun 2012 12:00:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201200.57853.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/usbdux.c | 50 +++++++++------------------------
 1 file changed, 14 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 83ee669..586936b 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -317,7 +317,7 @@ static struct usbduxsub usbduxsub[NUMUSBDUX];
 
 static DEFINE_SEMAPHORE(start_stop_sem);
 
-static struct comedi_driver driver_usbdux;	/* see below for initializer */
+static struct comedi_driver usbdux_driver;	/* see below for initializer */
 
 /*
  * Stops the data acquision
@@ -2323,7 +2323,7 @@ static void usbdux_firmware_request_complete_handler(const struct firmware *fw,
 			"Could not upload firmware (err=%d)\n", ret);
 		goto out;
 	}
-	comedi_usb_auto_config(uinterf, &driver_usbdux);
+	comedi_usb_auto_config(uinterf, &usbdux_driver);
  out:
 	release_firmware(fw);
 }
@@ -2832,12 +2832,12 @@ static void usbdux_detach(struct comedi_device *dev)
 }
 
 /* main driver struct */
-static struct comedi_driver driver_usbdux = {
-	.driver_name = "usbdux",
-	.module = THIS_MODULE,
-	.attach = usbdux_attach,
-	.detach = usbdux_detach,
-	.attach_usb = usbdux_attach_usb,
+static struct comedi_driver usbdux_driver = {
+	.driver_name	= "usbdux",
+	.module		= THIS_MODULE,
+	.attach		= usbdux_attach,
+	.detach		= usbdux_detach,
+	.attach_usb	= usbdux_attach_usb,
 };
 
 /* Table with the USB-devices: just now only testing IDs */
@@ -2849,35 +2849,13 @@ static const struct usb_device_id usbduxsub_table[] = {
 
 MODULE_DEVICE_TABLE(usb, usbduxsub_table);
 
-/* The usbduxsub-driver */
-static struct usb_driver usbduxsub_driver = {
-	.name = BOARDNAME,
-	.probe = usbduxsub_probe,
-	.disconnect = usbduxsub_disconnect,
-	.id_table = usbduxsub_table,
+static struct usb_driver usbdux_usb_driver = {
+	.name		= BOARDNAME,
+	.probe		= usbduxsub_probe,
+	.disconnect	= usbduxsub_disconnect,
+	.id_table	= usbduxsub_table,
 };
-
-/* Can't use the nice macro as I have also to initialise the USB */
-/* subsystem: */
-/* registering the usb-system _and_ the comedi-driver */
-static int __init init_usbdux(void)
-{
-	printk(KERN_INFO KBUILD_MODNAME ": "
-	       DRIVER_VERSION ":" DRIVER_DESC "\n");
-	usb_register(&usbduxsub_driver);
-	comedi_driver_register(&driver_usbdux);
-	return 0;
-}
-
-/* deregistering the comedi driver and the usb-subsystem */
-static void __exit exit_usbdux(void)
-{
-	comedi_driver_unregister(&driver_usbdux);
-	usb_deregister(&usbduxsub_driver);
-}
-
-module_init(init_usbdux);
-module_exit(exit_usbdux);
+module_comedi_usb_driver(usbdux_driver, usbdux_usb_driver);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-- 
1.7.11

