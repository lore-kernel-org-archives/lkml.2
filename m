Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1EANVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:21:49 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49711 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1EANVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:21:48 -0400
Date: Sun, 1 May 2011 06:21:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@lnaro.org
Subject: [PATCH tip/core/rcu 0/6] Preview of RCU patches for 2.6.40
Message-ID: <20110501132142.GA25494@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset introduces RCU_TREE priority boosting, a new "fire and
forget" kfree_rcu() API, numerous uses of kfree_rcu(), plus a number
of other fixes and improvements.  The patches are as follows:

1.	Remove conditional compilation for RCU CPU stall warnings, which
	are now controlled only by the boot command line and sysfs.

2.	Reworks RCU dyntick-idle interface to better tolerate theoretical
	races introduced by expedited grace periods.

3-9.	Introduce RCU priority boosting for TREE_RCU.

10-19.	Upgrace TREE_RCU tracing to accommodate RCU priority boosting
	and update documentation.

20-23.	Make DEBUG_OBJECTS_RCU_HEAD work from !PREEMPT (thanks to
	Mathieu Desnoyers).

24.	Switch to this_cpu() primitives (thanks to Christoph Lameter).

25-27.	Apply TREE_RCU priority-boosting lessons learned to TINY_RCU.

28.	Avoid spurious diagnostics by moving from rcu_read_unlock() to
	__rcu_read_unlock() in exit() patch (thanks to Lai Jiangshan).

29.	Settle on "preemptible" spelling vs. "preemptable".

30.	Introduce kfree_rcu() (thanks to Lai Jiangshan).

31.	"Nice" down processes in rcu_yield(), which is called by RCU's
	per-CPU kthreads to avoid monopolizing the CPU.

32.	Improve latency by having call_rcu() avoid diving into the
	RCU core code when called with irqs disabled.

33.	Further reduce TINY_RCU's memory footprint (thanks to Eric
	Dumazet).

34-70.	Use kfree_rcu() throughout the kernel.  This set of patches has
	Acked-by's, so will go up -tip.

71-86.	Ditto, but lacking Acked-by's.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

							Thanx, Paul
