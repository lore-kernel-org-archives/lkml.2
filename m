Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030648Ab2CUG6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:58:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965024Ab2CUG5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:57:14 -0400
Subject: [PATCH 14/16] mm/score: use vm_flags_t for vma flags
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lennox Wu <lennox.wu@gmail.com>, Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 21 Mar 2012 10:57:10 +0400
Message-ID: <20120321065710.13852.36939.stgit@zurg>
In-Reply-To: <20120321065140.13852.52315.stgit@zurg>
References: <20120321065140.13852.52315.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/mm/cache.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/score/mm/cache.c b/arch/score/mm/cache.c
index b25e957..2288ffc 100644
--- a/arch/score/mm/cache.c
+++ b/arch/score/mm/cache.c
@@ -79,7 +79,7 @@ void __update_cache(struct vm_area_struct *vma, unsigned long address,
 {
 	struct page *page;
 	unsigned long pfn, addr;
-	int exec = (vma->vm_flags & VM_EXEC);
+	int exec = (vma->vm_flags & VM_EXEC) != VM_NONE;
 
 	pfn = pte_pfn(pte);
 	if (unlikely(!pfn_valid(pfn)))
@@ -172,7 +172,7 @@ void flush_cache_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	int exec = vma->vm_flags & VM_EXEC;
+	int exec = (vma->vm_flags & VM_EXEC) != VM_NONE;
 	pgd_t *pgdp;
 	pud_t *pudp;
 	pmd_t *pmdp;
@@ -210,7 +210,7 @@ void flush_cache_range(struct vm_area_struct *vma,
 void flush_cache_page(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn)
 {
-	int exec = vma->vm_flags & VM_EXEC;
+	int exec = (vma->vm_flags & VM_EXEC) != VM_NONE;
 	unsigned long kaddr = 0xa0000000 | (pfn << PAGE_SHIFT);
 
 	flush_dcache_range(kaddr, kaddr + PAGE_SIZE);

