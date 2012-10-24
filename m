Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422792Ab2JXWKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:10:07 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64288 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161430Ab2JXWJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:09:47 -0400
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Victor Manuel Jaquez Leal <vjaquez@igalia.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Omar Ramirez Luna <omar.luna@linaro.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: [PATCH 6/6] staging: tidspbridge: delete unused mmu functions
Date: Wed, 24 Oct 2012 17:09:20 -0500
Message-Id: <1351116560-6918-7-git-send-email-omar.ramirez@copitl.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
References: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Omar Ramirez Luna <omar.luna@linaro.org>

This should get rid of warnings of the type:

warning: passing argument 1 of '' discards qualifiers from pointer target type
 note: expected 'void *' but argument is of type 'const void *'

Signed-off-by: Omar Ramirez Luna <omar.ramirez@copitl.com>
---

Intended for 3.7 due to code changes during rc1.

 drivers/staging/tidspbridge/hw/hw_mmu.c |   75 -------------------------------
 drivers/staging/tidspbridge/hw/hw_mmu.h |    3 --
 2 files changed, 78 deletions(-)

diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
index a159450..50244a4 100644
--- a/drivers/staging/tidspbridge/hw/hw_mmu.c
+++ b/drivers/staging/tidspbridge/hw/hw_mmu.c
@@ -48,31 +48,6 @@ enum hw_mmu_page_size_t {
 };
 
 /*
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
- *       Description     : 0		 -- No errors occurred
- *			 RET_BAD_NULL_PARAM     -- A Pointer
- *						Parameter was set to NULL
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
  * FUNCTION	      : mmu_set_cam_entry
  *
  * INPUTS:
@@ -285,44 +260,6 @@ hw_status hw_mmu_twl_disable(void __iomem *base_address)
 	return status;
 }
 
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
 hw_status hw_mmu_tlb_add(void __iomem *base_address,
 			 u32 physical_addr,
 			 u32 virtual_addr,
@@ -503,18 +440,6 @@ hw_status hw_mmu_pte_clear(const u32 pg_tbl_va, u32 virtual_addr, u32 page_size)
 	return status;
 }
 
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
 /* mmu_set_cam_entry */
 static hw_status mmu_set_cam_entry(void __iomem *base_address,
 				   const u32 page_sz,
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.h b/drivers/staging/tidspbridge/hw/hw_mmu.h
index 1cdd082..1c50bb3 100644
--- a/drivers/staging/tidspbridge/hw/hw_mmu.h
+++ b/drivers/staging/tidspbridge/hw/hw_mmu.h
@@ -76,9 +76,6 @@ extern hw_status hw_mmu_twl_enable(void __iomem *base_address);
 
 extern hw_status hw_mmu_twl_disable(void __iomem *base_address);
 
-extern hw_status hw_mmu_tlb_flush(const void __iomem *base_address,
-				  u32 virtual_addr, u32 page_sz);
-
 extern hw_status hw_mmu_tlb_add(void __iomem *base_address,
 				u32 physical_addr,
 				u32 virtual_addr,
-- 
1.7.9.5

