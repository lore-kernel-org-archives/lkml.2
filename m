Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0DIIIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 04:08:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47932 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab0DIIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 04:08:36 -0400
Subject: Re: [PATCH 09/13] mm, powerpc: Move the RCU page-table freeing
 into generic code
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20100409033532.GI5683@laptop>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.987227219@chello.nl>  <20100409033532.GI5683@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 10:08:31 +0200
Message-ID: <1270800511.20295.3214.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 13:35 +1000, Nick Piggin wrote:
> On Thu, Apr 08, 2010 at 09:17:46PM +0200, Peter Zijlstra wrote:
> > Index: linux-2.6/include/asm-generic/tlb.h
> > ===================================================================
> > --- linux-2.6.orig/include/asm-generic/tlb.h
> > +++ linux-2.6/include/asm-generic/tlb.h
> > @@ -27,6 +27,49 @@
> >    #define tlb_fast_mode(tlb) 1
> >  #endif
> >  
> > +#ifdef HAVE_ARCH_RCU_TABLE_FREE
> > +/*
> > + * Semi RCU freeing of the page directories.
> > + *
> > + * This is needed by some architectures to implement gup_fast().
> 
> Really? I see the comment in the powerpc code, but powerpc was already
> using RCU before gup_fast(), and AFAIKS it is indeed using it so that
> it can handle faults by getting the linux pte with find_linux_pte ?

Ah, see that is my ignorance of the powerpc mmu code, I've only been
staring at this mmu_gather piece long enough to (hopefully) make it
work.

If there is indeed more to it, then yes, that needs documenting.

