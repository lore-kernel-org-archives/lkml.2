Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2D0XV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:21:28 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:54451 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab2D0XV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:21:27 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1335568872!20687420!6
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcl730 driver to remove forward declarations
Date: Fri, 27 Apr 2012 16:21:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271621.21636.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index 78c8e59..f6fa8ae 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -26,47 +26,14 @@ The ACL-7130 card have an 8254 timer/counter not supported by this driver.
 #define PCL730_DIO_LO	2	/* TTL Digital I/O low byte (D0-D7) */
 #define PCL730_DIO_HI	3	/* TTL Digital I/O high byte (D8-D15) */
 
-static int pcl730_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcl730_detach(struct comedi_device *dev);
-
 struct pcl730_board {
 
 	const char *name;	/*  board name */
 	unsigned int io_range;	/*  len of I/O space */
 };
 
-static const struct pcl730_board boardtypes[] = {
-	{"pcl730", PCL730_SIZE,},
-	{"iso730", PCL730_SIZE,},
-	{"acl7130", ACL7130_SIZE,},
-};
-
 #define this_board ((const struct pcl730_board *)dev->board_ptr)
 
-static struct comedi_driver driver_pcl730 = {
-	.driver_name = "pcl730",
-	.module = THIS_MODULE,
-	.attach = pcl730_attach,
-	.detach = pcl730_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct pcl730_board),
-};
-
-static int __init driver_pcl730_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl730);
-}
-
-static void __exit driver_pcl730_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl730);
-}
-
-module_init(driver_pcl730_init_module);
-module_exit(driver_pcl730_cleanup_module);
-
 static int pcl730_do_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
@@ -177,6 +144,34 @@ static int pcl730_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct pcl730_board boardtypes[] = {
+	{ "pcl730", PCL730_SIZE, },
+	{ "iso730", PCL730_SIZE, },
+	{ "acl7130", ACL7130_SIZE, },
+};
+
+static struct comedi_driver driver_pcl730 = {
+	.driver_name	= "pcl730",
+	.module		= THIS_MODULE,
+	.attach		= pcl730_attach,
+	.detach		= pcl730_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct pcl730_board),
+};
+
+static int __init driver_pcl730_init_module(void)
+{
+	return comedi_driver_register(&driver_pcl730);
+}
+module_init(driver_pcl730_init_module);
+
+static void __exit driver_pcl730_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcl730);
+}
+module_exit(driver_pcl730_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
