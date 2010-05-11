Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0EKHP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:15:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34782 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab0EKHP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:15:56 -0400
Date: Tue, 11 May 2010 09:15:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [GIT PULL] RCU changes for 2.6.35
Message-ID: <20100511071526.GA10421@elte.hu>
References: <20100510203750.GA12918@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510203750.GA12918@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> Here are the first installment of RCU changes for 2.6.35, this time
> rebased to 2.6.34-rc7.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> 
> As noted earlier, Mathieu's debugobjects changes and Arnd's "sparse"
> checks are also in the works.
> 
> 							Thanx, Paul
> 
> ------------------>
>  Lai Jiangshan (4)
> 	 rcu: optionally leave lockdep enabled after RCU lockdep splat
> 	 rcu: make dead code really dead
> 	 rcu: move some code from macro to function
> 	 rcu: ignore offline CPUs in last non-dyntick-idle CPU check
> 
>  Paul E. McKenney (17)
> 	 rcu: substitute set_need_resched for sending resched IPIs
> 	 rcu: Fix bogus CONFIG_PROVE_LOCKING in comments to reflect reality.
> 	 rcu: fix now-bogus rcu_scheduler_active comments.
> 	 rcu: shrink rcutiny by making synchronize_rcu_bh() be inline
> 	 rcu: rename rcutiny rcu_ctrlblk to rcu_sched_ctrlblk
> 	 rcu: refactor RCU's context-switch handling
> 	 rcu: slim down rcutiny by removing rcu_scheduler_active and friends
> 	 rcu: enable CPU_STALL_VERBOSE by default
> 	 rcu: disable CPU stall warnings upon panic
> 	 rcu: print boot-time console messages if RCU configs out of ordinary
> 	 rcu: improve RCU CPU stall-warning messages
> 	 rcu: permit discontiguous cpu_possible_mask CPU numbering
> 	 rcu: reduce the number of spurious RCU_SOFTIRQ invocations
> 	 rcu: improve the RCU CPU-stall warning documentation
> 	 rcu: make SRCU usable in modules
> 	 rcu: RCU_FAST_NO_HZ must check RCU dyntick state
> 	 rcu: fix build bug in RCU_FAST_NO_HZ builds
> 
>  Documentation/RCU/stallwarn.txt |   94 ++++++++++++++++++++++-------
>  Documentation/RCU/trace.txt     |   35 +++++------
>  include/linux/rcupdate.h        |   42 +++++++------
>  include/linux/rcutiny.h         |   29 ++++++++-
>  include/linux/rcutree.h         |    6 +
>  include/linux/srcu.h            |    6 +
>  kernel/lockdep.c                |    3 
>  kernel/rcupdate.c               |   19 -----
>  kernel/rcutiny.c                |   29 +++++----
>  kernel/rcutiny_plugin.h         |   39 ++++++++++++
>  kernel/rcutree.c                |  127 ++++++++++++++++++++++++++++------------
>  kernel/rcutree.h                |    2 
>  kernel/rcutree_plugin.h         |   67 ++++++++++++++++++---
>  kernel/rcutree_trace.c          |    4 -
>  kernel/sched.c                  |    2 
>  kernel/softirq.c                |    2 
>  lib/Kconfig.debug               |   14 ++++
>  17 files changed, 381 insertions(+), 139 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
