Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2D0XNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:13:53 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:35174 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab2D0XNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:13:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1335568431!20662657!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcl816 driver to remove forward declarations
Date: Fri, 27 Apr 2012 16:13:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271613.37791.hartleys@visionengravers.com>
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

There are still some forward declarations in this file but fixing them
in this patch makes in to messy for review.

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index bf7b262..bccbb23 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -125,62 +125,14 @@ struct pcl816_board {
 	int i8254_osc_base;	/*  1/frequency of on board oscilator in ns */
 };
 
-static const struct pcl816_board boardtypes[] = {
-	{"pcl816", 8, 16, 10000, 1, 16, 16, &range_pcl816,
-	 &range_pcl816, PCLx1x_RANGE,
-	 0x00fc,		/*  IRQ mask */
-	 0x0a,			/*  DMA mask */
-	 0xffff,		/*  16-bit card */
-	 0xffff,		/*  D/A maxdata */
-	 1024,
-	 1,			/*  ao chan list */
-	 100},
-	{"pcl814b", 8, 16, 10000, 1, 16, 16, &range_pcl816,
-	 &range_pcl816, PCLx1x_RANGE,
-	 0x00fc,
-	 0x0a,
-	 0x3fff,		/* 14 bit card */
-	 0x3fff,
-	 1024,
-	 1,
-	 100},
-};
-
 #define devpriv ((struct pcl816_private *)dev->private)
 #define this_board ((const struct pcl816_board *)dev->board_ptr)
 
-static int pcl816_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcl816_detach(struct comedi_device *dev);
-
 #ifdef unused
 static int RTC_lock;	/* RTC lock */
 static int RTC_timer_lock;	/* RTC int lock */
 #endif
 
-static struct comedi_driver driver_pcl816 = {
-	.driver_name = "pcl816",
-	.module = THIS_MODULE,
-	.attach = pcl816_attach,
-	.detach = pcl816_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct pcl816_board),
-};
-
-static int __init driver_pcl816_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl816);
-}
-
-static void __exit driver_pcl816_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl816);
-}
-
-module_init(driver_pcl816_init_module);
-module_exit(driver_pcl816_cleanup_module);
-
 struct pcl816_private {
 
 	unsigned int dma;	/*  used DMA, 0=don't use DMA */
@@ -1108,12 +1060,6 @@ static void free_resources(struct comedi_device *dev)
 	/* printk("free_resource() end\n"); */
 }
 
-/*
-==============================================================================
-
-   Initialization
-
-*/
 static int pcl816_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int ret;
@@ -1339,10 +1285,6 @@ case COMEDI_SUBD_DO:
 	return 0;
 }
 
-/*
-==============================================================================
-  Removes device
- */
 static int pcl816_detach(struct comedi_device *dev)
 {
 	DEBUG(printk(KERN_INFO "comedi%d: pcl816: remove\n", dev->minor);)
@@ -1354,6 +1296,49 @@ static int pcl816_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct pcl816_board boardtypes[] = {
+	{"pcl816", 8, 16, 10000, 1, 16, 16, &range_pcl816,
+	 &range_pcl816, PCLx1x_RANGE,
+	 0x00fc,		/*  IRQ mask */
+	 0x0a,			/*  DMA mask */
+	 0xffff,		/*  16-bit card */
+	 0xffff,		/*  D/A maxdata */
+	 1024,
+	 1,			/*  ao chan list */
+	 100},
+	{"pcl814b", 8, 16, 10000, 1, 16, 16, &range_pcl816,
+	 &range_pcl816, PCLx1x_RANGE,
+	 0x00fc,
+	 0x0a,
+	 0x3fff,		/* 14 bit card */
+	 0x3fff,
+	 1024,
+	 1,
+	 100},
+};
+
+static struct comedi_driver driver_pcl816 = {
+	.driver_name	= "pcl816",
+	.module		= THIS_MODULE,
+	.attach		= pcl816_attach,
+	.detach		= pcl816_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct pcl816_board),
+};
+
+static int __init driver_pcl816_init_module(void)
+{
+	return comedi_driver_register(&driver_pcl816);
+}
+module_init(driver_pcl816_init_module);
+
+static void __exit driver_pcl816_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcl816);
+}
+module_exit(driver_pcl816_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
