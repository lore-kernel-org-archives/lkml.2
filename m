Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1CYNWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:34716 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752913Ab1CYNWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:35 -0400
Message-Id: <20110325132049.584376140@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 23/23] arm: Fold irq_set_chip/irq_set_handler
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-fold-chip-handler.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use irq_set_chip_and_handler() instead. Converted with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/common/gic.c                    |    3 +--
 arch/arm/common/it8152.c                 |    4 ++--
 arch/arm/common/locomo.c                 |    3 +--
 arch/arm/common/sa1111.c                 |    8 ++++----
 arch/arm/common/vic.c                    |    4 ++--
 arch/arm/kernel/ecard.c                  |    4 ++--
 arch/arm/mach-at91/gpio.c                |    4 ++--
 arch/arm/mach-at91/irq.c                 |    3 +--
 arch/arm/mach-clps711x/irq.c             |    8 ++++----
 arch/arm/mach-dove/irq.c                 |    3 +--
 arch/arm/mach-ebsa110/core.c             |    4 ++--
 arch/arm/mach-ep93xx/gpio.c              |    4 ++--
 arch/arm/mach-exynos4/irq-combiner.c     |    3 +--
 arch/arm/mach-exynos4/irq-eint.c         |    4 ++--
 arch/arm/mach-footbridge/common.c        |    3 +--
 arch/arm/mach-footbridge/isa-irq.c       |    8 ++++----
 arch/arm/mach-gemini/gpio.c              |    4 ++--
 arch/arm/mach-h720x/common.c             |   12 ++++++------
 arch/arm/mach-h720x/cpu-h7202.c          |    4 ++--
 arch/arm/mach-integrator/integrator_ap.c |    4 ++--
 arch/arm/mach-integrator/integrator_cp.c |    9 +++------
 arch/arm/mach-iop32x/irq.c               |    3 +--
 arch/arm/mach-iop33x/irq.c               |    6 +++---
 arch/arm/mach-ixp2000/core.c             |   16 ++++++++--------
 arch/arm/mach-ixp2000/ixdp2x00.c         |    4 ++--
 arch/arm/mach-ixp2000/ixdp2x01.c         |    4 ++--
 arch/arm/mach-ixp23xx/core.c             |   12 ++++++------
 arch/arm/mach-ixp23xx/ixdp2351.c         |    8 ++++----
 arch/arm/mach-ixp4xx/common.c            |    4 ++--
 arch/arm/mach-ks8695/irq.c               |   18 ++++++++++--------
 arch/arm/mach-lpc32xx/irq.c              |    4 ++--
 arch/arm/mach-mmp/irq-pxa168.c           |    3 +--
 arch/arm/mach-msm/board-trout-gpio.c     |    4 ++--
 arch/arm/mach-msm/gpio-v2.c              |    4 ++--
 arch/arm/mach-msm/gpio.c                 |    4 ++--
 arch/arm/mach-msm/irq-vic.c              |    3 +--
 arch/arm/mach-msm/irq.c                  |    3 +--
 arch/arm/mach-msm/sirc.c                 |    3 +--
 arch/arm/mach-mx3/mach-mx31ads.c         |    3 +--
 arch/arm/mach-mxs/gpio.c                 |    4 ++--
 arch/arm/mach-mxs/icoll.c                |    3 +--
 arch/arm/mach-netx/generic.c             |    4 ++--
 arch/arm/mach-ns9xxx/board-a9m9750dev.c  |    4 ++--
 arch/arm/mach-nuc93x/irq.c               |    4 ++--
 arch/arm/mach-omap1/irq.c                |    4 ++--
 arch/arm/mach-omap2/irq.c                |    3 +--
 arch/arm/mach-pxa/balloon3.c             |    4 ++--
 arch/arm/mach-pxa/irq.c                  |    8 ++++----
 arch/arm/mach-pxa/lpd270.c               |    4 ++--
 arch/arm/mach-pxa/lubbock.c              |    4 ++--
 arch/arm/mach-pxa/mainstone.c            |    4 ++--
 arch/arm/mach-pxa/pcm990-baseboard.c     |    4 ++--
 arch/arm/mach-pxa/pxa3xx.c               |    4 ++--
 arch/arm/mach-pxa/viper.c                |    4 ++--
 arch/arm/mach-pxa/zeus.c                 |    4 ++--
 arch/arm/mach-rpc/irq.c                  |   12 ++++++------
 arch/arm/mach-s3c2410/bast-irq.c         |    4 ++--
 arch/arm/mach-s3c2412/irq.c              |    8 ++++----
 arch/arm/mach-s3c2416/irq.c              |    6 ++----
 arch/arm/mach-s3c2440/irq.c              |    8 ++++----
 arch/arm/mach-s3c2440/s3c244x-irq.c      |   12 ++++++------
 arch/arm/mach-s3c2443/irq.c              |    6 ++----
 arch/arm/mach-s3c64xx/irq-eint.c         |    3 +--
 arch/arm/mach-sa1100/irq.c               |   12 ++++++------
 arch/arm/mach-shark/irq.c                |    3 +--
 arch/arm/mach-tegra/gpio.c               |    4 ++--
 arch/arm/mach-tegra/irq.c                |    3 +--
 arch/arm/mach-ux500/modem-irq-db5500.c   |    3 +--
 arch/arm/mach-versatile/core.c           |    4 ++--
 arch/arm/mach-vt8500/irq.c               |    8 ++++----
 arch/arm/mach-w90x900/irq.c              |    4 ++--
 arch/arm/plat-mxc/3ds_debugboard.c       |    3 +--
 arch/arm/plat-mxc/avic.c                 |    4 ++--
 arch/arm/plat-mxc/gpio.c                 |    4 ++--
 arch/arm/plat-mxc/tzic.c                 |    4 ++--
 arch/arm/plat-nomadik/gpio.c             |    4 ++--
 arch/arm/plat-orion/gpio.c               |    4 ++--
 arch/arm/plat-orion/irq.c                |    4 ++--
 arch/arm/plat-pxa/gpio.c                 |    4 ++--
 arch/arm/plat-s3c24xx/irq.c              |   31 +++++++++++++++----------------
 arch/arm/plat-s5p/irq-eint.c             |    3 +--
 arch/arm/plat-samsung/irq-uart.c         |    3 +--
 arch/arm/plat-spear/shirq.c              |    4 ++--
 arch/arm/plat-stmp3xxx/irq.c             |    3 +--
 arch/arm/plat-stmp3xxx/pinmux.c          |    4 ++--
 85 files changed, 213 insertions(+), 241 deletions(-)

Index: linux-2.6-tip/arch/arm/common/gic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/gic.c
+++ linux-2.6-tip/arch/arm/common/gic.c
@@ -319,8 +319,7 @@ static void __init gic_dist_init(struct 
 	 * Setup the Linux IRQ subsystem.
 	 */
 	for (i = irq_start; i < irq_limit; i++) {
-		irq_set_chip(i, &gic_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &gic_chip, handle_level_irq);
 		irq_set_chip_data(i, gic);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
Index: linux-2.6-tip/arch/arm/common/it8152.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/it8152.c
+++ linux-2.6-tip/arch/arm/common/it8152.c
@@ -88,8 +88,8 @@ void it8152_init_irq(void)
 	__raw_writel((0), IT8152_INTC_LDCNIRR);
 
 	for (irq = IT8152_IRQ(0); irq <= IT8152_LAST_IRQ; irq++) {
-		irq_set_chip(irq, &it8152_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &it8152_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/common/locomo.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/locomo.c
+++ linux-2.6-tip/arch/arm/common/locomo.c
@@ -203,8 +203,7 @@ static void locomo_setup_irq(struct loco
 
 	/* Install handlers for IRQ_LOCOMO_* */
 	for ( ; irq <= lchip->irq_base + 3; irq++) {
-		irq_set_chip(irq, &locomo_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &locomo_chip, handle_level_irq);
 		irq_set_chip_data(irq, lchip);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
Index: linux-2.6-tip/arch/arm/common/sa1111.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/sa1111.c
+++ linux-2.6-tip/arch/arm/common/sa1111.c
@@ -472,15 +472,15 @@ static void sa1111_setup_irq(struct sa11
 	sa1111_writel(~0, irqbase + SA1111_INTSTATCLR1);
 
 	for (irq = IRQ_GPAIN0; irq <= SSPROR; irq++) {
-		irq_set_chip(irq, &sa1111_low_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &sa1111_low_chip,
+					 handle_edge_irq);
 		irq_set_chip_data(irq, sachip);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	for (irq = AUDXMTDMADONEA; irq <= IRQ_S1_BVD1_STSCHG; irq++) {
-		irq_set_chip(irq, &sa1111_high_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &sa1111_high_chip,
+					 handle_edge_irq);
 		irq_set_chip_data(irq, sachip);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
Index: linux-2.6-tip/arch/arm/common/vic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/vic.c
+++ linux-2.6-tip/arch/arm/common/vic.c
@@ -305,8 +305,8 @@ static void __init vic_set_irq_sources(v
 		if (vic_sources & (1 << i)) {
 			unsigned int irq = irq_start + i;
 
-			irq_set_chip(irq, &vic_chip);
-			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_and_handler(irq, &vic_chip,
+						 handle_level_irq);
 			irq_set_chip_data(irq, base);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
Index: linux-2.6-tip/arch/arm/kernel/ecard.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/kernel/ecard.c
+++ linux-2.6-tip/arch/arm/kernel/ecard.c
@@ -1043,8 +1043,8 @@ ecard_probe(int slot, card_type_t type)
 	 */
 	if (slot < 8) {
 		ec->irq = 32 + slot;
-		irq_set_chip(ec->irq, &ecard_chip);
-		irq_set_handler(ec->irq, handle_level_irq);
+		irq_set_chip_and_handler(ec->irq, &ecard_chip,
+					 handle_level_irq);
 		set_irq_flags(ec->irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-at91/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-at91/gpio.c
+++ linux-2.6-tip/arch/arm/mach-at91/gpio.c
@@ -511,8 +511,8 @@ void __init at91_gpio_irq_setup(void)
 			 * Can use the "simple" and not "edge" handler since it's
 			 * shorter, and the AIC handles interrupts sanely.
 			 */
-			irq_set_chip(pin, &gpio_irqchip);
-			irq_set_handler(pin, handle_simple_irq);
+			irq_set_chip_and_handler(pin, &gpio_irqchip,
+						 handle_simple_irq);
 			set_irq_flags(pin, IRQF_VALID);
 		}
 
Index: linux-2.6-tip/arch/arm/mach-at91/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-at91/irq.c
+++ linux-2.6-tip/arch/arm/mach-at91/irq.c
@@ -143,8 +143,7 @@ void __init at91_aic_init(unsigned int p
 		/* Active Low interrupt, with the specified priority */
 		at91_sys_write(AT91_AIC_SMR(i), AT91_AIC_SRCTYPE_LOW | priority[i]);
 
-		irq_set_chip(i, &at91_aic_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &at91_aic_chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 
 		/* Perform 8 End Of Interrupt Command to make sure AIC will not Lock out nIRQ */
Index: linux-2.6-tip/arch/arm/mach-clps711x/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-clps711x/irq.c
+++ linux-2.6-tip/arch/arm/mach-clps711x/irq.c
@@ -112,13 +112,13 @@ void __init clps711x_init_irq(void)
 
 	for (i = 0; i < NR_IRQS; i++) {
 	        if (INT1_IRQS & (1 << i)) {
-	        	irq_set_handler(i, handle_level_irq);
-	        	irq_set_chip(i, &int1_chip);
+	        	irq_set_chip_and_handler(i, &int1_chip,
+						 handle_level_irq);
 	        	set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 		}
 		if (INT2_IRQS & (1 << i)) {
-			irq_set_handler(i, handle_level_irq);
-			irq_set_chip(i, &int2_chip);
+			irq_set_chip_and_handler(i, &int2_chip,
+						 handle_level_irq);
 			set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 		}			
 	}
Index: linux-2.6-tip/arch/arm/mach-dove/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-dove/irq.c
+++ linux-2.6-tip/arch/arm/mach-dove/irq.c
@@ -121,8 +121,7 @@ void __init dove_init_irq(void)
 	writel(0, PMU_INTERRUPT_CAUSE);
 
 	for (i = IRQ_DOVE_PMU_START; i < NR_IRQS; i++) {
-		irq_set_chip(i, &pmu_irq_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &pmu_irq_chip, handle_level_irq);
 		irq_set_status_flags(i, IRQ_LEVEL);
 		set_irq_flags(i, IRQF_VALID);
 	}
Index: linux-2.6-tip/arch/arm/mach-ebsa110/core.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ebsa110/core.c
+++ linux-2.6-tip/arch/arm/mach-ebsa110/core.c
@@ -66,8 +66,8 @@ static void __init ebsa110_init_irq(void
 	local_irq_restore(flags);
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
-		irq_set_chip(irq, &ebsa110_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &ebsa110_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ep93xx/gpio.c
+++ linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
@@ -231,8 +231,8 @@ void __init ep93xx_gpio_init_irq(void)
 
 	for (gpio_irq = gpio_to_irq(0);
 	     gpio_irq <= gpio_to_irq(EP93XX_GPIO_LINE_MAX_IRQ); ++gpio_irq) {
-		irq_set_chip(gpio_irq, &ep93xx_gpio_irq_chip);
-		irq_set_handler(gpio_irq, handle_level_irq);
+		irq_set_chip_and_handler(gpio_irq, &ep93xx_gpio_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(gpio_irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-exynos4/irq-combiner.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-exynos4/irq-combiner.c
+++ linux-2.6-tip/arch/arm/mach-exynos4/irq-combiner.c
@@ -119,8 +119,7 @@ void __init combiner_init(unsigned int c
 
 	for (i = irq_start; i < combiner_data[combiner_nr].irq_offset
 				+ MAX_IRQ_IN_COMBINER; i++) {
-		irq_set_chip(i, &combiner_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &combiner_chip, handle_level_irq);
 		irq_set_chip_data(i, &combiner_data[combiner_nr]);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
Index: linux-2.6-tip/arch/arm/mach-exynos4/irq-eint.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-exynos4/irq-eint.c
+++ linux-2.6-tip/arch/arm/mach-exynos4/irq-eint.c
@@ -208,8 +208,8 @@ int __init exynos4_init_irq_eint(void)
 	int irq;
 
 	for (irq = 0 ; irq <= 31 ; irq++) {
-		irq_set_chip(IRQ_EINT(irq), &exynos4_irq_eint);
-		irq_set_handler(IRQ_EINT(irq), handle_level_irq);
+		irq_set_chip_and_handler(IRQ_EINT(irq), &exynos4_irq_eint,
+					 handle_level_irq);
 		set_irq_flags(IRQ_EINT(irq), IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-footbridge/common.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-footbridge/common.c
+++ linux-2.6-tip/arch/arm/mach-footbridge/common.c
@@ -102,8 +102,7 @@ static void __init __fb_init_irq(void)
 	*CSR_FIQ_DISABLE = -1;
 
 	for (irq = _DC21285_IRQ(0); irq < _DC21285_IRQ(20); irq++) {
-		irq_set_chip(irq, &fb_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &fb_chip, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-footbridge/isa-irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-footbridge/isa-irq.c
+++ linux-2.6-tip/arch/arm/mach-footbridge/isa-irq.c
@@ -151,14 +151,14 @@ void __init isa_init_irq(unsigned int ho
 
 	if (host_irq != (unsigned int)-1) {
 		for (irq = _ISA_IRQ(0); irq < _ISA_IRQ(8); irq++) {
-			irq_set_chip(irq, &isa_lo_chip);
-			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_and_handler(irq, &isa_lo_chip,
+						 handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
 
 		for (irq = _ISA_IRQ(8); irq < _ISA_IRQ(16); irq++) {
-			irq_set_chip(irq, &isa_hi_chip);
-			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_and_handler(irq, &isa_hi_chip,
+						 handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
 
Index: linux-2.6-tip/arch/arm/mach-gemini/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-gemini/gpio.c
+++ linux-2.6-tip/arch/arm/mach-gemini/gpio.c
@@ -217,8 +217,8 @@ void __init gemini_gpio_init(void)
 
 		for (j = GPIO_IRQ_BASE + i * 32;
 		     j < GPIO_IRQ_BASE + (i + 1) * 32; j++) {
-			irq_set_chip(j, &gpio_irq_chip);
-			irq_set_handler(j, handle_edge_irq);
+			irq_set_chip_and_handler(j, &gpio_irq_chip,
+						 handle_edge_irq);
 			set_irq_flags(j, IRQF_VALID);
 		}
 
Index: linux-2.6-tip/arch/arm/mach-h720x/common.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-h720x/common.c
+++ linux-2.6-tip/arch/arm/mach-h720x/common.c
@@ -199,15 +199,15 @@ void __init h720x_init_irq (void)
 
 	/* Initialize global IRQ's, fast path */
 	for (irq = 0; irq < NR_GLBL_IRQS; irq++) {
-		irq_set_chip(irq, &h720x_global_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &h720x_global_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	/* Initialize multiplexed IRQ's, slow path */
 	for (irq = IRQ_CHAINED_GPIOA(0) ; irq <= IRQ_CHAINED_GPIOD(31); irq++) {
-		irq_set_chip(irq, &h720x_gpio_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &h720x_gpio_chip,
+					 handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID );
 	}
 	irq_set_chained_handler(IRQ_GPIOA, h720x_gpioa_demux_handler);
@@ -217,8 +217,8 @@ void __init h720x_init_irq (void)
 
 #ifdef CONFIG_CPU_H7202
 	for (irq = IRQ_CHAINED_GPIOE(0) ; irq <= IRQ_CHAINED_GPIOE(31); irq++) {
-		irq_set_chip(irq, &h720x_gpio_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &h720x_gpio_chip,
+					 handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID );
 	}
 	irq_set_chained_handler(IRQ_GPIOE, h720x_gpioe_demux_handler);
Index: linux-2.6-tip/arch/arm/mach-h720x/cpu-h7202.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-h720x/cpu-h7202.c
+++ linux-2.6-tip/arch/arm/mach-h720x/cpu-h7202.c
@@ -197,8 +197,8 @@ void __init h7202_init_irq (void)
 	for (irq = IRQ_TIMER1;
 	                  irq < IRQ_CHAINED_TIMERX(NR_TIMERX_IRQS); irq++) {
 		mask_timerx_irq(irq);
-		irq_set_chip(irq, &h7202_timerx_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &h7202_timerx_chip,
+					 handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID );
 	}
 	irq_set_chained_handler(IRQ_TIMERX, h7202_timerx_demux_handler);
Index: linux-2.6-tip/arch/arm/mach-integrator/integrator_ap.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-integrator/integrator_ap.c
+++ linux-2.6-tip/arch/arm/mach-integrator/integrator_ap.c
@@ -187,8 +187,8 @@ static void __init ap_init_irq(void)
 
 	for (i = 0; i < NR_IRQS; i++) {
 		if (((1 << i) & INTEGRATOR_SC_VALID_INT) != 0) {
-			irq_set_chip(i, &sc_chip);
-			irq_set_handler(i, handle_level_irq);
+			irq_set_chip_and_handler(i, &sc_chip,
+						 handle_level_irq);
 			set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 		}
 	}
Index: linux-2.6-tip/arch/arm/mach-integrator/integrator_cp.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-integrator/integrator_cp.c
+++ linux-2.6-tip/arch/arm/mach-integrator/integrator_cp.c
@@ -238,8 +238,7 @@ static void __init intcp_init_irq(void)
 			i = 22;
 		if (i == 29)
 			break;
-		irq_set_chip(i, &pic_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &pic_chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
@@ -247,8 +246,7 @@ static void __init intcp_init_irq(void)
 	cic_writel(0xffffffff, INTCP_VA_CIC_BASE + FIQ_ENABLE_CLEAR);
 
 	for (i = IRQ_CIC_START; i <= IRQ_CIC_END; i++) {
-		irq_set_chip(i, &cic_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &cic_chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
@@ -256,8 +254,7 @@ static void __init intcp_init_irq(void)
 	sic_writel(0x00000fff, INTCP_VA_SIC_BASE + FIQ_ENABLE_CLEAR);
 
 	for (i = IRQ_SIC_START; i <= IRQ_SIC_END; i++) {
-		irq_set_chip(i, &sic_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &sic_chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-iop32x/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-iop32x/irq.c
+++ linux-2.6-tip/arch/arm/mach-iop32x/irq.c
@@ -68,8 +68,7 @@ void __init iop32x_init_irq(void)
 		*IOP3XX_PCIIRSR = 0x0f;
 
 	for (i = 0; i < NR_IRQS; i++) {
-		irq_set_chip(i, &ext_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &ext_chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-iop33x/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-iop33x/irq.c
+++ linux-2.6-tip/arch/arm/mach-iop33x/irq.c
@@ -110,9 +110,9 @@ void __init iop33x_init_irq(void)
 		*IOP3XX_PCIIRSR = 0x0f;
 
 	for (i = 0; i < NR_IRQS; i++) {
-		irq_set_chip(i,
-			     (i < 32) ? &iop33x_irqchip1 : &iop33x_irqchip2);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i,
+					 (i < 32) ? &iop33x_irqchip1 : &iop33x_irqchip2,
+					 handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-ixp2000/core.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp2000/core.c
+++ linux-2.6-tip/arch/arm/mach-ixp2000/core.c
@@ -476,8 +476,8 @@ void __init ixp2000_init_irq(void)
 	 */
 	for (irq = IRQ_IXP2000_SOFT_INT; irq <= IRQ_IXP2000_THDB3; irq++) {
 		if ((1 << irq) & IXP2000_VALID_IRQ_MASK) {
-			irq_set_chip(irq, &ixp2000_irq_chip);
-			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_and_handler(irq, &ixp2000_irq_chip,
+						 handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID);
 		} else set_irq_flags(irq, 0);
 	}
@@ -485,8 +485,8 @@ void __init ixp2000_init_irq(void)
 	for (irq = IRQ_IXP2000_DRAM0_MIN_ERR; irq <= IRQ_IXP2000_SP_INT; irq++) {
 		if((1 << (irq - IRQ_IXP2000_DRAM0_MIN_ERR)) &
 				IXP2000_VALID_ERR_IRQ_MASK) {
-			irq_set_chip(irq, &ixp2000_err_irq_chip);
-			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_and_handler(irq, &ixp2000_err_irq_chip,
+						 handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID);
 		}
 		else
@@ -495,8 +495,8 @@ void __init ixp2000_init_irq(void)
 	irq_set_chained_handler(IRQ_IXP2000_ERRSUM, ixp2000_err_irq_handler);
 
 	for (irq = IRQ_IXP2000_GPIO0; irq <= IRQ_IXP2000_GPIO7; irq++) {
-		irq_set_chip(irq, &ixp2000_GPIO_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &ixp2000_GPIO_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 	irq_set_chained_handler(IRQ_IXP2000_GPIO, ixp2000_GPIO_irq_handler);
@@ -508,8 +508,8 @@ void __init ixp2000_init_irq(void)
 	 */
 	ixp2000_reg_write(IXP2000_IRQ_ENABLE_SET, (1 << IRQ_IXP2000_PCI));
 	for (irq = IRQ_IXP2000_PCIA; irq <= IRQ_IXP2000_PCIB; irq++) {
-		irq_set_chip(irq, &ixp2000_pci_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &ixp2000_pci_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-ixp2000/ixdp2x00.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp2000/ixdp2x00.c
+++ linux-2.6-tip/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -158,8 +158,8 @@ void __init ixdp2x00_init_irq(volatile u
 	*board_irq_mask = 0xffffffff;
 
 	for(irq = IXP2000_BOARD_IRQ(0); irq < IXP2000_BOARD_IRQ(board_irq_count); irq++) {
-		irq_set_chip(irq, &ixdp2x00_cpld_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &ixdp2x00_cpld_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-ixp2000/ixdp2x01.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp2000/ixdp2x01.c
+++ linux-2.6-tip/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -115,8 +115,8 @@ void __init ixdp2x01_init_irq(void)
 
 	for (irq = NR_IXP2000_IRQS; irq < NR_IXDP2X01_IRQS; irq++) {
 		if (irq & valid_irq_mask) {
-			irq_set_chip(irq, &ixdp2x01_irq_chip);
-			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_and_handler(irq, &ixdp2x01_irq_chip,
+						 handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID);
 		} else {
 			set_irq_flags(irq, 0);
Index: linux-2.6-tip/arch/arm/mach-ixp23xx/core.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp23xx/core.c
+++ linux-2.6-tip/arch/arm/mach-ixp23xx/core.c
@@ -289,12 +289,12 @@ static void ixp23xx_config_irq(unsigned 
 {
 	switch (type) {
 	case IXP23XX_IRQ_LEVEL:
-		irq_set_chip(irq, &ixp23xx_irq_level_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &ixp23xx_irq_level_chip,
+					 handle_level_irq);
 		break;
 	case IXP23XX_IRQ_EDGE:
-		irq_set_chip(irq, &ixp23xx_irq_edge_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &ixp23xx_irq_edge_chip,
+					 handle_edge_irq);
 		break;
 	}
 	set_irq_flags(irq, IRQF_VALID);
@@ -324,8 +324,8 @@ void __init ixp23xx_init_irq(void)
 	}
 
 	for (irq = IRQ_IXP23XX_INTA; irq <= IRQ_IXP23XX_INTB; irq++) {
-		irq_set_chip(irq, &ixp23xx_pci_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &ixp23xx_pci_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-ixp23xx/ixdp2351.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp23xx/ixdp2351.c
+++ linux-2.6-tip/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -136,8 +136,8 @@ void __init ixdp2351_init_irq(void)
 	     irq++) {
 		if (IXDP2351_INTA_IRQ_MASK(irq) & IXDP2351_INTA_IRQ_VALID) {
 			set_irq_flags(irq, IRQF_VALID);
-			irq_set_handler(irq, handle_level_irq);
-			irq_set_chip(irq, &ixdp2351_inta_chip);
+			irq_set_chip_and_handler(irq, &ixdp2351_inta_chip,
+						 handle_level_irq);
 		}
 	}
 
@@ -147,8 +147,8 @@ void __init ixdp2351_init_irq(void)
 	     irq++) {
 		if (IXDP2351_INTB_IRQ_MASK(irq) & IXDP2351_INTB_IRQ_VALID) {
 			set_irq_flags(irq, IRQF_VALID);
-			irq_set_handler(irq, handle_level_irq);
-			irq_set_chip(irq, &ixdp2351_intb_chip);
+			irq_set_chip_and_handler(irq, &ixdp2351_intb_chip,
+						 handle_level_irq);
 		}
 	}
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/common.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/common.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/common.c
@@ -252,8 +252,8 @@ void __init ixp4xx_init_irq(void)
 
         /* Default to all level triggered */
 	for(i = 0; i < NR_IRQS; i++) {
-		irq_set_chip(i, &ixp4xx_irq_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &ixp4xx_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-ks8695/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ks8695/irq.c
+++ linux-2.6-tip/arch/arm/mach-ks8695/irq.c
@@ -115,12 +115,12 @@ static int ks8695_irq_set_type(struct ir
 	}
 
 	if (level_triggered) {
-		irq_set_chip(d->irq, &ks8695_irq_level_chip);
-		irq_set_handler(d->irq, handle_level_irq);
+		irq_set_chip_and_handler(d->irq, &ks8695_irq_level_chip,
+					 handle_level_irq);
 	}
 	else {
-		irq_set_chip(d->irq, &ks8695_irq_edge_chip);
-		irq_set_handler(d->irq, handle_edge_irq);
+		irq_set_chip_and_handler(d->irq, &ks8695_irq_edge_chip,
+					 handle_edge_irq);
 	}
 
 	__raw_writel(ctrl, KS8695_GPIO_VA + KS8695_IOPC);
@@ -158,16 +158,18 @@ void __init ks8695_init_irq(void)
 			case KS8695_IRQ_UART_RX:
 			case KS8695_IRQ_COMM_TX:
 			case KS8695_IRQ_COMM_RX:
-				irq_set_chip(irq, &ks8695_irq_level_chip);
-				irq_set_handler(irq, handle_level_irq);
+				irq_set_chip_and_handler(irq,
+							 &ks8695_irq_level_chip,
+							 handle_level_irq);
 				break;
 
 			/* Edge-triggered interrupts */
 			default:
 				/* clear pending bit */
 				ks8695_irq_ack(irq_get_irq_data(irq));
-				irq_set_chip(irq, &ks8695_irq_edge_chip);
-				irq_set_handler(irq, handle_edge_irq);
+				irq_set_chip_and_handler(irq,
+							 &ks8695_irq_edge_chip,
+							 handle_edge_irq);
 		}
 
 		set_irq_flags(irq, IRQF_VALID);
Index: linux-2.6-tip/arch/arm/mach-lpc32xx/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-lpc32xx/irq.c
+++ linux-2.6-tip/arch/arm/mach-lpc32xx/irq.c
@@ -390,8 +390,8 @@ void __init lpc32xx_init_irq(void)
 
 	/* Configure supported IRQ's */
 	for (i = 0; i < NR_IRQS; i++) {
-		irq_set_chip(i, &lpc32xx_irq_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &lpc32xx_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-mmp/irq-pxa168.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mmp/irq-pxa168.c
+++ linux-2.6-tip/arch/arm/mach-mmp/irq-pxa168.c
@@ -48,8 +48,7 @@ void __init icu_init_irq(void)
 
 	for (irq = 0; irq < 64; irq++) {
 		icu_mask_irq(irq_get_irq_data(irq));
-		irq_set_chip(irq, &icu_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &icu_irq_chip, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-msm/board-trout-gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/board-trout-gpio.c
+++ linux-2.6-tip/arch/arm/mach-msm/board-trout-gpio.c
@@ -214,8 +214,8 @@ int __init trout_init_gpio(void)
 {
 	int i;
 	for(i = TROUT_INT_START; i <= TROUT_INT_END; i++) {
-		irq_set_chip(i, &trout_gpio_irq_chip);
-		irq_set_handler(i, handle_edge_irq);
+		irq_set_chip_and_handler(i, &trout_gpio_irq_chip,
+					 handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-msm/gpio-v2.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/gpio-v2.c
+++ linux-2.6-tip/arch/arm/mach-msm/gpio-v2.c
@@ -362,8 +362,8 @@ static int __devinit msm_gpio_probe(stru
 
 	for (i = 0; i < msm_gpio.gpio_chip.ngpio; ++i) {
 		irq = msm_gpio_to_irq(&msm_gpio.gpio_chip, i);
-		irq_set_chip(irq, &msm_gpio_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &msm_gpio_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-msm/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/gpio.c
+++ linux-2.6-tip/arch/arm/mach-msm/gpio.c
@@ -355,8 +355,8 @@ static int __init msm_init_gpio(void)
 			msm_gpio_chips[j].chip.ngpio)
 			j++;
 		irq_set_chip_data(i, &msm_gpio_chips[j]);
-		irq_set_chip(i, &msm_gpio_irq_chip);
-		irq_set_handler(i, handle_edge_irq);
+		irq_set_chip_and_handler(i, &msm_gpio_irq_chip,
+					 handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-msm/irq-vic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/irq-vic.c
+++ linux-2.6-tip/arch/arm/mach-msm/irq-vic.c
@@ -357,8 +357,7 @@ void __init msm_init_irq(void)
 	writel(3, VIC_INT_MASTEREN);
 
 	for (n = 0; n < NR_MSM_IRQS; n++) {
-		irq_set_chip(n, &msm_irq_chip);
-		irq_set_handler(n, handle_level_irq);
+		irq_set_chip_and_handler(n, &msm_irq_chip, handle_level_irq);
 		set_irq_flags(n, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-msm/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/irq.c
+++ linux-2.6-tip/arch/arm/mach-msm/irq.c
@@ -145,8 +145,7 @@ void __init msm_init_irq(void)
 	writel(1, VIC_INT_MASTEREN);
 
 	for (n = 0; n < NR_MSM_IRQS; n++) {
-		irq_set_chip(n, &msm_irq_chip);
-		irq_set_handler(n, handle_level_irq);
+		irq_set_chip_and_handler(n, &msm_irq_chip, handle_level_irq);
 		set_irq_flags(n, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-msm/sirc.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/sirc.c
+++ linux-2.6-tip/arch/arm/mach-msm/sirc.c
@@ -158,8 +158,7 @@ void __init msm_init_sirc(void)
 	wake_enable = 0;
 
 	for (i = FIRST_SIRC_IRQ; i < LAST_SIRC_IRQ; i++) {
-		irq_set_chip(i, &sirc_irq_chip);
-		irq_set_handler(i, handle_edge_irq);
+		irq_set_chip_and_handler(i, &sirc_irq_chip, handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-mx3/mach-mx31ads.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mx3/mach-mx31ads.c
+++ linux-2.6-tip/arch/arm/mach-mx3/mach-mx31ads.c
@@ -199,8 +199,7 @@ static void __init mx31ads_init_expio(vo
 	__raw_writew(0xFFFF, PBC_INTSTATUS_REG);
 	for (i = MXC_EXP_IO_BASE; i < (MXC_EXP_IO_BASE + MXC_MAX_EXP_IO_LINES);
 	     i++) {
-		irq_set_chip(i, &expio_irq_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &expio_irq_chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 	irq_set_irq_type(EXPIO_PARENT_INT, IRQ_TYPE_LEVEL_HIGH);
Index: linux-2.6-tip/arch/arm/mach-mxs/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mxs/gpio.c
+++ linux-2.6-tip/arch/arm/mach-mxs/gpio.c
@@ -265,8 +265,8 @@ int __init mxs_gpio_init(struct mxs_gpio
 
 		for (j = port[i].virtual_irq_start;
 			j < port[i].virtual_irq_start + 32; j++) {
-			irq_set_chip(j, &gpio_irq_chip);
-			irq_set_handler(j, handle_level_irq);
+			irq_set_chip_and_handler(j, &gpio_irq_chip,
+						 handle_level_irq);
 			set_irq_flags(j, IRQF_VALID);
 		}
 
Index: linux-2.6-tip/arch/arm/mach-mxs/icoll.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mxs/icoll.c
+++ linux-2.6-tip/arch/arm/mach-mxs/icoll.c
@@ -74,8 +74,7 @@ void __init icoll_init_irq(void)
 	mxs_reset_block(icoll_base + HW_ICOLL_CTRL);
 
 	for (i = 0; i < MXS_INTERNAL_IRQS; i++) {
-		irq_set_chip(i, &mxs_icoll_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &mxs_icoll_chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-netx/generic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-netx/generic.c
+++ linux-2.6-tip/arch/arm/mach-netx/generic.c
@@ -171,8 +171,8 @@ void __init netx_init_irq(void)
 	vic_init(__io(io_p2v(NETX_PA_VIC)), 0, ~0, 0);
 
 	for (irq = NETX_IRQ_HIF_CHAINED(0); irq <= NETX_IRQ_HIF_LAST; irq++) {
-		irq_set_chip(irq, &netx_hif_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &netx_hif_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-ns9xxx/board-a9m9750dev.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ns9xxx/board-a9m9750dev.c
+++ linux-2.6-tip/arch/arm/mach-ns9xxx/board-a9m9750dev.c
@@ -107,8 +107,8 @@ void __init board_a9m9750dev_init_irq(vo
 				__func__);
 
 	for (i = FPGA_IRQ(0); i <= FPGA_IRQ(7); ++i) {
-		irq_set_chip(i, &a9m9750dev_fpga_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &a9m9750dev_fpga_chip,
+					 handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-nuc93x/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-nuc93x/irq.c
+++ linux-2.6-tip/arch/arm/mach-nuc93x/irq.c
@@ -59,8 +59,8 @@ void __init nuc93x_init_irq(void)
 	__raw_writel(0xFFFFFFFE, REG_AIC_MDCR);
 
 	for (irqno = IRQ_WDT; irqno <= NR_IRQS; irqno++) {
-		irq_set_chip(irqno, &nuc93x_irq_chip);
-		irq_set_handler(irqno, handle_level_irq);
+		irq_set_chip_and_handler(irqno, &nuc93x_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-omap1/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-omap1/irq.c
+++ linux-2.6-tip/arch/arm/mach-omap1/irq.c
@@ -230,8 +230,8 @@ void __init omap_init_irq(void)
 			irq_trigger = irq_banks[i].trigger_map >> IRQ_BIT(j);
 			omap_irq_set_cfg(j, 0, 0, irq_trigger);
 
-			irq_set_chip(j, &omap_irq_chip);
-			irq_set_handler(j, handle_level_irq);
+			irq_set_chip_and_handler(j, &omap_irq_chip,
+						 handle_level_irq);
 			set_irq_flags(j, IRQF_VALID);
 		}
 	}
Index: linux-2.6-tip/arch/arm/mach-omap2/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-omap2/irq.c
+++ linux-2.6-tip/arch/arm/mach-omap2/irq.c
@@ -223,8 +223,7 @@ void __init omap_init_irq(void)
 	       nr_of_irqs, nr_banks, nr_banks > 1 ? "s" : "");
 
 	for (i = 0; i < nr_of_irqs; i++) {
-		irq_set_chip(i, &omap_irq_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &omap_irq_chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-pxa/balloon3.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/balloon3.c
+++ linux-2.6-tip/arch/arm/mach-pxa/balloon3.c
@@ -527,8 +527,8 @@ static void __init balloon3_init_irq(voi
 	pxa27x_init_irq();
 	/* setup extra Balloon3 irqs */
 	for (irq = BALLOON3_IRQ(0); irq <= BALLOON3_IRQ(7); irq++) {
-		irq_set_chip(irq, &balloon3_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &balloon3_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-pxa/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/irq.c
+++ linux-2.6-tip/arch/arm/mach-pxa/irq.c
@@ -137,8 +137,8 @@ static void __init pxa_init_low_gpio_irq
 	GEDR0 = 0x3;
 
 	for (irq = IRQ_GPIO0; irq <= IRQ_GPIO1; irq++) {
-		irq_set_chip(irq, &pxa_low_gpio_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &pxa_low_gpio_chip,
+					 handle_edge_irq);
 		irq_set_chip_data(irq, irq_base(0));
 		set_irq_flags(irq, IRQF_VALID);
 	}
@@ -165,8 +165,8 @@ void __init pxa_init_irq(int irq_nr, set
 				__raw_writel(i | IPR_VALID, IRQ_BASE + IPR(i));
 
 			irq = PXA_IRQ(i);
-			irq_set_chip(irq, &pxa_internal_irq_chip);
-			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_and_handler(irq, &pxa_internal_irq_chip,
+						 handle_level_irq);
 			irq_set_chip_data(irq, base);
 			set_irq_flags(irq, IRQF_VALID);
 		}
Index: linux-2.6-tip/arch/arm/mach-pxa/lpd270.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/lpd270.c
+++ linux-2.6-tip/arch/arm/mach-pxa/lpd270.c
@@ -149,8 +149,8 @@ static void __init lpd270_init_irq(void)
 
 	/* setup extra LogicPD PXA270 irqs */
 	for (irq = LPD270_IRQ(2); irq <= LPD270_IRQ(4); irq++) {
-		irq_set_chip(irq, &lpd270_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &lpd270_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 	irq_set_chained_handler(IRQ_GPIO(0), lpd270_irq_handler);
Index: linux-2.6-tip/arch/arm/mach-pxa/lubbock.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/lubbock.c
+++ linux-2.6-tip/arch/arm/mach-pxa/lubbock.c
@@ -165,8 +165,8 @@ static void __init lubbock_init_irq(void
 
 	/* setup extra lubbock irqs */
 	for (irq = LUBBOCK_IRQ(0); irq <= LUBBOCK_LAST_IRQ; irq++) {
-		irq_set_chip(irq, &lubbock_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &lubbock_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-pxa/mainstone.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/mainstone.c
+++ linux-2.6-tip/arch/arm/mach-pxa/mainstone.c
@@ -166,8 +166,8 @@ static void __init mainstone_init_irq(vo
 
 	/* setup extra Mainstone irqs */
 	for(irq = MAINSTONE_IRQ(0); irq <= MAINSTONE_IRQ(15); irq++) {
-		irq_set_chip(irq, &mainstone_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &mainstone_irq_chip,
+					 handle_level_irq);
 		if (irq == MAINSTONE_IRQ(10) || irq == MAINSTONE_IRQ(14))
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE | IRQF_NOAUTOEN);
 		else
Index: linux-2.6-tip/arch/arm/mach-pxa/pcm990-baseboard.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/pcm990-baseboard.c
+++ linux-2.6-tip/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -281,8 +281,8 @@ static void __init pcm990_init_irq(void)
 
 	/* setup extra PCM990 irqs */
 	for (irq = PCM027_IRQ(0); irq <= PCM027_IRQ(3); irq++) {
-		irq_set_chip(irq, &pcm990_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &pcm990_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-pxa/pxa3xx.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/pxa3xx.c
+++ linux-2.6-tip/arch/arm/mach-pxa/pxa3xx.c
@@ -362,8 +362,8 @@ static void __init pxa_init_ext_wakeup_i
 	int irq;
 
 	for (irq = IRQ_WAKEUP0; irq <= IRQ_WAKEUP1; irq++) {
-		irq_set_chip(irq, &pxa_ext_wakeup_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &pxa_ext_wakeup_chip,
+					 handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-pxa/viper.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/viper.c
+++ linux-2.6-tip/arch/arm/mach-pxa/viper.c
@@ -310,8 +310,8 @@ static void __init viper_init_irq(void)
 	/* setup ISA IRQs */
 	for (level = 0; level < ARRAY_SIZE(viper_isa_irqs); level++) {
 		isa_irq = viper_bit_to_irq(level);
-		irq_set_chip(isa_irq, &viper_irq_chip);
-		irq_set_handler(isa_irq, handle_edge_irq);
+		irq_set_chip_and_handler(isa_irq, &viper_irq_chip,
+					 handle_edge_irq);
 		set_irq_flags(isa_irq, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-pxa/zeus.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/zeus.c
+++ linux-2.6-tip/arch/arm/mach-pxa/zeus.c
@@ -146,8 +146,8 @@ static void __init zeus_init_irq(void)
 	/* Setup ISA IRQs */
 	for (level = 0; level < ARRAY_SIZE(zeus_isa_irqs); level++) {
 		isa_irq = zeus_bit_to_irq(level);
-		irq_set_chip(isa_irq, &zeus_irq_chip);
-		irq_set_handler(isa_irq, handle_edge_irq);
+		irq_set_chip_and_handler(isa_irq, &zeus_irq_chip,
+					 handle_edge_irq);
 		set_irq_flags(isa_irq, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-rpc/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-rpc/irq.c
+++ linux-2.6-tip/arch/arm/mach-rpc/irq.c
@@ -133,20 +133,20 @@ void __init rpc_init_irq(void)
 
 		switch (irq) {
 		case 0 ... 7:
-			irq_set_chip(irq, &iomd_a_chip);
-			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_and_handler(irq, &iomd_a_chip,
+						 handle_level_irq);
 			set_irq_flags(irq, flags);
 			break;
 
 		case 8 ... 15:
-			irq_set_chip(irq, &iomd_b_chip);
-			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_and_handler(irq, &iomd_b_chip,
+						 handle_level_irq);
 			set_irq_flags(irq, flags);
 			break;
 
 		case 16 ... 21:
-			irq_set_chip(irq, &iomd_dma_chip);
-			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_and_handler(irq, &iomd_dma_chip,
+						 handle_level_irq);
 			set_irq_flags(irq, flags);
 			break;
 
Index: linux-2.6-tip/arch/arm/mach-s3c2410/bast-irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2410/bast-irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2410/bast-irq.c
@@ -154,8 +154,8 @@ static __init int bast_irq_init(void)
 		for (i = 0; i < 4; i++) {
 			unsigned int irqno = bast_pc104_irqs[i];
 
-			irq_set_chip(irqno, &bast_pc104_chip);
-			irq_set_handler(irqno, handle_level_irq);
+			irq_set_chip_and_handler(irqno, &bast_pc104_chip,
+						 handle_level_irq);
 			set_irq_flags(irqno, IRQF_VALID);
 		}
 	}
Index: linux-2.6-tip/arch/arm/mach-s3c2412/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2412/irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2412/irq.c
@@ -175,8 +175,8 @@ static int s3c2412_irq_add(struct sys_de
 	unsigned int irqno;
 
 	for (irqno = IRQ_EINT0; irqno <= IRQ_EINT3; irqno++) {
-		irq_set_chip(irqno, &s3c2412_irq_eint0t4);
-		irq_set_handler(irqno, handle_edge_irq);
+		irq_set_chip_and_handler(irqno, &s3c2412_irq_eint0t4,
+					 handle_edge_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
@@ -185,8 +185,8 @@ static int s3c2412_irq_add(struct sys_de
 	irq_set_chained_handler(IRQ_S3C2412_CFSDI, s3c2412_irq_demux_cfsdi);
 
 	for (irqno = IRQ_S3C2412_SDI; irqno <= IRQ_S3C2412_CF; irqno++) {
-		irq_set_chip(irqno, &s3c2412_irq_cfsdi);
-		irq_set_handler(irqno, handle_level_irq);
+		irq_set_chip_and_handler(irqno, &s3c2412_irq_cfsdi,
+					 handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-s3c2416/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2416/irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2416/irq.c
@@ -202,13 +202,11 @@ static int __init s3c2416_add_sub(unsign
 {
 	unsigned int irqno;
 
-	irq_set_chip(base, &s3c_irq_level_chip);
-	irq_set_handler(base, handle_level_irq);
+	irq_set_chip_and_handler(base, &s3c_irq_level_chip, handle_level_irq);
 	irq_set_chained_handler(base, demux);
 
 	for (irqno = start; irqno <= end; irqno++) {
-		irq_set_chip(irqno, chip);
-		irq_set_handler(irqno, handle_level_irq);
+		irq_set_chip_and_handler(irqno, chip, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-s3c2440/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2440/irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2440/irq.c
@@ -100,13 +100,13 @@ static int s3c2440_irq_add(struct sys_de
 
 	/* add new chained handler for wdt, ac7 */
 
-	irq_set_chip(IRQ_WDT, &s3c_irq_level_chip);
-	irq_set_handler(IRQ_WDT, handle_level_irq);
+	irq_set_chip_and_handler(IRQ_WDT, &s3c_irq_level_chip,
+				 handle_level_irq);
 	irq_set_chained_handler(IRQ_WDT, s3c_irq_demux_wdtac97);
 
 	for (irqno = IRQ_S3C2440_WDT; irqno <= IRQ_S3C2440_AC97; irqno++) {
-		irq_set_chip(irqno, &s3c_irq_wdtac97);
-		irq_set_handler(irqno, handle_level_irq);
+		irq_set_chip_and_handler(irqno, &s3c_irq_wdtac97,
+					 handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-s3c2440/s3c244x-irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2440/s3c244x-irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2440/s3c244x-irq.c
@@ -95,19 +95,19 @@ static int s3c244x_irq_add(struct sys_de
 {
 	unsigned int irqno;
 
-	irq_set_chip(IRQ_NFCON, &s3c_irq_level_chip);
-	irq_set_handler(IRQ_NFCON, handle_level_irq);
+	irq_set_chip_and_handler(IRQ_NFCON, &s3c_irq_level_chip,
+				 handle_level_irq);
 	set_irq_flags(IRQ_NFCON, IRQF_VALID);
 
 	/* add chained handler for camera */
 
-	irq_set_chip(IRQ_CAM, &s3c_irq_level_chip);
-	irq_set_handler(IRQ_CAM, handle_level_irq);
+	irq_set_chip_and_handler(IRQ_CAM, &s3c_irq_level_chip,
+				 handle_level_irq);
 	irq_set_chained_handler(IRQ_CAM, s3c_irq_demux_cam);
 
 	for (irqno = IRQ_S3C2440_CAM_C; irqno <= IRQ_S3C2440_CAM_P; irqno++) {
-		irq_set_chip(irqno, &s3c_irq_cam);
-		irq_set_handler(irqno, handle_level_irq);
+		irq_set_chip_and_handler(irqno, &s3c_irq_cam,
+					 handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-s3c2443/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2443/irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2443/irq.c
@@ -230,13 +230,11 @@ static int __init s3c2443_add_sub(unsign
 {
 	unsigned int irqno;
 
-	irq_set_chip(base, &s3c_irq_level_chip);
-	irq_set_handler(base, handle_level_irq);
+	irq_set_chip_and_handler(base, &s3c_irq_level_chip, handle_level_irq);
 	irq_set_chained_handler(base, demux);
 
 	for (irqno = start; irqno <= end; irqno++) {
-		irq_set_chip(irqno, chip);
-		irq_set_handler(irqno, handle_level_irq);
+		irq_set_chip_and_handler(irqno, chip, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-s3c64xx/irq-eint.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c64xx/irq-eint.c
+++ linux-2.6-tip/arch/arm/mach-s3c64xx/irq-eint.c
@@ -197,8 +197,7 @@ static int __init s3c64xx_init_irq_eint(
 	int irq;
 
 	for (irq = IRQ_EINT(0); irq <= IRQ_EINT(27); irq++) {
-		irq_set_chip(irq, &s3c_irq_eint);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &s3c_irq_eint, handle_level_irq);
 		irq_set_chip_data(irq, (void *)eint_irq_to_bit(irq));
 		set_irq_flags(irq, IRQF_VALID);
 	}
Index: linux-2.6-tip/arch/arm/mach-sa1100/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-sa1100/irq.c
+++ linux-2.6-tip/arch/arm/mach-sa1100/irq.c
@@ -323,20 +323,20 @@ void __init sa1100_init_irq(void)
 	ICCR = 1;
 
 	for (irq = 0; irq <= 10; irq++) {
-		irq_set_chip(irq, &sa1100_low_gpio_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &sa1100_low_gpio_chip,
+					 handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	for (irq = 12; irq <= 31; irq++) {
-		irq_set_chip(irq, &sa1100_normal_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &sa1100_normal_chip,
+					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
 	for (irq = 32; irq <= 48; irq++) {
-		irq_set_chip(irq, &sa1100_high_gpio_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &sa1100_high_gpio_chip,
+					 handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-shark/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-shark/irq.c
+++ linux-2.6-tip/arch/arm/mach-shark/irq.c
@@ -80,8 +80,7 @@ void __init shark_init_irq(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
-		irq_set_chip(irq, &fb_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &fb_chip, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-tegra/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-tegra/gpio.c
+++ linux-2.6-tip/arch/arm/mach-tegra/gpio.c
@@ -298,8 +298,8 @@ static int __init tegra_gpio_init(void)
 
 		irq_set_lockdep_class(i, &gpio_lock_class);
 		irq_set_chip_data(i, bank);
-		irq_set_chip(i, &tegra_gpio_irq_chip);
-		irq_set_handler(i, handle_simple_irq);
+		irq_set_chip_and_handler(i, &tegra_gpio_irq_chip,
+					 handle_simple_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-tegra/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-tegra/irq.c
+++ linux-2.6-tip/arch/arm/mach-tegra/irq.c
@@ -154,8 +154,7 @@ void __init tegra_init_irq(void)
 
 	for (i = 0; i < INT_MAIN_NR; i++) {
 		irq = INT_PRI_BASE + i;
-		irq_set_chip(irq, &tegra_irq);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &tegra_irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-ux500/modem-irq-db5500.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ux500/modem-irq-db5500.c
+++ linux-2.6-tip/arch/arm/mach-ux500/modem-irq-db5500.c
@@ -90,8 +90,7 @@ static irqreturn_t modem_cpu_irq_handler
 
 static void create_virtual_irq(int irq, struct irq_chip *modem_irq_chip)
 {
-	irq_set_chip(irq, modem_irq_chip);
-	irq_set_handler(irq, handle_simple_irq);
+	irq_set_chip_and_handler(irq, modem_irq_chip, handle_simple_irq);
 	set_irq_flags(irq, IRQF_VALID);
 
 	pr_debug("modem_irq: Created virtual IRQ %d\n", irq);
Index: linux-2.6-tip/arch/arm/mach-versatile/core.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-versatile/core.c
+++ linux-2.6-tip/arch/arm/mach-versatile/core.c
@@ -129,8 +129,8 @@ void __init versatile_init_irq(void)
 
 	for (i = IRQ_SIC_START; i <= IRQ_SIC_END; i++) {
 		if ((PIC_MASK & (1 << (i - IRQ_SIC_START))) == 0) {
-			irq_set_chip(i, &sic_chip);
-			irq_set_handler(i, handle_level_irq);
+			irq_set_chip_and_handler(i, &sic_chip,
+						 handle_level_irq);
 			set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 		}
 	}
Index: linux-2.6-tip/arch/arm/mach-vt8500/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-vt8500/irq.c
+++ linux-2.6-tip/arch/arm/mach-vt8500/irq.c
@@ -136,8 +136,8 @@ void __init vt8500_init_irq(void)
 			/* Disable all interrupts and route them to IRQ */
 			writeb(0x00, ic_regbase + VT8500_IC_DCTR + i);
 
-			irq_set_chip(i, &vt8500_irq_chip);
-			irq_set_handler(i, handle_level_irq);
+			irq_set_chip_and_handler(i, &vt8500_irq_chip,
+						 handle_level_irq);
 			set_irq_flags(i, IRQF_VALID);
 		}
 	} else {
@@ -167,8 +167,8 @@ void __init wm8505_init_irq(void)
 				writeb(0x00, sic_regbase + VT8500_IC_DCTR
 								+ i - 64);
 
-			irq_set_chip(i, &vt8500_irq_chip);
-			irq_set_handler(i, handle_level_irq);
+			irq_set_chip_and_handler(i, &vt8500_irq_chip,
+						 handle_level_irq);
 			set_irq_flags(i, IRQF_VALID);
 		}
 	} else {
Index: linux-2.6-tip/arch/arm/mach-w90x900/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-w90x900/irq.c
+++ linux-2.6-tip/arch/arm/mach-w90x900/irq.c
@@ -207,8 +207,8 @@ void __init nuc900_init_irq(void)
 	__raw_writel(0xFFFFFFFE, REG_AIC_MDCR);
 
 	for (irqno = IRQ_WDT; irqno <= IRQ_ADC; irqno++) {
-		irq_set_chip(irqno, &nuc900_irq_chip);
-		irq_set_handler(irqno, handle_level_irq);
+		irq_set_chip_and_handler(irqno, &nuc900_irq_chip,
+					 handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/plat-mxc/3ds_debugboard.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-mxc/3ds_debugboard.c
+++ linux-2.6-tip/arch/arm/plat-mxc/3ds_debugboard.c
@@ -181,8 +181,7 @@ int __init mxc_expio_init(u32 base, u32 
 	__raw_writew(0x1F, brd_io + INTR_MASK_REG);
 	for (i = MXC_EXP_IO_BASE;
 	     i < (MXC_EXP_IO_BASE + MXC_MAX_EXP_IO_LINES); i++) {
-		irq_set_chip(i, &expio_irq_chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &expio_irq_chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 	irq_set_irq_type(p_irq, IRQF_TRIGGER_LOW);
Index: linux-2.6-tip/arch/arm/plat-mxc/avic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-mxc/avic.c
+++ linux-2.6-tip/arch/arm/plat-mxc/avic.c
@@ -139,8 +139,8 @@ void __init mxc_init_irq(void __iomem *i
 	__raw_writel(0, avic_base + AVIC_INTTYPEH);
 	__raw_writel(0, avic_base + AVIC_INTTYPEL);
 	for (i = 0; i < MXC_INTERNAL_IRQS; i++) {
-		irq_set_chip(i, &mxc_avic_chip.base);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &mxc_avic_chip.base,
+					 handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-mxc/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-mxc/gpio.c
+++ linux-2.6-tip/arch/arm/plat-mxc/gpio.c
@@ -311,8 +311,8 @@ int __init mxc_gpio_init(struct mxc_gpio
 		__raw_writel(~0, port[i].base + GPIO_ISR);
 		for (j = port[i].virtual_irq_start;
 			j < port[i].virtual_irq_start + 32; j++) {
-			irq_set_chip(j, &gpio_irq_chip);
-			irq_set_handler(j, handle_level_irq);
+			irq_set_chip_and_handler(j, &gpio_irq_chip,
+						 handle_level_irq);
 			set_irq_flags(j, IRQF_VALID);
 		}
 
Index: linux-2.6-tip/arch/arm/plat-mxc/tzic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-mxc/tzic.c
+++ linux-2.6-tip/arch/arm/plat-mxc/tzic.c
@@ -167,8 +167,8 @@ void __init tzic_init_irq(void __iomem *
 	/* all IRQ no FIQ Warning :: No selection */
 
 	for (i = 0; i < MXC_INTERNAL_IRQS; i++) {
-		irq_set_chip(i, &mxc_tzic_chip.base);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, &mxc_tzic_chip.base,
+					 handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-nomadik/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-nomadik/gpio.c
+++ linux-2.6-tip/arch/arm/plat-nomadik/gpio.c
@@ -732,8 +732,8 @@ static int nmk_gpio_init_irq(struct nmk_
 
 	first_irq = NOMADIK_GPIO_TO_IRQ(nmk_chip->chip.base);
 	for (i = first_irq; i < first_irq + nmk_chip->chip.ngpio; i++) {
-		irq_set_chip(i, &nmk_gpio_irq_chip);
-		irq_set_handler(i, handle_edge_irq);
+		irq_set_chip_and_handler(i, &nmk_gpio_irq_chip,
+					 handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID);
 		irq_set_chip_data(i, nmk_chip);
 		irq_set_irq_type(i, IRQ_TYPE_EDGE_FALLING);
Index: linux-2.6-tip/arch/arm/plat-orion/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-orion/gpio.c
+++ linux-2.6-tip/arch/arm/plat-orion/gpio.c
@@ -474,8 +474,8 @@ void __init orion_gpio_init(int gpio_bas
 	for (i = 0; i < ngpio; i++) {
 		unsigned int irq = secondary_irq_base + i;
 
-		irq_set_chip(irq, &orion_gpio_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &orion_gpio_irq_chip,
+					 handle_level_irq);
 		irq_set_chip_data(irq, ochip);
 		irq_set_status_flags(irq, IRQ_LEVEL);
 		set_irq_flags(irq, IRQF_VALID);
Index: linux-2.6-tip/arch/arm/plat-orion/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-orion/irq.c
+++ linux-2.6-tip/arch/arm/plat-orion/irq.c
@@ -56,8 +56,8 @@ void __init orion_irq_init(unsigned int 
 	for (i = 0; i < 32; i++) {
 		unsigned int irq = irq_start + i;
 
-		irq_set_chip(irq, &orion_irq_chip);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &orion_irq_chip,
+					 handle_level_irq);
 		irq_set_chip_data(irq, maskaddr);
 		irq_set_status_flags(irq, IRQ_LEVEL);
 		set_irq_flags(irq, IRQF_VALID);
Index: linux-2.6-tip/arch/arm/plat-pxa/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-pxa/gpio.c
+++ linux-2.6-tip/arch/arm/plat-pxa/gpio.c
@@ -284,8 +284,8 @@ void __init pxa_init_gpio(int mux_irq, i
 	}
 
 	for (irq  = gpio_to_irq(start); irq <= gpio_to_irq(end); irq++) {
-		irq_set_chip(irq, &pxa_muxed_gpio_chip);
-		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_and_handler(irq, &pxa_muxed_gpio_chip,
+					 handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-s3c24xx/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-s3c24xx/irq.c
+++ linux-2.6-tip/arch/arm/plat-s3c24xx/irq.c
@@ -592,8 +592,8 @@ void __init s3c24xx_init_irq(void)
 		case IRQ_UART1:
 		case IRQ_UART2:
 		case IRQ_ADCPARENT:
-			irq_set_chip(irqno, &s3c_irq_level_chip);
-			irq_set_handler(irqno, handle_level_irq);
+			irq_set_chip_and_handler(irqno, &s3c_irq_level_chip,
+						 handle_level_irq);
 			break;
 
 		case IRQ_RESERVED6:
@@ -603,8 +603,8 @@ void __init s3c24xx_init_irq(void)
 
 		default:
 			//irqdbf("registering irq %d (s3c irq)\n", irqno);
-			irq_set_chip(irqno, &s3c_irq_chip);
-			irq_set_handler(irqno, handle_edge_irq);
+			irq_set_chip_and_handler(irqno, &s3c_irq_chip,
+						 handle_edge_irq);
 			set_irq_flags(irqno, IRQF_VALID);
 		}
 	}
@@ -623,15 +623,15 @@ void __init s3c24xx_init_irq(void)
 
 	for (irqno = IRQ_EINT0; irqno <= IRQ_EINT3; irqno++) {
 		irqdbf("registering irq %d (ext int)\n", irqno);
-		irq_set_chip(irqno, &s3c_irq_eint0t4);
-		irq_set_handler(irqno, handle_edge_irq);
+		irq_set_chip_and_handler(irqno, &s3c_irq_eint0t4,
+					 handle_edge_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
 	for (irqno = IRQ_EINT4; irqno <= IRQ_EINT23; irqno++) {
 		irqdbf("registering irq %d (extended s3c irq)\n", irqno);
-		irq_set_chip(irqno, &s3c_irqext_chip);
-		irq_set_handler(irqno, handle_edge_irq);
+		irq_set_chip_and_handler(irqno, &s3c_irqext_chip,
+					 handle_edge_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
@@ -641,29 +641,28 @@ void __init s3c24xx_init_irq(void)
 
 	for (irqno = IRQ_S3CUART_RX0; irqno <= IRQ_S3CUART_ERR0; irqno++) {
 		irqdbf("registering irq %d (s3c uart0 irq)\n", irqno);
-		irq_set_chip(irqno, &s3c_irq_uart0);
-		irq_set_handler(irqno, handle_level_irq);
+		irq_set_chip_and_handler(irqno, &s3c_irq_uart0,
+					 handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
 	for (irqno = IRQ_S3CUART_RX1; irqno <= IRQ_S3CUART_ERR1; irqno++) {
 		irqdbf("registering irq %d (s3c uart1 irq)\n", irqno);
-		irq_set_chip(irqno, &s3c_irq_uart1);
-		irq_set_handler(irqno, handle_level_irq);
+		irq_set_chip_and_handler(irqno, &s3c_irq_uart1,
+					 handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
 	for (irqno = IRQ_S3CUART_RX2; irqno <= IRQ_S3CUART_ERR2; irqno++) {
 		irqdbf("registering irq %d (s3c uart2 irq)\n", irqno);
-		irq_set_chip(irqno, &s3c_irq_uart2);
-		irq_set_handler(irqno, handle_level_irq);
+		irq_set_chip_and_handler(irqno, &s3c_irq_uart2,
+					 handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
 	for (irqno = IRQ_TC; irqno <= IRQ_ADC; irqno++) {
 		irqdbf("registering irq %d (s3c adc irq)\n", irqno);
-		irq_set_chip(irqno, &s3c_irq_adc);
-		irq_set_handler(irqno, handle_edge_irq);
+		irq_set_chip_and_handler(irqno, &s3c_irq_adc, handle_edge_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-s5p/irq-eint.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-s5p/irq-eint.c
+++ linux-2.6-tip/arch/arm/plat-s5p/irq-eint.c
@@ -208,8 +208,7 @@ int __init s5p_init_irq_eint(void)
 		irq_set_chip(irq, &s5p_irq_vic_eint);
 
 	for (irq = IRQ_EINT(16); irq <= IRQ_EINT(31); irq++) {
-		irq_set_chip(irq, &s5p_irq_eint);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &s5p_irq_eint, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-samsung/irq-uart.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-samsung/irq-uart.c
+++ linux-2.6-tip/arch/arm/plat-samsung/irq-uart.c
@@ -117,8 +117,7 @@ static void __init s3c_init_uart_irq(str
 	for (offs = 0; offs < 3; offs++) {
 		irq = uirq->base_irq + offs;
 
-		irq_set_chip(irq, &s3c_irq_uart);
-		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_and_handler(irq, &s3c_irq_uart, handle_level_irq);
 		irq_set_chip_data(irq, uirq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
Index: linux-2.6-tip/arch/arm/plat-spear/shirq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-spear/shirq.c
+++ linux-2.6-tip/arch/arm/plat-spear/shirq.c
@@ -107,8 +107,8 @@ int spear_shirq_register(struct spear_sh
 
 	irq_set_chained_handler(shirq->irq, shirq_handler);
 	for (i = 0; i < shirq->dev_count; i++) {
-		irq_set_chip(shirq->dev_config[i].virq, &shirq_chip);
-		irq_set_handler(shirq->dev_config[i].virq, handle_simple_irq);
+		irq_set_chip_and_handler(shirq->dev_config[i].virq,
+					 &shirq_chip, handle_simple_irq);
 		set_irq_flags(shirq->dev_config[i].virq, IRQF_VALID);
 		irq_set_chip_data(shirq->dev_config[i].virq, shirq);
 	}
Index: linux-2.6-tip/arch/arm/plat-stmp3xxx/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-stmp3xxx/irq.c
+++ linux-2.6-tip/arch/arm/plat-stmp3xxx/irq.c
@@ -35,8 +35,7 @@ void __init stmp3xxx_init_irq(struct irq
 	/* Disable all interrupts initially */
 	for (i = 0; i < NR_REAL_IRQS; i++) {
 		chip->irq_mask(irq_get_irq_data(i));
-		irq_set_chip(i, chip);
-		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_and_handler(i, chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-stmp3xxx/pinmux.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-stmp3xxx/pinmux.c
+++ linux-2.6-tip/arch/arm/plat-stmp3xxx/pinmux.c
@@ -533,8 +533,8 @@ int __init stmp3xxx_pinmux_init(int virt
 
 		for (virq = pm->virq; virq < pm->virq; virq++) {
 			gpio_irq_chip.irq_mask(irq_get_irq_data(virq));
-			irq_set_chip(virq, &gpio_irq_chip);
-			irq_set_handler(virq, handle_level_irq);
+			irq_set_chip_and_handler(virq, &gpio_irq_chip,
+						 handle_level_irq);
 			set_irq_flags(virq, IRQF_VALID);
 		}
 		r = gpiochip_add(&pm->chip);


