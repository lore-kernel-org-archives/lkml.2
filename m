Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab0EJUhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:37:55 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52214 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab0EJUhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:37:53 -0400
Date: Mon, 10 May 2010 13:37:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: [GIT PULL] RCU changes for 2.6.35
Message-ID: <20100510203750.GA12918@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Here are the first installment of RCU changes for 2.6.35, this time
rebased to 2.6.34-rc7.

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

As noted earlier, Mathieu's debugobjects changes and Arnd's "sparse"
checks are also in the works.

							Thanx, Paul

------------------>
 Lai Jiangshan (4)
	 rcu: optionally leave lockdep enabled after RCU lockdep splat
	 rcu: make dead code really dead
	 rcu: move some code from macro to function
	 rcu: ignore offline CPUs in last non-dyntick-idle CPU check

 Paul E. McKenney (17)
	 rcu: substitute set_need_resched for sending resched IPIs
	 rcu: Fix bogus CONFIG_PROVE_LOCKING in comments to reflect reality.
	 rcu: fix now-bogus rcu_scheduler_active comments.
	 rcu: shrink rcutiny by making synchronize_rcu_bh() be inline
	 rcu: rename rcutiny rcu_ctrlblk to rcu_sched_ctrlblk
	 rcu: refactor RCU's context-switch handling
	 rcu: slim down rcutiny by removing rcu_scheduler_active and friends
	 rcu: enable CPU_STALL_VERBOSE by default
	 rcu: disable CPU stall warnings upon panic
	 rcu: print boot-time console messages if RCU configs out of ordinary
	 rcu: improve RCU CPU stall-warning messages
	 rcu: permit discontiguous cpu_possible_mask CPU numbering
	 rcu: reduce the number of spurious RCU_SOFTIRQ invocations
	 rcu: improve the RCU CPU-stall warning documentation
	 rcu: make SRCU usable in modules
	 rcu: RCU_FAST_NO_HZ must check RCU dyntick state
	 rcu: fix build bug in RCU_FAST_NO_HZ builds

 Documentation/RCU/stallwarn.txt |   94 ++++++++++++++++++++++-------
 Documentation/RCU/trace.txt     |   35 +++++------
 include/linux/rcupdate.h        |   42 +++++++------
 include/linux/rcutiny.h         |   29 ++++++++-
 include/linux/rcutree.h         |    6 +
 include/linux/srcu.h            |    6 +
 kernel/lockdep.c                |    3 
 kernel/rcupdate.c               |   19 -----
 kernel/rcutiny.c                |   29 +++++----
 kernel/rcutiny_plugin.h         |   39 ++++++++++++
 kernel/rcutree.c                |  127 ++++++++++++++++++++++++++++------------
 kernel/rcutree.h                |    2 
 kernel/rcutree_plugin.h         |   67 ++++++++++++++++++---
 kernel/rcutree_trace.c          |    4 -
 kernel/sched.c                  |    2 
 kernel/softirq.c                |    2 
 lib/Kconfig.debug               |   14 ++++
 17 files changed, 381 insertions(+), 139 deletions(-)
