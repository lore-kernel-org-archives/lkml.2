Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2KVUgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:36:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35649 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab2KVUg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:36:28 -0500
Date: Thu, 22 Nov 2012 10:05:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/46] Automatic NUMA Balancing V4
Message-ID: <20121122090514.GA17769@gmail.com>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
 <20121121165342.GH8218@suse.de>
 <20121121170306.GA28811@gmail.com>
 <20121121172011.GI8218@suse.de>
 <20121121173316.GA29311@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121173316.GA29311@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > On Wed, Nov 21, 2012 at 06:03:06PM +0100, Ingo Molnar wrote:
> > > 
> > > * Mel Gorman <mgorman@suse.de> wrote:
> > > 
> > > > On Wed, Nov 21, 2012 at 10:21:06AM +0000, Mel Gorman wrote:
> > > > > 
> > > > > I am not including a benchmark report in this but will be posting one
> > > > > shortly in the "Latest numa/core release, v16" thread along with the latest
> > > > > schednuma figures I have available.
> > > > > 
> > > > 
> > > > Report is linked here https://lkml.org/lkml/2012/11/21/202
> > > > 
> > > > I ended up cancelling the remaining tests and restarted with
> > > > 
> > > > 1. schednuma + patches posted since so that works out as
> > > 
> > > Mel, I'd like to ask you to refer to our tree as numa/core or 
> > > 'numacore' in the future. Would such a courtesy to use the 
> > > current name of our tree be possible?
> > > 
> > 
> > Sure, no problem.
> 
> Thanks!
> 
> I ran a quick test with your 'balancenuma v4' tree and while 
> numa02 and numa01-THREAD-ALLOC performance is looking good, 
> numa01 performance does not look very good:
> 
>                     mainline    numa/core      balancenuma-v4
>      numa01:           340.3       139.4          276 secs
> 
> 97% slower than numa/core.

I mean numa/core was 97% faster. That transforms into 
balancenuma-v4 being 50.5% slower.

Your numbers from yesterday showed an even bigger proportion:

AUTONUMA BENCH
                                          3.7.0                 3.7.0                 3.7.0                 3.7.0                 
3.7.0                 3.7.0
                                rc6-stats-v4r12   rc6-schednuma-v16r2 rc6-autonuma-v28fastr3	  rc6-moron-v4r38    rc6-twostage-v4r38  rc6-thpmigrate-v4r38
Elapsed NUMA01                1668.03 (  0.00%)      486.04 ( 70.86%) 	   794.10 ( 52.39%)	 601.19 ( 63.96%)     1575.52 (  5.55%)     1066.67 ( 36.05%)

In your test numa/core was 240% times faster than mainline, 63% 
faster than autonuma and 119% faster than 
balancenuma-"rc6-thpmigrate-v4r38".

Thanks,

	Ingo
