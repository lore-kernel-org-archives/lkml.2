Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab2H3S5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:57:11 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58321 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab2H3S5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:57:09 -0400
Date: Thu, 30 Aug 2012 11:56:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/15] Miscellaneous fixes
Message-ID: <20120830185607.GA32148@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-1976-0000-0000-000010BE14BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains miscellaneous fixes.  The individual fixes are as
follows:

1.	Add PROVE_RCU_DELAY Kconfig parameter to add delays as needed to
	provoke difficult races.
2.	Pull TINY_RCU dyntick-idle tracing into non-idle region.
3.	Properly initialize ->boost_tasks on CPU offline.
4.	Permit RCU_NONIDLE() to be used from interrupt context.
5.	Improve boost selection when moving tasks to root rcu_node.
6.	Make offline-CPU checking allow for indefinite delays.
7.	Fix obsolete rcu_initiate_boost() header comment.
8.	Apply for_each_rcu_flavor() to increment_cpu_stall_ticks().
9.	Avoid segfault in rcu_print_detail_task_stall_rnp().
10.	Protect rcu_node accesses during CPU stall warnings.
11.	Avoid spurious RCU CPU stall warnings.
12.	Remove redundant memory barrier from __call_rcu().
13.	Move TINY_PREEMPT_RCU away from raw_local_irq_save().
14.	RCU permitted to stop idle entry via softirq.
15.	Replace kmemleak use of list_for_each_continue_rcu() with
	list_for_each_entry_continue_rcu() (courtesy of Michael Wang).

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/interrupt.h |    2 +
 b/include/linux/rcupdate.h  |    6 +---
 b/kernel/rcupdate.c         |    4 ++
 b/kernel/rcutiny.c          |   31 +++++++++++----------
 b/kernel/rcutiny_plugin.h   |   10 +++---
 b/kernel/rcutree.c          |    2 +
 b/kernel/rcutree_plugin.h   |    7 ++--
 b/kernel/time/tick-sched.c  |    3 +-
 b/lib/Kconfig.debug         |   14 +++++++++
 b/mm/kmemleak.c             |    6 +---
 kernel/rcutiny.c            |    2 +
 kernel/rcutree.c            |   64 ++++++++++++++++++--------------------------
 kernel/rcutree_plugin.h     |   24 ++++++++--------
 13 files changed, 95 insertions(+), 80 deletions(-)

