Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2D0X2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:28:06 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:29491 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab2D0X2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:28:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1335569247!4982566!9
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcl725 driver to remove forward declarations
Date: Fri, 27 Apr 2012 16:27:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271627.20797.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and other variables to the end of the source.
This is more typical of how other drivers are written and removes
the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/pcl725.c b/drivers/staging/comedi/drivers/pcl725.c
index 24b223c..4b761a6 100644
--- a/drivers/staging/comedi/drivers/pcl725.c
+++ b/drivers/staging/comedi/drivers/pcl725.c
@@ -20,29 +20,6 @@ Devices: [Advantech] PCL-725 (pcl725)
 #define PCL725_DO 0
 #define PCL725_DI 1
 
-static int pcl725_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcl725_detach(struct comedi_device *dev);
-static struct comedi_driver driver_pcl725 = {
-	.driver_name = "pcl725",
-	.module = THIS_MODULE,
-	.attach = pcl725_attach,
-	.detach = pcl725_detach,
-};
-
-static int __init driver_pcl725_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl725);
-}
-
-static void __exit driver_pcl725_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl725);
-}
-
-module_init(driver_pcl725_init_module);
-module_exit(driver_pcl725_cleanup_module);
-
 static int pcl725_do_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
@@ -122,6 +99,25 @@ static int pcl725_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver driver_pcl725 = {
+	.driver_name	= "pcl725",
+	.module		= THIS_MODULE,
+	.attach		= pcl725_attach,
+	.detach		= pcl725_detach,
+};
+
+static int __init driver_pcl725_init_module(void)
+{
+	return comedi_driver_register(&driver_pcl725);
+}
+module_init(driver_pcl725_init_module);
+
+static void __exit driver_pcl725_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcl725);
+}
+module_exit(driver_pcl725_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
