Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab2L1JD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 04:03:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34625 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2L1JDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 04:03:19 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-1e-50dd60187ff1
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kgene.kim@samsung.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, rjw@sisk.pl,
        jhbird.choi@samsung.com, Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [PATCH] ARM: EXYNOS5: Support Exynos5-bus devfreq driver
Date: Fri, 28 Dec 2012 04:24:09 -0500
Message-id: <1356686649-15856-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1355141166-17205-1-git-send-email-a.kesavan@samsung.com>
References: <1355141166-17205-1-git-send-email-a.kesavan@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkTlci4W6AweSVxhaXd81hs/jce4TR
	gcnj8ya5AMYoLpuU1JzMstQifbsErozvz+cxFnTdZay4Ous6cwPjom2MXYycHBICJhLnOn+w
	QNhiEhfurWfrYuTiEBJYyijRsHcDE0zRhDkTmCES0xklfvyeDuX0Mkm8ubyDDaSKTUBPYsG/
	r8wgtohAsETnlfUsIEXMAp2MEo1Hn4HtEBZwlDiw8wcriM0ioCqx6OBpsDt4BVwl/n/bwgax
	Tk7iw55H7CA2p4CbxOr7z8FqhIBqOl/8ZYToFZD4NvkQ0EwOoHpZiU0HwA6SELjPJtHWfAHq
	bEmJgytusExgFF7AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzAoT/97JrWDcWWDxSFG
	AQ5GJR7ehT13AoRYE8uKK3MPMUpwMCuJ8Or/AArxpiRWVqUW5ccXleakFh9i9AG6ZCKzlGhy
	PjBi8kriDY1NzE2NTS2NjMxMTXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpg7Lj89O6s
	t8kbLIS+rFhjF/mlI8p5d6DzS67lOzznZ+8tue286pfglQM7v0+vjde0y1D+5Bpz5LuCziaG
	srxfNUbhOfbrHl2e2NbwbJnPRKVfLs+d3scsjEp0uJ23RC0244/yygUFM8MK51ZeFI1+wNWw
	5/TsXd6zvOS7o9Yc1ausmtMs4TTNV4mlOCPRUIu5qDgRABzmLU13AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jQV2JhLsBBptuyFlc3jWHzeJz7xFG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzvj+fx1jQdZex
	4uqs68wNjIu2MXYxcnJICJhITJgzgRnCFpO4cG89WxcjF4eQwHRGiR+/pzNDOL1MEm8u72AD
	qWIT0JNY8O8rWIeIQLBE55X1LCBFzAKdjBKNR5+xgCSEBRwlDuz8wQpiswioSiw6eBpsHa+A
	q8T/b1vYINbJSXzY84gdxOYUcJNYff85WI0QUE3ni7+MExh5FzAyrGIUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQIDvlnUjsYVzZYHGIU4GBU4uFd2HMnQIg1say4MvcQowQHs5IIr/4PoBBv
	SmJlVWpRfnxRaU5q8SFGH6CrJjJLiSbnA+MxryTe0NjE3NTY1NLEwsTMEoewkjhvs0dKgJBA
	emJJanZqakFqEcw4Jg5OqQZGvi0vftyLPiUnOftiisDE1EenbN/t3fdVavJlb12hHK/7Nw1k
	DOx21eTdsw7aJTVJeLWtpvpTnptf51R9WZ9ediRAR0CkxjZh2YKSdRwnl7XuemZ93M34VILo
	guqMyccsONynhDzm3jzRo3K6fIVK929TjbZCLau0/G8SXRNfnrgj9MyydWemEktxRqKhFnNR
	cSIA7P1cvaYCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Setup the INT clock ops to control/vary INT frequency
- Add PPMU support for Exynos5250
- Add mappings initially for the PPMU device

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
Changes since RFC v1:
* Fixed the unnecessary clock manipulations being done
* Moved the PPMU driver from drivers/devfreq to machine specific directory

 arch/arm/mach-exynos/Kconfig                     |   8 +
 arch/arm/mach-exynos/Makefile                    |   4 +
 arch/arm/mach-exynos/clock-exynos5.c             | 143 ++++++++
 arch/arm/mach-exynos/common.c                    |  25 ++
 arch/arm/mach-exynos/exynos5_ppmu.c              | 396 +++++++++++++++++++++++
 arch/arm/mach-exynos/exynos_ppmu.c               |  56 ++++
 arch/arm/mach-exynos/include/mach/exynos5_ppmu.h |  26 ++
 arch/arm/mach-exynos/include/mach/exynos_ppmu.h  |  79 +++++
 arch/arm/mach-exynos/include/mach/map.h          |   6 +
 arch/arm/mach-exynos/include/mach/regs-clock.h   |  37 +++
 arch/arm/plat-samsung/include/plat/map-s5p.h     |   6 +
 11 files changed, 786 insertions(+)
 create mode 100644 arch/arm/mach-exynos/exynos5_ppmu.c
 create mode 100644 arch/arm/mach-exynos/exynos_ppmu.c
 create mode 100644 arch/arm/mach-exynos/include/mach/exynos5_ppmu.h
 create mode 100644 arch/arm/mach-exynos/include/mach/exynos_ppmu.h

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 91d5b6f..38bde0e 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -179,6 +179,14 @@ config EXYNOS_SETUP_SPI
 	help
 	  Common setup code for SPI GPIO configurations.
 
+config EXYNOS5250_PPMU
+	bool "Exynos5250 PPMU Driver"
+        depends on SOC_EXYNOS5250
+        help
+          This adds the Performance Profiling Monitoring Unit (PPMU) support
+	  for Exynos5250. This code is used by the devfreq driver to read the
+	  PPMU counters and vary the INT bus frequency/voltage.
+
 # machine support
 
 if ARCH_EXYNOS4
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 7e53a3a..b0b4cc9 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -74,3 +74,7 @@ obj-$(CONFIG_EXYNOS4_SETUP_KEYPAD)	+= setup-keypad.o
 obj-$(CONFIG_EXYNOS4_SETUP_SDHCI_GPIO)	+= setup-sdhci-gpio.o
 obj-$(CONFIG_EXYNOS4_SETUP_USB_PHY)	+= setup-usb-phy.o
 obj-$(CONFIG_EXYNOS_SETUP_SPI)		+= setup-spi.o
+
+# ppmu support
+
+obj-$(CONFIG_EXYNOS5250_PPMU)		+= exynos_ppmu.o exynos5_ppmu.o
diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 0208c3a..050879c 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -108,6 +108,11 @@ static struct clk exynos5_clk_sclk_usbphy = {
 	.rate		= 48000000,
 };
 
+/* Virtual Bus INT clock */
+static struct clk exynos5_int_clk = {
+	.name		= "int_clk",
+};
+
 static int exynos5_clksrc_mask_top_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(EXYNOS5_CLKSRC_MASK_TOP, clk, enable);
@@ -1426,6 +1431,141 @@ static struct clk *exynos5_clks[] __initdata = {
 	&clk_fout_cpll,
 	&clk_fout_mpll_div2,
 	&exynos5_clk_armclk,
+	&exynos5_int_clk,
+};
+
+#define INT_FREQ(f, a0, a1, a2, a3, a4, a5, b0, b1, b2, b3, \
+			c0, c1, d0, e0) \
+	{ \
+		.freq = (f) * 1000000, \
+		.clk_div_top0 = ((a0) << 0 | (a1) << 8 | (a2) << 12 | \
+				(a3) << 16 | (a4) << 20 | (a5) << 28), \
+		.clk_div_top1 = ((b0) << 12 | (b1) << 16 | (b2) << 20 | \
+				(b3) << 24), \
+		.clk_div_lex = ((c0) << 4 | (c1) << 8), \
+		.clk_div_r0x = ((d0) << 4), \
+		.clk_div_r1x = ((e0) << 4), \
+	}
+
+static struct {
+	unsigned long freq;
+	u32 clk_div_top0;
+	u32 clk_div_top1;
+	u32 clk_div_lex;
+	u32 clk_div_r0x;
+	u32 clk_div_r1x;
+} int_freq[] = {
+	/*
+	 * values:
+	 * freq
+	 * clock divider for ACLK66, ACLK166, ACLK200, ACLK266,
+			ACLK333, ACLK300_DISP1
+	 * clock divider for ACLK300_GSCL, ACLK400_IOP, ACLK400_ISP, ACLK66_PRE
+	 * clock divider for PCLK_LEX, ATCLK_LEX
+	 * clock divider for ACLK_PR0X
+	 * clock divider for ACLK_PR1X
+	 */
+	INT_FREQ(266, 1, 1, 3, 2, 0, 0, 0, 1, 1, 5, 1, 0, 1, 1),
+	INT_FREQ(200, 1, 2, 4, 3, 1, 0, 0, 3, 2, 5, 1, 0, 1, 1),
+	INT_FREQ(160, 1, 3, 4, 4, 2, 0, 0, 3, 3, 5, 1, 0, 1, 1),
+	INT_FREQ(133, 1, 3, 5, 5, 2, 1, 1, 4, 4, 5, 1, 0, 1, 1),
+	INT_FREQ(100, 1, 7, 7, 7, 7, 3, 7, 7, 7, 5, 1, 0, 1, 1),
+};
+
+static unsigned long exynos5_clk_int_get_rate(struct clk *clk)
+{
+	return clk->rate;
+}
+
+static void exynos5_int_set_clkdiv(unsigned int div_index)
+{
+	unsigned int tmp;
+
+	/* Change Divider - TOP0 */
+	tmp = __raw_readl(EXYNOS5_CLKDIV_TOP0);
+
+	tmp &= ~(EXYNOS5_CLKDIV_TOP0_ACLK266_MASK |
+		EXYNOS5_CLKDIV_TOP0_ACLK200_MASK |
+		EXYNOS5_CLKDIV_TOP0_ACLK66_MASK |
+		EXYNOS5_CLKDIV_TOP0_ACLK333_MASK |
+		EXYNOS5_CLKDIV_TOP0_ACLK166_MASK |
+		EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_MASK);
+
+	tmp |= int_freq[div_index].clk_div_top0;
+
+	__raw_writel(tmp, EXYNOS5_CLKDIV_TOP0);
+
+	/* Wait for TOP0 divider to stabilize */
+	while (__raw_readl(EXYNOS5_CLKDIV_STAT_TOP0) & 0x151101)
+		cpu_relax();
+
+	/* Change Divider - TOP1 */
+	tmp = __raw_readl(EXYNOS5_CLKDIV_TOP1);
+
+	tmp &= ~(EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_MASK |
+		EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_MASK |
+		EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_MASK |
+		EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_MASK);
+
+	tmp |= int_freq[div_index].clk_div_top1;
+
+	__raw_writel(tmp, EXYNOS5_CLKDIV_TOP1);
+
+	/* Wait for TOP0 and TOP1 dividers to stabilize */
+	while ((__raw_readl(EXYNOS5_CLKDIV_STAT_TOP1) & 0x1110000) &&
+		(__raw_readl(EXYNOS5_CLKDIV_STAT_TOP0) & 0x80000))
+		cpu_relax();
+
+	/* Change Divider - LEX */
+	tmp = int_freq[div_index].clk_div_lex;
+
+	__raw_writel(tmp, EXYNOS5_CLKDIV_LEX);
+
+	/* Wait for LEX divider to stabilize */
+	while (__raw_readl(EXYNOS5_CLKDIV_STAT_LEX) & 0x110)
+		cpu_relax();
+
+	/* Change Divider - R0X */
+	tmp = int_freq[div_index].clk_div_r0x;
+
+	__raw_writel(tmp, EXYNOS5_CLKDIV_R0X);
+
+	/* Wait for R0X divider to stabilize */
+	while (__raw_readl(EXYNOS5_CLKDIV_STAT_R0X) & 0x10)
+		cpu_relax();
+
+	/* Change Divider - R1X */
+	tmp = int_freq[div_index].clk_div_r1x;
+
+	__raw_writel(tmp, EXYNOS5_CLKDIV_R1X);
+
+	/* Wait for R1X divider to stabilize */
+	while (__raw_readl(EXYNOS5_CLKDIV_STAT_R1X) & 0x10)
+		cpu_relax();
+}
+
+static int exynos5_clk_int_set_rate(struct clk *clk, unsigned long rate)
+{
+	int index;
+
+	for (index = 0; index < ARRAY_SIZE(int_freq); index++)
+		if (int_freq[index].freq == rate)
+			break;
+
+	if (index == ARRAY_SIZE(int_freq))
+		return -EINVAL;
+
+	/* Change the system clock divider values */
+	exynos5_int_set_clkdiv(index);
+
+	clk->rate = rate;
+
+	return 0;
+}
+
+static struct clk_ops exynos5_clk_int_ops = {
+	.get_rate = exynos5_clk_int_get_rate,
+	.set_rate = exynos5_clk_int_set_rate
 };
 
 static u32 epll_div[][6] = {
@@ -1620,6 +1760,9 @@ void __init_or_cpufreq exynos5_setup_clocks(void)
 
 	clk_fout_epll.ops = &exynos5_epll_ops;
 
+	exynos5_int_clk.ops = &exynos5_clk_int_ops;
+	exynos5_int_clk.rate = aclk_266;
+
 	if (clk_set_parent(&exynos5_clk_mout_epll.clk, &clk_fout_epll))
 		printk(KERN_ERR "Unable to set parent %s of clock %s.\n",
 				clk_fout_epll.name, exynos5_clk_mout_epll.clk.name);
diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 578a610..a285080 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -308,6 +308,31 @@ static struct map_desc exynos5_iodesc[] __initdata = {
 		.pfn		= __phys_to_pfn(EXYNOS5_PA_UART),
 		.length		= SZ_512K,
 		.type		= MT_DEVICE,
+	}, {
+		.virtual        = (unsigned long)S5P_VA_PPMU_CPU,
+		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_CPU),
+		.length         = SZ_8K,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual        = (unsigned long)S5P_VA_PPMU_DDR_C,
+		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_C),
+		.length         = SZ_8K,
+		.type           = MT_DEVICE,
+	}, {
+		.virtual        = (unsigned long)S5P_VA_PPMU_DDR_R1,
+		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_R1),
+		.length         = SZ_8K,
+		.type           = MT_DEVICE,
+	}, {
+		.virtual        = (unsigned long)S5P_VA_PPMU_DDR_L,
+		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_DDR_L),
+		.length         = SZ_8K,
+		.type           = MT_DEVICE,
+	}, {
+		.virtual        = (unsigned long)S5P_VA_PPMU_RIGHT,
+		.pfn            = __phys_to_pfn(EXYNOS5_PA_PPMU_RIGHT),
+		.length         = SZ_8K,
+		.type           = MT_DEVICE,
 	},
 };
 
diff --git a/arch/arm/mach-exynos/exynos5_ppmu.c b/arch/arm/mach-exynos/exynos5_ppmu.c
new file mode 100644
index 0000000..3fecef4
--- /dev/null
+++ b/arch/arm/mach-exynos/exynos5_ppmu.c
@@ -0,0 +1,396 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS5 PPMU support
+ * Support for only EXYNOS5250 is present.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/hrtimer.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include <mach/map.h>
+
+#include <mach/exynos_ppmu.h>
+#include <mach/exynos5_ppmu.h>
+
+#define FIXED_POINT_OFFSET 8
+#define FIXED_POINT_MASK ((1 << FIXED_POINT_OFFSET) - 1)
+
+enum exynos5_ppmu_list {
+	PPMU_DDR_C,
+	PPMU_DDR_R1,
+	PPMU_DDR_L,
+	PPMU_RIGHT,
+	PPMU_CPU,
+	PPMU_END,
+};
+
+struct exynos5_ppmu_handle {
+	struct list_head node;
+	struct exynos_ppmu ppmu[PPMU_END];
+};
+
+static DEFINE_SPINLOCK(exynos5_ppmu_lock);
+static LIST_HEAD(exynos5_ppmu_handle_list);
+static struct exynos5_ppmu_handle *exynos5_ppmu_trace_handle;
+
+static const char *exynos5_ppmu_name[PPMU_END] = {
+	[PPMU_DDR_C]	= "DDR_C",
+	[PPMU_DDR_R1]	= "DDR_R1",
+	[PPMU_DDR_L]	= "DDR_L",
+	[PPMU_RIGHT]	= "RIGHT",
+	[PPMU_CPU]	= "CPU",
+};
+
+static struct exynos_ppmu ppmu[PPMU_END] = {
+	[PPMU_DDR_C] = {
+		.hw_base = S5P_VA_PPMU_DDR_C,
+	},
+	[PPMU_DDR_R1] = {
+		.hw_base = S5P_VA_PPMU_DDR_R1,
+	},
+	[PPMU_DDR_L] = {
+		.hw_base = S5P_VA_PPMU_DDR_L,
+	},
+	[PPMU_RIGHT] = {
+		.hw_base = S5P_VA_PPMU_RIGHT,
+	},
+	[PPMU_CPU] = {
+		.hw_base = S5P_VA_PPMU_CPU,
+	},
+};
+
+static void exynos5_ppmu_reset(struct exynos_ppmu *ppmu)
+{
+	unsigned long flags;
+
+	void __iomem *ppmu_base = ppmu->hw_base;
+
+	/* Reset PPMU */
+	exynos_ppmu_reset(ppmu_base);
+
+	/* Set PPMU Event */
+	ppmu->event[PPMU_PMNCNT0] = RD_DATA_COUNT;
+	exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT0,
+			ppmu->event[PPMU_PMNCNT0]);
+	ppmu->event[PPMU_PMCCNT1] = WR_DATA_COUNT;
+	exynos_ppmu_setevent(ppmu_base, PPMU_PMCCNT1,
+			ppmu->event[PPMU_PMCCNT1]);
+	ppmu->event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
+	exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
+			ppmu->event[PPMU_PMNCNT3]);
+
+	local_irq_save(flags);
+	ppmu->reset_time = ktime_get();
+	/* Start PPMU */
+	exynos_ppmu_start(ppmu_base);
+	local_irq_restore(flags);
+}
+
+static void exynos5_ppmu_read(struct exynos_ppmu *ppmu)
+{
+	int j;
+	unsigned long flags;
+	ktime_t read_time;
+	ktime_t t;
+	u32 reg;
+
+	void __iomem *ppmu_base = ppmu->hw_base;
+
+	local_irq_save(flags);
+	read_time = ktime_get();
+	/* Stop PPMU */
+	exynos_ppmu_stop(ppmu_base);
+	local_irq_restore(flags);
+
+	/* Update local data from PPMU */
+	ppmu->ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
+	reg = __raw_readl(ppmu_base + PPMU_FLAG);
+	ppmu->ccnt_overflow = reg & PPMU_CCNT_OVERFLOW;
+
+	for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
+		if (ppmu->event[j] == 0)
+			ppmu->count[j] = 0;
+		else
+			ppmu->count[j] = exynos_ppmu_read(ppmu_base, j);
+	}
+	t = ktime_sub(read_time, ppmu->reset_time);
+	ppmu->ns = ktime_to_ns(t);
+}
+
+static void exynos5_ppmu_add(struct exynos_ppmu *to, struct exynos_ppmu *from)
+{
+	int i;
+	int j;
+
+	for (i = 0; i < PPMU_END; i++) {
+		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++)
+			to[i].count[j] += from[i].count[j];
+
+		to[i].ccnt += from[i].ccnt;
+		if (to[i].ccnt < from[i].ccnt)
+			to[i].ccnt_overflow = true;
+
+		to[i].ns += from[i].ns;
+
+		if (from[i].ccnt_overflow)
+			to[i].ccnt_overflow = true;
+	}
+}
+
+static void exynos5_ppmu_handle_clear(struct exynos5_ppmu_handle *handle)
+{
+	memset(&handle->ppmu, 0, sizeof(struct exynos_ppmu) * PPMU_END);
+}
+
+static void exynos5_ppmu_update(void)
+{
+	int i;
+	struct exynos5_ppmu_handle *handle;
+
+	for (i = 0; i < PPMU_END; i++) {
+		exynos5_ppmu_read(&ppmu[i]);
+		exynos5_ppmu_reset(&ppmu[i]);
+	}
+
+	list_for_each_entry(handle, &exynos5_ppmu_handle_list, node)
+		exynos5_ppmu_add(handle->ppmu, ppmu);
+}
+
+static int exynos5_ppmu_get_filter(enum exynos5_ppmu_sets filter,
+	enum exynos5_ppmu_list *start, enum exynos5_ppmu_list *end)
+{
+	switch (filter) {
+	case PPMU_SET_DDR:
+		*start = PPMU_DDR_C;
+		*end = PPMU_DDR_L;
+		break;
+	case PPMU_SET_RIGHT:
+		*start = PPMU_RIGHT;
+		*end = PPMU_RIGHT;
+		break;
+	case PPMU_SET_CPU:
+		*start = PPMU_CPU;
+		*end = PPMU_CPU;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int exynos5_ppmu_get_busy(struct exynos5_ppmu_handle *handle,
+	enum exynos5_ppmu_sets filter)
+{
+	unsigned long flags;
+	int i;
+	int busy = 0;
+	int temp;
+	enum exynos5_ppmu_list start;
+	enum exynos5_ppmu_list end;
+	int ret;
+
+	ret = exynos5_ppmu_get_filter(filter, &start, &end);
+	if (ret < 0)
+		return ret;
+
+	spin_lock_irqsave(&exynos5_ppmu_lock, flags);
+
+	exynos5_ppmu_update();
+
+	for (i = start; i <= end; i++) {
+		if (handle->ppmu[i].ccnt_overflow) {
+			busy = -EOVERFLOW;
+			break;
+		}
+		temp = handle->ppmu[i].count[PPMU_PMNCNT3] * 100;
+		if (handle->ppmu[i].ccnt > 0)
+			temp /= handle->ppmu[i].ccnt;
+		if (temp > busy)
+			busy = temp;
+	}
+
+	exynos5_ppmu_handle_clear(handle);
+
+	spin_unlock_irqrestore(&exynos5_ppmu_lock, flags);
+
+	return busy;
+}
+
+static void exynos5_ppmu_put(struct exynos5_ppmu_handle *handle)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&exynos5_ppmu_lock, flags);
+
+	list_del(&handle->node);
+
+	spin_unlock_irqrestore(&exynos5_ppmu_lock, flags);
+
+	kfree(handle);
+}
+
+struct exynos5_ppmu_handle *exynos5_ppmu_get(void)
+{
+	struct exynos5_ppmu_handle *handle;
+	unsigned long flags;
+
+	handle = kzalloc(sizeof(struct exynos5_ppmu_handle), GFP_KERNEL);
+	if (!handle)
+		return NULL;
+
+	spin_lock_irqsave(&exynos5_ppmu_lock, flags);
+
+	exynos5_ppmu_update();
+	list_add_tail(&handle->node, &exynos5_ppmu_handle_list);
+
+	spin_unlock_irqrestore(&exynos5_ppmu_lock, flags);
+
+	return handle;
+}
+
+static int exynos5_ppmu_trace_init(void)
+{
+	exynos5_ppmu_trace_handle = exynos5_ppmu_get();
+	return 0;
+}
+late_initcall(exynos5_ppmu_trace_init);
+
+static void exynos5_ppmu_debug_compute(struct exynos_ppmu *ppmu,
+	enum ppmu_counter i, u32 *sat, u32 *freq, u32 *bw)
+{
+	u64 ns = ppmu->ns;
+	u32 busy = ppmu->count[i];
+	u32 total = ppmu->ccnt;
+
+	u64 s;
+	u64 f;
+	u64 b;
+
+	s = (u64)busy * 100 * (1 << FIXED_POINT_OFFSET);
+	s += total / 2;
+	do_div(s, total);
+
+	f = (u64)total * 1000 * (1 << FIXED_POINT_OFFSET);
+	f += ns / 2;
+	f = div64_u64(f, ns);
+
+	b = (u64)busy * (128 / 8) * 1000 * (1 << FIXED_POINT_OFFSET);
+	b += ns / 2;
+	b = div64_u64(b, ns);
+
+	*sat = s;
+	*freq = f;
+	*bw = b;
+}
+
+static void exynos5_ppmu_debug_show_one_counter(struct seq_file *s,
+	const char *name, const char *type, struct exynos_ppmu *ppmu,
+	enum ppmu_counter i, u32 *bw_total)
+{
+	u32 sat;
+	u32 freq;
+	u32 bw;
+
+	exynos5_ppmu_debug_compute(ppmu, i, &sat, &freq, &bw);
+
+	seq_printf(s, "%-10s %-10s %4u.%02u MBps %3u.%02u MHz %2u.%02u%%\n",
+		name, type,
+		bw >> FIXED_POINT_OFFSET,
+		(bw & FIXED_POINT_MASK) * 100 / (1 << FIXED_POINT_OFFSET),
+		freq >> FIXED_POINT_OFFSET,
+		(freq & FIXED_POINT_MASK) * 100 / (1 << FIXED_POINT_OFFSET),
+		sat >> FIXED_POINT_OFFSET,
+		(sat & FIXED_POINT_MASK) * 100 / (1 << FIXED_POINT_OFFSET));
+
+	*bw_total += bw;
+}
+
+static void exynos5_ppmu_debug_show_one(struct seq_file *s,
+	const char *name, struct exynos_ppmu *ppmu,
+	u32 *bw_total)
+{
+	exynos5_ppmu_debug_show_one_counter(s, name, "read+write",
+		ppmu, PPMU_PMNCNT3, &bw_total[PPMU_PMNCNT3]);
+	exynos5_ppmu_debug_show_one_counter(s, "", "read",
+		ppmu, PPMU_PMNCNT0, &bw_total[PPMU_PMNCNT0]);
+	exynos5_ppmu_debug_show_one_counter(s, "", "write",
+		ppmu, PPMU_PMCCNT1, &bw_total[PPMU_PMCCNT1]);
+
+}
+
+static int exynos5_ppmu_debug_show(struct seq_file *s, void *d)
+{
+	int i;
+	u32 bw_total[PPMU_PMNCNT_MAX];
+	struct exynos5_ppmu_handle *handle;
+	unsigned long flags;
+
+	memset(bw_total, 0, sizeof(bw_total));
+
+	handle = exynos5_ppmu_get();
+	msleep(100);
+
+	spin_lock_irqsave(&exynos5_ppmu_lock, flags);
+
+	exynos5_ppmu_update();
+
+	for (i = 0; i < PPMU_CPU; i++)
+		exynos5_ppmu_debug_show_one(s, exynos5_ppmu_name[i],
+				&handle->ppmu[i], bw_total);
+
+	seq_printf(s, "%-10s %-10s %4u.%02u MBps\n", "total", "read+write",
+		bw_total[PPMU_PMNCNT3] >> FIXED_POINT_OFFSET,
+		(bw_total[PPMU_PMNCNT3] & FIXED_POINT_MASK) *
+				100 / (1 << FIXED_POINT_OFFSET));
+	seq_printf(s, "%-10s %-10s %4u.%02u MBps\n", "", "read",
+		bw_total[PPMU_PMNCNT0] >> FIXED_POINT_OFFSET,
+		(bw_total[PPMU_PMNCNT0] & FIXED_POINT_MASK) *
+				100 / (1 << FIXED_POINT_OFFSET));
+	seq_printf(s, "%-10s %-10s %4u.%02u MBps\n", "", "write",
+		bw_total[PPMU_PMCCNT1] >> FIXED_POINT_OFFSET,
+		(bw_total[PPMU_PMCCNT1] & FIXED_POINT_MASK) *
+				100 / (1 << FIXED_POINT_OFFSET));
+
+	seq_printf(s, "\n");
+
+	exynos5_ppmu_debug_show_one(s, exynos5_ppmu_name[PPMU_CPU],
+			&ppmu[PPMU_CPU], bw_total);
+
+	spin_unlock_irqrestore(&exynos5_ppmu_lock, flags);
+
+	exynos5_ppmu_put(handle);
+
+	return 0;
+}
+
+static int exynos5_ppmu_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, exynos5_ppmu_debug_show, inode->i_private);
+}
+
+static const struct file_operations exynos5_ppmu_debug_fops = {
+	.open		= exynos5_ppmu_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init exynos5_ppmu_debug_init(void)
+{
+	debugfs_create_file("exynos5_bus", S_IRUGO, NULL, NULL,
+		&exynos5_ppmu_debug_fops);
+	return 0;
+}
+late_initcall(exynos5_ppmu_debug_init);
diff --git a/arch/arm/mach-exynos/exynos_ppmu.c b/arch/arm/mach-exynos/exynos_ppmu.c
new file mode 100644
index 0000000..f627813
--- /dev/null
+++ b/arch/arm/mach-exynos/exynos_ppmu.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS - PPMU support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/io.h>
+
+#include <mach/exynos_ppmu.h>
+
+void exynos_ppmu_reset(void __iomem *ppmu_base)
+{
+	__raw_writel(PPMU_CYCLE_RESET | PPMU_COUNTER_RESET, ppmu_base);
+	__raw_writel(PPMU_ENABLE_CYCLE  |
+		     PPMU_ENABLE_COUNT0 |
+		     PPMU_ENABLE_COUNT1 |
+		     PPMU_ENABLE_COUNT2 |
+		     PPMU_ENABLE_COUNT3,
+		     ppmu_base + PPMU_CNTENS);
+}
+
+void exynos_ppmu_setevent(void __iomem *ppmu_base, unsigned int ch,
+			unsigned int evt)
+{
+	__raw_writel(evt, ppmu_base + PPMU_BEVTSEL(ch));
+}
+
+void exynos_ppmu_start(void __iomem *ppmu_base)
+{
+	__raw_writel(PPMU_ENABLE, ppmu_base);
+}
+
+void exynos_ppmu_stop(void __iomem *ppmu_base)
+{
+	__raw_writel(PPMU_DISABLE, ppmu_base);
+}
+
+unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch)
+{
+	unsigned int total;
+
+	if (ch == PPMU_PMNCNT3)
+		total = ((__raw_readl(ppmu_base + PMCNT_OFFSET(ch)) << 8) |
+			  __raw_readl(ppmu_base + PMCNT_OFFSET(ch + 1)));
+	else
+		total = __raw_readl(ppmu_base + PMCNT_OFFSET(ch));
+
+	return total;
+}
diff --git a/arch/arm/mach-exynos/include/mach/exynos5_ppmu.h b/arch/arm/mach-exynos/include/mach/exynos5_ppmu.h
new file mode 100644
index 0000000..9f492c1
--- /dev/null
+++ b/arch/arm/mach-exynos/include/mach/exynos5_ppmu.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS5 PPMU header
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __DEVFREQ_EXYNOS5_PPMU_H
+#define __DEVFREQ_EXYNOS5_PPMU_H __FILE__
+
+enum exynos5_ppmu_sets {
+	PPMU_SET_DDR,
+	PPMU_SET_RIGHT,
+	PPMU_SET_CPU,
+};
+
+struct exynos5_ppmu_handle *exynos5_ppmu_get(void);
+extern int exynos5_ppmu_get_busy(struct exynos5_ppmu_handle *handle,
+	enum exynos5_ppmu_sets filter);
+
+#endif /* __DEVFREQ_EXYNOS5_PPMU_H */
+
diff --git a/arch/arm/mach-exynos/include/mach/exynos_ppmu.h b/arch/arm/mach-exynos/include/mach/exynos_ppmu.h
new file mode 100644
index 0000000..b46d31b
--- /dev/null
+++ b/arch/arm/mach-exynos/include/mach/exynos_ppmu.h
@@ -0,0 +1,79 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS PPMU header
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __DEVFREQ_EXYNOS_PPMU_H
+#define __DEVFREQ_EXYNOS_PPMU_H __FILE__
+
+#include <linux/ktime.h>
+
+/* For PPMU Control */
+#define PPMU_ENABLE             BIT(0)
+#define PPMU_DISABLE            0x0
+#define PPMU_CYCLE_RESET        BIT(1)
+#define PPMU_COUNTER_RESET      BIT(2)
+
+#define PPMU_ENABLE_COUNT0      BIT(0)
+#define PPMU_ENABLE_COUNT1      BIT(1)
+#define PPMU_ENABLE_COUNT2      BIT(2)
+#define PPMU_ENABLE_COUNT3      BIT(3)
+#define PPMU_ENABLE_CYCLE       BIT(31)
+
+#define PPMU_CNTENS		0x10
+#define PPMU_FLAG		0x50
+#define PPMU_CCNT_OVERFLOW	BIT(31)
+#define PPMU_CCNT		0x100
+
+#define PPMU_PMCNT0		0x110
+#define PPMU_PMCNT_OFFSET	0x10
+#define PMCNT_OFFSET(x)		(PPMU_PMCNT0 + (PPMU_PMCNT_OFFSET * x))
+
+#define PPMU_BEVT0SEL		0x1000
+#define PPMU_BEVTSEL_OFFSET	0x100
+#define PPMU_BEVTSEL(x)		(PPMU_BEVT0SEL + (ch * PPMU_BEVTSEL_OFFSET))
+
+/* For Event Selection */
+#define RD_DATA_COUNT		0x5
+#define WR_DATA_COUNT		0x6
+#define RDWR_DATA_COUNT		0x7
+
+enum ppmu_counter {
+	PPMU_PMNCNT0,
+	PPMU_PMCCNT1,
+	PPMU_PMNCNT2,
+	PPMU_PMNCNT3,
+	PPMU_PMNCNT_MAX,
+};
+
+struct bus_opp_table {
+	unsigned int idx;
+	unsigned long clk;
+	unsigned long volt;
+};
+
+struct exynos_ppmu {
+	void __iomem *hw_base;
+	unsigned int ccnt;
+	unsigned int event[PPMU_PMNCNT_MAX];
+	unsigned int count[PPMU_PMNCNT_MAX];
+	unsigned long long ns;
+	ktime_t reset_time;
+	bool ccnt_overflow;
+	bool count_overflow[PPMU_PMNCNT_MAX];
+};
+
+void exynos_ppmu_reset(void __iomem *ppmu_base);
+void exynos_ppmu_setevent(void __iomem *ppmu_base, unsigned int ch,
+			unsigned int evt);
+void exynos_ppmu_start(void __iomem *ppmu_base);
+void exynos_ppmu_stop(void __iomem *ppmu_base);
+unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch);
+#endif /* __DEVFREQ_EXYNOS_PPMU_H */
+
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index b8ea67e..9af6e06 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -229,6 +229,12 @@
 #define EXYNOS4_PA_SDRAM		0x40000000
 #define EXYNOS5_PA_SDRAM		0x40000000
 
+#define EXYNOS5_PA_PPMU_DDR_C		0x10C40000
+#define EXYNOS5_PA_PPMU_DDR_R1		0x10C50000
+#define EXYNOS5_PA_PPMU_CPU		0x10C60000
+#define EXYNOS5_PA_PPMU_DDR_L		0x10CB0000
+#define EXYNOS5_PA_PPMU_RIGHT		0x13660000
+
 /* Compatibiltiy Defines */
 
 #define S3C_PA_HSMMC0			EXYNOS4_PA_HSMMC(0)
diff --git a/arch/arm/mach-exynos/include/mach/regs-clock.h b/arch/arm/mach-exynos/include/mach/regs-clock.h
index d36ad76..3d3cbc8 100644
--- a/arch/arm/mach-exynos/include/mach/regs-clock.h
+++ b/arch/arm/mach-exynos/include/mach/regs-clock.h
@@ -323,6 +323,9 @@
 #define EXYNOS5_CLKDIV_PERIC5			EXYNOS_CLKREG(0x1056C)
 #define EXYNOS5_SCLK_DIV_ISP			EXYNOS_CLKREG(0x10580)
 
+#define EXYNOS5_CLKDIV_STAT_TOP0		EXYNOS_CLKREG(0x10610)
+#define EXYNOS5_CLKDIV_STAT_TOP1		EXYNOS_CLKREG(0x10614)
+
 #define EXYNOS5_CLKGATE_IP_ACP			EXYNOS_CLKREG(0x08800)
 #define EXYNOS5_CLKGATE_IP_ISP0			EXYNOS_CLKREG(0x0C800)
 #define EXYNOS5_CLKGATE_IP_ISP1			EXYNOS_CLKREG(0x0C804)
@@ -337,6 +340,18 @@
 #define EXYNOS5_CLKGATE_IP_PERIS		EXYNOS_CLKREG(0x10960)
 #define EXYNOS5_CLKGATE_BLOCK			EXYNOS_CLKREG(0x10980)
 
+#define EXYNOS5_CLKGATE_BUS_SYSLFT		EXYNOS_CLKREG(0x08920)
+
+#define EXYNOS5_CLKOUT_CMU_TOP			EXYNOS_CLKREG(0x10A00)
+
+#define EXYNOS5_CLKDIV_LEX			EXYNOS_CLKREG(0x14500)
+#define EXYNOS5_CLKDIV_STAT_LEX			EXYNOS_CLKREG(0x14600)
+
+#define EXYNOS5_CLKDIV_R0X			EXYNOS_CLKREG(0x18500)
+#define EXYNOS5_CLKDIV_STAT_R0X			EXYNOS_CLKREG(0x18600)
+
+#define EXYNOS5_CLKDIV_R1X			EXYNOS_CLKREG(0x1C500)
+#define EXYNOS5_CLKDIV_STAT_R1X			EXYNOS_CLKREG(0x1C600)
 #define EXYNOS5_BPLL_CON0			EXYNOS_CLKREG(0x20110)
 #define EXYNOS5_CLKSRC_CDREX			EXYNOS_CLKREG(0x20200)
 #define EXYNOS5_CLKDIV_CDREX			EXYNOS_CLKREG(0x20500)
@@ -347,6 +362,28 @@
 
 #define EXYNOS5_EPLLCON0_LOCKED_SHIFT		(29)
 
+#define EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_SHIFT	(28)
+#define EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_MASK	(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK300_DISP1_SHIFT)
+#define EXYNOS5_CLKDIV_TOP0_ACLK333_SHIFT	(20)
+#define EXYNOS5_CLKDIV_TOP0_ACLK333_MASK	(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK333_SHIFT)
+#define EXYNOS5_CLKDIV_TOP0_ACLK266_SHIFT	(16)
+#define EXYNOS5_CLKDIV_TOP0_ACLK266_MASK	(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK266_SHIFT)
+#define EXYNOS5_CLKDIV_TOP0_ACLK200_SHIFT	(12)
+#define EXYNOS5_CLKDIV_TOP0_ACLK200_MASK	(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK200_SHIFT)
+#define EXYNOS5_CLKDIV_TOP0_ACLK166_SHIFT	(8)
+#define EXYNOS5_CLKDIV_TOP0_ACLK166_MASK	(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK166_SHIFT)
+#define EXYNOS5_CLKDIV_TOP0_ACLK66_SHIFT	(0)
+#define EXYNOS5_CLKDIV_TOP0_ACLK66_MASK		(0x7 << EXYNOS5_CLKDIV_TOP0_ACLK66_SHIFT)
+
+#define EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_SHIFT	(24)
+#define EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_MASK	(0x7 << EXYNOS5_CLKDIV_TOP1_ACLK66_PRE_SHIFT)
+#define EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_SHIFT	(20)
+#define EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_MASK	(0x7 << EXYNOS5_CLKDIV_TOP1_ACLK400_ISP_SHIFT)
+#define EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_SHIFT	(16)
+#define EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_MASK	(0x7 << EXYNOS5_CLKDIV_TOP1_ACLK400_IOP_SHIFT)
+#define EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_SHIFT	(12)
+#define EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_MASK	(0x7 << EXYNOS5_CLKDIV_TOP1_ACLK300_GSCL_SHIFT)
+
 #define PWR_CTRL1_CORE2_DOWN_RATIO		(7 << 28)
 #define PWR_CTRL1_CORE1_DOWN_RATIO		(7 << 16)
 #define PWR_CTRL1_DIV2_DOWN_EN			(1 << 9)
diff --git a/arch/arm/plat-samsung/include/plat/map-s5p.h b/arch/arm/plat-samsung/include/plat/map-s5p.h
index c186786..9399f2d 100644
--- a/arch/arm/plat-samsung/include/plat/map-s5p.h
+++ b/arch/arm/plat-samsung/include/plat/map-s5p.h
@@ -41,6 +41,12 @@
 #define S5P_VA_GIC_CPU		S3C_ADDR(0x02810000)
 #define S5P_VA_GIC_DIST		S3C_ADDR(0x02820000)
 
+#define S5P_VA_PPMU_CPU		S3C_ADDR(0x02830000)
+#define S5P_VA_PPMU_DDR_C	S3C_ADDR(0x02832000)
+#define S5P_VA_PPMU_DDR_R1	S3C_ADDR(0x02834000)
+#define S5P_VA_PPMU_DDR_L	S3C_ADDR(0x02836000)
+#define S5P_VA_PPMU_RIGHT	S3C_ADDR(0x02838000)
+
 #define VA_VIC(x)		(S3C_VA_IRQ + ((x) * 0x10000))
 #define VA_VIC0			VA_VIC(0)
 #define VA_VIC1			VA_VIC(1)
-- 
1.8.1-rc3

