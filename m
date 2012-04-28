Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2D1A5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:57:42 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:7008 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446Ab2D1A5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:57:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1335574587!2319286!20
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] staging: comedi: refactor dt2817 driver to remove forward declarations
Date: Fri, 27 Apr 2012 17:57:16 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271757.16559.hartleys@visionengravers.com>
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

v2: I fat fingered the previous one and included another patch

diff --git a/drivers/staging/comedi/drivers/dt2817.c b/drivers/staging/comedi/drivers/dt2817.c
index 99c1584..45d9a82 100644
--- a/drivers/staging/comedi/drivers/dt2817.c
+++ b/drivers/staging/comedi/drivers/dt2817.c
@@ -47,29 +47,6 @@ Configuration options:
 #define DT2817_CR 0
 #define DT2817_DATA 1
 
-static int dt2817_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int dt2817_detach(struct comedi_device *dev);
-static struct comedi_driver driver_dt2817 = {
-	.driver_name = "dt2817",
-	.module = THIS_MODULE,
-	.attach = dt2817_attach,
-	.detach = dt2817_detach,
-};
-
-static int __init driver_dt2817_init_module(void)
-{
-	return comedi_driver_register(&driver_dt2817);
-}
-
-static void __exit driver_dt2817_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_dt2817);
-}
-
-module_init(driver_dt2817_init_module);
-module_exit(driver_dt2817_cleanup_module);
-
 static int dt2817_dio_insn_config(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
@@ -192,6 +169,25 @@ static int dt2817_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver driver_dt2817 = {
+	.driver_name	= "dt2817",
+	.module		= THIS_MODULE,
+	.attach		= dt2817_attach,
+	.detach		= dt2817_detach,
+};
+
+static int __init driver_dt2817_init_module(void)
+{
+	return comedi_driver_register(&driver_dt2817);
+}
+module_init(driver_dt2817_init_module);
+
+static void __exit driver_dt2817_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_dt2817);
+}
+module_exit(driver_dt2817_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
