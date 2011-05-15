Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1EOXiH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:38:07 -0400
Received: from mail.df.lth.se ([194.47.250.12]:22997 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab1EOXiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:38:02 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/13] mach-ux500: make PRCMU base address dynamic
Date: Mon, 16 May 2011 01:38:00 +0200
Message-Id: <1305502680-32612-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the PRCMU base address be selected at runtime for U8500
and U5500 instead of being compiled-in.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/cpu-db5500.c              |    2 ++
 arch/arm/mach-ux500/cpu-db8500.c              |    2 ++
 arch/arm/mach-ux500/cpu.c                     |    2 ++
 arch/arm/mach-ux500/include/mach/hardware.h   |    1 +
 arch/arm/mach-ux500/include/mach/prcmu-regs.h |    2 --
 5 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db5500.c b/arch/arm/mach-ux500/cpu-db5500.c
index c9dc2ef..c01bc19 100644
--- a/arch/arm/mach-ux500/cpu-db5500.c
+++ b/arch/arm/mach-ux500/cpu-db5500.c
@@ -188,6 +188,8 @@ void __init u5500_map_io(void)
 	ux500_map_io();
 
 	iotable_init(u5500_io_desc, ARRAY_SIZE(u5500_io_desc));
+
+	_PRCMU_BASE = __io_address(U5500_PRCMU_BASE);
 }
 
 static int usb_db5500_rx_dma_cfg[] = {
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 516126c..3d419fe 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -87,6 +87,8 @@ void __init u8500_map_io(void)
 		iotable_init(u8500_v1_io_desc, ARRAY_SIZE(u8500_v1_io_desc));
 	else if (cpu_is_u8500v2())
 		iotable_init(u8500_v2_io_desc, ARRAY_SIZE(u8500_v2_io_desc));
+
+	_PRCMU_BASE = __io_address(U8500_PRCMU_BASE);
 }
 
 static struct resource db8500_pmu_resources[] = {
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 5a43107..0190e0e 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -23,6 +23,8 @@
 
 #include "clock.h"
 
+void __iomem *_PRCMU_BASE;
+
 #ifdef CONFIG_CACHE_L2X0
 static void __iomem *l2x0_base;
 #endif
diff --git a/arch/arm/mach-ux500/include/mach/hardware.h b/arch/arm/mach-ux500/include/mach/hardware.h
index bf63f26..2c6f710 100644
--- a/arch/arm/mach-ux500/include/mach/hardware.h
+++ b/arch/arm/mach-ux500/include/mach/hardware.h
@@ -35,6 +35,7 @@
 #ifndef __ASSEMBLY__
 
 #include <mach/id.h>
+extern void __iomem *_PRCMU_BASE;
 
 #define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
 
diff --git a/arch/arm/mach-ux500/include/mach/prcmu-regs.h b/arch/arm/mach-ux500/include/mach/prcmu-regs.h
index 455467e..c1226da 100644
--- a/arch/arm/mach-ux500/include/mach/prcmu-regs.h
+++ b/arch/arm/mach-ux500/include/mach/prcmu-regs.h
@@ -15,8 +15,6 @@
 
 #include <mach/hardware.h>
 
-#define _PRCMU_BASE		IO_ADDRESS(U8500_PRCMU_BASE)
-
 #define PRCM_ARM_PLLDIVPS	(_PRCMU_BASE + 0x118)
 #define PRCM_ARM_CHGCLKREQ	(_PRCMU_BASE + 0x114)
 #define PRCM_PLLARM_ENABLE	(_PRCMU_BASE + 0x98)
-- 
1.7.4.4

