Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278Ab1D0XhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:37:11 -0400
Received: from mout.perfora.net ([74.208.4.194]:64631 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760257Ab1D0XhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:37:06 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] mm: remove check_huge_range()
Date: Wed, 27 Apr 2011 19:35:46 -0400
Message-Id: <1303947349-3620-6-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1303947349-3620-1-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:7vh2g4YDfeDg2fpgphjyJqSrjFNShTFaMntjtkwmvVT
 a1W6hNWNybomt08SEhZ0YPmk4HSHj89ZWqmd7mqxHSAvV2M8EW
 2AnJHBFL9qxBGUABKo+bRrysKdtk7gosK20CIqQIlT2LMCYsQ4
 iwuKMzs42n05wAtKpx5RuIbQZ0bzBiodYvIbxySsqGTE5kZGxs
 0pYEiYkIoDYgp6wSd4zbYJDQIpzPhZzxT3lWNi7Ka4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function has been superseded by gather_hugetbl_stats() and is no
longer needed.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 mm/mempolicy.c |   35 -----------------------------------
 1 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d4c0b8d..c5a4342 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2587,35 +2587,6 @@ static int gather_pte_stats(pte_t *pte, unsigned long addr,
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
@@ -2635,12 +2606,6 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
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
1.7.3.5

