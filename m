Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab0EGVWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:22:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50344 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab0EGVWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:22:22 -0400
Date: Fri, 7 May 2010 14:22:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: [GIT RFC PULL] RCU changes for 2.6.35
Message-ID: <20100507212220.GA10465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Here is the first installment of RCU changes for 2.6.35.  These commits
are based on top of the rcu/urgent set sent yesterday.  If you would rather
rcu/urgent be merged into tip/core/rcu and then this set based on top of
that, or some other arrangement, please let me know.

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

There are two more sets of commits queued:

o	Mathieu's debugobjects changes.  These need to be reworked in
	order to coordinate with other maintainer trees, and also to
	get the relevant Acked-by:s.  This will eventually apply in
	three stages: (1) add new RCU APIs, (2) apply these APIs into
	various trees, and (3) remove old RCU APIs.

o	Arnd's "sparse" checks.  These require a quadruple-action approach:
	(1) add a new RCU API member rcu_dereference_index_check(),
	(2) a couple of commits must be accepted into maintainer trees
	(networking, vfs, and mce), (3) a pair of RCU-infrastructure
	patches, and finally (4) a number of patches to apply __rcu
	attributes to various trees.

							Thanx, Paul

------------------>
 Lai Jiangshan (4)
	 rcu: optionally leave lockdep enabled after RCU lockdep splat
	 rcu: make dead code really dead
	 rcu: move some code from macro to function
	 rcu: ignore offline CPUs in last non-dyntick-idle CPU check

 Paul E. McKenney (16)
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
