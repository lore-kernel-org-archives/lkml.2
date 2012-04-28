Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2D1Abo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:31:44 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:25411 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab2D1Abn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:31:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1335573098!4281479!16
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor fl512 driver to remove forward declarations
Date: Fri, 27 Apr 2012 17:31:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271731.27541.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index 7f49add..88c18ea 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -42,38 +42,6 @@ static const struct comedi_lrange range_fl512 = { 4, {
 						      }
 };
 
-static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int fl512_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver_fl512 = {
-	.driver_name = "fl512",
-	.module = THIS_MODULE,
-	.attach = fl512_attach,
-	.detach = fl512_detach,
-};
-
-static int __init driver_fl512_init_module(void)
-{
-	return comedi_driver_register(&driver_fl512);
-}
-
-static void __exit driver_fl512_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_fl512);
-}
-
-module_init(driver_fl512_init_module);
-module_exit(driver_fl512_cleanup_module);
-
-static int fl512_ai_insn(struct comedi_device *dev,
-			 struct comedi_subdevice *s, struct comedi_insn *insn,
-			 unsigned int *data);
-static int fl512_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
-			 struct comedi_insn *insn, unsigned int *data);
-static int fl512_ao_insn_readback(struct comedi_device *dev,
-				  struct comedi_subdevice *s,
-				  struct comedi_insn *insn, unsigned int *data);
-
 /*
  * fl512_ai_insn : this is the analog input function
  */
@@ -140,9 +108,6 @@ static int fl512_ao_insn_readback(struct comedi_device *dev,
 	return n;
 }
 
-/*
- * start attach
- */
 static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	unsigned long iobase;
@@ -217,6 +182,25 @@ static int fl512_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver driver_fl512 = {
+	.driver_name	= "fl512",
+	.module		= THIS_MODULE,
+	.attach		= fl512_attach,
+	.detach		= fl512_detach,
+};
+
+static int __init driver_fl512_init_module(void)
+{
+	return comedi_driver_register(&driver_fl512);
+}
+module_init(driver_fl512_init_module);
+
+static void __exit driver_fl512_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_fl512);
+}
+module_exit(driver_fl512_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
