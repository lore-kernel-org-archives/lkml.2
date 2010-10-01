Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0JACAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:00:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42545 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab0JAB7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:59:39 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>, <nm@ti.com>,
        <Hiroshi.DOYU@nokia.com>, <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv2 06/11] staging: tidspbrge - remove hw directory
Date: Thu, 30 Sep 2010 21:12:53 -0500
Message-Id: <1285899178-14413-7-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285899178-14413-6-git-send-email-x0095840@ti.com>
References: <1285899178-14413-1-git-send-email-x0095840@ti.com>
 <1285899178-14413-2-git-send-email-x0095840@ti.com>
 <1285899178-14413-3-git-send-email-x0095840@ti.com>
 <1285899178-14413-4-git-send-email-x0095840@ti.com>
 <1285899178-14413-5-git-send-email-x0095840@ti.com>
 <1285899178-14413-6-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hw directory was only being used for custom iommu implementation
APIs, so after the iommu module migration this directory is not
needed anymore.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/Makefile               |    3 +-
 drivers/staging/tidspbridge/core/_tiomap.h         |    1 -
 drivers/staging/tidspbridge/core/io_sm.c           |    4 -
 drivers/staging/tidspbridge/core/tiomap3430.c      |    4 -
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    4 -
 drivers/staging/tidspbridge/core/tiomap_io.c       |    2 +-
 drivers/staging/tidspbridge/hw/EasiGlobal.h        |   41 --
 drivers/staging/tidspbridge/hw/MMUAccInt.h         |   76 ---
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |  225 --------
 drivers/staging/tidspbridge/hw/hw_defs.h           |   58 --
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  562 --------------------
 drivers/staging/tidspbridge/hw/hw_mmu.h            |  163 ------
 .../tidspbridge/include/dspbridge/dspioctl.h       |    7 -
 13 files changed, 2 insertions(+), 1148 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/hw/EasiGlobal.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMUAccInt.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMURegAcM.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_defs.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.c
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.h

diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
index 8082d5c..e09547d 100644
--- a/drivers/staging/tidspbridge/Makefile
+++ b/drivers/staging/tidspbridge/Makefile
@@ -11,10 +11,9 @@ librmgr = rmgr/dbdcd.o rmgr/disp.o rmgr/drv.o rmgr/mgr.o rmgr/node.o \
 		rmgr/nldr.o rmgr/drv_interface.o
 libdload = dynload/cload.o dynload/getsection.o dynload/reloc.o \
 		 dynload/tramp.o
-libhw = hw/hw_mmu.o
 
 bridgedriver-objs = $(libgen) $(libservices) $(libcore) $(libpmgr) $(librmgr) \
-			$(libdload) $(libhw)
+			$(libdload)
 
 #Machine dependent
 ccflags-y += -D_TI_ -D_DB_TIOMAP -DTMS32060 \
diff --git a/drivers/staging/tidspbridge/core/_tiomap.h b/drivers/staging/tidspbridge/core/_tiomap.h
index 394a64a..cd7ff88 100644
--- a/drivers/staging/tidspbridge/core/_tiomap.h
+++ b/drivers/staging/tidspbridge/core/_tiomap.h
@@ -26,7 +26,6 @@
 #include <plat/iommu.h>
 #include <plat/iovmm.h>
 #include <dspbridge/devdefs.h>
-#include <hw_defs.h>
 #include <dspbridge/dspioctl.h>	/* for bridge_ioctl_extproc defn */
 #include <dspbridge/sync.h>
 #include <dspbridge/clk.h>
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 56856ad..194bada 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -39,10 +39,6 @@
 #include <dspbridge/ntfy.h>
 #include <dspbridge/sync.h>
 
-/* Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /* Bridge Driver */
 #include <dspbridge/dspdeh.h>
 #include <dspbridge/dspio.h>
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 55ea265..58118aa 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -33,10 +33,6 @@
 #include <dspbridge/drv.h>
 #include <dspbridge/sync.h>
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /*  ----------------------------------- Link Driver */
 #include <dspbridge/dspdefs.h>
 #include <dspbridge/dspchnl.h>
diff --git a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
index b9d0753..e29b969 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
@@ -29,10 +29,6 @@
 #include <dspbridge/dev.h>
 #include <dspbridge/iodefs.h>
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 #include <dspbridge/pwr_sh.h>
 
 /*  ----------------------------------- Bridge Driver */
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index 1300bd3..63d46bc 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -141,7 +141,7 @@ int read_ext_dsp_data(struct bridge_dev_context *dev_ctxt,
 				    ul_shm_base_virt - ul_tlb_base_virt;
 				ul_shm_offset_virt +=
 				    PG_ALIGN_HIGH(ul_ext_end - ul_dyn_ext_base +
-						  1, HW_PAGE_SIZE64KB);
+						  1, PAGE_SIZE * 16);
 				dw_ext_prog_virt_mem -= ul_shm_offset_virt;
 				dw_ext_prog_virt_mem +=
 				    (ul_ext_base - ul_dyn_ext_base);
diff --git a/drivers/staging/tidspbridge/hw/EasiGlobal.h b/drivers/staging/tidspbridge/hw/EasiGlobal.h
deleted file mode 100644
index e48d7f6..0000000
--- a/drivers/staging/tidspbridge/hw/EasiGlobal.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * EasiGlobal.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _EASIGLOBAL_H
-#define _EASIGLOBAL_H
-#include <linux/types.h>
-
-/*
- * DEFINE:        READ_ONLY, WRITE_ONLY &  READ_WRITE
- *
- * DESCRIPTION: Defines used to describe register types for EASI-checker tests.
- */
-
-#define READ_ONLY    1
-#define WRITE_ONLY   2
-#define READ_WRITE   3
-
-/*
- * MACRO:        _DEBUG_LEVEL1_EASI
- *
- * DESCRIPTION:  A MACRO which can be used to indicate that a particular beach
- *               register access function was called.
- *
- * NOTE:         We currently dont use this functionality.
- */
-#define _DEBUG_LEVEL1_EASI(easi_num)     ((void)0)
-
-#endif /* _EASIGLOBAL_H */
diff --git a/drivers/staging/tidspbridge/hw/MMUAccInt.h b/drivers/staging/tidspbridge/hw/MMUAccInt.h
deleted file mode 100644
index 1cefca3..0000000
--- a/drivers/staging/tidspbridge/hw/MMUAccInt.h
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * MMUAccInt.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _MMU_ACC_INT_H
-#define _MMU_ACC_INT_H
-
-/* Mappings of level 1 EASI function numbers to function names */
-
-#define EASIL1_MMUMMU_SYSCONFIG_READ_REGISTER32 (MMU_BASE_EASIL1 + 3)
-#define EASIL1_MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32  (MMU_BASE_EASIL1 + 17)
-#define EASIL1_MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32    (MMU_BASE_EASIL1 + 39)
-#define EASIL1_MMUMMU_IRQSTATUS_WRITE_REGISTER32   (MMU_BASE_EASIL1 + 51)
-#define EASIL1_MMUMMU_IRQENABLE_READ_REGISTER32 (MMU_BASE_EASIL1 + 102)
-#define EASIL1_MMUMMU_IRQENABLE_WRITE_REGISTER32 (MMU_BASE_EASIL1 + 103)
-#define EASIL1_MMUMMU_WALKING_STTWL_RUNNING_READ32 (MMU_BASE_EASIL1 + 156)
-#define EASIL1_MMUMMU_CNTLTWL_ENABLE_READ32 (MMU_BASE_EASIL1 + 174)
-#define EASIL1_MMUMMU_CNTLTWL_ENABLE_WRITE32   (MMU_BASE_EASIL1 + 180)
-#define EASIL1_MMUMMU_CNTLMMU_ENABLE_WRITE32     (MMU_BASE_EASIL1 + 190)
-#define EASIL1_MMUMMU_FAULT_AD_READ_REGISTER32   (MMU_BASE_EASIL1 + 194)
-#define EASIL1_MMUMMU_TTB_WRITE_REGISTER32  (MMU_BASE_EASIL1 + 198)
-#define EASIL1_MMUMMU_LOCK_READ_REGISTER32   (MMU_BASE_EASIL1 + 203)
-#define EASIL1_MMUMMU_LOCK_WRITE_REGISTER32  (MMU_BASE_EASIL1 + 204)
-#define EASIL1_MMUMMU_LOCK_BASE_VALUE_READ32  (MMU_BASE_EASIL1 + 205)
-#define EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_READ32 (MMU_BASE_EASIL1 + 209)
-#define EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_WRITE32 (MMU_BASE_EASIL1 + 211)
-#define EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_SET32  (MMU_BASE_EASIL1 + 212)
-#define EASIL1_MMUMMU_LD_TLB_READ_REGISTER32    (MMU_BASE_EASIL1 + 213)
-#define EASIL1_MMUMMU_LD_TLB_WRITE_REGISTER32   (MMU_BASE_EASIL1 + 214)
-#define EASIL1_MMUMMU_CAM_WRITE_REGISTER32   (MMU_BASE_EASIL1 + 226)
-#define EASIL1_MMUMMU_RAM_WRITE_REGISTER32 (MMU_BASE_EASIL1 + 268)
-#define EASIL1_MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32  (MMU_BASE_EASIL1 + 322)
-
-/* Register offset address definitions */
-#define MMU_MMU_SYSCONFIG_OFFSET   0x10
-#define MMU_MMU_IRQSTATUS_OFFSET  0x18
-#define MMU_MMU_IRQENABLE_OFFSET    0x1c
-#define MMU_MMU_WALKING_ST_OFFSET 0x40
-#define MMU_MMU_CNTL_OFFSET   0x44
-#define MMU_MMU_FAULT_AD_OFFSET  0x48
-#define MMU_MMU_TTB_OFFSET  0x4c
-#define MMU_MMU_LOCK_OFFSET   0x50
-#define MMU_MMU_LD_TLB_OFFSET  0x54
-#define MMU_MMU_CAM_OFFSET   0x58
-#define MMU_MMU_RAM_OFFSET   0x5c
-#define MMU_MMU_GFLUSH_OFFSET  0x60
-#define MMU_MMU_FLUSH_ENTRY_OFFSET  0x64
-/* Bitfield mask and offset declarations */
-#define MMU_MMU_SYSCONFIG_IDLE_MODE_MASK  0x18
-#define MMU_MMU_SYSCONFIG_IDLE_MODE_OFFSET  3
-#define MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK  0x1
-#define MMU_MMU_SYSCONFIG_AUTO_IDLE_OFFSET   0
-#define MMU_MMU_WALKING_ST_TWL_RUNNING_MASK 0x1
-#define MMU_MMU_WALKING_ST_TWL_RUNNING_OFFSET  0
-#define MMU_MMU_CNTL_TWL_ENABLE_MASK 0x4
-#define MMU_MMU_CNTL_TWL_ENABLE_OFFSET 2
-#define MMU_MMU_CNTL_MMU_ENABLE_MASK    0x2
-#define MMU_MMU_CNTL_MMU_ENABLE_OFFSET   1
-#define MMU_MMU_LOCK_BASE_VALUE_MASK 0xfc00
-#define MMU_MMU_LOCK_BASE_VALUE_OFFSET   10
-#define MMU_MMU_LOCK_CURRENT_VICTIM_MASK   0x3f0
-#define MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET    4
-
-#endif /* _MMU_ACC_INT_H */
diff --git a/drivers/staging/tidspbridge/hw/MMURegAcM.h b/drivers/staging/tidspbridge/hw/MMURegAcM.h
deleted file mode 100644
index ab1a16d..0000000
--- a/drivers/staging/tidspbridge/hw/MMURegAcM.h
+++ /dev/null
@@ -1,225 +0,0 @@
-/*
- * MMURegAcM.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _MMU_REG_ACM_H
-#define _MMU_REG_ACM_H
-
-#include <linux/io.h>
-#include <EasiGlobal.h>
-
-#include "MMUAccInt.h"
-
-#if defined(USE_LEVEL_1_MACROS)
-
-#define MMUMMU_SYSCONFIG_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_SYSCONFIG_OFFSET))
-
-#define MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32);\
-    data &= ~(MMU_MMU_SYSCONFIG_IDLE_MODE_MASK);\
-    new_value <<= MMU_MMU_SYSCONFIG_IDLE_MODE_OFFSET;\
-    new_value &= MMU_MMU_SYSCONFIG_IDLE_MODE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32);\
-    data &= ~(MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK);\
-    new_value <<= MMU_MMU_SYSCONFIG_AUTO_IDLE_OFFSET;\
-    new_value &= MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_IRQSTATUS_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(easil1_mmummu_irqstatus_read_register32),\
-      __raw_readl((base_address)+MMU_MMU_IRQSTATUS_OFFSET))
-
-#define MMUMMU_IRQSTATUS_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_IRQSTATUS_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQSTATUS_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_IRQENABLE_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_IRQENABLE_OFFSET))
-
-#define MMUMMU_IRQENABLE_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_IRQENABLE_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_WALKING_STTWL_RUNNING_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_WALKING_STTWL_RUNNING_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_WALKING_ST_OFFSET))))\
-      & MMU_MMU_WALKING_ST_TWL_RUNNING_MASK) >>\
-      MMU_MMU_WALKING_ST_TWL_RUNNING_OFFSET))
-
-#define MMUMMU_CNTLTWL_ENABLE_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_CNTL_OFFSET)))) &\
-      MMU_MMU_CNTL_TWL_ENABLE_MASK) >>\
-      MMU_MMU_CNTL_TWL_ENABLE_OFFSET))
-
-#define MMUMMU_CNTLTWL_ENABLE_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_CNTL_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_WRITE32);\
-    data &= ~(MMU_MMU_CNTL_TWL_ENABLE_MASK);\
-    new_value <<= MMU_MMU_CNTL_TWL_ENABLE_OFFSET;\
-    new_value &= MMU_MMU_CNTL_TWL_ENABLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_CNTLMMU_ENABLE_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_CNTL_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLMMU_ENABLE_WRITE32);\
-    data &= ~(MMU_MMU_CNTL_MMU_ENABLE_MASK);\
-    new_value <<= MMU_MMU_CNTL_MMU_ENABLE_OFFSET;\
-    new_value &= MMU_MMU_CNTL_MMU_ENABLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_FAULT_AD_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FAULT_AD_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_FAULT_AD_OFFSET))
-
-#define MMUMMU_TTB_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_TTB_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_TTB_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_LOCK_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_LOCK_OFFSET))
-
-#define MMUMMU_LOCK_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_LOCK_BASE_VALUE_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_BASE_VALUE_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
-      MMU_MMU_LOCK_BASE_VALUE_MASK) >>\
-      MMU_MMU_LOCK_BASE_VALUE_OFFSET))
-
-#define MMUMMU_LOCK_BASE_VALUE_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(easil1_mmummu_lock_base_value_write32);\
-    data &= ~(MMU_MMU_LOCK_BASE_VALUE_MASK);\
-    new_value <<= MMU_MMU_LOCK_BASE_VALUE_OFFSET;\
-    new_value &= MMU_MMU_LOCK_BASE_VALUE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_LOCK_CURRENT_VICTIM_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
-      MMU_MMU_LOCK_CURRENT_VICTIM_MASK) >>\
-      MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET))
-
-#define MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_WRITE32);\
-    data &= ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK);\
-    new_value <<= MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET;\
-    new_value &= MMU_MMU_LOCK_CURRENT_VICTIM_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_LOCK_CURRENT_VICTIM_SET32(var, value)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_SET32),\
-      (((var) & ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK)) |\
-      (((value) << MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET) &\
-      MMU_MMU_LOCK_CURRENT_VICTIM_MASK)))
-
-#define MMUMMU_LD_TLB_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_LD_TLB_OFFSET))
-
-#define MMUMMU_LD_TLB_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_LD_TLB_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_CAM_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_CAM_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CAM_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_RAM_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_RAM_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_RAM_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_FLUSH_ENTRY_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#endif /* USE_LEVEL_1_MACROS */
-
-#endif /* _MMU_REG_ACM_H */
diff --git a/drivers/staging/tidspbridge/hw/hw_defs.h b/drivers/staging/tidspbridge/hw/hw_defs.h
deleted file mode 100644
index d5266d4..0000000
--- a/drivers/staging/tidspbridge/hw/hw_defs.h
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
- * hw_defs.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Global HW definitions
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _HW_DEFS_H
-#define _HW_DEFS_H
-
-/* Page size */
-#define HW_PAGE_SIZE4KB   0x1000
-#define HW_PAGE_SIZE64KB  0x10000
-#define HW_PAGE_SIZE1MB   0x100000
-#define HW_PAGE_SIZE16MB  0x1000000
-
-/* hw_status:  return type for HW API */
-typedef long hw_status;
-
-/*  Macro used to set and clear any bit */
-#define HW_CLEAR	0
-#define HW_SET		1
-
-/* hw_endianism_t:  Enumerated Type used to specify the endianism
- *		Do NOT change these values. They are used as bit fields. */
-enum hw_endianism_t {
-	HW_LITTLE_ENDIAN,
-	HW_BIG_ENDIAN
-};
-
-/* hw_element_size_t:  Enumerated Type used to specify the element size
- *		Do NOT change these values. They are used as bit fields. */
-enum hw_element_size_t {
-	HW_ELEM_SIZE8BIT,
-	HW_ELEM_SIZE16BIT,
-	HW_ELEM_SIZE32BIT,
-	HW_ELEM_SIZE64BIT
-};
-
-/* hw_idle_mode_t:  Enumerated Type used to specify Idle modes */
-enum hw_idle_mode_t {
-	HW_FORCE_IDLE,
-	HW_NO_IDLE,
-	HW_SMART_IDLE
-};
-
-#endif /* _HW_DEFS_H */
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
deleted file mode 100644
index 014f5d5..0000000
--- a/drivers/staging/tidspbridge/hw/hw_mmu.c
+++ /dev/null
@@ -1,562 +0,0 @@
-/*
- * hw_mmu.c
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * API definitions to setup MMU TLB and PTE
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#include <linux/io.h>
-#include "MMURegAcM.h"
-#include <hw_defs.h>
-#include <hw_mmu.h>
-#include <linux/types.h>
-#include <linux/err.h>
-
-#define MMU_BASE_VAL_MASK	0xFC00
-#define MMU_PAGE_MAX	     3
-#define MMU_ELEMENTSIZE_MAX      3
-#define MMU_ADDR_MASK	    0xFFFFF000
-#define MMU_TTB_MASK	     0xFFFFC000
-#define MMU_SECTION_ADDR_MASK    0xFFF00000
-#define MMU_SSECTION_ADDR_MASK   0xFF000000
-#define MMU_PAGE_TABLE_MASK      0xFFFFFC00
-#define MMU_LARGE_PAGE_MASK      0xFFFF0000
-#define MMU_SMALL_PAGE_MASK      0xFFFFF000
-
-#define MMU_LOAD_TLB	0x00000001
-#define MMU_GFLUSH	0x60
-
-/*
- * hw_mmu_page_size_t: Enumerated Type used to specify the MMU Page Size(SLSS)
- */
-enum hw_mmu_page_size_t {
-	HW_MMU_SECTION,
-	HW_MMU_LARGE_PAGE,
-	HW_MMU_SMALL_PAGE,
-	HW_MMU_SUPERSECTION
-};
-
-/*
- * FUNCTION	      : mmu_flush_entry
- *
- * INPUTS:
- *
- *       Identifier      : base_address
- *       Type		: const u32
- *       Description     : Base Address of instance of MMU module
- *
- * RETURNS:
- *
- *       Type		: hw_status
- *       Description     : 0		 -- No errors occured
- *			 RET_BAD_NULL_PARAM     -- A Pointer
- *						Paramater was set to NULL
- *
- * PURPOSE:	      : Flush the TLB entry pointed by the
- *			lock counter register
- *			even if this entry is set protected
- *
- * METHOD:	       : Check the Input parameter and Flush a
- *			 single entry in the TLB.
- */
-static hw_status mmu_flush_entry(const void __iomem *base_address);
-
-/*
- * FUNCTION	      : mmu_set_cam_entry
- *
- * INPUTS:
- *
- *       Identifier      : base_address
- *       TypE		: const u32
- *       Description     : Base Address of instance of MMU module
- *
- *       Identifier      : page_sz
- *       TypE		: const u32
- *       Description     : It indicates the page size
- *
- *       Identifier      : preserved_bit
- *       Type		: const u32
- *       Description     : It indicates the TLB entry is preserved entry
- *							or not
- *
- *       Identifier      : valid_bit
- *       Type		: const u32
- *       Description     : It indicates the TLB entry is valid entry or not
- *
- *
- *       Identifier      : virtual_addr_tag
- *       Type	    	: const u32
- *       Description     : virtual Address
- *
- * RETURNS:
- *
- *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
- *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
- *						   was set to NULL
- *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter out
- *						   of Range
- *
- * PURPOSE:	      	: Set MMU_CAM reg
- *
- * METHOD:	       	: Check the Input parameters and set the CAM entry.
- */
-static hw_status mmu_set_cam_entry(const void __iomem *base_address,
-				   const u32 page_sz,
-				   const u32 preserved_bit,
-				   const u32 valid_bit,
-				   const u32 virtual_addr_tag);
-
-/*
- * FUNCTION	      : mmu_set_ram_entry
- *
- * INPUTS:
- *
- *       Identifier      : base_address
- *       Type	    	: const u32
- *       Description     : Base Address of instance of MMU module
- *
- *       Identifier      : physical_addr
- *       Type	    	: const u32
- *       Description     : Physical Address to which the corresponding
- *			 virtual   Address shouldpoint
- *
- *       Identifier      : endianism
- *       Type	    	: hw_endianism_t
- *       Description     : endianism for the given page
- *
- *       Identifier      : element_size
- *       Type	    	: hw_element_size_t
- *       Description     : The element size ( 8,16, 32 or 64 bit)
- *
- *       Identifier      : mixed_size
- *       Type	    	: hw_mmu_mixed_size_t
- *       Description     : Element Size to follow CPU or TLB
- *
- * RETURNS:
- *
- *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
- *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
- *							was set to NULL
- *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter
- *							out of Range
- *
- * PURPOSE:	      : Set MMU_CAM reg
- *
- * METHOD:	       : Check the Input parameters and set the RAM entry.
- */
-static hw_status mmu_set_ram_entry(const void __iomem *base_address,
-				   const u32 physical_addr,
-				   enum hw_endianism_t endianism,
-				   enum hw_element_size_t element_size,
-				   enum hw_mmu_mixed_size_t mixed_size);
-
-/* HW FUNCTIONS */
-
-hw_status hw_mmu_enable(const void __iomem *base_address)
-{
-	hw_status status = 0;
-
-	MMUMMU_CNTLMMU_ENABLE_WRITE32(base_address, HW_SET);
-
-	return status;
-}
-
-hw_status hw_mmu_disable(const void __iomem *base_address)
-{
-	hw_status status = 0;
-
-	MMUMMU_CNTLMMU_ENABLE_WRITE32(base_address, HW_CLEAR);
-
-	return status;
-}
-
-hw_status hw_mmu_num_locked_set(const void __iomem *base_address,
-				u32 num_locked_entries)
-{
-	hw_status status = 0;
-
-	MMUMMU_LOCK_BASE_VALUE_WRITE32(base_address, num_locked_entries);
-
-	return status;
-}
-
-hw_status hw_mmu_victim_num_set(const void __iomem *base_address,
-				u32 victim_entry_num)
-{
-	hw_status status = 0;
-
-	MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(base_address, victim_entry_num);
-
-	return status;
-}
-
-hw_status hw_mmu_event_ack(const void __iomem *base_address, u32 irq_mask)
-{
-	hw_status status = 0;
-
-	MMUMMU_IRQSTATUS_WRITE_REGISTER32(base_address, irq_mask);
-
-	return status;
-}
-
-hw_status hw_mmu_event_disable(const void __iomem *base_address, u32 irq_mask)
-{
-	hw_status status = 0;
-	u32 irq_reg;
-
-	irq_reg = MMUMMU_IRQENABLE_READ_REGISTER32(base_address);
-
-	MMUMMU_IRQENABLE_WRITE_REGISTER32(base_address, irq_reg & ~irq_mask);
-
-	return status;
-}
-
-hw_status hw_mmu_event_enable(const void __iomem *base_address, u32 irq_mask)
-{
-	hw_status status = 0;
-	u32 irq_reg;
-
-	irq_reg = MMUMMU_IRQENABLE_READ_REGISTER32(base_address);
-
-	MMUMMU_IRQENABLE_WRITE_REGISTER32(base_address, irq_reg | irq_mask);
-
-	return status;
-}
-
-hw_status hw_mmu_event_status(const void __iomem *base_address, u32 *irq_mask)
-{
-	hw_status status = 0;
-
-	*irq_mask = MMUMMU_IRQSTATUS_READ_REGISTER32(base_address);
-
-	return status;
-}
-
-hw_status hw_mmu_fault_addr_read(const void __iomem *base_address, u32 *addr)
-{
-	hw_status status = 0;
-
-	/* read values from register */
-	*addr = MMUMMU_FAULT_AD_READ_REGISTER32(base_address);
-
-	return status;
-}
-
-hw_status hw_mmu_ttb_set(const void __iomem *base_address, u32 ttb_phys_addr)
-{
-	hw_status status = 0;
-	u32 load_ttb;
-
-	load_ttb = ttb_phys_addr & ~0x7FUL;
-	/* write values to register */
-	MMUMMU_TTB_WRITE_REGISTER32(base_address, load_ttb);
-
-	return status;
-}
-
-hw_status hw_mmu_twl_enable(const void __iomem *base_address)
-{
-	hw_status status = 0;
-
-	MMUMMU_CNTLTWL_ENABLE_WRITE32(base_address, HW_SET);
-
-	return status;
-}
-
-hw_status hw_mmu_twl_disable(const void __iomem *base_address)
-{
-	hw_status status = 0;
-
-	MMUMMU_CNTLTWL_ENABLE_WRITE32(base_address, HW_CLEAR);
-
-	return status;
-}
-
-hw_status hw_mmu_tlb_flush(const void __iomem *base_address, u32 virtual_addr,
-			   u32 page_sz)
-{
-	hw_status status = 0;
-	u32 virtual_addr_tag;
-	enum hw_mmu_page_size_t pg_size_bits;
-
-	switch (page_sz) {
-	case HW_PAGE_SIZE4KB:
-		pg_size_bits = HW_MMU_SMALL_PAGE;
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		pg_size_bits = HW_MMU_LARGE_PAGE;
-		break;
-
-	case HW_PAGE_SIZE1MB:
-		pg_size_bits = HW_MMU_SECTION;
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		pg_size_bits = HW_MMU_SUPERSECTION;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	/* Generate the 20-bit tag from virtual address */
-	virtual_addr_tag = ((virtual_addr & MMU_ADDR_MASK) >> 12);
-
-	mmu_set_cam_entry(base_address, pg_size_bits, 0, 0, virtual_addr_tag);
-
-	mmu_flush_entry(base_address);
-
-	return status;
-}
-
-hw_status hw_mmu_tlb_add(const void __iomem *base_address,
-			 u32 physical_addr,
-			 u32 virtual_addr,
-			 u32 page_sz,
-			 u32 entry_num,
-			 struct hw_mmu_map_attrs_t *map_attrs,
-			 s8 preserved_bit, s8 valid_bit)
-{
-	hw_status status = 0;
-	u32 lock_reg;
-	u32 virtual_addr_tag;
-	enum hw_mmu_page_size_t mmu_pg_size;
-
-	/*Check the input Parameters */
-	switch (page_sz) {
-	case HW_PAGE_SIZE4KB:
-		mmu_pg_size = HW_MMU_SMALL_PAGE;
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		mmu_pg_size = HW_MMU_LARGE_PAGE;
-		break;
-
-	case HW_PAGE_SIZE1MB:
-		mmu_pg_size = HW_MMU_SECTION;
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		mmu_pg_size = HW_MMU_SUPERSECTION;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	lock_reg = MMUMMU_LOCK_READ_REGISTER32(base_address);
-
-	/* Generate the 20-bit tag from virtual address */
-	virtual_addr_tag = ((virtual_addr & MMU_ADDR_MASK) >> 12);
-
-	/* Write the fields in the CAM Entry Register */
-	mmu_set_cam_entry(base_address, mmu_pg_size, preserved_bit, valid_bit,
-			  virtual_addr_tag);
-
-	/* Write the different fields of the RAM Entry Register */
-	/* endianism of the page,Element Size of the page (8, 16, 32, 64 bit) */
-	mmu_set_ram_entry(base_address, physical_addr, map_attrs->endianism,
-			  map_attrs->element_size, map_attrs->mixed_size);
-
-	/* Update the MMU Lock Register */
-	/* currentVictim between lockedBaseValue and (MMU_Entries_Number - 1) */
-	MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(base_address, entry_num);
-
-	/* Enable loading of an entry in TLB by writing 1
-	   into LD_TLB_REG register */
-	MMUMMU_LD_TLB_WRITE_REGISTER32(base_address, MMU_LOAD_TLB);
-
-	MMUMMU_LOCK_WRITE_REGISTER32(base_address, lock_reg);
-
-	return status;
-}
-
-hw_status hw_mmu_pte_set(const u32 pg_tbl_va,
-			 u32 physical_addr,
-			 u32 virtual_addr,
-			 u32 page_sz, struct hw_mmu_map_attrs_t *map_attrs)
-{
-	hw_status status = 0;
-	u32 pte_addr, pte_val;
-	s32 num_entries = 1;
-
-	switch (page_sz) {
-	case HW_PAGE_SIZE4KB:
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SMALL_PAGE_MASK);
-		pte_val =
-		    ((physical_addr & MMU_SMALL_PAGE_MASK) |
-		     (map_attrs->endianism << 9) | (map_attrs->
-						    element_size << 4) |
-		     (map_attrs->mixed_size << 11) | 2);
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtual_addr &
-					      MMU_LARGE_PAGE_MASK);
-		pte_val =
-		    ((physical_addr & MMU_LARGE_PAGE_MASK) |
-		     (map_attrs->endianism << 9) | (map_attrs->
-						    element_size << 4) |
-		     (map_attrs->mixed_size << 11) | 1);
-		break;
-
-	case HW_PAGE_SIZE1MB:
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SECTION_ADDR_MASK);
-		pte_val =
-		    ((((physical_addr & MMU_SECTION_ADDR_MASK) |
-		       (map_attrs->endianism << 15) | (map_attrs->
-						       element_size << 10) |
-		       (map_attrs->mixed_size << 17)) & ~0x40000) | 0x2);
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SSECTION_ADDR_MASK);
-		pte_val =
-		    (((physical_addr & MMU_SSECTION_ADDR_MASK) |
-		      (map_attrs->endianism << 15) | (map_attrs->
-						      element_size << 10) |
-		      (map_attrs->mixed_size << 17)
-		     ) | 0x40000 | 0x2);
-		break;
-
-	case HW_MMU_COARSE_PAGE_SIZE:
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SECTION_ADDR_MASK);
-		pte_val = (physical_addr & MMU_PAGE_TABLE_MASK) | 1;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	while (--num_entries >= 0)
-		((u32 *) pte_addr)[num_entries] = pte_val;
-
-	return status;
-}
-
-hw_status hw_mmu_pte_clear(const u32 pg_tbl_va, u32 virtual_addr, u32 page_size)
-{
-	hw_status status = 0;
-	u32 pte_addr;
-	s32 num_entries = 1;
-
-	switch (page_size) {
-	case HW_PAGE_SIZE4KB:
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SMALL_PAGE_MASK);
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtual_addr &
-					      MMU_LARGE_PAGE_MASK);
-		break;
-
-	case HW_PAGE_SIZE1MB:
-	case HW_MMU_COARSE_PAGE_SIZE:
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SECTION_ADDR_MASK);
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SSECTION_ADDR_MASK);
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	while (--num_entries >= 0)
-		((u32 *) pte_addr)[num_entries] = 0;
-
-	return status;
-}
-
-/* mmu_flush_entry */
-static hw_status mmu_flush_entry(const void __iomem *base_address)
-{
-	hw_status status = 0;
-	u32 flush_entry_data = 0x1;
-
-	/* write values to register */
-	MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32(base_address, flush_entry_data);
-
-	return status;
-}
-
-/* mmu_set_cam_entry */
-static hw_status mmu_set_cam_entry(const void __iomem *base_address,
-				   const u32 page_sz,
-				   const u32 preserved_bit,
-				   const u32 valid_bit,
-				   const u32 virtual_addr_tag)
-{
-	hw_status status = 0;
-	u32 mmu_cam_reg;
-
-	mmu_cam_reg = (virtual_addr_tag << 12);
-	mmu_cam_reg = (mmu_cam_reg) | (page_sz) | (valid_bit << 2) |
-	    (preserved_bit << 3);
-
-	/* write values to register */
-	MMUMMU_CAM_WRITE_REGISTER32(base_address, mmu_cam_reg);
-
-	return status;
-}
-
-/* mmu_set_ram_entry */
-static hw_status mmu_set_ram_entry(const void __iomem *base_address,
-				   const u32 physical_addr,
-				   enum hw_endianism_t endianism,
-				   enum hw_element_size_t element_size,
-				   enum hw_mmu_mixed_size_t mixed_size)
-{
-	hw_status status = 0;
-	u32 mmu_ram_reg;
-
-	mmu_ram_reg = (physical_addr & MMU_ADDR_MASK);
-	mmu_ram_reg = (mmu_ram_reg) | ((endianism << 9) | (element_size << 7) |
-				       (mixed_size << 6));
-
-	/* write values to register */
-	MMUMMU_RAM_WRITE_REGISTER32(base_address, mmu_ram_reg);
-
-	return status;
-
-}
-
-void hw_mmu_tlb_flush_all(const void __iomem *base)
-{
-	__raw_writeb(1, base + MMU_GFLUSH);
-}
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.h b/drivers/staging/tidspbridge/hw/hw_mmu.h
deleted file mode 100644
index 1458a2c..0000000
--- a/drivers/staging/tidspbridge/hw/hw_mmu.h
+++ /dev/null
@@ -1,163 +0,0 @@
-/*
- * hw_mmu.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * MMU types and API declarations
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _HW_MMU_H
-#define _HW_MMU_H
-
-#include <linux/types.h>
-
-/* Bitmasks for interrupt sources */
-#define HW_MMU_TRANSLATION_FAULT   0x2
-#define HW_MMU_ALL_INTERRUPTS      0x1F
-
-#define HW_MMU_COARSE_PAGE_SIZE 0x400
-
-/* hw_mmu_mixed_size_t:  Enumerated Type used to specify whether to follow
-			CPU/TLB Element size */
-enum hw_mmu_mixed_size_t {
-	HW_MMU_TLBES,
-	HW_MMU_CPUES
-};
-
-/* hw_mmu_map_attrs_t:  Struct containing MMU mapping attributes */
-struct hw_mmu_map_attrs_t {
-	enum hw_endianism_t endianism;
-	enum hw_element_size_t element_size;
-	enum hw_mmu_mixed_size_t mixed_size;
-	bool donotlockmpupage;
-};
-
-extern hw_status hw_mmu_enable(const void __iomem *base_address);
-
-extern hw_status hw_mmu_disable(const void __iomem *base_address);
-
-extern hw_status hw_mmu_num_locked_set(const void __iomem *base_address,
-				       u32 num_locked_entries);
-
-extern hw_status hw_mmu_victim_num_set(const void __iomem *base_address,
-				       u32 victim_entry_num);
-
-/* For MMU faults */
-extern hw_status hw_mmu_event_ack(const void __iomem *base_address,
-				  u32 irq_mask);
-
-extern hw_status hw_mmu_event_disable(const void __iomem *base_address,
-				      u32 irq_mask);
-
-extern hw_status hw_mmu_event_enable(const void __iomem *base_address,
-				     u32 irq_mask);
-
-extern hw_status hw_mmu_event_status(const void __iomem *base_address,
-				     u32 *irq_mask);
-
-extern hw_status hw_mmu_fault_addr_read(const void __iomem *base_address,
-					u32 *addr);
-
-/* Set the TT base address */
-extern hw_status hw_mmu_ttb_set(const void __iomem *base_address,
-				u32 ttb_phys_addr);
-
-extern hw_status hw_mmu_twl_enable(const void __iomem *base_address);
-
-extern hw_status hw_mmu_twl_disable(const void __iomem *base_address);
-
-extern hw_status hw_mmu_tlb_flush(const void __iomem *base_address,
-				  u32 virtual_addr, u32 page_sz);
-
-extern hw_status hw_mmu_tlb_add(const void __iomem *base_address,
-				u32 physical_addr,
-				u32 virtual_addr,
-				u32 page_sz,
-				u32 entry_num,
-				struct hw_mmu_map_attrs_t *map_attrs,
-				s8 preserved_bit, s8 valid_bit);
-
-/* For PTEs */
-extern hw_status hw_mmu_pte_set(const u32 pg_tbl_va,
-				u32 physical_addr,
-				u32 virtual_addr,
-				u32 page_sz,
-				struct hw_mmu_map_attrs_t *map_attrs);
-
-extern hw_status hw_mmu_pte_clear(const u32 pg_tbl_va,
-				  u32 virtual_addr, u32 page_size);
-
-void hw_mmu_tlb_flush_all(const void __iomem *base);
-
-static inline u32 hw_mmu_pte_addr_l1(u32 l1_base, u32 va)
-{
-	u32 pte_addr;
-	u32 va31_to20;
-
-	va31_to20 = va >> (20 - 2);	/* Left-shift by 2 here itself */
-	va31_to20 &= 0xFFFFFFFCUL;
-	pte_addr = l1_base + va31_to20;
-
-	return pte_addr;
-}
-
-static inline u32 hw_mmu_pte_addr_l2(u32 l2_base, u32 va)
-{
-	u32 pte_addr;
-
-	pte_addr = (l2_base & 0xFFFFFC00) | ((va >> 10) & 0x3FC);
-
-	return pte_addr;
-}
-
-static inline u32 hw_mmu_pte_coarse_l1(u32 pte_val)
-{
-	u32 pte_coarse;
-
-	pte_coarse = pte_val & 0xFFFFFC00;
-
-	return pte_coarse;
-}
-
-static inline u32 hw_mmu_pte_size_l1(u32 pte_val)
-{
-	u32 pte_size = 0;
-
-	if ((pte_val & 0x3) == 0x1) {
-		/* Points to L2 PT */
-		pte_size = HW_MMU_COARSE_PAGE_SIZE;
-	}
-
-	if ((pte_val & 0x3) == 0x2) {
-		if (pte_val & (1 << 18))
-			pte_size = HW_PAGE_SIZE16MB;
-		else
-			pte_size = HW_PAGE_SIZE1MB;
-	}
-
-	return pte_size;
-}
-
-static inline u32 hw_mmu_pte_size_l2(u32 pte_val)
-{
-	u32 pte_size = 0;
-
-	if (pte_val & 0x2)
-		pte_size = HW_PAGE_SIZE4KB;
-	else if (pte_val & 0x1)
-		pte_size = HW_PAGE_SIZE64KB;
-
-	return pte_size;
-}
-
-#endif /* _HW_MMU_H */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspioctl.h b/drivers/staging/tidspbridge/include/dspbridge/dspioctl.h
index 41e0594..bad1801 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspioctl.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspioctl.h
@@ -19,10 +19,6 @@
 #ifndef DSPIOCTL_
 #define DSPIOCTL_
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /*
  * Any IOCTLS at or above this value are reserved for standard Bridge driver
  * interfaces.
@@ -65,9 +61,6 @@ struct bridge_ioctl_extproc {
 	/* GPP virtual address. __va does not work for ioremapped addresses */
 	u32 ul_gpp_va;
 	u32 ul_size;		/* Size of the mapped memory in bytes */
-	enum hw_endianism_t endianism;
-	enum hw_mmu_mixed_size_t mixed_mode;
-	enum hw_element_size_t elem_size;
 };
 
 #endif /* DSPIOCTL_ */
-- 
1.6.3.3

