Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab0DARCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:02:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54531 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663Ab0DARCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:02:12 -0400
Date: Thu, 1 Apr 2010 10:02:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
Message-ID: <20100401170202.GG2472@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BB47FC3.1020606@redhat.com>
 <4BB480CC.2060503@redhat.com>
 <1270121264.1653.205.camel@laptop>
 <1270122194.1653.223.camel@laptop>
 <20100401154249.GQ5825@random.random>
 <4BB4C0F5.3070204@redhat.com>
 <1270137406.1598.78.camel@laptop>
 <4BB4C48C.5000005@redhat.com>
 <20100401161551.GE2472@linux.vnet.ibm.com>
 <1270139774.1598.130.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270139774.1598.130.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 06:36:14PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-04-01 at 09:15 -0700, Paul E. McKenney wrote:
> > > I don't understand.  I thought the problem was that the locks were
> > > taken inside an rcu critical section; switching to srcu would fix
> > > that.  But how is call_rcu_preempt() related?  Grepping a bit, what
> > > is call_rcu_preempt()?  my tree doesn't have it.
> > 
> > I believe that Peter is referring to the RCU implementation you get
> > with CONFIG_TREE_PREEMPT_RCU, which currently depends on CONFIG_PREEMPT.
> > The other implementation is CONFIG_TREE_RCU, which is usually called
> > "classic RCU". 
> 
> Right, so I've been nudging Paul a while to make it so that we always
> have preemptible rcu available and that only the default interface
> switches between sched/classic and preempt.
> 
> Currently we already have:
> 
> call_rcu_sched()
> call_rcu_bh()
> call_rcu()	(depends on CONFIG_PREEMPT_RCU)
> 
> I'm saying it would be nice to also have:
> 
> call_rcu_preempt()

And, given the !CONFIG_PREEMPT issue, along with the issue of
sleeping forever in RCU read-side critical sections, my counteroffer
has been to integrate SRCU into the treercu (and of course the
tinyrcu) implementations, thus getting roughly the same performance
as CONFIG_TREE_RCU.

Delivering on this counteroffer has proven to be another kettle of fish,
although I am making some progress.  It will be several months, best case.

							Thanx, Paul
