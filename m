Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab1FNPCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:02:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57110 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab1FNPCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:02:04 -0400
Date: Tue, 14 Jun 2011 08:01:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Alex,Shi" <alex.shi@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, rostedt@goodmis.org
Subject: Re: rcu: performance regression
Message-ID: <20110614150155.GC2288@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1308029185.15392.147.camel@sli10-conroe>
 <1308040388.21027.1847.camel@debian>
 <20110614130203.GF2264@linux.vnet.ibm.com>
 <1308057298.19856.40.camel@twins>
 <1308057522.19856.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308057522.19856.41.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 03:18:42PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-14 at 15:14 +0200, Peter Zijlstra wrote:
> > On Tue, 2011-06-14 at 06:02 -0700, Paul E. McKenney wrote:
> > > > This commit also cause hackbench process mode performance dropping, and
> > > > Shaohua's patch do recovered this. But in hackbench testing, the vmstat
> > > > show context switch have some reduce. And perf tool show
> > > > root_domain->cpupri->prio_to_cpu[]->lock has contention with the commit.
> > > 
> > > Steven, Peter, would any of the recent fixes address this lock contention? 
> > 
> > No. People occasionally run into that thing, but given the constraints
> > on SCHED_FIFO SMP (run the n highest priority tasks on m cpus; n<=m)
> > there isn't really much we can do.
> > 
> > IIRC Chris Mason once proposed a lockless version, but that opened up
> > race windows, Steve might know the details better.
> 
> Note that even a lockless version will die of cacheline contention.

Hmmm...  This is going to be fun for the -rt guys given the mapping of
softirq and irq to kthreads, but then again, perhaps people will
confine use of -rt to smaller systems.

Thankfully, Shaohua's patch is looking good so far, give or take a
couple of future RCU items, but then again, those are in the future
rather than here and now.

							Thanx, Paul
