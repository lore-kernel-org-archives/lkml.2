Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1CGRtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:49:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:56341 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1CGRtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:49:07 -0500
Message-Id: <20110307172207.513560565@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Mar 2011 18:14:05 +0100
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
        Chris Zankel <chris@zankel.net>
Subject: [RFC][PATCH 15/15] mm, xtensa: Convert xtensa to generic tlb
References: <20110307171350.989666626@chello.nl>
Content-Disposition: inline; filename=xtensa-mmu_range.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/xtensa/Kconfig           |    1 +
 arch/xtensa/include/asm/tlb.h |   23 -----------------------
 2 files changed, 1 insertion(+), 23 deletions(-)

Index: linux-2.6/arch/xtensa/Kconfig
===================================================================
--- linux-2.6.orig/arch/xtensa/Kconfig
+++ linux-2.6/arch/xtensa/Kconfig
@@ -7,6 +7,7 @@ config ZONE_DMA
 config XTENSA
 	def_bool y
 	select HAVE_IDE
+	select HAVE_MMU_GATHER_RANGE
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
Index: linux-2.6/arch/xtensa/include/asm/tlb.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/tlb.h
+++ linux-2.6/arch/xtensa/include/asm/tlb.h
@@ -14,29 +14,6 @@
 #include <asm/cache.h>
 #include <asm/page.h>
 
-#if (DCACHE_WAY_SIZE <= PAGE_SIZE)
-
-/* Note, read http://lkml.org/lkml/2004/1/15/6 */
-
-# define tlb_start_vma(tlb,vma)			do { } while (0)
-# define tlb_end_vma(tlb,vma)			do { } while (0)
-
-#else
-
-# define tlb_start_vma(tlb, vma)					      \
-	do {								      \
-		if (!tlb->fullmm)					      \
-			flush_cache_range(vma, vma->vm_start, vma->vm_end);   \
-	} while(0)
-
-# define tlb_end_vma(tlb, vma)						      \
-	do {								      \
-		if (!tlb->fullmm)					      \
-			flush_tlb_range(vma, vma->vm_start, vma->vm_end);     \
-	} while(0)
-
-#endif
-
 #define __tlb_remove_tlb_entry(tlb,pte,addr)	do { } while (0)
 
 #include <asm-generic/tlb.h>


