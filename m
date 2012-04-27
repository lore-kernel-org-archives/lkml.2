Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab2D0MYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:24:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44244 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757169Ab2D0MYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:24:46 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <greg@kroah.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Aneesh V <aneesh@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v5 1/7] ddr: add LPDDR2 data from JESD209-2
Date: Fri, 27 Apr 2012 17:54:03 +0530
Message-ID: <1335529449-28046-2-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
References: <y>
 <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh V <aneesh@ti.com>

add LPDDR2 data from the JEDEC spec JESD209-2. The data
includes:

1. Addressing information for LPDDR2 memories of different
   densities and types(S2/S4)
2. AC timing data.

This data will useful for memory controller device drivers.
Right now this is used by the TI EMIF SDRAM controller
driver.

Signed-off-by: Aneesh V <aneesh@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Benoit Cousson <b-cousson@ti.com>
[santosh.shilimkar@ti.com: Moved to drivers/memory from drivers/misc]
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Greg KH <greg@kroah.com>
---
 include/memory/jedec_ddr.h |  175 ++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig                |    8 ++
 lib/Makefile               |    2 +
 lib/jedec_ddr_data.c       |  135 ++++++++++++++++++++++++++++++++++
 4 files changed, 320 insertions(+), 0 deletions(-)
 create mode 100644 include/memory/jedec_ddr.h
 create mode 100644 lib/jedec_ddr_data.c

diff --git a/include/memory/jedec_ddr.h b/include/memory/jedec_ddr.h
new file mode 100644
index 0000000..ddad0f8
--- /dev/null
+++ b/include/memory/jedec_ddr.h
@@ -0,0 +1,175 @@
+/*
+ * Definitions for DDR memories based on JEDEC specs
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Aneesh V <aneesh@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __LINUX_JEDEC_DDR_H
+#define __LINUX_JEDEC_DDR_H
+
+#include <linux/types.h>
+
+/* DDR Densities */
+#define DDR_DENSITY_64Mb	1
+#define DDR_DENSITY_128Mb	2
+#define DDR_DENSITY_256Mb	3
+#define DDR_DENSITY_512Mb	4
+#define DDR_DENSITY_1Gb		5
+#define DDR_DENSITY_2Gb		6
+#define DDR_DENSITY_4Gb		7
+#define DDR_DENSITY_8Gb		8
+#define DDR_DENSITY_16Gb	9
+#define DDR_DENSITY_32Gb	10
+
+/* DDR type */
+#define DDR_TYPE_DDR2		1
+#define DDR_TYPE_DDR3		2
+#define DDR_TYPE_LPDDR2_S4	3
+#define DDR_TYPE_LPDDR2_S2	4
+#define DDR_TYPE_LPDDR2_NVM	5
+
+/* DDR IO width */
+#define DDR_IO_WIDTH_4		1
+#define DDR_IO_WIDTH_8		2
+#define DDR_IO_WIDTH_16		3
+#define DDR_IO_WIDTH_32		4
+
+/* Number of Row bits */
+#define R9			9
+#define R10			10
+#define R11			11
+#define R12			12
+#define R13			13
+#define R14			14
+#define R15			15
+#define R16			16
+
+/* Number of Column bits */
+#define C7			7
+#define C8			8
+#define C9			9
+#define C10			10
+#define C11			11
+#define C12			12
+
+/* Number of Banks */
+#define B1			0
+#define B2			1
+#define B4			2
+#define B8			3
+
+/* Refresh rate in nano-seconds */
+#define T_REFI_15_6		15600
+#define T_REFI_7_8		7800
+#define T_REFI_3_9		3900
+
+/* tRFC values */
+#define T_RFC_90		90000
+#define T_RFC_110		110000
+#define T_RFC_130		130000
+#define T_RFC_160		160000
+#define T_RFC_210		210000
+#define T_RFC_300		300000
+#define T_RFC_350		350000
+
+/* Mode register numbers */
+#define DDR_MR0			0
+#define DDR_MR1			1
+#define DDR_MR2			2
+#define DDR_MR3			3
+#define DDR_MR4			4
+#define DDR_MR5			5
+#define DDR_MR6			6
+#define DDR_MR7			7
+#define DDR_MR8			8
+#define DDR_MR9			9
+#define DDR_MR10		10
+#define DDR_MR11		11
+#define DDR_MR16		16
+#define DDR_MR17		17
+#define DDR_MR18		18
+
+/*
+ * LPDDR2 related defines
+ */
+
+/* MR4 register fields */
+#define MR4_SDRAM_REF_RATE_SHIFT			0
+#define MR4_SDRAM_REF_RATE_MASK				7
+#define MR4_TUF_SHIFT					7
+#define MR4_TUF_MASK					(1 << 7)
+
+/* MR4 SDRAM Refresh Rate field values */
+#define SDRAM_TEMP_NOMINAL				0x3
+#define SDRAM_TEMP_RESERVED_4				0x4
+#define SDRAM_TEMP_HIGH_DERATE_REFRESH			0x5
+#define SDRAM_TEMP_HIGH_DERATE_REFRESH_AND_TIMINGS	0x6
+#define SDRAM_TEMP_VERY_HIGH_SHUTDOWN			0x7
+
+#define NUM_DDR_ADDR_TABLE_ENTRIES			11
+#define NUM_DDR_TIMING_TABLE_ENTRIES			4
+
+/* Structure for DDR addressing info from the JEDEC spec */
+struct lpddr2_addressing {
+	u32 num_banks;
+	u32 tREFI_ns;
+	u32 tRFCab_ps;
+};
+
+/*
+ * Structure for timings from the LPDDR2 datasheet
+ * All parameters are in pico seconds(ps) unless explicitly indicated
+ * with a suffix like tRAS_max_ns below
+ */
+struct lpddr2_timings {
+	u32 max_freq;
+	u32 min_freq;
+	u32 tRPab;
+	u32 tRCD;
+	u32 tWR;
+	u32 tRAS_min;
+	u32 tRRD;
+	u32 tWTR;
+	u32 tXP;
+	u32 tRTP;
+	u32 tCKESR;
+	u32 tDQSCK_max;
+	u32 tDQSCK_max_derated;
+	u32 tFAW;
+	u32 tZQCS;
+	u32 tZQCL;
+	u32 tZQinit;
+	u32 tRAS_max_ns;
+};
+
+/*
+ * Min value for some parameters in terms of number of tCK cycles(nCK)
+ * Please set to zero parameters that are not valid for a given memory
+ * type
+ */
+struct lpddr2_min_tck {
+	u32 tRPab;
+	u32 tRCD;
+	u32 tWR;
+	u32 tRASmin;
+	u32 tRRD;
+	u32 tWTR;
+	u32 tXP;
+	u32 tRTP;
+	u32 tCKE;
+	u32 tCKESR;
+	u32 tFAW;
+};
+
+extern const struct lpddr2_addressing
+	lpddr2_jedec_addressing_table[NUM_DDR_ADDR_TABLE_ENTRIES];
+extern const struct lpddr2_timings
+	lpddr2_jedec_timings[NUM_DDR_TIMING_TABLE_ENTRIES];
+extern const struct lpddr2_min_tck lpddr2_jedec_min_tck;
+
+#endif /* __LINUX_JEDEC_DDR_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 4a8aba2..0e25c03 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -353,6 +353,14 @@ config CORDIC
 	  This option provides an implementation of the CORDIC algorithm;
 	  calculations are in fixed point. Module will be called cordic.
 
+config DDR
+	bool "JEDEC DDR data"
+	help
+	  Data from JEDEC specs for DDR SDRAM memories,
+	  particularly the AC timing parameters and addressing
+	  information. This data is useful for drivers handling
+	  DDR SDRAM controllers.
+
 config MPILIB
 	tristate
 	select CLZ_TAB
diff --git a/lib/Makefile b/lib/Makefile
index 18515f0..74290c9 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -123,6 +123,8 @@ obj-$(CONFIG_SIGNATURE) += digsig.o
 
 obj-$(CONFIG_CLZ_TAB) += clz_tab.o
 
+obj-$(CONFIG_DDR) += jedec_ddr_data.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/jedec_ddr_data.c b/lib/jedec_ddr_data.c
new file mode 100644
index 0000000..6d2cbf1
--- /dev/null
+++ b/lib/jedec_ddr_data.c
@@ -0,0 +1,135 @@
+/*
+ * DDR addressing details and AC timing parameters from JEDEC specs
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Aneesh V <aneesh@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <memory/jedec_ddr.h>
+#include <linux/module.h>
+
+/* LPDDR2 addressing details from JESD209-2 section 2.4 */
+const struct lpddr2_addressing
+	lpddr2_jedec_addressing_table[NUM_DDR_ADDR_TABLE_ENTRIES] = {
+	{B4, T_REFI_15_6, T_RFC_90}, /* 64M */
+	{B4, T_REFI_15_6, T_RFC_90}, /* 128M */
+	{B4, T_REFI_7_8,  T_RFC_90}, /* 256M */
+	{B4, T_REFI_7_8,  T_RFC_90}, /* 512M */
+	{B8, T_REFI_7_8, T_RFC_130}, /* 1GS4 */
+	{B8, T_REFI_3_9, T_RFC_130}, /* 2GS4 */
+	{B8, T_REFI_3_9, T_RFC_130}, /* 4G */
+	{B8, T_REFI_3_9, T_RFC_210}, /* 8G */
+	{B4, T_REFI_7_8, T_RFC_130}, /* 1GS2 */
+	{B4, T_REFI_3_9, T_RFC_130}, /* 2GS2 */
+};
+EXPORT_SYMBOL_GPL(lpddr2_jedec_addressing_table);
+
+/* LPDDR2 AC timing parameters from JESD209-2 section 12 */
+const struct lpddr2_timings
+	lpddr2_jedec_timings[NUM_DDR_TIMING_TABLE_ENTRIES] = {
+	/* Speed bin 400(200 MHz) */
+	[0] = {
+		.max_freq	= 200000000,
+		.min_freq	= 10000000,
+		.tRPab		= 21000,
+		.tRCD		= 18000,
+		.tWR		= 15000,
+		.tRAS_min	= 42000,
+		.tRRD		= 10000,
+		.tWTR		= 10000,
+		.tXP		= 7500,
+		.tRTP		= 7500,
+		.tCKESR		= 15000,
+		.tDQSCK_max	= 5500,
+		.tFAW		= 50000,
+		.tZQCS		= 90000,
+		.tZQCL		= 360000,
+		.tZQinit	= 1000000,
+		.tRAS_max_ns	= 70000,
+		.tDQSCK_max_derated = 6000,
+	},
+	/* Speed bin 533(266 MHz) */
+	[1] = {
+		.max_freq	= 266666666,
+		.min_freq	= 10000000,
+		.tRPab		= 21000,
+		.tRCD		= 18000,
+		.tWR		= 15000,
+		.tRAS_min	= 42000,
+		.tRRD		= 10000,
+		.tWTR		= 7500,
+		.tXP		= 7500,
+		.tRTP		= 7500,
+		.tCKESR		= 15000,
+		.tDQSCK_max	= 5500,
+		.tFAW		= 50000,
+		.tZQCS		= 90000,
+		.tZQCL		= 360000,
+		.tZQinit	= 1000000,
+		.tRAS_max_ns	= 70000,
+		.tDQSCK_max_derated = 6000,
+	},
+	/* Speed bin 800(400 MHz) */
+	[2] = {
+		.max_freq	= 400000000,
+		.min_freq	= 10000000,
+		.tRPab		= 21000,
+		.tRCD		= 18000,
+		.tWR		= 15000,
+		.tRAS_min	= 42000,
+		.tRRD		= 10000,
+		.tWTR		= 7500,
+		.tXP		= 7500,
+		.tRTP		= 7500,
+		.tCKESR		= 15000,
+		.tDQSCK_max	= 5500,
+		.tFAW		= 50000,
+		.tZQCS		= 90000,
+		.tZQCL		= 360000,
+		.tZQinit	= 1000000,
+		.tRAS_max_ns	= 70000,
+		.tDQSCK_max_derated = 6000,
+	},
+	/* Speed bin 1066(533 MHz) */
+	[3] = {
+		.max_freq	= 533333333,
+		.min_freq	= 10000000,
+		.tRPab		= 21000,
+		.tRCD		= 18000,
+		.tWR		= 15000,
+		.tRAS_min	= 42000,
+		.tRRD		= 10000,
+		.tWTR		= 7500,
+		.tXP		= 7500,
+		.tRTP		= 7500,
+		.tCKESR		= 15000,
+		.tDQSCK_max	= 5500,
+		.tFAW		= 50000,
+		.tZQCS		= 90000,
+		.tZQCL		= 360000,
+		.tZQinit	= 1000000,
+		.tRAS_max_ns	= 70000,
+		.tDQSCK_max_derated = 5620,
+	},
+};
+EXPORT_SYMBOL_GPL(lpddr2_jedec_timings);
+
+const struct lpddr2_min_tck lpddr2_jedec_min_tck = {
+	.tRPab		= 3,
+	.tRCD		= 3,
+	.tWR		= 3,
+	.tRASmin	= 3,
+	.tRRD		= 2,
+	.tWTR		= 2,
+	.tXP		= 2,
+	.tRTP		= 2,
+	.tCKE		= 3,
+	.tCKESR		= 3,
+	.tFAW		= 8
+};
+EXPORT_SYMBOL_GPL(lpddr2_jedec_min_tck);
-- 
1.7.5.4

