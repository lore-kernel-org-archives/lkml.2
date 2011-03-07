Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1CGRuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:50:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43063 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab1CGRtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:49:50 -0500
Message-Id: <20110307172207.445811237@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Mar 2011 18:14:04 +0100
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
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][PATCH 14/15] mm, sparc32: Convert sparc32 to generic tlb
References: <20110307171350.989666626@chello.nl>
Content-Disposition: inline; filename=sparc32-mmu_range.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/sparc/Kconfig              |    1 +
 arch/sparc/include/asm/tlb_32.h |   10 ----------
 2 files changed, 1 insertion(+), 10 deletions(-)

Index: linux-2.6/arch/sparc/Kconfig
===================================================================
--- linux-2.6.orig/arch/sparc/Kconfig
+++ linux-2.6/arch/sparc/Kconfig
@@ -25,6 +25,7 @@ config SPARC
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_MMU_GATHER_RANGE
 
 config SPARC32
 	def_bool !64BIT
Index: linux-2.6/arch/sparc/include/asm/tlb_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/tlb_32.h
+++ linux-2.6/arch/sparc/include/asm/tlb_32.h
@@ -1,16 +1,6 @@
 #ifndef _SPARC_TLB_H
 #define _SPARC_TLB_H
 
-#define tlb_start_vma(tlb, vma) \
-do {								\
-	flush_cache_range(vma, vma->vm_start, vma->vm_end);	\
-} while (0)
-
-#define tlb_end_vma(tlb, vma) \
-do {								\
-	flush_tlb_range(vma, vma->vm_start, vma->vm_end);	\
-} while (0)
-
 #define __tlb_remove_tlb_entry(tlb, pte, address) \
 	do { } while (0)
 


