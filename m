Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030586Ab2CUG5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:57:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030431Ab2CUG5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:57:05 -0400
Subject: [PATCH 12/16] mm/mips: use vm_flags_t for vma flags
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Date: Wed, 21 Mar 2012 10:57:02 +0400
Message-ID: <20120321065702.13852.81639.stgit@zurg>
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
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/mm/c-r3k.c  |    2 +-
 arch/mips/mm/c-r4k.c  |    6 +++---
 arch/mips/mm/c-tx39.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/mm/c-r3k.c b/arch/mips/mm/c-r3k.c
index 0765583..0ae0684 100644
--- a/arch/mips/mm/c-r3k.c
+++ b/arch/mips/mm/c-r3k.c
@@ -239,7 +239,7 @@ static void r3k_flush_cache_page(struct vm_area_struct *vma,
 				 unsigned long addr, unsigned long pfn)
 {
 	unsigned long kaddr = KSEG0ADDR(pfn << PAGE_SHIFT);
-	int exec = vma->vm_flags & VM_EXEC;
+	int exec = (vma->vm_flags & VM_EXEC) != VM_NONE;
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgdp;
 	pud_t *pudp;
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index c97087d..94b2b89 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -394,7 +394,7 @@ static void r4k__flush_cache_vunmap(void)
 static inline void local_r4k_flush_cache_range(void * args)
 {
 	struct vm_area_struct *vma = args;
-	int exec = vma->vm_flags & VM_EXEC;
+	int exec = (vma->vm_flags & VM_EXEC) != VM_NONE;
 
 	if (!(has_valid_asid(vma->vm_mm)))
 		return;
@@ -407,7 +407,7 @@ static inline void local_r4k_flush_cache_range(void * args)
 static void r4k_flush_cache_range(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end)
 {
-	int exec = vma->vm_flags & VM_EXEC;
+	int exec = (vma->vm_flags & VM_EXEC) != VM_NONE;
 
 	if (cpu_has_dc_aliases || (exec && !cpu_has_ic_fills_f_dc))
 		r4k_on_each_cpu(local_r4k_flush_cache_range, vma);
@@ -457,7 +457,7 @@ static inline void local_r4k_flush_cache_page(void *args)
 	struct vm_area_struct *vma = fcp_args->vma;
 	unsigned long addr = fcp_args->addr;
 	struct page *page = pfn_to_page(fcp_args->pfn);
-	int exec = vma->vm_flags & VM_EXEC;
+	int exec = (vma->vm_flags & VM_EXEC) != VM_NONE;
 	struct mm_struct *mm = vma->vm_mm;
 	int map_coherent = 0;
 	pgd_t *pgdp;
diff --git a/arch/mips/mm/c-tx39.c b/arch/mips/mm/c-tx39.c
index a43c197c..1227670 100644
--- a/arch/mips/mm/c-tx39.c
+++ b/arch/mips/mm/c-tx39.c
@@ -169,7 +169,7 @@ static void tx39_flush_cache_range(struct vm_area_struct *vma,
 
 static void tx39_flush_cache_page(struct vm_area_struct *vma, unsigned long page, unsigned long pfn)
 {
-	int exec = vma->vm_flags & VM_EXEC;
+	int exec = (vma->vm_flags & VM_EXEC) != VM_NONE;
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgdp;
 	pud_t *pudp;

