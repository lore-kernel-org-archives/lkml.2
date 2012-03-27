Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2C0QF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:05:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2C0QF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:05:27 -0400
Date: Tue, 27 Mar 2012 18:04:22 +0200
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
Subject: Re: [PATCH 07/39] autonuma: introduce kthread_bind_node()
Message-ID: <20120327160422.GR5906@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
 <1332783986-24195-8-git-send-email-aarcange@redhat.com>
 <1332786755.16159.174.camel@twins>
 <20120327152209.GL5906@redhat.com>
 <1332863135.16159.239.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332863135.16159.239.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 05:45:35PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-03-27 at 17:22 +0200, Andrea Arcangeli wrote:
> > I don't see what's wrong with more than 1 CPU in the hard bind
> > cpumask.
> 
> Because its currently broken, but we're trying to restore its pure
> semantic so that we can use it in more places again, like
> debug_smp_processor_id(). Testing a single process flag is _much_
> cheaper than testing ->cpus_allowed.
> 
> Adding more broken isn't an option.

I would suggest you to use a new bitflag for that _future_
optimization that you plan to do without altering the way the current
bitflag works.

I doubt knuma_migrated will ever be the only kernel thread that wants
to run with a NUMA NODE-wide CPU binding (instead of single-CPU
binding).

Being able to keep using this bitflag for NUMA-wide bindings too in
the future as well (after you do the optimization you planned), is
going to reduce the chances of the root user shooting himself in the
foot for both the kernel thread node-BIND and the single-cpu-BIND.
