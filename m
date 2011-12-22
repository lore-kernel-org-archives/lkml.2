Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1LVO7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:59:11 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34243 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab1LVO65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:58:57 -0500
From: Benoit Cousson <b-cousson@ti.com>
To: <rob.herring@calxeda.com>, <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux-i2c@vger.kernel.org>, <sameo@linux.intel.com>,
        <ben-linux@fluff.org>, Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH v4 12/12] ARM: OMAP2+: board-generic: Remove i2c static init
Date: Thu, 22 Dec 2011 15:56:46 +0100
Message-ID: <1324565806-31142-13-git-send-email-b-cousson@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
References: <1324565806-31142-1-git-send-email-b-cousson@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mainly reverts the commit that was adding the i2c static init.

Since the i2c and twl nodes are now present, there is no need
for the static initialization anymore.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-generic.c |   48 +---------------------------------
 1 files changed, 2 insertions(+), 46 deletions(-)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 2529017..38f105d 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -15,7 +15,6 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/irqdomain.h>
-#include <linux/i2c/twl.h>
 
 #include <mach/hardware.h>
 #include <asm/hardware/gic.h>
@@ -36,34 +35,6 @@ static void __init omap_init_irq(void)
 	of_irq_init(irq_match);
 }
 
-/*
- * XXX: Still needed to boot until the i2c & twl driver is adapted to
- * device-tree
- */
-#ifdef CONFIG_ARCH_OMAP4
-static struct twl4030_platform_data sdp4430_twldata = {
-	.irq_base	= TWL6030_IRQ_BASE,
-	.irq_end	= TWL6030_IRQ_END,
-};
-
-static void __init omap4_i2c_init(void)
-{
-	omap4_pmic_init("twl6030", &sdp4430_twldata);
-}
-#endif
-
-#ifdef CONFIG_ARCH_OMAP3
-static struct twl4030_platform_data beagle_twldata = {
-	.irq_base	= TWL4030_IRQ_BASE,
-	.irq_end	= TWL4030_IRQ_END,
-};
-
-static void __init omap3_i2c_init(void)
-{
-	omap3_pmic_init("twl4030", &beagle_twldata);
-}
-#endif
-
 static struct of_device_id omap_dt_match_table[] __initdata = {
 	{ .compatible = "simple-bus", },
 	{ .compatible = "ti,omap-infra", },
@@ -78,21 +49,6 @@ static void __init omap_generic_init(void)
 	of_platform_populate(NULL, omap_dt_match_table, NULL, NULL);
 }
 
-#ifdef CONFIG_ARCH_OMAP4
-static void __init omap4_init(void)
-{
-	omap4_i2c_init();
-	omap_generic_init();
-}
-#endif
-
-#ifdef CONFIG_ARCH_OMAP3
-static void __init omap3_init(void)
-{
-	omap3_i2c_init();
-	omap_generic_init();
-}
-#endif
 
 #if defined(CONFIG_SOC_OMAP2420)
 static const char *omap242x_boards_compat[] __initdata = {
@@ -145,7 +101,7 @@ DT_MACHINE_START(OMAP3_DT, "Generic OMAP3 (Flattened Device Tree)")
 	.init_early	= omap3430_init_early,
 	.init_irq	= omap_init_irq,
 	.handle_irq	= omap3_intc_handle_irq,
-	.init_machine	= omap3_init,
+	.init_machine	= omap_generic_init,
 	.timer		= &omap3_timer,
 	.dt_compat	= omap3_boards_compat,
 MACHINE_END
@@ -164,7 +120,7 @@ DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
 	.init_early	= omap4430_init_early,
 	.init_irq	= omap_init_irq,
 	.handle_irq	= gic_handle_irq,
-	.init_machine	= omap4_init,
+	.init_machine	= omap_generic_init,
 	.timer		= &omap4_timer,
 	.dt_compat	= omap4_boards_compat,
 MACHINE_END
-- 
1.7.0.4

