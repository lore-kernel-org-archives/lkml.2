Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab0HaGMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:12:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:46330 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab0HaGMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:12:06 -0400
Subject: Re: [PATCH 01/20] powerpc: Use call_rcu_sched() for pagetables
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@suse.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20100828142455.464074954@chello.nl>
References: <20100828141637.421594670@chello.nl>
	 <20100828142455.464074954@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 16:10:10 +1000
Message-ID: <1283235010.2151.16.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-28 at 16:16 +0200, Peter Zijlstra wrote:
> plain text document attachment (powerpc-pgtable-call_rcu_sched.patch)
> PowerPC relies on IRQ-disable to guard against RCU quiecent states,
> use the appropriate RCU call version.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

So as per discussions with Paul Mck, that should be correct,
thus

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  arch/powerpc/mm/pgtable.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/powerpc/mm/pgtable.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/mm/pgtable.c
> +++ linux-2.6/arch/powerpc/mm/pgtable.c
> @@ -92,7 +92,7 @@ static void pte_free_rcu_callback(struct
>  
>  static void pte_free_submit(struct pte_freelist_batch *batch)
>  {
> -	call_rcu(&batch->rcu, pte_free_rcu_callback);
> +	call_rcu_sched(&batch->rcu, pte_free_rcu_callback);
>  }
>  
>  void pgtable_free_tlb(struct mmu_gather *tlb, void *table, unsigned shift)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


