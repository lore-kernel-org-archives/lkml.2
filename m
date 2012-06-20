Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2FTTMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:12:17 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:19745 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603Ab2FTTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:12:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1340218890!7278668!22
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] staging: comedi: vmk80xx: use module_comedi_usb_driver()
Date: Wed, 20 Jun 2012 12:01:44 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201201.44466.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/vmk80xx.c | 50 +++++++++-----------------------
 1 file changed, 14 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 7d3cb3a..14fb50a 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -232,7 +232,7 @@ static struct vmk80xx_usb vmb[VMK80XX_MAX_BOARDS];
 
 static DEFINE_MUTEX(glb_mutex);
 
-static struct comedi_driver driver_vmk80xx;	/* see below for initializer */
+static struct comedi_driver vmk80xx_driver;	/* see below for initializer */
 
 static void vmk80xx_tx_callback(struct urb *urb)
 {
@@ -1410,7 +1410,7 @@ static int vmk80xx_probe(struct usb_interface *intf,
 
 	mutex_unlock(&glb_mutex);
 
-	comedi_usb_auto_config(intf, &driver_vmk80xx);
+	comedi_usb_auto_config(intf, &vmk80xx_driver);
 
 	return 0;
 error:
@@ -1449,40 +1449,18 @@ static void vmk80xx_disconnect(struct usb_interface *intf)
 
 /* TODO: Add support for suspend, resume, pre_reset,
  * post_reset and flush */
-static struct usb_driver vmk80xx_driver = {
-	.name = "vmk80xx",
-	.probe = vmk80xx_probe,
-	.disconnect = vmk80xx_disconnect,
-	.id_table = vmk80xx_id_table
+static struct usb_driver vmk80xx_usb_driver = {
+	.name		= "vmk80xx",
+	.probe		= vmk80xx_probe,
+	.disconnect	= vmk80xx_disconnect,
+	.id_table	= vmk80xx_id_table
 };
 
-static struct comedi_driver driver_vmk80xx = {
-	.module = THIS_MODULE,
-	.driver_name = "vmk80xx",
-	.attach = vmk80xx_attach,
-	.detach = vmk80xx_detach,
-	.attach_usb = vmk80xx_attach_usb,
+static struct comedi_driver vmk80xx_driver = {
+	.module		= THIS_MODULE,
+	.driver_name	= "vmk80xx",
+	.attach		= vmk80xx_attach,
+	.detach		= vmk80xx_detach,
+	.attach_usb	= vmk80xx_attach_usb,
 };
-
-static int __init vmk80xx_init(void)
-{
-	int retval;
-
-	printk(KERN_INFO "vmk80xx: version 0.8.01 "
-	       "Manuel Gebele <forensixs@gmx.de>\n");
-
-	retval = comedi_driver_register(&driver_vmk80xx);
-	if (retval < 0)
-		return retval;
-
-	return usb_register(&vmk80xx_driver);
-}
-
-static void __exit vmk80xx_exit(void)
-{
-	comedi_driver_unregister(&driver_vmk80xx);
-	usb_deregister(&vmk80xx_driver);
-}
-
-module_init(vmk80xx_init);
-module_exit(vmk80xx_exit);
+module_comedi_usb_driver(vmk80xx_driver, vmk80xx_usb_driver);
-- 
1.7.11

