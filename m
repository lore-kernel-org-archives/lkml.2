Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0DSTQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:16:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab0DSTQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:16:20 -0400
Subject: Re: [PATCH 06/13] mm: Preemptible mmu_gather
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
In-Reply-To: <1270845384.20295.3369.camel@laptop>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.858079986@chello.nl>  <20100409032509.GH5683@laptop>
	 <1270845384.20295.3369.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 21:16:15 +0200
Message-ID: <1271704575.1676.251.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 22:36 +0200, Peter Zijlstra wrote:
> On Fri, 2010-04-09 at 13:25 +1000, Nick Piggin wrote:
> > Have you done some profiling on this? What I would like to see, if
> > it's not too much complexity, is to have a small set of pages to
> > handle common size frees, and then use them up first by default
> > before attempting to allocate more.
> > 
> > Also, it would be cool to be able to chain allocations to avoid
> > TLB flushes even on big frees (overridable by arch of course, in
> > case they're doing some non-preeemptible work or you wish to break
> > up lock hold times). But that might be just getting over engineered.

[ patch to do very long queues ]

One thing that comes from having preemptible mmu_gather, and esp. when
we allow such very long gathers, is that we can potentially have a very
large amount of pages stuck on these lists.

So we'd need to hook into reclaim somehow to allow flushing of them when
we're falling short.

