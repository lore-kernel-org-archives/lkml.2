Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2CBAcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:32:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab2CBAcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:32:13 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH v2 1/2] thp: add HPAGE_PMD_* definitions for !CONFIG_TRANSPARENT_HUGEPAGE
Date: Thu,  1 Mar 2012 19:31:52 -0500
Message-Id: <1330648313-32593-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros will be used in later patch, where all usage are expected
to be optimized away without #ifdef CONFIG_TRANSPARENT_HUGEPAGE.
But to detect unexpected usages, we convert existing BUG() to BUILD_BUG().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/huge_mm.h |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git linux-next-20120228.orig/include/linux/huge_mm.h linux-next-20120228/include/linux/huge_mm.h
index f56cacb..c8af7a2 100644
--- linux-next-20120228.orig/include/linux/huge_mm.h
+++ linux-next-20120228/include/linux/huge_mm.h
@@ -51,6 +51,9 @@ extern pmd_t *page_check_address_pmd(struct page *page,
 				     unsigned long address,
 				     enum page_check_address_pmd_flag flag);
 
+#define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
+#define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define HPAGE_PMD_SHIFT HPAGE_SHIFT
 #define HPAGE_PMD_MASK HPAGE_MASK
@@ -102,8 +105,6 @@ extern void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd);
 		BUG_ON(pmd_trans_splitting(*____pmd) ||			\
 		       pmd_trans_huge(*____pmd));			\
 	} while (0)
-#define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
-#define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
 #if HPAGE_PMD_ORDER > MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
@@ -158,9 +159,9 @@ static inline struct page *compound_trans_head(struct page *page)
 	return page;
 }
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
-#define HPAGE_PMD_SHIFT ({ BUG(); 0; })
-#define HPAGE_PMD_MASK ({ BUG(); 0; })
-#define HPAGE_PMD_SIZE ({ BUG(); 0; })
+#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
 
 #define hpage_nr_pages(x) 1
 
-- 
1.7.7.6

