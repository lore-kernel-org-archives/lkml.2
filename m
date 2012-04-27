Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2D0VxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:53:08 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:12595 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2D0VxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:53:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-209.messagelabs.com!1335563569!4271088!20
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor rti800 driver to remove forward declarations
Date: Fri, 27 Apr 2012 14:52:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271452.53501.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index 72042b8..9e082b3 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -138,39 +138,8 @@ struct rti800_board {
 	int has_ao;
 };
 
-static const struct rti800_board boardtypes[] = {
-	{"rti800", 0},
-	{"rti815", 1},
-};
-
 #define this_board ((const struct rti800_board *)dev->board_ptr)
 
-static int rti800_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int rti800_detach(struct comedi_device *dev);
-static struct comedi_driver driver_rti800 = {
-	.driver_name = "rti800",
-	.module = THIS_MODULE,
-	.attach = rti800_attach,
-	.detach = rti800_detach,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.board_name = &boardtypes[0].name,
-	.offset = sizeof(struct rti800_board),
-};
-
-static int __init driver_rti800_init_module(void)
-{
-	return comedi_driver_register(&driver_rti800);
-}
-
-static void __exit driver_rti800_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_rti800);
-}
-
-module_init(driver_rti800_init_module);
-module_exit(driver_rti800_cleanup_module);
-
 static irqreturn_t rti800_interrupt(int irq, void *dev);
 
 struct rti800_private {
@@ -487,6 +456,33 @@ static int rti800_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct rti800_board boardtypes[] = {
+	{ "rti800", 0 },
+	{ "rti815", 1 },
+};
+
+static struct comedi_driver driver_rti800 = {
+	.driver_name	= "rti800",
+	.module		= THIS_MODULE,
+	.attach		= rti800_attach,
+	.detach		= rti800_detach,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.board_name	= &boardtypes[0].name,
+	.offset		= sizeof(struct rti800_board),
+};
+
+static int __init driver_rti800_init_module(void)
+{
+	return comedi_driver_register(&driver_rti800);
+}
+module_init(driver_rti800_init_module);
+
+static void __exit driver_rti800_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_rti800);
+}
+module_exit(driver_rti800_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
