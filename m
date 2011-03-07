Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1CGRtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:49:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab1CGRt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:49:28 -0500
Message-Id: <20110307172207.309211374@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Mar 2011 18:14:02 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Russell King <rmk@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [RFC][PATCH 12/15] mm, mips: Convert mips to generic tlb
References: <20110307171350.989666626@chello.nl>
Content-Disposition: inline; filename=mips-mmu_range.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/mips/Kconfig           |    1 +
 arch/mips/include/asm/tlb.h |   10 ----------
 2 files changed, 1 insertion(+), 10 deletions(-)

Index: linux-2.6/arch/mips/Kconfig
===================================================================
--- linux-2.6.orig/arch/mips/Kconfig
+++ linux-2.6/arch/mips/Kconfig
@@ -22,6 +22,7 @@ config MIPS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_MMU_GATHER_RANGE
 
 menu "Machine selection"
 
Index: linux-2.6/arch/mips/include/asm/tlb.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/tlb.h
+++ linux-2.6/arch/mips/include/asm/tlb.h
@@ -1,16 +1,6 @@
 #ifndef __ASM_TLB_H
 #define __ASM_TLB_H
 
-/*
- * MIPS doesn't need any special per-pte or per-vma handling, except
- * we need to flush cache for area to be unmapped.
- */
-#define tlb_start_vma(tlb, vma) 				\
-	do {							\
-		if (!tlb->fullmm)				\
-			flush_cache_range(vma, vma->vm_start, vma->vm_end); \
-	}  while (0)
-#define tlb_end_vma(tlb, vma) do { } while (0)
 #define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
 
 #include <asm-generic/tlb.h>


