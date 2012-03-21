Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2CUMNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 08:13:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab2CUMNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 08:13:45 -0400
Date: Wed, 21 Mar 2012 13:08:07 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dan Smith <danms@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] AutoNUMA alpha6
Message-ID: <20120321120807.GV24602@redhat.com>
References: <20120316144028.036474157@chello.nl>
 <20120316182511.GJ24602@redhat.com>
 <87k42edenh.fsf@danplanet.com>
 <20120321021239.GQ24602@redhat.com>
 <20120321071258.GA24997@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321071258.GA24997@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 08:12:58AM +0100, Ingo Molnar wrote:
> 
> * Andrea Arcangeli <aarcange@redhat.com> wrote:
> 
> > [...]
> > 
> > So give me a break... you must have made a real mess in your 
> > benchmarking. numasched is always doing worse than upstream 
> > here, in fact two times massively worse. Almost as bad as the 
> > inverse binds.
> 
> Andrea, please stop attacking the messenger.

I am simply informing him. Why should not inform him that the way he
performed the benchmark wasn't the best way?

I informed him because it wasn't entirely documented how to properly
run by benchmark set. I would have expected people to read my pdf I
posted 2 months ago already that explains it:

http://www.kernel.org/pub/linux/kernel/people/andrea/autonuma/
http://www.kernel.org/pub/linux/kernel/people/andrea/autonuma/autonuma_bench-20120126.pdf

Jump to page 7.

Two modes:

numa01 -DNO_BIND_FORCE_SAME_NODE
numa01 -DTHREAD_ALLOC

I recommend Dan to now as last thing repeat the numasched benchmark
with the numa01 built was -DNO_BIND_FORCE_SAME_NODE.

For me neither -DNO_BIND_FORCE_SAME_NODE nor DTHREAD_ALLOC nor numa02
perform, in fact numa01 tends to hang and they never end.

> We wanted and needed more testing, and I'm glad that we got it.

Yes, I also posted the specjbb and I did a kernel build as measurement
of the worst case overhead of the numa hinting page fault.

You can see it here:

http://www.kernel.org/pub/linux/kernel/people/andrea/autonuma/autonuma_bench-20120321.pdf

> Can we please figure out all the details *without* accusing 
> anyone of having made a mess? It is quite possible as well that 
> *you* made a mess of it somewhere, either at the conceptual 
> stage or at the implementational stage, right?

I didn't make a mess. I also repeated without lockdep still same
thing, in fact now it never ends. I'll have to reboot a few more times
to see if I can get at least some number out.

Maybe it takes -DNO_BIND_FORCE_SAME_NODE to show the brokeness, I'll
wait Dan to repeat the numasched test with either
-DNO_BIND_FORCE_SAME_NODE or -DTHREAD_ALLOC.

Or maybe the higher ram (24G vs my 16G) could have played a role.
