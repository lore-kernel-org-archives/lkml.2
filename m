Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0GLW4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:56:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39123 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab0GLW4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:56:21 -0400
From: Nishanth Menon <nm@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 06/11] staging: tidspbridge: remove GlobalTypes.h
Date: Mon, 12 Jul 2010 17:56:04 -0500
Message-Id: <1278975369-7687-7-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1278975369-7687-1-git-send-email-nm@ti.com>
References: <1278975369-7687-1-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove custom globaltypes.h header

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/staging/tidspbridge/hw/GlobalTypes.h |  289 --------------------------
 drivers/staging/tidspbridge/hw/MMURegAcM.h   |    1 -
 drivers/staging/tidspbridge/hw/hw_defs.h     |    2 -
 drivers/staging/tidspbridge/hw/hw_mmu.c      |   32 ---
 4 files changed, 0 insertions(+), 324 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/hw/GlobalTypes.h

diff --git a/drivers/staging/tidspbridge/hw/GlobalTypes.h b/drivers/staging/tidspbridge/hw/GlobalTypes.h
deleted file mode 100644
index 2f8e69b..0000000
--- a/drivers/staging/tidspbridge/hw/GlobalTypes.h
+++ /dev/null
@@ -1,289 +0,0 @@
-/*
- * GlobalTypes.h
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
-#ifndef _GLOBALTYPES_H
-#define _GLOBALTYPES_H
-
-/*
- * Definition: RET_CODE_BASE
- *
- * DESCRIPTION:  Base value for return code offsets
- */
-#define RET_CODE_BASE	0
-
-/*
- * Definition: *BIT_OFFSET
- *
- * DESCRIPTION:  offset in bytes from start of 32-bit word.
- */
-#define LOWER16BIT_OFFSET	  0
-#define UPPER16BIT_OFFSET	  2
-
-#define LOWER8BIT_OFFSET	   0
-#define LOWER_MIDDLE8BIT_OFFSET    1
-#define UPPER_MIDDLE8BIT_OFFSET    2
-#define UPPER8BIT_OFFSET	   3
-
-#define LOWER8BIT_OF16_OFFSET      0
-#define UPPER8BIT_OF16_OFFSET      1
-
-/*
- * Definition: *BIT_SHIFT
- *
- * DESCRIPTION:  offset in bits from start of 32-bit word.
- */
-#define LOWER16BIT_SHIFT	  0
-#define UPPER16BIT_SHIFT	  16
-
-#define LOWER8BIT_SHIFT	   0
-#define LOWER_MIDDLE8BIT_SHIFT    8
-#define UPPER_MIDDLE8BIT_SHIFT    16
-#define UPPER8BIT_SHIFT	   24
-
-#define LOWER8BIT_OF16_SHIFT      0
-#define UPPER8BIT_OF16_SHIFT      8
-
-/*
- * Definition: LOWER16BIT_MASK
- *
- * DESCRIPTION: 16 bit mask used for inclusion of lower 16 bits i.e. mask out
- *		the upper 16 bits
- */
-#define LOWER16BIT_MASK	0x0000FFFF
-
-/*
- * Definition: LOWER8BIT_MASK
- *
- * DESCRIPTION: 8 bit masks used for inclusion of 8 bits i.e. mask out
- *		the upper 16 bits
- */
-#define LOWER8BIT_MASK	   0x000000FF
-
-/*
- * Definition: RETURN32BITS_FROM16LOWER_AND16UPPER(lower16Bits, upper16Bits)
- *
- * DESCRIPTION: Returns a 32 bit value given a 16 bit lower value and a 16
- *		bit upper value
- */
-#define RETURN32BITS_FROM16LOWER_AND16UPPER(lower16Bits, upper16Bits)\
-    (((((u32)lower16Bits)  & LOWER16BIT_MASK)) | \
-     (((((u32)upper16Bits) & LOWER16BIT_MASK) << UPPER16BIT_SHIFT)))
-
-/*
- * Definition: RETURN16BITS_FROM8LOWER_AND8UPPER(lower16Bits, upper16Bits)
- *
- * DESCRIPTION:  Returns a 16 bit value given a 8 bit lower value and a 8
- *	       bit upper value
- */
-#define RETURN16BITS_FROM8LOWER_AND8UPPER(lower8Bits, upper8Bits)\
-    (((((u32)lower8Bits)  & LOWER8BIT_MASK)) | \
-     (((((u32)upper8Bits) & LOWER8BIT_MASK) << UPPER8BIT_OF16_SHIFT)))
-
-/*
- * Definition: RETURN32BITS_FROM48BIT_VALUES(lower8Bits, lowerMiddle8Bits,
- * 					lowerUpper8Bits, upper8Bits)
- *
- * DESCRIPTION:  Returns a 32 bit value given four 8 bit values
- */
-#define RETURN32BITS_FROM48BIT_VALUES(lower8Bits, lowerMiddle8Bits,\
-	lowerUpper8Bits, upper8Bits)\
-	(((((u32)lower8Bits) & LOWER8BIT_MASK)) | \
-	(((((u32)lowerMiddle8Bits) & LOWER8BIT_MASK) <<\
-		LOWER_MIDDLE8BIT_SHIFT)) | \
-	(((((u32)lowerUpper8Bits) & LOWER8BIT_MASK) <<\
-		UPPER_MIDDLE8BIT_SHIFT)) | \
-	(((((u32)upper8Bits) & LOWER8BIT_MASK) <<\
-		UPPER8BIT_SHIFT)))
-
-/*
- * Definition: READ_LOWER16BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 16 lower bits of 32bit value
- */
-#define READ_LOWER16BITS_OF32(value32bits)\
-    ((u16)((u32)(value32bits) & LOWER16BIT_MASK))
-
-/*
- * Definition: READ_UPPER16BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 16 lower bits of 32bit value
- */
-#define READ_UPPER16BITS_OF32(value32bits)\
-	(((u16)((u32)(value32bits) >> UPPER16BIT_SHIFT)) &\
-	LOWER16BIT_MASK)
-
-/*
- * Definition: READ_LOWER8BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 8 lower bits of 32bit value
- */
-#define READ_LOWER8BITS_OF32(value32bits)\
-    ((u8)((u32)(value32bits) & LOWER8BIT_MASK))
-
-/*
- * Definition: READ_LOWER_MIDDLE8BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 8 lower middle bits of 32bit value
- */
-#define READ_LOWER_MIDDLE8BITS_OF32(value32bits)\
-	(((u8)((u32)(value32bits) >> LOWER_MIDDLE8BIT_SHIFT)) &\
-	LOWER8BIT_MASK)
-
-/*
- * Definition: READ_LOWER_MIDDLE8BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 8 lower middle bits of 32bit value
- */
-#define READ_UPPER_MIDDLE8BITS_OF32(value32bits)\
-	(((u8)((u32)(value32bits) >> LOWER_MIDDLE8BIT_SHIFT)) &\
-	LOWER8BIT_MASK)
-
-/*
- * Definition: READ_UPPER8BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 8 upper bits of 32bit value
- */
-#define READ_UPPER8BITS_OF32(value32bits)\
-    (((u8)((u32)(value32bits) >> UPPER8BIT_SHIFT)) & LOWER8BIT_MASK)
-
-/*
- * Definition: READ_LOWER8BITS_OF16(value16bits)
- *
- * DESCRIPTION:  Returns a 8 lower bits of 16bit value
- */
-#define READ_LOWER8BITS_OF16(value16bits)\
-    ((u8)((u16)(value16bits) & LOWER8BIT_MASK))
-
-/*
- * Definition: READ_UPPER8BITS_OF16(value32bits)
- *
- * DESCRIPTION:  Returns a 8 upper bits of 16bit value
- */
-#define READ_UPPER8BITS_OF16(value16bits)\
-    (((u8)((u32)(value16bits) >> UPPER8BIT_SHIFT)) & LOWER8BIT_MASK)
-
-/* UWORD16:  16 bit tpyes */
-
-/* reg_uword8, reg_word8: 8 bit register types */
-typedef volatile unsigned char reg_uword8;
-typedef volatile signed char reg_word8;
-
-/* reg_uword16, reg_word16: 16 bit register types */
-#ifndef OMAPBRIDGE_TYPES
-typedef volatile unsigned short reg_uword16;
-#endif
-typedef volatile short reg_word16;
-
-/* reg_uword32, REG_WORD32: 32 bit register types */
-typedef volatile unsigned long reg_uword32;
-
-/* FLOAT
- *
- * Type to be used for floating point calculation. Note that floating point
- * calculation is very CPU expensive, and you should only  use if you
- * absolutely need this. */
-
-/* boolean_t:  Boolean Type True, False */
-/* return_code_t:  Return codes to be returned by all library functions */
-enum return_code_label {
-	RET_OK = 0,
-	RET_FAIL = -1,
-	RET_BAD_NULL_PARAM = -2,
-	RET_PARAM_OUT_OF_RANGE = -3,
-	RET_INVALID_ID = -4,
-	RET_EMPTY = -5,
-	RET_FULL = -6,
-	RET_TIMEOUT = -7,
-	RET_INVALID_OPERATION = -8,
-
-	/* Add new error codes at end of above list */
-
-	RET_NUM_RET_CODES	/* this should ALWAYS be LAST entry */
-};
-
-/* MACRO: RD_MEM8, WR_MEM8
- *
- * DESCRIPTION:  32 bit memory access macros
- */
-#define RD_MEM8(addr)	((u8)(*((u8 *)(addr))))
-#define WR_MEM8(addr, data)	(*((u8 *)(addr)) = (u8)(data))
-
-/* MACRO: RD_MEM8_VOLATILE, WR_MEM8_VOLATILE
- *
- * DESCRIPTION:  8 bit register access macros
- */
-#define RD_MEM8_VOLATILE(addr)	((u8)(*((reg_uword8 *)(addr))))
-#define WR_MEM8_VOLATILE(addr, data) (*((reg_uword8 *)(addr)) = (u8)(data))
-
-/*
- * MACRO: RD_MEM16, WR_MEM16
- *
- * DESCRIPTION:  16 bit memory access macros
- */
-#define RD_MEM16(addr)	((u16)(*((u16 *)(addr))))
-#define WR_MEM16(addr, data)	(*((u16 *)(addr)) = (u16)(data))
-
-/*
- * MACRO: RD_MEM16_VOLATILE, WR_MEM16_VOLATILE
- *
- * DESCRIPTION:  16 bit register access macros
- */
-#define RD_MEM16_VOLATILE(addr)	((u16)(*((reg_uword16 *)(addr))))
-#define WR_MEM16_VOLATILE(addr, data)	(*((reg_uword16 *)(addr)) =\
-					(u16)(data))
-
-/*
- * MACRO: RD_MEM32, WR_MEM32
- *
- * DESCRIPTION:  32 bit memory access macros
- */
-#define RD_MEM32(addr)	((u32)(*((u32 *)(addr))))
-#define WR_MEM32(addr, data)	(*((u32 *)(addr)) = (u32)(data))
-
-/*
- * MACRO: RD_MEM32_VOLATILE, WR_MEM32_VOLATILE
- *
- * DESCRIPTION:  32 bit register access macros
- */
-#define RD_MEM32_VOLATILE(addr)	((u32)(*((reg_uword32 *)(addr))))
-#define WR_MEM32_VOLATILE(addr, data)	(*((reg_uword32 *)(addr)) =\
-					(u32)(data))
-
-/* Not sure if this all belongs here */
-
-#define CHECK_RETURN_VALUE(actualValue, expectedValue,  returnCodeIfMismatch,\
-	spyCodeIfMisMatch)
-#define CHECK_RETURN_VALUE_RET(actualValue, expectedValue, returnCodeIfMismatch)
-#define CHECK_RETURN_VALUE_RES(actualValue, expectedValue, spyCodeIfMisMatch)
-#define CHECK_RETURN_VALUE_RET_VOID(actualValue, expectedValue,\
-	spyCodeIfMisMatch)
-
-#define CHECK_INPUT_PARAM(actualValue, invalidValue, returnCodeIfMismatch,\
-	spyCodeIfMisMatch)
-#define CHECK_INPUT_PARAM_NO_SPY(actualValue, invalidValue,\
-	returnCodeIfMismatch)
-#define CHECK_INPUT_RANGE(actualValue, minValidValue, maxValidValue,\
-	returnCodeIfMismatch, spyCodeIfMisMatch)
-#define CHECK_INPUT_RANGE_NO_SPY(actualValue, minValidValue, maxValidValue,\
-	returnCodeIfMismatch)
-#define CHECK_INPUT_RANGE_MIN0(actualValue, maxValidValue,\
-	returnCodeIfMismatch, spyCodeIfMisMatch)
-#define CHECK_INPUT_RANGE_NO_SPY_MIN0(actualValue, maxValidValue,\
-	returnCodeIfMismatch)
-
-#endif /* _GLOBALTYPES_H */
diff --git a/drivers/staging/tidspbridge/hw/MMURegAcM.h b/drivers/staging/tidspbridge/hw/MMURegAcM.h
index c341060..eafd478 100644
--- a/drivers/staging/tidspbridge/hw/MMURegAcM.h
+++ b/drivers/staging/tidspbridge/hw/MMURegAcM.h
@@ -17,7 +17,6 @@
 #ifndef _MMU_REG_ACM_H
 #define _MMU_REG_ACM_H
 
-#include <GlobalTypes.h>
 #include <linux/io.h>
 #include <EasiGlobal.h>
 
diff --git a/drivers/staging/tidspbridge/hw/hw_defs.h b/drivers/staging/tidspbridge/hw/hw_defs.h
index 98f6045..d5266d4 100644
--- a/drivers/staging/tidspbridge/hw/hw_defs.h
+++ b/drivers/staging/tidspbridge/hw/hw_defs.h
@@ -19,8 +19,6 @@
 #ifndef _HW_DEFS_H
 #define _HW_DEFS_H
 
-#include <GlobalTypes.h>
-
 /* Page size */
 #define HW_PAGE_SIZE4KB   0x1000
 #define HW_PAGE_SIZE64KB  0x10000
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
index 321b72d..fdff2e5 100644
--- a/drivers/staging/tidspbridge/hw/hw_mmu.c
+++ b/drivers/staging/tidspbridge/hw/hw_mmu.c
@@ -16,7 +16,6 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
-#include <GlobalTypes.h>
 #include <linux/io.h>
 #include "MMURegAcM.h"
 #include <hw_defs.h>
@@ -250,10 +249,6 @@ hw_status hw_mmu_fault_addr_read(const void __iomem *base_address, u32 *addr)
 {
 	hw_status status = 0;
 
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(base_address, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-
 	/* read values from register */
 	*addr = MMUMMU_FAULT_AD_READ_REGISTER32(base_address);
 
@@ -265,10 +260,6 @@ hw_status hw_mmu_ttb_set(const void __iomem *base_address, u32 TTBPhysAddr)
 	hw_status status = 0;
 	u32 load_ttb;
 
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(base_address, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-
 	load_ttb = TTBPhysAddr & ~0x7FUL;
 	/* write values to register */
 	MMUMMU_TTB_WRITE_REGISTER32(base_address, load_ttb);
@@ -346,14 +337,6 @@ hw_status hw_mmu_tlb_add(const void __iomem *base_address,
 	enum hw_mmu_page_size_t mmu_pg_size;
 
 	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(base_address, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-	CHECK_INPUT_RANGE_MIN0(pageSize, MMU_PAGE_MAX, RET_PARAM_OUT_OF_RANGE,
-			       RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-	CHECK_INPUT_RANGE_MIN0(map_attrs->element_size, MMU_ELEMENTSIZE_MAX,
-			       RET_PARAM_OUT_OF_RANGE, RES_MMU_BASE +
-			       RES_INVALID_INPUT_PARAM);
-
 	switch (pageSize) {
 	case HW_PAGE_SIZE4KB:
 		mmu_pg_size = HW_MMU_SMALL_PAGE;
@@ -526,10 +509,6 @@ static hw_status mmu_flush_entry(const void __iomem *base_address)
 	hw_status status = 0;
 	u32 flush_entry_data = 0x1;
 
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(base_address, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-
 	/* write values to register */
 	MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32(base_address, flush_entry_data);
 
@@ -546,10 +525,6 @@ static hw_status mmu_set_cam_entry(const void __iomem *base_address,
 	hw_status status = 0;
 	u32 mmu_cam_reg;
 
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(base_address, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-
 	mmu_cam_reg = (virtual_addr_tag << 12);
 	mmu_cam_reg = (mmu_cam_reg) | (pageSize) | (validBit << 2) |
 	    (preservedBit << 3);
@@ -570,13 +545,6 @@ static hw_status mmu_set_ram_entry(const void __iomem *base_address,
 	hw_status status = 0;
 	u32 mmu_ram_reg;
 
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(base_address, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-	CHECK_INPUT_RANGE_MIN0(element_size, MMU_ELEMENTSIZE_MAX,
-			       RET_PARAM_OUT_OF_RANGE, RES_MMU_BASE +
-			       RES_INVALID_INPUT_PARAM);
-
 	mmu_ram_reg = (physicalAddr & MMU_ADDR_MASK);
 	mmu_ram_reg = (mmu_ram_reg) | ((endianism << 9) | (element_size << 7) |
 				       (mixed_size << 6));
-- 
1.6.3.3

