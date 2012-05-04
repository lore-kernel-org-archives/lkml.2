Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386Ab2EDWT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:19:59 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:54351 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2EDWT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:19:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1336169996!2903755!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor multiq3 driver and use module_comedi_driver
Date: Fri, 4 May 2012 15:19:49 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041519.50021.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver to the end of the source. Convert
the driver to use the module_comedi_driver() macro which makes
the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

diff --git a/drivers/staging/comedi/drivers/multiq3.c b/drivers/staging/comedi/drivers/multiq3.c
index dace902..206296c 100644
--- a/drivers/staging/comedi/drivers/multiq3.c
+++ b/drivers/staging/comedi/drivers/multiq3.c
@@ -83,29 +83,6 @@ Devices: [Quanser Consulting] MultiQ-3 (multiq3)
 
 #define MULTIQ3_TIMEOUT 30
 
-static int multiq3_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int multiq3_detach(struct comedi_device *dev);
-static struct comedi_driver driver_multiq3 = {
-	.driver_name = "multiq3",
-	.module = THIS_MODULE,
-	.attach = multiq3_attach,
-	.detach = multiq3_detach,
-};
-
-static int __init driver_multiq3_init_module(void)
-{
-	return comedi_driver_register(&driver_multiq3);
-}
-
-static void __exit driver_multiq3_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_multiq3);
-}
-
-module_init(driver_multiq3_init_module);
-module_exit(driver_multiq3_cleanup_module);
-
 struct multiq3_private {
 	unsigned int ao_readback[2];
 };
@@ -350,6 +327,14 @@ static int multiq3_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver multiq3_driver = {
+	.driver_name	= "multiq3",
+	.module		= THIS_MODULE,
+	.attach		= multiq3_attach,
+	.detach		= multiq3_detach,
+};
+module_comedi_driver(multiq3_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
