Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2D1RVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 13:21:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41446 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab2D1RVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 13:21:37 -0400
Date: Sat, 28 Apr 2012 10:21:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 6/6] rcu: Reduce cache-miss
 initialization latencies for large systems
Message-ID: <20120428172127.GE2495@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335501371.10374.30.camel@marge.simpson.net>
 <20120427151518.GA2419@linux.vnet.ibm.com>
 <1335588142.7498.21.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335588142.7498.21.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042817-9360-0000-0000-000005D56B64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 06:42:22AM +0200, Mike Galbraith wrote:
> On Fri, 2012-04-27 at 08:15 -0700, Paul E. McKenney wrote: 
> > On Fri, Apr 27, 2012 at 06:36:11AM +0200, Mike Galbraith wrote:
> > > On Mon, 2012-04-23 at 09:42 -0700, Paul E. McKenney wrote: 
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > Commit #0209f649 (rcu: limit rcu_node leaf-level fanout) set an upper
> > > > limit of 16 on the leaf-level fanout for the rcu_node tree.  This was
> > > > needed to reduce lock contention that was induced by the synchronization
> > > > of scheduling-clock interrupts, which was in turn needed to improve
> > > > energy efficiency for moderate-sized lightly loaded servers.
> > > > 
> > > > However, reducing the leaf-level fanout means that there are more
> > > > leaf-level rcu_node structures in the tree, which in turn means that
> > > > RCU's grace-period initialization incurs more cache misses.  This is
> > > > not a problem on moderate-sized servers with only a few tens of CPUs,
> > > 
> > > With a distro config (4096 CPUs) interrupt latency is bad even on a
> > > quad.  Traversing empty nodes taking locks and cache misses hurts.
> > 
> > Agreed -- and I will be working on an additional patch that makes RCU
> > avoid initializing its data structures for CPUs that don't exist.
> 
> That's still on my todo list too, your initial patch (and my butchery
> thereof to skip taking lock) showed this helps a heap.

Indeed, I am a bit worried about the safety of skipping the lock in
that case.  Either way, if you would rather keep working on this, I
have no problem pushing it further down my todo list.

> > That said, increasing the leaf-level fanout from 16 to 64 should reduce
> > the latency pain by a factor of four.  In addition, I would expect that
> > real-time builds of the kernel would set NR_CPUS to some value much
> > smaller than 4096.  ;-)
> 
> Yup, else you would have heard whimpering months ago ;-)

I am not sure that it would have been exactly whimpering, but yes.  ;-)

							Thanx, Paul

