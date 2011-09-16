Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1IPRsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:48:33 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:57294 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1IPRsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:48:32 -0400
From: Tzu-Jung Lee <roylee17@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rmk+kernel@arm.linux.org.uk, aarcange@redhat.com,
        Tzu-Jung Lee <tjlee@ambarella.com>
Subject: [PATCH] mm: add dummy place holders when TRANSPARENT_HUGEPAGE is undefined
Date: Sat, 17 Sep 2011 01:46:48 +0800
Message-Id: <1316195208-21098-1-git-send-email-tjlee@ambarella.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To eliminate compile-time errors when built with -O0

Change-Id: I57d63b9168d31499d234afbc1db6e25966b1b08b
Signed-off-by: Tzu-Jung Lee <tjlee@ambarella.com>

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8847c8c..edd68a9 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -1,6 +1,24 @@
 #ifndef _LINUX_HUGE_MM_H
 #define _LINUX_HUGE_MM_H
 
+enum transparent_hugepage_flag {
+	TRANSPARENT_HUGEPAGE_FLAG,
+	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+	TRANSPARENT_HUGEPAGE_DEFRAG_FLAG,
+	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
+	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
+#ifdef CONFIG_DEBUG_VM
+	TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG,
+#endif
+};
+
+enum page_check_address_pmd_flag {
+	PAGE_CHECK_ADDRESS_PMD_FLAG,
+	PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG,
+	PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG,
+};
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern int do_huge_pmd_anonymous_page(struct mm_struct *mm,
 				      struct vm_area_struct *vma,
 				      unsigned long address, pmd_t *pmd,
@@ -24,29 +42,11 @@ extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned char *vec);
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, pgprot_t newprot);
-
-enum transparent_hugepage_flag {
-	TRANSPARENT_HUGEPAGE_FLAG,
-	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
-	TRANSPARENT_HUGEPAGE_DEFRAG_FLAG,
-	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
-	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
-#ifdef CONFIG_DEBUG_VM
-	TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG,
-#endif
-};
-
-enum page_check_address_pmd_flag {
-	PAGE_CHECK_ADDRESS_PMD_FLAG,
-	PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG,
-	PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG,
-};
 extern pmd_t *page_check_address_pmd(struct page *page,
 				     struct mm_struct *mm,
 				     unsigned long address,
 				     enum page_check_address_pmd_flag flag);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define HPAGE_PMD_SHIFT HPAGE_SHIFT
 #define HPAGE_PMD_MASK HPAGE_MASK
 #define HPAGE_PMD_SIZE HPAGE_SIZE
@@ -175,6 +175,64 @@ static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 long adjust_next)
 {
 }
+static inline int do_huge_pmd_anonymous_page(struct mm_struct *mm,
+				      struct vm_area_struct *vma,
+				      unsigned long address, pmd_t *pmd,
+				      unsigned int flags)
+{
+	return 0;
+}
+static inline int copy_huge_pmd(struct mm_struct *dst_mm,
+			struct mm_struct *src_mm,
+			pmd_t *dst_pmd, pmd_t *src_pmd,
+			unsigned long addr,
+			struct vm_area_struct *vma)
+{
+	return 0;
+}
+static inline int do_huge_pmd_wp_page(struct mm_struct *mm,
+			struct vm_area_struct *vma,
+			unsigned long address,
+			pmd_t *pmd,
+			pmd_t orig_pmd)
+{
+	return 0;
+}
+static inline pgtable_t get_pmd_huge_pte(struct mm_struct *mm)
+{
+	return 0;
+}
+static inline struct page *follow_trans_huge_pmd(struct mm_struct *mm,
+					  unsigned long addr,
+					  pmd_t *pmd,
+					  unsigned int flags)
+{
+	return 0;
+}
+static inline int zap_huge_pmd(struct mmu_gather *tlb,
+			struct vm_area_struct *vma,
+			pmd_t *pmd)
+{
+	return 0;
+}
+static inline int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec)
+{
+	return 0;
+}
+static inline int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			unsigned long addr, pgprot_t newprot)
+{
+	return 0;
+}
+static inline pmd_t *page_check_address_pmd(struct page *page,
+				     struct mm_struct *mm,
+				     unsigned long address,
+				     enum page_check_address_pmd_flag flag)
+{
+	return 0;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
-- 
1.7.6.1

