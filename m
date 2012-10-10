Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab2JJPUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:20:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54790 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab2JJPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:19:17 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/6] ARM: ux500: Add support for ST-Ericsson's u9540 SoC
Date: Wed, 10 Oct 2012 16:18:52 +0100
Message-Id: <1349882335-6786-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First level board support for the u9540.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 3d8e321..6b7f970 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/mfd/abx500/ab8500.h>
+#include <linux/mfd/dbx500-prcmu.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/regulator/machine.h>
@@ -319,6 +320,8 @@ static void __init u8500_init_machine(void)
 		snowball_pinmaps_init();
 	else if (of_machine_is_compatible("st-ericsson,hrefv60+"))
 		hrefv60_pinmaps_init();
+	else if (of_machine_is_compatible("st-ericsson,u9540")) {}
+		/* TODO: Add u9540 pinmaps. */
 
 	/* TODO: Export SoC, USB, cpu-freq and DMA40 */
 	parent = u8500_of_init_devices();
@@ -331,6 +334,7 @@ static const char * u8500_dt_board_compat[] = {
 	"calaosystems,snowball-a9500",
 	"st-ericsson,hrefv60+",
 	"st-ericsson,mop500",
+	"st-ericsson,u9540",
 	NULL,
 };
 
@@ -345,4 +349,14 @@ DT_MACHINE_START(U8500_DT, "ST-Ericsson U8500 platform (Device Tree Support)")
 	.dt_compat      = u8500_dt_board_compat,
 MACHINE_END
 
+DT_MACHINE_START(U9540_DT, "ST-Ericsson 9540 platform (Device Tree Support)")
+	.map_io		= u8500_map_io,
+	.init_irq	= ux500_init_irq,
+	.timer		= &ux500_timer,
+	.handle_irq	= gic_handle_irq,
+	.init_machine	= u8500_init_machine,
+	.init_late	= NULL,
+	.dt_compat      = u8500_dt_board_compat,
+MACHINE_END
+
 #endif
-- 
1.7.9.5

