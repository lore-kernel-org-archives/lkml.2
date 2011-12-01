Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1LAA3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:29:12 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42380 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1LAA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:29:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6546"; a="142458295"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] ARM: msm: Remove MSM7x00 support
Date: Wed, 30 Nov 2011 16:29:02 -0800
Message-Id: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This target has been bitrotting for a while.  The hardware is quite a
bit different from the other MSM targets, making it hard to justify
maintaining the support in the kernel.  This SoC was dropped from
Google's Android kernel a while back.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig                       |   29 +--
 arch/arm/mach-msm/Makefile                      |    4 -
 arch/arm/mach-msm/acpuclock-arm11.c             |  525 -----------------------
 arch/arm/mach-msm/acpuclock.h                   |   32 --
 arch/arm/mach-msm/board-halibut.c               |  102 -----
 arch/arm/mach-msm/board-trout-gpio.c            |  233 ----------
 arch/arm/mach-msm/board-trout-mmc.c             |  185 --------
 arch/arm/mach-msm/board-trout-panel.c           |  296 -------------
 arch/arm/mach-msm/board-trout.c                 |  102 -----
 arch/arm/mach-msm/board-trout.h                 |  162 -------
 arch/arm/mach-msm/idle.S                        |   13 -
 arch/arm/mach-msm/include/mach/irqs-7x00.h      |   75 ----
 arch/arm/mach-msm/include/mach/irqs.h           |    2 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |  127 ------
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    2 -
 arch/arm/mach-msm/io.c                          |   34 --
 arch/arm/mach-msm/irq.c                         |  151 -------
 arch/arm/mach-msm/smd_private.h                 |   39 --
 arch/arm/mach-msm/timer.c                       |    5 +-
 19 files changed, 2 insertions(+), 2116 deletions(-)
 delete mode 100644 arch/arm/mach-msm/acpuclock-arm11.c
 delete mode 100644 arch/arm/mach-msm/acpuclock.h
 delete mode 100644 arch/arm/mach-msm/board-halibut.c
 delete mode 100644 arch/arm/mach-msm/board-trout-gpio.c
 delete mode 100644 arch/arm/mach-msm/board-trout-mmc.c
 delete mode 100644 arch/arm/mach-msm/board-trout-panel.c
 delete mode 100644 arch/arm/mach-msm/board-trout.c
 delete mode 100644 arch/arm/mach-msm/board-trout.h
 delete mode 100644 arch/arm/mach-msm/include/mach/irqs-7x00.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
 delete mode 100644 arch/arm/mach-msm/irq.c

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index ebde97f..643a706 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -2,18 +2,7 @@ if ARCH_MSM
 
 choice
 	prompt "Qualcomm MSM SoC Type"
-	default ARCH_MSM7X00A
-
-config ARCH_MSM7X00A
-	bool "MSM7x00A / MSM7x01A"
-	select MACH_TROUT if !MACH_HALIBUT
-	select ARCH_MSM_ARM11
-	select MSM_SMD
-	select MSM_SMD_PKG3
-	select CPU_V6
-	select GPIO_MSM_V1
-	select MSM_PROC_COMM
-	select HAS_MSM_DEBUG_UART_PHYS
+	default ARCH_QSD8X50
 
 config ARCH_MSM7X30
 	bool "MSM7x30"
@@ -68,8 +57,6 @@ config MSM_SOC_REV_A
 config  ARCH_MSM_SCORPIONMP
 	bool
 
-config  ARCH_MSM_ARM11
-	bool
 config  ARCH_MSM_SCORPION
 	bool
 
@@ -81,20 +68,6 @@ config  MSM_VIC
 
 menu "Qualcomm MSM Board Type"
 
-config MACH_HALIBUT
-	depends on ARCH_MSM
-	depends on ARCH_MSM7X00A
-	bool "Halibut Board (QCT SURF7201A)"
-	help
-	  Support for the Qualcomm SURF7201A eval board.
-
-config MACH_TROUT
-	depends on ARCH_MSM
-	depends on ARCH_MSM7X00A
-	bool "HTC Dream (aka trout)"
-	help
-	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
-
 config MACH_MSM7X30_SURF
 	depends on ARCH_MSM7X30
 	bool "MSM7x30 SURF"
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 4ad3969..4a5dfb8 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -5,7 +5,6 @@ obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
 obj-$(CONFIG_MSM_IOMMU) += devices-iommu.o
 
-obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
 obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
 
@@ -20,9 +19,6 @@ CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
 obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
 obj-$(CONFIG_SMP) += headsmp.o platsmp.o
 
-obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
-obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o board-trout-panel.o devices-msm7x00.o
-obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
diff --git a/arch/arm/mach-msm/acpuclock-arm11.c b/arch/arm/mach-msm/acpuclock-arm11.c
deleted file mode 100644
index 805d4ee..0000000
--- a/arch/arm/mach-msm/acpuclock-arm11.c
+++ /dev/null
@@ -1,525 +0,0 @@
-/* arch/arm/mach-msm/acpuclock.c
- *
- * MSM architecture clock driver
- *
- * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2007 QUALCOMM Incorporated
- * Author: San Mehat <san@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/errno.h>
-#include <linux/string.h>
-#include <linux/delay.h>
-#include <linux/clk.h>
-#include <linux/cpufreq.h>
-#include <linux/mutex.h>
-#include <linux/io.h>
-#include <mach/board.h>
-#include <mach/msm_iomap.h>
-
-#include "proc_comm.h"
-#include "acpuclock.h"
-
-
-#define A11S_CLK_CNTL_ADDR (MSM_CSR_BASE + 0x100)
-#define A11S_CLK_SEL_ADDR (MSM_CSR_BASE + 0x104)
-#define A11S_VDD_SVS_PLEVEL_ADDR (MSM_CSR_BASE + 0x124)
-
-/*
- * ARM11 clock configuration for specific ACPU speeds
- */
-
-#define ACPU_PLL_TCXO	-1
-#define ACPU_PLL_0	0
-#define ACPU_PLL_1	1
-#define ACPU_PLL_2	2
-#define ACPU_PLL_3	3
-
-#define PERF_SWITCH_DEBUG 0
-#define PERF_SWITCH_STEP_DEBUG 0
-
-struct clock_state
-{
-	struct clkctl_acpu_speed	*current_speed;
-	struct mutex			lock;
-	uint32_t			acpu_switch_time_us;
-	uint32_t			max_speed_delta_khz;
-	uint32_t			vdd_switch_time_us;
-	unsigned long			power_collapse_khz;
-	unsigned long			wait_for_irq_khz;
-};
-
-static struct clk *ebi1_clk;
-static struct clock_state drv_state = { 0 };
-
-static void __init acpuclk_init(void);
-
-/* MSM7201A Levels 3-6 all correspond to 1.2V, level 7 corresponds to 1.325V. */
-enum {
-	VDD_0 = 0,
-	VDD_1 = 1,
-	VDD_2 = 2,
-	VDD_3 = 3,
-	VDD_4 = 3,
-	VDD_5 = 3,
-	VDD_6 = 3,
-	VDD_7 = 7,
-	VDD_END
-};
-
-struct clkctl_acpu_speed {
-	unsigned int	a11clk_khz;
-	int		pll;
-	unsigned int	a11clk_src_sel;
-	unsigned int	a11clk_src_div;
-	unsigned int	ahbclk_khz;
-	unsigned int	ahbclk_div;
-	int		vdd;
-	unsigned int 	axiclk_khz;
-	unsigned long	lpj; /* loops_per_jiffy */
-/* Index in acpu_freq_tbl[] for steppings. */
-	short		down;
-	short		up;
-};
-
-/*
- * ACPU speed table. Complete table is shown but certain speeds are commented
- * out to optimized speed switching. Initialize loops_per_jiffy to 0.
- *
- * Table stepping up/down is optimized for 256mhz jumps while staying on the
- * same PLL.
- */
-#if (0)
-static struct clkctl_acpu_speed  acpu_freq_tbl[] = {
-	{ 19200, ACPU_PLL_TCXO, 0, 0, 19200, 0, VDD_0, 30720, 0, 0, 8 },
-	{ 61440, ACPU_PLL_0,  4, 3, 61440,  0, VDD_0, 30720,  0, 0, 8 },
-	{ 81920, ACPU_PLL_0,  4, 2, 40960,  1, VDD_0, 61440,  0, 0, 8 },
-	{ 96000, ACPU_PLL_1,  1, 7, 48000,  1, VDD_0, 61440,  0, 0, 9 },
-	{ 122880, ACPU_PLL_0, 4, 1, 61440,  1, VDD_3, 61440,  0, 0, 8 },
-	{ 128000, ACPU_PLL_1, 1, 5, 64000,  1, VDD_3, 61440,  0, 0, 12 },
-	{ 176000, ACPU_PLL_2, 2, 5, 88000,  1, VDD_3, 61440,  0, 0, 11 },
-	{ 192000, ACPU_PLL_1, 1, 3, 64000,  2, VDD_3, 61440,  0, 0, 12 },
-	{ 245760, ACPU_PLL_0, 4, 0, 81920,  2, VDD_4, 61440,  0, 0, 12 },
-	{ 256000, ACPU_PLL_1, 1, 2, 128000, 2, VDD_5, 128000, 0, 0, 12 },
-	{ 264000, ACPU_PLL_2, 2, 3, 88000,  2, VDD_5, 128000, 0, 6, 13 },
-	{ 352000, ACPU_PLL_2, 2, 2, 88000,  3, VDD_5, 128000, 0, 6, 13 },
-	{ 384000, ACPU_PLL_1, 1, 1, 128000, 2, VDD_6, 128000, 0, 5, -1 },
-	{ 528000, ACPU_PLL_2, 2, 1, 132000, 3, VDD_7, 128000, 0, 11, -1 },
-	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
-};
-#else /* Table of freq we currently use. */
-static struct clkctl_acpu_speed  acpu_freq_tbl[] = {
-	{ 19200, ACPU_PLL_TCXO, 0, 0, 19200, 0, VDD_0, 30720, 0, 0, 4 },
-	{ 122880, ACPU_PLL_0, 4, 1, 61440, 1, VDD_3, 61440, 0, 0, 4 },
-	{ 128000, ACPU_PLL_1, 1, 5, 64000, 1, VDD_3, 61440, 0, 0, 6 },
-	{ 176000, ACPU_PLL_2, 2, 5, 88000, 1, VDD_3, 61440, 0, 0, 5 },
-	{ 245760, ACPU_PLL_0, 4, 0, 81920, 2, VDD_4, 61440, 0, 0, 5 },
-	{ 352000, ACPU_PLL_2, 2, 2, 88000, 3, VDD_5, 128000, 0, 3, 7 },
-	{ 384000, ACPU_PLL_1, 1, 1, 128000, 2, VDD_6, 128000, 0, 2, -1 },
-	{ 528000, ACPU_PLL_2, 2, 1, 132000, 3, VDD_7, 128000, 0, 5, -1 },
-	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
-};
-#endif
-
-
-#ifdef CONFIG_CPU_FREQ_TABLE
-static struct cpufreq_frequency_table freq_table[] = {
-	{ 0, 122880 },
-	{ 1, 128000 },
-	{ 2, 245760 },
-	{ 3, 384000 },
-	{ 4, 528000 },
-	{ 5, CPUFREQ_TABLE_END },
-};
-#endif
-
-static int pc_pll_request(unsigned id, unsigned on)
-{
-	int res;
-	on = !!on;
-
-#if PERF_SWITCH_DEBUG
-	if (on)
-		printk(KERN_DEBUG "Enabling PLL %d\n", id);
-	else
-		printk(KERN_DEBUG "Disabling PLL %d\n", id);
-#endif
-
-	res = msm_proc_comm(PCOM_CLKCTL_RPC_PLL_REQUEST, &id, &on);
-	if (res < 0)
-		return res;
-
-#if PERF_SWITCH_DEBUG
-	if (on)
-		printk(KERN_DEBUG "PLL %d enabled\n", id);
-	else
-		printk(KERN_DEBUG "PLL %d disabled\n", id);
-#endif
-	return res;
-}
-
-
-/*----------------------------------------------------------------------------
- * ARM11 'owned' clock control
- *---------------------------------------------------------------------------*/
-
-unsigned long acpuclk_power_collapse(void) {
-	int ret = acpuclk_get_rate();
-	ret *= 1000;
-	if (ret > drv_state.power_collapse_khz)
-		acpuclk_set_rate(drv_state.power_collapse_khz, 1);
-	return ret;
-}
-
-unsigned long acpuclk_get_wfi_rate(void)
-{
-	return drv_state.wait_for_irq_khz;
-}
-
-unsigned long acpuclk_wait_for_irq(void) {
-	int ret = acpuclk_get_rate();
-	ret *= 1000;
-	if (ret > drv_state.wait_for_irq_khz)
-		acpuclk_set_rate(drv_state.wait_for_irq_khz, 1);
-	return ret;
-}
-
-static int acpuclk_set_vdd_level(int vdd)
-{
-	uint32_t current_vdd;
-
-	current_vdd = readl(A11S_VDD_SVS_PLEVEL_ADDR) & 0x07;
-
-#if PERF_SWITCH_DEBUG
-	printk(KERN_DEBUG "acpuclock: Switching VDD from %u -> %d\n",
-	       current_vdd, vdd);
-#endif
-	writel((1 << 7) | (vdd << 3), A11S_VDD_SVS_PLEVEL_ADDR);
-	udelay(drv_state.vdd_switch_time_us);
-	if ((readl(A11S_VDD_SVS_PLEVEL_ADDR) & 0x7) != vdd) {
-#if PERF_SWITCH_DEBUG
-		printk(KERN_ERR "acpuclock: VDD set failed\n");
-#endif
-		return -EIO;
-	}
-
-#if PERF_SWITCH_DEBUG
-	printk(KERN_DEBUG "acpuclock: VDD switched\n");
-#endif
-	return 0;
-}
-
-/* Set proper dividers for the given clock speed. */
-static void acpuclk_set_div(const struct clkctl_acpu_speed *hunt_s) {
-	uint32_t reg_clkctl, reg_clksel, clk_div;
-
-	/* AHB_CLK_DIV */
-	clk_div = (readl(A11S_CLK_SEL_ADDR) >> 1) & 0x03;
-	/*
-	 * If the new clock divider is higher than the previous, then
-	 * program the divider before switching the clock
-	 */
-	if (hunt_s->ahbclk_div > clk_div) {
-		reg_clksel = readl(A11S_CLK_SEL_ADDR);
-		reg_clksel &= ~(0x3 << 1);
-		reg_clksel |= (hunt_s->ahbclk_div << 1);
-		writel(reg_clksel, A11S_CLK_SEL_ADDR);
-	}
-	if ((readl(A11S_CLK_SEL_ADDR) & 0x01) == 0) {
-		/* SRC0 */
-
-		/* Program clock source */
-		reg_clkctl = readl(A11S_CLK_CNTL_ADDR);
-		reg_clkctl &= ~(0x07 << 4);
-		reg_clkctl |= (hunt_s->a11clk_src_sel << 4);
-		writel(reg_clkctl, A11S_CLK_CNTL_ADDR);
-
-		/* Program clock divider */
-		reg_clkctl = readl(A11S_CLK_CNTL_ADDR);
-		reg_clkctl &= ~0xf;
-		reg_clkctl |= hunt_s->a11clk_src_div;
-		writel(reg_clkctl, A11S_CLK_CNTL_ADDR);
-
-		/* Program clock source selection */
-		reg_clksel = readl(A11S_CLK_SEL_ADDR);
-		reg_clksel |= 1; /* CLK_SEL_SRC1NO  == SRC1 */
-		writel(reg_clksel, A11S_CLK_SEL_ADDR);
-	} else {
-		/* SRC1 */
-
-		/* Program clock source */
-		reg_clkctl = readl(A11S_CLK_CNTL_ADDR);
-		reg_clkctl &= ~(0x07 << 12);
-		reg_clkctl |= (hunt_s->a11clk_src_sel << 12);
-		writel(reg_clkctl, A11S_CLK_CNTL_ADDR);
-
-		/* Program clock divider */
-		reg_clkctl = readl(A11S_CLK_CNTL_ADDR);
-		reg_clkctl &= ~(0xf << 8);
-		reg_clkctl |= (hunt_s->a11clk_src_div << 8);
-		writel(reg_clkctl, A11S_CLK_CNTL_ADDR);
-
-		/* Program clock source selection */
-		reg_clksel = readl(A11S_CLK_SEL_ADDR);
-		reg_clksel &= ~1; /* CLK_SEL_SRC1NO  == SRC0 */
-		writel(reg_clksel, A11S_CLK_SEL_ADDR);
-	}
-
-	/*
-	 * If the new clock divider is lower than the previous, then
-	 * program the divider after switching the clock
-	 */
-	if (hunt_s->ahbclk_div < clk_div) {
-		reg_clksel = readl(A11S_CLK_SEL_ADDR);
-		reg_clksel &= ~(0x3 << 1);
-		reg_clksel |= (hunt_s->ahbclk_div << 1);
-		writel(reg_clksel, A11S_CLK_SEL_ADDR);
-	}
-}
-
-int acpuclk_set_rate(unsigned long rate, int for_power_collapse)
-{
-	uint32_t reg_clkctl;
-	struct clkctl_acpu_speed *cur_s, *tgt_s, *strt_s;
-	int rc = 0;
-	unsigned int plls_enabled = 0, pll;
-
-	strt_s = cur_s = drv_state.current_speed;
-
-	WARN_ONCE(cur_s == NULL, "acpuclk_set_rate: not initialized\n");
-	if (cur_s == NULL)
-		return -ENOENT;
-
-	if (rate == (cur_s->a11clk_khz * 1000))
-		return 0;
-
-	for (tgt_s = acpu_freq_tbl; tgt_s->a11clk_khz != 0; tgt_s++) {
-		if (tgt_s->a11clk_khz == (rate / 1000))
-			break;
-	}
-
-	if (tgt_s->a11clk_khz == 0)
-		return -EINVAL;
-
-	/* Choose the highest speed speed at or below 'rate' with same PLL. */
-	if (for_power_collapse && tgt_s->a11clk_khz < cur_s->a11clk_khz) {
-		while (tgt_s->pll != ACPU_PLL_TCXO && tgt_s->pll != cur_s->pll)
-			tgt_s--;
-	}
-
-	if (strt_s->pll != ACPU_PLL_TCXO)
-		plls_enabled |= 1 << strt_s->pll;
-
-	if (!for_power_collapse) {
-		mutex_lock(&drv_state.lock);
-		if (strt_s->pll != tgt_s->pll && tgt_s->pll != ACPU_PLL_TCXO) {
-			rc = pc_pll_request(tgt_s->pll, 1);
-			if (rc < 0) {
-				pr_err("PLL%d enable failed (%d)\n",
-					tgt_s->pll, rc);
-				goto out;
-			}
-			plls_enabled |= 1 << tgt_s->pll;
-		}
-		/* Increase VDD if needed. */
-		if (tgt_s->vdd > cur_s->vdd) {
-			if ((rc = acpuclk_set_vdd_level(tgt_s->vdd)) < 0) {
-				printk(KERN_ERR "Unable to switch ACPU vdd\n");
-				goto out;
-			}
-		}
-	}
-
-	/* Set wait states for CPU between frequency changes */
-	reg_clkctl = readl(A11S_CLK_CNTL_ADDR);
-	reg_clkctl |= (100 << 16); /* set WT_ST_CNT */
-	writel(reg_clkctl, A11S_CLK_CNTL_ADDR);
-
-#if PERF_SWITCH_DEBUG
-	printk(KERN_INFO "acpuclock: Switching from ACPU rate %u -> %u\n",
-	       strt_s->a11clk_khz * 1000, tgt_s->a11clk_khz * 1000);
-#endif
-
-	while (cur_s != tgt_s) {
-		/*
-		 * Always jump to target freq if within 256mhz, regulardless of
-		 * PLL. If differnece is greater, use the predefinied
-		 * steppings in the table.
-		 */
-		int d = abs((int)(cur_s->a11clk_khz - tgt_s->a11clk_khz));
-		if (d > drv_state.max_speed_delta_khz) {
-			/* Step up or down depending on target vs current. */
-			int clk_index = tgt_s->a11clk_khz > cur_s->a11clk_khz ?
-				cur_s->up : cur_s->down;
-			if (clk_index < 0) { /* This should not happen. */
-				printk(KERN_ERR "cur:%u target: %u\n",
-					cur_s->a11clk_khz, tgt_s->a11clk_khz);
-				rc = -EINVAL;
-				goto out;
-			}
-			cur_s = &acpu_freq_tbl[clk_index];
-		} else {
-			cur_s = tgt_s;
-		}
-#if PERF_SWITCH_STEP_DEBUG
-		printk(KERN_DEBUG "%s: STEP khz = %u, pll = %d\n",
-			__FUNCTION__, cur_s->a11clk_khz, cur_s->pll);
-#endif
-		if (!for_power_collapse&& cur_s->pll != ACPU_PLL_TCXO
-		    && !(plls_enabled & (1 << cur_s->pll))) {
-			rc = pc_pll_request(cur_s->pll, 1);
-			if (rc < 0) {
-				pr_err("PLL%d enable failed (%d)\n",
-					cur_s->pll, rc);
-				goto out;
-			}
-			plls_enabled |= 1 << cur_s->pll;
-		}
-
-		acpuclk_set_div(cur_s);
-		drv_state.current_speed = cur_s;
-		/* Re-adjust lpj for the new clock speed. */
-		loops_per_jiffy = cur_s->lpj;
-		udelay(drv_state.acpu_switch_time_us);
-	}
-
-	/* Nothing else to do for power collapse. */
-	if (for_power_collapse)
-		return 0;
-
-	/* Disable PLLs we are not using anymore. */
-	plls_enabled &= ~(1 << tgt_s->pll);
-	for (pll = ACPU_PLL_0; pll <= ACPU_PLL_2; pll++)
-		if (plls_enabled & (1 << pll)) {
-			rc = pc_pll_request(pll, 0);
-			if (rc < 0) {
-				pr_err("PLL%d disable failed (%d)\n", pll, rc);
-				goto out;
-			}
-		}
-
-	/* Change the AXI bus frequency if we can. */
-	if (strt_s->axiclk_khz != tgt_s->axiclk_khz) {
-		rc = clk_set_rate(ebi1_clk, tgt_s->axiclk_khz * 1000);
-		if (rc < 0)
-			pr_err("Setting AXI min rate failed!\n");
-	}
-
-	/* Drop VDD level if we can. */
-	if (tgt_s->vdd < strt_s->vdd) {
-		if (acpuclk_set_vdd_level(tgt_s->vdd) < 0)
-			printk(KERN_ERR "acpuclock: Unable to drop ACPU vdd\n");
-	}
-
-#if PERF_SWITCH_DEBUG
-	printk(KERN_DEBUG "%s: ACPU speed change complete\n", __FUNCTION__);
-#endif
-out:
-	if (!for_power_collapse)
-		mutex_unlock(&drv_state.lock);
-	return rc;
-}
-
-static void __init acpuclk_init(void)
-{
-	struct clkctl_acpu_speed *speed;
-	uint32_t div, sel;
-	int rc;
-
-	/*
-	 * Determine the rate of ACPU clock
-	 */
-
-	if (!(readl(A11S_CLK_SEL_ADDR) & 0x01)) { /* CLK_SEL_SRC1N0 */
-		/* CLK_SRC0_SEL */
-		sel = (readl(A11S_CLK_CNTL_ADDR) >> 12) & 0x7;
-		/* CLK_SRC0_DIV */
-		div = (readl(A11S_CLK_CNTL_ADDR) >> 8) & 0x0f;
-	} else {
-		/* CLK_SRC1_SEL */
-		sel = (readl(A11S_CLK_CNTL_ADDR) >> 4) & 0x07;
-		/* CLK_SRC1_DIV */
-		div = readl(A11S_CLK_CNTL_ADDR) & 0x0f;
-	}
-
-	for (speed = acpu_freq_tbl; speed->a11clk_khz != 0; speed++) {
-		if (speed->a11clk_src_sel == sel
-		 && (speed->a11clk_src_div == div))
-			break;
-	}
-	if (speed->a11clk_khz == 0) {
-		printk(KERN_WARNING "Warning - ACPU clock reports invalid speed\n");
-		return;
-	}
-
-	drv_state.current_speed = speed;
-
-	rc = clk_set_rate(ebi1_clk, speed->axiclk_khz * 1000);
-	if (rc < 0)
-		pr_err("Setting AXI min rate failed!\n");
-
-	printk(KERN_INFO "ACPU running at %d KHz\n", speed->a11clk_khz);
-}
-
-unsigned long acpuclk_get_rate(void)
-{
-	WARN_ONCE(drv_state.current_speed == NULL,
-		  "acpuclk_get_rate: not initialized\n");
-	if (drv_state.current_speed)
-		return drv_state.current_speed->a11clk_khz;
-	else
-		return 0;
-}
-
-uint32_t acpuclk_get_switch_time(void)
-{
-	return drv_state.acpu_switch_time_us;
-}
-
-/*----------------------------------------------------------------------------
- * Clock driver initialization
- *---------------------------------------------------------------------------*/
-
-/* Initialize the lpj field in the acpu_freq_tbl. */
-static void __init lpj_init(void)
-{
-	int i;
-	const struct clkctl_acpu_speed *base_clk = drv_state.current_speed;
-	for (i = 0; acpu_freq_tbl[i].a11clk_khz; i++) {
-		acpu_freq_tbl[i].lpj = cpufreq_scale(loops_per_jiffy,
-						base_clk->a11clk_khz,
-						acpu_freq_tbl[i].a11clk_khz);
-	}
-}
-
-void __init msm_acpu_clock_init(struct msm_acpu_clock_platform_data *clkdata)
-{
-	pr_info("acpu_clock_init()\n");
-
-	ebi1_clk = clk_get(NULL, "ebi1_clk");
-
-	mutex_init(&drv_state.lock);
-	drv_state.acpu_switch_time_us = clkdata->acpu_switch_time_us;
-	drv_state.max_speed_delta_khz = clkdata->max_speed_delta_khz;
-	drv_state.vdd_switch_time_us = clkdata->vdd_switch_time_us;
-	drv_state.power_collapse_khz = clkdata->power_collapse_khz;
-	drv_state.wait_for_irq_khz = clkdata->wait_for_irq_khz;
-	acpuclk_init();
-	lpj_init();
-#ifdef CONFIG_CPU_FREQ_TABLE
-	cpufreq_frequency_table_get_attr(freq_table, smp_processor_id());
-#endif
-}
diff --git a/arch/arm/mach-msm/acpuclock.h b/arch/arm/mach-msm/acpuclock.h
deleted file mode 100644
index 415de2e..0000000
--- a/arch/arm/mach-msm/acpuclock.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/* arch/arm/mach-msm/acpuclock.h
- *
- * MSM architecture clock driver header
- *
- * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2007 QUALCOMM Incorporated
- * Author: San Mehat <san@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __ARCH_ARM_MACH_MSM_ACPUCLOCK_H
-#define __ARCH_ARM_MACH_MSM_ACPUCLOCK_H
-
-int acpuclk_set_rate(unsigned long rate, int for_power_collapse);
-unsigned long acpuclk_get_rate(void);
-uint32_t acpuclk_get_switch_time(void);
-unsigned long acpuclk_wait_for_irq(void);
-unsigned long acpuclk_power_collapse(void);
-unsigned long acpuclk_get_wfi_rate(void);
-
-
-#endif
-
diff --git a/arch/arm/mach-msm/board-halibut.c b/arch/arm/mach-msm/board-halibut.c
deleted file mode 100644
index a60ab6d..0000000
--- a/arch/arm/mach-msm/board-halibut.c
+++ /dev/null
@@ -1,102 +0,0 @@
-/* linux/arch/arm/mach-msm/board-halibut.c
- *
- * Copyright (C) 2007 Google, Inc.
- * Author: Brian Swetland <swetland@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/input.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-
-#include <mach/hardware.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/mach/flash.h>
-#include <asm/setup.h>
-
-#include <mach/irqs.h>
-#include <mach/board.h>
-#include <mach/msm_iomap.h>
-
-#include <linux/mtd/nand.h>
-#include <linux/mtd/partitions.h>
-
-#include "devices.h"
-
-static struct resource smc91x_resources[] = {
-	[0] = {
-		.start	= 0x9C004300,
-		.end	= 0x9C004400,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= MSM_GPIO_TO_INT(49),
-		.end	= MSM_GPIO_TO_INT(49),
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device smc91x_device = {
-	.name		= "smc91x",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(smc91x_resources),
-	.resource	= smc91x_resources,
-};
-
-static struct platform_device *devices[] __initdata = {
-	&msm_device_uart3,
-	&msm_device_smd,
-	&msm_device_nand,
-	&msm_device_hsusb,
-	&msm_device_i2c,
-	&smc91x_device,
-};
-
-extern struct sys_timer msm_timer;
-
-static void __init halibut_init_irq(void)
-{
-	msm_init_irq();
-}
-
-static void __init halibut_init(void)
-{
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-}
-
-static void __init halibut_fixup(struct tag *tags, char **cmdline,
-				 struct meminfo *mi)
-{
-	mi->nr_banks=1;
-	mi->bank[0].start = PHYS_OFFSET;
-	mi->bank[0].size = (101*1024*1024);
-}
-
-static void __init halibut_map_io(void)
-{
-	msm_map_common_io();
-	msm_clock_init(msm_clocks_7x01a, msm_num_clocks_7x01a);
-}
-
-MACHINE_START(HALIBUT, "Halibut Board (QCT SURF7200A)")
-	.atag_offset	= 0x100,
-	.fixup		= halibut_fixup,
-	.map_io		= halibut_map_io,
-	.init_irq	= halibut_init_irq,
-	.init_machine	= halibut_init,
-	.timer		= &msm_timer,
-MACHINE_END
diff --git a/arch/arm/mach-msm/board-trout-gpio.c b/arch/arm/mach-msm/board-trout-gpio.c
deleted file mode 100644
index 87e1d01..0000000
--- a/arch/arm/mach-msm/board-trout-gpio.c
+++ /dev/null
@@ -1,233 +0,0 @@
-/*
- * linux/arch/arm/mach-msm/gpio.c
- *
- * Copyright (C) 2005 HP Labs
- * Copyright (C) 2008 Google, Inc.
- * Copyright (C) 2009 Pavel Machek <pavel@ucw.cz>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/interrupt.h>
-#include <linux/gpio.h>
-
-#include "board-trout.h"
-
-static uint8_t trout_int_mask[2] = {
-	[0] = 0xff, /* mask all interrupts */
-	[1] = 0xff,
-};
-static uint8_t trout_sleep_int_mask[] = {
-	[0] = 0xff,
-	[1] = 0xff,
-};
-
-struct msm_gpio_chip {
-	struct gpio_chip	chip;
-	void __iomem		*reg;	/* Base of register bank */
-	u8			shadow;
-};
-
-#define to_msm_gpio_chip(c) container_of(c, struct msm_gpio_chip, chip)
-
-static int msm_gpiolib_get(struct gpio_chip *chip, unsigned offset)
-{
-	struct msm_gpio_chip *msm_gpio = to_msm_gpio_chip(chip);
-	unsigned mask = 1 << offset;
-
-	return !!(readb(msm_gpio->reg) & mask);
-}
-
-static void msm_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val)
-{
-	struct msm_gpio_chip *msm_gpio = to_msm_gpio_chip(chip);
-	unsigned mask = 1 << offset;
-
-	if (val)
-		msm_gpio->shadow |= mask;
-	else
-		msm_gpio->shadow &= ~mask;
-
-	writeb(msm_gpio->shadow, msm_gpio->reg);
-}
-
-static int msm_gpiolib_direction_input(struct gpio_chip *chip,
-					unsigned offset)
-{
-	msm_gpiolib_set(chip, offset, 0);
-	return 0;
-}
-
-static int msm_gpiolib_direction_output(struct gpio_chip *chip,
-					 unsigned offset, int val)
-{
-	msm_gpiolib_set(chip, offset, val);
-	return 0;
-}
-
-static int trout_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	return TROUT_GPIO_TO_INT(offset + chip->base);
-}
-
-#define TROUT_GPIO_BANK(name, reg_num, base_gpio, shadow_val)		\
-	{								\
-		.chip = {						\
-			.label		  = name,			\
-			.direction_input  = msm_gpiolib_direction_input,\
-			.direction_output = msm_gpiolib_direction_output, \
-			.get		  = msm_gpiolib_get,		\
-			.set		  = msm_gpiolib_set,		\
-			.to_irq		  = trout_gpio_to_irq,		\
-			.base		  = base_gpio,			\
-			.ngpio		  = 8,				\
-		},							\
-		.reg = (void *) reg_num + TROUT_CPLD_BASE,		\
-		.shadow = shadow_val,					\
-	}
-
-static struct msm_gpio_chip msm_gpio_banks[] = {
-#if defined(CONFIG_MSM_DEBUG_UART1)
-	/* H2W pins <-> UART1 */
-	TROUT_GPIO_BANK("MISC2", 0x00,   TROUT_GPIO_MISC2_BASE, 0x40),
-#else
-	/* H2W pins <-> UART3, Bluetooth <-> UART1 */
-	TROUT_GPIO_BANK("MISC2", 0x00,   TROUT_GPIO_MISC2_BASE, 0x80),
-#endif
-	/* I2C pull */
-	TROUT_GPIO_BANK("MISC3", 0x02,   TROUT_GPIO_MISC3_BASE, 0x04),
-	TROUT_GPIO_BANK("MISC4", 0x04,   TROUT_GPIO_MISC4_BASE, 0),
-	/* mmdi 32k en */
-	TROUT_GPIO_BANK("MISC5", 0x06,   TROUT_GPIO_MISC5_BASE, 0x04),
-	TROUT_GPIO_BANK("INT2", 0x08,    TROUT_GPIO_INT2_BASE,  0),
-	TROUT_GPIO_BANK("MISC1", 0x0a,   TROUT_GPIO_MISC1_BASE, 0),
-	TROUT_GPIO_BANK("VIRTUAL", 0x12, TROUT_GPIO_VIRTUAL_BASE, 0),
-};
-
-static void trout_gpio_irq_ack(struct irq_data *d)
-{
-	int bank = TROUT_INT_TO_BANK(d->irq);
-	uint8_t mask = TROUT_INT_TO_MASK(d->irq);
-	int reg = TROUT_BANK_TO_STAT_REG(bank);
-	/*printk(KERN_INFO "trout_gpio_irq_ack irq %d\n", d->irq);*/
-	writeb(mask, TROUT_CPLD_BASE + reg);
-}
-
-static void trout_gpio_irq_mask(struct irq_data *d)
-{
-	unsigned long flags;
-	uint8_t reg_val;
-	int bank = TROUT_INT_TO_BANK(d->irq);
-	uint8_t mask = TROUT_INT_TO_MASK(d->irq);
-	int reg = TROUT_BANK_TO_MASK_REG(bank);
-
-	local_irq_save(flags);
-	reg_val = trout_int_mask[bank] |= mask;
-	/*printk(KERN_INFO "trout_gpio_irq_mask irq %d => %d:%02x\n",
-	       d->irq, bank, reg_val);*/
-	writeb(reg_val, TROUT_CPLD_BASE + reg);
-	local_irq_restore(flags);
-}
-
-static void trout_gpio_irq_unmask(struct irq_data *d)
-{
-	unsigned long flags;
-	uint8_t reg_val;
-	int bank = TROUT_INT_TO_BANK(d->irq);
-	uint8_t mask = TROUT_INT_TO_MASK(d->irq);
-	int reg = TROUT_BANK_TO_MASK_REG(bank);
-
-	local_irq_save(flags);
-	reg_val = trout_int_mask[bank] &= ~mask;
-	/*printk(KERN_INFO "trout_gpio_irq_unmask irq %d => %d:%02x\n",
-	       d->irq, bank, reg_val);*/
-	writeb(reg_val, TROUT_CPLD_BASE + reg);
-	local_irq_restore(flags);
-}
-
-int trout_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
-{
-	unsigned long flags;
-	int bank = TROUT_INT_TO_BANK(d->irq);
-	uint8_t mask = TROUT_INT_TO_MASK(d->irq);
-
-	local_irq_save(flags);
-	if(on)
-		trout_sleep_int_mask[bank] &= ~mask;
-	else
-		trout_sleep_int_mask[bank] |= mask;
-	local_irq_restore(flags);
-	return 0;
-}
-
-static void trout_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
-{
-	int j, m;
-	unsigned v;
-	int bank;
-	int stat_reg;
-	int int_base = TROUT_INT_START;
-	uint8_t int_mask;
-
-	for (bank = 0; bank < 2; bank++) {
-		stat_reg = TROUT_BANK_TO_STAT_REG(bank);
-		v = readb(TROUT_CPLD_BASE + stat_reg);
-		int_mask = trout_int_mask[bank];
-		if (v & int_mask) {
-			writeb(v & int_mask, TROUT_CPLD_BASE + stat_reg);
-			printk(KERN_ERR "trout_gpio_irq_handler: got masked "
-			       "interrupt: %d:%02x\n", bank, v & int_mask);
-		}
-		v &= ~int_mask;
-		while (v) {
-			m = v & -v;
-			j = fls(m) - 1;
-			/*printk(KERN_INFO "msm_gpio_irq_handler %d:%02x %02x b"
-			       "it %d irq %d\n", bank, v, m, j, int_base + j);*/
-			v &= ~m;
-			generic_handle_irq(int_base + j);
-		}
-		int_base += TROUT_INT_BANK0_COUNT;
-	}
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
-}
-
-static struct irq_chip trout_gpio_irq_chip = {
-	.name          = "troutgpio",
-	.irq_ack       = trout_gpio_irq_ack,
-	.irq_mask      = trout_gpio_irq_mask,
-	.irq_unmask    = trout_gpio_irq_unmask,
-	.irq_set_wake  = trout_gpio_irq_set_wake,
-};
-
-/*
- * Called from the processor-specific init to enable GPIO pin support.
- */
-int __init trout_init_gpio(void)
-{
-	int i;
-	for(i = TROUT_INT_START; i <= TROUT_INT_END; i++) {
-		irq_set_chip_and_handler(i, &trout_gpio_irq_chip,
-					 handle_edge_irq);
-		set_irq_flags(i, IRQF_VALID);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(msm_gpio_banks); i++)
-		gpiochip_add(&msm_gpio_banks[i].chip);
-
-	irq_set_irq_type(MSM_GPIO_TO_INT(17), IRQF_TRIGGER_HIGH);
-	irq_set_chained_handler(MSM_GPIO_TO_INT(17), trout_gpio_irq_handler);
-	irq_set_irq_wake(MSM_GPIO_TO_INT(17), 1);
-
-	return 0;
-}
-
-postcore_initcall(trout_init_gpio);
-
diff --git a/arch/arm/mach-msm/board-trout-mmc.c b/arch/arm/mach-msm/board-trout-mmc.c
deleted file mode 100644
index 8650342..0000000
--- a/arch/arm/mach-msm/board-trout-mmc.c
+++ /dev/null
@@ -1,185 +0,0 @@
-/* linux/arch/arm/mach-msm/board-trout-mmc.c
-** Author: Brian Swetland <swetland@google.com>
-*/
-#include <linux/gpio.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/delay.h>
-#include <linux/mmc/host.h>
-#include <linux/mmc/sdio_ids.h>
-#include <linux/err.h>
-#include <linux/debugfs.h>
-
-#include <asm/io.h>
-
-#include <mach/vreg.h>
-
-#include <mach/mmc.h>
-
-#include "devices.h"
-
-#include "board-trout.h"
-
-#include "proc_comm.h"
-
-#define DEBUG_SDSLOT_VDD 1
-
-/* ---- COMMON ---- */
-static void config_gpio_table(uint32_t *table, int len)
-{
-	int n;
-	unsigned id;
-	for(n = 0; n < len; n++) {
-		id = table[n];
-		msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX, &id, 0);
-	}
-}
-
-/* ---- SDCARD ---- */
-
-static uint32_t sdcard_on_gpio_table[] = {
-	PCOM_GPIO_CFG(62, 2, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_8MA), /* CLK */
-	PCOM_GPIO_CFG(63, 2, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_8MA), /* CMD */
-	PCOM_GPIO_CFG(64, 2, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_8MA), /* DAT3 */
-	PCOM_GPIO_CFG(65, 2, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_8MA), /* DAT2 */
-	PCOM_GPIO_CFG(66, 2, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_4MA), /* DAT1 */
-	PCOM_GPIO_CFG(67, 2, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_4MA), /* DAT0 */
-};
-
-static uint32_t sdcard_off_gpio_table[] = {
-	PCOM_GPIO_CFG(62, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* CLK */
-	PCOM_GPIO_CFG(63, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* CMD */
-	PCOM_GPIO_CFG(64, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT3 */
-	PCOM_GPIO_CFG(65, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT2 */
-	PCOM_GPIO_CFG(66, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT1 */
-	PCOM_GPIO_CFG(67, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT0 */
-};
-
-static uint opt_disable_sdcard;
-
-static int __init trout_disablesdcard_setup(char *str)
-{
-	int cal = simple_strtol(str, NULL, 0);
-	
-	opt_disable_sdcard = cal;
-	return 1;
-}
-
-__setup("board_trout.disable_sdcard=", trout_disablesdcard_setup);
-
-static struct vreg *vreg_sdslot;	/* SD slot power */
-
-struct mmc_vdd_xlat {
-	int mask;
-	int level;
-};
-
-static struct mmc_vdd_xlat mmc_vdd_table[] = {
-	{ MMC_VDD_165_195,	1800 },
-	{ MMC_VDD_20_21,	2050 },
-	{ MMC_VDD_21_22,	2150 },
-	{ MMC_VDD_22_23,	2250 },
-	{ MMC_VDD_23_24,	2350 },
-	{ MMC_VDD_24_25,	2450 },
-	{ MMC_VDD_25_26,	2550 },
-	{ MMC_VDD_26_27,	2650 },
-	{ MMC_VDD_27_28,	2750 },
-	{ MMC_VDD_28_29,	2850 },
-	{ MMC_VDD_29_30,	2950 },
-};
-
-static unsigned int sdslot_vdd = 0xffffffff;
-static unsigned int sdslot_vreg_enabled;
-
-static uint32_t trout_sdslot_switchvdd(struct device *dev, unsigned int vdd)
-{
-	int i, rc;
-
-	BUG_ON(!vreg_sdslot);
-
-	if (vdd == sdslot_vdd)
-		return 0;
-
-	sdslot_vdd = vdd;
-
-	if (vdd == 0) {
-#if DEBUG_SDSLOT_VDD
-		printk("%s: Disabling SD slot power\n", __func__);
-#endif
-		config_gpio_table(sdcard_off_gpio_table,
-				  ARRAY_SIZE(sdcard_off_gpio_table));
-		vreg_disable(vreg_sdslot);
-		sdslot_vreg_enabled = 0;
-		return 0;
-	}
-
-	if (!sdslot_vreg_enabled) {
-		rc = vreg_enable(vreg_sdslot);
-		if (rc) {
-			printk(KERN_ERR "%s: Error enabling vreg (%d)\n",
-			       __func__, rc);
-		}
-		config_gpio_table(sdcard_on_gpio_table,
-				  ARRAY_SIZE(sdcard_on_gpio_table));
-		sdslot_vreg_enabled = 1;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(mmc_vdd_table); i++) {
-		if (mmc_vdd_table[i].mask == (1 << vdd)) {
-#if DEBUG_SDSLOT_VDD
-			printk("%s: Setting level to %u\n",
-			        __func__, mmc_vdd_table[i].level);
-#endif
-			rc = vreg_set_level(vreg_sdslot,
-					    mmc_vdd_table[i].level);
-			if (rc) {
-				printk(KERN_ERR
-				       "%s: Error setting vreg level (%d)\n",
-				       __func__, rc);
-			}
-			return 0;
-		}
-	}
-
-	printk(KERN_ERR "%s: Invalid VDD %d specified\n", __func__, vdd);
-	return 0;
-}
-
-static unsigned int trout_sdslot_status(struct device *dev)
-{
-	unsigned int status;
-
-	status = (unsigned int) gpio_get_value(TROUT_GPIO_SDMC_CD_N);
-	return (!status);
-}
-
-#define TROUT_MMC_VDD	MMC_VDD_165_195 | MMC_VDD_20_21 | MMC_VDD_21_22 \
-			| MMC_VDD_22_23 | MMC_VDD_23_24 | MMC_VDD_24_25 \
-			| MMC_VDD_25_26 | MMC_VDD_26_27 | MMC_VDD_27_28 \
-			| MMC_VDD_28_29 | MMC_VDD_29_30
-
-static struct msm_mmc_platform_data trout_sdslot_data = {
-	.ocr_mask	= TROUT_MMC_VDD,
-	.status		= trout_sdslot_status,
-	.translate_vdd	= trout_sdslot_switchvdd,
-};
-
-int __init trout_init_mmc(unsigned int sys_rev)
-{
-	sdslot_vreg_enabled = 0;
-
-	vreg_sdslot = vreg_get(0, "gp6");
-	if (IS_ERR(vreg_sdslot))
-		return PTR_ERR(vreg_sdslot);
-
-	irq_set_irq_wake(TROUT_GPIO_TO_INT(TROUT_GPIO_SDMC_CD_N), 1);
-
-	if (!opt_disable_sdcard)
-		msm_add_sdcc(2, &trout_sdslot_data,
-			     TROUT_GPIO_TO_INT(TROUT_GPIO_SDMC_CD_N), 0);
-	else
-		printk(KERN_INFO "trout: SD-Card interface disabled\n");
-	return 0;
-}
-
diff --git a/arch/arm/mach-msm/board-trout-panel.c b/arch/arm/mach-msm/board-trout-panel.c
deleted file mode 100644
index 25105c1..0000000
--- a/arch/arm/mach-msm/board-trout-panel.c
+++ /dev/null
@@ -1,296 +0,0 @@
-/* linux/arch/arm/mach-msm/board-trout-mddi.c
-** Author: Brian Swetland <swetland@google.com>
-*/
-#include <linux/gpio.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/delay.h>
-#include <linux/leds.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-
-#include <asm/io.h>
-#include <asm/mach-types.h>
-
-#include <mach/msm_fb.h>
-#include <mach/vreg.h>
-
-#include "board-trout.h"
-#include "proc_comm.h"
-#include "devices.h"
-
-#define TROUT_DEFAULT_BACKLIGHT_BRIGHTNESS 255
-
-#define MDDI_CLIENT_CORE_BASE  0x108000
-#define LCD_CONTROL_BLOCK_BASE 0x110000
-#define SPI_BLOCK_BASE         0x120000
-#define I2C_BLOCK_BASE         0x130000
-#define PWM_BLOCK_BASE         0x140000
-#define GPIO_BLOCK_BASE        0x150000
-#define SYSTEM_BLOCK1_BASE     0x160000
-#define SYSTEM_BLOCK2_BASE     0x170000
-
-
-#define	DPSUS       (MDDI_CLIENT_CORE_BASE|0x24)
-#define	SYSCLKENA   (MDDI_CLIENT_CORE_BASE|0x2C)
-#define	PWM0OFF	      (PWM_BLOCK_BASE|0x1C)
-
-#define V_VDDE2E_VDD2_GPIO 0
-#define MDDI_RST_N 82
-
-#define	MDDICAP0    (MDDI_CLIENT_CORE_BASE|0x00)
-#define	MDDICAP1    (MDDI_CLIENT_CORE_BASE|0x04)
-#define	MDDICAP2    (MDDI_CLIENT_CORE_BASE|0x08)
-#define	MDDICAP3    (MDDI_CLIENT_CORE_BASE|0x0C)
-#define	MDCAPCHG    (MDDI_CLIENT_CORE_BASE|0x10)
-#define	MDCRCERC    (MDDI_CLIENT_CORE_BASE|0x14)
-#define	TTBUSSEL    (MDDI_CLIENT_CORE_BASE|0x18)
-#define	DPSET0      (MDDI_CLIENT_CORE_BASE|0x1C)
-#define	DPSET1      (MDDI_CLIENT_CORE_BASE|0x20)
-#define	DPSUS       (MDDI_CLIENT_CORE_BASE|0x24)
-#define	DPRUN       (MDDI_CLIENT_CORE_BASE|0x28)
-#define	SYSCKENA    (MDDI_CLIENT_CORE_BASE|0x2C)
-#define	TESTMODE    (MDDI_CLIENT_CORE_BASE|0x30)
-#define	FIFOMONI    (MDDI_CLIENT_CORE_BASE|0x34)
-#define	INTMONI     (MDDI_CLIENT_CORE_BASE|0x38)
-#define	MDIOBIST    (MDDI_CLIENT_CORE_BASE|0x3C)
-#define	MDIOPSET    (MDDI_CLIENT_CORE_BASE|0x40)
-#define	BITMAP0     (MDDI_CLIENT_CORE_BASE|0x44)
-#define	BITMAP1     (MDDI_CLIENT_CORE_BASE|0x48)
-#define	BITMAP2     (MDDI_CLIENT_CORE_BASE|0x4C)
-#define	BITMAP3     (MDDI_CLIENT_CORE_BASE|0x50)
-#define	BITMAP4     (MDDI_CLIENT_CORE_BASE|0x54)
-
-#define	SRST        (LCD_CONTROL_BLOCK_BASE|0x00)
-#define	PORT_ENB    (LCD_CONTROL_BLOCK_BASE|0x04)
-#define	START       (LCD_CONTROL_BLOCK_BASE|0x08)
-#define	PORT        (LCD_CONTROL_BLOCK_BASE|0x0C)
-#define	CMN         (LCD_CONTROL_BLOCK_BASE|0x10)
-#define	GAMMA       (LCD_CONTROL_BLOCK_BASE|0x14)
-#define	INTFLG      (LCD_CONTROL_BLOCK_BASE|0x18)
-#define	INTMSK      (LCD_CONTROL_BLOCK_BASE|0x1C)
-#define	MPLFBUF     (LCD_CONTROL_BLOCK_BASE|0x20)
-#define	HDE_LEFT    (LCD_CONTROL_BLOCK_BASE|0x24)
-#define	VDE_TOP     (LCD_CONTROL_BLOCK_BASE|0x28)
-#define	PXL         (LCD_CONTROL_BLOCK_BASE|0x30)
-#define	HCYCLE      (LCD_CONTROL_BLOCK_BASE|0x34)
-#define	HSW         (LCD_CONTROL_BLOCK_BASE|0x38)
-#define	HDE_START   (LCD_CONTROL_BLOCK_BASE|0x3C)
-#define	HDE_SIZE    (LCD_CONTROL_BLOCK_BASE|0x40)
-#define	VCYCLE      (LCD_CONTROL_BLOCK_BASE|0x44)
-#define	VSW         (LCD_CONTROL_BLOCK_BASE|0x48)
-#define	VDE_START   (LCD_CONTROL_BLOCK_BASE|0x4C)
-#define	VDE_SIZE    (LCD_CONTROL_BLOCK_BASE|0x50)
-#define	WAKEUP      (LCD_CONTROL_BLOCK_BASE|0x54)
-#define	WSYN_DLY    (LCD_CONTROL_BLOCK_BASE|0x58)
-#define	REGENB      (LCD_CONTROL_BLOCK_BASE|0x5C)
-#define	VSYNIF      (LCD_CONTROL_BLOCK_BASE|0x60)
-#define	WRSTB       (LCD_CONTROL_BLOCK_BASE|0x64)
-#define	RDSTB       (LCD_CONTROL_BLOCK_BASE|0x68)
-#define	ASY_DATA    (LCD_CONTROL_BLOCK_BASE|0x6C)
-#define	ASY_DATB    (LCD_CONTROL_BLOCK_BASE|0x70)
-#define	ASY_DATC    (LCD_CONTROL_BLOCK_BASE|0x74)
-#define	ASY_DATD    (LCD_CONTROL_BLOCK_BASE|0x78)
-#define	ASY_DATE    (LCD_CONTROL_BLOCK_BASE|0x7C)
-#define	ASY_DATF    (LCD_CONTROL_BLOCK_BASE|0x80)
-#define	ASY_DATG    (LCD_CONTROL_BLOCK_BASE|0x84)
-#define	ASY_DATH    (LCD_CONTROL_BLOCK_BASE|0x88)
-#define	ASY_CMDSET  (LCD_CONTROL_BLOCK_BASE|0x8C)
-
-#define	SSICTL      (SPI_BLOCK_BASE|0x00)
-#define	SSITIME     (SPI_BLOCK_BASE|0x04)
-#define	SSITX       (SPI_BLOCK_BASE|0x08)
-#define	SSIRX       (SPI_BLOCK_BASE|0x0C)
-#define	SSIINTC     (SPI_BLOCK_BASE|0x10)
-#define	SSIINTS     (SPI_BLOCK_BASE|0x14)
-#define	SSIDBG1     (SPI_BLOCK_BASE|0x18)
-#define	SSIDBG2     (SPI_BLOCK_BASE|0x1C)
-#define	SSIID       (SPI_BLOCK_BASE|0x20)
-
-#define	WKREQ       (SYSTEM_BLOCK1_BASE|0x00)
-#define	CLKENB      (SYSTEM_BLOCK1_BASE|0x04)
-#define	DRAMPWR     (SYSTEM_BLOCK1_BASE|0x08)
-#define	INTMASK     (SYSTEM_BLOCK1_BASE|0x0C)
-#define	GPIOSEL     (SYSTEM_BLOCK2_BASE|0x00)
-
-#define	GPIODATA    (GPIO_BLOCK_BASE|0x00)
-#define	GPIODIR     (GPIO_BLOCK_BASE|0x04)
-#define	GPIOIS      (GPIO_BLOCK_BASE|0x08)
-#define	GPIOIBE     (GPIO_BLOCK_BASE|0x0C)
-#define	GPIOIEV     (GPIO_BLOCK_BASE|0x10)
-#define	GPIOIE      (GPIO_BLOCK_BASE|0x14)
-#define	GPIORIS     (GPIO_BLOCK_BASE|0x18)
-#define	GPIOMIS     (GPIO_BLOCK_BASE|0x1C)
-#define	GPIOIC      (GPIO_BLOCK_BASE|0x20)
-#define	GPIOOMS     (GPIO_BLOCK_BASE|0x24)
-#define	GPIOPC      (GPIO_BLOCK_BASE|0x28)
-#define	GPIOID      (GPIO_BLOCK_BASE|0x30)
-
-#define SPI_WRITE(reg, val) \
-	{ SSITX,        0x00010000 | (((reg) & 0xff) << 8) | ((val) & 0xff) }, \
-	{ 0, 5 },
-
-#define SPI_WRITE1(reg) \
-	{ SSITX,        (reg) & 0xff }, \
-	{ 0, 5 },
-
-struct mddi_table {
-	uint32_t reg;
-	uint32_t value;
-};
-static struct mddi_table mddi_toshiba_init_table[] = {
-	{ DPSET0,       0x09e90046 },
-	{ DPSET1,       0x00000118 },
-	{ DPSUS,        0x00000000 },
-	{ DPRUN,        0x00000001 },
-	{ 1,            14         }, /* msleep 14 */
-	{ SYSCKENA,     0x00000001 },
-	{ CLKENB,       0x0000A1EF },  /*    # SYS.CLKENB  # Enable clocks for each module (without DCLK , i2cCLK) */
-
-	{ GPIODATA,     0x02000200 },  /*   # GPI .GPIODATA  # GPIO2(RESET_LCD_N) set to 0 , GPIO3(eDRAM_Power) set to 0 */
-	{ GPIODIR,      0x000030D  },  /* 24D   # GPI .GPIODIR  # Select direction of GPIO port (0,2,3,6,9 output) */
-	{ GPIOSEL,      0/*0x00000173*/},  /*   # SYS.GPIOSEL  # GPIO port multiplexing control */
-	{ GPIOPC,       0x03C300C0 },  /*   # GPI .GPIOPC  # GPIO2,3 PD cut */
-	{ WKREQ,        0x00000000 },  /*   # SYS.WKREQ  # Wake-up request event is VSYNC alignment */
-
-	{ GPIOIBE,      0x000003FF },
-	{ GPIOIS,       0x00000000 },
-	{ GPIOIC,       0x000003FF },
-	{ GPIOIE,       0x00000000 },
-
-	{ GPIODATA,     0x00040004 },  /*   # GPI .GPIODATA  # eDRAM VD supply */
-	{ 1,            1          }, /* msleep 1 */
-	{ GPIODATA,     0x02040004 },  /*   # GPI .GPIODATA  # eDRAM VD supply */
-	{ DRAMPWR,      0x00000001 }, /* eDRAM power */
-};
-
-#define GPIOSEL_VWAKEINT (1U << 0)
-#define INTMASK_VWAKEOUT (1U << 0)
-
-
-static struct clk *gp_clk;
-static int trout_new_backlight = 1;
-static struct vreg *vreg_mddi_1v5;
-static struct vreg *vreg_lcm_2v85;
-
-static void trout_process_mddi_table(struct msm_mddi_client_data *client_data,
-				     struct mddi_table *table, size_t count)
-{
-	int i;
-	for (i = 0; i < count; i++) {
-		uint32_t reg = table[i].reg;
-		uint32_t value = table[i].value;
-
-		if (reg == 0)
-			udelay(value);
-		else if (reg == 1)
-			msleep(value);
-		else
-			client_data->remote_write(client_data, value, reg);
-	}
-}
-
-static int trout_mddi_toshiba_client_init(
-	struct msm_mddi_bridge_platform_data *bridge_data,
-	struct msm_mddi_client_data *client_data)
-{
-	int panel_id;
-
-	client_data->auto_hibernate(client_data, 0);
-	trout_process_mddi_table(client_data, mddi_toshiba_init_table,
-				 ARRAY_SIZE(mddi_toshiba_init_table));
-	client_data->auto_hibernate(client_data, 1);
-	panel_id = (client_data->remote_read(client_data, GPIODATA) >> 4) & 3;
-	if (panel_id > 1) {
-		printk(KERN_WARNING "unknown panel id at mddi_enable\n");
-		return -1;
-	}
-	return 0;
-}
-
-static int trout_mddi_toshiba_client_uninit(
-	struct msm_mddi_bridge_platform_data *bridge_data,
-	struct msm_mddi_client_data *client_data)
-{
-	return 0;
-}
-
-static struct resource resources_msm_fb[] = {
-	{
-		.start = MSM_FB_BASE,
-		.end = MSM_FB_BASE + MSM_FB_SIZE,
-		.flags = IORESOURCE_MEM,
-	},
-};
-
-struct msm_mddi_bridge_platform_data toshiba_client_data = {
-	.init = trout_mddi_toshiba_client_init,
-	.uninit = trout_mddi_toshiba_client_uninit,
-	.fb_data = {
-		.xres = 320,
-		.yres = 480,
-		.width = 45,
-		.height = 67,
-		.output_format = 0,
-	},
-};
-
-static struct msm_mddi_platform_data mddi_pdata = {
-	.clk_rate = 122880000,
-	.fb_resource = resources_msm_fb,
-	.num_clients = 1,
-	.client_platform_data = {
-		{
-			.product_id = (0xd263 << 16 | 0),
-			.name = "mddi_c_d263_0000",
-			.id = 0,
-			.client_data = &toshiba_client_data,
-			.clk_rate = 0,
-		},
-	},
-};
-
-int __init trout_init_panel(void)
-{
-	int rc;
-
-	if (!machine_is_trout())
-		return 0;
-	vreg_mddi_1v5 = vreg_get(0, "gp2");
-	if (IS_ERR(vreg_mddi_1v5))
-		return PTR_ERR(vreg_mddi_1v5);
-	vreg_lcm_2v85 = vreg_get(0, "gp4");
-	if (IS_ERR(vreg_lcm_2v85))
-		return PTR_ERR(vreg_lcm_2v85);
-
-	trout_new_backlight = system_rev >= 5;
-	if (trout_new_backlight) {
-		uint32_t config = PCOM_GPIO_CFG(27, 0, GPIO_OUTPUT,
-						GPIO_NO_PULL, GPIO_8MA);
-		msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX, &config, 0);
-	} else {
-		uint32_t config = PCOM_GPIO_CFG(27, 1, GPIO_OUTPUT,
-						GPIO_NO_PULL, GPIO_8MA);
-		msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX, &config, 0);
-
-		gp_clk = clk_get(NULL, "gp_clk");
-		if (IS_ERR(gp_clk)) {
-			printk(KERN_ERR "trout_init_panel: could not get gp"
-			       "clock\n");
-			gp_clk = NULL;
-		}
-		rc = clk_set_rate(gp_clk, 19200000);
-		if (rc)
-			printk(KERN_ERR "trout_init_panel: set clock rate "
-			       "failed\n");
-	}
-
-	rc = platform_device_register(&msm_device_mdp);
-	if (rc)
-		return rc;
-	msm_device_mddi0.dev.platform_data = &mddi_pdata;
-	return platform_device_register(&msm_device_mddi0);
-}
-
-device_initcall(trout_init_panel);
diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
deleted file mode 100644
index 6b9b227..0000000
--- a/arch/arm/mach-msm/board-trout.c
+++ /dev/null
@@ -1,102 +0,0 @@
-/* linux/arch/arm/mach-msm/board-trout.c
- *
- * Copyright (C) 2009 Google, Inc.
- * Author: Brian Swetland <swetland@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/clkdev.h>
-
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/setup.h>
-
-#include <mach/board.h>
-#include <mach/hardware.h>
-#include <mach/msm_iomap.h>
-
-#include "devices.h"
-#include "board-trout.h"
-
-extern int trout_init_mmc(unsigned int);
-
-static struct platform_device *devices[] __initdata = {
-	&msm_device_uart3,
-	&msm_device_smd,
-	&msm_device_nand,
-	&msm_device_hsusb,
-	&msm_device_i2c,
-};
-
-extern struct sys_timer msm_timer;
-
-static void __init trout_init_irq(void)
-{
-	msm_init_irq();
-}
-
-static void __init trout_fixup(struct tag *tags, char **cmdline,
-			       struct meminfo *mi)
-{
-	mi->nr_banks = 1;
-	mi->bank[0].start = PHYS_OFFSET;
-	mi->bank[0].size = (101*1024*1024);
-}
-
-static void __init trout_init(void)
-{
-	int rc;
-
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-
-#ifdef CONFIG_MMC
-        rc = trout_init_mmc(system_rev);
-        if (rc)
-                printk(KERN_CRIT "%s: MMC init failure (%d)\n", __func__, rc);
-#endif
-
-}
-
-static struct map_desc trout_io_desc[] __initdata = {
-	{
-		.virtual = TROUT_CPLD_BASE,
-		.pfn     = __phys_to_pfn(TROUT_CPLD_START),
-		.length  = TROUT_CPLD_SIZE,
-		.type    = MT_DEVICE_NONSHARED
-	}
-};
-
-static void __init trout_map_io(void)
-{
-	msm_map_common_io();
-	iotable_init(trout_io_desc, ARRAY_SIZE(trout_io_desc));
-
-#ifdef CONFIG_MSM_DEBUG_UART3
-	/* route UART3 to the "H2W" extended usb connector */
-	writeb(0x80, TROUT_CPLD_BASE + 0x00);
-#endif
-
-	msm_clock_init(msm_clocks_7x01a, msm_num_clocks_7x01a);
-}
-
-MACHINE_START(TROUT, "HTC Dream")
-	.atag_offset	= 0x100,
-	.fixup		= trout_fixup,
-	.map_io		= trout_map_io,
-	.init_irq	= trout_init_irq,
-	.init_machine	= trout_init,
-	.timer		= &msm_timer,
-MACHINE_END
diff --git a/arch/arm/mach-msm/board-trout.h b/arch/arm/mach-msm/board-trout.h
deleted file mode 100644
index 651851c..0000000
--- a/arch/arm/mach-msm/board-trout.h
+++ /dev/null
@@ -1,162 +0,0 @@
-/* linux/arch/arm/mach-msm/board-trout.h
-** Author: Brian Swetland <swetland@google.com>
-*/
-#ifndef __ARCH_ARM_MACH_MSM_BOARD_TROUT_H
-#define __ARCH_ARM_MACH_MSM_BOARD_TROUT_H
-
-#include <mach/board.h>
-
-#define MSM_SMI_BASE		0x00000000
-#define MSM_SMI_SIZE		0x00800000
-
-#define MSM_EBI_BASE		0x10000000
-#define MSM_EBI_SIZE		0x06e00000
-
-#define MSM_PMEM_GPU0_BASE	0x00000000
-#define MSM_PMEM_GPU0_SIZE	0x00700000
-
-#define MSM_PMEM_MDP_BASE	0x02000000
-#define MSM_PMEM_MDP_SIZE	0x00800000
-
-#define MSM_PMEM_ADSP_BASE      0x02800000
-#define MSM_PMEM_ADSP_SIZE	0x00800000
-
-#define MSM_PMEM_CAMERA_BASE	0x03000000
-#define MSM_PMEM_CAMERA_SIZE	0x00800000
-
-#define MSM_FB_BASE		0x03800000
-#define MSM_FB_SIZE		0x00100000
-
-#define MSM_LINUX_BASE		MSM_EBI_BASE
-#define MSM_LINUX_SIZE		0x06500000
-
-#define MSM_PMEM_GPU1_SIZE	0x800000
-#define MSM_PMEM_GPU1_BASE	(MSM_RAM_CONSOLE_BASE - MSM_PMEM_GPU1_SIZE)
-
-#define MSM_RAM_CONSOLE_BASE	(MSM_EBI_BASE + 0x6d00000)
-#define MSM_RAM_CONSOLE_SIZE	(128 * SZ_1K)
-
-#if (MSM_FB_BASE + MSM_FB_SIZE) >= (MSM_PMEM_GPU1_BASE)
-#error invalid memory map
-#endif
-
-#define DECLARE_MSM_IOMAP
-#include <mach/msm_iomap.h>
-
-#define TROUT_4_BALL_UP_0     1
-#define TROUT_4_BALL_LEFT_0   18
-#define TROUT_4_BALL_DOWN_0   57
-#define TROUT_4_BALL_RIGHT_0  91
-
-#define TROUT_5_BALL_UP_0     94
-#define TROUT_5_BALL_LEFT_0   18
-#define TROUT_5_BALL_DOWN_0   90
-#define TROUT_5_BALL_RIGHT_0  19
-
-#define TROUT_POWER_KEY     20
-
-#define TROUT_4_TP_LS_EN    19
-#define TROUT_5_TP_LS_EN    1
-
-#define TROUT_CPLD_BASE   0xE8100000
-#define TROUT_CPLD_START  0x98000000
-#define TROUT_CPLD_SIZE   SZ_4K
-
-#define TROUT_GPIO_CABLE_IN1		(83)
-#define TROUT_GPIO_CABLE_IN2		(49)
-
-#define TROUT_GPIO_START (128)
-
-#define TROUT_GPIO_INT_MASK0_REG            (0x0c)
-#define TROUT_GPIO_INT_STAT0_REG            (0x0e)
-#define TROUT_GPIO_INT_MASK1_REG            (0x14)
-#define TROUT_GPIO_INT_STAT1_REG            (0x10)
-
-#define TROUT_GPIO_HAPTIC_PWM               (28)
-#define TROUT_GPIO_PS_HOLD                  (25)
-
-#define TROUT_GPIO_MISC2_BASE               (TROUT_GPIO_START + 0x00)
-#define TROUT_GPIO_MISC3_BASE               (TROUT_GPIO_START + 0x08)
-#define TROUT_GPIO_MISC4_BASE               (TROUT_GPIO_START + 0x10)
-#define TROUT_GPIO_MISC5_BASE               (TROUT_GPIO_START + 0x18)
-#define TROUT_GPIO_INT2_BASE                (TROUT_GPIO_START + 0x20)
-#define TROUT_GPIO_MISC1_BASE               (TROUT_GPIO_START + 0x28)
-#define TROUT_GPIO_VIRTUAL_BASE             (TROUT_GPIO_START + 0x30)
-#define TROUT_GPIO_INT5_BASE                (TROUT_GPIO_START + 0x48)
-
-#define TROUT_GPIO_CHARGER_EN               (TROUT_GPIO_MISC2_BASE + 0)
-#define TROUT_GPIO_ISET                     (TROUT_GPIO_MISC2_BASE + 1)
-#define TROUT_GPIO_H2W_DAT_DIR              (TROUT_GPIO_MISC2_BASE + 2)
-#define TROUT_GPIO_H2W_CLK_DIR              (TROUT_GPIO_MISC2_BASE + 3)
-#define TROUT_GPIO_H2W_DAT_GPO              (TROUT_GPIO_MISC2_BASE + 4)
-#define TROUT_GPIO_H2W_CLK_GPO              (TROUT_GPIO_MISC2_BASE + 5)
-#define TROUT_GPIO_H2W_SEL0                 (TROUT_GPIO_MISC2_BASE + 6)
-#define TROUT_GPIO_H2W_SEL1                 (TROUT_GPIO_MISC2_BASE + 7)
-
-#define TROUT_GPIO_SPOTLIGHT_EN             (TROUT_GPIO_MISC3_BASE + 0)
-#define TROUT_GPIO_FLASH_EN                 (TROUT_GPIO_MISC3_BASE + 1)
-#define TROUT_GPIO_I2C_PULL                 (TROUT_GPIO_MISC3_BASE + 2)
-#define TROUT_GPIO_TP_I2C_PULL              (TROUT_GPIO_MISC3_BASE + 3)
-#define TROUT_GPIO_TP_EN                    (TROUT_GPIO_MISC3_BASE + 4)
-#define TROUT_GPIO_JOG_EN                   (TROUT_GPIO_MISC3_BASE + 5)
-#define TROUT_GPIO_UI_LED_EN                (TROUT_GPIO_MISC3_BASE + 6)
-#define TROUT_GPIO_QTKEY_LED_EN             (TROUT_GPIO_MISC3_BASE + 7)
-
-#define TROUT_GPIO_VCM_PWDN                 (TROUT_GPIO_MISC4_BASE + 0)
-#define TROUT_GPIO_USB_H2W_SW               (TROUT_GPIO_MISC4_BASE + 1)
-#define TROUT_GPIO_COMPASS_RST_N            (TROUT_GPIO_MISC4_BASE + 2)
-#define TROUT_GPIO_HAPTIC_EN_UP             (TROUT_GPIO_MISC4_BASE + 3)
-#define TROUT_GPIO_HAPTIC_EN_MAIN           (TROUT_GPIO_MISC4_BASE + 4)
-#define TROUT_GPIO_USB_PHY_RST_N            (TROUT_GPIO_MISC4_BASE + 5)
-#define TROUT_GPIO_WIFI_PA_RESETX           (TROUT_GPIO_MISC4_BASE + 6)
-#define TROUT_GPIO_WIFI_EN                  (TROUT_GPIO_MISC4_BASE + 7)
-
-#define TROUT_GPIO_BT_32K_EN                (TROUT_GPIO_MISC5_BASE + 0)
-#define TROUT_GPIO_MAC_32K_EN               (TROUT_GPIO_MISC5_BASE + 1)
-#define TROUT_GPIO_MDDI_32K_EN              (TROUT_GPIO_MISC5_BASE + 2)
-#define TROUT_GPIO_COMPASS_32K_EN           (TROUT_GPIO_MISC5_BASE + 3)
-
-#define TROUT_GPIO_NAVI_ACT_N               (TROUT_GPIO_INT2_BASE + 0)
-#define TROUT_GPIO_COMPASS_IRQ              (TROUT_GPIO_INT2_BASE + 1)
-#define TROUT_GPIO_SLIDING_DET              (TROUT_GPIO_INT2_BASE + 2)
-#define TROUT_GPIO_AUD_HSMIC_DET_N          (TROUT_GPIO_INT2_BASE + 3)
-#define TROUT_GPIO_SD_DOOR_N                (TROUT_GPIO_INT2_BASE + 4)
-#define TROUT_GPIO_CAM_BTN_STEP1_N          (TROUT_GPIO_INT2_BASE + 5)
-#define TROUT_GPIO_CAM_BTN_STEP2_N          (TROUT_GPIO_INT2_BASE + 6)
-#define TROUT_GPIO_TP_ATT_N                 (TROUT_GPIO_INT2_BASE + 7)
-#define TROUT_GPIO_BANK0_FIRST_INT_SOURCE   (TROUT_GPIO_NAVI_ACT_N)
-#define TROUT_GPIO_BANK0_LAST_INT_SOURCE    (TROUT_GPIO_TP_ATT_N)
-
-#define TROUT_GPIO_H2W_DAT_GPI              (TROUT_GPIO_MISC1_BASE + 0)
-#define TROUT_GPIO_H2W_CLK_GPI              (TROUT_GPIO_MISC1_BASE + 1)
-#define TROUT_GPIO_CPLD128_VER_0            (TROUT_GPIO_MISC1_BASE + 4)
-#define TROUT_GPIO_CPLD128_VER_1            (TROUT_GPIO_MISC1_BASE + 5)
-#define TROUT_GPIO_CPLD128_VER_2            (TROUT_GPIO_MISC1_BASE + 6)
-#define TROUT_GPIO_CPLD128_VER_3            (TROUT_GPIO_MISC1_BASE + 7)
-
-#define TROUT_GPIO_SDMC_CD_N                (TROUT_GPIO_VIRTUAL_BASE + 0)
-#define TROUT_GPIO_END                      (TROUT_GPIO_SDMC_CD_N)
-#define TROUT_GPIO_BANK1_FIRST_INT_SOURCE   (TROUT_GPIO_SDMC_CD_N)
-#define TROUT_GPIO_BANK1_LAST_INT_SOURCE    (TROUT_GPIO_SDMC_CD_N)
-
-#define TROUT_GPIO_VIRTUAL_TO_REAL_OFFSET \
-	(TROUT_GPIO_INT5_BASE - TROUT_GPIO_VIRTUAL_BASE)
-
-#define TROUT_INT_START (NR_MSM_IRQS + NR_GPIO_IRQS)
-#define TROUT_INT_BANK0_COUNT (8)
-#define TROUT_INT_BANK1_START (TROUT_INT_START + TROUT_INT_BANK0_COUNT)
-#define TROUT_INT_BANK1_COUNT (1)
-#define TROUT_INT_END (TROUT_INT_START + TROUT_INT_BANK0_COUNT + \
-			TROUT_INT_BANK1_COUNT - 1)
-#define TROUT_GPIO_TO_INT(n) (((n) <= TROUT_GPIO_BANK0_LAST_INT_SOURCE) ? \
-	(TROUT_INT_START - TROUT_GPIO_BANK0_FIRST_INT_SOURCE + (n)) : \
-	(TROUT_INT_BANK1_START - TROUT_GPIO_BANK1_FIRST_INT_SOURCE + (n)))
-
-#define TROUT_INT_TO_BANK(n) ((n - TROUT_INT_START) / TROUT_INT_BANK0_COUNT)
-#define TROUT_INT_TO_MASK(n) (1U << ((n - TROUT_INT_START) & 7))
-#define TROUT_BANK_TO_MASK_REG(bank) \
-	(bank ? TROUT_GPIO_INT_MASK1_REG : TROUT_GPIO_INT_MASK0_REG)
-#define TROUT_BANK_TO_STAT_REG(bank) \
-	(bank ? TROUT_GPIO_INT_STAT1_REG : TROUT_GPIO_INT_STAT0_REG)
-
-#endif /* GUARD */
diff --git a/arch/arm/mach-msm/idle.S b/arch/arm/mach-msm/idle.S
index 6a94f05..d8e8027 100644
--- a/arch/arm/mach-msm/idle.S
+++ b/arch/arm/mach-msm/idle.S
@@ -20,17 +20,4 @@
 #include <asm/assembler.h>
 
 ENTRY(arch_idle)
-#ifdef CONFIG_MSM7X00A_IDLE
-	mrc     p15, 0, r1, c1, c0, 0    /* read current CR    */
-	bic     r0, r1, #(1 << 2)        /* clear dcache bit   */
-	bic     r0, r0, #(1 << 12)       /* clear icache bit   */
-	mcr     p15, 0, r0, c1, c0, 0    /* disable d/i cache  */
-
-	mov     r0, #0                   /* prepare wfi value  */
-	mcr     p15, 0, r0, c7, c10, 0   /* flush the cache    */
-	mcr     p15, 0, r0, c7, c10, 4   /* memory barrier     */
-	mcr     p15, 0, r0, c7, c0, 4    /* wait for interrupt */
-
-	mcr     p15, 0, r1, c1, c0, 0    /* restore d/i cache  */
-#endif
 	mov     pc, lr
diff --git a/arch/arm/mach-msm/include/mach/irqs-7x00.h b/arch/arm/mach-msm/include/mach/irqs-7x00.h
deleted file mode 100644
index f1fe706..0000000
--- a/arch/arm/mach-msm/include/mach/irqs-7x00.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2009, Code Aurora Forum. All rights reserved.
- * Author: Brian Swetland <swetland@google.com>
- */
-
-#ifndef __ASM_ARCH_MSM_IRQS_7X00_H
-#define __ASM_ARCH_MSM_IRQS_7X00_H
-
-/* MSM ARM11 Interrupt Numbers */
-/* See 80-VE113-1 A, pp219-221     */
-
-#define INT_A9_M2A_0         0
-#define INT_A9_M2A_1         1
-#define INT_A9_M2A_2         2
-#define INT_A9_M2A_3         3
-#define INT_A9_M2A_4         4
-#define INT_A9_M2A_5         5
-#define INT_A9_M2A_6         6
-#define INT_GP_TIMER_EXP     7
-#define INT_DEBUG_TIMER_EXP  8
-#define INT_UART1            9
-#define INT_UART2            10
-#define INT_UART3            11
-#define INT_UART1_RX         12
-#define INT_UART2_RX         13
-#define INT_UART3_RX         14
-#define INT_USB_OTG          15
-#define INT_MDDI_PRI         16
-#define INT_MDDI_EXT         17
-#define INT_MDDI_CLIENT      18
-#define INT_MDP              19
-#define INT_GRAPHICS         20
-#define INT_ADM_AARM         21
-#define INT_ADSP_A11         22
-#define INT_ADSP_A9_A11      23
-#define INT_SDC1_0           24
-#define INT_SDC1_1           25
-#define INT_SDC2_0           26
-#define INT_SDC2_1           27
-#define INT_KEYSENSE         28
-#define INT_TCHSCRN_SSBI     29
-#define INT_TCHSCRN1         30
-#define INT_TCHSCRN2         31
-
-#define INT_GPIO_GROUP1      (32 + 0)
-#define INT_GPIO_GROUP2      (32 + 1)
-#define INT_PWB_I2C          (32 + 2)
-#define INT_SOFTRESET        (32 + 3)
-#define INT_NAND_WR_ER_DONE  (32 + 4)
-#define INT_NAND_OP_DONE     (32 + 5)
-#define INT_PBUS_ARM11       (32 + 6)
-#define INT_AXI_MPU_SMI      (32 + 7)
-#define INT_AXI_MPU_EBI1     (32 + 8)
-#define INT_AD_HSSD          (32 + 9)
-#define INT_ARM11_PMU        (32 + 10)
-#define INT_ARM11_DMA        (32 + 11)
-#define INT_TSIF_IRQ         (32 + 12)
-#define INT_UART1DM_IRQ      (32 + 13)
-#define INT_UART1DM_RX       (32 + 14)
-#define INT_USB_HS           (32 + 15)
-#define INT_SDC3_0           (32 + 16)
-#define INT_SDC3_1           (32 + 17)
-#define INT_SDC4_0           (32 + 18)
-#define INT_SDC4_1           (32 + 19)
-#define INT_UART2DM_RX       (32 + 20)
-#define INT_UART2DM_IRQ      (32 + 21)
-
-/* 22-31 are reserved */
-
-#define NR_MSM_IRQS 64
-#define NR_GPIO_IRQS 122
-#define NR_BOARD_IRQS 64
-
-#endif
diff --git a/arch/arm/mach-msm/include/mach/irqs.h b/arch/arm/mach-msm/include/mach/irqs.h
index 3cd78b1..4bfd614 100644
--- a/arch/arm/mach-msm/include/mach/irqs.h
+++ b/arch/arm/mach-msm/include/mach/irqs.h
@@ -29,8 +29,6 @@
 #elif defined(CONFIG_ARCH_MSM8960)
 /* TODO: Make these not generic. */
 #include "irqs-8960.h"
-#elif defined(CONFIG_ARCH_MSM_ARM11)
-#include "irqs-7x00.h"
 #else
 #error "Unknown architecture specification"
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
deleted file mode 100644
index 94fe9fe..0000000
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
+++ /dev/null
@@ -1,127 +0,0 @@
-/* arch/arm/mach-msm/include/mach/msm_iomap.h
- *
- * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
- * Author: Brian Swetland <swetland@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- *
- * The MSM peripherals are spread all over across 768MB of physical
- * space, which makes just having a simple IO_ADDRESS macro to slide
- * them into the right virtual location rough.  Instead, we will
- * provide a master phys->virt mapping for peripherals here.
- *
- */
-
-#ifndef __ASM_ARCH_MSM_IOMAP_7X00_H
-#define __ASM_ARCH_MSM_IOMAP_7X00_H
-
-#include <asm/sizes.h>
-
-/* Physical base address and size of peripherals.
- * Ordered by the virtual base addresses they will be mapped at.
- *
- * MSM_VIC_BASE must be an value that can be loaded via a "mov"
- * instruction, otherwise entry-macro.S will not compile.
- *
- * If you add or remove entries here, you'll want to edit the
- * msm_io_desc array in arch/arm/mach-msm/io.c to reflect your
- * changes.
- *
- */
-
-#ifdef __ASSEMBLY__
-#define IOMEM(x)	x
-#else
-#define IOMEM(x)	((void __force __iomem *)(x))
-#endif
-
-#define MSM_VIC_BASE          IOMEM(0xE0000000)
-#define MSM_VIC_PHYS          0xC0000000
-#define MSM_VIC_SIZE          SZ_4K
-
-#define MSM7X00_CSR_PHYS      0xC0100000
-#define MSM7X00_CSR_SIZE      SZ_4K
-
-#define MSM_DMOV_BASE         IOMEM(0xE0002000)
-#define MSM_DMOV_PHYS         0xA9700000
-#define MSM_DMOV_SIZE         SZ_4K
-
-#define MSM7X00_GPIO1_PHYS        0xA9200000
-#define MSM7X00_GPIO1_SIZE        SZ_4K
-
-#define MSM7X00_GPIO2_PHYS        0xA9300000
-#define MSM7X00_GPIO2_SIZE        SZ_4K
-
-#define MSM_CLK_CTL_BASE      IOMEM(0xE0005000)
-#define MSM_CLK_CTL_PHYS      0xA8600000
-#define MSM_CLK_CTL_SIZE      SZ_4K
-
-#define MSM_SHARED_RAM_BASE   IOMEM(0xE0100000)
-#define MSM_SHARED_RAM_PHYS   0x01F00000
-#define MSM_SHARED_RAM_SIZE   SZ_1M
-
-#define MSM_UART1_PHYS        0xA9A00000
-#define MSM_UART1_SIZE        SZ_4K
-
-#define MSM_UART2_PHYS        0xA9B00000
-#define MSM_UART2_SIZE        SZ_4K
-
-#define MSM_UART3_PHYS        0xA9C00000
-#define MSM_UART3_SIZE        SZ_4K
-
-#ifdef CONFIG_MSM_DEBUG_UART
-#define MSM_DEBUG_UART_BASE   0xE1000000
-#if CONFIG_MSM_DEBUG_UART == 1
-#define MSM_DEBUG_UART_PHYS   MSM_UART1_PHYS
-#elif CONFIG_MSM_DEBUG_UART == 2
-#define MSM_DEBUG_UART_PHYS   MSM_UART2_PHYS
-#elif CONFIG_MSM_DEBUG_UART == 3
-#define MSM_DEBUG_UART_PHYS   MSM_UART3_PHYS
-#endif
-#define MSM_DEBUG_UART_SIZE   SZ_4K
-#endif
-
-#define MSM_SDC1_PHYS         0xA0400000
-#define MSM_SDC1_SIZE         SZ_4K
-
-#define MSM_SDC2_PHYS         0xA0500000
-#define MSM_SDC2_SIZE         SZ_4K
-
-#define MSM_SDC3_PHYS         0xA0600000
-#define MSM_SDC3_SIZE         SZ_4K
-
-#define MSM_SDC4_PHYS         0xA0700000
-#define MSM_SDC4_SIZE         SZ_4K
-
-#define MSM_I2C_PHYS          0xA9900000
-#define MSM_I2C_SIZE          SZ_4K
-
-#define MSM_HSUSB_PHYS        0xA0800000
-#define MSM_HSUSB_SIZE        SZ_4K
-
-#define MSM_PMDH_PHYS         0xAA600000
-#define MSM_PMDH_SIZE         SZ_4K
-
-#define MSM_EMDH_PHYS         0xAA700000
-#define MSM_EMDH_SIZE         SZ_4K
-
-#define MSM_MDP_PHYS          0xAA200000
-#define MSM_MDP_SIZE          0x000F0000
-
-#define MSM_MDC_PHYS	      0xAA500000
-#define MSM_MDC_SIZE	      SZ_1M
-
-#define MSM_AD5_PHYS          0xAC000000
-#define MSM_AD5_SIZE          (SZ_1M*13)
-
-
-#endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 4ded152..f4027a6 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -49,8 +49,6 @@
 #include "msm_iomap-8x50.h"
 #elif defined(CONFIG_ARCH_MSM8X60)
 #include "msm_iomap-8x60.h"
-#else
-#include "msm_iomap-7x00.h"
 #endif
 
 #include "msm_iomap-8960.h"
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 8759ecf..45561d0 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -38,40 +38,6 @@
 
 #define MSM_DEVICE(name) MSM_CHIP_DEVICE(name, MSM)
 
-#if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X27) \
-	|| defined(CONFIG_ARCH_MSM7X25)
-static struct map_desc msm_io_desc[] __initdata = {
-	MSM_DEVICE(VIC),
-	MSM_CHIP_DEVICE(CSR, MSM7X00),
-	MSM_DEVICE(DMOV),
-	MSM_CHIP_DEVICE(GPIO1, MSM7X00),
-	MSM_CHIP_DEVICE(GPIO2, MSM7X00),
-	MSM_DEVICE(CLK_CTL),
-#ifdef CONFIG_MSM_DEBUG_UART
-	MSM_DEVICE(DEBUG_UART),
-#endif
-#ifdef CONFIG_ARCH_MSM7X30
-	MSM_DEVICE(GCC),
-#endif
-	{
-		.virtual =  (unsigned long) MSM_SHARED_RAM_BASE,
-		.pfn = __phys_to_pfn(MSM_SHARED_RAM_PHYS),
-		.length =   MSM_SHARED_RAM_SIZE,
-		.type =     MT_DEVICE,
-	},
-};
-
-void __init msm_map_common_io(void)
-{
-	/* Make sure the peripheral register window is closed, since
-	 * we will use PTE flags (TEX[1]=1,B=0,C=1) to determine which
-	 * pages are peripheral interface or not.
-	 */
-	asm("mcr p15, 0, %0, c15, c2, 4" : : "r" (0));
-	iotable_init(msm_io_desc, ARRAY_SIZE(msm_io_desc));
-}
-#endif
-
 #ifdef CONFIG_ARCH_QSD8X50
 static struct map_desc qsd8x50_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
diff --git a/arch/arm/mach-msm/irq.c b/arch/arm/mach-msm/irq.c
deleted file mode 100644
index ea514be..0000000
--- a/arch/arm/mach-msm/irq.c
+++ /dev/null
@@ -1,151 +0,0 @@
-/* linux/arch/arm/mach-msm/irq.c
- *
- * Copyright (C) 2007 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/ptrace.h>
-#include <linux/timer.h>
-#include <linux/irq.h>
-#include <linux/io.h>
-
-#include <mach/hardware.h>
-
-#include <mach/msm_iomap.h>
-
-#define VIC_REG(off) (MSM_VIC_BASE + (off))
-
-#define VIC_INT_SELECT0     VIC_REG(0x0000)  /* 1: FIQ, 0: IRQ */
-#define VIC_INT_SELECT1     VIC_REG(0x0004)  /* 1: FIQ, 0: IRQ */
-#define VIC_INT_EN0         VIC_REG(0x0010)
-#define VIC_INT_EN1         VIC_REG(0x0014)
-#define VIC_INT_ENCLEAR0    VIC_REG(0x0020)
-#define VIC_INT_ENCLEAR1    VIC_REG(0x0024)
-#define VIC_INT_ENSET0      VIC_REG(0x0030)
-#define VIC_INT_ENSET1      VIC_REG(0x0034)
-#define VIC_INT_TYPE0       VIC_REG(0x0040)  /* 1: EDGE, 0: LEVEL  */
-#define VIC_INT_TYPE1       VIC_REG(0x0044)  /* 1: EDGE, 0: LEVEL  */
-#define VIC_INT_POLARITY0   VIC_REG(0x0050)  /* 1: NEG, 0: POS */
-#define VIC_INT_POLARITY1   VIC_REG(0x0054)  /* 1: NEG, 0: POS */
-#define VIC_NO_PEND_VAL     VIC_REG(0x0060)
-#define VIC_INT_MASTEREN    VIC_REG(0x0064)  /* 1: IRQ, 2: FIQ     */
-#define VIC_PROTECTION      VIC_REG(0x006C)  /* 1: ENABLE          */
-#define VIC_CONFIG          VIC_REG(0x0068)  /* 1: USE ARM1136 VIC */
-#define VIC_IRQ_STATUS0     VIC_REG(0x0080)
-#define VIC_IRQ_STATUS1     VIC_REG(0x0084)
-#define VIC_FIQ_STATUS0     VIC_REG(0x0090)
-#define VIC_FIQ_STATUS1     VIC_REG(0x0094)
-#define VIC_RAW_STATUS0     VIC_REG(0x00A0)
-#define VIC_RAW_STATUS1     VIC_REG(0x00A4)
-#define VIC_INT_CLEAR0      VIC_REG(0x00B0)
-#define VIC_INT_CLEAR1      VIC_REG(0x00B4)
-#define VIC_SOFTINT0        VIC_REG(0x00C0)
-#define VIC_SOFTINT1        VIC_REG(0x00C4)
-#define VIC_IRQ_VEC_RD      VIC_REG(0x00D0)  /* pending int # */
-#define VIC_IRQ_VEC_PEND_RD VIC_REG(0x00D4)  /* pending vector addr */
-#define VIC_IRQ_VEC_WR      VIC_REG(0x00D8)
-#define VIC_IRQ_IN_SERVICE  VIC_REG(0x00E0)
-#define VIC_IRQ_IN_STACK    VIC_REG(0x00E4)
-#define VIC_TEST_BUS_SEL    VIC_REG(0x00E8)
-
-#define VIC_VECTPRIORITY(n) VIC_REG(0x0200+((n) * 4))
-#define VIC_VECTADDR(n)     VIC_REG(0x0400+((n) * 4))
-
-static void msm_irq_ack(struct irq_data *d)
-{
-	void __iomem *reg = VIC_INT_CLEAR0 + ((d->irq & 32) ? 4 : 0);
-	writel(1 << (d->irq & 31), reg);
-}
-
-static void msm_irq_mask(struct irq_data *d)
-{
-	void __iomem *reg = VIC_INT_ENCLEAR0 + ((d->irq & 32) ? 4 : 0);
-	writel(1 << (d->irq & 31), reg);
-}
-
-static void msm_irq_unmask(struct irq_data *d)
-{
-	void __iomem *reg = VIC_INT_ENSET0 + ((d->irq & 32) ? 4 : 0);
-	writel(1 << (d->irq & 31), reg);
-}
-
-static int msm_irq_set_wake(struct irq_data *d, unsigned int on)
-{
-	return -EINVAL;
-}
-
-static int msm_irq_set_type(struct irq_data *d, unsigned int flow_type)
-{
-	void __iomem *treg = VIC_INT_TYPE0 + ((d->irq & 32) ? 4 : 0);
-	void __iomem *preg = VIC_INT_POLARITY0 + ((d->irq & 32) ? 4 : 0);
-	int b = 1 << (d->irq & 31);
-
-	if (flow_type & (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_LOW))
-		writel(readl(preg) | b, preg);
-	if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_HIGH))
-		writel(readl(preg) & (~b), preg);
-
-	if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) {
-		writel(readl(treg) | b, treg);
-		__irq_set_handler_locked(d->irq, handle_edge_irq);
-	}
-	if (flow_type & (IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW)) {
-		writel(readl(treg) & (~b), treg);
-		__irq_set_handler_locked(d->irq, handle_level_irq);
-	}
-	return 0;
-}
-
-static struct irq_chip msm_irq_chip = {
-	.name          = "msm",
-	.irq_ack       = msm_irq_ack,
-	.irq_mask      = msm_irq_mask,
-	.irq_unmask    = msm_irq_unmask,
-	.irq_set_wake  = msm_irq_set_wake,
-	.irq_set_type  = msm_irq_set_type,
-};
-
-void __init msm_init_irq(void)
-{
-	unsigned n;
-
-	/* select level interrupts */
-	writel(0, VIC_INT_TYPE0);
-	writel(0, VIC_INT_TYPE1);
-
-	/* select highlevel interrupts */
-	writel(0, VIC_INT_POLARITY0);
-	writel(0, VIC_INT_POLARITY1);
-
-	/* select IRQ for all INTs */
-	writel(0, VIC_INT_SELECT0);
-	writel(0, VIC_INT_SELECT1);
-
-	/* disable all INTs */
-	writel(0, VIC_INT_EN0);
-	writel(0, VIC_INT_EN1);
-
-	/* don't use 1136 vic */
-	writel(0, VIC_CONFIG);
-
-	/* enable interrupt controller */
-	writel(1, VIC_INT_MASTEREN);
-
-	for (n = 0; n < NR_MSM_IRQS; n++) {
-		irq_set_chip_and_handler(n, &msm_irq_chip, handle_level_irq);
-		set_irq_flags(n, IRQF_VALID);
-	}
-}
diff --git a/arch/arm/mach-msm/smd_private.h b/arch/arm/mach-msm/smd_private.h
index 727bfe6..e66d9fa 100644
--- a/arch/arm/mach-msm/smd_private.h
+++ b/arch/arm/mach-msm/smd_private.h
@@ -64,13 +64,6 @@ struct smem_shared {
 #define SMSM_V1_SIZE		(sizeof(unsigned) * 8)
 #define SMSM_V2_SIZE		(sizeof(unsigned) * 4)
 
-#ifdef CONFIG_MSM_SMD_PKG3
-struct smsm_interrupt_info {
-	uint32_t interrupt_mask;
-	uint32_t pending_interrupts;
-	uint32_t wakeup_reason;
-};
-#else
 #define DEM_MAX_PORT_NAME_LEN (20)
 struct msm_dem_slave_data {
 	uint32_t sleep_time;
@@ -85,7 +78,6 @@ struct msm_dem_slave_data {
 	char     smd_port_name[DEM_MAX_PORT_NAME_LEN];
 	uint32_t reserved2;
 };
-#endif
 
 #define SZ_DIAG_ERR_MSG 0xC8
 #define ID_DIAG_ERR_MSG SMEM_DIAG_ERR_MESSAGE
@@ -126,13 +118,6 @@ struct msm_dem_slave_data {
 #define SMSM_WKUP_REASON_ALARM	0x00000010
 #define SMSM_WKUP_REASON_RESET	0x00000020
 
-#ifdef CONFIG_ARCH_MSM7X00A
-enum smsm_state_item {
-	SMSM_STATE_APPS = 1,
-	SMSM_STATE_MODEM = 3,
-	SMSM_STATE_COUNT,
-};
-#else
 enum smsm_state_item {
 	SMSM_STATE_APPS,
 	SMSM_STATE_MODEM,
@@ -144,7 +129,6 @@ enum smsm_state_item {
 	SMSM_STATE_TIME_MASTER_DEM,
 	SMSM_STATE_COUNT,
 };
-#endif
 
 void *smem_alloc(unsigned id, unsigned size);
 int smsm_change_state(enum smsm_state_item item, uint32_t clear_mask, uint32_t set_mask);
@@ -335,28 +319,6 @@ uint32_t raw_smsm_get_state(enum smsm_state_item item);
 
 extern void msm_init_last_radio_log(struct module *);
 
-#ifdef CONFIG_MSM_SMD_PKG3
-/*
- * This allocator assumes an SMD Package v3 which only exists on
- * MSM7x00 SoC's.
- */
-static inline int _smd_alloc_channel(struct smd_channel *ch)
-{
-	struct smd_shared_v1 *shared1;
-
-	shared1 = smem_alloc(ID_SMD_CHANNELS + ch->n, sizeof(*shared1));
-	if (!shared1) {
-		pr_err("smd_alloc_channel() cid %d does not exist\n", ch->n);
-		return -1;
-	}
-	ch->send = &shared1->ch0;
-	ch->recv = &shared1->ch1;
-	ch->send_data = shared1->data0;
-	ch->recv_data = shared1->data1;
-	ch->fifo_size = SMD_BUF_SIZE;
-	return 0;
-}
-#else
 /*
  * This allocator assumes an SMD Package v4, the most common
  * and the default.
@@ -385,7 +347,6 @@ static inline int _smd_alloc_channel(struct smd_channel *ch)
 	ch->fifo_size = buffer_sz;
 	return 0;
 }
-#endif /* CONFIG_MSM_SMD_PKG3 */
 
 #if defined(CONFIG_ARCH_MSM7X30)
 static inline void msm_a2m_int(uint32_t irq)
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index afeeca5..04770f3 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -203,10 +203,7 @@ static void __init msm_timer_init(void)
 	int res;
 	int global_offset = 0;
 
-	if (cpu_is_msm7x01()) {
-		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
-		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
-	} else if (cpu_is_msm7x30()) {
+	if (cpu_is_msm7x30()) {
 		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE + 0x04;
 		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x24;
 	} else if (cpu_is_qsd8x50()) {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

