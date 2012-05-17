Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966Ab2EQL3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 07:29:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34128 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965682Ab2EQL26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 07:28:58 -0400
Message-ID: <1337254086.4281.26.camel@twins>
Subject: Re: [RFC][PATCH 4/6] arm, mm: Convert arm to generic tlb
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
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
        Nick Piggin <npiggin@kernel.dk>, Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Thu, 17 May 2012 13:28:06 +0200
In-Reply-To: <20120517095124.GN23420@flint.arm.linux.org.uk>
References: <20110302175928.022902359@chello.nl>
	 <20110302180259.109909335@chello.nl> <20120517030551.GA11623@linux-sh.org>
	 <20120517093022.GA14666@arm.com>
	 <20120517095124.GN23420@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 10:51 +0100, Russell King wrote:
> On Thu, May 17, 2012 at 10:30:23AM +0100, Catalin Marinas wrote:
> > Another minor thing is that on newer ARM processors (Cortex-A15) we
> > need the TLB shootdown even on UP systems, so tlb_fast_mode should
> > always return 0. Something like below (untested):
> 
> No Catalin, we need this for virtually all ARMv7 CPUs whether they're UP
> or SMP, not just for A15, because of the speculative prefetch which can
> re-load TLB entries from the page tables at _any_ time.

Hmm,. so this is mostly because of the confusion/coupling between
tlb_remove_page() and tlb_remove_table() I guess. Since I don't see the
freeing of the actual pages being a problem with speculative TLB
reloads, just the page-tables.

Should we introduce a tlb_remove_table() regardless of
HAVE_RCU_TABLE_FREE which always queues the tables regardless of
tlb_fast_mode()? 


