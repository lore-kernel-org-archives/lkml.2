Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1JIFrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 01:47:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51383 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1JIFrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 01:47:19 -0400
From: Michael Opdenacker <michael.opdenacker@linaro.org>
To: tony@atomide.com, linux@arm.linux.org.uk, khilman@ti.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        Michael Opdenacker <michael.opdenacker@linaro.org>
Subject: [PATCH 1/1] arm: omap: removed obsolete IRQF_DISABLED
Date: Sun,  9 Oct 2011 07:46:38 +0200
Message-Id: <1318139198-6865-2-git-send-email-michael.opdenacker@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318139198-6865-1-git-send-email-michael.opdenacker@linaro.org>
References: <1318139198-6865-1-git-send-email-michael.opdenacker@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP since 2.6.36

Signed-off-by: Michael Opdenacker <michael.opdenacker@linaro.org>
---
 arch/arm/mach-omap1/fpga.c        |    5 ++---
 arch/arm/mach-omap1/pm.c          |    1 -
 arch/arm/mach-omap1/time.c        |    2 +-
 arch/arm/mach-omap1/timer32k.c    |    2 +-
 arch/arm/mach-omap2/omap_l3_noc.c |    4 ++--
 arch/arm/mach-omap2/omap_l3_smx.c |    4 ++--
 arch/arm/mach-omap2/pm34xx.c      |    2 +-
 arch/arm/mach-omap2/timer.c       |    2 +-
 arch/arm/plat-omap/dma.c          |    1 -
 9 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap1/fpga.c b/arch/arm/mach-omap1/fpga.c
index cddbf8b..3786b35 100644
--- a/arch/arm/mach-omap1/fpga.c
+++ b/arch/arm/mach-omap1/fpga.c
@@ -131,9 +131,8 @@ static struct irq_chip omap_fpga_irq = {
  * In an attempt to workaround the problem with missed interrupts, the
  * mask_ack routine for all of the FPGA interrupts has been changed from
  * fpga_mask_ack_irq() to fpga_ack_irq() so that the specific FPGA interrupt
- * being serviced is left unmasked.  We can do this because the FPGA cascade
- * interrupt is installed with the IRQF_DISABLED flag, which leaves all
- * interrupts masked at the CPU while an FPGA interrupt handler executes.
+ * being serviced is left unmasked.  We can do this because all the interrupts
+ * are masked at the CPU while an FPGA interrupt handler executes.
  *
  * Limited testing indicates that this workaround appears to be effective
  * for the smc9194 Ethernet driver used on the Innovator.  It should work
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 6badc29..f842ff2 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -641,7 +641,6 @@ static irqreturn_t omap_wakeup_interrupt(int irq, void *dev)
 
 static struct irqaction omap_wakeup_irq = {
 	.name		= "peripheral wakeup",
-	.flags		= IRQF_DISABLED,
 	.handler	= omap_wakeup_interrupt
 };
 
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index a183777..a35b4d2 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -163,7 +163,7 @@ static irqreturn_t omap_mpu_timer1_interrupt(int irq, void *dev_id)
 
 static struct irqaction omap_mpu_timer1_irq = {
 	.name		= "mpu_timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap_mpu_timer1_interrupt,
 };
 
diff --git a/arch/arm/mach-omap1/timer32k.c b/arch/arm/mach-omap1/timer32k.c
index 96604a5..db08fd4 100644
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -155,7 +155,7 @@ static irqreturn_t omap_32k_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction omap_32k_timer_irq = {
 	.name		= "32KHz timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap_32k_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-omap2/omap_l3_noc.c b/arch/arm/mach-omap2/omap_l3_noc.c
index c8b1bef..a679437 100644
--- a/arch/arm/mach-omap2/omap_l3_noc.c
+++ b/arch/arm/mach-omap2/omap_l3_noc.c
@@ -186,7 +186,7 @@ static int __devinit omap4_l3_probe(struct platform_device *pdev)
 	l3->debug_irq = platform_get_irq(pdev, 0);
 	ret = request_irq(l3->debug_irq,
 			l3_interrupt_handler,
-			IRQF_DISABLED, "l3-dbg-irq", l3);
+			0, "l3-dbg-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						OMAP44XX_IRQ_L3_DBG);
@@ -196,7 +196,7 @@ static int __devinit omap4_l3_probe(struct platform_device *pdev)
 	l3->app_irq = platform_get_irq(pdev, 1);
 	ret = request_irq(l3->app_irq,
 			l3_interrupt_handler,
-			IRQF_DISABLED, "l3-app-irq", l3);
+			0, "l3-app-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						OMAP44XX_IRQ_L3_APP);
diff --git a/arch/arm/mach-omap2/omap_l3_smx.c b/arch/arm/mach-omap2/omap_l3_smx.c
index a05a62f..c1c33bf 100644
--- a/arch/arm/mach-omap2/omap_l3_smx.c
+++ b/arch/arm/mach-omap2/omap_l3_smx.c
@@ -237,7 +237,7 @@ static int __init omap3_l3_probe(struct platform_device *pdev)
 
 	l3->debug_irq = platform_get_irq(pdev, 0);
 	ret = request_irq(l3->debug_irq, omap3_l3_app_irq,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING,
+		IRQF_TRIGGER_RISING,
 		"l3-debug-irq", l3);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't request debug irq\n");
@@ -246,7 +246,7 @@ static int __init omap3_l3_probe(struct platform_device *pdev)
 
 	l3->app_irq = platform_get_irq(pdev, 1);
 	ret = request_irq(l3->app_irq, omap3_l3_app_irq,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING,
+		IRQF_TRIGGER_RISING,
 		"l3-app-irq", l3);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't request app irq\n");
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index c8cbd00..ea5b37a 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -878,7 +878,7 @@ static int __init omap3_pm_init(void)
 
 	ret = request_irq(INT_34XX_PRCM_MPU_IRQ,
 			  (irq_handler_t)prcm_interrupt_handler,
-			  IRQF_DISABLED, "prcm", NULL);
+			  0, "prcm", NULL);
 	if (ret) {
 		printk(KERN_ERR "request_irq failed to register for 0x%x\n",
 		       INT_34XX_PRCM_MPU_IRQ);
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 037b0d7..2bc303c 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -91,7 +91,7 @@ static irqreturn_t omap2_gp_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction omap2_gp_timer_irq = {
 	.name		= "gp timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap2_gp_timer_interrupt,
 };
 
diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index c22217c..f51e18e 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -1928,7 +1928,6 @@ static irqreturn_t omap2_dma_irq_handler(int irq, void *dev_id)
 static struct irqaction omap24xx_dma_irq = {
 	.name = "DMA",
 	.handler = omap2_dma_irq_handler,
-	.flags = IRQF_DISABLED
 };
 
 #else
-- 
1.7.4.1

