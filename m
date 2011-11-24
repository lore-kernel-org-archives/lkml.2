Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1KXV44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:56:56 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:16836 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1KXV4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:56:54 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, robherring2@gmail.com,
        grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        plagnioj@jcrosoft.com, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/3] ARM: at91/board-dt: remove AIC irq domain from board file
Date: Thu, 24 Nov 2011 22:56:29 +0100
Message-Id: <7c73fc61e1dfd855368a052fd62cf94dd8c8bdf6.1322171620.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
References: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
In-Reply-To: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
References: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding of irqdomain in AIC code make the specification
of the irq domain in board file useless.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-dt.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-at91/board-dt.c b/arch/arm/mach-at91/board-dt.c
index bb6b434..119eda6 100644
--- a/arch/arm/mach-at91/board-dt.c
+++ b/arch/arm/mach-at91/board-dt.c
@@ -15,8 +15,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/gpio.h>
-#include <linux/irqdomain.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
 #include <mach/hardware.h>
@@ -88,17 +86,6 @@ static void __init ek_add_device_nand(void)
 	at91_add_device_nand(&ek_nand_data);
 }
 
-static const struct of_device_id aic_of_match[] __initconst = {
-	{ .compatible = "atmel,at91rm9200-aic", },
-	{},
-};
-
-static void __init at91_dt_init_irq(void)
-{
-	irq_domain_generate_simple(aic_of_match, 0xfffff000, 0);
-	at91_init_irq_default();
-}
-
 static void __init at91_dt_device_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
@@ -118,7 +105,7 @@ DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	.timer		= &at91sam926x_timer,
 	.map_io		= at91_map_io,
 	.init_early	= ek_init_early,
-	.init_irq	= at91_dt_init_irq,
+	.init_irq	= at91_init_irq_default,
 	.init_machine	= at91_dt_device_init,
 	.dt_compat	= at91_dt_board_compat,
 MACHINE_END
-- 
1.7.5.4

