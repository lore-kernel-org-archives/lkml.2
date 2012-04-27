Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab2D0XZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:25:17 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:36204 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab2D0XZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:25:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1335569113!4269738!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcl726 driver to remove forward declarations
Date: Fri, 27 Apr 2012 16:25:06 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271625.06553.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index a880ceb..c63e91c 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -111,10 +111,6 @@ static const struct comedi_lrange *const rangelist_728[] = {
 	&range_4_20mA, &range_0_20mA
 };
 
-static int pcl726_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcl726_detach(struct comedi_device *dev);
-
 struct pcl726_board {
 
 	const char *name;	/*  driver name */
@@ -151,29 +147,6 @@ static const struct pcl726_board boardtypes[] = {
 
 #define this_board ((const struct pcl726_board *)dev->board_ptr)
 
-static struct comedi_driver driver_pcl726 = {
-	.driver_name = "pcl726",
-	.module = THIS_MODULE,
-	.attach = pcl726_attach,
-	.detach = pcl726_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct pcl726_board),
-};
-
-static int __init driver_pcl726_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl726);
-}
-
-static void __exit driver_pcl726_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl726);
-}
-
-module_init(driver_pcl726_init_module);
-module_exit(driver_pcl726_cleanup_module);
-
 struct pcl726_private {
 
 	int bipolar[12];
@@ -392,6 +365,28 @@ static int pcl726_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver driver_pcl726 = {
+	.driver_name	= "pcl726",
+	.module		= THIS_MODULE,
+	.attach		= pcl726_attach,
+	.detach		= pcl726_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct pcl726_board),
+};
+
+static int __init driver_pcl726_init_module(void)
+{
+	return comedi_driver_register(&driver_pcl726);
+}
+module_init(driver_pcl726_init_module);
+
+static void __exit driver_pcl726_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcl726);
+}
+module_exit(driver_pcl726_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
