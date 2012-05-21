Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2EUHru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:47:50 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:53153 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2EUHrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:47:47 -0400
Date: Mon, 21 May 2012 09:47:09 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>, Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFC][PATCH 4/6] arm, mm: Convert arm to generic tlb
Message-ID: <20120521094709.6036d868@de.ibm.com>
In-Reply-To: <1337271884.4281.46.camel@twins>
References: <20110302175928.022902359@chello.nl>
	<20110302180259.109909335@chello.nl>
	<20120517030551.GA11623@linux-sh.org>
	<20120517093022.GA14666@arm.com>
	<20120517095124.GN23420@flint.arm.linux.org.uk>
	<1337254086.4281.26.camel@twins>
	<20120517160012.GB18593@arm.com>
	<1337271884.4281.46.camel@twins>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12052107-5024-0000-0000-0000029B05C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012 18:24:44 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2012-05-17 at 17:00 +0100, Catalin Marinas wrote:
> 
> > BTW, looking at your tlb-unify branch, does tlb_remove_table() call
> > tlb_flush/tlb_flush_mmu before freeing the tables?  I can only see
> > tlb_remove_page() doing this. On ARM, even UP, we need the TLB flushing
> > after clearing the pmd and before freeing the pte page table (and
> > ideally doing it less often than at every pte_free_tlb() call).
> 
> No I don't think it does, so far the only archs using the RCU stuff are
> ppc,sparc and s390 and none of those needed that (Xen might join them
> soon though). But I will have to look and consider this more carefully.
> I 'lost' most of the ppc/sparc/s390 details from memory to say this with
> any certainty.
 
s390 needs a TLB flush for the pgd, pud and pmd tables. See git commit
cd94154cc6a28dd9dc271042c1a59c08d26da886 for the sad details.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

