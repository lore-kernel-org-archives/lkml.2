Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2B1Ghd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 01:37:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25496 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2B1Gh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 01:37:26 -0500
X-AuditID: cbfee61b-b7c62ae000000989-e8-4f4c76242adc
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
Reply-to: pullip.cho@samsung.com
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>
Subject: [PATCH v9 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
Date: Tue, 28 Feb 2012 15:37:34 +0900
Organization: Samsung Electronics Co., Ltd
Message-id: <001a01ccf5e3$74a0d360$5de27a20$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczxzIZWl05Y2BnpTRu+x9QsD8bqkwEFRixg
x-cr-hashedpuzzle: CzqG TZvV WBpw Xs9h X4FO YJ3D arq0 hG8E hvOJ 8AMx /3Hn
 AAorYQ== AC6LNA== AEvHWw== AKs+Lg==
 AL2xmg==;11;aQBvAG0AbQB1AEAAbABpAHMAdABzAC4AbABpAG4AdQB4AC0AZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAagBvAHIAbwBAADgAYgB5AHQAZQBzAC4AbwByAGcAOwBrAGcAZQBuAGUALgBrAGkAbQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGsAeQB1AG4AZwBtAGkAbgAuAHAAYQByAGsAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBhAHIAbQAtAGsAZQByAG4AZQBsAEAAbABpAHMAdABzAC4AaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBzAGEAbQBzAHUAbgBnAC0AcwBvAGMAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0ALgBzAHoAeQBwAHIAbwB3AHMAawBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAcwBhAG4AZwBoAHkAdQBuADcANQAuAGwAZQBlAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAcwB1AGIAYQBzAGgALgByAGEAbQBhAHMAdwBhAG0AeQBAAGwAaQBuAGEAcgBvAC4AbwByAGcAOwB5AG8AdQBuAGcAbABhAGsAMQAwADAANAAuAGsAaQBtAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Sosha1_v1;7;{A7DCA01D-7357-496D-8A82-82B25CF0E1C3};cAB1AGwAbABpAHAALgBjAGgAbwBAA	HMAY
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

QBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
 28 Feb 2012 06:37:18 GMT;WwBQAEEAVABDAEgAIAB2ADkAIAAyAC8AMgBdACAAaQBvAG0AbQB1AC8AZQB4AHkAbgBvAHMAOgAgAEEAZABkACAAaQBvAG0AbQB1ACAAZAByAGkAdgBlAHIAIABmAG8AcgAgAEUAeAB5AG4AbwBzACAAUABsAGEAdABmAG8AcgBtAHMA
x-cr-puzzleid: {A7DCA01D-7357-496D-8A82-82B25CF0E1C3}

This is the System MMU driver and IOMMU API implementation for
Exynos SOC platforms. Exynos platforms has more than 10 System
MMUs dedicated for each multimedia accelerators.

The System MMU driver is already in arc/arm/plat-s5p but it is
moved to drivers/iommu due to Ohad Ben-Cohen gathered IOMMU drivers
there

Any device driver in Exynos platforms that needs to control its
System MMU must call platform_set_sysmmu() to inform System MMU
driver who will control it.
platform_set_sysmmu() is defined in <mach/sysmmu.h>

Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/plat-s5p/Kconfig                   |    8 -
 arch/arm/plat-s5p/Makefile                  |    1 -
 arch/arm/plat-s5p/sysmmu.c                  |  324 --------
 arch/arm/plat-samsung/include/plat/sysmmu.h |   95 ---
 drivers/iommu/Kconfig                       |   21 +
 drivers/iommu/Makefile                      |    1 +
 drivers/iommu/exynos-iommu.c                | 1076 +++++++++++++++++++++++++++
 7 files changed, 1098 insertions(+), 428 deletions(-)
 delete mode 100644 arch/arm/plat-s5p/sysmmu.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/sysmmu.h
 create mode 100644 drivers/iommu/exynos-iommu.c

diff --git a/arch/arm/plat-s5p/Kconfig b/arch/arm/plat-s5p/Kconfig
index 88795ea..f905905 100644
--- a/arch/arm/plat-s5p/Kconfig
+++ b/arch/arm/plat-s5p/Kconfig
@@ -50,14 +50,6 @@ config S5P_PM
 	  Common code for power management support on S5P and newer SoCs
 	  Note: Do not select this for S5P6440 and S5P6450.
 
-comment "System MMU"
-
-config S5P_SYSTEM_MMU
-	bool "S5P SYSTEM MMU"
-	depends on ARCH_EXYNOS4
-	help
-	  Say Y here if you want to enable System MMU
-
 config S5P_SLEEP
 	bool
 	help
diff --git a/arch/arm/plat-s5p/Makefile b/arch/arm/plat-s5p/Makefile
index 4bd8241..4953d50 100644
--- a/arch/arm/plat-s5p/Makefile
+++ b/arch/arm/plat-s5p/Makefile
@@ -16,7 +16,6 @@ obj-y				+= clock.o
 obj-y				+= irq.o
 obj-$(CONFIG_S5P_EXT_INT)	+= irq-eint.o
 obj-$(CONFIG_S5P_GPIO_INT)	+= irq-gpioint.o
-obj-$(CONFIG_S5P_SYSTEM_MMU)	+= sysmmu.o
 obj-$(CONFIG_S5P_PM)		+= pm.o irq-pm.o
 obj-$(CONFIG_S5P_SLEEP)		+= sleep.o
 obj-$(CONFIG_S5P_HRT) 		+= s5p-time.o
diff --git a/arch/arm/plat-s5p/sysmmu.c b/arch/arm/plat-s5p/sysmmu.c
deleted file mode 100644
index 98b87c1..0000000
--- a/arch/arm/plat-s5p/sysmmu.c
+++ /dev/null
@@ -1,324 +0,0 @@
-/* linux/arch/arm/plat-s5p/sysmmu.c
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/export.h>
-
-#include <asm/pgtable.h>
-
-#include <mach/map.h>
-#include <plat/sysmmu.h>
-
-#define CTRL_ENABLE	0x5
-#define CTRL_BLOCK	0x7
-#define CTRL_DISABLE	0x0
-
-static struct device *dev;
-
-#define EXYNOS_MMU_CTRL			0x000
-#define EXYNOS_MMU_CFG			0x004
-#define EXYNOS_MMU_STATUS		0x008
-#define EXYNOS_MMU_FLUSH		0x00C
-#define EXYNOS_PT_BASE_ADDR		0x014
-#define EXYNOS_INT_STATUS		0x018
-#define EXYNOS_INT_CLEAR		0x01C
-#define EXYNOS_PAGE_FAULT_ADDR		0x024
-#define EXYNOS_AW_FAULT_ADDR		0x028
-#define EXYNOS_AR_FAULT_ADDR		0x02C
-#define EXYNOS_DEFAULT_SLAVE_ADDR	0x030
-
-static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
-	S5P_PAGE_FAULT_ADDR,
-	S5P_AR_FAULT_ADDR,
-	S5P_AW_FAULT_ADDR,
-	S5P_DEFAULT_SLAVE_ADDR,
-	S5P_AR_FAULT_ADDR,
-	S5P_AR_FAULT_ADDR,
-	S5P_AW_FAULT_ADDR,
-	S5P_AW_FAULT_ADDR
-};
-
-static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
-	"PAGE FAULT",
-	"AR MULTI-HIT FAULT",
-	"AW MULTI-HIT FAULT",
-	"BUS ERROR",
-	"AR SECURITY PROTECTION FAULT",
-	"AR ACCESS PROTECTION FAULT",
-	"AW SECURITY PROTECTION FAULT",
-	"AW ACCESS PROTECTION FAULT"
-};
-
-static int (*fault_handlers[S5P_SYSMMU_TOTAL_IPNUM])(
-		enum S5P_SYSMMU_INTERRUPT_TYPE itype,
-		unsigned long pgtable_base,
-		unsigned long fault_addr);
-
-/*
- * If adjacent 2 bits are true, the system MMU is enabled.
- * The system MMU is disabled, otherwise.
- */
-static unsigned long sysmmu_states;
-
-static inline void set_sysmmu_active(sysmmu_ips ips)
-{
-	sysmmu_states |= 3 << (ips * 2);
-}
-
-static inline void set_sysmmu_inactive(sysmmu_ips ips)
-{
-	sysmmu_states &= ~(3 << (ips * 2));
-}
-
-static inline int is_sysmmu_active(sysmmu_ips ips)
-{
-	return sysmmu_states & (3 << (ips * 2));
-}
-
-static void __iomem *sysmmusfrs[S5P_SYSMMU_TOTAL_IPNUM];
-
-static inline void sysmmu_block(sysmmu_ips ips)
-{
-	__raw_writel(CTRL_BLOCK, sysmmusfrs[ips] + S5P_MMU_CTRL);
-	dev_dbg(dev, "%s is blocked.\n", sysmmu_ips_name[ips]);
-}
-
-static inline void sysmmu_unblock(sysmmu_ips ips)
-{
-	__raw_writel(CTRL_ENABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
-	dev_dbg(dev, "%s is unblocked.\n", sysmmu_ips_name[ips]);
-}
-
-static inline void __sysmmu_tlb_invalidate(sysmmu_ips ips)
-{
-	__raw_writel(0x1, sysmmusfrs[ips] + S5P_MMU_FLUSH);
-	dev_dbg(dev, "TLB of %s is invalidated.\n", sysmmu_ips_name[ips]);
-}
-
-static inline void __sysmmu_set_ptbase(sysmmu_ips ips, unsigned long pgd)
-{
-	if (unlikely(pgd == 0)) {
-		pgd = (unsigned long)ZERO_PAGE(0);
-		__raw_writel(0x20, sysmmusfrs[ips] + S5P_MMU_CFG); /* 4KB LV1 */
-	} else {
-		__raw_writel(0x0, sysmmusfrs[ips] + S5P_MMU_CFG); /* 16KB LV1 */
-	}
-
-	__raw_writel(pgd, sysmmusfrs[ips] + S5P_PT_BASE_ADDR);
-
-	dev_dbg(dev, "Page table base of %s is initialized with 0x%08lX.\n",
-						sysmmu_ips_name[ips], pgd);
-	__sysmmu_tlb_invalidate(ips);
-}
-
-void sysmmu_set_fault_handler(sysmmu_ips ips,
-			int (*handler)(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
-					unsigned long pgtable_base,
-					unsigned long fault_addr))
-{
-	BUG_ON(!((ips >= SYSMMU_MDMA) && (ips < S5P_SYSMMU_TOTAL_IPNUM)));
-	fault_handlers[ips] = handler;
-}
-
-static irqreturn_t s5p_sysmmu_irq(int irq, void *dev_id)
-{
-	/* SYSMMU is in blocked when interrupt occurred. */
-	unsigned long base = 0;
-	sysmmu_ips ips = (sysmmu_ips)dev_id;
-	enum S5P_SYSMMU_INTERRUPT_TYPE itype;
-
-	itype = (enum S5P_SYSMMU_INTERRUPT_TYPE)
-		__ffs(__raw_readl(sysmmusfrs[ips] + S5P_INT_STATUS));
-
-	BUG_ON(!((itype >= 0) && (itype < 8)));
-
-	dev_alert(dev, "%s occurred by %s.\n", sysmmu_fault_name[itype],
-							sysmmu_ips_name[ips]);
-
-	if (fault_handlers[ips]) {
-		unsigned long addr;
-
-		base = __raw_readl(sysmmusfrs[ips] + S5P_PT_BASE_ADDR);
-		addr = __raw_readl(sysmmusfrs[ips] + fault_reg_offset[itype]);
-
-		if (fault_handlers[ips](itype, base, addr)) {
-			__raw_writel(1 << itype,
-					sysmmusfrs[ips] + S5P_INT_CLEAR);
-			dev_notice(dev, "%s from %s is resolved."
-					" Retrying translation.\n",
-				sysmmu_fault_name[itype], sysmmu_ips_name[ips]);
-		} else {
-			base = 0;
-		}
-	}
-
-	sysmmu_unblock(ips);
-
-	if (!base)
-		dev_notice(dev, "%s from %s is not handled.\n",
-			sysmmu_fault_name[itype], sysmmu_ips_name[ips]);
-
-	return IRQ_HANDLED;
-}
-
-void s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd)
-{
-	if (is_sysmmu_active(ips)) {
-		sysmmu_block(ips);
-		__sysmmu_set_ptbase(ips, pgd);
-		sysmmu_unblock(ips);
-	} else {
-		dev_dbg(dev, "%s is disabled. "
-			"Skipping initializing page table base.\n",
-						sysmmu_ips_name[ips]);
-	}
-}
-
-void s5p_sysmmu_enable(sysmmu_ips ips, unsigned long pgd)
-{
-	if (!is_sysmmu_active(ips)) {
-		sysmmu_clk_enable(ips);
-
-		__sysmmu_set_ptbase(ips, pgd);
-
-		__raw_writel(CTRL_ENABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
-
-		set_sysmmu_active(ips);
-		dev_dbg(dev, "%s is enabled.\n", sysmmu_ips_name[ips]);
-	} else {
-		dev_dbg(dev, "%s is already enabled.\n", sysmmu_ips_name[ips]);
-	}
-}
-
-void s5p_sysmmu_disable(sysmmu_ips ips)
-{
-	if (is_sysmmu_active(ips)) {
-		__raw_writel(CTRL_DISABLE, sysmmusfrs[ips] + S5P_MMU_CTRL);
-		set_sysmmu_inactive(ips);
-		sysmmu_clk_disable(ips);
-		dev_dbg(dev, "%s is disabled.\n", sysmmu_ips_name[ips]);
-	} else {
-		dev_dbg(dev, "%s is already disabled.\n", sysmmu_ips_name[ips]);
-	}
-}
-
-void s5p_sysmmu_tlb_invalidate(sysmmu_ips ips)
-{
-	if (is_sysmmu_active(ips)) {
-		sysmmu_block(ips);
-		__sysmmu_tlb_invalidate(ips);
-		sysmmu_unblock(ips);
-	} else {
-		dev_dbg(dev, "%s is disabled. "
-			"Skipping invalidating TLB.\n", sysmmu_ips_name[ips]);
-	}
-}
-
-static int s5p_sysmmu_probe(struct platform_device *pdev)
-{
-	int i, ret;
-	struct resource *res, *mem;
-
-	dev = &pdev->dev;
-
-	for (i = 0; i < S5P_SYSMMU_TOTAL_IPNUM; i++) {
-		int irq;
-
-		sysmmu_clk_init(dev, i);
-		sysmmu_clk_disable(i);
-
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res) {
-			dev_err(dev, "Failed to get the resource of %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENODEV;
-			goto err_res;
-		}
-
-		mem = request_mem_region(res->start, resource_size(res),
-					 pdev->name);
-		if (!mem) {
-			dev_err(dev, "Failed to request the memory region of %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -EBUSY;
-			goto err_res;
-		}
-
-		sysmmusfrs[i] = ioremap(res->start, resource_size(res));
-		if (!sysmmusfrs[i]) {
-			dev_err(dev, "Failed to ioremap() for %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENXIO;
-			goto err_reg;
-		}
-
-		irq = platform_get_irq(pdev, i);
-		if (irq <= 0) {
-			dev_err(dev, "Failed to get the IRQ resource of %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENOENT;
-			goto err_map;
-		}
-
-		if (request_irq(irq, s5p_sysmmu_irq, IRQF_DISABLED,
-						pdev->name, (void *)i)) {
-			dev_err(dev, "Failed to request IRQ for %s.\n",
-							sysmmu_ips_name[i]);
-			ret = -ENOENT;
-			goto err_map;
-		}
-	}
-
-	return 0;
-
-err_map:
-	iounmap(sysmmusfrs[i]);
-err_reg:
-	release_mem_region(mem->start, resource_size(mem));
-err_res:
-	return ret;
-}
-
-static int s5p_sysmmu_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-int s5p_sysmmu_runtime_suspend(struct device *dev)
-{
-	return 0;
-}
-
-int s5p_sysmmu_runtime_resume(struct device *dev)
-{
-	return 0;
-}
-
-const struct dev_pm_ops s5p_sysmmu_pm_ops = {
-	.runtime_suspend	= s5p_sysmmu_runtime_suspend,
-	.runtime_resume		= s5p_sysmmu_runtime_resume,
-};
-
-static struct platform_driver s5p_sysmmu_driver = {
-	.probe		= s5p_sysmmu_probe,
-	.remove		= s5p_sysmmu_remove,
-	.driver		= {
-		.owner		= THIS_MODULE,
-		.name		= "s5p-sysmmu",
-		.pm		= &s5p_sysmmu_pm_ops,
-	}
-};
-
-static int __init s5p_sysmmu_init(void)
-{
-	return platform_driver_register(&s5p_sysmmu_driver);
-}
-arch_initcall(s5p_sysmmu_init);
diff --git a/arch/arm/plat-samsung/include/plat/sysmmu.h b/arch/arm/plat-samsung/include/plat/sysmmu.h
deleted file mode 100644
index 5fe8ee0..0000000
--- a/arch/arm/plat-samsung/include/plat/sysmmu.h
+++ /dev/null
@@ -1,95 +0,0 @@
-/* linux/arch/arm/plat-samsung/include/plat/sysmmu.h
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * Samsung System MMU driver for S5P platform
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __PLAT_SAMSUNG_SYSMMU_H
-#define __PLAT_SAMSUNG_SYSMMU_H __FILE__
-
-enum S5P_SYSMMU_INTERRUPT_TYPE {
-	SYSMMU_PAGEFAULT,
-	SYSMMU_AR_MULTIHIT,
-	SYSMMU_AW_MULTIHIT,
-	SYSMMU_BUSERROR,
-	SYSMMU_AR_SECURITY,
-	SYSMMU_AR_ACCESS,
-	SYSMMU_AW_SECURITY,
-	SYSMMU_AW_PROTECTION, /* 7 */
-	SYSMMU_FAULTS_NUM
-};
-
-#ifdef CONFIG_S5P_SYSTEM_MMU
-
-#include <mach/sysmmu.h>
-
-/**
- * s5p_sysmmu_enable() - enable system mmu of ip
- * @ips: The ip connected system mmu.
- * #pgd: Base physical address of the 1st level page table
- *
- * This function enable system mmu to transfer address
- * from virtual address to physical address
- */
-void s5p_sysmmu_enable(sysmmu_ips ips, unsigned long pgd);
-
-/**
- * s5p_sysmmu_disable() - disable sysmmu mmu of ip
- * @ips: The ip connected system mmu.
- *
- * This function disable system mmu to transfer address
- * from virtual address to physical address
- */
-void s5p_sysmmu_disable(sysmmu_ips ips);
-
-/**
- * s5p_sysmmu_set_tablebase_pgd() - set page table base address to refer page table
- * @ips: The ip connected system mmu.
- * @pgd: The page table base address.
- *
- * This function set page table base address
- * When system mmu transfer address from virtaul address to physical address,
- * system mmu refer address information from page table
- */
-void s5p_sysmmu_set_tablebase_pgd(sysmmu_ips ips, unsigned long pgd);
-
-/**
- * s5p_sysmmu_tlb_invalidate() - flush all TLB entry in system mmu
- * @ips: The ip connected system mmu.
- *
- * This function flush all TLB entry in system mmu
- */
-void s5p_sysmmu_tlb_invalidate(sysmmu_ips ips);
-
-/** s5p_sysmmu_set_fault_handler() - Fault handler for System MMUs
- * @itype: type of fault.
- * @pgtable_base: the physical address of page table base. This is 0 if @ips is
- *               SYSMMU_BUSERROR.
- * @fault_addr: the device (virtual) address that the System MMU tried to
- *             translated. This is 0 if @ips is SYSMMU_BUSERROR.
- * Called when interrupt occurred by the System MMUs
- * The device drivers of peripheral devices that has a System MMU can implement
- * a fault handler to resolve address translation fault by System MMU.
- * The meanings of return value and parameters are described below.
-
- * return value: non-zero if the fault is correctly resolved.
- *         zero if the fault is not handled.
- */
-void s5p_sysmmu_set_fault_handler(sysmmu_ips ips,
-			int (*handler)(enum S5P_SYSMMU_INTERRUPT_TYPE itype,
-					unsigned long pgtable_base,
-					unsigned long fault_addr));
-#else
-#define s5p_sysmmu_enable(ips, pgd) do { } while (0)
-#define s5p_sysmmu_disable(ips) do { } while (0)
-#define s5p_sysmmu_set_tablebase_pgd(ips, pgd) do { } while (0)
-#define s5p_sysmmu_tlb_invalidate(ips) do { } while (0)
-#define s5p_sysmmu_set_fault_handler(ips, handler) do { } while (0)
-#endif
-#endif /* __ASM_PLAT_SYSMMU_H */
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 6bea696..25d3eed 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -142,4 +142,25 @@ config OMAP_IOMMU_DEBUG
 
          Say N unless you know you need this.
 
+config EXYNOS_IOMMU
+	bool "Exynos IOMMU Support"
+	depends on EXYNOS_DEV_SYSMMU
+	select IOMMU_API
+	help
+	  Support for the IOMMU(System MMU) of Samsung Exynos application
+	  processor family. This enables H/W multimedia accellerators to see
+	  non-linear physical memory chunks as a linear memory in their
+	  address spaces
+
+	  If unsure, say N here.
+
+config EXYNOS_IOMMU_DEBUG
+	bool "Debugging log for Exynos IOMMU"
+	depends on EXYNOS_IOMMU
+	help
+	  Select this to see the detailed log message that shows what
+	  happens in the IOMMU driver
+
+	  Say N unless you need kernel log message for IOMMU debugging
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 0e36b49..5a8fd97 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
 obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
 obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
+obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
new file mode 100644
index 0000000..87b5c0f
--- /dev/null
+++ b/drivers/iommu/exynos-iommu.c
@@ -0,0 +1,1076 @@
+/* linux/drivers/iommu/exynos_iommu.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifdef CONFIG_EXYNOS_IOMMU_DEBUG
+#define DEBUG
+#endif
+
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/iommu.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/memblock.h>
+#include <linux/export.h>
+
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+
+#include <mach/sysmmu.h>
+
+#define S5P_MMU_CTRL			0x000
+#define S5P_MMU_CFG			0x004
+#define S5P_MMU_STATUS			0x008
+#define S5P_MMU_FLUSH			0x00C
+#define S5P_PT_BASE_ADDR		0x014
+#define S5P_INT_STATUS			0x018
+#define S5P_INT_CLEAR			0x01C
+#define S5P_PAGE_FAULT_ADDR		0x024
+#define S5P_AW_FAULT_ADDR		0x028
+#define S5P_AR_FAULT_ADDR		0x02C
+#define S5P_DEFAULT_SLAVE_ADDR		0x030
+#define S5P_MMU_VERSION			0x034
+#define S5P_PB0_SADDR			0x04C
+#define S5P_PB0_EADDR			0x050
+#define S5P_PB1_SADDR			0x054
+#define S5P_PB1_EADDR			0x058
+
+#define SECT_ORDER 20
+#define LPAGE_ORDER 16
+#define SPAGE_ORDER 12
+
+#define SECT_SIZE (1 << SECT_ORDER)
+#define LPAGE_SIZE (1 << LPAGE_ORDER)
+#define SPAGE_SIZE (1 << SPAGE_ORDER)
+
+#define SECT_MASK (~(SECT_SIZE - 1))
+#define LPAGE_MASK (~(LPAGE_SIZE - 1))
+#define SPAGE_MASK (~(SPAGE_SIZE - 1))
+
+#define lv1ent_fault(sent) (((*(sent) & 3) == 0) || ((*(sent) & 3) == 3))
+#define lv1ent_page(sent) ((*(sent) & 3) == 1)
+#define lv1ent_section(sent) ((*(sent) & 3) == 2)
+
+#define lv2ent_fault(pent) ((*(pent) & 3) == 0)
+#define lv2ent_small(pent) ((*(pent) & 2) == 2)
+#define lv2ent_large(pent) ((*(pent) & 3) == 1)
+
+#define section_phys(sent) (*(sent) & SECT_MASK)
+#define section_offs(iova) ((iova) & 0xFFFFF)
+#define lpage_phys(pent) (*(pent) & LPAGE_MASK)
+#define lpage_offs(iova) ((iova) & 0xFFFF)
+#define spage_phys(pent) (*(pent) & SPAGE_MASK)
+#define spage_offs(iova) ((iova) & 0xFFF)
+
+#define lv1ent_offset(iova) ((iova) >> SECT_ORDER)
+#define lv2ent_offset(iova) (((iova) & 0xFF000) >> SPAGE_ORDER)
+
+#define NUM_LV1ENTRIES 4096
+#define NUM_LV2ENTRIES 256
+
+#define LV2TABLE_SIZE (NUM_LV2ENTRIES * sizeof(long))
+
+#define SPAGES_PER_LPAGE (LPAGE_SIZE / SPAGE_SIZE)
+
+#define lv2table_base(sent) (*(sent) & 0xFFFFFC00)
+
+#define mk_lv1ent_sect(pa) ((pa) | 2)
+#define mk_lv1ent_page(pa) ((pa) | 1)
+#define mk_lv2ent_lpage(pa) ((pa) | 1)
+#define mk_lv2ent_spage(pa) ((pa) | 2)
+
+#define CTRL_ENABLE	0x5
+#define CTRL_BLOCK	0x7
+#define CTRL_DISABLE	0x0
+
+#define REG_MMU_CTRL		0x000
+#define REG_MMU_CFG		0x004
+#define REG_MMU_STATUS		0x008
+#define REG_MMU_FLUSH		0x00C
+#define REG_MMU_FLUSH_ENTRY	0x010
+#define REG_PT_BASE_ADDR	0x014
+#define REG_INT_STATUS		0x018
+#define REG_INT_CLEAR		0x01C
+#define REG_MMU_VERSION		0x034
+
+#define REG_PAGE_FAULT_ADDR	0x024
+#define REG_AW_FAULT_ADDR	0x028
+#define REG_AR_FAULT_ADDR	0x02C
+#define REG_DEFAULT_SLAVE_ADDR	0x030
+
+static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
+{
+	return pgtable + lv1ent_offset(iova);
+}
+
+static unsigned long *page_entry(unsigned long *sent, unsigned long iova)
+{
+	return (unsigned long *)__va(lv2table_base(sent)) + lv2ent_offset(iova);
+}
+
+enum EXYNOS_SYSMMU_INTERRUPT_TYPE {
+	SYSMMU_PAGEFAULT,
+	SYSMMU_AR_MULTIHIT,
+	SYSMMU_AW_MULTIHIT,
+	SYSMMU_BUSERROR,
+	SYSMMU_AR_SECURITY,
+	SYSMMU_AR_ACCESS,
+	SYSMMU_AW_SECURITY,
+	SYSMMU_AW_PROTECTION, /* 7 */
+	SYSMMU_FAULT_UNKNOWN,
+	SYSMMU_FAULTS_NUM
+};
+
+typedef int (*sysmmu_fault_handler_t)(enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype,
+			unsigned long pgtable_base, unsigned long fault_addr);
+
+static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
+	REG_PAGE_FAULT_ADDR,
+	REG_AR_FAULT_ADDR,
+	REG_AW_FAULT_ADDR,
+	REG_DEFAULT_SLAVE_ADDR,
+	REG_AR_FAULT_ADDR,
+	REG_AR_FAULT_ADDR,
+	REG_AW_FAULT_ADDR,
+	REG_AW_FAULT_ADDR
+};
+
+static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
+	"PAGE FAULT",
+	"AR MULTI-HIT FAULT",
+	"AW MULTI-HIT FAULT",
+	"BUS ERROR",
+	"AR SECURITY PROTECTION FAULT",
+	"AR ACCESS PROTECTION FAULT",
+	"AW SECURITY PROTECTION FAULT",
+	"AW ACCESS PROTECTION FAULT",
+	"UNKNOWN FAULT"
+};
+
+struct exynos_iommu_domain;
+
+struct sysmmu_drvdata {
+	struct device *dev;
+	char *dbgname;
+	int nsfrs;
+	void __iomem **sfrbases;
+	struct clk *clk[2];
+	bool active;
+	rwlock_t lock;
+	struct iommu_domain *domain;
+	sysmmu_fault_handler_t fault_handler;
+	unsigned long pgtable;
+};
+
+static bool set_sysmmu_active(struct sysmmu_drvdata *data)
+{
+	/* return true if the System MMU was not active previously
+	   and it needs to be initialized */
+	if (WARN_ON_ONCE(data->active))
+		return false;
+	data->active = true;
+	return true;
+}
+
+static bool set_sysmmu_inactive(struct sysmmu_drvdata *data)
+{
+	/* return true if the System MMU is needed to be disabled */
+	if (WARN_ON_ONCE(!data->active))
+		return false;
+	data->active = false;
+	return true;
+}
+
+static bool is_sysmmu_active(struct sysmmu_drvdata *data)
+{
+	return data->active;
+}
+
+static void sysmmu_block(void __iomem *sfrbase)
+{
+	__raw_writel(CTRL_BLOCK, sfrbase + REG_MMU_CTRL);
+}
+
+static void sysmmu_unblock(void __iomem *sfrbase)
+{
+	__raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
+}
+
+static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
+{
+	__raw_writel(0x1, sfrbase + REG_MMU_FLUSH);
+}
+
+static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
+						unsigned long iova)
+{
+	__raw_writel((iova & SPAGE_MASK) | 1, sfrbase + REG_MMU_FLUSH_ENTRY);
+}
+
+static void __sysmmu_set_ptbase(void __iomem *sfrbase,
+				       unsigned long pgd)
+{
+	__raw_writel(0x1, sfrbase + REG_MMU_CFG); /* 16KB LV1, LRU */
+	__raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
+
+	__sysmmu_tlb_invalidate(sfrbase);
+}
+
+static void __sysmmu_set_prefbuf(void __iomem *sfrbase, unsigned long base,
+						unsigned long size, int idx)
+{
+	__raw_writel(base, sfrbase + S5P_PB0_SADDR + idx * 8);
+	__raw_writel(size - 1 + base,  sfrbase + S5P_PB0_EADDR + idx * 8);
+}
+
+void exynos_sysmmu_set_prefbuf(struct device *owner,
+				unsigned long base0, unsigned long size0,
+				unsigned long base1, unsigned long size1)
+{
+	struct sysmmu_drvdata *data = dev_get_drvdata(owner->archdata.iommu);
+	unsigned long flags;
+	int i;
+
+	BUG_ON((base0 + (size0 - 1)) <= base0);
+	BUG_ON((base1 + (size1 - 1)) <= base1);
+
+	read_lock_irqsave(&data->lock, flags);
+	if (!is_sysmmu_active(data))
+		goto finish;
+
+	for (i = 0; i < data->nsfrs; i++) {
+		if ((readl(data->sfrbases[i] + S5P_MMU_VERSION) >> 28) == 3) {
+			sysmmu_block(data->sfrbases[i]);
+
+			if (size1 == 0) {
+				if (size0 <= SZ_128K) {
+					base1 = base0;
+					size1 = size0;
+				} else {
+					size1 = size0 -
+						ALIGN(size0 / 2, SZ_64K);
+					size0 = size0 - size1;
+					base1 = base0 + size0;
+				}
+			}
+
+			__sysmmu_set_prefbuf(
+					data->sfrbases[i], base0, size0, 0);
+			__sysmmu_set_prefbuf(
+					data->sfrbases[i], base1, size1, 1);
+
+			sysmmu_unblock(data->sfrbases[i]);
+		}
+	}
+finish:
+	read_unlock_irqrestore(&data->lock, flags);
+}
+
+static void __set_fault_handler(struct sysmmu_drvdata *data,
+					sysmmu_fault_handler_t handler)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&data->lock, flags);
+	data->fault_handler = handler;
+	write_unlock_irqrestore(&data->lock, flags);
+}
+
+void exynos_sysmmu_set_fault_handler(struct device *owner,
+					sysmmu_fault_handler_t handler)
+{
+	struct sysmmu_drvdata *data = dev_get_drvdata(owner->archdata.iommu);
+
+	__set_fault_handler(data, handler);
+}
+
+static int default_fault_handler(enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype,
+		     unsigned long pgtable_base, unsigned long fault_addr)
+{
+	unsigned long *ent;
+
+	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
+		itype = SYSMMU_FAULT_UNKNOWN;
+
+	pr_err("%s occured at 0x%lx(Page table base: 0x%lx)\n",
+			sysmmu_fault_name[itype], fault_addr, pgtable_base);
+
+	ent = section_entry(__va(pgtable_base), fault_addr);
+	pr_err("\tLv1 entry: 0x%lx\n", *ent);
+
+	if (lv1ent_page(ent)) {
+		ent = page_entry(ent, fault_addr);
+		pr_err("\t Lv2 entry: 0x%lx\n", *ent);
+	}
+
+	pr_err("Generating Kernel OOPS... because it is unrecoverable.\n");
+
+	BUG();
+
+	return 0;
+}
+
+static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
+{
+	/* SYSMMU is in blocked when interrupt occurred. */
+	struct sysmmu_drvdata *data = dev_id;
+	struct resource *irqres;
+	struct platform_device *pdev;
+	enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype;
+	unsigned long addr = -1;
+
+	int i, ret = -ENOSYS;
+
+	read_lock(&data->lock);
+
+	WARN_ON(!is_sysmmu_active(data));
+
+	pdev = to_platform_device(data->dev);
+	for (i = 0; i < pdev->num_resources; i++) {
+		irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
+		if (irqres && ((int)irqres->start == irq))
+			break;
+	}
+
+	if (i == pdev->num_resources) {
+		itype = SYSMMU_FAULT_UNKNOWN;
+	} else {
+		i /= 2;
+
+		itype = (enum EXYNOS_SYSMMU_INTERRUPT_TYPE)
+			__ffs(__raw_readl(data->sfrbases[i] + REG_INT_STATUS));
+		if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
+			itype = SYSMMU_FAULT_UNKNOWN;
+		else
+			addr = __raw_readl(
+				data->sfrbases[i] + fault_reg_offset[itype]);
+	}
+
+	if (data->domain)
+		ret = report_iommu_fault(data->domain, data->dev, addr, itype);
+
+	if ((ret == -ENOSYS) && data->fault_handler) {
+		unsigned long base = data->pgtable;
+		if (itype != SYSMMU_FAULT_UNKNOWN)
+			base = __raw_readl(
+					data->sfrbases[i] + REG_PT_BASE_ADDR);
+		ret = data->fault_handler(itype, base, addr);
+	}
+
+	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
+		__raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
+	else
+		dev_dbg(data->dev, "(%s) %s is not handled.\n",
+				data->dbgname, sysmmu_fault_name[itype]);
+
+	if (itype != SYSMMU_FAULT_UNKNOWN)
+		sysmmu_unblock(data->sfrbases[i]);
+
+	read_unlock(&data->lock);
+
+	return IRQ_HANDLED;
+}
+
+static bool __sysmmu_disable(struct sysmmu_drvdata *data)
+{
+	unsigned long flags;
+	bool disabled = false;
+	int i;
+
+	write_lock_irqsave(&data->lock, flags);
+
+	if (!set_sysmmu_inactive(data))
+		goto finish;
+
+	for (i = 0; i < data->nsfrs; i++) {
+		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
+		if (data->clk[0])
+			clk_disable(data->clk[0]);
+		if (data->clk[1])
+			clk_disable(data->clk[1]);
+		disabled = true;
+		data->pgtable = 0;
+		data->domain = NULL;
+		pm_runtime_put(data->dev);
+	}
+
+finish:
+	write_unlock_irqrestore(&data->lock, flags);
+
+	return disabled;
+}
+
+static int __exynos_sysmmu_enable(struct device *owner, unsigned long pgtable,
+						struct iommu_domain *domain)
+{
+	int i, ret = 0;
+	unsigned long flags;
+	struct sysmmu_drvdata *data = dev_get_drvdata(owner->archdata.iommu);
+
+	BUG_ON(!memblock_is_memory(pgtable));
+
+	ret = pm_runtime_get_sync(data->dev);
+	if (ret < 0)
+		return ret;
+
+	write_lock_irqsave(&data->lock, flags);
+
+	if (!set_sysmmu_active(data)) {
+		/* RPM of sysmmu won't be refcounted */
+		if (ret > 0)
+			pm_runtime_put(data->dev);
+
+		if (WARN_ON(pgtable != data->pgtable)) {
+			set_sysmmu_inactive(data);
+			ret = -EBUSY;
+		}
+
+		dev_dbg(data->dev, "(%s) Already enabled.\n", data->dbgname);
+		goto finish;
+	}
+
+	if (data->clk[0])
+		clk_enable(data->clk[0]);
+	if (data->clk[1])
+		clk_enable(data->clk[1]);
+
+	data->pgtable = pgtable;
+
+	for (i = 0; i < data->nsfrs; i++) {
+		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
+
+		if ((readl(data->sfrbases[i] + S5P_MMU_VERSION) >> 28) == 3) {
+			/* System MMU version is 3.x */
+			__raw_writel((1 << 12) | (2 << 28),
+					data->sfrbases[i] + S5P_MMU_CFG);
+			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
+			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
+		}
+
+		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
+	}
+
+	data->domain = domain;
+
+	dev_dbg(data->dev, "(%s) Enabled.\n", data->dbgname);
+finish:
+	write_unlock_irqrestore(&data->lock, flags);
+
+	if (ret < 0) {
+		__sysmmu_disable(data);
+		dev_dbg(data->dev, "(%s) Failed to enable.\n", data->dbgname);
+		return ret;
+	}
+
+	return 0;
+}
+
+int exynos_sysmmu_enable(struct device *owner, unsigned long pgtable)
+{
+	return __exynos_sysmmu_enable(owner, pgtable, NULL);
+}
+
+void exynos_sysmmu_disable(struct device *owner)
+{
+	struct sysmmu_drvdata *data = dev_get_drvdata(owner->archdata.iommu);
+	bool disabled;
+
+	disabled = __sysmmu_disable(data);
+	dev_dbg(data->dev,
+			disabled ? "(%s) Disabled.\n" :
+				"(%s) Deactivation request ignorred.\n",
+			data->dbgname);
+}
+
+static void sysmmu_tlb_invalidate_entry(struct device *owner,
+						unsigned long iova)
+{
+	unsigned long flags;
+	struct sysmmu_drvdata *data = dev_get_drvdata(owner->archdata.iommu);
+
+	read_lock_irqsave(&data->lock, flags);
+
+	if (is_sysmmu_active(data)) {
+		int i;
+		for (i = 0; i < data->nsfrs; i++) {
+			sysmmu_block(data->sfrbases[i]);
+			__sysmmu_tlb_invalidate_entry(data->sfrbases[i], iova);
+			sysmmu_unblock(data->sfrbases[i]);
+		}
+	} else {
+		dev_dbg(data->dev,
+			"(%s) Disabled. Skipping invalidating TLB.\n",
+			data->dbgname);
+	}
+
+	read_unlock_irqrestore(&data->lock, flags);
+}
+
+void exynos_sysmmu_tlb_invalidate(struct device *owner)
+{
+	unsigned long flags;
+	struct sysmmu_drvdata *data = dev_get_drvdata(owner->archdata.iommu);
+
+	read_lock_irqsave(&data->lock, flags);
+
+	if (is_sysmmu_active(data)) {
+		int i;
+		for (i = 0; i < data->nsfrs; i++) {
+			sysmmu_block(data->sfrbases[i]);
+			__sysmmu_tlb_invalidate(data->sfrbases[i]);
+			sysmmu_unblock(data->sfrbases[i]);
+		}
+	} else {
+		dev_dbg(data->dev,
+			"(%s) Disabled. Skipping invalidating TLB.\n",
+			data->dbgname);
+	}
+
+	read_unlock_irqrestore(&data->lock, flags);
+}
+
+static int exynos_sysmmu_probe(struct platform_device *pdev)
+{
+	int i, ret;
+	struct device *dev;
+	struct sysmmu_drvdata *data;
+
+	dev = &pdev->dev;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_dbg(dev, "Not enough memory\n");
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	ret = dev_set_drvdata(dev, data);
+	if (ret) {
+		dev_dbg(dev, "Unabled to initialize driver data\n");
+		goto err_init;
+	}
+
+	data->nsfrs = pdev->num_resources / 2;
+	data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
+								GFP_KERNEL);
+	if (data->sfrbases == NULL) {
+		dev_dbg(dev, "Not enough memory\n");
+		ret = -ENOMEM;
+		goto err_init;
+	}
+
+	for (i = 0; i < data->nsfrs; i++) {
+		struct resource *res;
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!res) {
+			dev_dbg(dev, "Unable to find IOMEM region\n");
+			ret = -ENOENT;
+			goto err_res;
+		}
+
+		data->sfrbases[i] = ioremap(res->start, resource_size(res));
+		if (!data->sfrbases[i]) {
+			dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n",
+							res->start);
+			ret = -ENOENT;
+			goto err_res;
+		}
+	}
+
+	for (i = 0; i < data->nsfrs; i++) {
+		ret = platform_get_irq(pdev, i);
+		if (ret <= 0) {
+			dev_dbg(dev, "Unable to find IRQ resource\n");
+			goto err_irq;
+		}
+
+		ret = request_irq(ret, exynos_sysmmu_irq, 0,
+					dev_name(dev), data);
+		if (ret) {
+			dev_dbg(dev, "Unabled to register interrupt handler\n");
+			goto err_irq;
+		}
+	}
+
+	if (dev_get_platdata(dev)) {
+		char *deli, *beg;
+		struct sysmmu_platform_data *platdata = dev_get_platdata(dev);
+
+		beg = platdata->clockname;
+
+		for (deli = beg; (*deli != '\0') && (*deli != ','); deli++)
+			/* NOTHING */;
+
+		if (*deli == '\0')
+			deli = NULL;
+		else
+			*deli = '\0';
+
+		data->clk[0] = clk_get(dev, beg);
+		if (IS_ERR(data->clk[0])) {
+			data->clk[0] = NULL;
+			dev_dbg(dev, "No clock descriptor registered\n");
+		}
+
+		if (data->clk[0] && deli) {
+			*deli = ',';
+			data->clk[1] = clk_get(dev, deli + 1);
+			if (IS_ERR(data->clk[1]))
+				data->clk[1] = NULL;
+		}
+
+		data->dbgname = platdata->dbgname;
+	}
+
+	data->dev = dev;
+	rwlock_init(&data->lock);
+
+	__set_fault_handler(data, &default_fault_handler);
+
+	if (dev->parent)
+		pm_runtime_enable(dev);
+
+	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
+	return 0;
+err_irq:
+	while (i-- > 0) {
+		int irq;
+
+		irq = platform_get_irq(pdev, i);
+		free_irq(irq, data);
+	}
+err_res:
+	while (data->nsfrs-- > 0)
+		iounmap(data->sfrbases[data->nsfrs]);
+	kfree(data->sfrbases);
+err_init:
+	kfree(data);
+err_alloc:
+	dev_err(dev, "(%s) Failed to initialize\n", data->dbgname);
+	return ret;
+}
+
+static struct platform_driver exynos_sysmmu_driver = {
+	.probe		= exynos_sysmmu_probe,
+	.driver		= {
+		.owner		= THIS_MODULE,
+		.name		= "exynos-sysmmu",
+	}
+};
+
+/* We does not consider super section mapping (16MB) */
+struct iommu_client {
+	struct list_head node;
+	struct device *dev;
+	int refcnt;
+};
+
+struct exynos_iommu_domain {
+	struct list_head clients; /* list of iommu_client */
+	unsigned long *pgtable; /* lv1 page table, 16KB */
+	short *lv2entcnt; /* free lv2 entry counter for each section */
+	spinlock_t lock; /* lock for this structure */
+	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
+};
+
+static inline void pgtable_flush(void *vastart, void *vaend)
+{
+	dmac_flush_range(vastart, vaend);
+	outer_flush_range(virt_to_phys(vastart),
+				virt_to_phys(vaend));
+}
+
+static int exynos_iommu_domain_init(struct iommu_domain *domain)
+{
+	struct exynos_iommu_domain *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->pgtable = (unsigned long *)__get_free_pages(
+						GFP_KERNEL | __GFP_ZERO, 2);
+	if (!priv->pgtable)
+		goto err_pgtable;
+
+	priv->lv2entcnt = (short *)__get_free_pages(
+						GFP_KERNEL | __GFP_ZERO, 1);
+	if (!priv->lv2entcnt)
+		goto err_counter;
+
+	pgtable_flush(priv->pgtable, priv->pgtable + NUM_LV1ENTRIES);
+
+	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->pgtablelock);
+	INIT_LIST_HEAD(&priv->clients);
+
+	domain->priv = priv;
+	return 0;
+
+err_counter:
+	free_pages((unsigned long)priv->pgtable, 2);
+err_pgtable:
+	kfree(priv);
+	return -ENOMEM;
+}
+
+static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	struct list_head *pos, *n;
+	unsigned long flags;
+	int i;
+
+	WARN_ON(!list_empty(&priv->clients));
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	list_for_each_safe(pos, n, &priv->clients) {
+		struct iommu_client *client;
+
+		client = list_entry(pos, struct iommu_client, node);
+		exynos_sysmmu_disable(client->dev);
+		kfree(client);
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	for (i = 0; i < NUM_LV1ENTRIES; i++)
+		if (lv1ent_page(priv->pgtable + i))
+			kfree(__va(lv2table_base(priv->pgtable + i)));
+
+	free_pages((unsigned long)priv->pgtable, 2);
+	free_pages((unsigned long)priv->lv2entcnt, 1);
+	kfree(domain->priv);
+	domain->priv = NULL;
+}
+
+static int exynos_iommu_attach_device(struct iommu_domain *domain,
+				   struct device *dev)
+{
+	int ret;
+	struct exynos_iommu_domain *priv = domain->priv;
+	struct iommu_client *client = NULL;
+	struct list_head *pos;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	list_for_each(pos, &priv->clients) {
+		struct iommu_client *cur;
+
+		cur = list_entry(pos, struct iommu_client, node);
+		if (cur->dev == dev) {
+			client = cur;
+			break;
+		}
+	}
+
+	if (client != NULL) {
+		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
+					__func__, __pa(priv->pgtable));
+		client->refcnt++;
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (client != NULL)
+		return 0;
+
+	client = kmalloc(sizeof(*client), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&client->node);
+	client->dev = dev;
+	client->refcnt = 1;
+
+	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
+	if (ret) {
+		kfree(client);
+		return ret;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+	list_add_tail(&client->node, &priv->clients);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n", __func__,
+						__pa(priv->pgtable));
+	return 0;
+}
+
+static void exynos_iommu_detach_device(struct iommu_domain *domain,
+				    struct device *dev)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	struct iommu_client *client = NULL;
+	struct list_head *pos;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	list_for_each(pos, &priv->clients) {
+		struct iommu_client *cur;
+
+		cur = list_entry(pos, struct iommu_client, node);
+		if (cur->dev == dev) {
+			cur->refcnt--;
+			client = cur;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (WARN_ON(client == NULL))
+		return;
+
+	if (client->refcnt > 0) {
+		dev_dbg(dev, "%s: Detaching IOMMU with pgtable 0x%lx delayed\n",
+					__func__, __pa(priv->pgtable));
+		return;
+	}
+
+	BUG_ON(client->refcnt != 0);
+
+	list_del(&client->node);
+	exynos_sysmmu_disable(client->dev);
+	kfree(client);
+	dev_dbg(dev, "%s: Detached IOMMU with pgtable 0x%lx\n", __func__,
+						__pa(priv->pgtable));
+}
+
+static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
+					short *pgcounter)
+{
+	if (lv1ent_fault(sent)) {
+		unsigned long *pent;
+
+		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
+		if (!pent)
+			return NULL;
+
+		*sent = mk_lv1ent_page(__pa(pent));
+		*pgcounter = NUM_LV2ENTRIES;
+		pgtable_flush(pent, pent + NUM_LV2ENTRIES);
+		pgtable_flush(sent, sent + 1);
+	}
+
+	return page_entry(sent, iova);
+}
+
+static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
+{
+	if (lv1ent_section(sent))
+		return -EADDRINUSE;
+
+	if (lv1ent_page(sent)) {
+		if (*pgcnt != NUM_LV2ENTRIES)
+			return -EADDRINUSE;
+
+		kfree(page_entry(sent, 0));
+
+		*pgcnt = 0;
+	}
+
+	*sent = mk_lv1ent_sect(paddr);
+
+	pgtable_flush(sent, sent + 1);
+
+	return 0;
+}
+
+static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
+								short *pgcnt)
+{
+	if (size == SPAGE_SIZE) {
+		if (!lv2ent_fault(pent))
+			return -EADDRINUSE;
+
+		*pent = mk_lv2ent_spage(paddr);
+		pgtable_flush(pent, pent + 1);
+		*pgcnt -= 1;
+	} else { /* size == LPAGE_SIZE */
+		int i;
+		for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
+			if (!lv2ent_fault(pent)) {
+				memset(pent, 0, sizeof(*pent) * i);
+				return -EADDRINUSE;
+			}
+
+			*pent = mk_lv2ent_lpage(paddr);
+		}
+		pgtable_flush(pent - SPAGES_PER_LPAGE, pent);
+		*pgcnt -= SPAGES_PER_LPAGE;
+	}
+
+	return 0;
+}
+
+static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
+			 phys_addr_t paddr, size_t size, int prot)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	unsigned long *entry;
+	unsigned long flags;
+	int ret = -ENOMEM;
+
+	BUG_ON(priv->pgtable == NULL);
+
+	spin_lock_irqsave(&priv->pgtablelock, flags);
+
+	entry = section_entry(priv->pgtable, iova);
+
+	if (size == SECT_SIZE) {
+		ret = lv1set_section(entry, paddr,
+					&priv->lv2entcnt[lv1ent_offset(iova)]);
+	} else {
+		unsigned long *pent;
+
+		pent = alloc_lv2entry(entry, iova,
+					&priv->lv2entcnt[lv1ent_offset(iova)]);
+
+		if (!pent)
+			ret = -ENOMEM;
+		else
+			ret = lv2set_page(pent, paddr, size,
+					&priv->lv2entcnt[lv1ent_offset(iova)]);
+	}
+
+	if (ret) {
+		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
+							__func__, iova, size);
+	}
+
+	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+	return ret;
+}
+
+static size_t exynos_iommu_unmap(struct iommu_domain *domain,
+					       unsigned long iova, size_t size)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	struct iommu_client *client;
+	unsigned long flags;
+	unsigned long *ent;
+
+	BUG_ON(priv->pgtable == NULL);
+
+	spin_lock_irqsave(&priv->pgtablelock, flags);
+
+	ent = section_entry(priv->pgtable, iova);
+
+	if (lv1ent_section(ent)) {
+		BUG_ON(size < SECT_SIZE);
+
+		*ent = 0;
+		pgtable_flush(ent, ent + 1);
+		size = SECT_SIZE;
+		goto done;
+	}
+
+	if (unlikely(lv1ent_fault(ent))) {
+		if (size > SECT_SIZE)
+			size = SECT_SIZE;
+		goto done;
+	}
+
+	/* lv1ent_page(sent) == true here */
+
+	ent = page_entry(ent, iova);
+
+	if (unlikely(lv2ent_fault(ent))) {
+		size = SPAGE_SIZE;
+		goto done;
+	}
+
+	if (lv2ent_small(ent)) {
+		*ent = 0;
+		size = SPAGE_SIZE;
+		priv->lv2entcnt[lv1ent_offset(iova)] -= 1;
+		goto done;
+	}
+
+	/* lv1ent_large(ent) == true here */
+	BUG_ON(size < LPAGE_SIZE);
+
+	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
+
+	size = LPAGE_SIZE;
+	priv->lv2entcnt[lv1ent_offset(iova)] -= SPAGES_PER_LPAGE;
+done:
+	list_for_each_entry(client, &priv->clients, node)
+		sysmmu_tlb_invalidate_entry(client->dev, iova);
+
+	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+	return size;
+}
+
+static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
+					  unsigned long iova)
+{
+	struct exynos_iommu_domain *priv = domain->priv;
+	unsigned long *entry;
+	unsigned long flags;
+	phys_addr_t phys = -1;
+
+	spin_lock_irqsave(&priv->pgtablelock, flags);
+
+	entry = section_entry(priv->pgtable, iova);
+
+	if (lv1ent_section(entry)) {
+		phys = section_phys(entry) + section_offs(iova);
+	} else if (lv1ent_page(entry)) {
+		entry = page_entry(entry, iova);
+
+		if (lv2ent_large(entry))
+			phys = lpage_phys(entry) + lpage_offs(iova);
+		else if (lv2ent_small(entry))
+			phys = spage_phys(entry) + spage_offs(iova);
+	}
+
+	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+	return phys;
+}
+
+static struct iommu_ops exynos_iommu_ops = {
+	.domain_init = &exynos_iommu_domain_init,
+	.domain_destroy = &exynos_iommu_domain_destroy,
+	.attach_dev = &exynos_iommu_attach_device,
+	.detach_dev = &exynos_iommu_detach_device,
+	.map = &exynos_iommu_map,
+	.unmap = &exynos_iommu_unmap,
+	.iova_to_phys = &exynos_iommu_iova_to_phys,
+	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
+};
+
+static int __init exynos_iommu_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&exynos_sysmmu_driver);
+
+	if (ret == 0)
+		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+
+	return ret;
+}
+arch_initcall(exynos_iommu_init);
-- 
1.7.1


