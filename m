Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab2BQRum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:50:42 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:40075 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2BQRuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:50:39 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/18] ARM: at91: move at91rm9200 sdramc defines to at91rm9200_sdramc.h
Date: Fri, 17 Feb 2012 18:49:59 +0100
Message-Id: <2c1cd58cd9d299ca4b70d82b6bf60f07ba22b952.1329500622.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

This cleanup is done to allow to have multiple SoC in the same image.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/include/mach/at91rm9200_mc.h    |   44 --------------
 .../arm/mach-at91/include/mach/at91rm9200_sdramc.h |   63 ++++++++++++++++++++
 arch/arm/mach-at91/pm.c                            |    2 +-
 arch/arm/mach-at91/pm.h                            |    7 +-
 arch/arm/mach-at91/pm_slowclock.S                  |    3 +-
 5 files changed, 70 insertions(+), 49 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h

diff --git a/arch/arm/mach-at91/include/mach/at91rm9200_mc.h b/arch/arm/mach-at91/include/mach/at91rm9200_mc.h
index d34e4ed..0eb031b 100644
--- a/arch/arm/mach-at91/include/mach/at91rm9200_mc.h
+++ b/arch/arm/mach-at91/include/mach/at91rm9200_mc.h
@@ -87,50 +87,6 @@
 #define		AT91_SMC_RWHOLD		(7 << 28)		/* Read & Write Signal Hold Time */
 #define			AT91_SMC_RWHOLD_(x)	((x) << 28)
 
-/* SDRAM Controller registers */
-#define AT91_SDRAMC_MR		(AT91_MC + 0x90)	/* Mode Register */
-#define		AT91_SDRAMC_MODE	(0xf << 0)		/* Command Mode */
-#define			AT91_SDRAMC_MODE_NORMAL		(0 << 0)
-#define			AT91_SDRAMC_MODE_NOP		(1 << 0)
-#define			AT91_SDRAMC_MODE_PRECHARGE	(2 << 0)
-#define			AT91_SDRAMC_MODE_LMR		(3 << 0)
-#define			AT91_SDRAMC_MODE_REFRESH	(4 << 0)
-#define		AT91_SDRAMC_DBW		(1   << 4)		/* Data Bus Width */
-#define			AT91_SDRAMC_DBW_32	(0 << 4)
-#define			AT91_SDRAMC_DBW_16	(1 << 4)
-
-#define AT91_SDRAMC_TR		(AT91_MC + 0x94)	/* Refresh Timer Register */
-#define		AT91_SDRAMC_COUNT	(0xfff << 0)		/* Refresh Timer Count */
-
-#define AT91_SDRAMC_CR		(AT91_MC + 0x98)	/* Configuration Register */
-#define		AT91_SDRAMC_NC		(3   <<  0)		/* Number of Column Bits */
-#define			AT91_SDRAMC_NC_8	(0 << 0)
-#define			AT91_SDRAMC_NC_9	(1 << 0)
-#define			AT91_SDRAMC_NC_10	(2 << 0)
-#define			AT91_SDRAMC_NC_11	(3 << 0)
-#define		AT91_SDRAMC_NR		(3   <<  2)		/* Number of Row Bits */
-#define			AT91_SDRAMC_NR_11	(0 << 2)
-#define			AT91_SDRAMC_NR_12	(1 << 2)
-#define			AT91_SDRAMC_NR_13	(2 << 2)
-#define		AT91_SDRAMC_NB		(1   <<  4)		/* Number of Banks */
-#define			AT91_SDRAMC_NB_2	(0 << 4)
-#define			AT91_SDRAMC_NB_4	(1 << 4)
-#define		AT91_SDRAMC_CAS		(3   <<  5)		/* CAS Latency */
-#define			AT91_SDRAMC_CAS_2	(2 << 5)
-#define		AT91_SDRAMC_TWR		(0xf <<  7)		/* Write Recovery Delay */
-#define		AT91_SDRAMC_TRC		(0xf << 11)		/* Row Cycle Delay */
-#define		AT91_SDRAMC_TRP		(0xf << 15)		/* Row Precharge Delay */
-#define		AT91_SDRAMC_TRCD	(0xf << 19)		/* Row to Column Delay */
-#define		AT91_SDRAMC_TRAS	(0xf << 23)		/* Active to Precharge Delay */
-#define		AT91_SDRAMC_TXSR	(0xf << 27)		/* Exit Self Refresh to Active Delay */
-
-#define AT91_SDRAMC_SRR		(AT91_MC + 0x9c)	/* Self Refresh Register */
-#define AT91_SDRAMC_LPR		(AT91_MC + 0xa0)	/* Low Power Register */
-#define AT91_SDRAMC_IER		(AT91_MC + 0xa4)	/* Interrupt Enable Register */
-#define AT91_SDRAMC_IDR		(AT91_MC + 0xa8)	/* Interrupt Disable Register */
-#define AT91_SDRAMC_IMR		(AT91_MC + 0xac)	/* Interrupt Mask Register */
-#define AT91_SDRAMC_ISR		(AT91_MC + 0xb0)	/* Interrupt Status Register */
-
 /* Burst Flash Controller register */
 #define AT91_BFC_MR		(AT91_MC + 0xc0)	/* Mode Register */
 #define		AT91_BFC_BFCOM		(3   <<  0)		/* Burst Flash Controller Operating Mode */
diff --git a/arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h b/arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
new file mode 100644
index 0000000..7ad3597
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
@@ -0,0 +1,63 @@
+/*
+ * arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
+ *
+ * Copyright (C) 2005 Ivan Kokshaysky
+ * Copyright (C) SAN People
+ *
+ * Memory Controllers (SDRAMC only) - System peripherals registers.
+ * Based on AT91RM9200 datasheet revision E.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef AT91RM9200_SDRAMC_H
+#define AT91RM9200_SDRAMC_H
+
+/* SDRAM Controller registers */
+#define AT91RM9200_SDRAMC_MR		(AT91_MC + 0x90)	/* Mode Register */
+#define		AT91RM9200_SDRAMC_MODE	(0xf << 0)		/* Command Mode */
+#define			AT91RM9200_SDRAMC_MODE_NORMAL		(0 << 0)
+#define			AT91RM9200_SDRAMC_MODE_NOP		(1 << 0)
+#define			AT91RM9200_SDRAMC_MODE_PRECHARGE	(2 << 0)
+#define			AT91RM9200_SDRAMC_MODE_LMR		(3 << 0)
+#define			AT91RM9200_SDRAMC_MODE_REFRESH	(4 << 0)
+#define		AT91RM9200_SDRAMC_DBW		(1   << 4)		/* Data Bus Width */
+#define			AT91RM9200_SDRAMC_DBW_32	(0 << 4)
+#define			AT91RM9200_SDRAMC_DBW_16	(1 << 4)
+
+#define AT91RM9200_SDRAMC_TR		(AT91_MC + 0x94)	/* Refresh Timer Register */
+#define		AT91RM9200_SDRAMC_COUNT	(0xfff << 0)		/* Refresh Timer Count */
+
+#define AT91RM9200_SDRAMC_CR		(AT91_MC + 0x98)	/* Configuration Register */
+#define		AT91RM9200_SDRAMC_NC		(3   <<  0)		/* Number of Column Bits */
+#define			AT91RM9200_SDRAMC_NC_8	(0 << 0)
+#define			AT91RM9200_SDRAMC_NC_9	(1 << 0)
+#define			AT91RM9200_SDRAMC_NC_10	(2 << 0)
+#define			AT91RM9200_SDRAMC_NC_11	(3 << 0)
+#define		AT91RM9200_SDRAMC_NR		(3   <<  2)		/* Number of Row Bits */
+#define			AT91RM9200_SDRAMC_NR_11	(0 << 2)
+#define			AT91RM9200_SDRAMC_NR_12	(1 << 2)
+#define			AT91RM9200_SDRAMC_NR_13	(2 << 2)
+#define		AT91RM9200_SDRAMC_NB		(1   <<  4)		/* Number of Banks */
+#define			AT91RM9200_SDRAMC_NB_2	(0 << 4)
+#define			AT91RM9200_SDRAMC_NB_4	(1 << 4)
+#define		AT91RM9200_SDRAMC_CAS		(3   <<  5)		/* CAS Latency */
+#define			AT91RM9200_SDRAMC_CAS_2	(2 << 5)
+#define		AT91RM9200_SDRAMC_TWR		(0xf <<  7)		/* Write Recovery Delay */
+#define		AT91RM9200_SDRAMC_TRC		(0xf << 11)		/* Row Cycle Delay */
+#define		AT91RM9200_SDRAMC_TRP		(0xf << 15)		/* Row Precharge Delay */
+#define		AT91RM9200_SDRAMC_TRCD	(0xf << 19)		/* Row to Column Delay */
+#define		AT91RM9200_SDRAMC_TRAS	(0xf << 23)		/* Active to Precharge Delay */
+#define		AT91RM9200_SDRAMC_TXSR	(0xf << 27)		/* Exit Self Refresh to Active Delay */
+
+#define AT91RM9200_SDRAMC_SRR		(AT91_MC + 0x9c)	/* Self Refresh Register */
+#define AT91RM9200_SDRAMC_LPR		(AT91_MC + 0xa0)	/* Low Power Register */
+#define AT91RM9200_SDRAMC_IER		(AT91_MC + 0xa4)	/* Interrupt Enable Register */
+#define AT91RM9200_SDRAMC_IDR		(AT91_MC + 0xa8)	/* Interrupt Disable Register */
+#define AT91RM9200_SDRAMC_IMR		(AT91_MC + 0xac)	/* Interrupt Mask Register */
+#define AT91RM9200_SDRAMC_ISR		(AT91_MC + 0xb0)	/* Interrupt Status Register */
+
+#endif
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index aac00ce..8046a50 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -315,7 +315,7 @@ static int __init at91_pm_init(void)
 
 #ifdef CONFIG_ARCH_AT91RM9200
 	/* AT91RM9200 SDRAM low-power mode cannot be used with self-refresh. */
-	at91_sys_write(AT91_SDRAMC_LPR, 0);
+	at91_sys_write(AT91RM9200_SDRAMC_LPR, 0);
 #endif
 
 	suspend_set_ops(&at91_pm_ops);
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index bba9ce1..41cdd2b 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -13,6 +13,7 @@
 
 #ifdef CONFIG_ARCH_AT91RM9200
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91rm9200_sdramc.h>
 
 /*
  * The AT91RM9200 goes into self-refresh mode with this command, and will
@@ -26,7 +27,7 @@
 
 static inline void at91rm9200_standby(void)
 {
-	u32 lpr = at91_sys_read(AT91_SDRAMC_LPR);
+	u32 lpr = at91_sys_read(AT91RM9200_SDRAMC_LPR);
 
 	asm volatile(
 		"b    1f\n\t"
@@ -37,8 +38,8 @@ static inline void at91rm9200_standby(void)
 		"    mcr    p15, 0, %0, c7, c0, 4\n\t"
 		"    str    %5, [%1, %2]"
 		:
-		: "r" (0), "r" (AT91_BASE_SYS), "r" (AT91_SDRAMC_LPR),
-		  "r" (1), "r" (AT91_SDRAMC_SRR),
+		: "r" (0), "r" (AT91_BASE_SYS), "r" (AT91RM9200_SDRAMC_LPR),
+		  "r" (1), "r" (AT91RM9200_SDRAMC_SRR),
 		  "r" (lpr));
 }
 
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 33fc4a7..c2cc7d4 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -18,6 +18,7 @@
 
 #if defined(CONFIG_ARCH_AT91RM9200)
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91rm9200_sdramc.h>
 #elif defined(CONFIG_ARCH_AT91SAM9G45)
 #include <mach/at91sam9_ddrsdr.h>
 #else
@@ -131,7 +132,7 @@ ENTRY(at91_slow_clock)
 #ifdef CONFIG_ARCH_AT91RM9200
 	/* Put SDRAM in self-refresh mode */
 	mov	tmp1, #1
-	str	tmp1, [sdramc, #AT91_SDRAMC_SRR]
+	str	tmp1, [sdramc, #AT91RM9200_SDRAMC_SRR]
 #elif defined(CONFIG_ARCH_AT91SAM9G45)
 
 	/* prepare for DDRAM self-refresh mode */
-- 
1.7.9

