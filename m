Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1IUJgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:36:10 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:63946 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1IUJgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:36:04 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Geoff Levand <geoff@infradead.org>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Anatolij Gustschin <agust@denx.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jiri Kosina <jkosina@suse.cz>, Archit Taneja <archit@ti.com>,
        linux-fbdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 49/57] video: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:50 +0800
Message-Id: <1316597339-29861-50-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/video/au1200fb.c                  |    2 +-
 drivers/video/bf54x-lq043fb.c             |    2 +-
 drivers/video/bfin-lq035q1-fb.c           |    2 +-
 drivers/video/bfin-t350mcqb-fb.c          |    2 +-
 drivers/video/bfin_adv7393fb.c            |    2 +-
 drivers/video/mb862xx/mb862xxfbdrv.c      |    4 ++--
 drivers/video/msm/mddi.c                  |    2 +-
 drivers/video/msm/mdp.c                   |    2 +-
 drivers/video/nuc900fb.c                  |    2 +-
 drivers/video/omap2/displays/panel-taal.c |    2 +-
 drivers/video/ps3fb.c                     |    2 +-
 drivers/video/pxa3xx-gcu.c                |    2 +-
 drivers/video/pxafb.c                     |    2 +-
 drivers/video/s3c2410fb.c                 |    2 +-
 drivers/video/sa1100fb.c                  |    3 +--
 drivers/video/sh_mobile_lcdcfb.c          |    2 +-
 drivers/video/tmiofb.c                    |    2 +-
 drivers/video/vt8500lcdfb.c               |    2 +-
 18 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
index a19a40e..7200559 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1673,7 +1673,7 @@ static int __devinit au1200fb_drv_probe(struct platform_device *dev)
 	/* Now hook interrupt too */
 	irq = platform_get_irq(dev, 0);
 	ret = request_irq(irq, au1200fb_handle_irq,
-			  IRQF_DISABLED | IRQF_SHARED, "lcd", (void *)dev);
+			  IRQF_SHARED, "lcd", (void *)dev);
 	if (ret) {
 		print_err("fail to request interrupt line %d (err: %d)",
 			  irq, ret);
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 2464b91..56720fb 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -633,7 +633,7 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 		goto out7;
 	}
 
-	if (request_irq(info->irq, bfin_bf54x_irq_error, IRQF_DISABLED,
+	if (request_irq(info->irq, bfin_bf54x_irq_error, 0,
 			"PPI ERROR", info) < 0) {
 		printk(KERN_ERR DRIVER_NAME
 		       ": unable to request PPI ERROR IRQ\n");
diff --git a/drivers/video/bfin-lq035q1-fb.c b/drivers/video/bfin-lq035q1-fb.c
index 23b6c4b..c633068 100644
--- a/drivers/video/bfin-lq035q1-fb.c
+++ b/drivers/video/bfin-lq035q1-fb.c
@@ -695,7 +695,7 @@ static int __devinit bfin_lq035q1_probe(struct platform_device *pdev)
 		goto out7;
 	}
 
-	ret = request_irq(info->irq, bfin_lq035q1_irq_error, IRQF_DISABLED,
+	ret = request_irq(info->irq, bfin_lq035q1_irq_error, 0,
 			DRIVER_NAME" PPI ERROR", info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to request PPI ERROR IRQ\n");
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index d8de29f..d5e1267 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -529,7 +529,7 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 		goto out7;
 	}
 
-	ret = request_irq(info->irq, bfin_t350mcqb_irq_error, IRQF_DISABLED,
+	ret = request_irq(info->irq, bfin_t350mcqb_irq_error, 0,
 			"PPI ERROR", info);
 	if (ret < 0) {
 		printk(KERN_ERR DRIVER_NAME
diff --git a/drivers/video/bfin_adv7393fb.c b/drivers/video/bfin_adv7393fb.c
index 8486f54..811dd7f 100644
--- a/drivers/video/bfin_adv7393fb.c
+++ b/drivers/video/bfin_adv7393fb.c
@@ -481,7 +481,7 @@ static int __devinit bfin_adv7393_fb_probe(struct i2c_client *client,
 		goto out_4;
 	}
 
-	if (request_irq(IRQ_PPI_ERROR, ppi_irq_error, IRQF_DISABLED,
+	if (request_irq(IRQ_PPI_ERROR, ppi_irq_error, 0,
 			"PPI ERROR", fbdev) < 0) {
 		dev_err(&client->dev, "unable to request PPI ERROR IRQ\n");
 		ret = -EFAULT;
diff --git a/drivers/video/mb862xx/mb862xxfbdrv.c b/drivers/video/mb862xx/mb862xxfbdrv.c
index 12a634a..11a7a33 100644
--- a/drivers/video/mb862xx/mb862xxfbdrv.c
+++ b/drivers/video/mb862xx/mb862xxfbdrv.c
@@ -738,7 +738,7 @@ static int __devinit of_platform_mb862xx_probe(struct platform_device *ofdev)
 	if (mb862xx_gdc_init(par))
 		goto io_unmap;
 
-	if (request_irq(par->irq, mb862xx_intr, IRQF_DISABLED,
+	if (request_irq(par->irq, mb862xx_intr, 0,
 			DRV_NAME, (void *)par)) {
 		dev_err(dev, "Cannot request irq\n");
 		goto io_unmap;
@@ -1074,7 +1074,7 @@ static int __devinit mb862xx_pci_probe(struct pci_dev *pdev,
 	if (mb862xx_pci_gdc_init(par))
 		goto io_unmap;
 
-	if (request_irq(par->irq, mb862xx_intr, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(par->irq, mb862xx_intr, IRQF_SHARED,
 			DRV_NAME, (void *)par)) {
 		dev_err(dev, "Cannot request irq\n");
 		goto io_unmap;
diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index 178b072..4527cbf 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -715,7 +715,7 @@ static int __devinit mddi_probe(struct platform_device *pdev)
 
 	mddi->int_enable = 0;
 	mddi_writel(mddi->int_enable, INTEN);
-	ret = request_irq(mddi->irq, mddi_isr, IRQF_DISABLED, "mddi",
+	ret = request_irq(mddi->irq, mddi_isr, 0, "mddi",
 			  &mddi->client_data);
 	if (ret) {
 		printk(KERN_ERR "mddi: failed to request enable irq!\n");
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 2750ed2..cb2ddf1 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -426,7 +426,7 @@ int mdp_probe(struct platform_device *pdev)
 		goto error_get_clk;
 	}
 
-	ret = request_irq(mdp->irq, mdp_isr, IRQF_DISABLED, "msm_mdp", mdp);
+	ret = request_irq(mdp->irq, mdp_isr, 0, "msm_mdp", mdp);
 	if (ret)
 		goto error_request_irq;
 	disable_irq(mdp->irq);
diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index 37dd850..d1fbbd8 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -587,7 +587,7 @@ static int __devinit nuc900fb_probe(struct platform_device *pdev)
 	fbinfo->flags			= FBINFO_FLAG_DEFAULT;
 	fbinfo->pseudo_palette		= &fbi->pseudo_pal;
 
-	ret = request_irq(irq, nuc900fb_irqhandler, IRQF_DISABLED,
+	ret = request_irq(irq, nuc900fb_irqhandler, 0,
 			  pdev->name, fbinfo);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register irq handler %d -err %d\n",
diff --git a/drivers/video/omap2/displays/panel-taal.c b/drivers/video/omap2/displays/panel-taal.c
index ddc696d..20d9968 100644
--- a/drivers/video/omap2/displays/panel-taal.c
+++ b/drivers/video/omap2/displays/panel-taal.c
@@ -1053,7 +1053,7 @@ static int taal_probe(struct omap_dss_device *dssdev)
 		gpio_direction_input(gpio);
 
 		r = request_irq(gpio_to_irq(gpio), taal_te_isr,
-				IRQF_DISABLED | IRQF_TRIGGER_RISING,
+				IRQF_TRIGGER_RISING,
 				"taal vsync", dssdev);
 
 		if (r) {
diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index 65560a1..213fbbc 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -1082,7 +1082,7 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 	}
 
 	retval = request_irq(ps3fb.irq_no, ps3fb_vsync_interrupt,
-			     IRQF_DISABLED, DEVICE_NAME, &dev->core);
+			     0, DEVICE_NAME, &dev->core);
 	if (retval) {
 		dev_err(&dev->core, "%s: request_irq failed %d\n", __func__,
 			retval);
diff --git a/drivers/video/pxa3xx-gcu.c b/drivers/video/pxa3xx-gcu.c
index d8de557..1ed8b36 100644
--- a/drivers/video/pxa3xx-gcu.c
+++ b/drivers/video/pxa3xx-gcu.c
@@ -676,7 +676,7 @@ pxa3xx_gcu_probe(struct platform_device *dev)
 	}
 
 	ret = request_irq(irq, pxa3xx_gcu_handle_irq,
-			  IRQF_DISABLED, DRV_NAME, priv);
+			  0, DRV_NAME, priv);
 	if (ret) {
 		dev_err(&dev->dev, "request_irq failed\n");
 		ret = -EBUSY;
diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 0f4e8c9..e89778f 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -2191,7 +2191,7 @@ static int __devinit pxafb_probe(struct platform_device *dev)
 		goto failed_free_mem;
 	}
 
-	ret = request_irq(irq, pxafb_handle_irq, IRQF_DISABLED, "LCD", fbi);
+	ret = request_irq(irq, pxafb_handle_irq, 0, "LCD", fbi);
 	if (ret) {
 		dev_err(&dev->dev, "request_irq failed: %d\n", ret);
 		ret = -EBUSY;
diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index 798144a..ee4c0df 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -910,7 +910,7 @@ static int __devinit s3c24xxfb_probe(struct platform_device *pdev,
 	for (i = 0; i < 256; i++)
 		info->palette_buffer[i] = PALETTE_BUFF_CLEAR;
 
-	ret = request_irq(irq, s3c2410fb_irq, IRQF_DISABLED, pdev->name, info);
+	ret = request_irq(irq, s3c2410fb_irq, 0, pdev->name, info);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot get irq %d - err %d\n", irq, ret);
 		ret = -EBUSY;
diff --git a/drivers/video/sa1100fb.c b/drivers/video/sa1100fb.c
index e8b76d6..98d55d0 100644
--- a/drivers/video/sa1100fb.c
+++ b/drivers/video/sa1100fb.c
@@ -1457,8 +1457,7 @@ static int __devinit sa1100fb_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed;
 
-	ret = request_irq(irq, sa1100fb_handle_irq, IRQF_DISABLED,
-			  "LCD", fbi);
+	ret = request_irq(irq, sa1100fb_handle_irq, 0, "LCD", fbi);
 	if (ret) {
 		printk(KERN_ERR "sa1100fb: request_irq failed: %d\n", ret);
 		goto failed;
diff --git a/drivers/video/sh_mobile_lcdcfb.c b/drivers/video/sh_mobile_lcdcfb.c
index 4636f9d..facffc2 100644
--- a/drivers/video/sh_mobile_lcdcfb.c
+++ b/drivers/video/sh_mobile_lcdcfb.c
@@ -1577,7 +1577,7 @@ static int __devinit sh_mobile_lcdc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, priv);
 
-	error = request_irq(i, sh_mobile_lcdc_irq, IRQF_DISABLED,
+	error = request_irq(i, sh_mobile_lcdc_irq, 0,
 			    dev_name(&pdev->dev), priv);
 	if (error) {
 		dev_err(&pdev->dev, "unable to request irq\n");
diff --git a/drivers/video/tmiofb.c b/drivers/video/tmiofb.c
index cd1c4dc..8e4a446 100644
--- a/drivers/video/tmiofb.c
+++ b/drivers/video/tmiofb.c
@@ -744,7 +744,7 @@ static int __devinit tmiofb_probe(struct platform_device *dev)
 		goto err_ioremap_vram;
 	}
 
-	retval = request_irq(irq, &tmiofb_irq, IRQF_DISABLED,
+	retval = request_irq(irq, &tmiofb_irq, 0,
 					dev_name(&dev->dev), info);
 
 	if (retval)
diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index c13c246..777c21d 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -355,7 +355,7 @@ static int __devinit vt8500lcd_probe(struct platform_device *pdev)
 		goto failed_free_palette;
 	}
 
-	ret = request_irq(irq, vt8500lcd_handle_irq, IRQF_DISABLED, "LCD", fbi);
+	ret = request_irq(irq, vt8500lcd_handle_irq, 0, "LCD", fbi);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed: %d\n", ret);
 		ret = -EBUSY;
-- 
1.7.4.1

