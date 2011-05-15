Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab1EOWXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 18:23:00 -0400
Received: from mout.perfora.net ([74.208.4.194]:53942 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761504Ab1EOWWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 18:22:35 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH v2 5/9] mm: remove check_huge_range()
Date: Sun, 15 May 2011 18:20:25 -0400
Message-Id: <1305498029-11677-6-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305498029-11677-1-git-send-email-wilsons@start.ca>
References: <1305498029-11677-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:PawbvHcKpcZs7c1fqM0YjDJMnBquaH4L8EFHRGTfZls
 sGAmSX9CMfALVPYtTi/jg7mTOgN5Y7me0CB4cnrgDqZa9EkBHv
 xcCisWABkw8gF0yrOLMD/8zWlGj/zYjTGA/QTUlJRPnnhUxSDE
 9PUeDm0qjOyQ3Q4q2DdNzGSnoCv4BUpwypKSWIOLcIbsQ7j3Sn
 q5b/dftNBDP4NPP1pkQj104ZQfio6zx8OmcFbaoTlk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function has been superseded by gather_hugetbl_stats() and is no
longer needed.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 mm/mempolicy.c |   35 -----------------------------------
 1 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 108f858..231efc8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2616,35 +2616,6 @@ static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static void check_huge_range(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end,
-		struct numa_maps *md)
-{
-	unsigned long addr;
-	struct page *page;
-	struct hstate *h = hstate_vma(vma);
-	unsigned long sz = huge_page_size(h);
-
-	for (addr = start; addr < end; addr += sz) {
-		pte_t *ptep = huge_pte_offset(vma->vm_mm,
-						addr & huge_page_mask(h));
-		pte_t pte;
-
-		if (!ptep)
-			continue;
-
-		pte = *ptep;
-		if (pte_none(pte))
-			continue;
-
-		page = pte_page(pte);
-		if (!page)
-			continue;
-
-		gather_stats(page, md, pte_dirty(*ptep));
-	}
-}
-
 static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
@@ -2664,12 +2635,6 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 }
 
 #else
-static inline void check_huge_range(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end,
-		struct numa_maps *md)
-{
-}
-
 static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
-- 
1.7.4.4

