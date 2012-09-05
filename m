Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab2IEJ7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:59:53 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:57540 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758407Ab2IEJ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:47 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>
Subject: [PATCH 03/17] arm: ux500: Create board-specific IRQ init callback
Date: Wed, 5 Sep 2012 11:58:59 +0200
Message-ID: <1346839153-6465-4-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First step to have a cpu-specific prcmu early init.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c | 15 +++++++++++----
 arch/arm/mach-ux500/cpu.c          |  2 --
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index fa75f95..057dfdb 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -21,6 +21,7 @@
 #include <linux/amba/pl022.h>
 #include <linux/amba/serial.h>
 #include <linux/spi/spi.h>
+#include <linux/mfd/dbx500-prcmu.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/ab8500.h>
 #include <linux/mfd/tc3589x.h>
@@ -715,12 +716,18 @@ static void __init u9540_init_machine(void)
 	regulator_has_full_constraints();
 }
 
+static void __init mop500_init_irq(void)
+{
+	prcmu_early_init();
+	ux500_init_irq();
+}
+
 MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
 	/* Maintainer: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com> */
 	.atag_offset	= 0x100,
 	.map_io		= u8500_map_io,
 	.nr_irqs	= UX500_NR_IRQS,
-	.init_irq	= ux500_init_irq,
+	.init_irq	= mop500_init_irq,
 	/* we re-use nomadik timer here */
 	.timer		= &ux500_timer,
 	.handle_irq	= gic_handle_irq,
@@ -732,7 +739,7 @@ MACHINE_START(HREFV60, "ST-Ericsson U8500 Platform HREFv60+")
 	.atag_offset	= 0x100,
 	.map_io		= u8500_map_io,
 	.nr_irqs	= UX500_NR_IRQS,
-	.init_irq	= ux500_init_irq,
+	.init_irq	= mop500_init_irq,
 	.timer		= &ux500_timer,
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= hrefv60_init_machine,
@@ -743,7 +750,7 @@ MACHINE_START(SNOWBALL, "Calao Systems Snowball platform")
 	.atag_offset	= 0x100,
 	.map_io		= u8500_map_io,
 	.nr_irqs	= UX500_NR_IRQS,
-	.init_irq	= ux500_init_irq,
+	.init_irq	= mop500_init_irq,
 	/* we re-use nomadik timer here */
 	.timer		= &ux500_timer,
 	.handle_irq	= gic_handle_irq,
@@ -755,7 +762,7 @@ MACHINE_START(U9540, "ST-Ericsson 9540 platform")
 	.atag_offset	= 0x100,
 	.map_io		= u8500_map_io,
 	.nr_irqs	= UX500_NR_IRQS,
-	.init_irq	= ux500_init_irq,
+	.init_irq	= mop500_init_irq,
 	.timer		= &ux500_timer,
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= u9540_init_machine,
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 4b0a9b3..4a5177b 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -68,8 +68,6 @@ void __init ux500_init_irq(void)
 	 * Init clocks here so that they are available for system timer
 	 * initialization.
 	 */
-	if (cpu_is_u8500_family())
-		db8500_prcmu_early_init();
 	clk_init();
 }
 
-- 
1.7.11.1

