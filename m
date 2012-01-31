Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2AaQrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:47:15 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53858 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2AaQrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:47:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 31 Jan 2012 17:47:14 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH] ARM: Exynos4: Bring exynos4-dt up to date
In-reply-to: <1328028434-30139-1-git-send-email-k.lewandowsk@samsung.com>
To: thomas.abraham@linaro.org
Cc: m.szyprowski@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        kyungmin.park@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1328028434-30139-2-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.8.3
References: <1328028434-30139-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit brings exynos4-dt in line with recent changes to
mach-exynos tree, specifically:

 - Fixes build break related to replacing plat/exynos4.h with common.h
   in commit cc511b8d84d8 ("ARM: 7257/1: EXYNOS: introduce
   arch/arm/mach-exynos/common.[ch]")

 - Converts machine to use CONFIG_MULTI_IRQ_HANDLER as done for other
   machines in commit 4e44d2cb95bd ("ARM: exynos4: convert to
   CONFIG_MULTI_IRQ_HANDLER") converted all exynos boards but
   exynos4-dt.c.

 - Adds restart specifier as done for other machines in commit
   9eb4859564d6 ("ARM: 7262/1: restart: EXYNOS: use new restart hook")

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos/mach-exynos4-dt.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index 85fa027..e6b02fd 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -15,11 +15,13 @@
 #include <linux/serial_core.h>
 
 #include <asm/mach/arch.h>
+#include <asm/hardware/gic.h>
 #include <mach/map.h>
 
 #include <plat/cpu.h>
 #include <plat/regs-serial.h>
-#include <plat/exynos4.h>
+
+#include "common.h"
 
 /*
  * The following lookup table is used to override device names when devices
@@ -60,7 +62,7 @@ static const struct of_dev_auxdata exynos4210_auxdata_lookup[] __initconst = {
 
 static void __init exynos4210_dt_map_io(void)
 {
-	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
+	exynos_init_io(NULL, 0);
 	s3c24xx_init_clocks(24000000);
 }
 
@@ -79,7 +81,9 @@ DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4 (Flattened Device Tree)")
 	/* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
 	.init_irq	= exynos4_init_irq,
 	.map_io		= exynos4210_dt_map_io,
+	.handle_irq	= gic_handle_irq,
 	.init_machine	= exynos4210_dt_machine_init,
 	.timer		= &exynos4_timer,
 	.dt_compat	= exynos4210_dt_compat,
+	.restart        = exynos4_restart,
 MACHINE_END
-- 
1.7.8.3

