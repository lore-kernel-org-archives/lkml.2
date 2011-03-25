Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1CYNWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:34705 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752832Ab1CYNW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:28 -0400
Message-Id: <20110325132049.382413026@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 21/23] arm: Cleanup the irq namespace
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-genirq-namespace-cleanup.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new function names. Automated with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/common/gic.c                          |   14 +++----
 arch/arm/common/it8152.c                       |    4 +-
 arch/arm/common/locomo.c                       |   18 +++++-----
 arch/arm/common/sa1111.c                       |   24 ++++++-------
 arch/arm/common/vic.c                          |    6 +--
 arch/arm/kernel/ecard.c                        |    6 +--
 arch/arm/mach-at91/at91cap9_devices.c          |    6 +--
 arch/arm/mach-at91/gpio.c                      |   10 ++---
 arch/arm/mach-at91/irq.c                       |    4 +-
 arch/arm/mach-bcmring/irq.c                    |   10 ++---
 arch/arm/mach-clps711x/irq.c                   |    8 ++--
 arch/arm/mach-davinci/cp_intc.c                |    4 +-
 arch/arm/mach-davinci/gpio.c                   |   32 +++++++++---------
 arch/arm/mach-davinci/irq.c                    |    6 +--
 arch/arm/mach-dove/irq.c                       |   16 ++++-----
 arch/arm/mach-ebsa110/core.c                   |    4 +-
 arch/arm/mach-ep93xx/gpio.c                    |   31 +++++++++++------
 arch/arm/mach-exynos4/irq-combiner.c           |   14 +++----
 arch/arm/mach-exynos4/irq-eint.c               |   15 ++++----
 arch/arm/mach-footbridge/common.c              |    4 +-
 arch/arm/mach-footbridge/isa-irq.c             |   10 ++---
 arch/arm/mach-gemini/gpio.c                    |    8 ++--
 arch/arm/mach-gemini/irq.c                     |    6 +--
 arch/arm/mach-h720x/common.c                   |   22 ++++++------
 arch/arm/mach-h720x/cpu-h7202.c                |    6 +--
 arch/arm/mach-integrator/integrator_ap.c       |    4 +-
 arch/arm/mach-integrator/integrator_cp.c       |   14 +++----
 arch/arm/mach-iop13xx/irq.c                    |   10 ++---
 arch/arm/mach-iop13xx/msi.c                    |    6 +--
 arch/arm/mach-iop32x/irq.c                     |    4 +-
 arch/arm/mach-iop33x/irq.c                     |    5 +-
 arch/arm/mach-ixp2000/core.c                   |   20 +++++------
 arch/arm/mach-ixp2000/ixdp2x00.c               |    6 +--
 arch/arm/mach-ixp2000/ixdp2x01.c               |    6 +--
 arch/arm/mach-ixp23xx/core.c                   |   14 +++----
 arch/arm/mach-ixp23xx/ixdp2351.c               |   12 +++---
 arch/arm/mach-ixp23xx/roadrunner.c             |    4 +-
 arch/arm/mach-ixp4xx/avila-pci.c               |    8 ++--
 arch/arm/mach-ixp4xx/common.c                  |    4 +-
 arch/arm/mach-ixp4xx/coyote-pci.c              |    4 +-
 arch/arm/mach-ixp4xx/dsmg600-pci.c             |   12 +++---
 arch/arm/mach-ixp4xx/fsg-pci.c                 |    6 +--
 arch/arm/mach-ixp4xx/gateway7001-pci.c         |    4 +-
 arch/arm/mach-ixp4xx/goramo_mlr.c              |   12 +++---
 arch/arm/mach-ixp4xx/gtwx5715-pci.c            |    4 +-
 arch/arm/mach-ixp4xx/ixdp425-pci.c             |    8 ++--
 arch/arm/mach-ixp4xx/ixdpg425-pci.c            |    4 +-
 arch/arm/mach-ixp4xx/nas100d-pci.c             |   10 ++---
 arch/arm/mach-ixp4xx/nslu2-pci.c               |    6 +--
 arch/arm/mach-ixp4xx/vulcan-pci.c              |    4 +-
 arch/arm/mach-ixp4xx/wg302v2-pci.c             |    4 +-
 arch/arm/mach-kirkwood/irq.c                   |   15 ++++----
 arch/arm/mach-ks8695/gpio.c                    |    2 -
 arch/arm/mach-ks8695/irq.c                     |   16 ++++-----
 arch/arm/mach-lpc32xx/irq.c                    |   10 ++---
 arch/arm/mach-mmp/irq-mmp2.c                   |   18 +++++-----
 arch/arm/mach-mmp/irq-pxa168.c                 |    4 +-
 arch/arm/mach-msm/board-msm8960.c              |    2 -
 arch/arm/mach-msm/board-msm8x60.c              |    2 -
 arch/arm/mach-msm/board-trout-gpio.c           |   10 ++---
 arch/arm/mach-msm/board-trout-mmc.c            |    2 -
 arch/arm/mach-msm/gpio-v2.c                    |   12 +++---
 arch/arm/mach-msm/gpio.c                       |   14 +++----
 arch/arm/mach-msm/irq-vic.c                    |    4 +-
 arch/arm/mach-msm/irq.c                        |    4 +-
 arch/arm/mach-msm/sirc.c                       |    8 ++--
 arch/arm/mach-mv78xx0/irq.c                    |    8 ++--
 arch/arm/mach-mx3/mach-mx31ads.c               |    8 ++--
 arch/arm/mach-mx5/eukrea_mbimx51-baseboard.c   |    2 -
 arch/arm/mach-mxs/gpio.c                       |   10 ++---
 arch/arm/mach-mxs/icoll.c                      |    4 +-
 arch/arm/mach-netx/generic.c                   |    6 +--
 arch/arm/mach-ns9xxx/board-a9m9750dev.c        |    8 ++--
 arch/arm/mach-ns9xxx/irq.c                     |    4 +-
 arch/arm/mach-nuc93x/irq.c                     |    4 +-
 arch/arm/mach-omap1/board-osk.c                |    6 +--
 arch/arm/mach-omap1/board-palmz71.c            |    8 ++--
 arch/arm/mach-omap1/board-voiceblue.c          |    8 ++--
 arch/arm/mach-omap1/fpga.c                     |   10 ++---
 arch/arm/mach-omap1/irq.c                      |    4 +-
 arch/arm/mach-omap2/gpmc.c                     |    2 -
 arch/arm/mach-omap2/irq.c                      |    4 +-
 arch/arm/mach-orion5x/db88f5281-setup.c        |    4 +-
 arch/arm/mach-orion5x/irq.c                    |    8 ++--
 arch/arm/mach-orion5x/rd88f5182-setup.c        |    4 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c |    2 -
 arch/arm/mach-orion5x/ts209-setup.c            |    4 +-
 arch/arm/mach-pnx4008/irq.c                    |   10 ++---
 arch/arm/mach-pxa/balloon3.c                   |    8 ++--
 arch/arm/mach-pxa/cm-x2xx-pci.c                |    5 +-
 arch/arm/mach-pxa/cm-x300.c                    |    2 -
 arch/arm/mach-pxa/irq.c                        |   12 +++---
 arch/arm/mach-pxa/lpd270.c                     |    8 ++--
 arch/arm/mach-pxa/lubbock.c                    |    8 ++--
 arch/arm/mach-pxa/mainstone.c                  |    8 ++--
 arch/arm/mach-pxa/pcm990-baseboard.c           |    8 ++--
 arch/arm/mach-pxa/pxa3xx.c                     |    4 +-
 arch/arm/mach-pxa/viper.c                      |    8 ++--
 arch/arm/mach-pxa/zeus.c                       |   19 +++++-----
 arch/arm/mach-rpc/irq.c                        |   14 +++----
 arch/arm/mach-s3c2410/bast-irq.c               |    6 +--
 arch/arm/mach-s3c2412/irq.c                    |   12 +++---
 arch/arm/mach-s3c2416/irq.c                    |   10 ++---
 arch/arm/mach-s3c2440/irq.c                    |   10 ++---
 arch/arm/mach-s3c2440/s3c244x-irq.c            |   14 +++----
 arch/arm/mach-s3c2443/irq.c                    |   10 ++---
 arch/arm/mach-s3c64xx/irq-eint.c               |   14 +++----
 arch/arm/mach-sa1100/cerf.c                    |    2 -
 arch/arm/mach-sa1100/irq.c                     |   16 ++++-----
 arch/arm/mach-sa1100/neponset.c                |    8 ++--
 arch/arm/mach-sa1100/pleb.c                    |    2 -
 arch/arm/mach-shark/irq.c                      |    4 +-
 arch/arm/mach-shmobile/board-ap4evb.c          |    4 +-
 arch/arm/mach-shmobile/board-mackerel.c        |    6 +--
 arch/arm/mach-shmobile/intc-sh7367.c           |    6 +--
 arch/arm/mach-shmobile/intc-sh7372.c           |    6 +--
 arch/arm/mach-shmobile/intc-sh7377.c           |    6 +--
 arch/arm/mach-tcc8k/irq.c                      |    6 +--
 arch/arm/mach-tegra/gpio.c                     |   18 +++++-----
 arch/arm/mach-tegra/irq.c                      |    6 +--
 arch/arm/mach-ux500/modem-irq-db5500.c         |    4 +-
 arch/arm/mach-versatile/core.c                 |    6 +--
 arch/arm/mach-vt8500/irq.c                     |    8 ++--
 arch/arm/mach-w90x900/irq.c                    |    4 +-
 arch/arm/plat-mxc/3ds_debugboard.c             |    8 ++--
 arch/arm/plat-mxc/avic.c                       |    4 +-
 arch/arm/plat-mxc/gpio.c                       |   24 +++++++------
 arch/arm/plat-mxc/irq-common.c                 |    4 +-
 arch/arm/plat-mxc/tzic.c                       |    4 +-
 arch/arm/plat-nomadik/gpio.c                   |   34 +++++++++----------
 arch/arm/plat-omap/gpio.c                      |   18 +++++-----
 arch/arm/plat-orion/gpio.c                     |    6 +--
 arch/arm/plat-orion/irq.c                      |    6 +--
 arch/arm/plat-pxa/gpio.c                       |    6 +--
 arch/arm/plat-s3c24xx/irq.c                    |   44 ++++++++++++-------------
 arch/arm/plat-s5p/irq-eint.c                   |    8 ++--
 arch/arm/plat-s5p/irq-gpioint.c                |   22 ++++++------
 arch/arm/plat-samsung/irq-uart.c               |    6 +--
 arch/arm/plat-spear/shirq.c                    |   12 +++---
 arch/arm/plat-stmp3xxx/irq.c                   |    4 +-
 arch/arm/plat-stmp3xxx/pinmux.c                |   10 ++---
 141 files changed, 631 insertions(+), 615 deletions(-)

Index: linux-2.6-tip/arch/arm/common/gic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/gic.c
+++ linux-2.6-tip/arch/arm/common/gic.c
@@ -213,8 +213,8 @@ static int gic_set_wake(struct irq_data 
 
 static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct gic_chip_data *chip_data = get_irq_data(irq);
-	struct irq_chip *chip = get_irq_chip(irq);
+	struct gic_chip_data *chip_data = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_get_chip(irq);
 	unsigned int cascade_irq, gic_irq;
 	unsigned long status;
 
@@ -257,9 +257,9 @@ void __init gic_cascade_irq(unsigned int
 {
 	if (gic_nr >= MAX_GIC_NR)
 		BUG();
-	if (set_irq_data(irq, &gic_data[gic_nr]) != 0)
+	if (irq_set_handler_data(irq, &gic_data[gic_nr]) != 0)
 		BUG();
-	set_irq_chained_handler(irq, gic_handle_cascade_irq);
+	irq_set_chained_handler(irq, gic_handle_cascade_irq);
 }
 
 static void __init gic_dist_init(struct gic_chip_data *gic,
@@ -319,9 +319,9 @@ static void __init gic_dist_init(struct 
 	 * Setup the Linux IRQ subsystem.
 	 */
 	for (i = irq_start; i < irq_limit; i++) {
-		set_irq_chip(i, &gic_chip);
-		set_irq_chip_data(i, gic);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &gic_chip);
+		irq_set_chip_data(i, gic);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/common/it8152.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/it8152.c
+++ linux-2.6-tip/arch/arm/common/it8152.c
@@ -88,8 +88,8 @@ void it8152_init_irq(void)
 	__raw_writel((0), IT8152_INTC_LDCNIRR);
 
 	for (irq = IT8152_IRQ(0); irq <= IT8152_LAST_IRQ; irq++) {
-		set_irq_chip(irq, &it8152_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &it8152_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/common/locomo.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/locomo.c
+++ linux-2.6-tip/arch/arm/common/locomo.c
@@ -140,7 +140,7 @@ static struct locomo_dev_info locomo_dev
 
 static void locomo_handler(unsigned int irq, struct irq_desc *desc)
 {
-	struct locomo *lchip = get_irq_chip_data(irq);
+	struct locomo *lchip = irq_get_chip_data(irq);
 	int req, i;
 
 	/* Acknowledge the parent IRQ */
@@ -197,15 +197,15 @@ static void locomo_setup_irq(struct loco
 	/*
 	 * Install handler for IRQ_LOCOMO_HW.
 	 */
-	set_irq_type(lchip->irq, IRQ_TYPE_EDGE_FALLING);
-	set_irq_chip_data(lchip->irq, lchip);
-	set_irq_chained_handler(lchip->irq, locomo_handler);
+	irq_set_irq_type(lchip->irq, IRQ_TYPE_EDGE_FALLING);
+	irq_set_chip_data(lchip->irq, lchip);
+	irq_set_chained_handler(lchip->irq, locomo_handler);
 
 	/* Install handlers for IRQ_LOCOMO_* */
 	for ( ; irq <= lchip->irq_base + 3; irq++) {
-		set_irq_chip(irq, &locomo_chip);
-		set_irq_chip_data(irq, lchip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &locomo_chip);
+		irq_set_chip_data(irq, lchip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 }
@@ -476,8 +476,8 @@ static void __locomo_remove(struct locom
 	device_for_each_child(lchip->dev, NULL, locomo_remove_child);
 
 	if (lchip->irq != NO_IRQ) {
-		set_irq_chained_handler(lchip->irq, NULL);
-		set_irq_data(lchip->irq, NULL);
+		irq_set_chained_handler(lchip->irq, NULL);
+		irq_set_handler_data(lchip->irq, NULL);
 	}
 
 	iounmap(lchip->base);
Index: linux-2.6-tip/arch/arm/common/sa1111.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/sa1111.c
+++ linux-2.6-tip/arch/arm/common/sa1111.c
@@ -202,7 +202,7 @@ static void
 sa1111_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int stat0, stat1, i;
-	struct sa1111 *sachip = get_irq_data(irq);
+	struct sa1111 *sachip = irq_get_handler_data(irq);
 	void __iomem *mapbase = sachip->base + SA1111_INTC;
 
 	stat0 = sa1111_readl(mapbase + SA1111_INTSTATCLR0);
@@ -472,25 +472,25 @@ static void sa1111_setup_irq(struct sa11
 	sa1111_writel(~0, irqbase + SA1111_INTSTATCLR1);
 
 	for (irq = IRQ_GPAIN0; irq <= SSPROR; irq++) {
-		set_irq_chip(irq, &sa1111_low_chip);
-		set_irq_chip_data(irq, sachip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &sa1111_low_chip);
+		irq_set_chip_data(irq, sachip);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	for (irq = AUDXMTDMADONEA; irq <= IRQ_S1_BVD1_STSCHG; irq++) {
-		set_irq_chip(irq, &sa1111_high_chip);
-		set_irq_chip_data(irq, sachip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &sa1111_high_chip);
+		irq_set_chip_data(irq, sachip);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	/*
 	 * Register SA1111 interrupt
 	 */
-	set_irq_type(sachip->irq, IRQ_TYPE_EDGE_RISING);
-	set_irq_data(sachip->irq, sachip);
-	set_irq_chained_handler(sachip->irq, sa1111_irq_handler);
+	irq_set_irq_type(sachip->irq, IRQ_TYPE_EDGE_RISING);
+	irq_set_handler_data(sachip->irq, sachip);
+	irq_set_chained_handler(sachip->irq, sa1111_irq_handler);
 }
 
 /*
@@ -815,8 +815,8 @@ static void __sa1111_remove(struct sa111
 	clk_disable(sachip->clk);
 
 	if (sachip->irq != NO_IRQ) {
-		set_irq_chained_handler(sachip->irq, NULL);
-		set_irq_data(sachip->irq, NULL);
+		irq_set_chained_handler(sachip->irq, NULL);
+		irq_set_handler_data(sachip->irq, NULL);
 
 		release_mem_region(sachip->phys + SA1111_INTC, 512);
 	}
Index: linux-2.6-tip/arch/arm/common/vic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/vic.c
+++ linux-2.6-tip/arch/arm/common/vic.c
@@ -305,9 +305,9 @@ static void __init vic_set_irq_sources(v
 		if (vic_sources & (1 << i)) {
 			unsigned int irq = irq_start + i;
 
-			set_irq_chip(irq, &vic_chip);
-			set_irq_chip_data(irq, base);
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &vic_chip);
+			irq_set_chip_data(irq, base);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
 	}
Index: linux-2.6-tip/arch/arm/kernel/ecard.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/kernel/ecard.c
+++ linux-2.6-tip/arch/arm/kernel/ecard.c
@@ -1043,8 +1043,8 @@ ecard_probe(int slot, card_type_t type)
 	 */
 	if (slot < 8) {
 		ec->irq = 32 + slot;
-		set_irq_chip(ec->irq, &ecard_chip);
-		set_irq_handler(ec->irq, handle_level_irq);
+		irq_set_chip(ec->irq, &ecard_chip);
+		irq_set_handler(ec->irq, handle_level_irq);
 		set_irq_flags(ec->irq, IRQF_VALID);
 	}
 
@@ -1103,7 +1103,7 @@ static int __init ecard_init(void)
 
 	irqhw = ecard_probeirqhw();
 
-	set_irq_chained_handler(IRQ_EXPANSIONCARD,
+	irq_set_chained_handler(IRQ_EXPANSIONCARD,
 				irqhw ? ecard_irqexp_handler : ecard_irq_handler);
 
 	ecard_proc_init();
Index: linux-2.6-tip/arch/arm/mach-at91/at91cap9_devices.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-at91/at91cap9_devices.c
+++ linux-2.6-tip/arch/arm/mach-at91/at91cap9_devices.c
@@ -72,7 +72,7 @@ void __init at91_add_device_usbh(struct 
 		return;
 
 	if (cpu_is_at91cap9_revB())
-		set_irq_type(AT91CAP9_ID_UHP, IRQ_TYPE_LEVEL_HIGH);
+		irq_set_irq_type(AT91CAP9_ID_UHP, IRQ_TYPE_LEVEL_HIGH);
 
 	/* Enable VBus control for UHP ports */
 	for (i = 0; i < data->ports; i++) {
@@ -157,7 +157,7 @@ static struct platform_device at91_usba_
 void __init at91_add_device_usba(struct usba_platform_data *data)
 {
 	if (cpu_is_at91cap9_revB()) {
-		set_irq_type(AT91CAP9_ID_UDPHS, IRQ_TYPE_LEVEL_HIGH);
+		irq_set_irq_type(AT91CAP9_ID_UDPHS, IRQ_TYPE_LEVEL_HIGH);
 		at91_sys_write(AT91_MATRIX_UDPHS, AT91_MATRIX_SELECT_UDPHS |
 						  AT91_MATRIX_UDPHS_BYPASS_LOCK);
 	}
@@ -861,7 +861,7 @@ void __init at91_add_device_lcdc(struct 
 		return;
 
 	if (cpu_is_at91cap9_revB())
-		set_irq_type(AT91CAP9_ID_LCDC, IRQ_TYPE_LEVEL_HIGH);
+		irq_set_irq_type(AT91CAP9_ID_LCDC, IRQ_TYPE_LEVEL_HIGH);
 
 	at91_set_A_periph(AT91_PIN_PC1, 0);	/* LCDHSYNC */
 	at91_set_A_periph(AT91_PIN_PC2, 0);	/* LCDDOTCK */
Index: linux-2.6-tip/arch/arm/mach-at91/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-at91/gpio.c
+++ linux-2.6-tip/arch/arm/mach-at91/gpio.c
@@ -287,7 +287,7 @@ static int gpio_irq_set_wake(struct irq_
 	else
 		wakeups[bank] &= ~mask;
 
-	set_irq_wake(gpio_chip[bank].bank->id, state);
+	irq_set_irq_wake(gpio_chip[bank].bank->id, state);
 
 	return 0;
 }
@@ -511,8 +511,8 @@ void __init at91_gpio_irq_setup(void)
 			 * Can use the "simple" and not "edge" handler since it's
 			 * shorter, and the AIC handles interrupts sanely.
 			 */
-			set_irq_chip(pin, &gpio_irqchip);
-			set_irq_handler(pin, handle_simple_irq);
+			irq_set_chip(pin, &gpio_irqchip);
+			irq_set_handler(pin, handle_simple_irq);
 			set_irq_flags(pin, IRQF_VALID);
 		}
 
@@ -523,8 +523,8 @@ void __init at91_gpio_irq_setup(void)
 		if (prev && prev->next == this)
 			continue;
 
-		set_irq_chip_data(id, this);
-		set_irq_chained_handler(id, gpio_irq_handler);
+		irq_set_chip_data(id, this);
+		irq_set_chained_handler(id, gpio_irq_handler);
 	}
 	pr_info("AT91: %d gpio irqs in %d banks\n", pin - PIN_BASE, gpio_banks);
 }
Index: linux-2.6-tip/arch/arm/mach-at91/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-at91/irq.c
+++ linux-2.6-tip/arch/arm/mach-at91/irq.c
@@ -143,8 +143,8 @@ void __init at91_aic_init(unsigned int p
 		/* Active Low interrupt, with the specified priority */
 		at91_sys_write(AT91_AIC_SMR(i), AT91_AIC_SRCTYPE_LOW | priority[i]);
 
-		set_irq_chip(i, &at91_aic_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &at91_aic_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 
 		/* Perform 8 End Of Interrupt Command to make sure AIC will not Lock out nIRQ */
Index: linux-2.6-tip/arch/arm/mach-bcmring/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-bcmring/irq.c
+++ linux-2.6-tip/arch/arm/mach-bcmring/irq.c
@@ -93,11 +93,11 @@ static void vic_init(void __iomem *base,
 	unsigned int i;
 	for (i = 0; i < 32; i++) {
 		unsigned int irq = irq_start + i;
-		set_irq_chip(irq, chip);
-		set_irq_chip_data(irq, base);
+		irq_set_chip(irq, chip);
+		irq_set_chip_data(irq, base);
 
 		if (vic_sources & (1 << i)) {
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
 	}
@@ -119,9 +119,9 @@ void __init bcmring_init_irq(void)
 
 	/* special cases */
 	if (INTCHW_INTC1_GPIO0 & IRQ_INTC1_VALID_MASK) {
-		set_irq_handler(IRQ_GPIO0, handle_simple_irq);
+		irq_set_handler(IRQ_GPIO0, handle_simple_irq);
 	}
 	if (INTCHW_INTC1_GPIO1 & IRQ_INTC1_VALID_MASK) {
-		set_irq_handler(IRQ_GPIO1, handle_simple_irq);
+		irq_set_handler(IRQ_GPIO1, handle_simple_irq);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-clps711x/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-clps711x/irq.c
+++ linux-2.6-tip/arch/arm/mach-clps711x/irq.c
@@ -112,13 +112,13 @@ void __init clps711x_init_irq(void)
 
 	for (i = 0; i < NR_IRQS; i++) {
 	        if (INT1_IRQS & (1 << i)) {
-	        	set_irq_handler(i, handle_level_irq);
-	        	set_irq_chip(i, &int1_chip);
+	        	irq_set_handler(i, handle_level_irq);
+	        	irq_set_chip(i, &int1_chip);
 	        	set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 		}
 		if (INT2_IRQS & (1 << i)) {
-			set_irq_handler(i, handle_level_irq);
-			set_irq_chip(i, &int2_chip);
+			irq_set_handler(i, handle_level_irq);
+			irq_set_chip(i, &int2_chip);
 			set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 		}			
 	}
Index: linux-2.6-tip/arch/arm/mach-davinci/cp_intc.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-davinci/cp_intc.c
+++ linux-2.6-tip/arch/arm/mach-davinci/cp_intc.c
@@ -167,9 +167,9 @@ void __init cp_intc_init(void)
 
 	/* Set up genirq dispatching for cp_intc */
 	for (i = 0; i < num_irq; i++) {
-		set_irq_chip(i, &cp_intc_irq_chip);
+		irq_set_chip(i, &cp_intc_irq_chip);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
-		set_irq_handler(i, handle_edge_irq);
+		irq_set_handler(i, handle_edge_irq);
 	}
 
 	/* Enable global interrupt */
Index: linux-2.6-tip/arch/arm/mach-davinci/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-davinci/gpio.c
+++ linux-2.6-tip/arch/arm/mach-davinci/gpio.c
@@ -62,7 +62,7 @@ static inline struct davinci_gpio_regs _
 {
 	struct davinci_gpio_regs __iomem *g;
 
-	g = (__force struct davinci_gpio_regs __iomem *)get_irq_chip_data(irq);
+	g = (__force struct davinci_gpio_regs __iomem *)irq_get_chip_data(irq);
 
 	return g;
 }
@@ -208,7 +208,7 @@ pure_initcall(davinci_gpio_setup);
 static void gpio_irq_disable(struct irq_data *d)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d->irq);
-	u32 mask = (u32) irq_data_get_irq_data(d);
+	u32 mask = (u32) irq_data_get_irq_handler_data(d);
 
 	__raw_writel(mask, &g->clr_falling);
 	__raw_writel(mask, &g->clr_rising);
@@ -217,7 +217,7 @@ static void gpio_irq_disable(struct irq_
 static void gpio_irq_enable(struct irq_data *d)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d->irq);
-	u32 mask = (u32) irq_data_get_irq_data(d);
+	u32 mask = (u32) irq_data_get_irq_handler_data(d);
 	unsigned status = irqd_get_trigger_type(d);
 
 	status &= IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING;
@@ -233,7 +233,7 @@ static void gpio_irq_enable(struct irq_d
 static int gpio_irq_type(struct irq_data *d, unsigned trigger)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d->irq);
-	u32 mask = (u32) irq_data_get_irq_data(d);
+	u32 mask = (u32) irq_data_get_irq_handler_data(d);
 
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
@@ -276,7 +276,7 @@ gpio_irq_handler(unsigned irq, struct ir
 			status >>= 16;
 
 		/* now demux them to the right lowlevel handler */
-		n = (int)get_irq_data(irq);
+		n = (int)irq_get_handler_data(irq);
 		while (status) {
 			res = ffs(status);
 			n += res;
@@ -314,7 +314,7 @@ static int gpio_to_irq_unbanked(struct g
 static int gpio_irq_type_unbanked(struct irq_data *d, unsigned trigger)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d->irq);
-	u32 mask = (u32) irq_data_get_irq_data(d);
+	u32 mask = (u32) irq_data_get_irq_handler_data(d);
 
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
@@ -397,9 +397,9 @@ static int __init davinci_gpio_irq_setup
 
 		/* set the direct IRQs up to use that irqchip */
 		for (gpio = 0; gpio < soc_info->gpio_unbanked; gpio++, irq++) {
-			set_irq_chip(irq, &gpio_irqchip_unbanked);
-			set_irq_data(irq, (void *) __gpio_mask(gpio));
-			set_irq_chip_data(irq, (__force void *) g);
+			irq_set_chip(irq, &gpio_irqchip_unbanked);
+			irq_set_handler_data(irq, (void *)__gpio_mask(gpio));
+			irq_set_chip_data(irq, (__force void *)g);
 			irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
 		}
 
@@ -421,15 +421,15 @@ static int __init davinci_gpio_irq_setup
 		__raw_writel(~0, &g->clr_rising);
 
 		/* set up all irqs in this bank */
-		set_irq_chained_handler(bank_irq, gpio_irq_handler);
-		set_irq_chip_data(bank_irq, (__force void *) g);
-		set_irq_data(bank_irq, (void *) irq);
+		irq_set_chained_handler(bank_irq, gpio_irq_handler);
+		irq_set_chip_data(bank_irq, (__force void *)g);
+		irq_set_handler_data(bank_irq, (void *)irq);
 
 		for (i = 0; i < 16 && gpio < ngpio; i++, irq++, gpio++) {
-			set_irq_chip(irq, &gpio_irqchip);
-			set_irq_chip_data(irq, (__force void *) g);
-			set_irq_data(irq, (void *) __gpio_mask(gpio));
-			set_irq_handler(irq, handle_simple_irq);
+			irq_set_chip(irq, &gpio_irqchip);
+			irq_set_chip_data(irq, (__force void *)g);
+			irq_set_handler_data(irq, (void *)__gpio_mask(gpio));
+			irq_set_handler(irq, handle_simple_irq);
 			set_irq_flags(irq, IRQF_VALID);
 		}
 
Index: linux-2.6-tip/arch/arm/mach-davinci/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-davinci/irq.c
+++ linux-2.6-tip/arch/arm/mach-davinci/irq.c
@@ -154,11 +154,11 @@ void __init davinci_irq_init(void)
 
 	/* set up genirq dispatch for ARM INTC */
 	for (i = 0; i < davinci_soc_info.intc_irq_num; i++) {
-		set_irq_chip(i, &davinci_irq_chip_0);
+		irq_set_chip(i, &davinci_irq_chip_0);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 		if (i != IRQ_TINT1_TINT34)
-			set_irq_handler(i, handle_edge_irq);
+			irq_set_handler(i, handle_edge_irq);
 		else
-			set_irq_handler(i, handle_level_irq);
+			irq_set_handler(i, handle_level_irq);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-dove/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-dove/irq.c
+++ linux-2.6-tip/arch/arm/mach-dove/irq.c
@@ -102,14 +102,14 @@ void __init dove_init_irq(void)
 	 */
 	orion_gpio_init(0, 32, DOVE_GPIO_LO_VIRT_BASE, 0,
 			IRQ_DOVE_GPIO_START);
-	set_irq_chained_handler(IRQ_DOVE_GPIO_0_7, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_DOVE_GPIO_8_15, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_DOVE_GPIO_16_23, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_DOVE_GPIO_24_31, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_DOVE_GPIO_0_7, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_DOVE_GPIO_8_15, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_DOVE_GPIO_16_23, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_DOVE_GPIO_24_31, gpio_irq_handler);
 
 	orion_gpio_init(32, 32, DOVE_GPIO_HI_VIRT_BASE, 0,
 			IRQ_DOVE_GPIO_START + 32);
-	set_irq_chained_handler(IRQ_DOVE_HIGH_GPIO, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_DOVE_HIGH_GPIO, gpio_irq_handler);
 
 	orion_gpio_init(64, 8, DOVE_GPIO2_VIRT_BASE, 0,
 			IRQ_DOVE_GPIO_START + 64);
@@ -121,10 +121,10 @@ void __init dove_init_irq(void)
 	writel(0, PMU_INTERRUPT_CAUSE);
 
 	for (i = IRQ_DOVE_PMU_START; i < NR_IRQS; i++) {
-		set_irq_chip(i, &pmu_irq_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &pmu_irq_chip);
+		irq_set_handler(i, handle_level_irq);
 		irq_set_status_flags(i, IRQ_LEVEL);
 		set_irq_flags(i, IRQF_VALID);
 	}
-	set_irq_chained_handler(IRQ_DOVE_PMU, pmu_irq_handler);
+	irq_set_chained_handler(IRQ_DOVE_PMU, pmu_irq_handler);
 }
Index: linux-2.6-tip/arch/arm/mach-ebsa110/core.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ebsa110/core.c
+++ linux-2.6-tip/arch/arm/mach-ebsa110/core.c
@@ -66,8 +66,8 @@ static void __init ebsa110_init_irq(void
 	local_irq_restore(flags);
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
-		set_irq_chip(irq, &ebsa110_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &ebsa110_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ep93xx/gpio.c
+++ linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
@@ -231,20 +231,29 @@ void __init ep93xx_gpio_init_irq(void)
 
 	for (gpio_irq = gpio_to_irq(0);
 	     gpio_irq <= gpio_to_irq(EP93XX_GPIO_LINE_MAX_IRQ); ++gpio_irq) {
-		set_irq_chip(gpio_irq, &ep93xx_gpio_irq_chip);
-		set_irq_handler(gpio_irq, handle_level_irq);
+		irq_set_chip(gpio_irq, &ep93xx_gpio_irq_chip);
+		irq_set_handler(gpio_irq, handle_level_irq);
 		set_irq_flags(gpio_irq, IRQF_VALID);
 	}
 
-	set_irq_chained_handler(IRQ_EP93XX_GPIO_AB, ep93xx_gpio_ab_irq_handler);
-	set_irq_chained_handler(IRQ_EP93XX_GPIO0MUX, ep93xx_gpio_f_irq_handler);
-	set_irq_chained_handler(IRQ_EP93XX_GPIO1MUX, ep93xx_gpio_f_irq_handler);
-	set_irq_chained_handler(IRQ_EP93XX_GPIO2MUX, ep93xx_gpio_f_irq_handler);
-	set_irq_chained_handler(IRQ_EP93XX_GPIO3MUX, ep93xx_gpio_f_irq_handler);
-	set_irq_chained_handler(IRQ_EP93XX_GPIO4MUX, ep93xx_gpio_f_irq_handler);
-	set_irq_chained_handler(IRQ_EP93XX_GPIO5MUX, ep93xx_gpio_f_irq_handler);
-	set_irq_chained_handler(IRQ_EP93XX_GPIO6MUX, ep93xx_gpio_f_irq_handler);
-	set_irq_chained_handler(IRQ_EP93XX_GPIO7MUX, ep93xx_gpio_f_irq_handler);
+	irq_set_chained_handler(IRQ_EP93XX_GPIO_AB,
+				ep93xx_gpio_ab_irq_handler);
+	irq_set_chained_handler(IRQ_EP93XX_GPIO0MUX,
+				ep93xx_gpio_f_irq_handler);
+	irq_set_chained_handler(IRQ_EP93XX_GPIO1MUX,
+				ep93xx_gpio_f_irq_handler);
+	irq_set_chained_handler(IRQ_EP93XX_GPIO2MUX,
+				ep93xx_gpio_f_irq_handler);
+	irq_set_chained_handler(IRQ_EP93XX_GPIO3MUX,
+				ep93xx_gpio_f_irq_handler);
+	irq_set_chained_handler(IRQ_EP93XX_GPIO4MUX,
+				ep93xx_gpio_f_irq_handler);
+	irq_set_chained_handler(IRQ_EP93XX_GPIO5MUX,
+				ep93xx_gpio_f_irq_handler);
+	irq_set_chained_handler(IRQ_EP93XX_GPIO6MUX,
+				ep93xx_gpio_f_irq_handler);
+	irq_set_chained_handler(IRQ_EP93XX_GPIO7MUX,
+				ep93xx_gpio_f_irq_handler);
 }
 
 
Index: linux-2.6-tip/arch/arm/mach-exynos4/irq-combiner.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-exynos4/irq-combiner.c
+++ linux-2.6-tip/arch/arm/mach-exynos4/irq-combiner.c
@@ -54,8 +54,8 @@ static void combiner_unmask_irq(struct i
 
 static void combiner_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct combiner_chip_data *chip_data = get_irq_data(irq);
-	struct irq_chip *chip = get_irq_chip(irq);
+	struct combiner_chip_data *chip_data = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_get_chip(irq);
 	unsigned int cascade_irq, combiner_irq;
 	unsigned long status;
 
@@ -93,9 +93,9 @@ void __init combiner_cascade_irq(unsigne
 {
 	if (combiner_nr >= MAX_COMBINER_NR)
 		BUG();
-	if (set_irq_data(irq, &combiner_data[combiner_nr]) != 0)
+	if (irq_set_handler_data(irq, &combiner_data[combiner_nr]) != 0)
 		BUG();
-	set_irq_chained_handler(irq, combiner_handle_cascade_irq);
+	irq_set_chained_handler(irq, combiner_handle_cascade_irq);
 }
 
 void __init combiner_init(unsigned int combiner_nr, void __iomem *base,
@@ -119,9 +119,9 @@ void __init combiner_init(unsigned int c
 
 	for (i = irq_start; i < combiner_data[combiner_nr].irq_offset
 				+ MAX_IRQ_IN_COMBINER; i++) {
-		set_irq_chip(i, &combiner_chip);
-		set_irq_chip_data(i, &combiner_data[combiner_nr]);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &combiner_chip);
+		irq_set_chip_data(i, &combiner_data[combiner_nr]);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-exynos4/irq-eint.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-exynos4/irq-eint.c
+++ linux-2.6-tip/arch/arm/mach-exynos4/irq-eint.c
@@ -190,8 +190,8 @@ static void exynos4_irq_demux_eint16_31(
 
 static void exynos4_irq_eint0_15(unsigned int irq, struct irq_desc *desc)
 {
-	u32 *irq_data = get_irq_data(irq);
-	struct irq_chip *chip = get_irq_chip(irq);
+	u32 *irq_data = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_get_chip(irq);
 
 	chip->irq_mask(&desc->irq_data);
 
@@ -208,18 +208,19 @@ int __init exynos4_init_irq_eint(void)
 	int irq;
 
 	for (irq = 0 ; irq <= 31 ; irq++) {
-		set_irq_chip(IRQ_EINT(irq), &exynos4_irq_eint);
-		set_irq_handler(IRQ_EINT(irq), handle_level_irq);
+		irq_set_chip(IRQ_EINT(irq), &exynos4_irq_eint);
+		irq_set_handler(IRQ_EINT(irq), handle_level_irq);
 		set_irq_flags(IRQ_EINT(irq), IRQF_VALID);
 	}
 
-	set_irq_chained_handler(IRQ_EINT16_31, exynos4_irq_demux_eint16_31);
+	irq_set_chained_handler(IRQ_EINT16_31, exynos4_irq_demux_eint16_31);
 
 	for (irq = 0 ; irq <= 15 ; irq++) {
 		eint0_15_data[irq] = IRQ_EINT(irq);
 
-		set_irq_data(exynos4_get_irq_nr(irq), &eint0_15_data[irq]);
-		set_irq_chained_handler(exynos4_get_irq_nr(irq),
+		irq_set_handler_data(exynos4_get_irq_nr(irq),
+				     &eint0_15_data[irq]);
+		irq_set_chained_handler(exynos4_get_irq_nr(irq),
 					exynos4_irq_eint0_15);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-footbridge/common.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-footbridge/common.c
+++ linux-2.6-tip/arch/arm/mach-footbridge/common.c
@@ -102,8 +102,8 @@ static void __init __fb_init_irq(void)
 	*CSR_FIQ_DISABLE = -1;
 
 	for (irq = _DC21285_IRQ(0); irq < _DC21285_IRQ(20); irq++) {
-		set_irq_chip(irq, &fb_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &fb_chip);
+		irq_set_handler(irq, handle_level_irq);
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
-			set_irq_chip(irq, &isa_lo_chip);
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &isa_lo_chip);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
 
 		for (irq = _ISA_IRQ(8); irq < _ISA_IRQ(16); irq++) {
-			set_irq_chip(irq, &isa_hi_chip);
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &isa_hi_chip);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
 
@@ -166,7 +166,7 @@ void __init isa_init_irq(unsigned int ho
 		request_resource(&ioport_resource, &pic2_resource);
 		setup_irq(IRQ_ISA_CASCADE, &irq_cascade);
 
-		set_irq_chained_handler(host_irq, isa_irq_handler);
+		irq_set_chained_handler(host_irq, isa_irq_handler);
 
 		/*
 		 * On the NetWinder, don't automatically
Index: linux-2.6-tip/arch/arm/mach-gemini/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-gemini/gpio.c
+++ linux-2.6-tip/arch/arm/mach-gemini/gpio.c
@@ -217,13 +217,13 @@ void __init gemini_gpio_init(void)
 
 		for (j = GPIO_IRQ_BASE + i * 32;
 		     j < GPIO_IRQ_BASE + (i + 1) * 32; j++) {
-			set_irq_chip(j, &gpio_irq_chip);
-			set_irq_handler(j, handle_edge_irq);
+			irq_set_chip(j, &gpio_irq_chip);
+			irq_set_handler(j, handle_edge_irq);
 			set_irq_flags(j, IRQF_VALID);
 		}
 
-		set_irq_chained_handler(IRQ_GPIO(i), gpio_irq_handler);
-		set_irq_data(IRQ_GPIO(i), (void *)i);
+		irq_set_chained_handler(IRQ_GPIO(i), gpio_irq_handler);
+		irq_set_handler_data(IRQ_GPIO(i), (void *)i);
 	}
 
 	BUG_ON(gpiochip_add(&gemini_gpio_chip));
Index: linux-2.6-tip/arch/arm/mach-gemini/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-gemini/irq.c
+++ linux-2.6-tip/arch/arm/mach-gemini/irq.c
@@ -81,13 +81,13 @@ void __init gemini_init_irq(void)
 	request_resource(&iomem_resource, &irq_resource);
 
 	for (i = 0; i < NR_IRQS; i++) {
-		set_irq_chip(i, &gemini_irq_chip);
+		irq_set_chip(i, &gemini_irq_chip);
 		if((i >= IRQ_TIMER1 && i <= IRQ_TIMER3) || (i >= IRQ_SERIRQ0 && i <= IRQ_SERIRQ1)) {
-			set_irq_handler(i, handle_edge_irq);
+			irq_set_handler(i, handle_edge_irq);
 			mode |= 1 << i;
 			level |= 1 << i;
 		} else {			
-			set_irq_handler(i, handle_level_irq);
+			irq_set_handler(i, handle_level_irq);
 		}
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
Index: linux-2.6-tip/arch/arm/mach-h720x/common.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-h720x/common.c
+++ linux-2.6-tip/arch/arm/mach-h720x/common.c
@@ -199,29 +199,29 @@ void __init h720x_init_irq (void)
 
 	/* Initialize global IRQ's, fast path */
 	for (irq = 0; irq < NR_GLBL_IRQS; irq++) {
-		set_irq_chip(irq, &h720x_global_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &h720x_global_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	/* Initialize multiplexed IRQ's, slow path */
 	for (irq = IRQ_CHAINED_GPIOA(0) ; irq <= IRQ_CHAINED_GPIOD(31); irq++) {
-		set_irq_chip(irq, &h720x_gpio_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &h720x_gpio_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID );
 	}
-	set_irq_chained_handler(IRQ_GPIOA, h720x_gpioa_demux_handler);
-	set_irq_chained_handler(IRQ_GPIOB, h720x_gpiob_demux_handler);
-	set_irq_chained_handler(IRQ_GPIOC, h720x_gpioc_demux_handler);
-	set_irq_chained_handler(IRQ_GPIOD, h720x_gpiod_demux_handler);
+	irq_set_chained_handler(IRQ_GPIOA, h720x_gpioa_demux_handler);
+	irq_set_chained_handler(IRQ_GPIOB, h720x_gpiob_demux_handler);
+	irq_set_chained_handler(IRQ_GPIOC, h720x_gpioc_demux_handler);
+	irq_set_chained_handler(IRQ_GPIOD, h720x_gpiod_demux_handler);
 
 #ifdef CONFIG_CPU_H7202
 	for (irq = IRQ_CHAINED_GPIOE(0) ; irq <= IRQ_CHAINED_GPIOE(31); irq++) {
-		set_irq_chip(irq, &h720x_gpio_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &h720x_gpio_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID );
 	}
-	set_irq_chained_handler(IRQ_GPIOE, h720x_gpioe_demux_handler);
+	irq_set_chained_handler(IRQ_GPIOE, h720x_gpioe_demux_handler);
 #endif
 
 	/* Enable multiplexed irq's */
Index: linux-2.6-tip/arch/arm/mach-h720x/cpu-h7202.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-h720x/cpu-h7202.c
+++ linux-2.6-tip/arch/arm/mach-h720x/cpu-h7202.c
@@ -197,11 +197,11 @@ void __init h7202_init_irq (void)
 	for (irq = IRQ_TIMER1;
 	                  irq < IRQ_CHAINED_TIMERX(NR_TIMERX_IRQS); irq++) {
 		mask_timerx_irq(irq);
-		set_irq_chip(irq, &h7202_timerx_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &h7202_timerx_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID );
 	}
-	set_irq_chained_handler(IRQ_TIMERX, h7202_timerx_demux_handler);
+	irq_set_chained_handler(IRQ_TIMERX, h7202_timerx_demux_handler);
 
 	h720x_init_irq();
 }
Index: linux-2.6-tip/arch/arm/mach-integrator/integrator_ap.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-integrator/integrator_ap.c
+++ linux-2.6-tip/arch/arm/mach-integrator/integrator_ap.c
@@ -187,8 +187,8 @@ static void __init ap_init_irq(void)
 
 	for (i = 0; i < NR_IRQS; i++) {
 		if (((1 << i) & INTEGRATOR_SC_VALID_INT) != 0) {
-			set_irq_chip(i, &sc_chip);
-			set_irq_handler(i, handle_level_irq);
+			irq_set_chip(i, &sc_chip);
+			irq_set_handler(i, handle_level_irq);
 			set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 		}
 	}
Index: linux-2.6-tip/arch/arm/mach-integrator/integrator_cp.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-integrator/integrator_cp.c
+++ linux-2.6-tip/arch/arm/mach-integrator/integrator_cp.c
@@ -238,8 +238,8 @@ static void __init intcp_init_irq(void)
 			i = 22;
 		if (i == 29)
 			break;
-		set_irq_chip(i, &pic_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &pic_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
@@ -247,8 +247,8 @@ static void __init intcp_init_irq(void)
 	cic_writel(0xffffffff, INTCP_VA_CIC_BASE + FIQ_ENABLE_CLEAR);
 
 	for (i = IRQ_CIC_START; i <= IRQ_CIC_END; i++) {
-		set_irq_chip(i, &cic_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &cic_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
@@ -256,12 +256,12 @@ static void __init intcp_init_irq(void)
 	sic_writel(0x00000fff, INTCP_VA_SIC_BASE + FIQ_ENABLE_CLEAR);
 
 	for (i = IRQ_SIC_START; i <= IRQ_SIC_END; i++) {
-		set_irq_chip(i, &sic_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &sic_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
-	set_irq_chained_handler(IRQ_CP_CPPLDINT, sic_handle_irq);
+	irq_set_chained_handler(IRQ_CP_CPPLDINT, sic_handle_irq);
 }
 
 /*
Index: linux-2.6-tip/arch/arm/mach-iop13xx/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-iop13xx/irq.c
+++ linux-2.6-tip/arch/arm/mach-iop13xx/irq.c
@@ -224,15 +224,15 @@ void __init iop13xx_init_irq(void)
 
 	for(i = 0; i <= IRQ_IOP13XX_HPI; i++) {
 		if (i < 32)
-			set_irq_chip(i, &iop13xx_irqchip1);
+			irq_set_chip(i, &iop13xx_irqchip1);
 		else if (i < 64)
-			set_irq_chip(i, &iop13xx_irqchip2);
+			irq_set_chip(i, &iop13xx_irqchip2);
 		else if (i < 96)
-			set_irq_chip(i, &iop13xx_irqchip3);
+			irq_set_chip(i, &iop13xx_irqchip3);
 		else
-			set_irq_chip(i, &iop13xx_irqchip4);
+			irq_set_chip(i, &iop13xx_irqchip4);
 
-		set_irq_handler(i, handle_level_irq);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-iop13xx/msi.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-iop13xx/msi.c
+++ linux-2.6-tip/arch/arm/mach-iop13xx/msi.c
@@ -118,7 +118,7 @@ static void iop13xx_msi_handler(unsigned
 
 void __init iop13xx_msi_init(void)
 {
-	set_irq_chained_handler(IRQ_IOP13XX_INBD_MSI, iop13xx_msi_handler);
+	irq_set_chained_handler(IRQ_IOP13XX_INBD_MSI, iop13xx_msi_handler);
 }
 
 /*
@@ -178,7 +178,7 @@ int arch_setup_msi_irq(struct pci_dev *p
 	if (irq < 0)
 		return irq;
 
-	set_irq_msi(irq, desc);
+	irq_set_msi_desc(irq, desc);
 
 	msg.address_hi = 0x0;
 	msg.address_lo = IOP13XX_MU_MIMR_PCI;
@@ -187,7 +187,7 @@ int arch_setup_msi_irq(struct pci_dev *p
 	msg.data = (id << IOP13XX_MU_MIMR_CORE_SELECT) | (irq & 0x7f);
 
 	write_msi_msg(irq, &msg);
-	set_irq_chip_and_handler(irq, &iop13xx_msi_chip, handle_simple_irq);
+	irq_set_chip_and_handler(irq, &iop13xx_msi_chip, handle_simple_irq);
 
 	return 0;
 }
Index: linux-2.6-tip/arch/arm/mach-iop32x/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-iop32x/irq.c
+++ linux-2.6-tip/arch/arm/mach-iop32x/irq.c
@@ -68,8 +68,8 @@ void __init iop32x_init_irq(void)
 		*IOP3XX_PCIIRSR = 0x0f;
 
 	for (i = 0; i < NR_IRQS; i++) {
-		set_irq_chip(i, &ext_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &ext_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-iop33x/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-iop33x/irq.c
+++ linux-2.6-tip/arch/arm/mach-iop33x/irq.c
@@ -110,8 +110,9 @@ void __init iop33x_init_irq(void)
 		*IOP3XX_PCIIRSR = 0x0f;
 
 	for (i = 0; i < NR_IRQS; i++) {
-		set_irq_chip(i, (i < 32) ? &iop33x_irqchip1 : &iop33x_irqchip2);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i,
+			     (i < 32) ? &iop33x_irqchip1 : &iop33x_irqchip2);
+		irq_set_handler(i, handle_level_irq);
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
-			set_irq_chip(irq, &ixp2000_irq_chip);
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &ixp2000_irq_chip);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID);
 		} else set_irq_flags(irq, 0);
 	}
@@ -485,21 +485,21 @@ void __init ixp2000_init_irq(void)
 	for (irq = IRQ_IXP2000_DRAM0_MIN_ERR; irq <= IRQ_IXP2000_SP_INT; irq++) {
 		if((1 << (irq - IRQ_IXP2000_DRAM0_MIN_ERR)) &
 				IXP2000_VALID_ERR_IRQ_MASK) {
-			set_irq_chip(irq, &ixp2000_err_irq_chip);
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &ixp2000_err_irq_chip);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID);
 		}
 		else
 			set_irq_flags(irq, 0);
 	}
-	set_irq_chained_handler(IRQ_IXP2000_ERRSUM, ixp2000_err_irq_handler);
+	irq_set_chained_handler(IRQ_IXP2000_ERRSUM, ixp2000_err_irq_handler);
 
 	for (irq = IRQ_IXP2000_GPIO0; irq <= IRQ_IXP2000_GPIO7; irq++) {
-		set_irq_chip(irq, &ixp2000_GPIO_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &ixp2000_GPIO_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
-	set_irq_chained_handler(IRQ_IXP2000_GPIO, ixp2000_GPIO_irq_handler);
+	irq_set_chained_handler(IRQ_IXP2000_GPIO, ixp2000_GPIO_irq_handler);
 
 	/*
 	 * Enable PCI irqs.  The actual PCI[AB] decoding is done in
@@ -508,8 +508,8 @@ void __init ixp2000_init_irq(void)
 	 */
 	ixp2000_reg_write(IXP2000_IRQ_ENABLE_SET, (1 << IRQ_IXP2000_PCI));
 	for (irq = IRQ_IXP2000_PCIA; irq <= IRQ_IXP2000_PCIB; irq++) {
-		set_irq_chip(irq, &ixp2000_pci_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &ixp2000_pci_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-ixp2000/ixdp2x00.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp2000/ixdp2x00.c
+++ linux-2.6-tip/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -158,13 +158,13 @@ void __init ixdp2x00_init_irq(volatile u
 	*board_irq_mask = 0xffffffff;
 
 	for(irq = IXP2000_BOARD_IRQ(0); irq < IXP2000_BOARD_IRQ(board_irq_count); irq++) {
-		set_irq_chip(irq, &ixdp2x00_cpld_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &ixdp2x00_cpld_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
 	/* Hook into PCI interrupt */
-	set_irq_chained_handler(IRQ_IXP2000_PCIB, ixdp2x00_irq_handler);
+	irq_set_chained_handler(IRQ_IXP2000_PCIB, ixdp2x00_irq_handler);
 }
 
 /*************************************************************************
Index: linux-2.6-tip/arch/arm/mach-ixp2000/ixdp2x01.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp2000/ixdp2x01.c
+++ linux-2.6-tip/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -115,8 +115,8 @@ void __init ixdp2x01_init_irq(void)
 
 	for (irq = NR_IXP2000_IRQS; irq < NR_IXDP2X01_IRQS; irq++) {
 		if (irq & valid_irq_mask) {
-			set_irq_chip(irq, &ixdp2x01_irq_chip);
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &ixdp2x01_irq_chip);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID);
 		} else {
 			set_irq_flags(irq, 0);
@@ -124,7 +124,7 @@ void __init ixdp2x01_init_irq(void)
 	}
 
 	/* Hook into PCI interrupts */
-	set_irq_chained_handler(IRQ_IXP2000_PCIB, ixdp2x01_irq_handler);
+	irq_set_chained_handler(IRQ_IXP2000_PCIB, ixdp2x01_irq_handler);
 }
 
 
Index: linux-2.6-tip/arch/arm/mach-ixp23xx/core.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp23xx/core.c
+++ linux-2.6-tip/arch/arm/mach-ixp23xx/core.c
@@ -289,12 +289,12 @@ static void ixp23xx_config_irq(unsigned 
 {
 	switch (type) {
 	case IXP23XX_IRQ_LEVEL:
-		set_irq_chip(irq, &ixp23xx_irq_level_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &ixp23xx_irq_level_chip);
+		irq_set_handler(irq, handle_level_irq);
 		break;
 	case IXP23XX_IRQ_EDGE:
-		set_irq_chip(irq, &ixp23xx_irq_edge_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &ixp23xx_irq_edge_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		break;
 	}
 	set_irq_flags(irq, IRQF_VALID);
@@ -324,12 +324,12 @@ void __init ixp23xx_init_irq(void)
 	}
 
 	for (irq = IRQ_IXP23XX_INTA; irq <= IRQ_IXP23XX_INTB; irq++) {
-		set_irq_chip(irq, &ixp23xx_pci_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &ixp23xx_pci_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
-	set_irq_chained_handler(IRQ_IXP23XX_PCI_INT_RPH, pci_handler);
+	irq_set_chained_handler(IRQ_IXP23XX_PCI_INT_RPH, pci_handler);
 }
 
 
Index: linux-2.6-tip/arch/arm/mach-ixp23xx/ixdp2351.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp23xx/ixdp2351.c
+++ linux-2.6-tip/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -136,8 +136,8 @@ void __init ixdp2351_init_irq(void)
 	     irq++) {
 		if (IXDP2351_INTA_IRQ_MASK(irq) & IXDP2351_INTA_IRQ_VALID) {
 			set_irq_flags(irq, IRQF_VALID);
-			set_irq_handler(irq, handle_level_irq);
-			set_irq_chip(irq, &ixdp2351_inta_chip);
+			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &ixdp2351_inta_chip);
 		}
 	}
 
@@ -147,13 +147,13 @@ void __init ixdp2351_init_irq(void)
 	     irq++) {
 		if (IXDP2351_INTB_IRQ_MASK(irq) & IXDP2351_INTB_IRQ_VALID) {
 			set_irq_flags(irq, IRQF_VALID);
-			set_irq_handler(irq, handle_level_irq);
-			set_irq_chip(irq, &ixdp2351_intb_chip);
+			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &ixdp2351_intb_chip);
 		}
 	}
 
-	set_irq_chained_handler(IRQ_IXP23XX_INTA, ixdp2351_inta_handler);
-	set_irq_chained_handler(IRQ_IXP23XX_INTB, ixdp2351_intb_handler);
+	irq_set_chained_handler(IRQ_IXP23XX_INTA, ixdp2351_inta_handler);
+	irq_set_chained_handler(IRQ_IXP23XX_INTB, ixdp2351_intb_handler);
 }
 
 /*
Index: linux-2.6-tip/arch/arm/mach-ixp23xx/roadrunner.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp23xx/roadrunner.c
+++ linux-2.6-tip/arch/arm/mach-ixp23xx/roadrunner.c
@@ -110,8 +110,8 @@ static int __init roadrunner_map_irq(str
 
 static void __init roadrunner_pci_preinit(void)
 {
-	set_irq_type(IRQ_ROADRUNNER_PCI_INTC, IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IRQ_ROADRUNNER_PCI_INTD, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ_ROADRUNNER_PCI_INTC, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ_ROADRUNNER_PCI_INTD, IRQ_TYPE_LEVEL_LOW);
 
 	ixp23xx_pci_preinit();
 }
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/avila-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/avila-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/avila-pci.c
@@ -39,10 +39,10 @@
 
 void __init avila_pci_preinit(void)
 {
-	set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTD), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTD), IRQ_TYPE_LEVEL_LOW);
 	ixp4xx_pci_preinit();
 }
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/common.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/common.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/common.c
@@ -252,8 +252,8 @@ void __init ixp4xx_init_irq(void)
 
         /* Default to all level triggered */
 	for(i = 0; i < NR_IRQS; i++) {
-		set_irq_chip(i, &ixp4xx_irq_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &ixp4xx_irq_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/coyote-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/coyote-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/coyote-pci.c
@@ -32,8 +32,8 @@
 
 void __init coyote_pci_preinit(void)
 {
-	set_irq_type(IXP4XX_GPIO_IRQ(SLOT0_INTA), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(SLOT1_INTA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(SLOT0_INTA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(SLOT1_INTA), IRQ_TYPE_LEVEL_LOW);
 	ixp4xx_pci_preinit();
 }
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/dsmg600-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/dsmg600-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/dsmg600-pci.c
@@ -35,12 +35,12 @@
 
 void __init dsmg600_pci_preinit(void)
 {
-	set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTD), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTE), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTF), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTD), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTE), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTF), IRQ_TYPE_LEVEL_LOW);
 	ixp4xx_pci_preinit();
 }
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/fsg-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/fsg-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/fsg-pci.c
@@ -32,9 +32,9 @@
 
 void __init fsg_pci_preinit(void)
 {
-	set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
 	ixp4xx_pci_preinit();
 }
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/gateway7001-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/gateway7001-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/gateway7001-pci.c
@@ -29,8 +29,8 @@
 
 void __init gateway7001_pci_preinit(void)
 {
-	set_irq_type(IRQ_IXP4XX_GPIO10, IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IRQ_IXP4XX_GPIO11, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ_IXP4XX_GPIO10, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ_IXP4XX_GPIO11, IRQ_TYPE_LEVEL_LOW);
 
 	ixp4xx_pci_preinit();
 }
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/goramo_mlr.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/goramo_mlr.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/goramo_mlr.c
@@ -420,8 +420,8 @@ static void __init gmlr_init(void)
 	gpio_line_config(GPIO_HSS1_RTS_N, IXP4XX_GPIO_OUT);
 	gpio_line_config(GPIO_HSS0_DCD_N, IXP4XX_GPIO_IN);
 	gpio_line_config(GPIO_HSS1_DCD_N, IXP4XX_GPIO_IN);
-	set_irq_type(IXP4XX_GPIO_IRQ(GPIO_HSS0_DCD_N), IRQ_TYPE_EDGE_BOTH);
-	set_irq_type(IXP4XX_GPIO_IRQ(GPIO_HSS1_DCD_N), IRQ_TYPE_EDGE_BOTH);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(GPIO_HSS0_DCD_N), IRQ_TYPE_EDGE_BOTH);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(GPIO_HSS1_DCD_N), IRQ_TYPE_EDGE_BOTH);
 
 	set_control(CONTROL_HSS0_DTR_N, 1);
 	set_control(CONTROL_HSS1_DTR_N, 1);
@@ -441,10 +441,10 @@ static void __init gmlr_init(void)
 #ifdef CONFIG_PCI
 static void __init gmlr_pci_preinit(void)
 {
-	set_irq_type(IXP4XX_GPIO_IRQ(GPIO_IRQ_ETHA), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(GPIO_IRQ_ETHB), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(GPIO_IRQ_NEC), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(GPIO_IRQ_MPCI), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(GPIO_IRQ_ETHA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(GPIO_IRQ_ETHB), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(GPIO_IRQ_NEC), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(GPIO_IRQ_MPCI), IRQ_TYPE_LEVEL_LOW);
 	ixp4xx_pci_preinit();
 }
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/gtwx5715-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/gtwx5715-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/gtwx5715-pci.c
@@ -43,8 +43,8 @@
  */
 void __init gtwx5715_pci_preinit(void)
 {
-	set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
 	ixp4xx_pci_preinit();
 }
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/ixdp425-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/ixdp425-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/ixdp425-pci.c
@@ -36,10 +36,10 @@
 
 void __init ixdp425_pci_preinit(void)
 {
-	set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTD), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTD), IRQ_TYPE_LEVEL_LOW);
 	ixp4xx_pci_preinit();
 }
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/ixdpg425-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/ixdpg425-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/ixdpg425-pci.c
@@ -25,8 +25,8 @@
 
 void __init ixdpg425_pci_preinit(void)
 {
-	set_irq_type(IRQ_IXP4XX_GPIO6, IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IRQ_IXP4XX_GPIO7, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ_IXP4XX_GPIO6, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ_IXP4XX_GPIO7, IRQ_TYPE_LEVEL_LOW);
 
 	ixp4xx_pci_preinit();
 }
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/nas100d-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/nas100d-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/nas100d-pci.c
@@ -33,11 +33,11 @@
 
 void __init nas100d_pci_preinit(void)
 {
-	set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTD), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTE), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTD), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTE), IRQ_TYPE_LEVEL_LOW);
 	ixp4xx_pci_preinit();
 }
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/nslu2-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/nslu2-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/nslu2-pci.c
@@ -32,9 +32,9 @@
 
 void __init nslu2_pci_preinit(void)
 {
-	set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTC), IRQ_TYPE_LEVEL_LOW);
 	ixp4xx_pci_preinit();
 }
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/vulcan-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/vulcan-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/vulcan-pci.c
@@ -38,8 +38,8 @@ void __init vulcan_pci_preinit(void)
 	pr_info("Vulcan PCI: limiting CardBus memory size to %dMB\n",
 		(int)(pci_cardbus_mem_size >> 20));
 #endif
-	set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTA), IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IXP4XX_GPIO_IRQ(INTB), IRQ_TYPE_LEVEL_LOW);
 	ixp4xx_pci_preinit();
 }
 
Index: linux-2.6-tip/arch/arm/mach-ixp4xx/wg302v2-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ixp4xx/wg302v2-pci.c
+++ linux-2.6-tip/arch/arm/mach-ixp4xx/wg302v2-pci.c
@@ -29,8 +29,8 @@
 
 void __init wg302v2_pci_preinit(void)
 {
-	set_irq_type(IRQ_IXP4XX_GPIO8, IRQ_TYPE_LEVEL_LOW);
-	set_irq_type(IRQ_IXP4XX_GPIO9, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ_IXP4XX_GPIO8, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ_IXP4XX_GPIO9, IRQ_TYPE_LEVEL_LOW);
 
 	ixp4xx_pci_preinit();
 }
Index: linux-2.6-tip/arch/arm/mach-kirkwood/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-kirkwood/irq.c
+++ linux-2.6-tip/arch/arm/mach-kirkwood/irq.c
@@ -35,14 +35,15 @@ void __init kirkwood_init_irq(void)
 	 */
 	orion_gpio_init(0, 32, GPIO_LOW_VIRT_BASE, 0,
 			IRQ_KIRKWOOD_GPIO_START);
-	set_irq_chained_handler(IRQ_KIRKWOOD_GPIO_LOW_0_7, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_KIRKWOOD_GPIO_LOW_8_15, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_KIRKWOOD_GPIO_LOW_16_23, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_KIRKWOOD_GPIO_LOW_24_31, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_KIRKWOOD_GPIO_LOW_0_7, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_KIRKWOOD_GPIO_LOW_8_15, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_KIRKWOOD_GPIO_LOW_16_23, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_KIRKWOOD_GPIO_LOW_24_31, gpio_irq_handler);
 
 	orion_gpio_init(32, 18, GPIO_HIGH_VIRT_BASE, 0,
 			IRQ_KIRKWOOD_GPIO_START + 32);
-	set_irq_chained_handler(IRQ_KIRKWOOD_GPIO_HIGH_0_7, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_KIRKWOOD_GPIO_HIGH_8_15, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_KIRKWOOD_GPIO_HIGH_16_23, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_KIRKWOOD_GPIO_HIGH_0_7, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_KIRKWOOD_GPIO_HIGH_8_15, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_KIRKWOOD_GPIO_HIGH_16_23,
+				gpio_irq_handler);
 }
Index: linux-2.6-tip/arch/arm/mach-ks8695/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ks8695/gpio.c
+++ linux-2.6-tip/arch/arm/mach-ks8695/gpio.c
@@ -80,7 +80,7 @@ int ks8695_gpio_interrupt(unsigned int p
 	local_irq_restore(flags);
 
 	/* Set IRQ triggering type */
-	set_irq_type(gpio_irq[pin], type);
+	irq_set_irq_type(gpio_irq[pin], type);
 
 	/* enable interrupt mode */
 	ks8695_gpio_mode(pin, 0);
Index: linux-2.6-tip/arch/arm/mach-ks8695/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ks8695/irq.c
+++ linux-2.6-tip/arch/arm/mach-ks8695/irq.c
@@ -115,12 +115,12 @@ static int ks8695_irq_set_type(struct ir
 	}
 
 	if (level_triggered) {
-		set_irq_chip(d->irq, &ks8695_irq_level_chip);
-		set_irq_handler(d->irq, handle_level_irq);
+		irq_set_chip(d->irq, &ks8695_irq_level_chip);
+		irq_set_handler(d->irq, handle_level_irq);
 	}
 	else {
-		set_irq_chip(d->irq, &ks8695_irq_edge_chip);
-		set_irq_handler(d->irq, handle_edge_irq);
+		irq_set_chip(d->irq, &ks8695_irq_edge_chip);
+		irq_set_handler(d->irq, handle_edge_irq);
 	}
 
 	__raw_writel(ctrl, KS8695_GPIO_VA + KS8695_IOPC);
@@ -158,16 +158,16 @@ void __init ks8695_init_irq(void)
 			case KS8695_IRQ_UART_RX:
 			case KS8695_IRQ_COMM_TX:
 			case KS8695_IRQ_COMM_RX:
-				set_irq_chip(irq, &ks8695_irq_level_chip);
-				set_irq_handler(irq, handle_level_irq);
+				irq_set_chip(irq, &ks8695_irq_level_chip);
+				irq_set_handler(irq, handle_level_irq);
 				break;
 
 			/* Edge-triggered interrupts */
 			default:
 				/* clear pending bit */
 				ks8695_irq_ack(irq_get_irq_data(irq));
-				set_irq_chip(irq, &ks8695_irq_edge_chip);
-				set_irq_handler(irq, handle_edge_irq);
+				irq_set_chip(irq, &ks8695_irq_edge_chip);
+				irq_set_handler(irq, handle_edge_irq);
 		}
 
 		set_irq_flags(irq, IRQF_VALID);
Index: linux-2.6-tip/arch/arm/mach-lpc32xx/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-lpc32xx/irq.c
+++ linux-2.6-tip/arch/arm/mach-lpc32xx/irq.c
@@ -290,7 +290,7 @@ static int lpc32xx_set_irq_type(struct i
 	}
 
 	/* Ok to use the level handler for all types */
-	set_irq_handler(d->irq, handle_level_irq);
+	irq_set_handler(d->irq, handle_level_irq);
 
 	return 0;
 }
@@ -390,8 +390,8 @@ void __init lpc32xx_init_irq(void)
 
 	/* Configure supported IRQ's */
 	for (i = 0; i < NR_IRQS; i++) {
-		set_irq_chip(i, &lpc32xx_irq_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &lpc32xx_irq_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
@@ -406,8 +406,8 @@ void __init lpc32xx_init_irq(void)
 	__raw_writel(0, LPC32XX_INTC_MASK(LPC32XX_SIC2_BASE));
 
 	/* MIC SUBIRQx interrupts will route handling to the chain handlers */
-	set_irq_chained_handler(IRQ_LPC32XX_SUB1IRQ, lpc32xx_sic1_handler);
-	set_irq_chained_handler(IRQ_LPC32XX_SUB2IRQ, lpc32xx_sic2_handler);
+	irq_set_chained_handler(IRQ_LPC32XX_SUB1IRQ, lpc32xx_sic1_handler);
+	irq_set_chained_handler(IRQ_LPC32XX_SUB2IRQ, lpc32xx_sic2_handler);
 
 	/* Initially disable all wake events */
 	__raw_writel(0, LPC32XX_CLKPWR_P01_ER);
Index: linux-2.6-tip/arch/arm/mach-mmp/irq-mmp2.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mmp/irq-mmp2.c
+++ linux-2.6-tip/arch/arm/mach-mmp/irq-mmp2.c
@@ -110,9 +110,9 @@ static void init_mux_irq(struct irq_chip
 		if (chip->irq_ack)
 			chip->irq_ack(d);
 
-		set_irq_chip(irq, chip);
+		irq_set_chip(irq, chip);
 		set_irq_flags(irq, IRQF_VALID);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_handler(irq, handle_level_irq);
 	}
 }
 
@@ -122,7 +122,7 @@ void __init mmp2_init_icu(void)
 
 	for (irq = 0; irq < IRQ_MMP2_MUX_BASE; irq++) {
 		icu_mask_irq(irq_get_irq_data(irq));
-		set_irq_chip(irq, &icu_irq_chip);
+		irq_set_chip(irq, &icu_irq_chip);
 		set_irq_flags(irq, IRQF_VALID);
 
 		switch (irq) {
@@ -133,7 +133,7 @@ void __init mmp2_init_icu(void)
 		case IRQ_MMP2_SSP_MUX:
 			break;
 		default:
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_handler(irq, handle_level_irq);
 			break;
 		}
 	}
@@ -149,9 +149,9 @@ void __init mmp2_init_icu(void)
 	init_mux_irq(&misc_irq_chip, IRQ_MMP2_MISC_BASE, 15);
 	init_mux_irq(&ssp_irq_chip, IRQ_MMP2_SSP_BASE, 2);
 
-	set_irq_chained_handler(IRQ_MMP2_PMIC_MUX, pmic_irq_demux);
-	set_irq_chained_handler(IRQ_MMP2_RTC_MUX, rtc_irq_demux);
-	set_irq_chained_handler(IRQ_MMP2_TWSI_MUX, twsi_irq_demux);
-	set_irq_chained_handler(IRQ_MMP2_MISC_MUX, misc_irq_demux);
-	set_irq_chained_handler(IRQ_MMP2_SSP_MUX, ssp_irq_demux);
+	irq_set_chained_handler(IRQ_MMP2_PMIC_MUX, pmic_irq_demux);
+	irq_set_chained_handler(IRQ_MMP2_RTC_MUX, rtc_irq_demux);
+	irq_set_chained_handler(IRQ_MMP2_TWSI_MUX, twsi_irq_demux);
+	irq_set_chained_handler(IRQ_MMP2_MISC_MUX, misc_irq_demux);
+	irq_set_chained_handler(IRQ_MMP2_SSP_MUX, ssp_irq_demux);
 }
Index: linux-2.6-tip/arch/arm/mach-mmp/irq-pxa168.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mmp/irq-pxa168.c
+++ linux-2.6-tip/arch/arm/mach-mmp/irq-pxa168.c
@@ -48,8 +48,8 @@ void __init icu_init_irq(void)
 
 	for (irq = 0; irq < 64; irq++) {
 		icu_mask_irq(irq_get_irq_data(irq));
-		set_irq_chip(irq, &icu_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &icu_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-msm/board-msm8960.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/board-msm8960.c
+++ linux-2.6-tip/arch/arm/mach-msm/board-msm8960.c
@@ -53,7 +53,7 @@ static void __init msm8960_init_irq(void
 	 */
 	for (i = GIC_PPI_START; i < GIC_SPI_START; i++) {
 		if (i != AVS_SVICINT && i != AVS_SVICINTSWDONE)
-			set_irq_handler(i, handle_percpu_irq);
+			irq_set_handler(i, handle_percpu_irq);
 	}
 }
 
Index: linux-2.6-tip/arch/arm/mach-msm/board-msm8x60.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/board-msm8x60.c
+++ linux-2.6-tip/arch/arm/mach-msm/board-msm8x60.c
@@ -56,7 +56,7 @@ static void __init msm8x60_init_irq(void
 	 */
 	for (i = GIC_PPI_START; i < GIC_SPI_START; i++) {
 		if (i != AVS_SVICINT && i != AVS_SVICINTSWDONE)
-			set_irq_handler(i, handle_percpu_irq);
+			irq_set_handler(i, handle_percpu_irq);
 	}
 }
 
Index: linux-2.6-tip/arch/arm/mach-msm/board-trout-gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/board-trout-gpio.c
+++ linux-2.6-tip/arch/arm/mach-msm/board-trout-gpio.c
@@ -214,17 +214,17 @@ int __init trout_init_gpio(void)
 {
 	int i;
 	for(i = TROUT_INT_START; i <= TROUT_INT_END; i++) {
-		set_irq_chip(i, &trout_gpio_irq_chip);
-		set_irq_handler(i, handle_edge_irq);
+		irq_set_chip(i, &trout_gpio_irq_chip);
+		irq_set_handler(i, handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(msm_gpio_banks); i++)
 		gpiochip_add(&msm_gpio_banks[i].chip);
 
-	set_irq_type(MSM_GPIO_TO_INT(17), IRQF_TRIGGER_HIGH);
-	set_irq_chained_handler(MSM_GPIO_TO_INT(17), trout_gpio_irq_handler);
-	set_irq_wake(MSM_GPIO_TO_INT(17), 1);
+	irq_set_irq_type(MSM_GPIO_TO_INT(17), IRQF_TRIGGER_HIGH);
+	irq_set_chained_handler(MSM_GPIO_TO_INT(17), trout_gpio_irq_handler);
+	irq_set_irq_wake(MSM_GPIO_TO_INT(17), 1);
 
 	return 0;
 }
Index: linux-2.6-tip/arch/arm/mach-msm/board-trout-mmc.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/board-trout-mmc.c
+++ linux-2.6-tip/arch/arm/mach-msm/board-trout-mmc.c
@@ -174,7 +174,7 @@ int __init trout_init_mmc(unsigned int s
 	if (IS_ERR(vreg_sdslot))
 		return PTR_ERR(vreg_sdslot);
 
-	set_irq_wake(TROUT_GPIO_TO_INT(TROUT_GPIO_SDMC_CD_N), 1);
+	irq_set_irq_wake(TROUT_GPIO_TO_INT(TROUT_GPIO_SDMC_CD_N), 1);
 
 	if (!opt_disable_sdcard)
 		msm_add_sdcc(2, &trout_sdslot_data,
Index: linux-2.6-tip/arch/arm/mach-msm/gpio-v2.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/gpio-v2.c
+++ linux-2.6-tip/arch/arm/mach-msm/gpio-v2.c
@@ -328,12 +328,12 @@ static int msm_gpio_irq_set_wake(struct 
 
 	if (on) {
 		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
-			set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 1);
+			irq_set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 1);
 		set_bit(gpio, msm_gpio.wake_irqs);
 	} else {
 		clear_bit(gpio, msm_gpio.wake_irqs);
 		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
-			set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 0);
+			irq_set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 0);
 	}
 
 	return 0;
@@ -362,12 +362,12 @@ static int __devinit msm_gpio_probe(stru
 
 	for (i = 0; i < msm_gpio.gpio_chip.ngpio; ++i) {
 		irq = msm_gpio_to_irq(&msm_gpio.gpio_chip, i);
-		set_irq_chip(irq, &msm_gpio_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &msm_gpio_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
-	set_irq_chained_handler(TLMM_SCSS_SUMMARY_IRQ,
+	irq_set_chained_handler(TLMM_SCSS_SUMMARY_IRQ,
 				msm_summary_irq_handler);
 	return 0;
 }
@@ -379,7 +379,7 @@ static int __devexit msm_gpio_remove(str
 	if (ret < 0)
 		return ret;
 
-	set_irq_handler(TLMM_SCSS_SUMMARY_IRQ, NULL);
+	irq_set_handler(TLMM_SCSS_SUMMARY_IRQ, NULL);
 
 	return 0;
 }
Index: linux-2.6-tip/arch/arm/mach-msm/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/gpio.c
+++ linux-2.6-tip/arch/arm/mach-msm/gpio.c
@@ -354,9 +354,9 @@ static int __init msm_init_gpio(void)
 			msm_gpio_chips[j].chip.base +
 			msm_gpio_chips[j].chip.ngpio)
 			j++;
-		set_irq_chip_data(i, &msm_gpio_chips[j]);
-		set_irq_chip(i, &msm_gpio_irq_chip);
-		set_irq_handler(i, handle_edge_irq);
+		irq_set_chip_data(i, &msm_gpio_chips[j]);
+		irq_set_chip(i, &msm_gpio_irq_chip);
+		irq_set_handler(i, handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
@@ -366,10 +366,10 @@ static int __init msm_init_gpio(void)
 		gpiochip_add(&msm_gpio_chips[i].chip);
 	}
 
-	set_irq_chained_handler(INT_GPIO_GROUP1, msm_gpio_irq_handler);
-	set_irq_chained_handler(INT_GPIO_GROUP2, msm_gpio_irq_handler);
-	set_irq_wake(INT_GPIO_GROUP1, 1);
-	set_irq_wake(INT_GPIO_GROUP2, 2);
+	irq_set_chained_handler(INT_GPIO_GROUP1, msm_gpio_irq_handler);
+	irq_set_chained_handler(INT_GPIO_GROUP2, msm_gpio_irq_handler);
+	irq_set_irq_wake(INT_GPIO_GROUP1, 1);
+	irq_set_irq_wake(INT_GPIO_GROUP2, 2);
 	return 0;
 }
 
Index: linux-2.6-tip/arch/arm/mach-msm/irq-vic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/irq-vic.c
+++ linux-2.6-tip/arch/arm/mach-msm/irq-vic.c
@@ -357,8 +357,8 @@ void __init msm_init_irq(void)
 	writel(3, VIC_INT_MASTEREN);
 
 	for (n = 0; n < NR_MSM_IRQS; n++) {
-		set_irq_chip(n, &msm_irq_chip);
-		set_irq_handler(n, handle_level_irq);
+		irq_set_chip(n, &msm_irq_chip);
+		irq_set_handler(n, handle_level_irq);
 		set_irq_flags(n, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-msm/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/irq.c
+++ linux-2.6-tip/arch/arm/mach-msm/irq.c
@@ -145,8 +145,8 @@ void __init msm_init_irq(void)
 	writel(1, VIC_INT_MASTEREN);
 
 	for (n = 0; n < NR_MSM_IRQS; n++) {
-		set_irq_chip(n, &msm_irq_chip);
-		set_irq_handler(n, handle_level_irq);
+		irq_set_chip(n, &msm_irq_chip);
+		irq_set_handler(n, handle_level_irq);
 		set_irq_flags(n, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-msm/sirc.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/sirc.c
+++ linux-2.6-tip/arch/arm/mach-msm/sirc.c
@@ -158,15 +158,15 @@ void __init msm_init_sirc(void)
 	wake_enable = 0;
 
 	for (i = FIRST_SIRC_IRQ; i < LAST_SIRC_IRQ; i++) {
-		set_irq_chip(i, &sirc_irq_chip);
-		set_irq_handler(i, handle_edge_irq);
+		irq_set_chip(i, &sirc_irq_chip);
+		irq_set_handler(i, handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(sirc_reg_table); i++) {
-		set_irq_chained_handler(sirc_reg_table[i].cascade_irq,
+		irq_set_chained_handler(sirc_reg_table[i].cascade_irq,
 					sirc_irq_handler);
-		set_irq_wake(sirc_reg_table[i].cascade_irq, 1);
+		irq_set_irq_wake(sirc_reg_table[i].cascade_irq, 1);
 	}
 	return;
 }
Index: linux-2.6-tip/arch/arm/mach-mv78xx0/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mv78xx0/irq.c
+++ linux-2.6-tip/arch/arm/mach-mv78xx0/irq.c
@@ -38,8 +38,8 @@ void __init mv78xx0_init_irq(void)
 	orion_gpio_init(0, 32, GPIO_VIRT_BASE,
 			mv78xx0_core_index() ? 0x18 : 0,
 			IRQ_MV78XX0_GPIO_START);
-	set_irq_chained_handler(IRQ_MV78XX0_GPIO_0_7, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_MV78XX0_GPIO_8_15, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_MV78XX0_GPIO_16_23, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_MV78XX0_GPIO_24_31, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_MV78XX0_GPIO_0_7, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_MV78XX0_GPIO_8_15, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_MV78XX0_GPIO_16_23, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_MV78XX0_GPIO_24_31, gpio_irq_handler);
 }
Index: linux-2.6-tip/arch/arm/mach-mx3/mach-mx31ads.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mx3/mach-mx31ads.c
+++ linux-2.6-tip/arch/arm/mach-mx3/mach-mx31ads.c
@@ -199,12 +199,12 @@ static void __init mx31ads_init_expio(vo
 	__raw_writew(0xFFFF, PBC_INTSTATUS_REG);
 	for (i = MXC_EXP_IO_BASE; i < (MXC_EXP_IO_BASE + MXC_MAX_EXP_IO_LINES);
 	     i++) {
-		set_irq_chip(i, &expio_irq_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &expio_irq_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
-	set_irq_type(EXPIO_PARENT_INT, IRQ_TYPE_LEVEL_HIGH);
-	set_irq_chained_handler(EXPIO_PARENT_INT, mx31ads_expio_irq_handler);
+	irq_set_irq_type(EXPIO_PARENT_INT, IRQ_TYPE_LEVEL_HIGH);
+	irq_set_chained_handler(EXPIO_PARENT_INT, mx31ads_expio_irq_handler);
 }
 
 #ifdef CONFIG_MACH_MX31ADS_WM1133_EV1
Index: linux-2.6-tip/arch/arm/mach-mx5/eukrea_mbimx51-baseboard.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mx5/eukrea_mbimx51-baseboard.c
+++ linux-2.6-tip/arch/arm/mach-mx5/eukrea_mbimx51-baseboard.c
@@ -212,7 +212,7 @@ void __init eukrea_mbimx51_baseboard_ini
 
 	gpio_request(MBIMX51_TSC2007_GPIO, "tsc2007_irq");
 	gpio_direction_input(MBIMX51_TSC2007_GPIO);
-	set_irq_type(MBIMX51_TSC2007_IRQ, IRQF_TRIGGER_FALLING);
+	irq_set_irq_type(MBIMX51_TSC2007_IRQ, IRQF_TRIGGER_FALLING);
 	i2c_register_board_info(1, mbimx51_i2c_devices,
 				ARRAY_SIZE(mbimx51_i2c_devices));
 
Index: linux-2.6-tip/arch/arm/mach-mxs/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mxs/gpio.c
+++ linux-2.6-tip/arch/arm/mach-mxs/gpio.c
@@ -136,7 +136,7 @@ static int mxs_gpio_set_irq_type(struct 
 static void mxs_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 {
 	u32 irq_stat;
-	struct mxs_gpio_port *port = (struct mxs_gpio_port *)get_irq_data(irq);
+	struct mxs_gpio_port *port = (struct mxs_gpio_port *)irq_get_handler_data(irq);
 	u32 gpio_irq_no_base = port->virtual_irq_start;
 
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
@@ -265,14 +265,14 @@ int __init mxs_gpio_init(struct mxs_gpio
 
 		for (j = port[i].virtual_irq_start;
 			j < port[i].virtual_irq_start + 32; j++) {
-			set_irq_chip(j, &gpio_irq_chip);
-			set_irq_handler(j, handle_level_irq);
+			irq_set_chip(j, &gpio_irq_chip);
+			irq_set_handler(j, handle_level_irq);
 			set_irq_flags(j, IRQF_VALID);
 		}
 
 		/* setup one handler for each entry */
-		set_irq_chained_handler(port[i].irq, mxs_gpio_irq_handler);
-		set_irq_data(port[i].irq, &port[i]);
+		irq_set_chained_handler(port[i].irq, mxs_gpio_irq_handler);
+		irq_set_handler_data(port[i].irq, &port[i]);
 
 		/* register gpio chip */
 		port[i].chip.direction_input = mxs_gpio_direction_input;
Index: linux-2.6-tip/arch/arm/mach-mxs/icoll.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-mxs/icoll.c
+++ linux-2.6-tip/arch/arm/mach-mxs/icoll.c
@@ -74,8 +74,8 @@ void __init icoll_init_irq(void)
 	mxs_reset_block(icoll_base + HW_ICOLL_CTRL);
 
 	for (i = 0; i < MXS_INTERNAL_IRQS; i++) {
-		set_irq_chip(i, &mxs_icoll_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &mxs_icoll_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-netx/generic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-netx/generic.c
+++ linux-2.6-tip/arch/arm/mach-netx/generic.c
@@ -171,13 +171,13 @@ void __init netx_init_irq(void)
 	vic_init(__io(io_p2v(NETX_PA_VIC)), 0, ~0, 0);
 
 	for (irq = NETX_IRQ_HIF_CHAINED(0); irq <= NETX_IRQ_HIF_LAST; irq++) {
-		set_irq_chip(irq, &netx_hif_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &netx_hif_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
 	writel(NETX_DPMAS_INT_EN_GLB_EN, NETX_DPMAS_INT_EN);
-	set_irq_chained_handler(NETX_IRQ_HIF, netx_hif_demux_handler);
+	irq_set_chained_handler(NETX_IRQ_HIF, netx_hif_demux_handler);
 }
 
 static int __init netx_init(void)
Index: linux-2.6-tip/arch/arm/mach-ns9xxx/board-a9m9750dev.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ns9xxx/board-a9m9750dev.c
+++ linux-2.6-tip/arch/arm/mach-ns9xxx/board-a9m9750dev.c
@@ -107,8 +107,8 @@ void __init board_a9m9750dev_init_irq(vo
 				__func__);
 
 	for (i = FPGA_IRQ(0); i <= FPGA_IRQ(7); ++i) {
-		set_irq_chip(i, &a9m9750dev_fpga_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &a9m9750dev_fpga_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
@@ -118,8 +118,8 @@ void __init board_a9m9750dev_init_irq(vo
 	REGSET(eic, SYS_EIC, LVEDG, LEVEL);
 	__raw_writel(eic, SYS_EIC(2));
 
-	set_irq_chained_handler(IRQ_NS9XXX_EXT2,
-			a9m9750dev_fpga_demux_handler);
+	irq_set_chained_handler(IRQ_NS9XXX_EXT2,
+				a9m9750dev_fpga_demux_handler);
 }
 
 void __init board_a9m9750dev_init_machine(void)
Index: linux-2.6-tip/arch/arm/mach-ns9xxx/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ns9xxx/irq.c
+++ linux-2.6-tip/arch/arm/mach-ns9xxx/irq.c
@@ -67,8 +67,8 @@ void __init ns9xxx_init_irq(void)
 		__raw_writel(prio2irq(i), SYS_IVA(i));
 
 	for (i = 0; i <= 31; ++i) {
-		set_irq_chip(i, &ns9xxx_chip);
-		set_irq_handler(i, handle_fasteoi_irq);
+		irq_set_chip(i, &ns9xxx_chip);
+		irq_set_handler(i, handle_fasteoi_irq);
 		set_irq_flags(i, IRQF_VALID);
 		irq_set_status_flags(i, IRQ_LEVEL);
 	}
Index: linux-2.6-tip/arch/arm/mach-nuc93x/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-nuc93x/irq.c
+++ linux-2.6-tip/arch/arm/mach-nuc93x/irq.c
@@ -59,8 +59,8 @@ void __init nuc93x_init_irq(void)
 	__raw_writel(0xFFFFFFFE, REG_AIC_MDCR);
 
 	for (irqno = IRQ_WDT; irqno <= NR_IRQS; irqno++) {
-		set_irq_chip(irqno, &nuc93x_irq_chip);
-		set_irq_handler(irqno, handle_level_irq);
+		irq_set_chip(irqno, &nuc93x_irq_chip);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-omap1/board-osk.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-omap1/board-osk.c
+++ linux-2.6-tip/arch/arm/mach-omap1/board-osk.c
@@ -276,7 +276,7 @@ static void __init osk_init_cf(void)
 		return;
 	}
 	/* the CF I/O IRQ is really active-low */
-	set_irq_type(gpio_to_irq(62), IRQ_TYPE_EDGE_FALLING);
+	irq_set_irq_type(gpio_to_irq(62), IRQ_TYPE_EDGE_FALLING);
 }
 
 static void __init osk_init_irq(void)
@@ -482,7 +482,7 @@ static void __init osk_mistral_init(void
 	omap_cfg_reg(P20_1610_GPIO4);	/* PENIRQ */
 	gpio_request(4, "ts_int");
 	gpio_direction_input(4);
-	set_irq_type(gpio_to_irq(4), IRQ_TYPE_EDGE_FALLING);
+	irq_set_irq_type(gpio_to_irq(4), IRQ_TYPE_EDGE_FALLING);
 
 	spi_register_board_info(mistral_boardinfo,
 			ARRAY_SIZE(mistral_boardinfo));
@@ -500,7 +500,7 @@ static void __init osk_mistral_init(void
 		int irq = gpio_to_irq(OMAP_MPUIO(2));
 
 		gpio_direction_input(OMAP_MPUIO(2));
-		set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
+		irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
 #ifdef	CONFIG_PM
 		/* share the IRQ in case someone wants to use the
 		 * button for more than wakeup from system sleep.
Index: linux-2.6-tip/arch/arm/mach-omap1/board-palmz71.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-omap1/board-palmz71.c
+++ linux-2.6-tip/arch/arm/mach-omap1/board-palmz71.c
@@ -256,12 +256,12 @@ palmz71_powercable(int irq, void *dev_id
 {
 	if (gpio_get_value(PALMZ71_USBDETECT_GPIO)) {
 		printk(KERN_INFO "PM: Power cable connected\n");
-		set_irq_type(gpio_to_irq(PALMZ71_USBDETECT_GPIO),
-				IRQ_TYPE_EDGE_FALLING);
+		irq_set_irq_type(gpio_to_irq(PALMZ71_USBDETECT_GPIO),
+				 IRQ_TYPE_EDGE_FALLING);
 	} else {
 		printk(KERN_INFO "PM: Power cable disconnected\n");
-		set_irq_type(gpio_to_irq(PALMZ71_USBDETECT_GPIO),
-				IRQ_TYPE_EDGE_RISING);
+		irq_set_irq_type(gpio_to_irq(PALMZ71_USBDETECT_GPIO),
+				 IRQ_TYPE_EDGE_RISING);
 	}
 	return IRQ_HANDLED;
 }
Index: linux-2.6-tip/arch/arm/mach-omap1/board-voiceblue.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-omap1/board-voiceblue.c
+++ linux-2.6-tip/arch/arm/mach-omap1/board-voiceblue.c
@@ -279,10 +279,10 @@ static void __init voiceblue_init(void)
 	gpio_request(13, "16C554 irq");
 	gpio_request(14, "16C554 irq");
 	gpio_request(15, "16C554 irq");
-	set_irq_type(gpio_to_irq(12), IRQ_TYPE_EDGE_RISING);
-	set_irq_type(gpio_to_irq(13), IRQ_TYPE_EDGE_RISING);
-	set_irq_type(gpio_to_irq(14), IRQ_TYPE_EDGE_RISING);
-	set_irq_type(gpio_to_irq(15), IRQ_TYPE_EDGE_RISING);
+	irq_set_irq_type(gpio_to_irq(12), IRQ_TYPE_EDGE_RISING);
+	irq_set_irq_type(gpio_to_irq(13), IRQ_TYPE_EDGE_RISING);
+	irq_set_irq_type(gpio_to_irq(14), IRQ_TYPE_EDGE_RISING);
+	irq_set_irq_type(gpio_to_irq(15), IRQ_TYPE_EDGE_RISING);
 
 	platform_add_devices(voiceblue_devices, ARRAY_SIZE(voiceblue_devices));
 	omap_board_config = voiceblue_config;
Index: linux-2.6-tip/arch/arm/mach-omap1/fpga.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-omap1/fpga.c
+++ linux-2.6-tip/arch/arm/mach-omap1/fpga.c
@@ -156,17 +156,17 @@ void omap1510_fpga_init_irq(void)
 			 * The touchscreen interrupt is level-sensitive, so
 			 * we'll use the regular mask_ack routine for it.
 			 */
-			set_irq_chip(i, &omap_fpga_irq_ack);
+			irq_set_chip(i, &omap_fpga_irq_ack);
 		}
 		else {
 			/*
 			 * All FPGA interrupts except the touchscreen are
 			 * edge-sensitive, so we won't mask them.
 			 */
-			set_irq_chip(i, &omap_fpga_irq);
+			irq_set_chip(i, &omap_fpga_irq);
 		}
 
-		set_irq_handler(i, handle_edge_irq);
+		irq_set_handler(i, handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
@@ -183,6 +183,6 @@ void omap1510_fpga_init_irq(void)
 		return;
 	}
 	gpio_direction_input(13);
-	set_irq_type(gpio_to_irq(13), IRQ_TYPE_EDGE_RISING);
-	set_irq_chained_handler(OMAP1510_INT_FPGA, innovator_fpga_IRQ_demux);
+	irq_set_irq_type(gpio_to_irq(13), IRQ_TYPE_EDGE_RISING);
+	irq_set_chained_handler(OMAP1510_INT_FPGA, innovator_fpga_IRQ_demux);
 }
Index: linux-2.6-tip/arch/arm/mach-omap1/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-omap1/irq.c
+++ linux-2.6-tip/arch/arm/mach-omap1/irq.c
@@ -230,8 +230,8 @@ void __init omap_init_irq(void)
 			irq_trigger = irq_banks[i].trigger_map >> IRQ_BIT(j);
 			omap_irq_set_cfg(j, 0, 0, irq_trigger);
 
-			set_irq_chip(j, &omap_irq_chip);
-			set_irq_handler(j, handle_level_irq);
+			irq_set_chip(j, &omap_irq_chip);
+			irq_set_handler(j, handle_level_irq);
 			set_irq_flags(j, IRQF_VALID);
 		}
 	}
Index: linux-2.6-tip/arch/arm/mach-omap2/gpmc.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-omap2/gpmc.c
+++ linux-2.6-tip/arch/arm/mach-omap2/gpmc.c
@@ -739,7 +739,7 @@ static int __init gpmc_init(void)
 	/* initalize the irq_chained */
 	irq = OMAP_GPMC_IRQ_BASE;
 	for (cs = 0; cs < GPMC_CS_NUM; cs++) {
-		set_irq_handler(irq, handle_simple_irq);
+		irq_set_handler(irq, handle_simple_irq);
 		set_irq_flags(irq, IRQF_VALID);
 		irq++;
 	}
Index: linux-2.6-tip/arch/arm/mach-omap2/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-omap2/irq.c
+++ linux-2.6-tip/arch/arm/mach-omap2/irq.c
@@ -223,8 +223,8 @@ void __init omap_init_irq(void)
 	       nr_of_irqs, nr_banks, nr_banks > 1 ? "s" : "");
 
 	for (i = 0; i < nr_of_irqs; i++) {
-		set_irq_chip(i, &omap_irq_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &omap_irq_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-orion5x/db88f5281-setup.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-orion5x/db88f5281-setup.c
+++ linux-2.6-tip/arch/arm/mach-orion5x/db88f5281-setup.c
@@ -213,7 +213,7 @@ void __init db88f5281_pci_preinit(void)
 	pin = DB88F5281_PCI_SLOT0_IRQ_PIN;
 	if (gpio_request(pin, "PCI Int1") == 0) {
 		if (gpio_direction_input(pin) == 0) {
-			set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
+			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
 			printk(KERN_ERR "db88f5281_pci_preinit faield to "
 					"set_irq_type pin %d\n", pin);
@@ -226,7 +226,7 @@ void __init db88f5281_pci_preinit(void)
 	pin = DB88F5281_PCI_SLOT1_SLOT2_IRQ_PIN;
 	if (gpio_request(pin, "PCI Int2") == 0) {
 		if (gpio_direction_input(pin) == 0) {
-			set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
+			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
 			printk(KERN_ERR "db88f5281_pci_preinit faield "
 					"to set_irq_type pin %d\n", pin);
Index: linux-2.6-tip/arch/arm/mach-orion5x/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-orion5x/irq.c
+++ linux-2.6-tip/arch/arm/mach-orion5x/irq.c
@@ -34,8 +34,8 @@ void __init orion5x_init_irq(void)
 	 * Initialize gpiolib for GPIOs 0-31.
 	 */
 	orion_gpio_init(0, 32, GPIO_VIRT_BASE, 0, IRQ_ORION5X_GPIO_START);
-	set_irq_chained_handler(IRQ_ORION5X_GPIO_0_7, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_ORION5X_GPIO_8_15, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_ORION5X_GPIO_16_23, gpio_irq_handler);
-	set_irq_chained_handler(IRQ_ORION5X_GPIO_24_31, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_ORION5X_GPIO_0_7, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_ORION5X_GPIO_8_15, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_ORION5X_GPIO_16_23, gpio_irq_handler);
+	irq_set_chained_handler(IRQ_ORION5X_GPIO_24_31, gpio_irq_handler);
 }
Index: linux-2.6-tip/arch/arm/mach-orion5x/rd88f5182-setup.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-orion5x/rd88f5182-setup.c
+++ linux-2.6-tip/arch/arm/mach-orion5x/rd88f5182-setup.c
@@ -148,7 +148,7 @@ void __init rd88f5182_pci_preinit(void)
 	pin = RD88F5182_PCI_SLOT0_IRQ_A_PIN;
 	if (gpio_request(pin, "PCI IntA") == 0) {
 		if (gpio_direction_input(pin) == 0) {
-			set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
+			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
 			printk(KERN_ERR "rd88f5182_pci_preinit faield to "
 					"set_irq_type pin %d\n", pin);
@@ -161,7 +161,7 @@ void __init rd88f5182_pci_preinit(void)
 	pin = RD88F5182_PCI_SLOT0_IRQ_B_PIN;
 	if (gpio_request(pin, "PCI IntB") == 0) {
 		if (gpio_direction_input(pin) == 0) {
-			set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
+			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
 			printk(KERN_ERR "rd88f5182_pci_preinit faield to "
 					"set_irq_type pin %d\n", pin);
Index: linux-2.6-tip/arch/arm/mach-orion5x/terastation_pro2-setup.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-orion5x/terastation_pro2-setup.c
+++ linux-2.6-tip/arch/arm/mach-orion5x/terastation_pro2-setup.c
@@ -88,7 +88,7 @@ void __init tsp2_pci_preinit(void)
 	pin = TSP2_PCI_SLOT0_IRQ_PIN;
 	if (gpio_request(pin, "PCI Int1") == 0) {
 		if (gpio_direction_input(pin) == 0) {
-			set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
+			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
 			printk(KERN_ERR "tsp2_pci_preinit failed "
 					"to set_irq_type pin %d\n", pin);
Index: linux-2.6-tip/arch/arm/mach-orion5x/ts209-setup.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-orion5x/ts209-setup.c
+++ linux-2.6-tip/arch/arm/mach-orion5x/ts209-setup.c
@@ -117,7 +117,7 @@ void __init qnap_ts209_pci_preinit(void)
 	pin = QNAP_TS209_PCI_SLOT0_IRQ_PIN;
 	if (gpio_request(pin, "PCI Int1") == 0) {
 		if (gpio_direction_input(pin) == 0) {
-			set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
+			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
 			printk(KERN_ERR "qnap_ts209_pci_preinit failed to "
 					"set_irq_type pin %d\n", pin);
@@ -131,7 +131,7 @@ void __init qnap_ts209_pci_preinit(void)
 	pin = QNAP_TS209_PCI_SLOT1_IRQ_PIN;
 	if (gpio_request(pin, "PCI Int2") == 0) {
 		if (gpio_direction_input(pin) == 0) {
-			set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
+			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
 			printk(KERN_ERR "qnap_ts209_pci_preinit failed "
 					"to set_irq_type pin %d\n", pin);
Index: linux-2.6-tip/arch/arm/mach-pnx4008/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pnx4008/irq.c
+++ linux-2.6-tip/arch/arm/mach-pnx4008/irq.c
@@ -58,22 +58,22 @@ static int pnx4008_set_irq_type(struct i
 	case IRQ_TYPE_EDGE_RISING:
 		__raw_writel(__raw_readl(INTC_ATR(d->irq)) | INTC_BIT(d->irq), INTC_ATR(d->irq));	/*edge sensitive */
 		__raw_writel(__raw_readl(INTC_APR(d->irq)) | INTC_BIT(d->irq), INTC_APR(d->irq));	/*rising edge */
-		set_irq_handler(d->irq, handle_edge_irq);
+		irq_set_handler(d->irq, handle_edge_irq);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
 		__raw_writel(__raw_readl(INTC_ATR(d->irq)) | INTC_BIT(d->irq), INTC_ATR(d->irq));	/*edge sensitive */
 		__raw_writel(__raw_readl(INTC_APR(d->irq)) & ~INTC_BIT(d->irq), INTC_APR(d->irq));	/*falling edge */
-		set_irq_handler(d->irq, handle_edge_irq);
+		irq_set_handler(d->irq, handle_edge_irq);
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
 		__raw_writel(__raw_readl(INTC_ATR(d->irq)) & ~INTC_BIT(d->irq), INTC_ATR(d->irq));	/*level sensitive */
 		__raw_writel(__raw_readl(INTC_APR(d->irq)) & ~INTC_BIT(d->irq), INTC_APR(d->irq));	/*low level */
-		set_irq_handler(d->irq, handle_level_irq);
+		irq_set_handler(d->irq, handle_level_irq);
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
 		__raw_writel(__raw_readl(INTC_ATR(d->irq)) & ~INTC_BIT(d->irq), INTC_ATR(d->irq));	/*level sensitive */
 		__raw_writel(__raw_readl(INTC_APR(d->irq)) | INTC_BIT(d->irq), INTC_APR(d->irq));	/* high level */
-		set_irq_handler(d->irq, handle_level_irq);
+		irq_set_handler(d->irq, handle_level_irq);
 		break;
 
 	/* IRQ_TYPE_EDGE_BOTH is not supported */
@@ -98,7 +98,7 @@ void __init pnx4008_init_irq(void)
 	/* configure IRQ's */
 	for (i = 0; i < NR_IRQS; i++) {
 		set_irq_flags(i, IRQF_VALID);
-		set_irq_chip(i, &pnx4008_irq_chip);
+		irq_set_chip(i, &pnx4008_irq_chip);
 		pnx4008_set_irq_type(irq_get_irq_data(i), pnx4008_irq_type[i]);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-pxa/balloon3.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/balloon3.c
+++ linux-2.6-tip/arch/arm/mach-pxa/balloon3.c
@@ -527,13 +527,13 @@ static void __init balloon3_init_irq(voi
 	pxa27x_init_irq();
 	/* setup extra Balloon3 irqs */
 	for (irq = BALLOON3_IRQ(0); irq <= BALLOON3_IRQ(7); irq++) {
-		set_irq_chip(irq, &balloon3_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &balloon3_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
-	set_irq_chained_handler(BALLOON3_AUX_NIRQ, balloon3_irq_handler);
-	set_irq_type(BALLOON3_AUX_NIRQ, IRQ_TYPE_EDGE_FALLING);
+	irq_set_chained_handler(BALLOON3_AUX_NIRQ, balloon3_irq_handler);
+	irq_set_irq_type(BALLOON3_AUX_NIRQ, IRQ_TYPE_EDGE_FALLING);
 
 	pr_debug("%s: chained handler installed - irq %d automatically "
 		"enabled\n", __func__, BALLOON3_AUX_NIRQ);
Index: linux-2.6-tip/arch/arm/mach-pxa/cm-x2xx-pci.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/cm-x2xx-pci.c
+++ linux-2.6-tip/arch/arm/mach-pxa/cm-x2xx-pci.c
@@ -70,9 +70,10 @@ void __cmx2xx_pci_init_irq(int irq_gpio)
 
 	cmx2xx_it8152_irq_gpio = irq_gpio;
 
-	set_irq_type(gpio_to_irq(irq_gpio), IRQ_TYPE_EDGE_RISING);
+	irq_set_irq_type(gpio_to_irq(irq_gpio), IRQ_TYPE_EDGE_RISING);
 
-	set_irq_chained_handler(gpio_to_irq(irq_gpio), cmx2xx_it8152_irq_demux);
+	irq_set_chained_handler(gpio_to_irq(irq_gpio),
+				cmx2xx_it8152_irq_demux);
 }
 
 #ifdef CONFIG_PM
Index: linux-2.6-tip/arch/arm/mach-pxa/cm-x300.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/cm-x300.c
+++ linux-2.6-tip/arch/arm/mach-pxa/cm-x300.c
@@ -765,7 +765,7 @@ static void __init cm_x300_init_da9030(v
 {
 	pxa3xx_set_i2c_power_info(&cm_x300_pwr_i2c_info);
 	i2c_register_board_info(1, &cm_x300_pmic_info, 1);
-	set_irq_wake(IRQ_WAKEUP0, 1);
+	irq_set_irq_wake(IRQ_WAKEUP0, 1);
 }
 
 static void __init cm_x300_init_wi2wi(void)
Index: linux-2.6-tip/arch/arm/mach-pxa/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/irq.c
+++ linux-2.6-tip/arch/arm/mach-pxa/irq.c
@@ -137,9 +137,9 @@ static void __init pxa_init_low_gpio_irq
 	GEDR0 = 0x3;
 
 	for (irq = IRQ_GPIO0; irq <= IRQ_GPIO1; irq++) {
-		set_irq_chip(irq, &pxa_low_gpio_chip);
-		set_irq_chip_data(irq, irq_base(0));
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &pxa_low_gpio_chip);
+		irq_set_chip_data(irq, irq_base(0));
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
@@ -165,9 +165,9 @@ void __init pxa_init_irq(int irq_nr, set
 				__raw_writel(i | IPR_VALID, IRQ_BASE + IPR(i));
 
 			irq = PXA_IRQ(i);
-			set_irq_chip(irq, &pxa_internal_irq_chip);
-			set_irq_chip_data(irq, base);
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &pxa_internal_irq_chip);
+			irq_set_chip_data(irq, base);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, IRQF_VALID);
 		}
 	}
Index: linux-2.6-tip/arch/arm/mach-pxa/lpd270.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/lpd270.c
+++ linux-2.6-tip/arch/arm/mach-pxa/lpd270.c
@@ -149,12 +149,12 @@ static void __init lpd270_init_irq(void)
 
 	/* setup extra LogicPD PXA270 irqs */
 	for (irq = LPD270_IRQ(2); irq <= LPD270_IRQ(4); irq++) {
-		set_irq_chip(irq, &lpd270_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &lpd270_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
-	set_irq_chained_handler(IRQ_GPIO(0), lpd270_irq_handler);
-	set_irq_type(IRQ_GPIO(0), IRQ_TYPE_EDGE_FALLING);
+	irq_set_chained_handler(IRQ_GPIO(0), lpd270_irq_handler);
+	irq_set_irq_type(IRQ_GPIO(0), IRQ_TYPE_EDGE_FALLING);
 }
 
 
Index: linux-2.6-tip/arch/arm/mach-pxa/lubbock.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/lubbock.c
+++ linux-2.6-tip/arch/arm/mach-pxa/lubbock.c
@@ -165,13 +165,13 @@ static void __init lubbock_init_irq(void
 
 	/* setup extra lubbock irqs */
 	for (irq = LUBBOCK_IRQ(0); irq <= LUBBOCK_LAST_IRQ; irq++) {
-		set_irq_chip(irq, &lubbock_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &lubbock_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
-	set_irq_chained_handler(IRQ_GPIO(0), lubbock_irq_handler);
-	set_irq_type(IRQ_GPIO(0), IRQ_TYPE_EDGE_FALLING);
+	irq_set_chained_handler(IRQ_GPIO(0), lubbock_irq_handler);
+	irq_set_irq_type(IRQ_GPIO(0), IRQ_TYPE_EDGE_FALLING);
 }
 
 #ifdef CONFIG_PM
Index: linux-2.6-tip/arch/arm/mach-pxa/mainstone.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/mainstone.c
+++ linux-2.6-tip/arch/arm/mach-pxa/mainstone.c
@@ -166,8 +166,8 @@ static void __init mainstone_init_irq(vo
 
 	/* setup extra Mainstone irqs */
 	for(irq = MAINSTONE_IRQ(0); irq <= MAINSTONE_IRQ(15); irq++) {
-		set_irq_chip(irq, &mainstone_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &mainstone_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		if (irq == MAINSTONE_IRQ(10) || irq == MAINSTONE_IRQ(14))
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE | IRQF_NOAUTOEN);
 		else
@@ -179,8 +179,8 @@ static void __init mainstone_init_irq(vo
 	MST_INTMSKENA = 0;
 	MST_INTSETCLR = 0;
 
-	set_irq_chained_handler(IRQ_GPIO(0), mainstone_irq_handler);
-	set_irq_type(IRQ_GPIO(0), IRQ_TYPE_EDGE_FALLING);
+	irq_set_chained_handler(IRQ_GPIO(0), mainstone_irq_handler);
+	irq_set_irq_type(IRQ_GPIO(0), IRQ_TYPE_EDGE_FALLING);
 }
 
 #ifdef CONFIG_PM
Index: linux-2.6-tip/arch/arm/mach-pxa/pcm990-baseboard.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/pcm990-baseboard.c
+++ linux-2.6-tip/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -281,16 +281,16 @@ static void __init pcm990_init_irq(void)
 
 	/* setup extra PCM990 irqs */
 	for (irq = PCM027_IRQ(0); irq <= PCM027_IRQ(3); irq++) {
-		set_irq_chip(irq, &pcm990_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &pcm990_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	PCM990_INTMSKENA = 0x00;	/* disable all Interrupts */
 	PCM990_INTSETCLR = 0xFF;
 
-	set_irq_chained_handler(PCM990_CTRL_INT_IRQ, pcm990_irq_handler);
-	set_irq_type(PCM990_CTRL_INT_IRQ, PCM990_CTRL_INT_IRQ_EDGE);
+	irq_set_chained_handler(PCM990_CTRL_INT_IRQ, pcm990_irq_handler);
+	irq_set_irq_type(PCM990_CTRL_INT_IRQ, PCM990_CTRL_INT_IRQ_EDGE);
 }
 
 static int pcm990_mci_init(struct device *dev, irq_handler_t mci_detect_int,
Index: linux-2.6-tip/arch/arm/mach-pxa/pxa3xx.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/pxa3xx.c
+++ linux-2.6-tip/arch/arm/mach-pxa/pxa3xx.c
@@ -362,8 +362,8 @@ static void __init pxa_init_ext_wakeup_i
 	int irq;
 
 	for (irq = IRQ_WAKEUP0; irq <= IRQ_WAKEUP1; irq++) {
-		set_irq_chip(irq, &pxa_ext_wakeup_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &pxa_ext_wakeup_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-pxa/viper.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/viper.c
+++ linux-2.6-tip/arch/arm/mach-pxa/viper.c
@@ -310,14 +310,14 @@ static void __init viper_init_irq(void)
 	/* setup ISA IRQs */
 	for (level = 0; level < ARRAY_SIZE(viper_isa_irqs); level++) {
 		isa_irq = viper_bit_to_irq(level);
-		set_irq_chip(isa_irq, &viper_irq_chip);
-		set_irq_handler(isa_irq, handle_edge_irq);
+		irq_set_chip(isa_irq, &viper_irq_chip);
+		irq_set_handler(isa_irq, handle_edge_irq);
 		set_irq_flags(isa_irq, IRQF_VALID | IRQF_PROBE);
 	}
 
-	set_irq_chained_handler(gpio_to_irq(VIPER_CPLD_GPIO),
+	irq_set_chained_handler(gpio_to_irq(VIPER_CPLD_GPIO),
 				viper_irq_handler);
-	set_irq_type(gpio_to_irq(VIPER_CPLD_GPIO), IRQ_TYPE_EDGE_BOTH);
+	irq_set_irq_type(gpio_to_irq(VIPER_CPLD_GPIO), IRQ_TYPE_EDGE_BOTH);
 }
 
 /* Flat Panel */
Index: linux-2.6-tip/arch/arm/mach-pxa/zeus.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/zeus.c
+++ linux-2.6-tip/arch/arm/mach-pxa/zeus.c
@@ -136,22 +136,23 @@ static void __init zeus_init_irq(void)
 
 	/* Peripheral IRQs. It would be nice to move those inside driver
 	   configuration, but it is not supported at the moment. */
-	set_irq_type(gpio_to_irq(ZEUS_AC97_GPIO),	IRQ_TYPE_EDGE_RISING);
-	set_irq_type(gpio_to_irq(ZEUS_WAKEUP_GPIO),	IRQ_TYPE_EDGE_RISING);
-	set_irq_type(gpio_to_irq(ZEUS_PTT_GPIO),	IRQ_TYPE_EDGE_RISING);
-	set_irq_type(gpio_to_irq(ZEUS_EXTGPIO_GPIO),	IRQ_TYPE_EDGE_FALLING);
-	set_irq_type(gpio_to_irq(ZEUS_CAN_GPIO),	IRQ_TYPE_EDGE_FALLING);
+	irq_set_irq_type(gpio_to_irq(ZEUS_AC97_GPIO), IRQ_TYPE_EDGE_RISING);
+	irq_set_irq_type(gpio_to_irq(ZEUS_WAKEUP_GPIO), IRQ_TYPE_EDGE_RISING);
+	irq_set_irq_type(gpio_to_irq(ZEUS_PTT_GPIO), IRQ_TYPE_EDGE_RISING);
+	irq_set_irq_type(gpio_to_irq(ZEUS_EXTGPIO_GPIO),
+			 IRQ_TYPE_EDGE_FALLING);
+	irq_set_irq_type(gpio_to_irq(ZEUS_CAN_GPIO), IRQ_TYPE_EDGE_FALLING);
 
 	/* Setup ISA IRQs */
 	for (level = 0; level < ARRAY_SIZE(zeus_isa_irqs); level++) {
 		isa_irq = zeus_bit_to_irq(level);
-		set_irq_chip(isa_irq, &zeus_irq_chip);
-		set_irq_handler(isa_irq, handle_edge_irq);
+		irq_set_chip(isa_irq, &zeus_irq_chip);
+		irq_set_handler(isa_irq, handle_edge_irq);
 		set_irq_flags(isa_irq, IRQF_VALID | IRQF_PROBE);
 	}
 
-	set_irq_type(gpio_to_irq(ZEUS_ISA_GPIO), IRQ_TYPE_EDGE_RISING);
-	set_irq_chained_handler(gpio_to_irq(ZEUS_ISA_GPIO), zeus_irq_handler);
+	irq_set_irq_type(gpio_to_irq(ZEUS_ISA_GPIO), IRQ_TYPE_EDGE_RISING);
+	irq_set_chained_handler(gpio_to_irq(ZEUS_ISA_GPIO), zeus_irq_handler);
 }
 
 
Index: linux-2.6-tip/arch/arm/mach-rpc/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-rpc/irq.c
+++ linux-2.6-tip/arch/arm/mach-rpc/irq.c
@@ -133,25 +133,25 @@ void __init rpc_init_irq(void)
 
 		switch (irq) {
 		case 0 ... 7:
-			set_irq_chip(irq, &iomd_a_chip);
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &iomd_a_chip);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, flags);
 			break;
 
 		case 8 ... 15:
-			set_irq_chip(irq, &iomd_b_chip);
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &iomd_b_chip);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, flags);
 			break;
 
 		case 16 ... 21:
-			set_irq_chip(irq, &iomd_dma_chip);
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_chip(irq, &iomd_dma_chip);
+			irq_set_handler(irq, handle_level_irq);
 			set_irq_flags(irq, flags);
 			break;
 
 		case 64 ... 71:
-			set_irq_chip(irq, &iomd_fiq_chip);
+			irq_set_chip(irq, &iomd_fiq_chip);
 			set_irq_flags(irq, IRQF_VALID);
 			break;
 		}
Index: linux-2.6-tip/arch/arm/mach-s3c2410/bast-irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2410/bast-irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2410/bast-irq.c
@@ -147,15 +147,15 @@ static __init int bast_irq_init(void)
 
 		__raw_writeb(0x0, BAST_VA_PC104_IRQMASK);
 
-		set_irq_chained_handler(IRQ_ISA, bast_irq_pc104_demux);
+		irq_set_chained_handler(IRQ_ISA, bast_irq_pc104_demux);
 
 		/* register our IRQs */
 
 		for (i = 0; i < 4; i++) {
 			unsigned int irqno = bast_pc104_irqs[i];
 
-			set_irq_chip(irqno, &bast_pc104_chip);
-			set_irq_handler(irqno, handle_level_irq);
+			irq_set_chip(irqno, &bast_pc104_chip);
+			irq_set_handler(irqno, handle_level_irq);
 			set_irq_flags(irqno, IRQF_VALID);
 		}
 	}
Index: linux-2.6-tip/arch/arm/mach-s3c2412/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2412/irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2412/irq.c
@@ -175,18 +175,18 @@ static int s3c2412_irq_add(struct sys_de
 	unsigned int irqno;
 
 	for (irqno = IRQ_EINT0; irqno <= IRQ_EINT3; irqno++) {
-		set_irq_chip(irqno, &s3c2412_irq_eint0t4);
-		set_irq_handler(irqno, handle_edge_irq);
+		irq_set_chip(irqno, &s3c2412_irq_eint0t4);
+		irq_set_handler(irqno, handle_edge_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
 	/* add demux support for CF/SDI */
 
-	set_irq_chained_handler(IRQ_S3C2412_CFSDI, s3c2412_irq_demux_cfsdi);
+	irq_set_chained_handler(IRQ_S3C2412_CFSDI, s3c2412_irq_demux_cfsdi);
 
 	for (irqno = IRQ_S3C2412_SDI; irqno <= IRQ_S3C2412_CF; irqno++) {
-		set_irq_chip(irqno, &s3c2412_irq_cfsdi);
-		set_irq_handler(irqno, handle_level_irq);
+		irq_set_chip(irqno, &s3c2412_irq_cfsdi);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
@@ -195,7 +195,7 @@ static int s3c2412_irq_add(struct sys_de
 	s3c2412_irq_rtc_chip = s3c_irq_chip;
 	s3c2412_irq_rtc_chip.irq_set_wake = s3c2412_irq_rtc_wake;
 
-	set_irq_chip(IRQ_RTC, &s3c2412_irq_rtc_chip);
+	irq_set_chip(IRQ_RTC, &s3c2412_irq_rtc_chip);
 
 	return 0;
 }
Index: linux-2.6-tip/arch/arm/mach-s3c2416/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2416/irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2416/irq.c
@@ -202,13 +202,13 @@ static int __init s3c2416_add_sub(unsign
 {
 	unsigned int irqno;
 
-	set_irq_chip(base, &s3c_irq_level_chip);
-	set_irq_handler(base, handle_level_irq);
-	set_irq_chained_handler(base, demux);
+	irq_set_chip(base, &s3c_irq_level_chip);
+	irq_set_handler(base, handle_level_irq);
+	irq_set_chained_handler(base, demux);
 
 	for (irqno = start; irqno <= end; irqno++) {
-		set_irq_chip(irqno, chip);
-		set_irq_handler(irqno, handle_level_irq);
+		irq_set_chip(irqno, chip);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-s3c2440/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2440/irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2440/irq.c
@@ -100,13 +100,13 @@ static int s3c2440_irq_add(struct sys_de
 
 	/* add new chained handler for wdt, ac7 */
 
-	set_irq_chip(IRQ_WDT, &s3c_irq_level_chip);
-	set_irq_handler(IRQ_WDT, handle_level_irq);
-	set_irq_chained_handler(IRQ_WDT, s3c_irq_demux_wdtac97);
+	irq_set_chip(IRQ_WDT, &s3c_irq_level_chip);
+	irq_set_handler(IRQ_WDT, handle_level_irq);
+	irq_set_chained_handler(IRQ_WDT, s3c_irq_demux_wdtac97);
 
 	for (irqno = IRQ_S3C2440_WDT; irqno <= IRQ_S3C2440_AC97; irqno++) {
-		set_irq_chip(irqno, &s3c_irq_wdtac97);
-		set_irq_handler(irqno, handle_level_irq);
+		irq_set_chip(irqno, &s3c_irq_wdtac97);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-s3c2440/s3c244x-irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2440/s3c244x-irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2440/s3c244x-irq.c
@@ -95,19 +95,19 @@ static int s3c244x_irq_add(struct sys_de
 {
 	unsigned int irqno;
 
-	set_irq_chip(IRQ_NFCON, &s3c_irq_level_chip);
-	set_irq_handler(IRQ_NFCON, handle_level_irq);
+	irq_set_chip(IRQ_NFCON, &s3c_irq_level_chip);
+	irq_set_handler(IRQ_NFCON, handle_level_irq);
 	set_irq_flags(IRQ_NFCON, IRQF_VALID);
 
 	/* add chained handler for camera */
 
-	set_irq_chip(IRQ_CAM, &s3c_irq_level_chip);
-	set_irq_handler(IRQ_CAM, handle_level_irq);
-	set_irq_chained_handler(IRQ_CAM, s3c_irq_demux_cam);
+	irq_set_chip(IRQ_CAM, &s3c_irq_level_chip);
+	irq_set_handler(IRQ_CAM, handle_level_irq);
+	irq_set_chained_handler(IRQ_CAM, s3c_irq_demux_cam);
 
 	for (irqno = IRQ_S3C2440_CAM_C; irqno <= IRQ_S3C2440_CAM_P; irqno++) {
-		set_irq_chip(irqno, &s3c_irq_cam);
-		set_irq_handler(irqno, handle_level_irq);
+		irq_set_chip(irqno, &s3c_irq_cam);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-s3c2443/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c2443/irq.c
+++ linux-2.6-tip/arch/arm/mach-s3c2443/irq.c
@@ -230,13 +230,13 @@ static int __init s3c2443_add_sub(unsign
 {
 	unsigned int irqno;
 
-	set_irq_chip(base, &s3c_irq_level_chip);
-	set_irq_handler(base, handle_level_irq);
-	set_irq_chained_handler(base, demux);
+	irq_set_chip(base, &s3c_irq_level_chip);
+	irq_set_handler(base, handle_level_irq);
+	irq_set_chained_handler(base, demux);
 
 	for (irqno = start; irqno <= end; irqno++) {
-		set_irq_chip(irqno, chip);
-		set_irq_handler(irqno, handle_level_irq);
+		irq_set_chip(irqno, chip);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-s3c64xx/irq-eint.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c64xx/irq-eint.c
+++ linux-2.6-tip/arch/arm/mach-s3c64xx/irq-eint.c
@@ -197,16 +197,16 @@ static int __init s3c64xx_init_irq_eint(
 	int irq;
 
 	for (irq = IRQ_EINT(0); irq <= IRQ_EINT(27); irq++) {
-		set_irq_chip(irq, &s3c_irq_eint);
-		set_irq_chip_data(irq, (void *)eint_irq_to_bit(irq));
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &s3c_irq_eint);
+		irq_set_chip_data(irq, (void *)eint_irq_to_bit(irq));
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
-	set_irq_chained_handler(IRQ_EINT0_3, s3c_irq_demux_eint0_3);
-	set_irq_chained_handler(IRQ_EINT4_11, s3c_irq_demux_eint4_11);
-	set_irq_chained_handler(IRQ_EINT12_19, s3c_irq_demux_eint12_19);
-	set_irq_chained_handler(IRQ_EINT20_27, s3c_irq_demux_eint20_27);
+	irq_set_chained_handler(IRQ_EINT0_3, s3c_irq_demux_eint0_3);
+	irq_set_chained_handler(IRQ_EINT4_11, s3c_irq_demux_eint4_11);
+	irq_set_chained_handler(IRQ_EINT12_19, s3c_irq_demux_eint12_19);
+	irq_set_chained_handler(IRQ_EINT20_27, s3c_irq_demux_eint20_27);
 
 	return 0;
 }
Index: linux-2.6-tip/arch/arm/mach-sa1100/cerf.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-sa1100/cerf.c
+++ linux-2.6-tip/arch/arm/mach-sa1100/cerf.c
@@ -96,7 +96,7 @@ static struct resource cerf_flash_resour
 static void __init cerf_init_irq(void)
 {
 	sa1100_init_irq();
-	set_irq_type(CERF_ETH_IRQ, IRQ_TYPE_EDGE_RISING);
+	irq_set_irq_type(CERF_ETH_IRQ, IRQ_TYPE_EDGE_RISING);
 }
 
 static struct map_desc cerf_io_desc[] __initdata = {
Index: linux-2.6-tip/arch/arm/mach-sa1100/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-sa1100/irq.c
+++ linux-2.6-tip/arch/arm/mach-sa1100/irq.c
@@ -323,28 +323,28 @@ void __init sa1100_init_irq(void)
 	ICCR = 1;
 
 	for (irq = 0; irq <= 10; irq++) {
-		set_irq_chip(irq, &sa1100_low_gpio_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &sa1100_low_gpio_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	for (irq = 12; irq <= 31; irq++) {
-		set_irq_chip(irq, &sa1100_normal_chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &sa1100_normal_chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
 	for (irq = 32; irq <= 48; irq++) {
-		set_irq_chip(irq, &sa1100_high_gpio_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &sa1100_high_gpio_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	/*
 	 * Install handler for GPIO 11-27 edge detect interrupts
 	 */
-	set_irq_chip(IRQ_GPIO11_27, &sa1100_normal_chip);
-	set_irq_chained_handler(IRQ_GPIO11_27, sa1100_high_gpio_handler);
+	irq_set_chip(IRQ_GPIO11_27, &sa1100_normal_chip);
+	irq_set_chained_handler(IRQ_GPIO11_27, sa1100_high_gpio_handler);
 
 	sa1100_init_gpio();
 }
Index: linux-2.6-tip/arch/arm/mach-sa1100/neponset.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-sa1100/neponset.c
+++ linux-2.6-tip/arch/arm/mach-sa1100/neponset.c
@@ -145,8 +145,8 @@ static int __devinit neponset_probe(stru
 	/*
 	 * Install handler for GPIO25.
 	 */
-	set_irq_type(IRQ_GPIO25, IRQ_TYPE_EDGE_RISING);
-	set_irq_chained_handler(IRQ_GPIO25, neponset_irq_handler);
+	irq_set_irq_type(IRQ_GPIO25, IRQ_TYPE_EDGE_RISING);
+	irq_set_chained_handler(IRQ_GPIO25, neponset_irq_handler);
 
 	/*
 	 * We would set IRQ_GPIO25 to be a wake-up IRQ, but
@@ -161,9 +161,9 @@ static int __devinit neponset_probe(stru
 	 * Setup other Neponset IRQs.  SA1111 will be done by the
 	 * generic SA1111 code.
 	 */
-	set_irq_handler(IRQ_NEPONSET_SMC9196, handle_simple_irq);
+	irq_set_handler(IRQ_NEPONSET_SMC9196, handle_simple_irq);
 	set_irq_flags(IRQ_NEPONSET_SMC9196, IRQF_VALID | IRQF_PROBE);
-	set_irq_handler(IRQ_NEPONSET_USAR, handle_simple_irq);
+	irq_set_handler(IRQ_NEPONSET_USAR, handle_simple_irq);
 	set_irq_flags(IRQ_NEPONSET_USAR, IRQF_VALID | IRQF_PROBE);
 
 	/*
Index: linux-2.6-tip/arch/arm/mach-sa1100/pleb.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-sa1100/pleb.c
+++ linux-2.6-tip/arch/arm/mach-sa1100/pleb.c
@@ -142,7 +142,7 @@ static void __init pleb_map_io(void)
 
 	GPDR &= ~GPIO_ETH0_IRQ;
 
-	set_irq_type(GPIO_ETH0_IRQ, IRQ_TYPE_EDGE_FALLING);
+	irq_set_irq_type(GPIO_ETH0_IRQ, IRQ_TYPE_EDGE_FALLING);
 }
 
 MACHINE_START(PLEB, "PLEB")
Index: linux-2.6-tip/arch/arm/mach-shark/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-shark/irq.c
+++ linux-2.6-tip/arch/arm/mach-shark/irq.c
@@ -80,8 +80,8 @@ void __init shark_init_irq(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
-		set_irq_chip(irq, &fb_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &fb_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-shmobile/board-ap4evb.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-shmobile/board-ap4evb.c
+++ linux-2.6-tip/arch/arm/mach-shmobile/board-ap4evb.c
@@ -1254,7 +1254,7 @@ static void __init ap4evb_init(void)
 	gpio_request(GPIO_FN_KEYIN4,     NULL);
 
 	/* enable TouchScreen */
-	set_irq_type(IRQ28, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ28, IRQ_TYPE_LEVEL_LOW);
 
 	tsc_device.irq = IRQ28;
 	i2c_register_board_info(1, &tsc_device, 1);
@@ -1310,7 +1310,7 @@ static void __init ap4evb_init(void)
 	lcdc_info.ch[0].lcd_size_cfg.height	= 91;
 
 	/* enable TouchScreen */
-	set_irq_type(IRQ7, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ7, IRQ_TYPE_LEVEL_LOW);
 
 	tsc_device.irq = IRQ7;
 	i2c_register_board_info(0, &tsc_device, 1);
Index: linux-2.6-tip/arch/arm/mach-shmobile/board-mackerel.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-shmobile/board-mackerel.c
+++ linux-2.6-tip/arch/arm/mach-shmobile/board-mackerel.c
@@ -1103,15 +1103,15 @@ static void __init mackerel_init(void)
 
 	/* enable Keypad */
 	gpio_request(GPIO_FN_IRQ9_42,	NULL);
-	set_irq_type(IRQ9, IRQ_TYPE_LEVEL_HIGH);
+	irq_set_irq_type(IRQ9, IRQ_TYPE_LEVEL_HIGH);
 
 	/* enable Touchscreen */
 	gpio_request(GPIO_FN_IRQ7_40,	NULL);
-	set_irq_type(IRQ7, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(IRQ7, IRQ_TYPE_LEVEL_LOW);
 
 	/* enable Accelerometer */
 	gpio_request(GPIO_FN_IRQ21,	NULL);
-	set_irq_type(IRQ21, IRQ_TYPE_LEVEL_HIGH);
+	irq_set_irq_type(IRQ21, IRQ_TYPE_LEVEL_HIGH);
 
 	/* enable SDHI0 */
 	gpio_request(GPIO_FN_SDHICD0, NULL);
Index: linux-2.6-tip/arch/arm/mach-shmobile/intc-sh7367.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-shmobile/intc-sh7367.c
+++ linux-2.6-tip/arch/arm/mach-shmobile/intc-sh7367.c
@@ -421,7 +421,7 @@ static struct intc_desc intcs_desc __ini
 
 static void intcs_demux(unsigned int irq, struct irq_desc *desc)
 {
-	void __iomem *reg = (void *)get_irq_data(irq);
+	void __iomem *reg = (void *)irq_get_handler_data(irq);
 	unsigned int evtcodeas = ioread32(reg);
 
 	generic_handle_irq(intcs_evt2irq(evtcodeas));
@@ -435,6 +435,6 @@ void __init sh7367_init_irq(void)
 	register_intc_controller(&intcs_desc);
 
 	/* demux using INTEVTSA */
-	set_irq_data(evt2irq(0xf80), (void *)intevtsa);
-	set_irq_chained_handler(evt2irq(0xf80), intcs_demux);
+	irq_set_handler_data(evt2irq(0xf80), (void *)intevtsa);
+	irq_set_chained_handler(evt2irq(0xf80), intcs_demux);
 }
Index: linux-2.6-tip/arch/arm/mach-shmobile/intc-sh7372.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-shmobile/intc-sh7372.c
+++ linux-2.6-tip/arch/arm/mach-shmobile/intc-sh7372.c
@@ -601,7 +601,7 @@ static struct intc_desc intcs_desc __ini
 
 static void intcs_demux(unsigned int irq, struct irq_desc *desc)
 {
-	void __iomem *reg = (void *)get_irq_data(irq);
+	void __iomem *reg = (void *)irq_get_handler_data(irq);
 	unsigned int evtcodeas = ioread32(reg);
 
 	generic_handle_irq(intcs_evt2irq(evtcodeas));
@@ -615,6 +615,6 @@ void __init sh7372_init_irq(void)
 	register_intc_controller(&intcs_desc);
 
 	/* demux using INTEVTSA */
-	set_irq_data(evt2irq(0xf80), (void *)intevtsa);
-	set_irq_chained_handler(evt2irq(0xf80), intcs_demux);
+	irq_set_handler_data(evt2irq(0xf80), (void *)intevtsa);
+	irq_set_chained_handler(evt2irq(0xf80), intcs_demux);
 }
Index: linux-2.6-tip/arch/arm/mach-shmobile/intc-sh7377.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-shmobile/intc-sh7377.c
+++ linux-2.6-tip/arch/arm/mach-shmobile/intc-sh7377.c
@@ -626,7 +626,7 @@ static struct intc_desc intcs_desc __ini
 
 static void intcs_demux(unsigned int irq, struct irq_desc *desc)
 {
-	void __iomem *reg = (void *)get_irq_data(irq);
+	void __iomem *reg = (void *)irq_get_handler_data(irq);
 	unsigned int evtcodeas = ioread32(reg);
 
 	generic_handle_irq(intcs_evt2irq(evtcodeas));
@@ -641,6 +641,6 @@ void __init sh7377_init_irq(void)
 	register_intc_controller(&intcs_desc);
 
 	/* demux using INTEVTSA */
-	set_irq_data(evt2irq(INTCS_INTVECT), (void *)intevtsa);
-	set_irq_chained_handler(evt2irq(INTCS_INTVECT), intcs_demux);
+	irq_set_handler_data(evt2irq(INTCS_INTVECT), (void *)intevtsa);
+	irq_set_chained_handler(evt2irq(INTCS_INTVECT), intcs_demux);
 }
Index: linux-2.6-tip/arch/arm/mach-tcc8k/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-tcc8k/irq.c
+++ linux-2.6-tip/arch/arm/mach-tcc8k/irq.c
@@ -102,10 +102,10 @@ void __init tcc8k_init_irq(void)
 
 	for (irqno = 0; irqno < NR_IRQS; irqno++) {
 		if (irqno < 32)
-			set_irq_chip(irqno, &tcc8000_irq_chip0);
+			irq_set_chip(irqno, &tcc8000_irq_chip0);
 		else
-			set_irq_chip(irqno, &tcc8000_irq_chip1);
-		set_irq_handler(irqno, handle_level_irq);
+			irq_set_chip(irqno, &tcc8000_irq_chip1);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-tegra/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-tegra/gpio.c
+++ linux-2.6-tip/arch/arm/mach-tegra/gpio.c
@@ -208,9 +208,9 @@ static int tegra_gpio_irq_set_type(struc
 	spin_unlock_irqrestore(&bank->lvl_lock[port], flags);
 
 	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
-		__set_irq_handler_unlocked(d->irq, handle_level_irq);
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 	else if (type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
-		__set_irq_handler_unlocked(d->irq, handle_edge_irq);
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 
 	return 0;
 }
@@ -224,7 +224,7 @@ static void tegra_gpio_irq_handler(unsig
 
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
-	bank = get_irq_data(irq);
+	bank = irq_get_handler_data(irq);
 
 	for (port = 0; port < 4; port++) {
 		int gpio = tegra_gpio_compose(bank->bank, port, 0);
@@ -257,7 +257,7 @@ static void tegra_gpio_irq_handler(unsig
 static int tegra_gpio_wake_enable(struct irq_data *d, unsigned int enable)
 {
 	struct tegra_gpio_bank *bank = irq_data_get_irq_chip_data(d);
-	return set_irq_wake(bank->irq, enable);
+	return irq_set_irq_wake(bank->irq, enable);
 }
 #endif
 
@@ -297,17 +297,17 @@ static int __init tegra_gpio_init(void)
 		bank = &tegra_gpio_banks[GPIO_BANK(irq_to_gpio(i))];
 
 		irq_set_lockdep_class(i, &gpio_lock_class);
-		set_irq_chip_data(i, bank);
-		set_irq_chip(i, &tegra_gpio_irq_chip);
-		set_irq_handler(i, handle_simple_irq);
+		irq_set_chip_data(i, bank);
+		irq_set_chip(i, &tegra_gpio_irq_chip);
+		irq_set_handler(i, handle_simple_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(tegra_gpio_banks); i++) {
 		bank = &tegra_gpio_banks[i];
 
-		set_irq_chained_handler(bank->irq, tegra_gpio_irq_handler);
-		set_irq_data(bank->irq, bank);
+		irq_set_chained_handler(bank->irq, tegra_gpio_irq_handler);
+		irq_set_handler_data(bank->irq, bank);
 
 		for (j = 0; j < 4; j++)
 			spin_lock_init(&bank->lvl_lock[j]);
Index: linux-2.6-tip/arch/arm/mach-tegra/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-tegra/irq.c
+++ linux-2.6-tip/arch/arm/mach-tegra/irq.c
@@ -144,7 +144,7 @@ void __init tegra_init_irq(void)
 	gic_init(0, 29, IO_ADDRESS(TEGRA_ARM_INT_DIST_BASE),
 		 IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x100));
 
-	gic = get_irq_chip(29);
+	gic = irq_get_chip(29);
 	tegra_gic_unmask_irq = gic->irq_unmask;
 	tegra_gic_mask_irq = gic->irq_mask;
 	tegra_gic_ack_irq = gic->irq_ack;
@@ -154,8 +154,8 @@ void __init tegra_init_irq(void)
 
 	for (i = 0; i < INT_MAIN_NR; i++) {
 		irq = INT_PRI_BASE + i;
-		set_irq_chip(irq, &tegra_irq);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &tegra_irq);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-ux500/modem-irq-db5500.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ux500/modem-irq-db5500.c
+++ linux-2.6-tip/arch/arm/mach-ux500/modem-irq-db5500.c
@@ -90,8 +90,8 @@ static irqreturn_t modem_cpu_irq_handler
 
 static void create_virtual_irq(int irq, struct irq_chip *modem_irq_chip)
 {
-	set_irq_chip(irq, modem_irq_chip);
-	set_irq_handler(irq, handle_simple_irq);
+	irq_set_chip(irq, modem_irq_chip);
+	irq_set_handler(irq, handle_simple_irq);
 	set_irq_flags(irq, IRQF_VALID);
 
 	pr_debug("modem_irq: Created virtual IRQ %d\n", irq);
Index: linux-2.6-tip/arch/arm/mach-versatile/core.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-versatile/core.c
+++ linux-2.6-tip/arch/arm/mach-versatile/core.c
@@ -122,15 +122,15 @@ void __init versatile_init_irq(void)
 
 	vic_init(VA_VIC_BASE, IRQ_VIC_START, ~0, 0);
 
-	set_irq_chained_handler(IRQ_VICSOURCE31, sic_handle_irq);
+	irq_set_chained_handler(IRQ_VICSOURCE31, sic_handle_irq);
 
 	/* Do second interrupt controller */
 	writel(~0, VA_SIC_BASE + SIC_IRQ_ENABLE_CLEAR);
 
 	for (i = IRQ_SIC_START; i <= IRQ_SIC_END; i++) {
 		if ((PIC_MASK & (1 << (i - IRQ_SIC_START))) == 0) {
-			set_irq_chip(i, &sic_chip);
-			set_irq_handler(i, handle_level_irq);
+			irq_set_chip(i, &sic_chip);
+			irq_set_handler(i, handle_level_irq);
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
 
-			set_irq_chip(i, &vt8500_irq_chip);
-			set_irq_handler(i, handle_level_irq);
+			irq_set_chip(i, &vt8500_irq_chip);
+			irq_set_handler(i, handle_level_irq);
 			set_irq_flags(i, IRQF_VALID);
 		}
 	} else {
@@ -167,8 +167,8 @@ void __init wm8505_init_irq(void)
 				writeb(0x00, sic_regbase + VT8500_IC_DCTR
 								+ i - 64);
 
-			set_irq_chip(i, &vt8500_irq_chip);
-			set_irq_handler(i, handle_level_irq);
+			irq_set_chip(i, &vt8500_irq_chip);
+			irq_set_handler(i, handle_level_irq);
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
-		set_irq_chip(irqno, &nuc900_irq_chip);
-		set_irq_handler(irqno, handle_level_irq);
+		irq_set_chip(irqno, &nuc900_irq_chip);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 }
Index: linux-2.6-tip/arch/arm/plat-mxc/3ds_debugboard.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-mxc/3ds_debugboard.c
+++ linux-2.6-tip/arch/arm/plat-mxc/3ds_debugboard.c
@@ -181,12 +181,12 @@ int __init mxc_expio_init(u32 base, u32 
 	__raw_writew(0x1F, brd_io + INTR_MASK_REG);
 	for (i = MXC_EXP_IO_BASE;
 	     i < (MXC_EXP_IO_BASE + MXC_MAX_EXP_IO_LINES); i++) {
-		set_irq_chip(i, &expio_irq_chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &expio_irq_chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
-	set_irq_type(p_irq, IRQF_TRIGGER_LOW);
-	set_irq_chained_handler(p_irq, mxc_expio_irq_handler);
+	irq_set_irq_type(p_irq, IRQF_TRIGGER_LOW);
+	irq_set_chained_handler(p_irq, mxc_expio_irq_handler);
 
 	/* Register Lan device on the debugboard */
 	smsc911x_resources[0].start = LAN9217_BASE_ADDR(base);
Index: linux-2.6-tip/arch/arm/plat-mxc/avic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-mxc/avic.c
+++ linux-2.6-tip/arch/arm/plat-mxc/avic.c
@@ -139,8 +139,8 @@ void __init mxc_init_irq(void __iomem *i
 	__raw_writel(0, avic_base + AVIC_INTTYPEH);
 	__raw_writel(0, avic_base + AVIC_INTTYPEL);
 	for (i = 0; i < MXC_INTERNAL_IRQS; i++) {
-		set_irq_chip(i, &mxc_avic_chip.base);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &mxc_avic_chip.base);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-mxc/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-mxc/gpio.c
+++ linux-2.6-tip/arch/arm/plat-mxc/gpio.c
@@ -175,7 +175,7 @@ static void mxc_gpio_irq_handler(struct 
 static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 {
 	u32 irq_stat;
-	struct mxc_gpio_port *port = get_irq_data(irq);
+	struct mxc_gpio_port *port = irq_get_handler_data(irq);
 
 	irq_stat = __raw_readl(port->base + GPIO_ISR) &
 			__raw_readl(port->base + GPIO_IMR);
@@ -188,7 +188,7 @@ static void mx2_gpio_irq_handler(u32 irq
 {
 	int i;
 	u32 irq_msk, irq_stat;
-	struct mxc_gpio_port *port = get_irq_data(irq);
+	struct mxc_gpio_port *port = irq_get_handler_data(irq);
 
 	/* walk through all interrupt status registers */
 	for (i = 0; i < gpio_table_size; i++) {
@@ -311,8 +311,8 @@ int __init mxc_gpio_init(struct mxc_gpio
 		__raw_writel(~0, port[i].base + GPIO_ISR);
 		for (j = port[i].virtual_irq_start;
 			j < port[i].virtual_irq_start + 32; j++) {
-			set_irq_chip(j, &gpio_irq_chip);
-			set_irq_handler(j, handle_level_irq);
+			irq_set_chip(j, &gpio_irq_chip);
+			irq_set_handler(j, handle_level_irq);
 			set_irq_flags(j, IRQF_VALID);
 		}
 
@@ -331,21 +331,23 @@ int __init mxc_gpio_init(struct mxc_gpio
 
 		if (cpu_is_mx1() || cpu_is_mx3() || cpu_is_mx25() || cpu_is_mx51()) {
 			/* setup one handler for each entry */
-			set_irq_chained_handler(port[i].irq, mx3_gpio_irq_handler);
-			set_irq_data(port[i].irq, &port[i]);
+			irq_set_chained_handler(port[i].irq,
+						mx3_gpio_irq_handler);
+			irq_set_handler_data(port[i].irq, &port[i]);
 			if (port[i].irq_high) {
 				/* setup handler for GPIO 16 to 31 */
-				set_irq_chained_handler(port[i].irq_high,
-						mx3_gpio_irq_handler);
-				set_irq_data(port[i].irq_high, &port[i]);
+				irq_set_chained_handler(port[i].irq_high,
+							mx3_gpio_irq_handler);
+				irq_set_handler_data(port[i].irq_high,
+						     &port[i]);
 			}
 		}
 	}
 
 	if (cpu_is_mx2()) {
 		/* setup one handler for all GPIO interrupts */
-		set_irq_chained_handler(port[0].irq, mx2_gpio_irq_handler);
-		set_irq_data(port[0].irq, port);
+		irq_set_chained_handler(port[0].irq, mx2_gpio_irq_handler);
+		irq_set_handler_data(port[0].irq, port);
 	}
 
 	return 0;
Index: linux-2.6-tip/arch/arm/plat-mxc/irq-common.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-mxc/irq-common.c
+++ linux-2.6-tip/arch/arm/plat-mxc/irq-common.c
@@ -29,7 +29,7 @@ int imx_irq_set_priority(unsigned char i
 
 	ret = -ENOSYS;
 
-	base = get_irq_chip(irq);
+	base = irq_get_chip(irq);
 	if (base) {
 		chip = container_of(base, struct mxc_irq_chip, base);
 		if (chip->set_priority)
@@ -48,7 +48,7 @@ int mxc_set_irq_fiq(unsigned int irq, un
 
 	ret = -ENOSYS;
 
-	base = get_irq_chip(irq);
+	base = irq_get_chip(irq);
 	if (base) {
 		chip = container_of(base, struct mxc_irq_chip, base);
 		if (chip->set_irq_fiq)
Index: linux-2.6-tip/arch/arm/plat-mxc/tzic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-mxc/tzic.c
+++ linux-2.6-tip/arch/arm/plat-mxc/tzic.c
@@ -167,8 +167,8 @@ void __init tzic_init_irq(void __iomem *
 	/* all IRQ no FIQ Warning :: No selection */
 
 	for (i = 0; i < MXC_INTERNAL_IRQS; i++) {
-		set_irq_chip(i, &mxc_tzic_chip.base);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, &mxc_tzic_chip.base);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-nomadik/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-nomadik/gpio.c
+++ linux-2.6-tip/arch/arm/plat-nomadik/gpio.c
@@ -319,7 +319,7 @@ static int __nmk_config_pins(pin_cfg_t *
 		struct nmk_gpio_chip *nmk_chip;
 		int pin = PIN_NUM(cfgs[i]);
 
-		nmk_chip = get_irq_chip_data(NOMADIK_GPIO_TO_IRQ(pin));
+		nmk_chip = irq_get_chip_data(NOMADIK_GPIO_TO_IRQ(pin));
 		if (!nmk_chip) {
 			ret = -EINVAL;
 			break;
@@ -398,7 +398,7 @@ int nmk_gpio_set_slpm(int gpio, enum nmk
 	struct nmk_gpio_chip *nmk_chip;
 	unsigned long flags;
 
-	nmk_chip = get_irq_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
+	nmk_chip = irq_get_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
 	if (!nmk_chip)
 		return -EINVAL;
 
@@ -431,7 +431,7 @@ int nmk_gpio_set_pull(int gpio, enum nmk
 	struct nmk_gpio_chip *nmk_chip;
 	unsigned long flags;
 
-	nmk_chip = get_irq_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
+	nmk_chip = irq_get_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
 	if (!nmk_chip)
 		return -EINVAL;
 
@@ -457,7 +457,7 @@ int nmk_gpio_set_mode(int gpio, int gpio
 	struct nmk_gpio_chip *nmk_chip;
 	unsigned long flags;
 
-	nmk_chip = get_irq_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
+	nmk_chip = irq_get_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
 	if (!nmk_chip)
 		return -EINVAL;
 
@@ -474,7 +474,7 @@ int nmk_gpio_get_mode(int gpio)
 	struct nmk_gpio_chip *nmk_chip;
 	u32 afunc, bfunc, bit;
 
-	nmk_chip = get_irq_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
+	nmk_chip = irq_get_chip_data(NOMADIK_GPIO_TO_IRQ(gpio));
 	if (!nmk_chip)
 		return -EINVAL;
 
@@ -685,7 +685,7 @@ static void __nmk_gpio_irq_handler(unsig
 				   u32 status)
 {
 	struct nmk_gpio_chip *nmk_chip;
-	struct irq_chip *host_chip = get_irq_chip(irq);
+	struct irq_chip *host_chip = irq_get_chip(irq);
 	unsigned int first_irq;
 
 	if (host_chip->irq_mask_ack)
@@ -696,7 +696,7 @@ static void __nmk_gpio_irq_handler(unsig
 			host_chip->irq_ack(&desc->irq_data);
 	}
 
-	nmk_chip = get_irq_data(irq);
+	nmk_chip = irq_get_handler_data(irq);
 	first_irq = NOMADIK_GPIO_TO_IRQ(nmk_chip->chip.base);
 	while (status) {
 		int bit = __ffs(status);
@@ -710,7 +710,7 @@ static void __nmk_gpio_irq_handler(unsig
 
 static void nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
-	struct nmk_gpio_chip *nmk_chip = get_irq_data(irq);
+	struct nmk_gpio_chip *nmk_chip = irq_get_handler_data(irq);
 	u32 status = readl(nmk_chip->addr + NMK_GPIO_IS);
 
 	__nmk_gpio_irq_handler(irq, desc, status);
@@ -719,7 +719,7 @@ static void nmk_gpio_irq_handler(unsigne
 static void nmk_gpio_secondary_irq_handler(unsigned int irq,
 					   struct irq_desc *desc)
 {
-	struct nmk_gpio_chip *nmk_chip = get_irq_data(irq);
+	struct nmk_gpio_chip *nmk_chip = irq_get_handler_data(irq);
 	u32 status = nmk_chip->get_secondary_status(nmk_chip->bank);
 
 	__nmk_gpio_irq_handler(irq, desc, status);
@@ -732,20 +732,20 @@ static int nmk_gpio_init_irq(struct nmk_
 
 	first_irq = NOMADIK_GPIO_TO_IRQ(nmk_chip->chip.base);
 	for (i = first_irq; i < first_irq + nmk_chip->chip.ngpio; i++) {
-		set_irq_chip(i, &nmk_gpio_irq_chip);
-		set_irq_handler(i, handle_edge_irq);
+		irq_set_chip(i, &nmk_gpio_irq_chip);
+		irq_set_handler(i, handle_edge_irq);
 		set_irq_flags(i, IRQF_VALID);
-		set_irq_chip_data(i, nmk_chip);
-		set_irq_type(i, IRQ_TYPE_EDGE_FALLING);
+		irq_set_chip_data(i, nmk_chip);
+		irq_set_irq_type(i, IRQ_TYPE_EDGE_FALLING);
 	}
 
-	set_irq_chained_handler(nmk_chip->parent_irq, nmk_gpio_irq_handler);
-	set_irq_data(nmk_chip->parent_irq, nmk_chip);
+	irq_set_chained_handler(nmk_chip->parent_irq, nmk_gpio_irq_handler);
+	irq_set_handler_data(nmk_chip->parent_irq, nmk_chip);
 
 	if (nmk_chip->secondary_parent_irq >= 0) {
-		set_irq_chained_handler(nmk_chip->secondary_parent_irq,
+		irq_set_chained_handler(nmk_chip->secondary_parent_irq,
 					nmk_gpio_secondary_irq_handler);
-		set_irq_data(nmk_chip->secondary_parent_irq, nmk_chip);
+		irq_set_handler_data(nmk_chip->secondary_parent_irq, nmk_chip);
 	}
 
 	return 0;
Index: linux-2.6-tip/arch/arm/plat-omap/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-omap/gpio.c
+++ linux-2.6-tip/arch/arm/plat-omap/gpio.c
@@ -758,9 +758,9 @@ static int gpio_irq_type(struct irq_data
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
-		__set_irq_handler_unlocked(d->irq, handle_level_irq);
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 	else if (type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
-		__set_irq_handler_unlocked(d->irq, handle_edge_irq);
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 
 	return retval;
 }
@@ -1140,7 +1140,7 @@ static void gpio_irq_handler(unsigned in
 
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
-	bank = get_irq_data(irq);
+	bank = irq_get_handler_data(irq);
 #ifdef CONFIG_ARCH_OMAP1
 	if (bank->method == METHOD_MPUIO)
 		isr_reg = bank->base +
@@ -1666,16 +1666,16 @@ static void __init omap_gpio_chip_init(s
 	for (j = bank->virtual_irq_start;
 		     j < bank->virtual_irq_start + bank_width; j++) {
 		irq_set_lockdep_class(j, &gpio_lock_class);
-		set_irq_chip_data(j, bank);
+		irq_set_chip_data(j, bank);
 		if (bank_is_mpuio(bank))
-			set_irq_chip(j, &mpuio_irq_chip);
+			irq_set_chip(j, &mpuio_irq_chip);
 		else
-			set_irq_chip(j, &gpio_irq_chip);
-		set_irq_handler(j, handle_simple_irq);
+			irq_set_chip(j, &gpio_irq_chip);
+		irq_set_handler(j, handle_simple_irq);
 		set_irq_flags(j, IRQF_VALID);
 	}
-	set_irq_chained_handler(bank->irq, gpio_irq_handler);
-	set_irq_data(bank->irq, bank);
+	irq_set_chained_handler(bank->irq, gpio_irq_handler);
+	irq_set_handler_data(bank->irq, bank);
 }
 
 static int __devinit omap_gpio_probe(struct platform_device *pdev)
Index: linux-2.6-tip/arch/arm/plat-orion/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-orion/gpio.c
+++ linux-2.6-tip/arch/arm/plat-orion/gpio.c
@@ -474,9 +474,9 @@ void __init orion_gpio_init(int gpio_bas
 	for (i = 0; i < ngpio; i++) {
 		unsigned int irq = secondary_irq_base + i;
 
-		set_irq_chip(irq, &orion_gpio_irq_chip);
-		set_irq_handler(irq, handle_level_irq);
-		set_irq_chip_data(irq, ochip);
+		irq_set_chip(irq, &orion_gpio_irq_chip);
+		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_data(irq, ochip);
 		irq_set_status_flags(irq, IRQ_LEVEL);
 		set_irq_flags(irq, IRQF_VALID);
 	}
Index: linux-2.6-tip/arch/arm/plat-orion/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-orion/irq.c
+++ linux-2.6-tip/arch/arm/plat-orion/irq.c
@@ -56,9 +56,9 @@ void __init orion_irq_init(unsigned int 
 	for (i = 0; i < 32; i++) {
 		unsigned int irq = irq_start + i;
 
-		set_irq_chip(irq, &orion_irq_chip);
-		set_irq_chip_data(irq, maskaddr);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &orion_irq_chip);
+		irq_set_chip_data(irq, maskaddr);
+		irq_set_handler(irq, handle_level_irq);
 		irq_set_status_flags(irq, IRQ_LEVEL);
 		set_irq_flags(irq, IRQF_VALID);
 	}
Index: linux-2.6-tip/arch/arm/plat-pxa/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-pxa/gpio.c
+++ linux-2.6-tip/arch/arm/plat-pxa/gpio.c
@@ -284,13 +284,13 @@ void __init pxa_init_gpio(int mux_irq, i
 	}
 
 	for (irq  = gpio_to_irq(start); irq <= gpio_to_irq(end); irq++) {
-		set_irq_chip(irq, &pxa_muxed_gpio_chip);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &pxa_muxed_gpio_chip);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	/* Install handler for GPIO>=2 edge detect interrupts */
-	set_irq_chained_handler(mux_irq, pxa_gpio_demux_handler);
+	irq_set_chained_handler(mux_irq, pxa_gpio_demux_handler);
 	pxa_muxed_gpio_chip.irq_set_wake = fn;
 }
 
Index: linux-2.6-tip/arch/arm/plat-s3c24xx/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-s3c24xx/irq.c
+++ linux-2.6-tip/arch/arm/plat-s3c24xx/irq.c
@@ -592,8 +592,8 @@ void __init s3c24xx_init_irq(void)
 		case IRQ_UART1:
 		case IRQ_UART2:
 		case IRQ_ADCPARENT:
-			set_irq_chip(irqno, &s3c_irq_level_chip);
-			set_irq_handler(irqno, handle_level_irq);
+			irq_set_chip(irqno, &s3c_irq_level_chip);
+			irq_set_handler(irqno, handle_level_irq);
 			break;
 
 		case IRQ_RESERVED6:
@@ -603,35 +603,35 @@ void __init s3c24xx_init_irq(void)
 
 		default:
 			//irqdbf("registering irq %d (s3c irq)\n", irqno);
-			set_irq_chip(irqno, &s3c_irq_chip);
-			set_irq_handler(irqno, handle_edge_irq);
+			irq_set_chip(irqno, &s3c_irq_chip);
+			irq_set_handler(irqno, handle_edge_irq);
 			set_irq_flags(irqno, IRQF_VALID);
 		}
 	}
 
 	/* setup the cascade irq handlers */
 
-	set_irq_chained_handler(IRQ_EINT4t7, s3c_irq_demux_extint4t7);
-	set_irq_chained_handler(IRQ_EINT8t23, s3c_irq_demux_extint8);
+	irq_set_chained_handler(IRQ_EINT4t7, s3c_irq_demux_extint4t7);
+	irq_set_chained_handler(IRQ_EINT8t23, s3c_irq_demux_extint8);
 
-	set_irq_chained_handler(IRQ_UART0, s3c_irq_demux_uart0);
-	set_irq_chained_handler(IRQ_UART1, s3c_irq_demux_uart1);
-	set_irq_chained_handler(IRQ_UART2, s3c_irq_demux_uart2);
-	set_irq_chained_handler(IRQ_ADCPARENT, s3c_irq_demux_adc);
+	irq_set_chained_handler(IRQ_UART0, s3c_irq_demux_uart0);
+	irq_set_chained_handler(IRQ_UART1, s3c_irq_demux_uart1);
+	irq_set_chained_handler(IRQ_UART2, s3c_irq_demux_uart2);
+	irq_set_chained_handler(IRQ_ADCPARENT, s3c_irq_demux_adc);
 
 	/* external interrupts */
 
 	for (irqno = IRQ_EINT0; irqno <= IRQ_EINT3; irqno++) {
 		irqdbf("registering irq %d (ext int)\n", irqno);
-		set_irq_chip(irqno, &s3c_irq_eint0t4);
-		set_irq_handler(irqno, handle_edge_irq);
+		irq_set_chip(irqno, &s3c_irq_eint0t4);
+		irq_set_handler(irqno, handle_edge_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
 	for (irqno = IRQ_EINT4; irqno <= IRQ_EINT23; irqno++) {
 		irqdbf("registering irq %d (extended s3c irq)\n", irqno);
-		set_irq_chip(irqno, &s3c_irqext_chip);
-		set_irq_handler(irqno, handle_edge_irq);
+		irq_set_chip(irqno, &s3c_irqext_chip);
+		irq_set_handler(irqno, handle_edge_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
@@ -641,29 +641,29 @@ void __init s3c24xx_init_irq(void)
 
 	for (irqno = IRQ_S3CUART_RX0; irqno <= IRQ_S3CUART_ERR0; irqno++) {
 		irqdbf("registering irq %d (s3c uart0 irq)\n", irqno);
-		set_irq_chip(irqno, &s3c_irq_uart0);
-		set_irq_handler(irqno, handle_level_irq);
+		irq_set_chip(irqno, &s3c_irq_uart0);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
 	for (irqno = IRQ_S3CUART_RX1; irqno <= IRQ_S3CUART_ERR1; irqno++) {
 		irqdbf("registering irq %d (s3c uart1 irq)\n", irqno);
-		set_irq_chip(irqno, &s3c_irq_uart1);
-		set_irq_handler(irqno, handle_level_irq);
+		irq_set_chip(irqno, &s3c_irq_uart1);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
 	for (irqno = IRQ_S3CUART_RX2; irqno <= IRQ_S3CUART_ERR2; irqno++) {
 		irqdbf("registering irq %d (s3c uart2 irq)\n", irqno);
-		set_irq_chip(irqno, &s3c_irq_uart2);
-		set_irq_handler(irqno, handle_level_irq);
+		irq_set_chip(irqno, &s3c_irq_uart2);
+		irq_set_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
 	for (irqno = IRQ_TC; irqno <= IRQ_ADC; irqno++) {
 		irqdbf("registering irq %d (s3c adc irq)\n", irqno);
-		set_irq_chip(irqno, &s3c_irq_adc);
-		set_irq_handler(irqno, handle_edge_irq);
+		irq_set_chip(irqno, &s3c_irq_adc);
+		irq_set_handler(irqno, handle_edge_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-s5p/irq-eint.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-s5p/irq-eint.c
+++ linux-2.6-tip/arch/arm/plat-s5p/irq-eint.c
@@ -205,15 +205,15 @@ int __init s5p_init_irq_eint(void)
 	int irq;
 
 	for (irq = IRQ_EINT(0); irq <= IRQ_EINT(15); irq++)
-		set_irq_chip(irq, &s5p_irq_vic_eint);
+		irq_set_chip(irq, &s5p_irq_vic_eint);
 
 	for (irq = IRQ_EINT(16); irq <= IRQ_EINT(31); irq++) {
-		set_irq_chip(irq, &s5p_irq_eint);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &s5p_irq_eint);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
-	set_irq_chained_handler(IRQ_EINT16_31, s5p_irq_demux_eint16_31);
+	irq_set_chained_handler(IRQ_EINT16_31, s5p_irq_demux_eint16_31);
 	return 0;
 }
 
Index: linux-2.6-tip/arch/arm/plat-s5p/irq-gpioint.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-s5p/irq-gpioint.c
+++ linux-2.6-tip/arch/arm/plat-s5p/irq-gpioint.c
@@ -43,13 +43,13 @@ LIST_HEAD(banks);
 
 static int s5p_gpioint_get_offset(struct irq_data *data)
 {
-	struct s3c_gpio_chip *chip = irq_data_get_irq_data(data);
+	struct s3c_gpio_chip *chip = irq_data_get_irq_handler_data(data);
 	return data->irq - chip->irq_base;
 }
 
 static void s5p_gpioint_ack(struct irq_data *data)
 {
-	struct s3c_gpio_chip *chip = irq_data_get_irq_data(data);
+	struct s3c_gpio_chip *chip = irq_data_get_irq_handler_data(data);
 	int group, offset, pend_offset;
 	unsigned int value;
 
@@ -64,7 +64,7 @@ static void s5p_gpioint_ack(struct irq_d
 
 static void s5p_gpioint_mask(struct irq_data *data)
 {
-	struct s3c_gpio_chip *chip = irq_data_get_irq_data(data);
+	struct s3c_gpio_chip *chip = irq_data_get_irq_handler_data(data);
 	int group, offset, mask_offset;
 	unsigned int value;
 
@@ -79,7 +79,7 @@ static void s5p_gpioint_mask(struct irq_
 
 static void s5p_gpioint_unmask(struct irq_data *data)
 {
-	struct s3c_gpio_chip *chip = irq_data_get_irq_data(data);
+	struct s3c_gpio_chip *chip = irq_data_get_irq_handler_data(data);
 	int group, offset, mask_offset;
 	unsigned int value;
 
@@ -100,7 +100,7 @@ static void s5p_gpioint_mask_ack(struct 
 
 static int s5p_gpioint_set_type(struct irq_data *data, unsigned int type)
 {
-	struct s3c_gpio_chip *chip = irq_data_get_irq_data(data);
+	struct s3c_gpio_chip *chip = irq_data_get_irq_handler_data(data);
 	int group, offset, con_offset;
 	unsigned int value;
 
@@ -149,7 +149,7 @@ static struct irq_chip s5p_gpioint = {
 
 static void s5p_gpioint_handler(unsigned int irq, struct irq_desc *desc)
 {
-	struct s5p_gpioint_bank *bank = get_irq_data(irq);
+	struct s5p_gpioint_bank *bank = irq_get_handler_data(irq);
 	int group, pend_offset, mask_offset;
 	unsigned int pend, mask;
 
@@ -200,8 +200,8 @@ static __init int s5p_gpioint_add(struct
 		if (!bank->chips)
 			return -ENOMEM;
 
-		set_irq_chained_handler(bank->irq, s5p_gpioint_handler);
-		set_irq_data(bank->irq, bank);
+		irq_set_chained_handler(bank->irq, s5p_gpioint_handler);
+		irq_set_handler_data(bank->irq, bank);
 		bank->handler = s5p_gpioint_handler;
 		printk(KERN_INFO "Registered chained gpio int handler for interrupt %d.\n",
 		       bank->irq);
@@ -219,9 +219,9 @@ static __init int s5p_gpioint_add(struct
 	bank->chips[group - bank->start] = chip;
 	for (i = 0; i < chip->chip.ngpio; i++) {
 		irq = chip->irq_base + i;
-		set_irq_chip(irq, &s5p_gpioint);
-		set_irq_data(irq, chip);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &s5p_gpioint);
+		irq_set_handler_data(irq, chip);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 	return 0;
Index: linux-2.6-tip/arch/arm/plat-samsung/irq-uart.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-samsung/irq-uart.c
+++ linux-2.6-tip/arch/arm/plat-samsung/irq-uart.c
@@ -117,9 +117,9 @@ static void __init s3c_init_uart_irq(str
 	for (offs = 0; offs < 3; offs++) {
 		irq = uirq->base_irq + offs;
 
-		set_irq_chip(irq, &s3c_irq_uart);
-		set_irq_chip_data(irq, uirq);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &s3c_irq_uart);
+		irq_set_chip_data(irq, uirq);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-spear/shirq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-spear/shirq.c
+++ linux-2.6-tip/arch/arm/plat-spear/shirq.c
@@ -68,7 +68,7 @@ static struct irq_chip shirq_chip = {
 static void shirq_handler(unsigned irq, struct irq_desc *desc)
 {
 	u32 i, val, mask;
-	struct spear_shirq *shirq = get_irq_data(irq);
+	struct spear_shirq *shirq = irq_get_handler_data(irq);
 
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 	while ((val = readl(shirq->regs.base + shirq->regs.status_reg) &
@@ -105,14 +105,14 @@ int spear_shirq_register(struct spear_sh
 	if (!shirq->dev_count)
 		return -EINVAL;
 
-	set_irq_chained_handler(shirq->irq, shirq_handler);
+	irq_set_chained_handler(shirq->irq, shirq_handler);
 	for (i = 0; i < shirq->dev_count; i++) {
-		set_irq_chip(shirq->dev_config[i].virq, &shirq_chip);
-		set_irq_handler(shirq->dev_config[i].virq, handle_simple_irq);
+		irq_set_chip(shirq->dev_config[i].virq, &shirq_chip);
+		irq_set_handler(shirq->dev_config[i].virq, handle_simple_irq);
 		set_irq_flags(shirq->dev_config[i].virq, IRQF_VALID);
-		set_irq_chip_data(shirq->dev_config[i].virq, shirq);
+		irq_set_chip_data(shirq->dev_config[i].virq, shirq);
 	}
 
-	set_irq_data(shirq->irq, shirq);
+	irq_set_handler_data(shirq->irq, shirq);
 	return 0;
 }
Index: linux-2.6-tip/arch/arm/plat-stmp3xxx/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-stmp3xxx/irq.c
+++ linux-2.6-tip/arch/arm/plat-stmp3xxx/irq.c
@@ -35,8 +35,8 @@ void __init stmp3xxx_init_irq(struct irq
 	/* Disable all interrupts initially */
 	for (i = 0; i < NR_REAL_IRQS; i++) {
 		chip->irq_mask(irq_get_irq_data(i));
-		set_irq_chip(i, chip);
-		set_irq_handler(i, handle_level_irq);
+		irq_set_chip(i, chip);
+		irq_set_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-stmp3xxx/pinmux.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-stmp3xxx/pinmux.c
+++ linux-2.6-tip/arch/arm/plat-stmp3xxx/pinmux.c
@@ -489,7 +489,7 @@ static void stmp3xxx_gpio_free(struct gp
 
 static void stmp3xxx_gpio_irq(u32 irq, struct irq_desc *desc)
 {
-	struct stmp3xxx_pinmux_bank *pm = get_irq_data(irq);
+	struct stmp3xxx_pinmux_bank *pm = irq_get_handler_data(irq);
 	int gpio_irq = pm->virq;
 	u32 stat = __raw_readl(pm->irqstat);
 
@@ -533,15 +533,15 @@ int __init stmp3xxx_pinmux_init(int virt
 
 		for (virq = pm->virq; virq < pm->virq; virq++) {
 			gpio_irq_chip.irq_mask(irq_get_irq_data(virq));
-			set_irq_chip(virq, &gpio_irq_chip);
-			set_irq_handler(virq, handle_level_irq);
+			irq_set_chip(virq, &gpio_irq_chip);
+			irq_set_handler(virq, handle_level_irq);
 			set_irq_flags(virq, IRQF_VALID);
 		}
 		r = gpiochip_add(&pm->chip);
 		if (r < 0)
 			break;
-		set_irq_chained_handler(pm->irq, stmp3xxx_gpio_irq);
-		set_irq_data(pm->irq, pm);
+		irq_set_chained_handler(pm->irq, stmp3xxx_gpio_irq);
+		irq_set_handler_data(pm->irq, pm);
 	}
 	return r;
 }


