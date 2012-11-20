Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2KTEq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:46:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43217 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2KTEq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:46:27 -0500
Date: Mon, 19 Nov 2012 20:46:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, dhaval.giani@gmail.com,
        keescook@chromium.org, edumazet@google.com, laijs@cn.fujitsu.com,
        wangyun@linux.vnet.ibm.com, fweisbec@gmail.com, ananaza@iki.fi,
        paul.gortmaker@linaro.org
Subject: [GIT PULL rcu/next] RCU commits for 3.8
Message-ID: <20121120044615.GA11440@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112004-2398-0000-0000-00000DE7B38D
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00192853; UDB=6.00043698; UTC=2012-11-20
 04:46:25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

The major features of this series are:

1.	A first version of no-callbacks CPUs.  This version prohibits
	offlining CPU 0, but only when enabled via CONFIG_RCU_NOCB_CPU=y.
	Relaxing this constraint is in progress, but not yet ready
	for prime time.  These commits were posted to LKML at
	https://lkml.org/lkml/2012/10/30/724, and are at branch rcu/nocb.

2.	Changes to SRCU that allows statically initialized srcu_struct
	structures.  These commits were posted to LKML at
	https://lkml.org/lkml/2012/10/30/296, and are at branch rcu/srcu.

3.	Restructuring of RCU's debugfs output.  These commits were posted
	to LKML at https://lkml.org/lkml/2012/10/30/341, and are at
	branch rcu/tracing.

4.	Additional CPU-hotplug/RCU improvements, posted to LKML at
	https://lkml.org/lkml/2012/10/30/327, and are at branch rcu/hotplug.
	Note that the commit eliminating __stop_machine() was judged to
	be too-high of risk, so is deferred to 3.9.

5.	Changes to RCU's idle interface, most notably a new module
	parameter that redirects normal grace-period operations to
	their expedited equivalents.  These were posted to LKML at
	https://lkml.org/lkml/2012/10/30/739, and are at branch rcu/idle.

6.	Additional diagnostics for RCU's CPU stall warning facility,
	posted to LKML at https://lkml.org/lkml/2012/10/30/315, and
	are at branch rcu/stall.  The most notable change reduces the
	default RCU CPU stall-warning time from 60 seconds to 21 seconds,
	so that it once again happens sooner than the softlockup timeout.

7.	Documentation updates, which were posted to LKML at
	https://lkml.org/lkml/2012/10/30/280, and are at branch rcu/doc.
	A couple of late-breaking changes were posted at
	https://lkml.org/lkml/2012/11/16/634 and
	https://lkml.org/lkml/2012/11/16/547.

8.	Miscellaneous fixes, which were posted to LKML at
	https://lkml.org/lkml/2012/10/30/309, along with a late-breaking
	change posted at Fri, 16 Nov 2012 11:26:25 -0800 with message-ID
	<20121116192625.GA447@linux.vnet.ibm.com>, but which lkml.org
	seems to have missed.  These are at branch rcu/fixes.

9.	Finally, a fix for an lockdep-RCU splat was posted to LKML
	at https://lkml.org/lkml/2012/11/7/486.  This is at rcu/next.

All executable code in these commits have been subject to -next testing.
(Fixes to trailing whitespace problems in one of the Documentation files
has not yet been, but as far as I know -next testing does not do anything
with Documentation files -- and testing will happen as soon as -next testing
restarts.)

These changes are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

							Thanx, Paul

------------------>
Antti P Miettinen (1):
      rcu: Add a module parameter to force use of expedited RCU primitives

Dhaval Giani (1):
      rcu: Correct the name of a reference in list of RCU papers

Eric Dumazet (1):
      rcu: Fix batch-limit size problem

Frederic Weisbecker (2):
      rcu: Remove rcu_switch()
      rcu: Fix unrecovered RCU user mode in syscall_trace_leave()

Kees Cook (1):
      rcu: Update docs to include kfree_rcu()

Lai Jiangshan (4):
      srcu: Credit Lai Jiangshan with SRCU rewrite
      srcu: Export process_srcu()
      srcu: Add DEFINE_SRCU()
      rcutorture: Use DEFINE_STATIC_SRCU()

Michael Wang (12):
      rcu: Create directory for each flavor of rcu
      rcu: Fundamental facility for 'CPU units sequence reading'
      rcu: Optimize the 'rcudata' for RCU trace
      rcu: Optimize the 'rcudata.csv' for RCU trace
      rcu: Optimize the 'rcu_pending' for RCU trace
      rcu: Replace the old interface with the new one
      rcu: Remove the interface "rcudata.csv"
      rcu: split 'rcubarrier' to each flavor
      rcu: split 'rcuboost' to each flavor
      rcu: split 'rcugp' to each flavor
      rcu: split 'rcuhier' to each flavor
      rcu: Remove old debugfs interfaces and also RCU flavor name

Paul E. McKenney (27):
      rcu: Accelerate callbacks for CPU initiating a grace period
      Documentation: Fix memory-barriers.txt example
      rcu: Fix comment about _rcu_barrier()/orphanage exclusion
      rcu: Make rcutorture give diagnostics if CPU offline fails
      rcu: Update RCU_FAST_NO_HZ help text
      rcu: Fix precedence error in cpu_needs_another_gp()
      rcu: Print remote CPU's stacks in stall warnings
      rcu: Add grace-period information to RCU CPU stall warnings
      rcu: Dump number of callbacks in stall warning messages
      rcu: Document alternative RCU/reference-count algorithms
      rcu: Rename ->onofflock to ->orphan_lock
      rcu: Avoid counter wrap in synchronize_sched_expedited()
      rcu: Move synchronize_sched_expedited() state to rcu_state
      rcu: Instrument synchronize_rcu_expedited() for debugfs tracing
      rcu: Fix tracing formatting
      rcu: Add tracing for synchronize_sched_expedited()
      rcu: Remove list_for_each_continue_rcu()
      rcu: Add new rcutorture module parameters to start/end test messages
      rcu: Clarify memory-ordering properties of grace-period primitives
      rcu: Fix TINY_RCU rcu_is_cpu_rrupt_from_idle check
      rcu: Reduce default RCU CPU stall warning timeout
      rcu: Update documentation for TREE_RCU debugfs tracing
      rcu: Add documentation for the new rcuexp debugfs trace file
      Merge branches 'urgent.2012.10.27a', 'doc.2012.11.16a', 'fixes.2012.11.13a', 'srcu.2012.10.27a', 'stall.2012.11.13a', 'tracing.2012.11.08a' and 'idle.2012.10.24a' into HEAD
      rcu: Add callback-free CPUs
      rcu: Separate accounting of callbacks from callback-free CPUs
      sched: Mark RCU reader in sched_show_task()

Paul Gortmaker (1):
      rcu: Wordsmith help text for RCU_USER_QS kernel parameter

 Documentation/RCU/RTFP.txt          |    2 +-
 Documentation/RCU/checklist.txt     |   17 +-
 Documentation/RCU/listRCU.txt       |    2 +-
 Documentation/RCU/rcuref.txt        |   61 +++++-
 Documentation/RCU/trace.txt         |  396 ++++++++++++++++++---------------
 Documentation/RCU/whatisRCU.txt     |   17 +-
 Documentation/kernel-parameters.txt |   21 ++
 Documentation/memory-barriers.txt   |    9 +-
 arch/um/drivers/mconsole_kern.c     |    2 +-
 arch/x86/kernel/ptrace.c            |    7 +
 include/linux/rculist.h             |   17 --
 include/linux/rcupdate.h            |   27 +++
 include/linux/sched.h               |   10 +-
 include/linux/srcu.h                |   34 +++
 include/trace/events/rcu.h          |    1 +
 init/Kconfig                        |   41 +++-
 kernel/ksysfs.c                     |   18 ++
 kernel/rcu.h                        |    2 +
 kernel/rcupdate.c                   |    3 +
 kernel/rcutiny.c                    |    2 +-
 kernel/rcutiny_plugin.h             |    5 +-
 kernel/rcutorture.c                 |   54 ++---
 kernel/rcutree.c                    |  283 ++++++++++++++++++------
 kernel/rcutree.h                    |   67 ++++++-
 kernel/rcutree_plugin.h             |  415 ++++++++++++++++++++++++++++++++++-
 kernel/rcutree_trace.c              |  330 ++++++++++++++--------------
 kernel/sched/core.c                 |   14 +-
 kernel/srcu.c                       |   16 +-
 lib/Kconfig.debug                   |    2 +-
 29 files changed, 1352 insertions(+), 523 deletions(-)

