Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab2C0ABD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 20:01:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859Ab2C0ABA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 20:01:00 -0400
Date: Tue, 27 Mar 2012 02:00:12 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 39/39] autonuma: NUMA scheduler SMT awareness
Message-ID: <20120327000012.GC5906@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
 <1332783986-24195-40-git-send-email-aarcange@redhat.com>
 <1332788223.16159.185.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332788223.16159.185.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 08:57:03PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-03-26 at 19:46 +0200, Andrea Arcangeli wrote:
> > Add SMT awareness to the NUMA scheduler so that it will not move load
> > from fully idle SMT threads, to semi idle SMT threads.
> 
> This shows a complete fail in design, you're working around the regular
> scheduler/load-balancer instead of with it and hence are duplicating all
> kinds of stuff.
> 
> I'll not have that..

I think here you're misunderstanding implementation issues with
design.

I already mentioned the need of closer integration in CFS as point 4
of my TODO list in the first email of this thread. The current
implementation is just good enough to evaluate the AutoNUMA math and
the resulting final performance (and after cleaning it up, it'll run
even faster if something).

If you want to contribute to sched/numa.c integrate it with CFS and
remove the code duplication you're welcome. I tried for a short while
but it wasn't even obvious the exact lines in fair.c where SMT is
handled (I'm aware of SD_SHARE_CPUPOWER in SD_SIBLING_INIT but things
weren't crystal clear there, in fact it's even hard to extrapolate the
exact semantics of all SD_ bitflags, the comment on the right isn't
very helpful either). An explanation of the exact lines in CFS where
SMT is handled would be welcome too if I shall do the cleanup.

Thanks,
Andrea
