Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1DUNaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:30:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:59671 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1DUN37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:29:59 -0400
Subject: Re: [PATCH 14/20] mm: Remove i_mmap_lock lockbreak
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <20110419130719.86093a27.akpm@linux-foundation.org>
References: <20110401121258.211963744@chello.nl>
	 <20110401121725.991633993@chello.nl>
	 <20110419130719.86093a27.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 15:32:35 +0200
Message-ID: <1303392755.2035.141.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 13:07 -0700, Andrew Morton wrote:
> On Fri, 01 Apr 2011 14:13:12 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Hugh says:
> >  "The only significant loser, I think, would be page reclaim (when
> >   concurrent with truncation): could spin for a long time waiting for
> >   the i_mmap_mutex it expects would soon be dropped? "
> > 
> > Counter points:
> >  - cpu contention makes the spin stop (need_resched())
> >  - zap pages should be freeing pages at a higher rate than reclaim
> >    ever can
> > 
> > I think the simplification of the truncate code is definately worth it.
> 
> Well, we don't need to guess.  These things are testable!

I suppose you're right, but I'm having a bit of a hard time coming up
with a sensible (reproducible) test case for the page reclaim part of
this problem set.

I'll try running 3 cyclic file scanners sized such that 2 exceed the
memory footprint of the machine and truncate the 3rd's file after
warming up.

That is, unless someone has a saner idea..

