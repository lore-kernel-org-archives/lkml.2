Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455Ab2CFNNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:13:07 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54055 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2CFNND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:13:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kyungmin78@gmail.com designates 10.224.189.12 as permitted sender) smtp.mail=kyungmin78@gmail.com; dkim=pass header.i=kyungmin78@gmail.com
MIME-Version: 1.0
In-Reply-To: <002201ccfb73$93311520$b9933f60$%cho@samsung.com>
References: <002201ccfb73$93311520$b9933f60$%cho@samsung.com>
Date: Tue, 6 Mar 2012 22:13:01 +0900
X-Google-Sender-Auth: EAu_X1_jEeFC5ymW67CyN9_Y9Ig
Message-ID: <CAH9JG2W=E7xmEO3o+up5a5Vm1PrPp60w0cfzN7=bYQO2BX1teA@mail.gmail.com>
Subject: Re: [PATCH v10 3/3] iommu/exynos: Add iommu driver for Exynos Platforms
From: Kyungmin Park <kmpark@infradead.org>
To: pullip.cho@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

some not critical comments.

Thank you,
Kyungmin Park

On Tue, Mar 6, 2012 at 5:31 PM, KyongHo Cho <pullip.cho@samsung.com> wrote:
> HAALgBjAGgAbwBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
>  06 Mar 2012 08:31:29 GMT;WwBQAEEAVABDAEgAIAB2ADEAMAAgADMALwAzAF0AIABpAG8AbQBtAHUALwBlAHgAeQBuAG8AcwA6ACAAQQBkAGQAIABpAG8AbQBtAHUAIABkAHIAaQB2AGUAcgAgAGYAbwByACAARQB4AHkAbgBvAHMAIABQAGwAYQB0AGYAbwByAG0AcwA=
> x-cr-puzzleid: {CF0AAF04-8639-4D69-B4E1-BF71EA1B0A70}
What's this?
>
> This is the System MMU driver and IOMMU API implementation for
> Exynos SOC platforms. Exynos platforms has more than 10 System
> MMUs dedicated for each multimedia accellerators.
>
> The System MMU driver is already in arc/arm/plat-s5p but it is
> moved to drivers/iommu due to Ohad Ben-Cohen gathered IOMMU drivers
> there
>
> Any device driver in Exynos platforms that needs to control its
> System MMU must call platform_set_sysmmu() to inform System MMU
> driver who will control it.
> platform_set_sysmmu() is defined in <mach/sysmmu.h>
Does it really required? if we can remove it. it can be compiled
without arch dependency.
>
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
> ---
>  drivers/iommu/Kconfig        |   21 +
>  drivers/iommu/Makefile       |    1 +
>  drivers/iommu/exynos-iommu.c | 1088 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1110 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/iommu/exynos-iommu.c
>
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 6bea696..25d3eed 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -142,4 +142,25 @@ config OMAP_IOMMU_DEBUG
>
>          Say N unless you know you need this.
>
> +config EXYNOS_IOMMU
> +       bool "Exynos IOMMU Support"
> +       depends on EXYNOS_DEV_SYSMMU
> +       select IOMMU_API
> +       help
> +         Support for the IOMMU(System MMU) of Samsung Exynos application
> +         processor family. This enables H/W multimedia accellerators to see
> +         non-linear physical memory chunks as a linear memory in their
> +         address spaces
> +
> +         If unsure, say N here.
> +
> +config EXYNOS_IOMMU_DEBUG
> +       bool "Debugging log for Exynos IOMMU"
> +       depends on EXYNOS_IOMMU
> +       help
> +         Select this to see the detailed log message that shows what
> +         happens in the IOMMU driver
> +
> +         Say N unless you need kernel log message for IOMMU debugging
> +
>  endif # IOMMU_SUPPORT
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 0e36b49..5a8fd97 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
>  obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
>  obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
>  obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
> +obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> new file mode 100644
> index 0000000..4c1c48a
> --- /dev/null
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -0,0 +1,1088 @@
> +/* linux/drivers/iommu/exynos_iommu.c
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifdef CONFIG_EXYNOS_IOMMU_DEBUG
> +#define DEBUG
> +#endif
If it's used only at here. you can add it at Makefile.

ifeq ($(CONFIG_EXYNOS_IOMMU_DEBUG),y)
         CFLAGS-exynos-iommu        += -DDEBUG
endif

Of course you can select as your preference.
> +
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/mm.h>
> +#include <linux/iommu.h>
> +#include <linux/errno.h>
> +#include <linux/list.h>
> +#include <linux/memblock.h>
> +#include <linux/export.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/pgtable.h>
> +
> +#include <mach/sysmmu.h>
> +
> +#define S5P_MMU_CTRL                   0x000
> +#define S5P_MMU_CFG                    0x004
> +#define S5P_MMU_STATUS                 0x008
> +#define S5P_MMU_FLUSH                  0x00C
> +#define S5P_PT_BASE_ADDR               0x014
> +#define S5P_INT_STATUS                 0x018
> +#define S5P_INT_CLEAR                  0x01C
> +#define S5P_PAGE_FAULT_ADDR            0x024
> +#define S5P_AW_FAULT_ADDR              0x028
> +#define S5P_AR_FAULT_ADDR              0x02C
> +#define S5P_DEFAULT_SLAVE_ADDR         0x030
> +#define S5P_MMU_VERSION                        0x034
> +#define S5P_PB0_SADDR                  0x04C
> +#define S5P_PB0_EADDR                  0x050
> +#define S5P_PB1_SADDR                  0x054
> +#define S5P_PB1_EADDR                  0x058
> +
> +#define SECT_ORDER 20
> +#define LPAGE_ORDER 16
> +#define SPAGE_ORDER 12
> +
> +#define SECT_SIZE (1 << SECT_ORDER)
> +#define LPAGE_SIZE (1 << LPAGE_ORDER)
> +#define SPAGE_SIZE (1 << SPAGE_ORDER)
> +
> +#define SECT_MASK (~(SECT_SIZE - 1))
> +#define LPAGE_MASK (~(LPAGE_SIZE - 1))
> +#define SPAGE_MASK (~(SPAGE_SIZE - 1))
> +
> +#define lv1ent_fault(sent) (((*(sent) & 3) == 0) || ((*(sent) & 3) == 3))
> +#define lv1ent_page(sent) ((*(sent) & 3) == 1)
> +#define lv1ent_section(sent) ((*(sent) & 3) == 2)
> +
> +#define lv2ent_fault(pent) ((*(pent) & 3) == 0)
> +#define lv2ent_small(pent) ((*(pent) & 2) == 2)
#define lv2ent_small(pent) ((*(pent) & 3) == 2)?
> +#define lv2ent_large(pent) ((*(pent) & 3) == 1)
> +
> +#define section_phys(sent) (*(sent) & SECT_MASK)
> +#define section_offs(iova) ((iova) & 0xFFFFF)
> +#define lpage_phys(pent) (*(pent) & LPAGE_MASK)
> +#define lpage_offs(iova) ((iova) & 0xFFFF)
> +#define spage_phys(pent) (*(pent) & SPAGE_MASK)
> +#define spage_offs(iova) ((iova) & 0xFFF)
> +
> +#define lv1ent_offset(iova) ((iova) >> SECT_ORDER)
> +#define lv2ent_offset(iova) (((iova) & 0xFF000) >> SPAGE_ORDER)
> +
> +#define NUM_LV1ENTRIES 4096
> +#define NUM_LV2ENTRIES 256
> +
> +#define LV2TABLE_SIZE (NUM_LV2ENTRIES * sizeof(long))
> +
> +#define SPAGES_PER_LPAGE (LPAGE_SIZE / SPAGE_SIZE)
> +
> +#define lv2table_base(sent) (*(sent) & 0xFFFFFC00)
> +
> +#define mk_lv1ent_sect(pa) ((pa) | 2)
> +#define mk_lv1ent_page(pa) ((pa) | 1)
> +#define mk_lv2ent_lpage(pa) ((pa) | 1)
> +#define mk_lv2ent_spage(pa) ((pa) | 2)
> +
> +#define CTRL_ENABLE    0x5
> +#define CTRL_BLOCK     0x7
> +#define CTRL_DISABLE   0x0
> +
> +#define REG_MMU_CTRL           0x000
> +#define REG_MMU_CFG            0x004
> +#define REG_MMU_STATUS         0x008
> +#define REG_MMU_FLUSH          0x00C
> +#define REG_MMU_FLUSH_ENTRY    0x010
> +#define REG_PT_BASE_ADDR       0x014
> +#define REG_INT_STATUS         0x018
> +#define REG_INT_CLEAR          0x01C
> +#define REG_MMU_VERSION                0x034
Please place it in order.
> +
> +#define REG_PAGE_FAULT_ADDR    0x024
> +#define REG_AW_FAULT_ADDR      0x028
> +#define REG_AR_FAULT_ADDR      0x02C
> +#define REG_DEFAULT_SLAVE_ADDR 0x030
> +
> +static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
> +{
> +       return pgtable + lv1ent_offset(iova);
> +}
> +
> +static unsigned long *page_entry(unsigned long *sent, unsigned long iova)
> +{
> +       return (unsigned long *)__va(lv2table_base(sent)) + lv2ent_offset(iova);
> +}
> +
> +enum EXYNOS_SYSMMU_INTERRUPT_TYPE {
> +       SYSMMU_PAGEFAULT,
> +       SYSMMU_AR_MULTIHIT,
> +       SYSMMU_AW_MULTIHIT,
> +       SYSMMU_BUSERROR,
> +       SYSMMU_AR_SECURITY,
> +       SYSMMU_AR_ACCESS,
> +       SYSMMU_AW_SECURITY,
> +       SYSMMU_AW_PROTECTION, /* 7 */
> +       SYSMMU_FAULT_UNKNOWN,
> +       SYSMMU_FAULTS_NUM
missing comma, "SYSMMU_FAULTS_NUM,"
> +};
> +
> +typedef int (*sysmmu_fault_handler_t)(enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype,
> +                       unsigned long pgtable_base, unsigned long fault_addr);
> +
> +static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
> +       REG_PAGE_FAULT_ADDR,
> +       REG_AR_FAULT_ADDR,
> +       REG_AW_FAULT_ADDR,
> +       REG_DEFAULT_SLAVE_ADDR,
> +       REG_AR_FAULT_ADDR,
> +       REG_AR_FAULT_ADDR,
> +       REG_AW_FAULT_ADDR,
> +       REG_AW_FAULT_ADDR
ditto.
> +};
> +
> +static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
> +       "PAGE FAULT",
> +       "AR MULTI-HIT FAULT",
> +       "AW MULTI-HIT FAULT",
> +       "BUS ERROR",
> +       "AR SECURITY PROTECTION FAULT",
> +       "AR ACCESS PROTECTION FAULT",
> +       "AW SECURITY PROTECTION FAULT",
> +       "AW ACCESS PROTECTION FAULT",
> +       "UNKNOWN FAULT"
ditto.
> +};
> +
> +/* We does not consider super section mapping (16MB) */
> +struct iommu_client {
> +       struct list_head node;
> +       struct device *dev;
> +       int refcnt;
> +};
> +
> +struct exynos_iommu_domain {
> +       struct list_head clients; /* list of iommu_client */
> +       unsigned long *pgtable; /* lv1 page table, 16KB */
> +       short *lv2entcnt; /* free lv2 entry counter for each section */
> +       spinlock_t lock; /* lock for this structure and attached iommu_client */
> +       spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
> +};
> +
> +struct sysmmu_drvdata {
> +       struct device *sysmmu;
> +       char *dbgname;
> +       int nsfrs;
> +       void __iomem **sfrbases;
> +       struct clk *clk[2];
> +       bool active;
> +       rwlock_t lock;
> +       struct iommu_domain *domain;
> +       sysmmu_fault_handler_t fault_handler;
> +       unsigned long pgtable;
> +       struct iommu_client client;
> +};
> +
> +static bool set_sysmmu_active(struct sysmmu_drvdata *data)
> +{
> +       /* return true if the System MMU was not active previously
> +          and it needs to be initialized */
> +       if (WARN_ON_ONCE(data->active))
> +               return false;
> +       data->active = true;
> +       return true;
> +}
> +
> +static bool set_sysmmu_inactive(struct sysmmu_drvdata *data)
> +{
> +       /* return true if the System MMU is needed to be disabled */
> +       if (WARN_ON_ONCE(!data->active))
> +               return false;
> +       data->active = false;
> +       return true;
> +}
> +
> +static bool is_sysmmu_active(struct sysmmu_drvdata *data)
> +{
> +       return data->active;
> +}
> +
> +static void sysmmu_block(void __iomem *sfrbase)
> +{
> +       __raw_writel(CTRL_BLOCK, sfrbase + REG_MMU_CTRL);
> +}
> +
> +static void sysmmu_unblock(void __iomem *sfrbase)
> +{
> +       __raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
> +}
> +
> +static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
> +{
> +       __raw_writel(0x1, sfrbase + REG_MMU_FLUSH);
> +}
> +
> +static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
> +                                               unsigned long iova)
> +{
> +       __raw_writel((iova & SPAGE_MASK) | 1, sfrbase + REG_MMU_FLUSH_ENTRY);
> +}
> +
> +static void __sysmmu_set_ptbase(void __iomem *sfrbase,
> +                                      unsigned long pgd)
> +{
> +       __raw_writel(0x1, sfrbase + REG_MMU_CFG); /* 16KB LV1, LRU */
> +       __raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
> +
> +       __sysmmu_tlb_invalidate(sfrbase);
> +}
> +
> +static void __sysmmu_set_prefbuf(void __iomem *sfrbase, unsigned long base,
> +                                               unsigned long size, int idx)
> +{
> +       __raw_writel(base, sfrbase + S5P_PB0_SADDR + idx * 8);
> +       __raw_writel(size - 1 + base,  sfrbase + S5P_PB0_EADDR + idx * 8);
> +}
> +
> +void exynos_sysmmu_set_prefbuf(struct device *dev,
> +                               unsigned long base0, unsigned long size0,
> +                               unsigned long base1, unsigned long size1)
> +{
> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +       unsigned long flags;
> +       int i;
> +
> +       BUG_ON((base0 + size0) <= base0);
> +       BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
It's bogus check. it's impossible. Do you think overflow case?
> +
> +       read_lock_irqsave(&data->lock, flags);
> +       if (!is_sysmmu_active(data))
> +               goto finish;
> +
> +       for (i = 0; i < data->nsfrs; i++) {
> +               if ((readl(data->sfrbases[i] + S5P_MMU_VERSION) >> 28) == 3) {
> +                       sysmmu_block(data->sfrbases[i]);
> +
> +                       if (size1 == 0) {
> +                               if (size0 <= SZ_128K) {
> +                                       base1 = base0;
> +                                       size1 = size0;
> +                               } else {
> +                                       size1 = size0 -
> +                                               ALIGN(size0 / 2, SZ_64K);
> +                                       size0 = size0 - size1;
Umm I mis-understand this codes at first. it think size1 has 0
already. so it's meaning-less but now it re-use the size1 above.
> +                                       base1 = base0 + size0;
> +                               }
> +                       }
> +
> +                       __sysmmu_set_prefbuf(
> +                                       data->sfrbases[i], base0, size0, 0);
> +                       __sysmmu_set_prefbuf(
> +                                       data->sfrbases[i], base1, size1, 1);
> +
> +                       sysmmu_unblock(data->sfrbases[i]);
> +               }
> +       }
> +finish:
> +       read_unlock_irqrestore(&data->lock, flags);
> +}
> +
> +static void __set_fault_handler(struct sysmmu_drvdata *data,
> +                                       sysmmu_fault_handler_t handler)
> +{
> +       unsigned long flags;
> +
> +       write_lock_irqsave(&data->lock, flags);
> +       data->fault_handler = handler;
> +       write_unlock_irqrestore(&data->lock, flags);
> +}
> +
> +void exynos_sysmmu_set_fault_handler(struct device *dev,
> +                                       sysmmu_fault_handler_t handler)
> +{
> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +
> +       __set_fault_handler(data, handler);
> +}
> +
> +static int default_fault_handler(enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype,
Can you use the small letter instead of large one? do you see codes like this?
> +                    unsigned long pgtable_base, unsigned long fault_addr)
> +{
> +       unsigned long *ent;
> +
> +       if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
> +               itype = SYSMMU_FAULT_UNKNOWN;
> +
> +       pr_err("%s occured at 0x%lx(Page table base: 0x%lx)\n",
> +                       sysmmu_fault_name[itype], fault_addr, pgtable_base);
> +
> +       ent = section_entry(__va(pgtable_base), fault_addr);
> +       pr_err("\tLv1 entry: 0x%lx\n", *ent);
> +
> +       if (lv1ent_page(ent)) {
> +               ent = page_entry(ent, fault_addr);
> +               pr_err("\t Lv2 entry: 0x%lx\n", *ent);
> +       }
> +
> +       pr_err("Generating Kernel OOPS... because it is unrecoverable.\n");
> +
> +       BUG();
> +
> +       return 0;
> +}
> +
> +static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> +{
> +       /* SYSMMU is in blocked when interrupt occurred. */
> +       struct sysmmu_drvdata *data = dev_id;
> +       struct resource *irqres;
> +       struct platform_device *pdev;
> +       enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype;
> +       unsigned long addr = -1;
> +
> +       int i, ret = -ENOSYS;
> +
> +       read_lock(&data->lock);
> +
> +       WARN_ON(!is_sysmmu_active(data));
> +
> +       pdev = to_platform_device(data->sysmmu);
> +       for (i = 0; i < pdev->num_resources; i++) {
> +               irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
> +               if (irqres && ((int)irqres->start == irq))
> +                       break;
> +       }
> +
> +       if (i == pdev->num_resources) {
> +               itype = SYSMMU_FAULT_UNKNOWN;
> +       } else {
> +               i /= 2;
> +
> +               itype = (enum EXYNOS_SYSMMU_INTERRUPT_TYPE)
> +                       __ffs(__raw_readl(data->sfrbases[i] + REG_INT_STATUS));
> +               if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
> +                       itype = SYSMMU_FAULT_UNKNOWN;
> +               else
> +                       addr = __raw_readl(
> +                               data->sfrbases[i] + fault_reg_offset[itype]);
> +       }
> +
> +       if (data->domain)
> +               ret = report_iommu_fault(data->domain, data->client.dev,
> +                               addr, itype);
> +
> +       if ((ret == -ENOSYS) && data->fault_handler) {
> +               unsigned long base = data->pgtable;
> +               if (itype != SYSMMU_FAULT_UNKNOWN)
> +                       base = __raw_readl(
> +                                       data->sfrbases[i] + REG_PT_BASE_ADDR);
> +               ret = data->fault_handler(itype, base, addr);
> +       }
> +
> +       if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
> +               __raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
> +       else
> +               dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
> +                               data->dbgname, sysmmu_fault_name[itype]);
> +
> +       if (itype != SYSMMU_FAULT_UNKNOWN)
> +               sysmmu_unblock(data->sfrbases[i]);
> +
> +       read_unlock(&data->lock);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static bool __sysmmu_disable(struct sysmmu_drvdata *data)
> +{
> +       unsigned long flags;
> +       bool disabled = false;
> +       int i;
> +
> +       write_lock_irqsave(&data->lock, flags);
> +
> +       if (!set_sysmmu_inactive(data))
> +               goto finish;
> +
> +       for (i = 0; i < data->nsfrs; i++) {
> +               __raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
> +               if (data->clk[1])
> +                       clk_disable(data->clk[1]);
> +               if (data->clk[0])
> +                       clk_disable(data->clk[0]);
> +               disabled = true;
> +               data->pgtable = 0;
> +               data->domain = NULL;
> +               pm_runtime_put(data->sysmmu);
> +       }
> +
> +finish:
> +       write_unlock_irqrestore(&data->lock, flags);
> +
> +       return disabled;
> +}
> +
> +/* __exynos_sysmmu_enable: Enables System MMU
> + *
> + * returns -error if an error occurred and System MMU is not enabled,
> + * 0 if the System MMU has been just enabled and 1 if System MMU was already
> + * enabled before.
> + */
> +static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
> +                                               struct iommu_domain *domain)
> +{
> +       int i, ret = 0;
> +       unsigned long flags;
> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +
> +       BUG_ON(!memblock_is_memory(pgtable));
> +
> +       ret = pm_runtime_get_sync(data->sysmmu);
> +       if (ret < 0)
> +               return ret;
> +
> +       write_lock_irqsave(&data->lock, flags);
> +
> +       if (!set_sysmmu_active(data)) {
> +               /* RPM of sysmmu won't be refcounted */
> +               if (ret > 0)
> +                       pm_runtime_put(data->sysmmu);
> +
> +               if (WARN_ON(pgtable != data->pgtable)) {
> +                       set_sysmmu_inactive(data);
> +                       ret = -EBUSY;
> +               }
> +
> +               ret = 1;
> +               dev_dbg(data->sysmmu, "(%s) Already enabled\n", data->dbgname);
> +               goto finish;
> +       }
> +
> +       if (data->clk[0])
> +               clk_enable(data->clk[0]);
> +       if (data->clk[1])
> +               clk_enable(data->clk[1]);
> +
> +       data->pgtable = pgtable;
> +
> +       for (i = 0; i < data->nsfrs; i++) {
> +               __sysmmu_set_ptbase(data->sfrbases[i], pgtable);
> +
> +               if ((readl(data->sfrbases[i] + S5P_MMU_VERSION) >> 28) == 3) {
> +                       /* System MMU version is 3.x */
> +                       __raw_writel((1 << 12) | (2 << 28),
> +                                       data->sfrbases[i] + S5P_MMU_CFG);
> +                       __sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
> +                       __sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
> +               }
> +
> +               __raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
> +       }
> +
> +       data->domain = domain;
> +
> +       dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
> +finish:
> +       write_unlock_irqrestore(&data->lock, flags);
> +
> +       if (ret < 0) {
> +               __sysmmu_disable(data);
> +               dev_dbg(data->sysmmu, "(%s) Failed to enable\n", data->dbgname);
> +       }
> +
> +       return ret;
> +}
> +
> +static struct iommu_client *__get_enabled_iommu_client(
> +                               struct iommu_domain *domain, struct device *dev)
> +{
> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +       struct exynos_iommu_domain *priv = domain->priv;
> +       int ret;
> +
> +       ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
> +       if (ret < 0)
> +               return ERR_PTR(ret);
> +       else if (ret == 1)
> +               return ERR_PTR(-EBUSY);
> +
> +       INIT_LIST_HEAD(&data->client.node);
> +       data->client.dev = dev;
> +       data->client.refcnt = 1;
> +
> +       return &data->client;
> +}
> +
> +int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
> +{
> +       return __exynos_sysmmu_enable(dev, pgtable, NULL);
> +}
> +
> +void exynos_sysmmu_disable(struct device *dev)
> +{
> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +       bool disabled;
> +
> +       disabled = __sysmmu_disable(data);
> +       dev_dbg(data->sysmmu,
> +                       disabled ? "(%s) Disabled.\n" :
> +                               "(%s) Deactivation request ignorred.\n",
> +                       data->dbgname);
> +}
> +
> +static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
> +{
> +       unsigned long flags;
> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +
> +       read_lock_irqsave(&data->lock, flags);
> +
> +       if (is_sysmmu_active(data)) {
> +               int i;
> +               for (i = 0; i < data->nsfrs; i++) {
> +                       sysmmu_block(data->sfrbases[i]);
> +                       __sysmmu_tlb_invalidate_entry(data->sfrbases[i], iova);
> +                       sysmmu_unblock(data->sfrbases[i]);
> +               }
> +       } else {
> +               dev_dbg(data->sysmmu,
> +                       "(%s) Disabled. Skipping invalidating TLB.\n",
> +                       data->dbgname);
> +       }
> +
> +       read_unlock_irqrestore(&data->lock, flags);
> +}
> +
> +void exynos_sysmmu_tlb_invalidate(struct device *dev)
> +{
> +       unsigned long flags;
> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +
> +       read_lock_irqsave(&data->lock, flags);
> +
> +       if (is_sysmmu_active(data)) {
> +               int i;
> +               for (i = 0; i < data->nsfrs; i++) {
> +                       sysmmu_block(data->sfrbases[i]);
> +                       __sysmmu_tlb_invalidate(data->sfrbases[i]);
> +                       sysmmu_unblock(data->sfrbases[i]);
> +               }
> +       } else {
> +               dev_dbg(data->sysmmu,
> +                       "(%s) Disabled. Skipping invalidating TLB.\n",
> +                       data->dbgname);
> +       }
> +
> +       read_unlock_irqrestore(&data->lock, flags);
> +}
> +
> +static int exynos_sysmmu_probe(struct platform_device *pdev)
> +{
> +       int i, ret;
> +       struct device *dev;
> +       struct sysmmu_drvdata *data;
> +
> +       dev = &pdev->dev;
> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data) {
> +               dev_dbg(dev, "Not enough memory\n");
> +               ret = -ENOMEM;
> +               goto err_alloc;
> +       }
> +
> +       ret = dev_set_drvdata(dev, data);
> +       if (ret) {
> +               dev_dbg(dev, "Unabled to initialize driver data\n");
> +               goto err_init;
> +       }
> +
> +       data->nsfrs = pdev->num_resources / 2;
> +       data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
> +                                                               GFP_KERNEL);
> +       if (data->sfrbases == NULL) {
> +               dev_dbg(dev, "Not enough memory\n");
> +               ret = -ENOMEM;
> +               goto err_init;
> +       }
> +
> +       for (i = 0; i < data->nsfrs; i++) {
> +               struct resource *res;
> +               res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> +               if (!res) {
> +                       dev_dbg(dev, "Unable to find IOMEM region\n");
> +                       ret = -ENOENT;
> +                       goto err_res;
> +               }
> +
> +               data->sfrbases[i] = ioremap(res->start, resource_size(res));
> +               if (!data->sfrbases[i]) {
> +                       dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n",
> +                                                       res->start);
> +                       ret = -ENOENT;
> +                       goto err_res;
> +               }
> +       }
> +
> +       for (i = 0; i < data->nsfrs; i++) {
> +               ret = platform_get_irq(pdev, i);
> +               if (ret <= 0) {
> +                       dev_dbg(dev, "Unable to find IRQ resource\n");
> +                       goto err_irq;
> +               }
> +
> +               ret = request_irq(ret, exynos_sysmmu_irq, 0,
> +                                       dev_name(dev), data);
> +               if (ret) {
> +                       dev_dbg(dev, "Unabled to register interrupt handler\n");
> +                       goto err_irq;
> +               }
> +       }
> +
> +       if (dev_get_platdata(dev)) {
> +               char *deli, *beg;
> +               struct sysmmu_platform_data *platdata = dev_get_platdata(dev);
> +
> +               beg = platdata->clockname;
> +
> +               for (deli = beg; (*deli != '\0') && (*deli != ','); deli++)
> +                       /* NOTHING */;
> +
> +               if (*deli == '\0')
> +                       deli = NULL;
> +               else
> +                       *deli = '\0';
> +
> +               data->clk[0] = clk_get(dev, beg);
> +               if (IS_ERR(data->clk[0])) {
> +                       data->clk[0] = NULL;
> +                       dev_dbg(dev, "No clock descriptor registered\n");
> +               }
> +
> +               if (data->clk[0] && deli) {
> +                       *deli = ',';
> +                       data->clk[1] = clk_get(dev, deli + 1);
> +                       if (IS_ERR(data->clk[1]))
> +                               data->clk[1] = NULL;
> +               }
> +
> +               data->dbgname = platdata->dbgname;
> +       }
> +
> +       data->sysmmu = dev;
> +       rwlock_init(&data->lock);
> +
> +       __set_fault_handler(data, &default_fault_handler);
> +
> +       if (dev->parent)
> +               pm_runtime_enable(dev);
> +
> +       dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
> +       return 0;
> +err_irq:
> +       while (i-- > 0) {
> +               int irq;
> +
> +               irq = platform_get_irq(pdev, i);
> +               free_irq(irq, data);
> +       }
> +err_res:
> +       while (data->nsfrs-- > 0)
> +               iounmap(data->sfrbases[data->nsfrs]);
> +       kfree(data->sfrbases);
> +err_init:
> +       kfree(data);
> +err_alloc:
> +       dev_err(dev, "Failed to initialize\n");
> +       return ret;
> +}
> +
> +static struct platform_driver exynos_sysmmu_driver = {
> +       .probe          = exynos_sysmmu_probe,
> +       .driver         = {
> +               .owner          = THIS_MODULE,
> +               .name           = "exynos-sysmmu",
> +       }
> +};
> +
> +static inline void pgtable_flush(void *vastart, void *vaend)
> +{
> +       dmac_flush_range(vastart, vaend);
> +       outer_flush_range(virt_to_phys(vastart),
> +                               virt_to_phys(vaend));
> +}
> +
> +static int exynos_iommu_domain_init(struct iommu_domain *domain)
> +{
> +       struct exynos_iommu_domain *priv;
> +
> +       priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +       if (!priv)
> +               return -ENOMEM;
> +
> +       priv->pgtable = (unsigned long *)__get_free_pages(
> +                                               GFP_KERNEL | __GFP_ZERO, 2);
> +       if (!priv->pgtable)
> +               goto err_pgtable;
> +
> +       priv->lv2entcnt = (short *)__get_free_pages(
> +                                               GFP_KERNEL | __GFP_ZERO, 1);
> +       if (!priv->lv2entcnt)
> +               goto err_counter;
> +
> +       pgtable_flush(priv->pgtable, priv->pgtable + NUM_LV1ENTRIES);
> +
> +       spin_lock_init(&priv->lock);
> +       spin_lock_init(&priv->pgtablelock);
> +       INIT_LIST_HEAD(&priv->clients);
> +
> +       domain->priv = priv;
> +       return 0;
> +
> +err_counter:
> +       free_pages((unsigned long)priv->pgtable, 2);
> +err_pgtable:
> +       kfree(priv);
> +       return -ENOMEM;
> +}
> +
> +static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> +{
> +       struct exynos_iommu_domain *priv = domain->priv;
> +       struct list_head *pos, *n;
> +       unsigned long flags;
> +       int i;
> +
> +       WARN_ON(!list_empty(&priv->clients));
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +
> +       list_for_each_safe(pos, n, &priv->clients) {
> +               struct iommu_client *client;
> +
> +               client = list_entry(pos, struct iommu_client, node);
> +               exynos_sysmmu_disable(client->dev);
> +               kfree(client);
> +       }
> +
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +
> +       for (i = 0; i < NUM_LV1ENTRIES; i++)
> +               if (lv1ent_page(priv->pgtable + i))
> +                       kfree(__va(lv2table_base(priv->pgtable + i)));
> +
> +       free_pages((unsigned long)priv->pgtable, 2);
> +       free_pages((unsigned long)priv->lv2entcnt, 1);
> +       kfree(domain->priv);
> +       domain->priv = NULL;
> +}
> +
> +static int exynos_iommu_attach_device(struct iommu_domain *domain,
> +                                  struct device *dev)
> +{
> +       struct exynos_iommu_domain *priv = domain->priv;
> +       struct iommu_client *client = NULL;
> +       struct list_head *pos;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +
> +       list_for_each(pos, &priv->clients) {
> +               struct iommu_client *cur;
> +
> +               cur = list_entry(pos, struct iommu_client, node);
> +               if (cur->dev == dev) {
> +                       client = cur;
> +                       break;
> +               }
> +       }
> +
> +       if (client != NULL)
> +               client->refcnt++;
> +
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +
> +       if (client != NULL) {
> +               dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
> +                                       __func__, __pa(priv->pgtable));
> +               return 0;
> +       }
> +
> +       client = __get_enabled_iommu_client(domain, dev);
> +       if (IS_ERR(client))
> +               return PTR_ERR(client);
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +       list_add_tail(&client->node, &priv->clients);
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +
> +       dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n", __func__,
> +                                               __pa(priv->pgtable));
> +       return 0;
> +}
> +
> +static void exynos_iommu_detach_device(struct iommu_domain *domain,
> +                                   struct device *dev)
> +{
> +       struct exynos_iommu_domain *priv = domain->priv;
> +       struct iommu_client *client = NULL;
> +       struct list_head *pos;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +
> +       list_for_each(pos, &priv->clients) {
> +               struct iommu_client *cur;
> +
> +               cur = list_entry(pos, struct iommu_client, node);
> +               if (cur->dev == dev) {
> +                       cur->refcnt--;
> +                       client = cur;
> +                       break;
> +               }
> +       }
> +
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +
> +       if (WARN_ON(client == NULL))
> +               return;
> +
> +       if (client->refcnt > 0) {
> +               dev_dbg(dev,
> +                       "IOMMU is still attached %d times with pgtable %#lx\n",
> +                                       client->refcnt, __pa(priv->pgtable));
> +               return;
> +       }
> +
> +       list_del(&client->node);
> +       exynos_sysmmu_disable(client->dev);
> +       dev_dbg(dev, "%s: Detached IOMMU with pgtable 0x%lx\n", __func__,
> +                                               __pa(priv->pgtable));
> +}
> +
> +static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
> +                                       short *pgcounter)
> +{
> +       if (lv1ent_fault(sent)) {
> +               unsigned long *pent;
> +
> +               pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
> +               BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
> +               if (!pent)
> +                       return NULL;
> +
> +               *sent = mk_lv1ent_page(__pa(pent));
> +               *pgcounter = NUM_LV2ENTRIES;
> +               pgtable_flush(pent, pent + NUM_LV2ENTRIES);
> +               pgtable_flush(sent, sent + 1);
> +       }
> +
> +       return page_entry(sent, iova);
> +}
> +
> +static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
> +{
> +       if (lv1ent_section(sent))
> +               return -EADDRINUSE;
> +
> +       if (lv1ent_page(sent)) {
> +               if (*pgcnt != NUM_LV2ENTRIES)
> +                       return -EADDRINUSE;
> +
> +               kfree(page_entry(sent, 0));
> +
> +               *pgcnt = 0;
> +       }
> +
> +       *sent = mk_lv1ent_sect(paddr);
> +
> +       pgtable_flush(sent, sent + 1);
> +
> +       return 0;
> +}
> +
> +static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
> +                                                               short *pgcnt)
> +{
> +       if (size == SPAGE_SIZE) {
> +               if (!lv2ent_fault(pent))
> +                       return -EADDRINUSE;
> +
> +               *pent = mk_lv2ent_spage(paddr);
> +               pgtable_flush(pent, pent + 1);
> +               *pgcnt -= 1;
> +       } else { /* size == LPAGE_SIZE */
> +               int i;
> +               for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
> +                       if (!lv2ent_fault(pent)) {
> +                               memset(pent, 0, sizeof(*pent) * i);
> +                               return -EADDRINUSE;
> +                       }
> +
> +                       *pent = mk_lv2ent_lpage(paddr);
> +               }
> +               pgtable_flush(pent - SPAGES_PER_LPAGE, pent);
> +               *pgcnt -= SPAGES_PER_LPAGE;
> +       }
> +
> +       return 0;
> +}
> +
> +static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
> +                        phys_addr_t paddr, size_t size, int prot)
> +{
> +       struct exynos_iommu_domain *priv = domain->priv;
> +       unsigned long *entry;
> +       unsigned long flags;
> +       int ret = -ENOMEM;
> +
> +       BUG_ON(priv->pgtable == NULL);
> +
> +       spin_lock_irqsave(&priv->pgtablelock, flags);
> +
> +       entry = section_entry(priv->pgtable, iova);
> +
> +       if (size == SECT_SIZE) {
> +               ret = lv1set_section(entry, paddr,
> +                                       &priv->lv2entcnt[lv1ent_offset(iova)]);
> +       } else {
> +               unsigned long *pent;
> +
> +               pent = alloc_lv2entry(entry, iova,
> +                                       &priv->lv2entcnt[lv1ent_offset(iova)]);
> +
> +               if (!pent)
> +                       ret = -ENOMEM;
> +               else
> +                       ret = lv2set_page(pent, paddr, size,
> +                                       &priv->lv2entcnt[lv1ent_offset(iova)]);
> +       }
> +
> +       if (ret) {
> +               pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
> +                                                       __func__, iova, size);
> +       }
> +
> +       spin_unlock_irqrestore(&priv->pgtablelock, flags);
> +
> +       return ret;
> +}
> +
> +static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> +                                              unsigned long iova, size_t size)
> +{
> +       struct exynos_iommu_domain *priv = domain->priv;
> +       struct iommu_client *client;
> +       unsigned long flags;
> +       unsigned long *ent;
> +
> +       BUG_ON(priv->pgtable == NULL);
> +
> +       spin_lock_irqsave(&priv->pgtablelock, flags);
> +
> +       ent = section_entry(priv->pgtable, iova);
> +
> +       if (lv1ent_section(ent)) {
> +               BUG_ON(size < SECT_SIZE);
> +
> +               *ent = 0;
> +               pgtable_flush(ent, ent + 1);
> +               size = SECT_SIZE;
> +               goto done;
> +       }
> +
> +       if (unlikely(lv1ent_fault(ent))) {
> +               if (size > SECT_SIZE)
> +                       size = SECT_SIZE;
> +               goto done;
> +       }
> +
> +       /* lv1ent_page(sent) == true here */
> +
> +       ent = page_entry(ent, iova);
> +
> +       if (unlikely(lv2ent_fault(ent))) {
> +               size = SPAGE_SIZE;
> +               goto done;
> +       }
> +
> +       if (lv2ent_small(ent)) {
> +               *ent = 0;
> +               size = SPAGE_SIZE;
> +               priv->lv2entcnt[lv1ent_offset(iova)] -= 1;
> +               goto done;
> +       }
> +
> +       /* lv1ent_large(ent) == true here */
> +       BUG_ON(size < LPAGE_SIZE);
> +
> +       memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
> +
> +       size = LPAGE_SIZE;
> +       priv->lv2entcnt[lv1ent_offset(iova)] -= SPAGES_PER_LPAGE;
> +done:
> +       list_for_each_entry(client, &priv->clients, node)
> +               sysmmu_tlb_invalidate_entry(client->dev, iova);
> +
> +       spin_unlock_irqrestore(&priv->pgtablelock, flags);
> +
> +       return size;
> +}
> +
> +static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
> +                                         unsigned long iova)
> +{
> +       struct exynos_iommu_domain *priv = domain->priv;
> +       unsigned long *entry;
> +       unsigned long flags;
> +       phys_addr_t phys = -1;
> +
> +       spin_lock_irqsave(&priv->pgtablelock, flags);
> +
> +       entry = section_entry(priv->pgtable, iova);
> +
> +       if (lv1ent_section(entry)) {
> +               phys = section_phys(entry) + section_offs(iova);
> +       } else if (lv1ent_page(entry)) {
> +               entry = page_entry(entry, iova);
> +
> +               if (lv2ent_large(entry))
> +                       phys = lpage_phys(entry) + lpage_offs(iova);
> +               else if (lv2ent_small(entry))
> +                       phys = spage_phys(entry) + spage_offs(iova);
> +       }
> +
> +       spin_unlock_irqrestore(&priv->pgtablelock, flags);
> +
> +       return phys;
What's happened if phys has -1? I mean it can't trigger any condition at above.
> +}
> +
> +static struct iommu_ops exynos_iommu_ops = {
> +       .domain_init = &exynos_iommu_domain_init,
> +       .domain_destroy = &exynos_iommu_domain_destroy,
> +       .attach_dev = &exynos_iommu_attach_device,
> +       .detach_dev = &exynos_iommu_detach_device,
> +       .map = &exynos_iommu_map,
> +       .unmap = &exynos_iommu_unmap,
> +       .iova_to_phys = &exynos_iommu_iova_to_phys,
> +       .pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
> +};
> +
> +static int __init exynos_iommu_init(void)
> +{
> +       int ret;
> +
> +       ret = platform_driver_register(&exynos_sysmmu_driver);
> +
> +       if (ret == 0)
> +               bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> +
> +       return ret;
> +}
> +arch_initcall(exynos_iommu_init);
> --
> 1.7.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
