Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab2EKSnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:43:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46775 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab2EKSnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:43:11 -0400
Date: Fri, 11 May 2012 11:42:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, dipankar@in.ibm.com,
        pascal.chapperon@wanadoo.fr, davej@redhat.com, michel@digirati.com.br,
        joern@purestorage.com, jengelh@medozas.de, efault@gmx.de,
        sivanich@sgi.com, torvalds@linux-foundation.org, peterz@infradead.org,
        laijs@cn.fujitsu.com
Subject: [GIT PULL rcu/next] RCU commits for 3.5
Message-ID: <20120511184236.GA10133@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051118-2398-0000-0000-000006916A29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

The major features of this series are:

1.	A set of improvements and fixes to the RCU_FAST_NO_HZ feature
	(with more on the way for 3.6).  Posted to LKML:
	https://lkml.org/lkml/2012/4/23/324 (commits 1-3 and 5), 
	https://lkml.org/lkml/2012/4/16/611 (commit 4),
	https://lkml.org/lkml/2012/4/30/390 (commit 6), and
	https://lkml.org/lkml/2012/5/4/410 (commit 7, combined with
	the other commits for the convenience of the tester).
2.	Changes to make rcu_barrier() avoid disrupting execution of CPUs
	that have no RCU callbacks.  Posted to LKML:
	https://lkml.org/lkml/2012/4/23/322.
3.	A couple of commits that improve the efficiency of the interaction
	between preemptible RCU and the scheduler, these two being all
	that survived an abortive attempt to allow preemptible RCU's
	__rcu_read_lock() to be inlined.  The full set was posted to
	LKML at https://lkml.org/lkml/2012/4/14/143, and the first and
	third patches of that set remain.
4.	Lai Jiangshan's algorithmic implementation of SRCU, which includes
	call_srcu() and srcu_barrier().  A major feature of this new
	implementation is that synchronize_srcu() no longer disturbs
	the execution of other CPUs.  This work is based on earlier
	implementations by Peter Zijlstra and myself.  Posted to
	LKML: https://lkml.org/lkml/2012/2/22/82.
5.	A number of miscellaneous bug fixes and improvements which were
	posted to LKML at: https://lkml.org/lkml/2012/4/23/353 with
	subsequent updates posted to LKML.

#1 and #2 are combined onto one topic branch due to dependencies among
the commits.

All of these have been exposed to -next testing.

These changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

								Thanx, Paul

-------------------->
Dave Jones (1):
      rcu: List-debug variants of rcu list routines.

Jan Engelhardt (1):
      rcu: Make __kfree_rcu() less dependent on compiler choices

Lai Jiangshan (10):
      rcu: Remove fast check path from __synchronize_srcu()
      rcu: Increment upper bit only for srcu_read_lock()
      rcu: Flip ->completed only once per SRCU grace period
      rcu: Improve SRCU's wait_idx() comments
      rcu: Implement a variant of Peter's SRCU algorithm
      rcu: Remove unused srcu_barrier()
      rcu: Improve srcu_readers_active_idx()'s cache locality
      rcu: Use single value to handle expedited SRCU grace periods
      rcu: Implement per-domain single-threaded call_srcu() state machine
      rcu: Add rcutorture test for call_srcu()

Michel Machado (1):
      rcu: Replace list_first_entry_rcu() with list_first_or_null_rcu()

Paul E. McKenney (20):
      rcu: Clarify help text for RCU_BOOST_PRIO
      rcu: Reduce cache-miss initialization latencies for large systems
      rcu: Document kernel command-line parameters
      rcu: Document why rcu_blocking_is_gp() is safe
      rcu: Add RCU_FAST_NO_HZ tracing for idle exit
      rcu: Make RCU_FAST_NO_HZ use timer rather than hrtimer
      rcu: Make RCU_FAST_NO_HZ account for pauses out of idle
      rcu: Fixes to rcutorture error handling and cleanup
      rcu: Add warning for RCU_FAST_NO_HZ timer firing
      timer: Fix mod_timer_pinned() header comment
      rcu: Introduce rcutorture testing for rcu_barrier()
      rcu: Direct algorithmic SRCU implementation
      rcu: Ensure that RCU_FAST_NO_HZ timers expire on correct CPU
      rcu: Move PREEMPT_RCU preemption to switch_to() invocation
      rcu: Make exit_rcu() more precise and consolidate
      rcu: Update RCU maintainership
      rcu: Make RCU_FAST_NO_HZ handle timer migration
      rcu: Explicitly initialize RCU_FAST_NO_HZ per-CPU variables
      rcu: Make rcu_barrier() less disruptive
      Merge branches 'barrier.2012.05.09a', 'fixes.2012.04.26a', 'inline.2012.05.02b' and 'srcu.2012.05.07b' into HEAD

 Documentation/RCU/torture.txt       |   15 +-
 Documentation/kernel-parameters.txt |   88 ++++++-
 MAINTAINERS                         |   14 +-
 arch/um/drivers/mconsole_kern.c     |    1 +
 include/linux/rculist.h             |   40 +++-
 include/linux/rcupdate.h            |   20 ++
 include/linux/rcutiny.h             |   11 -
 include/linux/rcutree.h             |   19 --
 include/linux/sched.h               |   10 +
 include/linux/srcu.h                |   48 +++-
 include/trace/events/rcu.h          |    2 +
 init/Kconfig                        |   50 +++-
 kernel/rcupdate.c                   |   28 ++
 kernel/rcutiny_plugin.h             |   16 -
 kernel/rcutorture.c                 |  257 +++++++++++++++-
 kernel/rcutree.c                    |  332 ++++++++++++++++------
 kernel/rcutree.h                    |   23 +-
 kernel/rcutree_plugin.h             |  154 +++++++----
 kernel/rcutree_trace.c              |    4 +-
 kernel/sched/core.c                 |    1 +
 kernel/srcu.c                       |  548 +++++++++++++++++++++++++++-------
 kernel/timer.c                      |    8 +-
 lib/list_debug.c                    |   22 ++
 23 files changed, 1358 insertions(+), 353 deletions(-)

