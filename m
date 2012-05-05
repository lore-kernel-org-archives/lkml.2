Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730Ab2EEACo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 20:02:44 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:61052 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab2EEACn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 20:02:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1336176162!4828411!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor dt282x driver to remove forward declarations
Date: Fri, 4 May 2012 17:02:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041702.38679.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver and variables to the end of the
source. This is more typical of how other drivers are written and
removes the need for the forward declarations.

Convert the driver to use the module_comedi_driver() macro which
makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 210b3f0..461a056 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -221,135 +221,6 @@ struct dt282x_board {
 	int dabits;
 };
 
-static const struct dt282x_board boardtypes[] = {
-	{.name = "dt2821",
-	 .adbits = 12,
-	 .adchan_se = 16,
-	 .adchan_di = 8,
-	 .ai_speed = 20000,
-	 .ispgl = 0,
-	 .dachan = 2,
-	 .dabits = 12,
-	 },
-	{.name = "dt2821-f",
-	 .adbits = 12,
-	 .adchan_se = 16,
-	 .adchan_di = 8,
-	 .ai_speed = 6500,
-	 .ispgl = 0,
-	 .dachan = 2,
-	 .dabits = 12,
-	 },
-	{.name = "dt2821-g",
-	 .adbits = 12,
-	 .adchan_se = 16,
-	 .adchan_di = 8,
-	 .ai_speed = 4000,
-	 .ispgl = 0,
-	 .dachan = 2,
-	 .dabits = 12,
-	 },
-	{.name = "dt2823",
-	 .adbits = 16,
-	 .adchan_se = 0,
-	 .adchan_di = 4,
-	 .ai_speed = 10000,
-	 .ispgl = 0,
-	 .dachan = 2,
-	 .dabits = 16,
-	 },
-	{.name = "dt2824-pgh",
-	 .adbits = 12,
-	 .adchan_se = 16,
-	 .adchan_di = 8,
-	 .ai_speed = 20000,
-	 .ispgl = 0,
-	 .dachan = 0,
-	 .dabits = 0,
-	 },
-	{.name = "dt2824-pgl",
-	 .adbits = 12,
-	 .adchan_se = 16,
-	 .adchan_di = 8,
-	 .ai_speed = 20000,
-	 .ispgl = 1,
-	 .dachan = 0,
-	 .dabits = 0,
-	 },
-	{.name = "dt2825",
-	 .adbits = 12,
-	 .adchan_se = 16,
-	 .adchan_di = 8,
-	 .ai_speed = 20000,
-	 .ispgl = 1,
-	 .dachan = 2,
-	 .dabits = 12,
-	 },
-	{.name = "dt2827",
-	 .adbits = 16,
-	 .adchan_se = 0,
-	 .adchan_di = 4,
-	 .ai_speed = 10000,
-	 .ispgl = 0,
-	 .dachan = 2,
-	 .dabits = 12,
-	 },
-	{.name = "dt2828",
-	 .adbits = 12,
-	 .adchan_se = 4,
-	 .adchan_di = 0,
-	 .ai_speed = 10000,
-	 .ispgl = 0,
-	 .dachan = 2,
-	 .dabits = 12,
-	 },
-	{.name = "dt2829",
-	 .adbits = 16,
-	 .adchan_se = 8,
-	 .adchan_di = 0,
-	 .ai_speed = 33250,
-	 .ispgl = 0,
-	 .dachan = 2,
-	 .dabits = 16,
-	 },
-	{.name = "dt21-ez",
-	 .adbits = 12,
-	 .adchan_se = 16,
-	 .adchan_di = 8,
-	 .ai_speed = 10000,
-	 .ispgl = 0,
-	 .dachan = 2,
-	 .dabits = 12,
-	 },
-	{.name = "dt23-ez",
-	 .adbits = 16,
-	 .adchan_se = 16,
-	 .adchan_di = 8,
-	 .ai_speed = 10000,
-	 .ispgl = 0,
-	 .dachan = 0,
-	 .dabits = 0,
-	 },
-	{.name = "dt24-ez",
-	 .adbits = 12,
-	 .adchan_se = 16,
-	 .adchan_di = 8,
-	 .ai_speed = 10000,
-	 .ispgl = 0,
-	 .dachan = 0,
-	 .dabits = 0,
-	 },
-	{.name = "dt24-ez-pgl",
-	 .adbits = 12,
-	 .adchan_se = 16,
-	 .adchan_di = 8,
-	 .ai_speed = 10000,
-	 .ispgl = 1,
-	 .dachan = 0,
-	 .dabits = 0,
-	 },
-};
-
 #define this_board ((const struct dt282x_board *)dev->board_ptr)
 
 struct dt282x_private {
@@ -410,33 +281,6 @@ struct dt282x_private {
 			b					\
 	} while (0)
 
-static int dt282x_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int dt282x_detach(struct comedi_device *dev);
-static struct comedi_driver driver_dt282x = {
-	.driver_name = "dt282x",
-	.module = THIS_MODULE,
-	.attach = dt282x_attach,
-	.detach = dt282x_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct dt282x_board),
-};
-
-static int __init driver_dt282x_init_module(void)
-{
-	return comedi_driver_register(&driver_dt282x);
-}
-
-static void __exit driver_dt282x_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_dt282x);
-}
-
-module_init(driver_dt282x_init_module);
-module_exit(driver_dt282x_cleanup_module);
-
-static void free_resources(struct comedi_device *dev);
 static int prep_ai_dma(struct comedi_device *dev, int chan, int size);
 static int prep_ao_dma(struct comedi_device *dev, int chan, int size);
 static int dt282x_ai_cancel(struct comedi_device *dev,
@@ -1270,6 +1114,52 @@ enum {  /* i/o base, irq, dma channels */
 	opt_ai_range, opt_ao0_range, opt_ao1_range,	/* range */
 };
 
+static int dt282x_grab_dma(struct comedi_device *dev, int dma1, int dma2)
+{
+	int ret;
+
+	devpriv->usedma = 0;
+
+	if (!dma1 && !dma2) {
+		printk(KERN_ERR " (no dma)");
+		return 0;
+	}
+
+	if (dma1 == dma2 || dma1 < 5 || dma2 < 5 || dma1 > 7 || dma2 > 7)
+		return -EINVAL;
+
+	if (dma2 < dma1) {
+		int i;
+		i = dma1;
+		dma1 = dma2;
+		dma2 = i;
+	}
+
+	ret = request_dma(dma1, "dt282x A");
+	if (ret)
+		return -EBUSY;
+	devpriv->dma[0].chan = dma1;
+
+	ret = request_dma(dma2, "dt282x B");
+	if (ret)
+		return -EBUSY;
+	devpriv->dma[1].chan = dma2;
+
+	devpriv->dma_maxsize = PAGE_SIZE;
+	devpriv->dma[0].buf = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	devpriv->dma[1].buf = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	if (!devpriv->dma[0].buf || !devpriv->dma[1].buf) {
+		printk(KERN_ERR " can't get DMA memory");
+		return -ENOMEM;
+	}
+
+	printk(KERN_INFO " (dma=%d,%d)", dma1, dma2);
+
+	devpriv->usedma = 1;
+
+	return 0;
+}
+
 /*
    options:
    0	i/o base
@@ -1468,51 +1358,146 @@ static int dt282x_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static int dt282x_grab_dma(struct comedi_device *dev, int dma1, int dma2)
-{
-	int ret;
-
-	devpriv->usedma = 0;
-
-	if (!dma1 && !dma2) {
-		printk(KERN_ERR " (no dma)");
-		return 0;
-	}
-
-	if (dma1 == dma2 || dma1 < 5 || dma2 < 5 || dma1 > 7 || dma2 > 7)
-		return -EINVAL;
-
-	if (dma2 < dma1) {
-		int i;
-		i = dma1;
-		dma1 = dma2;
-		dma2 = i;
-	}
-
-	ret = request_dma(dma1, "dt282x A");
-	if (ret)
-		return -EBUSY;
-	devpriv->dma[0].chan = dma1;
-
-	ret = request_dma(dma2, "dt282x B");
-	if (ret)
-		return -EBUSY;
-	devpriv->dma[1].chan = dma2;
-
-	devpriv->dma_maxsize = PAGE_SIZE;
-	devpriv->dma[0].buf = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
-	devpriv->dma[1].buf = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
-	if (!devpriv->dma[0].buf || !devpriv->dma[1].buf) {
-		printk(KERN_ERR " can't get DMA memory");
-		return -ENOMEM;
-	}
-
-	printk(KERN_INFO " (dma=%d,%d)", dma1, dma2);
-
-	devpriv->usedma = 1;
+static const struct dt282x_board boardtypes[] = {
+	{
+		.name		= "dt2821",
+		.adbits		= 12,
+		.adchan_se	= 16,
+		.adchan_di	= 8,
+		.ai_speed	= 20000,
+		.ispgl		= 0,
+		.dachan		= 2,
+		.dabits		= 12,
+	}, {
+		.name		= "dt2821-f",
+		.adbits		= 12,
+		.adchan_se	= 16,
+		.adchan_di	= 8,
+		.ai_speed	= 6500,
+		.ispgl		= 0,
+		.dachan		= 2,
+		.dabits		= 12,
+	}, {
+		.name		= "dt2821-g",
+		.adbits		= 12,
+		.adchan_se	= 16,
+		.adchan_di	= 8,
+		.ai_speed	= 4000,
+		.ispgl		= 0,
+		.dachan		= 2,
+		.dabits		= 12,
+	}, {
+		.name		= "dt2823",
+		.adbits		= 16,
+		.adchan_se	= 0,
+		.adchan_di	= 4,
+		.ai_speed	= 10000,
+		.ispgl		= 0,
+		.dachan		= 2,
+		.dabits		= 16,
+	}, {
+		.name		= "dt2824-pgh",
+		.adbits		= 12,
+		.adchan_se	= 16,
+		.adchan_di	= 8,
+		.ai_speed	= 20000,
+		.ispgl		= 0,
+		.dachan		= 0,
+		.dabits		= 0,
+	}, {
+		.name		= "dt2824-pgl",
+		.adbits		= 12,
+		.adchan_se	= 16,
+		.adchan_di	= 8,
+		.ai_speed	= 20000,
+		.ispgl		= 1,
+		.dachan		= 0,
+		.dabits		= 0,
+	}, {
+		.name		= "dt2825",
+		.adbits		= 12,
+		.adchan_se	= 16,
+		.adchan_di	= 8,
+		.ai_speed	= 20000,
+		.ispgl		= 1,
+		.dachan		= 2,
+		.dabits		= 12,
+	}, {
+		.name		= "dt2827",
+		.adbits		= 16,
+		.adchan_se	= 0,
+		.adchan_di	= 4,
+		.ai_speed	= 10000,
+		.ispgl		= 0,
+		.dachan		= 2,
+		.dabits		= 12,
+	}, {
+		.name		= "dt2828",
+		.adbits		= 12,
+		.adchan_se	= 4,
+		.adchan_di	= 0,
+		.ai_speed	= 10000,
+		.ispgl		= 0,
+		.dachan		= 2,
+		.dabits		= 12,
+	}, {
+		.name		= "dt2829",
+		.adbits		= 16,
+		.adchan_se	= 8,
+		.adchan_di	= 0,
+		.ai_speed	= 33250,
+		.ispgl		= 0,
+		.dachan		= 2,
+		.dabits		= 16,
+	}, {
+		.name		= "dt21-ez",
+		.adbits		= 12,
+		.adchan_se	= 16,
+		.adchan_di	= 8,
+		.ai_speed	= 10000,
+		.ispgl		= 0,
+		.dachan		= 2,
+		.dabits		= 12,
+	}, {
+		.name		= "dt23-ez",
+		.adbits		= 16,
+		.adchan_se	= 16,
+		.adchan_di	= 8,
+		.ai_speed	= 10000,
+		.ispgl		= 0,
+		.dachan		= 0,
+		.dabits		= 0,
+	}, {
+		.name		= "dt24-ez",
+		.adbits		= 12,
+		.adchan_se	= 16,
+		.adchan_di	= 8,
+		.ai_speed	= 10000,
+		.ispgl		= 0,
+		.dachan		= 0,
+		.dabits		= 0,
+	}, {
+		.name		= "dt24-ez-pgl",
+		.adbits		= 12,
+		.adchan_se	= 16,
+		.adchan_di	= 8,
+		.ai_speed	= 10000,
+		.ispgl		= 1,
+		.dachan		= 0,
+		.dabits		= 0,
+	},
+};
 
-	return 0;
-}
+static struct comedi_driver dt282x_driver = {
+	.driver_name	= "dt282x",
+	.module		= THIS_MODULE,
+	.attach		= dt282x_attach,
+	.detach		= dt282x_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct dt282x_board),
+};
+module_comedi_driver(dt282x_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
