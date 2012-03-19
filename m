Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab2CSN7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:59:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab2CSN66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:58:58 -0400
Date: Mon, 19 Mar 2012 14:57:45 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 00/26] sched/numa
Message-ID: <20120319135745.GL24602@redhat.com>
References: <20120316144028.036474157@chello.nl>
 <4F670325.7080700@redhat.com>
 <1332155527.18960.292.camel@twins>
 <20120319130401.GI24602@redhat.com>
 <1332163591.18960.334.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332163591.18960.334.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 02:26:31PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-19 at 14:04 +0100, Andrea Arcangeli wrote:
> > If you boot with memcg compiled in, that's taking an equivalent amount
> > of memory per-page.
> > 
> > If you can bear the memory loss when memcg is compiled in even when
> > not enabled, you sure can bear it on NUMA systems that have lots of
> > memory, so it's perfectly ok to sacrifice a bit of it so that it
> > performs like not-NUMA but you still have more memory than not-NUMA.
> > 
> I think the overhead of memcg is quite insane as well. And no I cannot
> bear that and have it disabled in all my kernels.
> 
> NUMA systems having lots of memory is a false argument, that doesn't
> mean we can just waste tons of it, people pay good money for that
> memory, they want to use it.
> 
> I fact, I know that HPC people want things like swap-over-nfs so they
> can push infrequently running system crap out into swap so they can get
> these few extra megabytes of memory. And you're proposing they give up
> ~100M just like that?

With your code they will get -ENOMEM from split_vma and a slowdown in
all regular page faults and vma mangling operations, before they run
out of memory...

The per-page memory loss is 24bytes, AutoNUMA in page terms costs 0.5%
of ram (and only if booted on NUMA hardware, unless noautonuma is
passed as parameter), and I can't imagine that to be a problem on a
system where hardware vendor took shortcuts to install massive amounts
of RAM that is fast to access only locally. If you buy that kind of
hardware losing the cost of 0.5% of RAM of it, is ridiculous compared
to the programmer cost of patching all apps.
