Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1AARRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 12:17:49 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54202 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1AARRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 12:17:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=SBoN3pVpfGWerPoBBa/CuJcs4TqFcRMI7xUjkVh2tB2Fblfq3Oyz64b5IusugqZqr9
         9oZyAT/TMnKTRihCRdVhLqrMj7yTk08SfXx2G1wD5u1yVf3JHOLPt4zNavBuo78SJYXD
         3D6994UI4GNjdEMFJx7GL0DKgfKmN1sf9WiDE=
Message-ID: <4D1F61B9.6040900@gmail.com>
Date: Sat, 01 Jan 2011 18:17:45 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, monstr@monstr.eu
Subject: [PATCH] microblaze: correct PVR access macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A definition like:

#define PVR_IS_FULL(pvr)		(pvr.pvr[0] & PVR0_PVR_FULL_MASK)

called with PVR_IS_FULL(foo) will be preprocessed to:

(foo.foo[0] & PVR0_PVR_FULL_MASK)
     ^^^
So to fix this and ensure the preprocessor compiles calls correctly:

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/microblaze/include/asm/pvr.h |  160 ++++++++++++++++++------------------
 1 files changed, 80 insertions(+), 80 deletions(-)

This was not compile tested.

diff --git a/arch/microblaze/include/asm/pvr.h b/arch/microblaze/include/asm/pvr.h
index 37db96a..a7ba4f0 100644
--- a/arch/microblaze/include/asm/pvr.h
+++ b/arch/microblaze/include/asm/pvr.h
@@ -122,96 +122,96 @@ struct pvr_s {
 
 
 /* PVR access macros */
-#define PVR_IS_FULL(pvr)		(pvr.pvr[0] & PVR0_PVR_FULL_MASK)
-#define PVR_USE_BARREL(pvr)		(pvr.pvr[0] & PVR0_USE_BARREL_MASK)
-#define PVR_USE_DIV(pvr)		(pvr.pvr[0] & PVR0_USE_DIV_MASK)
-#define PVR_USE_HW_MUL(pvr)		(pvr.pvr[0] & PVR0_USE_HW_MUL_MASK)
-#define PVR_USE_FPU(pvr)		(pvr.pvr[0] & PVR0_USE_FPU_MASK)
-#define PVR_USE_FPU2(pvr)		(pvr.pvr[2] & PVR2_USE_FPU2_MASK)
-#define PVR_USE_ICACHE(pvr)		(pvr.pvr[0] & PVR0_USE_ICACHE_MASK)
-#define PVR_USE_DCACHE(pvr)		(pvr.pvr[0] & PVR0_USE_DCACHE_MASK)
-#define PVR_VERSION(pvr)	((pvr.pvr[0] & PVR0_VERSION_MASK) >> 8)
-#define PVR_USER1(pvr)			(pvr.pvr[0] & PVR0_USER1_MASK)
-#define PVR_USER2(pvr)			(pvr.pvr[1] & PVR1_USER2_MASK)
-
-#define PVR_D_OPB(pvr)			(pvr.pvr[2] & PVR2_D_OPB_MASK)
-#define PVR_D_LMB(pvr)			(pvr.pvr[2] & PVR2_D_LMB_MASK)
-#define PVR_I_OPB(pvr)			(pvr.pvr[2] & PVR2_I_OPB_MASK)
-#define PVR_I_LMB(pvr)			(pvr.pvr[2] & PVR2_I_LMB_MASK)
-#define PVR_INTERRUPT_IS_EDGE(pvr) \
-			(pvr.pvr[2] & PVR2_INTERRUPT_IS_EDGE_MASK)
-#define PVR_EDGE_IS_POSITIVE(pvr) \
-			(pvr.pvr[2] & PVR2_EDGE_IS_POSITIVE_MASK)
-#define PVR_USE_MSR_INSTR(pvr)		(pvr.pvr[2] & PVR2_USE_MSR_INSTR)
-#define PVR_USE_PCMP_INSTR(pvr)		(pvr.pvr[2] & PVR2_USE_PCMP_INSTR)
-#define PVR_AREA_OPTIMISED(pvr)		(pvr.pvr[2] & PVR2_AREA_OPTIMISED)
-#define PVR_USE_MUL64(pvr)		(pvr.pvr[2] & PVR2_USE_MUL64_MASK)
-#define PVR_OPCODE_0x0_ILLEGAL(pvr) \
-			(pvr.pvr[2] & PVR2_OPCODE_0x0_ILL_MASK)
-#define PVR_UNALIGNED_EXCEPTION(pvr) \
-			(pvr.pvr[2] & PVR2_UNALIGNED_EXC_MASK)
-#define PVR_ILL_OPCODE_EXCEPTION(pvr) \
-			(pvr.pvr[2] & PVR2_ILL_OPCODE_EXC_MASK)
-#define PVR_IOPB_BUS_EXCEPTION(pvr) \
-			(pvr.pvr[2] & PVR2_IOPB_BUS_EXC_MASK)
-#define PVR_DOPB_BUS_EXCEPTION(pvr) \
-			(pvr.pvr[2] & PVR2_DOPB_BUS_EXC_MASK)
-#define PVR_DIV_ZERO_EXCEPTION(pvr) \
-			(pvr.pvr[2] & PVR2_DIV_ZERO_EXC_MASK)
-#define PVR_FPU_EXCEPTION(pvr)		(pvr.pvr[2] & PVR2_FPU_EXC_MASK)
-#define PVR_FSL_EXCEPTION(pvr)		(pvr.pvr[2] & PVR2_USE_EXTEND_FSL)
-
-#define PVR_DEBUG_ENABLED(pvr)		(pvr.pvr[3] & PVR3_DEBUG_ENABLED_MASK)
-#define PVR_NUMBER_OF_PC_BRK(pvr) \
-			((pvr.pvr[3] & PVR3_NUMBER_OF_PC_BRK_MASK) >> 25)
-#define PVR_NUMBER_OF_RD_ADDR_BRK(pvr) \
-			((pvr.pvr[3] & PVR3_NUMBER_OF_RD_ADDR_BRK_MASK) >> 19)
-#define PVR_NUMBER_OF_WR_ADDR_BRK(pvr) \
-			((pvr.pvr[3] & PVR3_NUMBER_OF_WR_ADDR_BRK_MASK) >> 13)
-#define PVR_FSL_LINKS(pvr)	((pvr.pvr[3] & PVR3_FSL_LINKS_MASK) >> 7)
-
-#define PVR_ICACHE_ADDR_TAG_BITS(pvr) \
-			((pvr.pvr[4] & PVR4_ICACHE_ADDR_TAG_BITS_MASK) >> 26)
-#define PVR_ICACHE_USE_FSL(pvr)		(pvr.pvr[4] & PVR4_ICACHE_USE_FSL_MASK)
-#define PVR_ICACHE_ALLOW_WR(pvr)	(pvr.pvr[4] & PVR4_ICACHE_ALLOW_WR_MASK)
-#define PVR_ICACHE_LINE_LEN(pvr) \
-			(1 << ((pvr.pvr[4] & PVR4_ICACHE_LINE_LEN_MASK) >> 21))
-#define PVR_ICACHE_BYTE_SIZE(pvr) \
-			(1 << ((pvr.pvr[4] & PVR4_ICACHE_BYTE_SIZE_MASK) >> 16))
-
-#define PVR_DCACHE_ADDR_TAG_BITS(pvr) \
-			((pvr.pvr[5] & PVR5_DCACHE_ADDR_TAG_BITS_MASK) >> 26)
-#define PVR_DCACHE_USE_FSL(pvr)		(pvr.pvr[5] & PVR5_DCACHE_USE_FSL_MASK)
-#define PVR_DCACHE_ALLOW_WR(pvr)	(pvr.pvr[5] & PVR5_DCACHE_ALLOW_WR_MASK)
+#define PVR_IS_FULL(_pvr)		(_pvr.pvr[0] & PVR0_PVR_FULL_MASK)
+#define PVR_USE_BARREL(_pvr)		(_pvr.pvr[0] & PVR0_USE_BARREL_MASK)
+#define PVR_USE_DIV(_pvr)		(_pvr.pvr[0] & PVR0_USE_DIV_MASK)
+#define PVR_USE_HW_MUL(_pvr)		(_pvr.pvr[0] & PVR0_USE_HW_MUL_MASK)
+#define PVR_USE_FPU(_pvr)		(_pvr.pvr[0] & PVR0_USE_FPU_MASK)
+#define PVR_USE_FPU2(_pvr)		(_pvr.pvr[2] & PVR2_USE_FPU2_MASK)
+#define PVR_USE_ICACHE(_pvr)		(_pvr.pvr[0] & PVR0_USE_ICACHE_MASK)
+#define PVR_USE_DCACHE(_pvr)		(_pvr.pvr[0] & PVR0_USE_DCACHE_MASK)
+#define PVR_VERSION(_pvr)	((_pvr.pvr[0] & PVR0_VERSION_MASK) >> 8)
+#define PVR_USER1(_pvr)			(_pvr.pvr[0] & PVR0_USER1_MASK)
+#define PVR_USER2(_pvr)			(_pvr.pvr[1] & PVR1_USER2_MASK)
+
+#define PVR_D_OPB(_pvr)			(_pvr.pvr[2] & PVR2_D_OPB_MASK)
+#define PVR_D_LMB(_pvr)			(_pvr.pvr[2] & PVR2_D_LMB_MASK)
+#define PVR_I_OPB(_pvr)			(_pvr.pvr[2] & PVR2_I_OPB_MASK)
+#define PVR_I_LMB(_pvr)			(_pvr.pvr[2] & PVR2_I_LMB_MASK)
+#define PVR_INTERRUPT_IS_EDGE(_pvr) \
+			(_pvr.pvr[2] & PVR2_INTERRUPT_IS_EDGE_MASK)
+#define PVR_EDGE_IS_POSITIVE(_pvr) \
+			(_pvr.pvr[2] & PVR2_EDGE_IS_POSITIVE_MASK)
+#define PVR_USE_MSR_INSTR(_pvr)		(_pvr.pvr[2] & PVR2_USE_MSR_INSTR)
+#define PVR_USE_PCMP_INSTR(_pvr)		(_pvr.pvr[2] & PVR2_USE_PCMP_INSTR)
+#define PVR_AREA_OPTIMISED(_pvr)		(_pvr.pvr[2] & PVR2_AREA_OPTIMISED)
+#define PVR_USE_MUL64(_pvr)		(_pvr.pvr[2] & PVR2_USE_MUL64_MASK)
+#define PVR_OPCODE_0x0_ILLEGAL(_pvr) \
+			(_pvr.pvr[2] & PVR2_OPCODE_0x0_ILL_MASK)
+#define PVR_UNALIGNED_EXCEPTION(_pvr) \
+			(_pvr.pvr[2] & PVR2_UNALIGNED_EXC_MASK)
+#define PVR_ILL_OPCODE_EXCEPTION(_pvr) \
+			(_pvr.pvr[2] & PVR2_ILL_OPCODE_EXC_MASK)
+#define PVR_IOPB_BUS_EXCEPTION(_pvr) \
+			(_pvr.pvr[2] & PVR2_IOPB_BUS_EXC_MASK)
+#define PVR_DOPB_BUS_EXCEPTION(_pvr) \
+			(_pvr.pvr[2] & PVR2_DOPB_BUS_EXC_MASK)
+#define PVR_DIV_ZERO_EXCEPTION(_pvr) \
+			(_pvr.pvr[2] & PVR2_DIV_ZERO_EXC_MASK)
+#define PVR_FPU_EXCEPTION(_pvr)		(_pvr.pvr[2] & PVR2_FPU_EXC_MASK)
+#define PVR_FSL_EXCEPTION(_pvr)		(_pvr.pvr[2] & PVR2_USE_EXTEND_FSL)
+
+#define PVR_DEBUG_ENABLED(_pvr)		(_pvr.pvr[3] & PVR3_DEBUG_ENABLED_MASK)
+#define PVR_NUMBER_OF_PC_BRK(_pvr) \
+			((_pvr.pvr[3] & PVR3_NUMBER_OF_PC_BRK_MASK) >> 25)
+#define PVR_NUMBER_OF_RD_ADDR_BRK(_pvr) \
+			((_pvr.pvr[3] & PVR3_NUMBER_OF_RD_ADDR_BRK_MASK) >> 19)
+#define PVR_NUMBER_OF_WR_ADDR_BRK(_pvr) \
+			((_pvr.pvr[3] & PVR3_NUMBER_OF_WR_ADDR_BRK_MASK) >> 13)
+#define PVR_FSL_LINKS(_pvr)	((_pvr.pvr[3] & PVR3_FSL_LINKS_MASK) >> 7)
+
+#define PVR_ICACHE_ADDR_TAG_BITS(_pvr) \
+			((_pvr.pvr[4] & PVR4_ICACHE_ADDR_TAG_BITS_MASK) >> 26)
+#define PVR_ICACHE_USE_FSL(_pvr)		(_pvr.pvr[4] & PVR4_ICACHE_USE_FSL_MASK)
+#define PVR_ICACHE_ALLOW_WR(_pvr)	(_pvr.pvr[4] & PVR4_ICACHE_ALLOW_WR_MASK)
+#define PVR_ICACHE_LINE_LEN(_pvr) \
+			(1 << ((_pvr.pvr[4] & PVR4_ICACHE_LINE_LEN_MASK) >> 21))
+#define PVR_ICACHE_BYTE_SIZE(_pvr) \
+			(1 << ((_pvr.pvr[4] & PVR4_ICACHE_BYTE_SIZE_MASK) >> 16))
+
+#define PVR_DCACHE_ADDR_TAG_BITS(_pvr) \
+			((_pvr.pvr[5] & PVR5_DCACHE_ADDR_TAG_BITS_MASK) >> 26)
+#define PVR_DCACHE_USE_FSL(_pvr)		(_pvr.pvr[5] & PVR5_DCACHE_USE_FSL_MASK)
+#define PVR_DCACHE_ALLOW_WR(_pvr)	(_pvr.pvr[5] & PVR5_DCACHE_ALLOW_WR_MASK)
 /* FIXME two shifts on one line needs any comment */
-#define PVR_DCACHE_LINE_LEN(pvr) \
-			(1 << ((pvr.pvr[5] & PVR5_DCACHE_LINE_LEN_MASK) >> 21))
-#define PVR_DCACHE_BYTE_SIZE(pvr) \
-			(1 << ((pvr.pvr[5] & PVR5_DCACHE_BYTE_SIZE_MASK) >> 16))
+#define PVR_DCACHE_LINE_LEN(_pvr) \
+			(1 << ((_pvr.pvr[5] & PVR5_DCACHE_LINE_LEN_MASK) >> 21))
+#define PVR_DCACHE_BYTE_SIZE(_pvr) \
+			(1 << ((_pvr.pvr[5] & PVR5_DCACHE_BYTE_SIZE_MASK) >> 16))
 
-#define PVR_DCACHE_USE_WRITEBACK(pvr) \
-			((pvr.pvr[5] & PVR5_DCACHE_USE_WRITEBACK) >> 14)
+#define PVR_DCACHE_USE_WRITEBACK(_pvr) \
+			((_pvr.pvr[5] & PVR5_DCACHE_USE_WRITEBACK) >> 14)
 
-#define PVR_ICACHE_BASEADDR(pvr)	(pvr.pvr[6] & PVR6_ICACHE_BASEADDR_MASK)
-#define PVR_ICACHE_HIGHADDR(pvr)	(pvr.pvr[7] & PVR7_ICACHE_HIGHADDR_MASK)
+#define PVR_ICACHE_BASEADDR(_pvr)	(_pvr.pvr[6] & PVR6_ICACHE_BASEADDR_MASK)
+#define PVR_ICACHE_HIGHADDR(_pvr)	(_pvr.pvr[7] & PVR7_ICACHE_HIGHADDR_MASK)
 
-#define PVR_DCACHE_BASEADDR(pvr)	(pvr.pvr[8] & PVR8_DCACHE_BASEADDR_MASK)
-#define PVR_DCACHE_HIGHADDR(pvr)	(pvr.pvr[9] & PVR9_DCACHE_HIGHADDR_MASK)
+#define PVR_DCACHE_BASEADDR(_pvr)	(_pvr.pvr[8] & PVR8_DCACHE_BASEADDR_MASK)
+#define PVR_DCACHE_HIGHADDR(_pvr)	(_pvr.pvr[9] & PVR9_DCACHE_HIGHADDR_MASK)
 
-#define PVR_TARGET_FAMILY(pvr)	((pvr.pvr[10] & PVR10_TARGET_FAMILY_MASK) >> 24)
+#define PVR_TARGET_FAMILY(_pvr)	((_pvr.pvr[10] & PVR10_TARGET_FAMILY_MASK) >> 24)
 
-#define PVR_MSR_RESET_VALUE(pvr) \
-				(pvr.pvr[11] & PVR11_MSR_RESET_VALUE_MASK)
+#define PVR_MSR_RESET_VALUE(_pvr) \
+				(_pvr.pvr[11] & PVR11_MSR_RESET_VALUE_MASK)
 
 /* mmu */
-#define PVR_USE_MMU(pvr)	((pvr.pvr[11] & PVR11_USE_MMU) >> 30)
-#define PVR_MMU_ITLB_SIZE(pvr)	(pvr.pvr[11] & PVR11_MMU_ITLB_SIZE)
-#define PVR_MMU_DTLB_SIZE(pvr)	(pvr.pvr[11] & PVR11_MMU_DTLB_SIZE)
-#define PVR_MMU_TLB_ACCESS(pvr)	(pvr.pvr[11] & PVR11_MMU_TLB_ACCESS)
-#define PVR_MMU_ZONES(pvr)	(pvr.pvr[11] & PVR11_MMU_ZONES)
+#define PVR_USE_MMU(_pvr)	((_pvr.pvr[11] & PVR11_USE_MMU) >> 30)
+#define PVR_MMU_ITLB_SIZE(_pvr)	(_pvr.pvr[11] & PVR11_MMU_ITLB_SIZE)
+#define PVR_MMU_DTLB_SIZE(_pvr)	(_pvr.pvr[11] & PVR11_MMU_DTLB_SIZE)
+#define PVR_MMU_TLB_ACCESS(_pvr)	(_pvr.pvr[11] & PVR11_MMU_TLB_ACCESS)
+#define PVR_MMU_ZONES(_pvr)	(_pvr.pvr[11] & PVR11_MMU_ZONES)
 
 /* endian */
-#define PVR_ENDIAN(pvr)	(pvr.pvr[0] & PVR0_ENDI)
+#define PVR_ENDIAN(_pvr)	(_pvr.pvr[0] & PVR0_ENDI)
 
 int cpu_has_pvr(void);
 void get_pvr(struct pvr_s *pvr);
