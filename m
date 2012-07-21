Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2GURUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 13:20:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64686 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2GURUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 13:20:49 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, joerg.roedel@amd.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] iommu: Fix typo in iommu
Date: Sun, 22 Jul 2012 02:21:32 +0900
Message-Id: <1342891292-8055-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.11.2.249.g31c7954
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in debug messages and comments
in drivers/iommu.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/iommu/amd_iommu_v2.c |  2 +-
 drivers/iommu/exynos-iommu.c |  2 +-
 drivers/iommu/iova.c         | 14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 036fe9b..be03238 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -924,7 +924,7 @@ static int __init amd_iommu_v2_init(void)
 	pr_info("AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>\n");
 
 	if (!amd_iommu_v2_supported()) {
-		pr_info("AMD IOMMUv2 functionality not available on this sytem\n");
+		pr_info("AMD IOMMUv2 functionality not available on this system\n");
 		/*
 		 * Load anyway to provide the symbols to other modules
 		 * which may use AMD IOMMUv2 optionally.
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 9a114b9..4407d5e 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -317,7 +317,7 @@ static int default_fault_handler(enum exynos_sysmmu_inttype itype,
 	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
 		itype = SYSMMU_FAULT_UNKNOWN;
 
-	pr_err("%s occured at 0x%lx(Page table base: 0x%lx)\n",
+	pr_err("%s occurred at 0x%lx(Page table base: 0x%lx)\n",
 			sysmmu_fault_name[itype], fault_addr, pgtable_base);
 
 	ent = section_entry(__va(pgtable_base), fault_addr);
diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index c5c274a..67da6cff 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -198,10 +198,10 @@ iova_insert_rbtree(struct rb_root *root, struct iova *iova)
 
 /**
  * alloc_iova - allocates an iova
- * @iovad - iova domain in question
- * @size - size of page frames to allocate
- * @limit_pfn - max limit address
- * @size_aligned - set if size_aligned address range is required
+ * @iovad: - iova domain in question
+ * @size: - size of page frames to allocate
+ * @limit_pfn: - max limit address
+ * @size_aligned: - set if size_aligned address range is required
  * This function allocates an iova in the range limit_pfn to IOVA_START_PFN
  * looking from limit_pfn instead from IOVA_START_PFN. If the size_aligned
  * flag is set then the allocated address iova->pfn_lo will be naturally
@@ -238,8 +238,8 @@ alloc_iova(struct iova_domain *iovad, unsigned long size,
 
 /**
  * find_iova - find's an iova for a given pfn
- * @iovad - iova domain in question.
- * pfn - page frame number
+ * @iovad: - iova domain in question.
+ * @pfn: - page frame number
  * This function finds and returns an iova belonging to the
  * given doamin which matches the given pfn.
  */
@@ -260,7 +260,7 @@ struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn)
 			/* We are not holding the lock while this iova
 			 * is referenced by the caller as the same thread
 			 * which called this function also calls __free_iova()
-			 * and it is by desing that only one thread can possibly
+			 * and it is by design that only one thread can possibly
 			 * reference a particular iova and hence no conflict.
 			 */
 			return iova;
-- 
1.7.11.2.249.g31c7954

