Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab2IYD6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 23:58:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45990 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2IYD6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 23:58:17 -0400
Date: Mon, 24 Sep 2012 20:57:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, josh@joshtriplett.org, sivanich@sgi.com,
        wangyun@linux.vnet.ibm.com, zhong@linux.vnet.ibm.com,
        peterz@infradead.org, sbw@mit.edu, fweisbec@gmail.com
Subject: [RFC GIT PULL rcu/next] RCU commits for 3.7
Message-ID: <20120925035717.GA8273@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092503-2876-0000-0000-00000073E598
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This is an RFC pull for two reasons:

1.	We are currently chasing down some problems with the adaptive-idle
	commits, with Frederic Weisbecker and Sasha Levin doing the heavy
	lifting on this.  We are likely to have fixes in a day or two,
	but in the meantime this RFC pull excludes the adaptive-idle
	commits.  They may be found on branch rcu/idle based on top of
	this pull request, FYI.

2.	Although all of these commits have been exposed to -next testing,
	they have not been exposed to -next testing without the
	adaptive-idle commits.  This will be remedied as soon as the
	next round of -next testing occurs.

My guess is that it would be best to take this pull request now, with
a follow-up (hopefully in a day or two) for the adaptive-idle patches,
but please let me know how you would like to proceed.

That said, the major features of this series are:

0.	A fix for a latent bug that has been in RCU ever since the
	addition of CPU stall warnings.  This bug results in
	false-positive stall warnings, but thus far only on embedded
	systems with severely cut-down userspace configurations.
	This fix is located on an rcu/urgent branch, with the rest
	of the commits based on top of it.  This commit CCs stable.
	Given that the merge window is coming quite soon and given
	the small number of affected users, I do -not- recommend
	pushing it to 3.6, but the separate branch makes it easy to
	find if someone needs it.

1.	Further reductions in latency spikes for huge systems, along
	with additional boot-time adaptation to the actual hardware.
	This is a large change, as it moves RCU grace-period
	initialization and cleanup, along with quiescent-state forcing,
	from softirq to a kthread.  However, it appears to be in
	quite good shape (famous last words).  Posted to LKML at
	https://lkml.org/lkml/2012/9/20/427.

2.	Updates to documentation and rcutorture, the latter category
	including keeping statistics on CPU-hotplug latencies and
	fixing some initialization-time races.  Posted to LKML at
	https://lkml.org/lkml/2012/8/30/193.

3.	Miscellaneous fixes and improvements, posted to LKML at
	https://lkml.org/lkml/2012/8/30/199.

4.	CPU-hotplug fixes and improvements, posted to LKML at
	https://lkml.org/lkml/2012/8/30/292 for first three and at
	https://lkml.org/lkml/2012/8/3/416.

5.	Idle-loop fixes that were omitted on an earlier submission,
	posted to LKML at https://lkml.org/lkml/2012/8/30/251.

As noted earlier, all of these commits have been exposed to -next testing,
albeit in combination with adaptive-idle commits that will hopefully be
following soon.

These changes are available in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

							Thanx, Paul

-------------------->
Dimitri Sivanich (1):
      rcu: Segregate rcu_state fields to improve cache locality

Frederic Weisbecker (11):
      alpha: Fix preemption handling in idle loop
      alpha: Add missing RCU idle APIs on idle loop
      cris: Add missing RCU idle APIs on idle loop
      frv: Add missing RCU idle APIs on idle loop
      h8300: Add missing RCU idle APIs on idle loop
      m32r: Add missing RCU idle APIs on idle loop
      m68k: Add missing RCU idle APIs on idle loop
      mn10300: Add missing RCU idle APIs on idle loop
      parisc: Add missing RCU idle APIs on idle loop
      score: Add missing RCU idle APIs on idle loop
      xtensa: Add missing RCU idle APIs on idle loop

Li Zhong (1):
      rcu: Move TINY_RCU quiescent state out of extended quiescent state

Michael Wang (1):
      kmemleak: Replace list_for_each_continue_rcu with new interface

Paul E. McKenney (46):
      rcu: Move RCU grace-period initialization into a kthread
      rcu: Prevent initialization-time quiescent-state race
      rcu: Allow RCU grace-period initialization to be preempted
      rcu: Move RCU grace-period cleanup into kthread
      rcu: Allow RCU grace-period cleanup to be preempted
      rcu: Break up rcu_gp_kthread() into subfunctions
      rcu: Prevent offline CPUs from executing RCU core code
      rcu: Provide OOM handler to motivate lazy RCU callbacks
      rcu: Move quiescent-state forcing into kthread
      rcu: Allow RCU quiescent-state forcing to be preempted
      rcu: Adjust debugfs tracing for kthread-based quiescent-state forcing
      rcu: Prevent force_quiescent_state() memory contention
      rcu: Control grace-period duration from sysfs
      rcu: Make rcutree module parameters visible in sysfs
      rcu: Fix day-zero grace-period initialization/cleanup race
      rcu: Add random PROVE_RCU_DELAY to grace-period initialization
      rcu: Adjust for unconditional ->completed assignment
      rcu: Eliminate signed overflow in synchronize_rcu_expedited()
      rcu: Reduce synchronize_rcu_expedited() latency
      rcu: Simplify quiescent-state detection
      rcu: Handle unbalanced rcu_node configurations with few CPUs
      rcu: Shrink RCU based on number of CPUs
      rcu: Update rcutorture defaults
      rcu: Track CPU-hotplug duration statistics
      rcu: Document SRCU dead-CPU capabilities, emphasize read-side limits
      rcu: Switch rcutorture to pr_alert() and friends
      rcu: Prevent initialization race in rcutorture kthreads
      rcu: Add PROVE_RCU_DELAY to provoke difficult races
      rcu: Pull TINY_RCU dyntick-idle tracing into non-idle region
      rcu: Properly initialize ->boost_tasks on CPU offline
      rcu: Permit RCU_NONIDLE() to be used from interrupt context
      rcu: Improve boost selection when moving tasks to root rcu_node
      rcu: Make offline-CPU checking allow for indefinite delays
      rcu: Fix obsolete rcu_initiate_boost() header comment
      rcu: Apply for_each_rcu_flavor() to increment_cpu_stall_ticks()
      rcu: Avoid rcu_print_detail_task_stall_rnp() segfault
      rcu: Protect rcu_node accesses during CPU stall warnings
      rcu: Avoid spurious RCU CPU stall warnings
      rcu: Remove redundant memory barrier from __call_rcu()
      rcu: Move TINY_PREEMPT_RCU away from raw_local_irq_save()
      time: RCU permitted to stop idle entry via softirq
      rcu: Fix CONFIG_RCU_FAST_NO_HZ stall warning message
      rcu: Remove _rcu_barrier() dependency on __stop_machine()
      rcu: Disallow callback registry on offline CPUs
      ia64: Add missing RCU idle APIs on idle loop
      Merge branches 'bigrt.2012.09.23a', 'doctorture.2012.09.23a', 'fixes.2012.09.23a', 'hotplug.2012.09.23a' and 'idlechop.2012.09.23a' into HEAD

Peter Zijlstra (1):
      sched: Fix load avg vs cpu-hotplug

Silas Boyd-Wickizer (2):
      Use get_online_cpus to avoid races involving CPU hotplug
      Use get_online_cpus to avoid races involving CPU hotplug

 Documentation/RCU/checklist.txt     |    6 +
 Documentation/RCU/stallwarn.txt     |   16 +-
 Documentation/RCU/trace.txt         |   43 +--
 Documentation/RCU/whatisRCU.txt     |    9 +-
 Documentation/kernel-parameters.txt |   11 +
 arch/alpha/kernel/process.c         |    6 +-
 arch/alpha/kernel/smp.c             |    1 +
 arch/cris/kernel/process.c          |    3 +
 arch/frv/kernel/process.c           |    3 +
 arch/h8300/kernel/process.c         |    3 +
 arch/ia64/kernel/process.c          |    3 +
 arch/m32r/kernel/process.c          |    3 +
 arch/m68k/kernel/process.c          |    3 +
 arch/mn10300/kernel/process.c       |    3 +
 arch/parisc/kernel/process.c        |    3 +
 arch/score/kernel/process.c         |    4 +-
 arch/x86/kernel/cpuid.c             |    5 +
 arch/x86/kernel/msr.c               |    5 +
 arch/xtensa/kernel/process.c        |    3 +
 include/linux/interrupt.h           |    2 +
 include/linux/rcupdate.h            |    6 +-
 kernel/rcupdate.c                   |    4 +
 kernel/rcutiny.c                    |   33 +-
 kernel/rcutiny_plugin.h             |   10 +-
 kernel/rcutorture.c                 |  159 +++++----
 kernel/rcutree.c                    |  690 ++++++++++++++++++-----------------
 kernel/rcutree.h                    |   31 +-
 kernel/rcutree_plugin.h             |  174 +++++++--
 kernel/rcutree_trace.c              |   19 +-
 kernel/sched/core.c                 |   41 +-
 kernel/time/tick-sched.c            |    3 +-
 lib/Kconfig.debug                   |   14 +
 mm/kmemleak.c                       |    6 +-
 33 files changed, 771 insertions(+), 554 deletions(-)

