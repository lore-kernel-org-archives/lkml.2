Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1EDSQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:16:51 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:52800 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1EDSQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:16:50 -0400
Date: Wed, 4 May 2011 20:16:42 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH 3/8] arch/x86/xen/mmu: Cleanup code/data sections definitions
Message-ID: <20110504181642.GD29218@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup code/data sections definitions
accordingly to include/linux/init.h.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 arch/x86/xen/mmu.c |   46 +++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 55c965b..99ba9ec 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1054,7 +1054,7 @@ void xen_mm_pin_all(void)
  * that's before we have page structures to store the bits.  So do all
  * the book-keeping now.
  */
-static __init int xen_mark_pinned(struct mm_struct *mm, struct page *page,
+static int __init xen_mark_pinned(struct mm_struct *mm, struct page *page,
 				  enum pt_level level)
 {
 	SetPagePinned(page);
@@ -1271,13 +1271,13 @@ void xen_exit_mmap(struct mm_struct *mm)
 	spin_unlock(&mm->page_table_lock);
 }
 
-static __init void xen_pagetable_setup_start(pgd_t *base)
+static void __init xen_pagetable_setup_start(pgd_t *base)
 {
 }
 
 static void xen_post_allocator_init(void);
 
-static __init void xen_pagetable_setup_done(pgd_t *base)
+static void __init xen_pagetable_setup_done(pgd_t *base)
 {
 	xen_setup_shared_info();
 	xen_post_allocator_init();
@@ -1464,10 +1464,10 @@ static int xen_pgd_alloc(struct mm_struct *mm)
 }
 
 #ifdef CONFIG_X86_64
-static __initdata u64 __last_pgt_set_rw = 0;
-static __initdata u64 __pgt_buf_start = 0;
-static __initdata u64 __pgt_buf_end = 0;
-static __initdata u64 __pgt_buf_top = 0;
+static u64 __last_pgt_set_rw __initdata = 0;
+static u64 __pgt_buf_start __initdata = 0;
+static u64 __pgt_buf_end __initdata = 0;
+static u64 __pgt_buf_top __initdata = 0;
 /*
  * As a consequence of the commit:
  * 
@@ -1516,7 +1516,7 @@ static __initdata u64 __pgt_buf_top = 0;
  * And then we update those "old" pgt_buf_[end|top] with the new ones
  * so that we can redo this on the next pagetable.
  */
-static __init void mark_rw_past_pgt(void) {
+static void __init mark_rw_past_pgt(void) {
 
 	if (pgt_buf_end > pgt_buf_start) {
 		u64 addr, size;
@@ -1574,7 +1574,7 @@ static __init void mark_rw_past_pgt(void) {
 	return;
 }
 #else
-static __init void mark_rw_past_pgt(void) { }
+static void __init mark_rw_past_pgt(void) { }
 #endif
 static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
@@ -1587,7 +1587,7 @@ static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
 }
 
 #ifdef CONFIG_X86_32
-static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
+static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
 {
 	/* If there's an existing pte, then don't allow _PAGE_RW to be set */
 	if (pte_val_ma(*ptep) & _PAGE_PRESENT)
@@ -1597,7 +1597,7 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 	return pte;
 }
 #else /* CONFIG_X86_64 */
-static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
+static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
 {
 	unsigned long pfn = pte_pfn(pte);
 
@@ -1626,7 +1626,7 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 
 /* Init-time set_pte while constructing initial pagetables, which
    doesn't allow RO pagetable pages to be remapped RW */
-static __init void xen_set_pte_init(pte_t *ptep, pte_t pte)
+static void __init xen_set_pte_init(pte_t *ptep, pte_t pte)
 {
 	pte = mask_rw_pte(ptep, pte);
 
@@ -1644,7 +1644,7 @@ static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
 
 /* Early in boot, while setting up the initial pagetable, assume
    everything is pinned. */
-static __init void xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
+static void __init xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
 {
 #ifdef CONFIG_FLATMEM
 	BUG_ON(mem_map);	/* should only be used early */
@@ -1654,7 +1654,7 @@ static __init void xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
 }
 
 /* Used for pmd and pud */
-static __init void xen_alloc_pmd_init(struct mm_struct *mm, unsigned long pfn)
+static void __init xen_alloc_pmd_init(struct mm_struct *mm, unsigned long pfn)
 {
 #ifdef CONFIG_FLATMEM
 	BUG_ON(mem_map);	/* should only be used early */
@@ -1664,13 +1664,13 @@ static __init void xen_alloc_pmd_init(struct mm_struct *mm, unsigned long pfn)
 
 /* Early release_pte assumes that all pts are pinned, since there's
    only init_mm and anything attached to that is pinned. */
-static __init void xen_release_pte_init(unsigned long pfn)
+static void __init xen_release_pte_init(unsigned long pfn)
 {
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
 
-static __init void xen_release_pmd_init(unsigned long pfn)
+static void __init xen_release_pmd_init(unsigned long pfn)
 {
 	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
@@ -1796,7 +1796,7 @@ static void set_page_prot(void *addr, pgprot_t prot)
 		BUG();
 }
 
-static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
+static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 {
 	unsigned pmdidx, pteidx;
 	unsigned ident_pte;
@@ -1879,7 +1879,7 @@ static void convert_pfn_mfn(void *v)
  * of the physical mapping once some sort of allocator has been set
  * up.
  */
-__init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
+pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 					 unsigned long max_pfn)
 {
 	pud_t *l3;
@@ -1950,7 +1950,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 static RESERVE_BRK_ARRAY(pmd_t, initial_kernel_pmd, PTRS_PER_PMD);
 static RESERVE_BRK_ARRAY(pmd_t, swapper_kernel_pmd, PTRS_PER_PMD);
 
-static __init void xen_write_cr3_init(unsigned long cr3)
+static void __init xen_write_cr3_init(unsigned long cr3)
 {
 	unsigned long pfn = PFN_DOWN(__pa(swapper_pg_dir));
 
@@ -1987,7 +1987,7 @@ static __init void xen_write_cr3_init(unsigned long cr3)
 	pv_mmu_ops.write_cr3 = &xen_write_cr3;
 }
 
-__init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
+pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 					 unsigned long max_pfn)
 {
 	pmd_t *kernel_pmd;
@@ -2093,7 +2093,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #endif
 }
 
-__init void xen_ident_map_ISA(void)
+void __init xen_ident_map_ISA(void)
 {
 	unsigned long pa;
 
@@ -2116,7 +2116,7 @@ __init void xen_ident_map_ISA(void)
 	xen_flush_tlb();
 }
 
-static __init void xen_post_allocator_init(void)
+static void __init xen_post_allocator_init(void)
 {
 	mark_rw_past_pgt();
 
@@ -2155,7 +2155,7 @@ static void xen_leave_lazy_mmu(void)
 	preempt_enable();
 }
 
-static const struct pv_mmu_ops xen_mmu_ops __initdata = {
+static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.read_cr2 = xen_read_cr2,
 	.write_cr2 = xen_write_cr2,
 
-- 
1.5.6.5
