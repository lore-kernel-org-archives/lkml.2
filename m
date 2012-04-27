Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2D0Wuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:50:52 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:23155 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2D0Wuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:50:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-209.messagelabs.com!1335567049!4275921!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcm3730 driver to remove forward declarations
Date: Fri, 27 Apr 2012 15:50:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271550.41418.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcm3730.c b/drivers/staging/comedi/drivers/pcm3730.c
index bada6b2..3428993 100644
--- a/drivers/staging/comedi/drivers/pcm3730.c
+++ b/drivers/staging/comedi/drivers/pcm3730.c
@@ -28,29 +28,6 @@ Configuration options:
 #define PCM3730_DIB 2
 #define PCM3730_DIC 3
 
-static int pcm3730_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int pcm3730_detach(struct comedi_device *dev);
-static struct comedi_driver driver_pcm3730 = {
-	.driver_name = "pcm3730",
-	.module = THIS_MODULE,
-	.attach = pcm3730_attach,
-	.detach = pcm3730_detach,
-};
-
-static int __init driver_pcm3730_init_module(void)
-{
-	return comedi_driver_register(&driver_pcm3730);
-}
-
-static void __exit driver_pcm3730_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcm3730);
-}
-
-module_init(driver_pcm3730_init_module);
-module_exit(driver_pcm3730_cleanup_module);
-
 static int pcm3730_do_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
@@ -166,6 +143,25 @@ static int pcm3730_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver driver_pcm3730 = {
+	.driver_name	= "pcm3730",
+	.module		= THIS_MODULE,
+	.attach		= pcm3730_attach,
+	.detach		= pcm3730_detach,
+};
+
+static int __init driver_pcm3730_init_module(void)
+{
+	return comedi_driver_register(&driver_pcm3730);
+}
+module_init(driver_pcm3730_init_module);
+
+static void __exit driver_pcm3730_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcm3730);
+}
+module_exit(driver_pcm3730_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
