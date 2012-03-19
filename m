Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031221Ab2CSOHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:07:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030222Ab2CSOHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:07:45 -0400
Message-ID: <4F673D73.90106@redhat.com>
Date: Mon, 19 Mar 2012 16:06:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
References: <20120316144028.036474157@chello.nl> <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins> <20120319130401.GI24602@redhat.com> <1332163591.18960.334.camel@twins> <20120319135745.GL24602@redhat.com>
In-Reply-To: <20120319135745.GL24602@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 03:57 PM, Andrea Arcangeli wrote:
> On Mon, Mar 19, 2012 at 02:26:31PM +0100, Peter Zijlstra wrote:
> > On Mon, 2012-03-19 at 14:04 +0100, Andrea Arcangeli wrote:
> > > If you boot with memcg compiled in, that's taking an equivalent amount
> > > of memory per-page.
> > > 
> > > If you can bear the memory loss when memcg is compiled in even when
> > > not enabled, you sure can bear it on NUMA systems that have lots of
> > > memory, so it's perfectly ok to sacrifice a bit of it so that it
> > > performs like not-NUMA but you still have more memory than not-NUMA.
> > > 
> > I think the overhead of memcg is quite insane as well. And no I cannot
> > bear that and have it disabled in all my kernels.
> > 
> > NUMA systems having lots of memory is a false argument, that doesn't
> > mean we can just waste tons of it, people pay good money for that
> > memory, they want to use it.
> > 
> > I fact, I know that HPC people want things like swap-over-nfs so they
> > can push infrequently running system crap out into swap so they can get
> > these few extra megabytes of memory. And you're proposing they give up
> > ~100M just like that?
>
> With your code they will get -ENOMEM from split_vma and a slowdown in
> all regular page faults and vma mangling operations, before they run
> out of memory...
>
> The per-page memory loss is 24bytes, AutoNUMA in page terms costs 0.5%
> of ram (and only if booted on NUMA hardware, unless noautonuma is
> passed as parameter), and I can't imagine that to be a problem on a
> system where hardware vendor took shortcuts to install massive amounts
> of RAM that is fast to access only locally. If you buy that kind of
> hardware losing the cost of 0.5% of RAM of it, is ridiculous compared
> to the programmer cost of patching all apps.

I agree with Peter on this, but perhaps it's because my app will take
all of 15 minutes to patch.  Up front knowledge is better than the
kernel discovering it on its own.

-- 
error compiling committee.c: too many arguments to function

