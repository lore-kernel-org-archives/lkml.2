Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0FGLUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:20:30 -0400
Received: from [18.85.46.34] ([18.85.46.34]:37727 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab0FGLUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:25 -0400
Message-Id: <20100607111406.477271904@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:06:55 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 01/28] powerpc: Use call_rcu_sched() for pagetables
References: <20100607110654.606530953@chello.nl>
Content-Disposition: inline; filename=powerpc-pgtable-call_rcu_sched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC relies on IRQ-disable to guard against RCU quiecent states,
use the appropriate RCU call version.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/mm/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/powerpc/mm/pgtable.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/pgtable.c
+++ linux-2.6/arch/powerpc/mm/pgtable.c
@@ -93,7 +93,7 @@ static void pte_free_rcu_callback(struct
 static void pte_free_submit(struct pte_freelist_batch *batch)
 {
 	INIT_RCU_HEAD(&batch->rcu);
-	call_rcu(&batch->rcu, pte_free_rcu_callback);
+	call_rcu_sched(&batch->rcu, pte_free_rcu_callback);
 }
 
 void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)


