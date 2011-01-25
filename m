Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1AYSD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:03:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49172 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1AYR7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:59:31 -0500
Message-Id: <20110125174907.552970417@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 25 Jan 2011 18:31:18 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 07/25] sh: Preemptible mmu_gather
References: <20110125173111.720927511@chello.nl>
Content-Disposition: inline; filename=peter_zijlstra-sh-preemptible_mmu_gather.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the sh mmu_gahter code to conform to the new API.

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/sh/include/asm/tlb.h |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/sh/include/asm/tlb.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/tlb.h
+++ linux-2.6/arch/sh/include/asm/tlb.h
@@ -23,8 +23,6 @@ struct mmu_gather {
 	unsigned long		start, end;
 };
 
-DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static inline void init_tlb_gather(struct mmu_gather *tlb)
 {
 	tlb->start = TASK_SIZE;
@@ -36,17 +34,13 @@ static inline void init_tlb_gather(struc
 	}
 }
 
-static inline struct mmu_gather *
-tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+static inline void
+tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
 {
-	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
-
 	tlb->mm = mm;
 	tlb->fullmm = full_mm_flush;
 
 	init_tlb_gather(tlb);
-
-	return tlb;
 }
 
 static inline void
@@ -57,8 +51,6 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
-
-	put_cpu_var(mmu_gathers);
 }
 
 static inline void


