Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1JVKLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:11:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57970 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab1JVKLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:11:05 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 29/49] dmaengine: irq: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:56:41 +0800
Message-Id: <1319277421-9203-30-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |    2 +-
 drivers/dma/coh901318.c  |    2 +-
 drivers/dma/shdma.c      |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index b7cbd1a..896a119 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1919,7 +1919,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	writel(0x000000FF, pl08x->base + PL080_ERR_CLEAR);
 	writel(0x000000FF, pl08x->base + PL080_TC_CLEAR);
 
-	ret = request_irq(adev->irq[0], pl08x_irq, IRQF_DISABLED,
+	ret = request_irq(adev->irq[0], pl08x_irq, 0,
 			  DRIVER_NAME, pl08x);
 	if (ret) {
 		dev_err(&adev->dev, "%s failed to request interrupt %d\n",
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 4234f41..1dd9455 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1506,7 +1506,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	if (irq < 0)
 		goto err_no_irq;
 
-	err = request_irq(irq, dma_irq_handler, IRQF_DISABLED,
+	err = request_irq(irq, dma_irq_handler, 0,
 			  "coh901318", base);
 	if (err) {
 		dev_crit(&pdev->dev,
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 81809c2..e5c47c3 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -1149,7 +1149,7 @@ static void sh_dmae_chan_remove(struct sh_dmae_device *shdev)
 static int __init sh_dmae_probe(struct platform_device *pdev)
 {
 	struct sh_dmae_pdata *pdata = pdev->dev.platform_data;
-	unsigned long irqflags = IRQF_DISABLED,
+	unsigned long irqflags = 0,
 		chan_flag[SH_DMAC_MAX_CHANNELS] = {};
 	int errirq, chan_irq[SH_DMAC_MAX_CHANNELS];
 	int err, i, irq_cnt = 0, irqres = 0, irq_cap = 0;
@@ -1309,7 +1309,7 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 				    IORESOURCE_IRQ_SHAREABLE)
 					chan_flag[irq_cnt] = IRQF_SHARED;
 				else
-					chan_flag[irq_cnt] = IRQF_DISABLED;
+					chan_flag[irq_cnt] = 0;
 				dev_dbg(&pdev->dev,
 					"Found IRQ %d for channel %d\n",
 					i, irq_cnt);
-- 
1.7.1

