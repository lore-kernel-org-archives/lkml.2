Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2JAMW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:22:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55286 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2JAMWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:22:50 -0400
Date: Mon, 1 Oct 2012 14:22:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.7
Message-ID: <20121001122242.GA21524@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   HEAD: fa34da708cbe1e2d9a2ee7fc68ea8fccbf095d12 Merge branch 'rcu/idle' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

Quite a few of changes:

 0. 'idle RCU':

     Adds RCU APIs that allow non-idle tasks to enter RCU idle 
     mode and provides x86 code to make use of them, allowing
     RCU to treat user-mode execution as an extended quiescent 
     state when the new RCU_USER_QS kernel configuration 
     parameter is specified.  (Work is in progress to port this 
     to a few other architectures, but is not part of this 
     series.)

 1.  A fix for a latent bug that has been in RCU ever since the
     addition of CPU stall warnings.  This bug results in
     false-positive stall warnings, but thus far only on 
     embedded systems with severely cut-down userspace 
     configurations.
    
 2.  Further reductions in latency spikes for huge systems, 
     along with additional boot-time adaptation to the actual 
     hardware.
  
     This is a large change, as it moves RCU grace-period
     initialization and cleanup, along with quiescent-state 
     forcing, from softirq to a kthread.  However, it appears to 
     be in quite good shape (famous last words).

 3.  Updates to documentation and rcutorture, the latter 
     category including keeping statistics on CPU-hotplug 
     latencies and fixing some initialization-time races.  

 4.  CPU-hotplug fixes and improvements.

 5.  Idle-loop fixes that were omitted on an earlier submission.

 6.  Miscellaneous fixes and improvements

In certain RCU configurations new kernel threads will show up 
(rcu_bh, rcu_sched), showing RCU processing overhead.

 Thanks,

	Ingo

------------------>
Dimitri Sivanich (1):
      rcu: Segregate rcu_state fields to improve cache locality

Frederic Weisbecker (25):
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
      rcu: New rcu_user_enter() and rcu_user_exit() APIs
      rcu: New rcu_user_enter_after_irq() and rcu_user_exit_after_irq() APIs
      rcu: Settle config for userspace extended quiescent state
      rcu: Allow rcu_user_enter()/exit() to nest
      rcu: Ignore userspace extended quiescent state by default
      rcu: Switch task's syscall hooks on context switch
      x86: Syscall hooks for userspace RCU extended QS
      x86: Unspaghettize do_general_protection()
      x86: Exception hooks for userspace RCU extended QS
      rcu: Exit RCU extended QS on kernel preemption after irq/exception
      rcu: Exit RCU extended QS on user preemption
      x86: Use the new schedule_user API on userspace preemption
      x86: Exit RCU extended QS on notify resume
      rcu: Userspace RCU extended QS selftest

Josh Triplett (1):
      trace: Don't declare trace_*_rcuidle functions in modules

Li Zhong (1):
      rcu: Move TINY_RCU quiescent state out of extended quiescent state

Michael Wang (1):
      kmemleak: Replace list_for_each_continue_rcu with new interface

Paul E. McKenney (52):
      hotplug: Fix UP bug in smpboot hotplug code
      rcu: Use smp_hotplug_thread facility for RCUs per-CPU kthread
      infiniband: ehca: Fix while->do-while conversion typo
      infiniband: ehca: Fix compiler warnings
      rcu: Fix day-one dyntick-idle stall-warning bug
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
      rcu: Make RCU_FAST_NO_HZ handle adaptive ticks
      rcu: Apply micro-optimization and int/bool fixes to RCU's idle handling

Peter Zijlstra (1):
      sched: Fix load avg vs cpu-hotplug

Silas Boyd-Wickizer (2):
      Use get_online_cpus to avoid races involving CPU hotplug
      Use get_online_cpus to avoid races involving CPU hotplug

Thomas Gleixner (6):
      rcu: Yield simpler
      kthread: Implement park/unpark facility
      smpboot: Provide infrastructure for percpu hotplug threads
      softirq: Use hotplug thread infrastructure
      watchdog: Use hotplug thread infrastructure
      infiniband: Ehca: Use hotplug thread infrastructure


 Documentation/RCU/checklist.txt       |   6 +
 Documentation/RCU/stallwarn.txt       |  16 +-
 Documentation/RCU/trace.txt           |  43 +-
 Documentation/RCU/whatisRCU.txt       |   9 +-
 Documentation/kernel-parameters.txt   |  11 +
 arch/Kconfig                          |  10 +
 arch/alpha/kernel/process.c           |   6 +-
 arch/alpha/kernel/smp.c               |   1 +
 arch/cris/kernel/process.c            |   3 +
 arch/frv/kernel/process.c             |   3 +
 arch/h8300/kernel/process.c           |   3 +
 arch/ia64/kernel/process.c            |   3 +
 arch/m32r/kernel/process.c            |   3 +
 arch/m68k/kernel/process.c            |   3 +
 arch/mn10300/kernel/process.c         |   3 +
 arch/parisc/kernel/process.c          |   3 +
 arch/score/kernel/process.c           |   4 +-
 arch/um/drivers/mconsole_kern.c       |   1 +
 arch/x86/Kconfig                      |   1 +
 arch/x86/include/asm/rcu.h            |  32 ++
 arch/x86/include/asm/thread_info.h    |  10 +-
 arch/x86/kernel/cpuid.c               |   5 +
 arch/x86/kernel/entry_64.S            |   9 +-
 arch/x86/kernel/msr.c                 |   5 +
 arch/x86/kernel/ptrace.c              |   5 +
 arch/x86/kernel/signal.c              |   4 +
 arch/x86/kernel/traps.c               | 109 ++--
 arch/x86/mm/fault.c                   |  13 +-
 arch/xtensa/kernel/process.c          |   3 +
 drivers/infiniband/hw/ehca/ehca_irq.c | 250 ++++------
 drivers/infiniband/hw/ehca/ehca_irq.h |   6 +-
 include/linux/interrupt.h             |   2 +
 include/linux/kthread.h               |  11 +-
 include/linux/rcupdate.h              |  21 +-
 include/linux/sched.h                 |   8 +
 include/linux/smpboot.h               |  43 ++
 include/linux/tracepoint.h            |  28 +-
 init/Kconfig                          |  18 +
 kernel/Makefile                       |   3 +-
 kernel/cpu.c                          |  10 +-
 kernel/kthread.c                      | 185 ++++++-
 kernel/rcupdate.c                     |   4 +
 kernel/rcutiny.c                      |  33 +-
 kernel/rcutiny_plugin.h               |  10 +-
 kernel/rcutorture.c                   | 159 +++---
 kernel/rcutree.c                      | 916 ++++++++++++++++++++--------------
 kernel/rcutree.h                      |  50 +-
 kernel/rcutree_plugin.h               | 597 +++++++++-------------
 kernel/rcutree_trace.c                |  22 +-
 kernel/sched/core.c                   |  19 +
 kernel/smpboot.c                      | 233 +++++++++
 kernel/smpboot.h                      |   4 +
 kernel/softirq.c                      | 111 +---
 kernel/time/tick-sched.c              |   3 +-
 kernel/watchdog.c                     | 263 ++++------
 lib/Kconfig.debug                     |  14 +
 mm/kmemleak.c                         |   6 +-
 57 files changed, 1932 insertions(+), 1424 deletions(-)
 create mode 100644 arch/x86/include/asm/rcu.h
 create mode 100644 include/linux/smpboot.h

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index fc103d7..cdb20d4 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -310,6 +310,12 @@ over a rather long period of time, but improvements are always welcome!
 	code under the influence of preempt_disable(), you instead
 	need to use synchronize_irq() or synchronize_sched().
 
+	This same limitation also applies to synchronize_rcu_bh()
+	and synchronize_srcu(), as well as to the asynchronous and
+	expedited forms of the three primitives, namely call_rcu(),
+	call_rcu_bh(), call_srcu(), synchronize_rcu_expedited(),
+	synchronize_rcu_bh_expedited(), and synchronize_srcu_expedited().
+
 12.	Any lock acquired by an RCU callback must be acquired elsewhere
 	with softirq disabled, e.g., via spin_lock_irqsave(),
 	spin_lock_bh(), etc.  Failing to disable irq on a given
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 523364e..1927151 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -99,7 +99,7 @@ In kernels with CONFIG_RCU_FAST_NO_HZ, even more information is
 printed:
 
 	INFO: rcu_preempt detected stall on CPU
-	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer=-1
+	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer not pending
 	   (t=65000 jiffies)
 
 The "(64628 ticks this GP)" indicates that this CPU has taken more
@@ -116,13 +116,13 @@ number between the two "/"s is the value of the nesting, which will
 be a small positive number if in the idle loop and a very large positive
 number (as shown above) otherwise.
 
-For CONFIG_RCU_FAST_NO_HZ kernels, the "drain=0" indicates that the
-CPU is not in the process of trying to force itself into dyntick-idle
-state, the "." indicates that the CPU has not given up forcing RCU
-into dyntick-idle mode (it would be "H" otherwise), and the "timer=-1"
-indicates that the CPU has not recented forced RCU into dyntick-idle
-mode (it would otherwise indicate the number of microseconds remaining
-in this forced state).
+For CONFIG_RCU_FAST_NO_HZ kernels, the "drain=0" indicates that the CPU is
+not in the process of trying to force itself into dyntick-idle state, the
+"." indicates that the CPU has not given up forcing RCU into dyntick-idle
+mode (it would be "H" otherwise), and the "timer not pending" indicates
+that the CPU has not recently forced RCU into dyntick-idle mode (it
+would otherwise indicate the number of microseconds remaining in this
+forced state).
 
 
 Multiple Warnings From One Stall
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index f6f15ce..672d190 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -333,23 +333,23 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 The output of "cat rcu/rcu_pending" looks as follows:
 
 rcu_sched:
-  0 np=255892 qsp=53936 rpq=85 cbr=0 cng=14417 gpc=10033 gps=24320 nf=6445 nn=146741
-  1 np=261224 qsp=54638 rpq=33 cbr=0 cng=25723 gpc=16310 gps=2849 nf=5912 nn=155792
-  2 np=237496 qsp=49664 rpq=23 cbr=0 cng=2762 gpc=45478 gps=1762 nf=1201 nn=136629
-  3 np=236249 qsp=48766 rpq=98 cbr=0 cng=286 gpc=48049 gps=1218 nf=207 nn=137723
-  4 np=221310 qsp=46850 rpq=7 cbr=0 cng=26 gpc=43161 gps=4634 nf=3529 nn=123110
-  5 np=237332 qsp=48449 rpq=9 cbr=0 cng=54 gpc=47920 gps=3252 nf=201 nn=137456
-  6 np=219995 qsp=46718 rpq=12 cbr=0 cng=50 gpc=42098 gps=6093 nf=4202 nn=120834
-  7 np=249893 qsp=49390 rpq=42 cbr=0 cng=72 gpc=38400 gps=17102 nf=41 nn=144888
+  0 np=255892 qsp=53936 rpq=85 cbr=0 cng=14417 gpc=10033 gps=24320 nn=146741
+  1 np=261224 qsp=54638 rpq=33 cbr=0 cng=25723 gpc=16310 gps=2849 nn=155792
+  2 np=237496 qsp=49664 rpq=23 cbr=0 cng=2762 gpc=45478 gps=1762 nn=136629
+  3 np=236249 qsp=48766 rpq=98 cbr=0 cng=286 gpc=48049 gps=1218 nn=137723
+  4 np=221310 qsp=46850 rpq=7 cbr=0 cng=26 gpc=43161 gps=4634 nn=123110
+  5 np=237332 qsp=48449 rpq=9 cbr=0 cng=54 gpc=47920 gps=3252 nn=137456
+  6 np=219995 qsp=46718 rpq=12 cbr=0 cng=50 gpc=42098 gps=6093 nn=120834
+  7 np=249893 qsp=49390 rpq=42 cbr=0 cng=72 gpc=38400 gps=17102 nn=144888
 rcu_bh:
-  0 np=146741 qsp=1419 rpq=6 cbr=0 cng=6 gpc=0 gps=0 nf=2 nn=145314
-  1 np=155792 qsp=12597 rpq=3 cbr=0 cng=0 gpc=4 gps=8 nf=3 nn=143180
-  2 np=136629 qsp=18680 rpq=1 cbr=0 cng=0 gpc=7 gps=6 nf=0 nn=117936
-  3 np=137723 qsp=2843 rpq=0 cbr=0 cng=0 gpc=10 gps=7 nf=0 nn=134863
-  4 np=123110 qsp=12433 rpq=0 cbr=0 cng=0 gpc=4 gps=2 nf=0 nn=110671
-  5 np=137456 qsp=4210 rpq=1 cbr=0 cng=0 gpc=6 gps=5 nf=0 nn=133235
-  6 np=120834 qsp=9902 rpq=2 cbr=0 cng=0 gpc=6 gps=3 nf=2 nn=110921
-  7 np=144888 qsp=26336 rpq=0 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
+  0 np=146741 qsp=1419 rpq=6 cbr=0 cng=6 gpc=0 gps=0 nn=145314
+  1 np=155792 qsp=12597 rpq=3 cbr=0 cng=0 gpc=4 gps=8 nn=143180
+  2 np=136629 qsp=18680 rpq=1 cbr=0 cng=0 gpc=7 gps=6 nn=117936
+  3 np=137723 qsp=2843 rpq=0 cbr=0 cng=0 gpc=10 gps=7 nn=134863
+  4 np=123110 qsp=12433 rpq=0 cbr=0 cng=0 gpc=4 gps=2 nn=110671
+  5 np=137456 qsp=4210 rpq=1 cbr=0 cng=0 gpc=6 gps=5 nn=133235
+  6 np=120834 qsp=9902 rpq=2 cbr=0 cng=0 gpc=6 gps=3 nn=110921
+  7 np=144888 qsp=26336 rpq=0 cbr=0 cng=0 gpc=8 gps=2 nn=118542
 
 As always, this is once again split into "rcu_sched" and "rcu_bh"
 portions, with CONFIG_TREE_PREEMPT_RCU kernels having an additional
@@ -377,17 +377,6 @@ o	"gpc" is the number of times that an old grace period had
 o	"gps" is the number of times that a new grace period had started,
 	but this CPU was not yet aware of it.
 
-o	"nf" is the number of times that this CPU suspected that the
-	current grace period had run for too long, and thus needed to
-	be forced.
-
-	Please note that "forcing" consists of sending resched IPIs
-	to holdout CPUs.  If that CPU really still is in an old RCU
-	read-side critical section, then we really do have to wait for it.
-	The assumption behing "forcing" is that the CPU is not still in
-	an old RCU read-side critical section, but has not yet responded
-	for some other reason.
-
 o	"nn" is the number of times that this CPU needed nothing.  Alert
 	readers will note that the rcu "nn" number for a given CPU very
 	closely matches the rcu_bh "np" number for that same CPU.  This
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 69ee188..bf0f6de 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -873,7 +873,7 @@ d.	Do you need to treat NMI handlers, hardirq handlers,
 	and code segments with preemption disabled (whether
 	via preempt_disable(), local_irq_save(), local_bh_disable(),
 	or some other mechanism) as if they were explicit RCU readers?
-	If so, you need RCU-sched.
+	If so, RCU-sched is the only choice that will work for you.
 
 e.	Do you need RCU grace periods to complete even in the face
 	of softirq monopolization of one or more of the CPUs?  For
@@ -884,7 +884,12 @@ f.	Is your workload too update-intensive for normal use of
 	RCU, but inappropriate for other synchronization mechanisms?
 	If so, consider SLAB_DESTROY_BY_RCU.  But please be careful!
 
-g.	Otherwise, use RCU.
+g.	Do you need read-side critical sections that are respected
+	even though they are in the middle of the idle loop, during
+	user-mode execution, or on an offlined CPU?  If so, SRCU is the
+	only choice that will work for you.
+
+h.	Otherwise, use RCU.
 
 Of course, this all assumes that you have determined that RCU is in fact
 the right tool for your job.
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ad7e2e5..55ada04 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2385,6 +2385,17 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	rcutree.rcu_cpu_stall_timeout= [KNL,BOOT]
 			Set timeout for RCU CPU stall warning messages.
 
+	rcutree.jiffies_till_first_fqs= [KNL,BOOT]
+			Set delay from grace-period initialization to
+			first attempt to force quiescent states.
+			Units are jiffies, minimum value is zero,
+			and maximum value is HZ.
+
+	rcutree.jiffies_till_next_fqs= [KNL,BOOT]
+			Set delay between subsequent attempts to force
+			quiescent states.  Units are jiffies, minimum
+			value is one, and maximum value is HZ.
+
 	rcutorture.fqs_duration= [KNL,BOOT]
 			Set duration of force_quiescent_state bursts.
 
diff --git a/arch/Kconfig b/arch/Kconfig
index 72f2fa1..1401a75 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -281,4 +281,14 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_RCU_USER_QS
+	bool
+	help
+	  Provide kernel entry/exit hooks necessary for userspace
+	  RCU extended quiescent state. Syscalls need to be wrapped inside
+	  rcu_user_exit()-rcu_user_enter() through the slow path using
+	  TIF_NOHZ flag. Exceptions handlers must be wrapped as well. Irqs
+	  are already protected inside rcu_irq_enter/rcu_irq_exit() but
+	  preemption or signal handling on irq exit still need to be protected.
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index d6fde98..83638aa 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -28,6 +28,7 @@
 #include <linux/tty.h>
 #include <linux/console.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 
 #include <asm/reg.h>
 #include <asm/uaccess.h>
@@ -54,9 +55,12 @@ cpu_idle(void)
 		/* FIXME -- EV6 and LCA45 know how to power down
 		   the CPU.  */
 
+		rcu_idle_enter();
 		while (!need_resched())
 			cpu_relax();
-		schedule();
+
+		rcu_idle_exit();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 35ddc02..a41ad90 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -166,6 +166,7 @@ smp_callin(void)
 	DBGS(("smp_callin: commencing CPU %d current %p active_mm %p\n",
 	      cpuid, current, current->active_mm));
 
+	preempt_disable();
 	/* Do nothing.  */
 	cpu_idle();
 }
diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index 66fd017..7f65be6 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -25,6 +25,7 @@
 #include <linux/elfcore.h>
 #include <linux/mqueue.h>
 #include <linux/reboot.h>
+#include <linux/rcupdate.h>
 
 //#define DEBUG
 
@@ -74,6 +75,7 @@ void cpu_idle (void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched()) {
 			void (*idle)(void);
 			/*
@@ -86,6 +88,7 @@ void cpu_idle (void)
 				idle = default_idle;
 			idle();
 		}
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index ff95f50..2eb7fa5 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -25,6 +25,7 @@
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
+#include <linux/rcupdate.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/uaccess.h>
@@ -69,12 +70,14 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched()) {
 			check_pgt_cache();
 
 			if (!frv_dma_inprogress && idle)
 				idle();
 		}
+		rcu_idle_exit();
 
 		schedule_preempt_disabled();
 	}
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 0e9c315..f153ed1 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -36,6 +36,7 @@
 #include <linux/reboot.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 
 #include <asm/uaccess.h>
 #include <asm/traps.h>
@@ -78,8 +79,10 @@ void (*idle)(void) = default_idle;
 void cpu_idle(void)
 {
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			idle();
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index dd6fc14..3e316ec 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -29,6 +29,7 @@
 #include <linux/kdebug.h>
 #include <linux/utsname.h>
 #include <linux/tracehook.h>
+#include <linux/rcupdate.h>
 
 #include <asm/cpu.h>
 #include <asm/delay.h>
@@ -279,6 +280,7 @@ cpu_idle (void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		if (can_do_pal_halt) {
 			current_thread_info()->status &= ~TS_POLLING;
 			/*
@@ -309,6 +311,7 @@ cpu_idle (void)
 			normal_xtp();
 #endif
 		}
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 		check_pgt_cache();
 		if (cpu_is_offline(cpu))
diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index 3a4a32b..384e63f 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/hardirq.h>
+#include <linux/rcupdate.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -82,6 +83,7 @@ void cpu_idle (void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched()) {
 			void (*idle)(void) = pm_idle;
 
@@ -90,6 +92,7 @@ void cpu_idle (void)
 
 			idle();
 		}
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index c488e3c..ac2892e 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -25,6 +25,7 @@
 #include <linux/reboot.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
+#include <linux/rcupdate.h>
 
 #include <asm/uaccess.h>
 #include <asm/traps.h>
@@ -75,8 +76,10 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			idle();
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 7dab0cd..e9cceba 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -107,6 +108,7 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	for (;;) {
+		rcu_idle_enter();
 		while (!need_resched()) {
 			void (*idle)(void);
 
@@ -121,6 +123,7 @@ void cpu_idle(void)
 			}
 			idle();
 		}
+		rcu_idle_exit();
 
 		schedule_preempt_disabled();
 	}
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index 2c05a92..8c6b6b6 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -48,6 +48,7 @@
 #include <linux/unistd.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
+#include <linux/rcupdate.h>
 
 #include <asm/io.h>
 #include <asm/asm-offsets.h>
@@ -69,8 +70,10 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			barrier();
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 		check_pgt_cache();
 	}
diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
index 2707023..637970c 100644
--- a/arch/score/kernel/process.c
+++ b/arch/score/kernel/process.c
@@ -27,6 +27,7 @@
 #include <linux/reboot.h>
 #include <linux/elfcore.h>
 #include <linux/pm.h>
+#include <linux/rcupdate.h>
 
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
@@ -50,9 +51,10 @@ void __noreturn cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			barrier();
-
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 664a60e..c17de0d 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -705,6 +705,7 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
+	rcu_switch(from, to);
 	switch_to(from, to, from);
 }
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 50a1d1f..20c49b8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -97,6 +97,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HAVE_RCU_USER_QS if X86_64
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
diff --git a/arch/x86/include/asm/rcu.h b/arch/x86/include/asm/rcu.h
new file mode 100644
index 0000000..d1ac07a
--- /dev/null
+++ b/arch/x86/include/asm/rcu.h
@@ -0,0 +1,32 @@
+#ifndef _ASM_X86_RCU_H
+#define _ASM_X86_RCU_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/rcupdate.h>
+#include <asm/ptrace.h>
+
+static inline void exception_enter(struct pt_regs *regs)
+{
+	rcu_user_exit();
+}
+
+static inline void exception_exit(struct pt_regs *regs)
+{
+#ifdef CONFIG_RCU_USER_QS
+	if (user_mode(regs))
+		rcu_user_enter();
+#endif
+}
+
+#else /* __ASSEMBLY__ */
+
+#ifdef CONFIG_RCU_USER_QS
+# define SCHEDULE_USER call schedule_user
+#else
+# define SCHEDULE_USER call schedule
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#endif
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 89f794f..c535d84 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -89,6 +89,7 @@ struct thread_info {
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_FORK		18	/* ret_from_fork */
+#define TIF_NOHZ		19	/* in adaptive nohz mode */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
@@ -114,6 +115,7 @@ struct thread_info {
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
+#define _TIF_NOHZ		(1 << TIF_NOHZ)
 #define _TIF_DEBUG		(1 << TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
@@ -126,12 +128,13 @@ struct thread_info {
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
-	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT)
+	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT |	\
+	 _TIF_NOHZ)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP |	\
-	 _TIF_SYSCALL_TRACEPOINT)
+	 _TIF_SYSCALL_TRACEPOINT | _TIF_NOHZ)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -141,7 +144,8 @@ struct thread_info {
 
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK						\
-	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT)
+	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT |	\
+	_TIF_NOHZ)
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 39472dd..60c7891 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -199,12 +199,14 @@ static int __init cpuid_init(void)
 		goto out_chrdev;
 	}
 	cpuid_class->devnode = cpuid_devnode;
+	get_online_cpus();
 	for_each_online_cpu(i) {
 		err = cpuid_device_create(i);
 		if (err != 0)
 			goto out_class;
 	}
 	register_hotcpu_notifier(&cpuid_class_cpu_notifier);
+	put_online_cpus();
 
 	err = 0;
 	goto out;
@@ -214,6 +216,7 @@ out_class:
 	for_each_online_cpu(i) {
 		cpuid_device_destroy(i);
 	}
+	put_online_cpus();
 	class_destroy(cpuid_class);
 out_chrdev:
 	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
@@ -225,11 +228,13 @@ static void __exit cpuid_exit(void)
 {
 	int cpu = 0;
 
+	get_online_cpus();
 	for_each_online_cpu(cpu)
 		cpuid_device_destroy(cpu);
 	class_destroy(cpuid_class);
 	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
 	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
+	put_online_cpus();
 }
 
 module_init(cpuid_init);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 69babd8..1a8f3cb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -56,6 +56,7 @@
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
 #include <asm/asm.h>
+#include <asm/rcu.h>
 #include <linux/err.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
@@ -565,7 +566,7 @@ sysret_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call schedule
+	SCHEDULE_USER
 	popq_cfi %rdi
 	jmp sysret_check
 
@@ -678,7 +679,7 @@ int_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call schedule
+	SCHEDULE_USER
 	popq_cfi %rdi
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
@@ -974,7 +975,7 @@ retint_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call  schedule
+	SCHEDULE_USER
 	popq_cfi %rdi
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -1449,7 +1450,7 @@ paranoid_userspace:
 paranoid_schedule:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_ANY)
-	call schedule
+	SCHEDULE_USER
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	jmp paranoid_userspace
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index eb11369..a7c5661 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -257,12 +257,14 @@ static int __init msr_init(void)
 		goto out_chrdev;
 	}
 	msr_class->devnode = msr_devnode;
+	get_online_cpus();
 	for_each_online_cpu(i) {
 		err = msr_device_create(i);
 		if (err != 0)
 			goto out_class;
 	}
 	register_hotcpu_notifier(&msr_class_cpu_notifier);
+	put_online_cpus();
 
 	err = 0;
 	goto out;
@@ -271,6 +273,7 @@ out_class:
 	i = 0;
 	for_each_online_cpu(i)
 		msr_device_destroy(i);
+	put_online_cpus();
 	class_destroy(msr_class);
 out_chrdev:
 	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
@@ -281,11 +284,13 @@ out:
 static void __exit msr_exit(void)
 {
 	int cpu = 0;
+	get_online_cpus();
 	for_each_online_cpu(cpu)
 		msr_device_destroy(cpu);
 	class_destroy(msr_class);
 	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
 	unregister_hotcpu_notifier(&msr_class_cpu_notifier);
+	put_online_cpus();
 }
 
 module_init(msr_init);
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index c4c6a5c..9f94f8e 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/rcupdate.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -1463,6 +1464,8 @@ long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
+	rcu_user_exit();
+
 	/*
 	 * If we stepped into a sysenter/syscall insn, it trapped in
 	 * kernel mode; do_debug() cleared TF and set TIF_SINGLESTEP.
@@ -1526,4 +1529,6 @@ void syscall_trace_leave(struct pt_regs *regs)
 			!test_thread_flag(TIF_SYSCALL_EMU);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
+
+	rcu_user_enter();
 }
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b280908..bca0ab9 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -779,6 +779,8 @@ static void do_signal(struct pt_regs *regs)
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
+	rcu_user_exit();
+
 #ifdef CONFIG_X86_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
@@ -804,6 +806,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 #ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
 #endif /* CONFIG_X86_32 */
+
+	rcu_user_enter();
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b481341..3789675 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -55,6 +55,7 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/mce.h>
+#include <asm/rcu.h>
 
 #include <asm/mach_traps.h>
 
@@ -180,11 +181,15 @@ vm86_trap:
 #define DO_ERROR(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
+	exception_enter(regs);						\
+	if (notify_die(DIE_TRAP, str, regs, error_code,			\
+			trapnr, signr) == NOTIFY_STOP) {		\
+		exception_exit(regs);					\
 		return;							\
+	}								\
 	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
+	exception_exit(regs);						\
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
@@ -195,11 +200,15 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 	info.si_errno = 0;						\
 	info.si_code = sicode;						\
 	info.si_addr = (void __user *)siaddr;				\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
+	exception_enter(regs);						\
+	if (notify_die(DIE_TRAP, str, regs, error_code,			\
+			trapnr, signr) == NOTIFY_STOP) {		\
+		exception_exit(regs);					\
 		return;							\
+	}								\
 	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, regs, error_code, &info);		\
+	exception_exit(regs);						\
 }
 
 DO_ERROR_INFO(X86_TRAP_DE, SIGFPE, "divide error", divide_error, FPE_INTDIV,
@@ -222,12 +231,14 @@ DO_ERROR_INFO(X86_TRAP_AC, SIGBUS, "alignment check", alignment_check,
 /* Runs on IST stack */
 dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
+	exception_enter(regs);
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
-			X86_TRAP_SS, SIGBUS) == NOTIFY_STOP)
-		return;
-	preempt_conditional_sti(regs);
-	do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
+		       X86_TRAP_SS, SIGBUS) != NOTIFY_STOP) {
+		preempt_conditional_sti(regs);
+		do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
+		preempt_conditional_cli(regs);
+	}
+	exception_exit(regs);
 }
 
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
@@ -235,6 +246,7 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	static const char str[] = "double fault";
 	struct task_struct *tsk = current;
 
+	exception_enter(regs);
 	/* Return not checked because double check cannot be ignored */
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
 
@@ -255,16 +267,29 @@ do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
 
+	exception_enter(regs);
 	conditional_sti(regs);
 
 #ifdef CONFIG_X86_32
-	if (regs->flags & X86_VM_MASK)
-		goto gp_in_vm86;
+	if (regs->flags & X86_VM_MASK) {
+		local_irq_enable();
+		handle_vm86_fault((struct kernel_vm86_regs *) regs, error_code);
+		goto exit;
+	}
 #endif
 
 	tsk = current;
-	if (!user_mode(regs))
-		goto gp_in_kernel;
+	if (!user_mode(regs)) {
+		if (fixup_exception(regs))
+			goto exit;
+
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_nr = X86_TRAP_GP;
+		if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
+			       X86_TRAP_GP, SIGSEGV) != NOTIFY_STOP)
+			die("general protection fault", regs, error_code);
+		goto exit;
+	}
 
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_nr = X86_TRAP_GP;
@@ -279,25 +304,8 @@ do_general_protection(struct pt_regs *regs, long error_code)
 	}
 
 	force_sig(SIGSEGV, tsk);
-	return;
-
-#ifdef CONFIG_X86_32
-gp_in_vm86:
-	local_irq_enable();
-	handle_vm86_fault((struct kernel_vm86_regs *) regs, error_code);
-	return;
-#endif
-
-gp_in_kernel:
-	if (fixup_exception(regs))
-		return;
-
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_nr = X86_TRAP_GP;
-	if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
-			X86_TRAP_GP, SIGSEGV) == NOTIFY_STOP)
-		return;
-	die("general protection fault", regs, error_code);
+exit:
+	exception_exit(regs);
 }
 
 /* May run on IST stack. */
@@ -312,15 +320,16 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	    ftrace_int3_handler(regs))
 		return;
 #endif
+	exception_enter(regs);
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto exit;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 
 	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 			SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto exit;
 
 	/*
 	 * Let others (NMI) know that the debug stack is in use
@@ -331,6 +340,8 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	do_trap(X86_TRAP_BP, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
+exit:
+	exception_exit(regs);
 }
 
 #ifdef CONFIG_X86_64
@@ -391,6 +402,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
+	exception_enter(regs);
+
 	get_debugreg(dr6, 6);
 
 	/* Filter out all the reserved bits which are preset to 1 */
@@ -406,7 +419,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	/* Catch kmemcheck conditions first of all! */
 	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
-		return;
+		goto exit;
 
 	/* DR6 may or may not be cleared by the CPU */
 	set_debugreg(0, 6);
@@ -421,7 +434,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
 							SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto exit;
 
 	/*
 	 * Let others (NMI) know that the debug stack is in use
@@ -437,7 +450,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 					X86_TRAP_DB);
 		preempt_conditional_cli(regs);
 		debug_stack_usage_dec();
-		return;
+		goto exit;
 	}
 
 	/*
@@ -458,7 +471,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
 
-	return;
+exit:
+	exception_exit(regs);
 }
 
 /*
@@ -555,14 +569,17 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 #ifdef CONFIG_X86_32
 	ignore_fpu_irq = 1;
 #endif
-
+	exception_enter(regs);
 	math_error(regs, error_code, X86_TRAP_MF);
+	exception_exit(regs);
 }
 
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
+	exception_enter(regs);
 	math_error(regs, error_code, X86_TRAP_XF);
+	exception_exit(regs);
 }
 
 dotraplinkage void
@@ -629,6 +646,7 @@ EXPORT_SYMBOL_GPL(math_state_restore);
 dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
+	exception_enter(regs);
 #ifdef CONFIG_MATH_EMULATION
 	if (read_cr0() & X86_CR0_EM) {
 		struct math_emu_info info = { };
@@ -637,6 +655,7 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 
 		info.regs = regs;
 		math_emulate(&info);
+		exception_exit(regs);
 		return;
 	}
 #endif
@@ -644,12 +663,15 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 #ifdef CONFIG_X86_32
 	conditional_sti(regs);
 #endif
+	exception_exit(regs);
 }
 
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 {
 	siginfo_t info;
+
+	exception_enter(regs);
 	local_irq_enable();
 
 	info.si_signo = SIGILL;
@@ -657,10 +679,11 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 	info.si_code = ILL_BADSTK;
 	info.si_addr = NULL;
 	if (notify_die(DIE_TRAP, "iret exception", regs, error_code,
-			X86_TRAP_IRET, SIGILL) == NOTIFY_STOP)
-		return;
-	do_trap(X86_TRAP_IRET, SIGILL, "iret exception", regs, error_code,
-		&info);
+			X86_TRAP_IRET, SIGILL) != NOTIFY_STOP) {
+		do_trap(X86_TRAP_IRET, SIGILL, "iret exception", regs, error_code,
+			&info);
+	}
+	exception_exit(regs);
 }
 #endif
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 76dcd9d..7dde46d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -18,6 +18,7 @@
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
 #include <asm/fixmap.h>			/* VSYSCALL_START		*/
+#include <asm/rcu.h>			/* exception_enter(), ...	*/
 
 /*
  * Page fault error code bits:
@@ -1000,8 +1001,8 @@ static int fault_in_kernel_space(unsigned long address)
  * and the problem, and then passes it off to one of the appropriate
  * routines.
  */
-dotraplinkage void __kprobes
-do_page_fault(struct pt_regs *regs, unsigned long error_code)
+static void __kprobes
+__do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
@@ -1209,3 +1210,11 @@ good_area:
 
 	up_read(&mm->mmap_sem);
 }
+
+dotraplinkage void __kprobes
+do_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	exception_enter(regs);
+	__do_page_fault(regs, error_code);
+	exception_exit(regs);
+}
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 2c8d6a3..bc44311 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -31,6 +31,7 @@
 #include <linux/mqueue.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
@@ -110,8 +111,10 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			platform_idle();
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 5358900..8615d7c 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -42,6 +42,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/smpboot.h>
 
 #include "ehca_classes.h"
 #include "ehca_irq.h"
@@ -652,7 +653,7 @@ void ehca_tasklet_eq(unsigned long data)
 	ehca_process_eq((struct ehca_shca*)data, 1);
 }
 
-static inline int find_next_online_cpu(struct ehca_comp_pool *pool)
+static int find_next_online_cpu(struct ehca_comp_pool *pool)
 {
 	int cpu;
 	unsigned long flags;
@@ -662,17 +663,20 @@ static inline int find_next_online_cpu(struct ehca_comp_pool *pool)
 		ehca_dmp(cpu_online_mask, cpumask_size(), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
-	cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
-	if (cpu >= nr_cpu_ids)
-		cpu = cpumask_first(cpu_online_mask);
-	pool->last_cpu = cpu;
+	do {
+		cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
+		if (cpu >= nr_cpu_ids)
+			cpu = cpumask_first(cpu_online_mask);
+		pool->last_cpu = cpu;
+	} while (!per_cpu_ptr(pool->cpu_comp_tasks, cpu)->active);
 	spin_unlock_irqrestore(&pool->last_cpu_lock, flags);
 
 	return cpu;
 }
 
 static void __queue_comp_task(struct ehca_cq *__cq,
-			      struct ehca_cpu_comp_task *cct)
+			      struct ehca_cpu_comp_task *cct,
+			      struct task_struct *thread)
 {
 	unsigned long flags;
 
@@ -683,7 +687,7 @@ static void __queue_comp_task(struct ehca_cq *__cq,
 		__cq->nr_callbacks++;
 		list_add_tail(&__cq->entry, &cct->cq_list);
 		cct->cq_jobs++;
-		wake_up(&cct->wait_queue);
+		wake_up_process(thread);
 	} else
 		__cq->nr_callbacks++;
 
@@ -695,6 +699,7 @@ static void queue_comp_task(struct ehca_cq *__cq)
 {
 	int cpu_id;
 	struct ehca_cpu_comp_task *cct;
+	struct task_struct *thread;
 	int cq_jobs;
 	unsigned long flags;
 
@@ -702,7 +707,8 @@ static void queue_comp_task(struct ehca_cq *__cq)
 	BUG_ON(!cpu_online(cpu_id));
 
 	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
-	BUG_ON(!cct);
+	thread = *per_cpu_ptr(pool->cpu_comp_threads, cpu_id);
+	BUG_ON(!cct || !thread);
 
 	spin_lock_irqsave(&cct->task_lock, flags);
 	cq_jobs = cct->cq_jobs;
@@ -710,28 +716,25 @@ static void queue_comp_task(struct ehca_cq *__cq)
 	if (cq_jobs > 0) {
 		cpu_id = find_next_online_cpu(pool);
 		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
-		BUG_ON(!cct);
+		thread = *per_cpu_ptr(pool->cpu_comp_threads, cpu_id);
+		BUG_ON(!cct || !thread);
 	}
-
-	__queue_comp_task(__cq, cct);
+	__queue_comp_task(__cq, cct, thread);
 }
 
 static void run_comp_task(struct ehca_cpu_comp_task *cct)
 {
 	struct ehca_cq *cq;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cct->task_lock, flags);
 
 	while (!list_empty(&cct->cq_list)) {
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
-		spin_unlock_irqrestore(&cct->task_lock, flags);
+		spin_unlock_irq(&cct->task_lock);
 
 		comp_event_callback(cq);
 		if (atomic_dec_and_test(&cq->nr_events))
 			wake_up(&cq->wait_completion);
 
-		spin_lock_irqsave(&cct->task_lock, flags);
+		spin_lock_irq(&cct->task_lock);
 		spin_lock(&cq->task_lock);
 		cq->nr_callbacks--;
 		if (!cq->nr_callbacks) {
@@ -740,159 +743,76 @@ static void run_comp_task(struct ehca_cpu_comp_task *cct)
 		}
 		spin_unlock(&cq->task_lock);
 	}
-
-	spin_unlock_irqrestore(&cct->task_lock, flags);
 }
 
-static int comp_task(void *__cct)
+static void comp_task_park(unsigned int cpu)
 {
-	struct ehca_cpu_comp_task *cct = __cct;
-	int cql_empty;
-	DECLARE_WAITQUEUE(wait, current);
-
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		add_wait_queue(&cct->wait_queue, &wait);
-
-		spin_lock_irq(&cct->task_lock);
-		cql_empty = list_empty(&cct->cq_list);
-		spin_unlock_irq(&cct->task_lock);
-		if (cql_empty)
-			schedule();
-		else
-			__set_current_state(TASK_RUNNING);
-
-		remove_wait_queue(&cct->wait_queue, &wait);
+	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+	struct ehca_cpu_comp_task *target;
+	struct task_struct *thread;
+	struct ehca_cq *cq, *tmp;
+	LIST_HEAD(list);
 
-		spin_lock_irq(&cct->task_lock);
-		cql_empty = list_empty(&cct->cq_list);
-		spin_unlock_irq(&cct->task_lock);
-		if (!cql_empty)
-			run_comp_task(__cct);
+	spin_lock_irq(&cct->task_lock);
+	cct->cq_jobs = 0;
+	cct->active = 0;
+	list_splice_init(&cct->cq_list, &list);
+	spin_unlock_irq(&cct->task_lock);
 
-		set_current_state(TASK_INTERRUPTIBLE);
+	cpu = find_next_online_cpu(pool);
+	target = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+	thread = *per_cpu_ptr(pool->cpu_comp_threads, cpu);
+	spin_lock_irq(&target->task_lock);
+	list_for_each_entry_safe(cq, tmp, &list, entry) {
+		list_del(&cq->entry);
+		__queue_comp_task(cq, target, thread);
 	}
-	__set_current_state(TASK_RUNNING);
-
-	return 0;
-}
-
-static struct task_struct *create_comp_task(struct ehca_comp_pool *pool,
-					    int cpu)
-{
-	struct ehca_cpu_comp_task *cct;
-
-	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-	spin_lock_init(&cct->task_lock);
-	INIT_LIST_HEAD(&cct->cq_list);
-	init_waitqueue_head(&cct->wait_queue);
-	cct->task = kthread_create_on_node(comp_task, cct, cpu_to_node(cpu),
-					   "ehca_comp/%d", cpu);
-
-	return cct->task;
+	spin_unlock_irq(&target->task_lock);
 }
 
-static void destroy_comp_task(struct ehca_comp_pool *pool,
-			      int cpu)
+static void comp_task_stop(unsigned int cpu, bool online)
 {
-	struct ehca_cpu_comp_task *cct;
-	struct task_struct *task;
-	unsigned long flags_cct;
-
-	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-
-	spin_lock_irqsave(&cct->task_lock, flags_cct);
+	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 
-	task = cct->task;
-	cct->task = NULL;
+	spin_lock_irq(&cct->task_lock);
 	cct->cq_jobs = 0;
-
-	spin_unlock_irqrestore(&cct->task_lock, flags_cct);
-
-	if (task)
-		kthread_stop(task);
+	cct->active = 0;
+	WARN_ON(!list_empty(&cct->cq_list));
+	spin_unlock_irq(&cct->task_lock);
 }
 
-static void __cpuinit take_over_work(struct ehca_comp_pool *pool, int cpu)
+static int comp_task_should_run(unsigned int cpu)
 {
 	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-	LIST_HEAD(list);
-	struct ehca_cq *cq;
-	unsigned long flags_cct;
-
-	spin_lock_irqsave(&cct->task_lock, flags_cct);
-
-	list_splice_init(&cct->cq_list, &list);
-
-	while (!list_empty(&list)) {
-		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
-
-		list_del(&cq->entry);
-		__queue_comp_task(cq, this_cpu_ptr(pool->cpu_comp_tasks));
-	}
-
-	spin_unlock_irqrestore(&cct->task_lock, flags_cct);
 
+	return cct->cq_jobs;
 }
 
-static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
-					unsigned long action,
-					void *hcpu)
+static void comp_task(unsigned int cpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
-	struct ehca_cpu_comp_task *cct;
+	struct ehca_cpu_comp_task *cct = this_cpu_ptr(pool->cpu_comp_tasks);
+	int cql_empty;
 
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_PREPARE)", cpu);
-		if (!create_comp_task(pool, cpu)) {
-			ehca_gen_err("Can't create comp_task for cpu: %x", cpu);
-			return notifier_from_errno(-ENOMEM);
-		}
-		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_CANCELED)", cpu);
-		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-		kthread_bind(cct->task, cpumask_any(cpu_online_mask));
-		destroy_comp_task(pool, cpu);
-		break;
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_ONLINE)", cpu);
-		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-		kthread_bind(cct->task, cpu);
-		wake_up_process(cct->task);
-		break;
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_DOWN_PREPARE)", cpu);
-		break;
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_DOWN_FAILED)", cpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		ehca_gen_dbg("CPU: %x (CPU_DEAD)", cpu);
-		destroy_comp_task(pool, cpu);
-		take_over_work(pool, cpu);
-		break;
+	spin_lock_irq(&cct->task_lock);
+	cql_empty = list_empty(&cct->cq_list);
+	if (!cql_empty) {
+		__set_current_state(TASK_RUNNING);
+		run_comp_task(cct);
 	}
-
-	return NOTIFY_OK;
+	spin_unlock_irq(&cct->task_lock);
 }
 
-static struct notifier_block comp_pool_callback_nb __cpuinitdata = {
-	.notifier_call	= comp_pool_callback,
-	.priority	= 0,
+static struct smp_hotplug_thread comp_pool_threads = {
+	.thread_should_run	= comp_task_should_run,
+	.thread_fn		= comp_task,
+	.thread_comm		= "ehca_comp/%u",
+	.cleanup		= comp_task_stop,
+	.park			= comp_task_park,
 };
 
 int ehca_create_comp_pool(void)
 {
-	int cpu;
-	struct task_struct *task;
+	int cpu, ret = -ENOMEM;
 
 	if (!ehca_scaling_code)
 		return 0;
@@ -905,38 +825,46 @@ int ehca_create_comp_pool(void)
 	pool->last_cpu = cpumask_any(cpu_online_mask);
 
 	pool->cpu_comp_tasks = alloc_percpu(struct ehca_cpu_comp_task);
-	if (pool->cpu_comp_tasks == NULL) {
-		kfree(pool);
-		return -EINVAL;
-	}
+	if (!pool->cpu_comp_tasks)
+		goto out_pool;
 
-	for_each_online_cpu(cpu) {
-		task = create_comp_task(pool, cpu);
-		if (task) {
-			kthread_bind(task, cpu);
-			wake_up_process(task);
-		}
+	pool->cpu_comp_threads = alloc_percpu(struct task_struct *);
+	if (!pool->cpu_comp_threads)
+		goto out_tasks;
+
+	for_each_present_cpu(cpu) {
+		struct ehca_cpu_comp_task *cct;
+
+		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+		spin_lock_init(&cct->task_lock);
+		INIT_LIST_HEAD(&cct->cq_list);
 	}
 
-	register_hotcpu_notifier(&comp_pool_callback_nb);
+	comp_pool_threads.store = pool->cpu_comp_threads;
+	ret = smpboot_register_percpu_thread(&comp_pool_threads);
+	if (ret)
+		goto out_threads;
 
-	printk(KERN_INFO "eHCA scaling code enabled\n");
+	pr_info("eHCA scaling code enabled\n");
+	return ret;
 
-	return 0;
+out_threads:
+	free_percpu(pool->cpu_comp_threads);
+out_tasks:
+	free_percpu(pool->cpu_comp_tasks);
+out_pool:
+	kfree(pool);
+	return ret;
 }
 
 void ehca_destroy_comp_pool(void)
 {
-	int i;
-
 	if (!ehca_scaling_code)
 		return;
 
-	unregister_hotcpu_notifier(&comp_pool_callback_nb);
-
-	for_each_online_cpu(i)
-		destroy_comp_task(pool, i);
+	smpboot_unregister_percpu_thread(&comp_pool_threads);
 
+	free_percpu(pool->cpu_comp_threads);
 	free_percpu(pool->cpu_comp_tasks);
 	kfree(pool);
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.h b/drivers/infiniband/hw/ehca/ehca_irq.h
index 3346cb0..5370199 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.h
+++ b/drivers/infiniband/hw/ehca/ehca_irq.h
@@ -58,15 +58,15 @@ void ehca_tasklet_eq(unsigned long data);
 void ehca_process_eq(struct ehca_shca *shca, int is_irq);
 
 struct ehca_cpu_comp_task {
-	wait_queue_head_t wait_queue;
 	struct list_head cq_list;
-	struct task_struct *task;
 	spinlock_t task_lock;
 	int cq_jobs;
+	int active;
 };
 
 struct ehca_comp_pool {
-	struct ehca_cpu_comp_task *cpu_comp_tasks;
+	struct ehca_cpu_comp_task __percpu *cpu_comp_tasks;
+	struct task_struct * __percpu *cpu_comp_threads;
 	int last_cpu;
 	spinlock_t last_cpu_lock;
 };
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c5f856a..5e4e617 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -430,6 +430,8 @@ enum
 	NR_SOFTIRQS
 };
 
+#define SOFTIRQ_STOP_IDLE_MASK (~(1 << RCU_SOFTIRQ))
+
 /* map softirq index to softirq name. update 'softirq_to_name' in
  * kernel/softirq.c when adding a new softirq.
  */
diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 22ccf9d..8d81664 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -14,6 +14,11 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
 
 
+struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
+					  void *data,
+					  unsigned int cpu,
+					  const char *namefmt);
+
 /**
  * kthread_run - create and wake a thread.
  * @threadfn: the function to run until signal_pending(current).
@@ -34,9 +39,13 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
-int kthread_should_stop(void);
+bool kthread_should_stop(void);
+bool kthread_should_park(void);
 bool kthread_freezable_should_stop(bool *was_frozen);
 void *kthread_data(struct task_struct *k);
+int kthread_park(struct task_struct *k);
+void kthread_unpark(struct task_struct *k);
+void kthread_parkme(void);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 115ead2..7c968e4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -191,6 +191,21 @@ extern void rcu_idle_enter(void);
 extern void rcu_idle_exit(void);
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
+
+#ifdef CONFIG_RCU_USER_QS
+extern void rcu_user_enter(void);
+extern void rcu_user_exit(void);
+extern void rcu_user_enter_after_irq(void);
+extern void rcu_user_exit_after_irq(void);
+extern void rcu_user_hooks_switch(struct task_struct *prev,
+				  struct task_struct *next);
+#else
+static inline void rcu_user_enter(void) { }
+static inline void rcu_user_exit(void) { }
+static inline void rcu_user_enter_after_irq(void) { }
+static inline void rcu_user_exit_after_irq(void) { }
+#endif /* CONFIG_RCU_USER_QS */
+
 extern void exit_rcu(void);
 
 /**
@@ -210,14 +225,12 @@ extern void exit_rcu(void);
  * to nest RCU_NONIDLE() wrappers, but the nesting level is currently
  * quite limited.  If deeper nesting is required, it will be necessary
  * to adjust DYNTICK_TASK_NESTING_VALUE accordingly.
- *
- * This macro may be used from process-level code only.
  */
 #define RCU_NONIDLE(a) \
 	do { \
-		rcu_idle_exit(); \
+		rcu_irq_enter(); \
 		do { a; } while (0); \
-		rcu_idle_enter(); \
+		rcu_irq_exit(); \
 	} while (0)
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 23bddac..335720a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1885,6 +1885,14 @@ static inline void rcu_copy_process(struct task_struct *p)
 
 #endif
 
+static inline void rcu_switch(struct task_struct *prev,
+			      struct task_struct *next)
+{
+#ifdef CONFIG_RCU_USER_QS
+	rcu_user_hooks_switch(prev, next);
+#endif
+}
+
 static inline void tsk_restore_flags(struct task_struct *task,
 				unsigned long orig_flags, unsigned long flags)
 {
diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
new file mode 100644
index 0000000..e0106d8
--- /dev/null
+++ b/include/linux/smpboot.h
@@ -0,0 +1,43 @@
+#ifndef _LINUX_SMPBOOT_H
+#define _LINUX_SMPBOOT_H
+
+#include <linux/types.h>
+
+struct task_struct;
+/* Cookie handed to the thread_fn*/
+struct smpboot_thread_data;
+
+/**
+ * struct smp_hotplug_thread - CPU hotplug related thread descriptor
+ * @store:		Pointer to per cpu storage for the task pointers
+ * @list:		List head for core management
+ * @thread_should_run:	Check whether the thread should run or not. Called with
+ *			preemption disabled.
+ * @thread_fn:		The associated thread function
+ * @setup:		Optional setup function, called when the thread gets
+ *			operational the first time
+ * @cleanup:		Optional cleanup function, called when the thread
+ *			should stop (module exit)
+ * @park:		Optional park function, called when the thread is
+ *			parked (cpu offline)
+ * @unpark:		Optional unpark function, called when the thread is
+ *			unparked (cpu online)
+ * @thread_comm:	The base name of the thread
+ */
+struct smp_hotplug_thread {
+	struct task_struct __percpu	**store;
+	struct list_head		list;
+	int				(*thread_should_run)(unsigned int cpu);
+	void				(*thread_fn)(unsigned int cpu);
+	void				(*setup)(unsigned int cpu);
+	void				(*cleanup)(unsigned int cpu, bool online);
+	void				(*park)(unsigned int cpu);
+	void				(*unpark)(unsigned int cpu);
+	const char			*thread_comm;
+};
+
+int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread);
+void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread);
+int smpboot_thread_schedule(void);
+
+#endif
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 802de56..2f322c3 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -136,6 +136,22 @@ static inline void tracepoint_synchronize_unregister(void)
 		postrcu;						\
 	} while (0)
 
+#ifndef MODULE
+#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)	\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{								\
+		if (static_key_false(&__tracepoint_##name.key))		\
+			__DO_TRACE(&__tracepoint_##name,		\
+				TP_PROTO(data_proto),			\
+				TP_ARGS(data_args),			\
+				TP_CONDITION(cond),			\
+				rcu_idle_exit(),			\
+				rcu_idle_enter());			\
+	}
+#else
+#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)
+#endif
+
 /*
  * Make sure the alignment of the structure in the __tracepoints section will
  * not add unwanted padding between the beginning of the section and the
@@ -151,16 +167,8 @@ static inline void tracepoint_synchronize_unregister(void)
 				TP_ARGS(data_args),			\
 				TP_CONDITION(cond),,);			\
 	}								\
-	static inline void trace_##name##_rcuidle(proto)		\
-	{								\
-		if (static_key_false(&__tracepoint_##name.key))		\
-			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(data_proto),			\
-				TP_ARGS(data_args),			\
-				TP_CONDITION(cond),			\
-				rcu_idle_exit(),			\
-				rcu_idle_enter());			\
-	}								\
+	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),		\
+		PARAMS(cond), PARAMS(data_proto), PARAMS(data_args))	\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto), void *data)	\
 	{								\
diff --git a/init/Kconfig b/init/Kconfig
index af6c7f8..c26b8a1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -441,6 +441,24 @@ config PREEMPT_RCU
 	  This option enables preemptible-RCU code that is common between
 	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
 
+config RCU_USER_QS
+	bool "Consider userspace as in RCU extended quiescent state"
+	depends on HAVE_RCU_USER_QS && SMP
+	help
+	  This option sets hooks on kernel / userspace boundaries and
+	  puts RCU in extended quiescent state when the CPU runs in
+	  userspace. It means that when a CPU runs in userspace, it is
+	  excluded from the global RCU state machine and thus doesn't
+	  to keep the timer tick on for RCU.
+
+config RCU_USER_QS_FORCE
+	bool "Force userspace extended QS by default"
+	depends on RCU_USER_QS
+	help
+	  Set the hooks in user/kernel boundaries by default in order to
+	  test this feature that treats userspace as an extended quiescent
+	  state until we have a real user like a full adaptive nohz option.
+
 config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
diff --git a/kernel/Makefile b/kernel/Makefile
index c0cc67a..e5602d3 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o \
-	    async.o range.o groups.o lglock.o
+	    async.o range.o groups.o lglock.o smpboot.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
@@ -46,7 +46,6 @@ obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += smp.o
-obj-$(CONFIG_SMP) += smpboot.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 14d3258..e615dfb 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -280,12 +280,13 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 				__func__, cpu);
 		goto out_release;
 	}
+	smpboot_park_threads(cpu);
 
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
+		smpboot_unpark_threads(cpu);
 		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
-
 		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
@@ -354,6 +355,10 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		goto out;
 	}
 
+	ret = smpboot_create_threads(cpu);
+	if (ret)
+		goto out;
+
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
@@ -368,6 +373,9 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
 
+	/* Wake the per cpu threads */
+	smpboot_unpark_threads(cpu);
+
 	/* Now call notifier in preparation. */
 	cpu_notify(CPU_ONLINE | mod, hcpu);
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index b579af5..146a6fa 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -37,11 +37,20 @@ struct kthread_create_info
 };
 
 struct kthread {
-	int should_stop;
+	unsigned long flags;
+	unsigned int cpu;
 	void *data;
+	struct completion parked;
 	struct completion exited;
 };
 
+enum KTHREAD_BITS {
+	KTHREAD_IS_PER_CPU = 0,
+	KTHREAD_SHOULD_STOP,
+	KTHREAD_SHOULD_PARK,
+	KTHREAD_IS_PARKED,
+};
+
 #define to_kthread(tsk)	\
 	container_of((tsk)->vfork_done, struct kthread, exited)
 
@@ -52,13 +61,29 @@ struct kthread {
  * and this will return true.  You should then return, and your return
  * value will be passed through to kthread_stop().
  */
-int kthread_should_stop(void)
+bool kthread_should_stop(void)
 {
-	return to_kthread(current)->should_stop;
+	return test_bit(KTHREAD_SHOULD_STOP, &to_kthread(current)->flags);
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
 /**
+ * kthread_should_park - should this kthread park now?
+ *
+ * When someone calls kthread_park() on your kthread, it will be woken
+ * and this will return true.  You should then do the necessary
+ * cleanup and call kthread_parkme()
+ *
+ * Similar to kthread_should_stop(), but this keeps the thread alive
+ * and in a park position. kthread_unpark() "restarts" the thread and
+ * calls the thread function again.
+ */
+bool kthread_should_park(void)
+{
+	return test_bit(KTHREAD_SHOULD_PARK, &to_kthread(current)->flags);
+}
+
+/**
  * kthread_freezable_should_stop - should this freezable kthread return now?
  * @was_frozen: optional out parameter, indicates whether %current was frozen
  *
@@ -96,6 +121,24 @@ void *kthread_data(struct task_struct *task)
 	return to_kthread(task)->data;
 }
 
+static void __kthread_parkme(struct kthread *self)
+{
+	__set_current_state(TASK_INTERRUPTIBLE);
+	while (test_bit(KTHREAD_SHOULD_PARK, &self->flags)) {
+		if (!test_and_set_bit(KTHREAD_IS_PARKED, &self->flags))
+			complete(&self->parked);
+		schedule();
+		__set_current_state(TASK_INTERRUPTIBLE);
+	}
+	clear_bit(KTHREAD_IS_PARKED, &self->flags);
+	__set_current_state(TASK_RUNNING);
+}
+
+void kthread_parkme(void)
+{
+	__kthread_parkme(to_kthread(current));
+}
+
 static int kthread(void *_create)
 {
 	/* Copy data: it's on kthread's stack */
@@ -105,9 +148,10 @@ static int kthread(void *_create)
 	struct kthread self;
 	int ret;
 
-	self.should_stop = 0;
+	self.flags = 0;
 	self.data = data;
 	init_completion(&self.exited);
+	init_completion(&self.parked);
 	current->vfork_done = &self.exited;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
@@ -117,9 +161,11 @@ static int kthread(void *_create)
 	schedule();
 
 	ret = -EINTR;
-	if (!self.should_stop)
-		ret = threadfn(data);
 
+	if (!test_bit(KTHREAD_SHOULD_STOP, &self.flags)) {
+		__kthread_parkme(&self);
+		ret = threadfn(data);
+	}
 	/* we can't just return, we must preserve "self" on stack */
 	do_exit(ret);
 }
@@ -172,8 +218,7 @@ static void create_kthread(struct kthread_create_info *create)
  * Returns a task_struct or ERR_PTR(-ENOMEM).
  */
 struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
-					   void *data,
-					   int node,
+					   void *data, int node,
 					   const char namefmt[],
 					   ...)
 {
@@ -210,6 +255,13 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 }
 EXPORT_SYMBOL(kthread_create_on_node);
 
+static void __kthread_bind(struct task_struct *p, unsigned int cpu)
+{
+	/* It's safe because the task is inactive. */
+	do_set_cpus_allowed(p, cpumask_of(cpu));
+	p->flags |= PF_THREAD_BOUND;
+}
+
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
  * @p: thread created by kthread_create().
@@ -226,14 +278,112 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
 		WARN_ON(1);
 		return;
 	}
-
-	/* It's safe because the task is inactive. */
-	do_set_cpus_allowed(p, cpumask_of(cpu));
-	p->flags |= PF_THREAD_BOUND;
+	__kthread_bind(p, cpu);
 }
 EXPORT_SYMBOL(kthread_bind);
 
 /**
+ * kthread_create_on_cpu - Create a cpu bound kthread
+ * @threadfn: the function to run until signal_pending(current).
+ * @data: data ptr for @threadfn.
+ * @cpu: The cpu on which the thread should be bound,
+ * @namefmt: printf-style name for the thread. Format is restricted
+ *	     to "name.*%u". Code fills in cpu number.
+ *
+ * Description: This helper function creates and names a kernel thread
+ * The thread will be woken and put into park mode.
+ */
+struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
+					  void *data, unsigned int cpu,
+					  const char *namefmt)
+{
+	struct task_struct *p;
+
+	p = kthread_create_on_node(threadfn, data, cpu_to_node(cpu), namefmt,
+				   cpu);
+	if (IS_ERR(p))
+		return p;
+	set_bit(KTHREAD_IS_PER_CPU, &to_kthread(p)->flags);
+	to_kthread(p)->cpu = cpu;
+	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
+	kthread_park(p);
+	return p;
+}
+
+static struct kthread *task_get_live_kthread(struct task_struct *k)
+{
+	struct kthread *kthread;
+
+	get_task_struct(k);
+	kthread = to_kthread(k);
+	/* It might have exited */
+	barrier();
+	if (k->vfork_done != NULL)
+		return kthread;
+	return NULL;
+}
+
+/**
+ * kthread_unpark - unpark a thread created by kthread_create().
+ * @k:		thread created by kthread_create().
+ *
+ * Sets kthread_should_park() for @k to return false, wakes it, and
+ * waits for it to return. If the thread is marked percpu then its
+ * bound to the cpu again.
+ */
+void kthread_unpark(struct task_struct *k)
+{
+	struct kthread *kthread = task_get_live_kthread(k);
+
+	if (kthread) {
+		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
+		/*
+		 * We clear the IS_PARKED bit here as we don't wait
+		 * until the task has left the park code. So if we'd
+		 * park before that happens we'd see the IS_PARKED bit
+		 * which might be about to be cleared.
+		 */
+		if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
+			if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
+				__kthread_bind(k, kthread->cpu);
+			wake_up_process(k);
+		}
+	}
+	put_task_struct(k);
+}
+
+/**
+ * kthread_park - park a thread created by kthread_create().
+ * @k: thread created by kthread_create().
+ *
+ * Sets kthread_should_park() for @k to return true, wakes it, and
+ * waits for it to return. This can also be called after kthread_create()
+ * instead of calling wake_up_process(): the thread will park without
+ * calling threadfn().
+ *
+ * Returns 0 if the thread is parked, -ENOSYS if the thread exited.
+ * If called by the kthread itself just the park bit is set.
+ */
+int kthread_park(struct task_struct *k)
+{
+	struct kthread *kthread = task_get_live_kthread(k);
+	int ret = -ENOSYS;
+
+	if (kthread) {
+		if (!test_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
+			set_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
+			if (k != current) {
+				wake_up_process(k);
+				wait_for_completion(&kthread->parked);
+			}
+		}
+		ret = 0;
+	}
+	put_task_struct(k);
+	return ret;
+}
+
+/**
  * kthread_stop - stop a thread created by kthread_create().
  * @k: thread created by kthread_create().
  *
@@ -250,16 +400,13 @@ EXPORT_SYMBOL(kthread_bind);
  */
 int kthread_stop(struct task_struct *k)
 {
-	struct kthread *kthread;
+	struct kthread *kthread = task_get_live_kthread(k);
 	int ret;
 
 	trace_sched_kthread_stop(k);
-	get_task_struct(k);
-
-	kthread = to_kthread(k);
-	barrier(); /* it might have exited */
-	if (k->vfork_done != NULL) {
-		kthread->should_stop = 1;
+	if (kthread) {
+		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
+		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
 		wake_up_process(k);
 		wait_for_completion(&kthread->exited);
 	}
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 4e6a61b..29ca1c6 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -45,6 +45,7 @@
 #include <linux/mutex.h>
 #include <linux/export.h>
 #include <linux/hardirq.h>
+#include <linux/delay.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/rcu.h>
@@ -81,6 +82,9 @@ void __rcu_read_unlock(void)
 	} else {
 		barrier();  /* critical section before exit code. */
 		t->rcu_read_lock_nesting = INT_MIN;
+#ifdef CONFIG_PROVE_RCU_DELAY
+		udelay(10); /* Make preemption more probable. */
+#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 			rcu_read_unlock_special(t);
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 547b1fe..e4c6a59 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -56,25 +56,28 @@ static void __call_rcu(struct rcu_head *head,
 static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
-static void rcu_idle_enter_common(long long oldval)
+static void rcu_idle_enter_common(long long newval)
 {
-	if (rcu_dynticks_nesting) {
+	if (newval) {
 		RCU_TRACE(trace_rcu_dyntick("--=",
-					    oldval, rcu_dynticks_nesting));
+					    rcu_dynticks_nesting, newval));
+		rcu_dynticks_nesting = newval;
 		return;
 	}
-	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
+	RCU_TRACE(trace_rcu_dyntick("Start", rcu_dynticks_nesting, newval));
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
-					    oldval, rcu_dynticks_nesting));
+					    rcu_dynticks_nesting, newval));
 		ftrace_dump(DUMP_ALL);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
 	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
+	barrier();
+	rcu_dynticks_nesting = newval;
 }
 
 /*
@@ -84,17 +87,16 @@ static void rcu_idle_enter_common(long long oldval)
 void rcu_idle_enter(void)
 {
 	unsigned long flags;
-	long long oldval;
+	long long newval;
 
 	local_irq_save(flags);
-	oldval = rcu_dynticks_nesting;
 	WARN_ON_ONCE((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) ==
 	    DYNTICK_TASK_NEST_VALUE)
-		rcu_dynticks_nesting = 0;
+		newval = 0;
 	else
-		rcu_dynticks_nesting  -= DYNTICK_TASK_NEST_VALUE;
-	rcu_idle_enter_common(oldval);
+		newval = rcu_dynticks_nesting - DYNTICK_TASK_NEST_VALUE;
+	rcu_idle_enter_common(newval);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -105,15 +107,15 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
 void rcu_irq_exit(void)
 {
 	unsigned long flags;
-	long long oldval;
+	long long newval;
 
 	local_irq_save(flags);
-	oldval = rcu_dynticks_nesting;
-	rcu_dynticks_nesting--;
-	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
-	rcu_idle_enter_common(oldval);
+	newval = rcu_dynticks_nesting - 1;
+	WARN_ON_ONCE(newval < 0);
+	rcu_idle_enter_common(newval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_irq_exit);
 
 /* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcutree.c. */
 static void rcu_idle_exit_common(long long oldval)
@@ -171,6 +173,7 @@ void rcu_irq_enter(void)
 	rcu_idle_exit_common(oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_irq_enter);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 918fd1e..3d01902 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -278,7 +278,7 @@ static int rcu_boost(void)
 	    rcu_preempt_ctrlblk.exp_tasks == NULL)
 		return 0;  /* Nothing to boost. */
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 
 	/*
 	 * Recheck with irqs disabled: all tasks in need of boosting
@@ -287,7 +287,7 @@ static int rcu_boost(void)
 	 */
 	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
 	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
-		raw_local_irq_restore(flags);
+		local_irq_restore(flags);
 		return 0;
 	}
 
@@ -317,7 +317,7 @@ static int rcu_boost(void)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 	rt_mutex_lock(&mtx);
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
 
@@ -991,9 +991,9 @@ static void rcu_trace_sub_qlen(struct rcu_ctrlblk *rcp, int n)
 {
 	unsigned long flags;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	rcp->qlen -= n;
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 
 /*
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 25b1503..aaa7b9f 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -53,10 +53,11 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@fre
 
 static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
 static int nfakewriters = 4;	/* # fake writer threads */
-static int stat_interval;	/* Interval between stats, in seconds. */
-				/*  Defaults to "only at end of test". */
+static int stat_interval = 60;	/* Interval between stats, in seconds. */
+				/*  Zero means "only at end of test". */
 static bool verbose;		/* Print more debug info. */
-static bool test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
+static bool test_no_idle_hz = true;
+				/* Test RCU support for tickless idle CPUs. */
 static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
 static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static int irqreader = 1;	/* RCU readers from irq (timers). */
@@ -119,11 +120,11 @@ MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
 #define TORTURE_FLAG "-torture:"
 #define PRINTK_STRING(s) \
-	do { printk(KERN_ALERT "%s" TORTURE_FLAG s "\n", torture_type); } while (0)
+	do { pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
 #define VERBOSE_PRINTK_STRING(s) \
-	do { if (verbose) printk(KERN_ALERT "%s" TORTURE_FLAG s "\n", torture_type); } while (0)
+	do { if (verbose) pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
 #define VERBOSE_PRINTK_ERRSTRING(s) \
-	do { if (verbose) printk(KERN_ALERT "%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
+	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
 
 static char printk_buf[4096];
 
@@ -176,8 +177,14 @@ static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
 static long n_offline_attempts;
 static long n_offline_successes;
+static unsigned long sum_offline;
+static int min_offline = -1;
+static int max_offline;
 static long n_online_attempts;
 static long n_online_successes;
+static unsigned long sum_online;
+static int min_online = -1;
+static int max_online;
 static long n_barrier_attempts;
 static long n_barrier_successes;
 static struct list_head rcu_torture_removed;
@@ -235,7 +242,7 @@ rcutorture_shutdown_notify(struct notifier_block *unused1,
 	if (fullstop == FULLSTOP_DONTSTOP)
 		fullstop = FULLSTOP_SHUTDOWN;
 	else
-		printk(KERN_WARNING /* but going down anyway, so... */
+		pr_warn(/* but going down anyway, so... */
 		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
 	mutex_unlock(&fullstop_mutex);
 	return NOTIFY_DONE;
@@ -248,7 +255,7 @@ rcutorture_shutdown_notify(struct notifier_block *unused1,
 static void rcutorture_shutdown_absorb(char *title)
 {
 	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
-		printk(KERN_NOTICE
+		pr_notice(
 		       "rcutorture thread %s parking due to system shutdown\n",
 		       title);
 		schedule_timeout_uninterruptible(MAX_SCHEDULE_TIMEOUT);
@@ -1214,11 +1221,13 @@ rcu_torture_printk(char *page)
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
-	cnt += sprintf(&page[cnt], "onoff: %ld/%ld:%ld/%ld ",
-		       n_online_successes,
-		       n_online_attempts,
-		       n_offline_successes,
-		       n_offline_attempts);
+	cnt += sprintf(&page[cnt],
+		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
+		       n_online_successes, n_online_attempts,
+		       n_offline_successes, n_offline_attempts,
+		       min_online, max_online,
+		       min_offline, max_offline,
+		       sum_online, sum_offline, HZ);
 	cnt += sprintf(&page[cnt], "barrier: %ld/%ld:%ld",
 		       n_barrier_successes,
 		       n_barrier_attempts,
@@ -1267,7 +1276,7 @@ rcu_torture_stats_print(void)
 	int cnt;
 
 	cnt = rcu_torture_printk(printk_buf);
-	printk(KERN_ALERT "%s", printk_buf);
+	pr_alert("%s", printk_buf);
 }
 
 /*
@@ -1380,20 +1389,20 @@ rcu_torture_stutter(void *arg)
 static inline void
 rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 {
-	printk(KERN_ALERT "%s" TORTURE_FLAG
-		"--- %s: nreaders=%d nfakewriters=%d "
-		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
-		"shuffle_interval=%d stutter=%d irqreader=%d "
-		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
-		"test_boost=%d/%d test_boost_interval=%d "
-		"test_boost_duration=%d shutdown_secs=%d "
-		"onoff_interval=%d onoff_holdoff=%d\n",
-		torture_type, tag, nrealreaders, nfakewriters,
-		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
-		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
-		test_boost, cur_ops->can_boost,
-		test_boost_interval, test_boost_duration, shutdown_secs,
-		onoff_interval, onoff_holdoff);
+	pr_alert("%s" TORTURE_FLAG
+		 "--- %s: nreaders=%d nfakewriters=%d "
+		 "stat_interval=%d verbose=%d test_no_idle_hz=%d "
+		 "shuffle_interval=%d stutter=%d irqreader=%d "
+		 "fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
+		 "test_boost=%d/%d test_boost_interval=%d "
+		 "test_boost_duration=%d shutdown_secs=%d "
+		 "onoff_interval=%d onoff_holdoff=%d\n",
+		 torture_type, tag, nrealreaders, nfakewriters,
+		 stat_interval, verbose, test_no_idle_hz, shuffle_interval,
+		 stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
+		 test_boost, cur_ops->can_boost,
+		 test_boost_interval, test_boost_duration, shutdown_secs,
+		 onoff_interval, onoff_holdoff);
 }
 
 static struct notifier_block rcutorture_shutdown_nb = {
@@ -1460,9 +1469,9 @@ rcu_torture_shutdown(void *arg)
 	       !kthread_should_stop()) {
 		delta = shutdown_time - jiffies_snap;
 		if (verbose)
-			printk(KERN_ALERT "%s" TORTURE_FLAG
-			       "rcu_torture_shutdown task: %lu jiffies remaining\n",
-			       torture_type, delta);
+			pr_alert("%s" TORTURE_FLAG
+				 "rcu_torture_shutdown task: %lu jiffies remaining\n",
+				 torture_type, delta);
 		schedule_timeout_interruptible(delta);
 		jiffies_snap = ACCESS_ONCE(jiffies);
 	}
@@ -1490,8 +1499,10 @@ static int __cpuinit
 rcu_torture_onoff(void *arg)
 {
 	int cpu;
+	unsigned long delta;
 	int maxcpu = -1;
 	DEFINE_RCU_RANDOM(rand);
+	unsigned long starttime;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_onoff task started");
 	for_each_online_cpu(cpu)
@@ -1506,29 +1517,51 @@ rcu_torture_onoff(void *arg)
 		cpu = (rcu_random(&rand) >> 4) % (maxcpu + 1);
 		if (cpu_online(cpu) && cpu_is_hotpluggable(cpu)) {
 			if (verbose)
-				printk(KERN_ALERT "%s" TORTURE_FLAG
-				       "rcu_torture_onoff task: offlining %d\n",
-				       torture_type, cpu);
+				pr_alert("%s" TORTURE_FLAG
+					 "rcu_torture_onoff task: offlining %d\n",
+					 torture_type, cpu);
+			starttime = jiffies;
 			n_offline_attempts++;
 			if (cpu_down(cpu) == 0) {
 				if (verbose)
-					printk(KERN_ALERT "%s" TORTURE_FLAG
-					       "rcu_torture_onoff task: offlined %d\n",
-					       torture_type, cpu);
+					pr_alert("%s" TORTURE_FLAG
+						 "rcu_torture_onoff task: offlined %d\n",
+						 torture_type, cpu);
 				n_offline_successes++;
+				delta = jiffies - starttime;
+				sum_offline += delta;
+				if (min_offline < 0) {
+					min_offline = delta;
+					max_offline = delta;
+				}
+				if (min_offline > delta)
+					min_offline = delta;
+				if (max_offline < delta)
+					max_offline = delta;
 			}
 		} else if (cpu_is_hotpluggable(cpu)) {
 			if (verbose)
-				printk(KERN_ALERT "%s" TORTURE_FLAG
-				       "rcu_torture_onoff task: onlining %d\n",
-				       torture_type, cpu);
+				pr_alert("%s" TORTURE_FLAG
+					 "rcu_torture_onoff task: onlining %d\n",
+					 torture_type, cpu);
+			starttime = jiffies;
 			n_online_attempts++;
 			if (cpu_up(cpu) == 0) {
 				if (verbose)
-					printk(KERN_ALERT "%s" TORTURE_FLAG
-					       "rcu_torture_onoff task: onlined %d\n",
-					       torture_type, cpu);
+					pr_alert("%s" TORTURE_FLAG
+						 "rcu_torture_onoff task: onlined %d\n",
+						 torture_type, cpu);
 				n_online_successes++;
+				delta = jiffies - starttime;
+				sum_online += delta;
+				if (min_online < 0) {
+					min_online = delta;
+					max_online = delta;
+				}
+				if (min_online > delta)
+					min_online = delta;
+				if (max_online < delta)
+					max_online = delta;
 			}
 		}
 		schedule_timeout_interruptible(onoff_interval * HZ);
@@ -1593,14 +1626,14 @@ static int __cpuinit rcu_torture_stall(void *args)
 	if (!kthread_should_stop()) {
 		stop_at = get_seconds() + stall_cpu;
 		/* RCU CPU stall is expected behavior in following code. */
-		printk(KERN_ALERT "rcu_torture_stall start.\n");
+		pr_alert("rcu_torture_stall start.\n");
 		rcu_read_lock();
 		preempt_disable();
 		while (ULONG_CMP_LT(get_seconds(), stop_at))
 			continue;  /* Induce RCU CPU stall warning. */
 		preempt_enable();
 		rcu_read_unlock();
-		printk(KERN_ALERT "rcu_torture_stall end.\n");
+		pr_alert("rcu_torture_stall end.\n");
 	}
 	rcutorture_shutdown_absorb("rcu_torture_stall");
 	while (!kthread_should_stop())
@@ -1716,12 +1749,12 @@ static int rcu_torture_barrier_init(void)
 	if (n_barrier_cbs == 0)
 		return 0;
 	if (cur_ops->call == NULL || cur_ops->cb_barrier == NULL) {
-		printk(KERN_ALERT "%s" TORTURE_FLAG
-		       " Call or barrier ops missing for %s,\n",
-		       torture_type, cur_ops->name);
-		printk(KERN_ALERT "%s" TORTURE_FLAG
-		       " RCU barrier testing omitted from run.\n",
-		       torture_type);
+		pr_alert("%s" TORTURE_FLAG
+			 " Call or barrier ops missing for %s,\n",
+			 torture_type, cur_ops->name);
+		pr_alert("%s" TORTURE_FLAG
+			 " RCU barrier testing omitted from run.\n",
+			 torture_type);
 		return 0;
 	}
 	atomic_set(&barrier_cbs_count, 0);
@@ -1814,7 +1847,7 @@ rcu_torture_cleanup(void)
 	mutex_lock(&fullstop_mutex);
 	rcutorture_record_test_transition();
 	if (fullstop == FULLSTOP_SHUTDOWN) {
-		printk(KERN_WARNING /* but going down anyway, so... */
+		pr_warn(/* but going down anyway, so... */
 		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
 		mutex_unlock(&fullstop_mutex);
 		schedule_timeout_uninterruptible(10);
@@ -1938,17 +1971,17 @@ rcu_torture_init(void)
 			break;
 	}
 	if (i == ARRAY_SIZE(torture_ops)) {
-		printk(KERN_ALERT "rcu-torture: invalid torture type: \"%s\"\n",
-		       torture_type);
-		printk(KERN_ALERT "rcu-torture types:");
+		pr_alert("rcu-torture: invalid torture type: \"%s\"\n",
+			 torture_type);
+		pr_alert("rcu-torture types:");
 		for (i = 0; i < ARRAY_SIZE(torture_ops); i++)
-			printk(KERN_ALERT " %s", torture_ops[i]->name);
-		printk(KERN_ALERT "\n");
+			pr_alert(" %s", torture_ops[i]->name);
+		pr_alert("\n");
 		mutex_unlock(&fullstop_mutex);
 		return -EINVAL;
 	}
 	if (cur_ops->fqs == NULL && fqs_duration != 0) {
-		printk(KERN_ALERT "rcu-torture: ->fqs NULL and non-zero fqs_duration, fqs disabled.\n");
+		pr_alert("rcu-torture: ->fqs NULL and non-zero fqs_duration, fqs disabled.\n");
 		fqs_duration = 0;
 	}
 	if (cur_ops->init)
@@ -1996,14 +2029,15 @@ rcu_torture_init(void)
 	/* Start up the kthreads. */
 
 	VERBOSE_PRINTK_STRING("Creating rcu_torture_writer task");
-	writer_task = kthread_run(rcu_torture_writer, NULL,
-				  "rcu_torture_writer");
+	writer_task = kthread_create(rcu_torture_writer, NULL,
+				     "rcu_torture_writer");
 	if (IS_ERR(writer_task)) {
 		firsterr = PTR_ERR(writer_task);
 		VERBOSE_PRINTK_ERRSTRING("Failed to create writer");
 		writer_task = NULL;
 		goto unwind;
 	}
+	wake_up_process(writer_task);
 	fakewriter_tasks = kzalloc(nfakewriters * sizeof(fakewriter_tasks[0]),
 				   GFP_KERNEL);
 	if (fakewriter_tasks == NULL) {
@@ -2118,14 +2152,15 @@ rcu_torture_init(void)
 	}
 	if (shutdown_secs > 0) {
 		shutdown_time = jiffies + shutdown_secs * HZ;
-		shutdown_task = kthread_run(rcu_torture_shutdown, NULL,
-					    "rcu_torture_shutdown");
+		shutdown_task = kthread_create(rcu_torture_shutdown, NULL,
+					       "rcu_torture_shutdown");
 		if (IS_ERR(shutdown_task)) {
 			firsterr = PTR_ERR(shutdown_task);
 			VERBOSE_PRINTK_ERRSTRING("Failed to create shutdown");
 			shutdown_task = NULL;
 			goto unwind;
 		}
+		wake_up_process(shutdown_task);
 	}
 	i = rcu_torture_onoff_init();
 	if (i != 0) {
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f280e54..4fb2376 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -52,6 +52,7 @@
 #include <linux/prefetch.h>
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
+#include <linux/random.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -61,6 +62,7 @@
 /* Data structures. */
 
 static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
+static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 
 #define RCU_STATE_INITIALIZER(sname, cr) { \
 	.level = { &sname##_state.node[0] }, \
@@ -72,7 +74,6 @@ static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
 	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
 	.orphan_donetail = &sname##_state.orphan_donelist, \
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
-	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.fqslock), \
 	.name = #sname, \
 }
 
@@ -88,7 +89,7 @@ LIST_HEAD(rcu_struct_flavors);
 
 /* Increase (but not decrease) the CONFIG_RCU_FANOUT_LEAF at boot time. */
 static int rcu_fanout_leaf = CONFIG_RCU_FANOUT_LEAF;
-module_param(rcu_fanout_leaf, int, 0);
+module_param(rcu_fanout_leaf, int, 0444);
 int rcu_num_lvls __read_mostly = RCU_NUM_LVLS;
 static int num_rcu_lvl[] = {  /* Number of rcu_nodes at specified level. */
 	NUM_RCU_LVL_0,
@@ -133,13 +134,12 @@ static int rcu_scheduler_fully_active __read_mostly;
  */
 static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
-DEFINE_PER_CPU(int, rcu_cpu_kthread_cpu);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
-static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 
@@ -175,8 +175,6 @@ void rcu_sched_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
 
-	rdp->passed_quiesce_gpnum = rdp->gpnum;
-	barrier();
 	if (rdp->passed_quiesce == 0)
 		trace_rcu_grace_period("rcu_sched", rdp->gpnum, "cpuqs");
 	rdp->passed_quiesce = 1;
@@ -186,8 +184,6 @@ void rcu_bh_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
 
-	rdp->passed_quiesce_gpnum = rdp->gpnum;
-	barrier();
 	if (rdp->passed_quiesce == 0)
 		trace_rcu_grace_period("rcu_bh", rdp->gpnum, "cpuqs");
 	rdp->passed_quiesce = 1;
@@ -210,15 +206,18 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
+#if defined(CONFIG_RCU_USER_QS) && !defined(CONFIG_RCU_USER_QS_FORCE)
+	.ignore_user_qs = true,
+#endif
 };
 
 static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
 static int qhimark = 10000;	/* If this many pending, ignore blimit. */
 static int qlowmark = 100;	/* Once only this many pending, use blimit. */
 
-module_param(blimit, int, 0);
-module_param(qhimark, int, 0);
-module_param(qlowmark, int, 0);
+module_param(blimit, int, 0444);
+module_param(qhimark, int, 0444);
+module_param(qlowmark, int, 0444);
 
 int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
 int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
@@ -226,7 +225,14 @@ int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
 module_param(rcu_cpu_stall_suppress, int, 0644);
 module_param(rcu_cpu_stall_timeout, int, 0644);
 
-static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
+static ulong jiffies_till_first_fqs = RCU_JIFFIES_TILL_FORCE_QS;
+static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
+
+module_param(jiffies_till_first_fqs, ulong, 0644);
+module_param(jiffies_till_next_fqs, ulong, 0644);
+
+static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
+static void force_quiescent_state(struct rcu_state *rsp);
 static int rcu_pending(int cpu);
 
 /*
@@ -252,7 +258,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
  */
 void rcu_bh_force_quiescent_state(void)
 {
-	force_quiescent_state(&rcu_bh_state, 0);
+	force_quiescent_state(&rcu_bh_state);
 }
 EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
 
@@ -286,7 +292,7 @@ EXPORT_SYMBOL_GPL(rcutorture_record_progress);
  */
 void rcu_sched_force_quiescent_state(void)
 {
-	force_quiescent_state(&rcu_sched_state, 0);
+	force_quiescent_state(&rcu_sched_state);
 }
 EXPORT_SYMBOL_GPL(rcu_sched_force_quiescent_state);
 
@@ -305,7 +311,9 @@ cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	return *rdp->nxttail[RCU_DONE_TAIL] && !rcu_gp_in_progress(rsp);
+	return *rdp->nxttail[RCU_DONE_TAIL +
+			     ACCESS_ONCE(rsp->completed) != rdp->completed] &&
+	       !rcu_gp_in_progress(rsp);
 }
 
 /*
@@ -317,45 +325,17 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 }
 
 /*
- * If the specified CPU is offline, tell the caller that it is in
- * a quiescent state.  Otherwise, whack it with a reschedule IPI.
- * Grace periods can end up waiting on an offline CPU when that
- * CPU is in the process of coming online -- it will be added to the
- * rcu_node bitmasks before it actually makes it online.  The same thing
- * can happen while a CPU is in the process of coming online.  Because this
- * race is quite rare, we check for it after detecting that the grace
- * period has been delayed rather than checking each and every CPU
- * each and every time we start a new grace period.
- */
-static int rcu_implicit_offline_qs(struct rcu_data *rdp)
-{
-	/*
-	 * If the CPU is offline for more than a jiffy, it is in a quiescent
-	 * state.  We can trust its state not to change because interrupts
-	 * are disabled.  The reason for the jiffy's worth of slack is to
-	 * handle CPUs initializing on the way up and finding their way
-	 * to the idle loop on the way down.
-	 */
-	if (cpu_is_offline(rdp->cpu) &&
-	    ULONG_CMP_LT(rdp->rsp->gp_start + 2, jiffies)) {
-		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
-		rdp->offline_fqs++;
-		return 1;
-	}
-	return 0;
-}
-
-/*
- * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
+ * rcu_eqs_enter_common - current CPU is moving towards extended quiescent state
  *
  * If the new value of the ->dynticks_nesting counter now is zero,
  * we really have entered idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
+static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
+				bool user)
 {
 	trace_rcu_dyntick("Start", oldval, 0);
-	if (!is_idle_task(current)) {
+	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on entry: not idle task", oldval, 0);
@@ -372,7 +352,7 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 
 	/*
-	 * The idle task is not permitted to enter the idle loop while
+	 * It is illegal to enter an extended quiescent state while
 	 * in an RCU read-side critical section.
 	 */
 	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
@@ -383,6 +363,25 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 			   "Illegal idle entry in RCU-sched read-side critical section.");
 }
 
+/*
+ * Enter an RCU extended quiescent state, which can be either the
+ * idle loop or adaptive-tickless usermode execution.
+ */
+static void rcu_eqs_enter(bool user)
+{
+	long long oldval;
+	struct rcu_dynticks *rdtp;
+
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = rdtp->dynticks_nesting;
+	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
+	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
+		rdtp->dynticks_nesting = 0;
+	else
+		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
+	rcu_eqs_enter_common(rdtp, oldval, user);
+}
+
 /**
  * rcu_idle_enter - inform RCU that current CPU is entering idle
  *
@@ -398,21 +397,70 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 void rcu_idle_enter(void)
 {
 	unsigned long flags;
-	long long oldval;
+
+	local_irq_save(flags);
+	rcu_eqs_enter(false);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(rcu_idle_enter);
+
+#ifdef CONFIG_RCU_USER_QS
+/**
+ * rcu_user_enter - inform RCU that we are resuming userspace.
+ *
+ * Enter RCU idle mode right before resuming userspace.  No use of RCU
+ * is permitted between this call and rcu_user_exit(). This way the
+ * CPU doesn't need to maintain the tick for RCU maintenance purposes
+ * when the CPU runs in userspace.
+ */
+void rcu_user_enter(void)
+{
+	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 
+	/*
+	 * Some contexts may involve an exception occuring in an irq,
+	 * leading to that nesting:
+	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
+	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
+	 * helpers are enough to protect RCU uses inside the exception. So
+	 * just return immediately if we detect we are in an IRQ.
+	 */
+	if (in_interrupt())
+		return;
+
+	WARN_ON_ONCE(!current->mm);
+
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	oldval = rdtp->dynticks_nesting;
-	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
-	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
-		rdtp->dynticks_nesting = 0;
-	else
-		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
-	rcu_idle_enter_common(rdtp, oldval);
+	if (!rdtp->ignore_user_qs && !rdtp->in_user) {
+		rdtp->in_user = true;
+		rcu_eqs_enter(true);
+	}
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(rcu_idle_enter);
+
+/**
+ * rcu_user_enter_after_irq - inform RCU that we are going to resume userspace
+ * after the current irq returns.
+ *
+ * This is similar to rcu_user_enter() but in the context of a non-nesting
+ * irq. After this call, RCU enters into idle mode when the interrupt
+ * returns.
+ */
+void rcu_user_enter_after_irq(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	/* Ensure this irq is interrupting a non-idle RCU state.  */
+	WARN_ON_ONCE(!(rdtp->dynticks_nesting & DYNTICK_TASK_MASK));
+	rdtp->dynticks_nesting = 1;
+	local_irq_restore(flags);
+}
+#endif /* CONFIG_RCU_USER_QS */
 
 /**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
@@ -444,18 +492,19 @@ void rcu_irq_exit(void)
 	if (rdtp->dynticks_nesting)
 		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
 	else
-		rcu_idle_enter_common(rdtp, oldval);
+		rcu_eqs_enter_common(rdtp, oldval, true);
 	local_irq_restore(flags);
 }
 
 /*
- * rcu_idle_exit_common - inform RCU that current CPU is moving away from idle
+ * rcu_eqs_exit_common - current CPU moving away from extended quiescent state
  *
  * If the new value of the ->dynticks_nesting counter was previously zero,
  * we really have exited idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
+static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
+			       int user)
 {
 	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
@@ -464,7 +513,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	rcu_cleanup_after_idle(smp_processor_id());
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
-	if (!is_idle_task(current)) {
+	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on exit: not idle task",
@@ -476,6 +525,25 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	}
 }
 
+/*
+ * Exit an RCU extended quiescent state, which can be either the
+ * idle loop or adaptive-tickless usermode execution.
+ */
+static void rcu_eqs_exit(bool user)
+{
+	struct rcu_dynticks *rdtp;
+	long long oldval;
+
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = rdtp->dynticks_nesting;
+	WARN_ON_ONCE(oldval < 0);
+	if (oldval & DYNTICK_TASK_NEST_MASK)
+		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
+	else
+		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
+	rcu_eqs_exit_common(rdtp, oldval, user);
+}
+
 /**
  * rcu_idle_exit - inform RCU that current CPU is leaving idle
  *
@@ -490,21 +558,67 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 void rcu_idle_exit(void)
 {
 	unsigned long flags;
+
+	local_irq_save(flags);
+	rcu_eqs_exit(false);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(rcu_idle_exit);
+
+#ifdef CONFIG_RCU_USER_QS
+/**
+ * rcu_user_exit - inform RCU that we are exiting userspace.
+ *
+ * Exit RCU idle mode while entering the kernel because it can
+ * run a RCU read side critical section anytime.
+ */
+void rcu_user_exit(void)
+{
+	unsigned long flags;
 	struct rcu_dynticks *rdtp;
-	long long oldval;
+
+	/*
+	 * Some contexts may involve an exception occuring in an irq,
+	 * leading to that nesting:
+	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
+	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
+	 * helpers are enough to protect RCU uses inside the exception. So
+	 * just return immediately if we detect we are in an IRQ.
+	 */
+	if (in_interrupt())
+		return;
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	oldval = rdtp->dynticks_nesting;
-	WARN_ON_ONCE(oldval < 0);
-	if (oldval & DYNTICK_TASK_NEST_MASK)
-		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
-	else
-		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
-	rcu_idle_exit_common(rdtp, oldval);
+	if (rdtp->in_user) {
+		rdtp->in_user = false;
+		rcu_eqs_exit(true);
+	}
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(rcu_idle_exit);
+
+/**
+ * rcu_user_exit_after_irq - inform RCU that we won't resume to userspace
+ * idle mode after the current non-nesting irq returns.
+ *
+ * This is similar to rcu_user_exit() but in the context of an irq.
+ * This is called when the irq has interrupted a userspace RCU idle mode
+ * context. When the current non-nesting interrupt returns after this call,
+ * the CPU won't restore the RCU idle mode.
+ */
+void rcu_user_exit_after_irq(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	/* Ensure we are interrupting an RCU idle mode. */
+	WARN_ON_ONCE(rdtp->dynticks_nesting & DYNTICK_TASK_NEST_MASK);
+	rdtp->dynticks_nesting += DYNTICK_TASK_EXIT_IDLE;
+	local_irq_restore(flags);
+}
+#endif /* CONFIG_RCU_USER_QS */
 
 /**
  * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
@@ -539,7 +653,7 @@ void rcu_irq_enter(void)
 	if (oldval)
 		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
 	else
-		rcu_idle_exit_common(rdtp, oldval);
+		rcu_eqs_exit_common(rdtp, oldval, true);
 	local_irq_restore(flags);
 }
 
@@ -603,6 +717,21 @@ int rcu_is_cpu_idle(void)
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 
+#ifdef CONFIG_RCU_USER_QS
+void rcu_user_hooks_switch(struct task_struct *prev,
+			   struct task_struct *next)
+{
+	struct rcu_dynticks *rdtp;
+
+	/* Interrupts are disabled in context switch */
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	if (!rdtp->ignore_user_qs) {
+		clear_tsk_thread_flag(prev, TIF_NOHZ);
+		set_tsk_thread_flag(next, TIF_NOHZ);
+	}
+}
+#endif /* #ifdef CONFIG_RCU_USER_QS */
+
 #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
 
 /*
@@ -673,7 +802,7 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
  * Return true if the specified CPU has passed through a quiescent
  * state by virtue of being in or having passed through an dynticks
  * idle state since the last call to dyntick_save_progress_counter()
- * for this same CPU.
+ * for this same CPU, or by virtue of having been offline.
  */
 static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 {
@@ -697,8 +826,26 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
-	/* Go check for the CPU being offline. */
-	return rcu_implicit_offline_qs(rdp);
+	/*
+	 * Check for the CPU being offline, but only if the grace period
+	 * is old enough.  We don't need to worry about the CPU changing
+	 * state: If we see it offline even once, it has been through a
+	 * quiescent state.
+	 *
+	 * The reason for insisting that the grace period be at least
+	 * one jiffy old is that CPUs that are not quite online and that
+	 * have just gone offline can still execute RCU read-side critical
+	 * sections.
+	 */
+	if (ULONG_CMP_GE(rdp->rsp->gp_start + 2, jiffies))
+		return 0;  /* Grace period is not old enough. */
+	barrier();
+	if (cpu_is_offline(rdp->cpu)) {
+		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
+		rdp->offline_fqs++;
+		return 1;
+	}
+	return 0;
 }
 
 static int jiffies_till_stall_check(void)
@@ -755,14 +902,15 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	rcu_for_each_leaf_node(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		ndetected += rcu_print_task_stall(rnp);
+		if (rnp->qsmask != 0) {
+			for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
+				if (rnp->qsmask & (1UL << cpu)) {
+					print_cpu_stall_info(rsp,
+							     rnp->grplo + cpu);
+					ndetected++;
+				}
+		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		if (rnp->qsmask == 0)
-			continue;
-		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
-			if (rnp->qsmask & (1UL << cpu)) {
-				print_cpu_stall_info(rsp, rnp->grplo + cpu);
-				ndetected++;
-			}
 	}
 
 	/*
@@ -782,11 +930,11 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	else if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
-	/* If so configured, complain about tasks blocking the grace period. */
+	/* Complain about tasks blocking the grace period. */
 
 	rcu_print_detail_task_stall(rsp);
 
-	force_quiescent_state(rsp, 0);  /* Kick them all. */
+	force_quiescent_state(rsp);  /* Kick them all. */
 }
 
 static void print_cpu_stall(struct rcu_state *rsp)
@@ -827,7 +975,8 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	j = ACCESS_ONCE(jiffies);
 	js = ACCESS_ONCE(rsp->jiffies_stall);
 	rnp = rdp->mynode;
-	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
+	if (rcu_gp_in_progress(rsp) &&
+	    (ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
@@ -889,12 +1038,8 @@ static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct
 		 */
 		rdp->gpnum = rnp->gpnum;
 		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpustart");
-		if (rnp->qsmask & rdp->grpmask) {
-			rdp->qs_pending = 1;
-			rdp->passed_quiesce = 0;
-		} else {
-			rdp->qs_pending = 0;
-		}
+		rdp->passed_quiesce = 0;
+		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
 		zero_cpu_stall_ticks(rdp);
 	}
 }
@@ -974,10 +1119,13 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 		 * our behalf. Catch up with this state to avoid noting
 		 * spurious new grace periods.  If another grace period
 		 * has started, then rnp->gpnum will have advanced, so
-		 * we will detect this later on.
+		 * we will detect this later on.  Of course, any quiescent
+		 * states we found for the old GP are now invalid.
 		 */
-		if (ULONG_CMP_LT(rdp->gpnum, rdp->completed))
+		if (ULONG_CMP_LT(rdp->gpnum, rdp->completed)) {
 			rdp->gpnum = rdp->completed;
+			rdp->passed_quiesce = 0;
+		}
 
 		/*
 		 * If RCU does not need a quiescent state from this CPU,
@@ -1021,97 +1169,56 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 	/* Prior grace period ended, so advance callbacks for current CPU. */
 	__rcu_process_gp_end(rsp, rnp, rdp);
 
-	/*
-	 * Because this CPU just now started the new grace period, we know
-	 * that all of its callbacks will be covered by this upcoming grace
-	 * period, even the ones that were registered arbitrarily recently.
-	 * Therefore, advance all outstanding callbacks to RCU_WAIT_TAIL.
-	 *
-	 * Other CPUs cannot be sure exactly when the grace period started.
-	 * Therefore, their recently registered callbacks must pass through
-	 * an additional RCU_NEXT_READY stage, so that they will be handled
-	 * by the next RCU grace period.
-	 */
-	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-
 	/* Set state so that this CPU will detect the next quiescent state. */
 	__note_new_gpnum(rsp, rnp, rdp);
 }
 
 /*
- * Start a new RCU grace period if warranted, re-initializing the hierarchy
- * in preparation for detecting the next grace period.  The caller must hold
- * the root node's ->lock, which is released before return.  Hard irqs must
- * be disabled.
- *
- * Note that it is legal for a dying CPU (which is marked as offline) to
- * invoke this function.  This can happen when the dying CPU reports its
- * quiescent state.
+ * Initialize a new grace period.
  */
-static void
-rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
-	__releases(rcu_get_root(rsp)->lock)
+static int rcu_gp_init(struct rcu_state *rsp)
 {
-	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	if (!rcu_scheduler_fully_active ||
-	    !cpu_needs_another_gp(rsp, rdp)) {
-		/*
-		 * Either the scheduler hasn't yet spawned the first
-		 * non-idle task or this CPU does not need another
-		 * grace period.  Either way, don't start a new grace
-		 * period.
-		 */
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		return;
-	}
+	raw_spin_lock_irq(&rnp->lock);
+	rsp->gp_flags = 0; /* Clear all flags: New grace period. */
 
-	if (rsp->fqs_active) {
-		/*
-		 * This CPU needs a grace period, but force_quiescent_state()
-		 * is running.  Tell it to start one on this CPU's behalf.
-		 */
-		rsp->fqs_need_gp = 1;
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		return;
+	if (rcu_gp_in_progress(rsp)) {
+		/* Grace period already in progress, don't start another.  */
+		raw_spin_unlock_irq(&rnp->lock);
+		return 0;
 	}
 
 	/* Advance to a new grace period and initialize state. */
 	rsp->gpnum++;
 	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
-	WARN_ON_ONCE(rsp->fqs_state == RCU_GP_INIT);
-	rsp->fqs_state = RCU_GP_INIT; /* Hold off force_quiescent_state. */
-	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
-	raw_spin_unlock(&rnp->lock);  /* leave irqs disabled. */
+	raw_spin_unlock_irq(&rnp->lock);
 
 	/* Exclude any concurrent CPU-hotplug operations. */
-	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+	get_online_cpus();
 
 	/*
 	 * Set the quiescent-state-needed bits in all the rcu_node
-	 * structures for all currently online CPUs in breadth-first
-	 * order, starting from the root rcu_node structure.  This
-	 * operation relies on the layout of the hierarchy within the
-	 * rsp->node[] array.  Note that other CPUs will access only
-	 * the leaves of the hierarchy, which still indicate that no
+	 * structures for all currently online CPUs in breadth-first order,
+	 * starting from the root rcu_node structure, relying on the layout
+	 * of the tree within the rsp->node[] array.  Note that other CPUs
+	 * will access only the leaves of the hierarchy, thus seeing that no
 	 * grace period is in progress, at least until the corresponding
 	 * leaf node has been initialized.  In addition, we have excluded
 	 * CPU-hotplug operations.
 	 *
-	 * Note that the grace period cannot complete until we finish
-	 * the initialization process, as there will be at least one
-	 * qsmask bit set in the root node until that time, namely the
-	 * one corresponding to this CPU, due to the fact that we have
-	 * irqs disabled.
+	 * The grace period cannot complete until the initialization
+	 * process finishes, because this kthread handles both.
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
-		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
+		raw_spin_lock_irq(&rnp->lock);
+		rdp = this_cpu_ptr(rsp->rda);
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
+		WARN_ON_ONCE(rnp->completed != rsp->completed);
 		rnp->completed = rsp->completed;
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
@@ -1119,37 +1226,54 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
 					    rnp->level, rnp->grplo,
 					    rnp->grphi, rnp->qsmask);
-		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
+		raw_spin_unlock_irq(&rnp->lock);
+#ifdef CONFIG_PROVE_RCU_DELAY
+		if ((random32() % (rcu_num_nodes * 8)) == 0)
+			schedule_timeout_uninterruptible(2);
+#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
+		cond_resched();
 	}
 
-	rnp = rcu_get_root(rsp);
-	raw_spin_lock(&rnp->lock);		/* irqs already disabled. */
-	rsp->fqs_state = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
-	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
-	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
+	put_online_cpus();
+	return 1;
 }
 
 /*
- * Report a full set of quiescent states to the specified rcu_state
- * data structure.  This involves cleaning up after the prior grace
- * period and letting rcu_start_gp() start up the next grace period
- * if one is needed.  Note that the caller must hold rnp->lock, as
- * required by rcu_start_gp(), which will release it.
+ * Do one round of quiescent-state forcing.
  */
-static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
-	__releases(rcu_get_root(rsp)->lock)
+int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 {
-	unsigned long gp_duration;
+	int fqs_state = fqs_state_in;
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 
-	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
+	rsp->n_force_qs++;
+	if (fqs_state == RCU_SAVE_DYNTICK) {
+		/* Collect dyntick-idle snapshots. */
+		force_qs_rnp(rsp, dyntick_save_progress_counter);
+		fqs_state = RCU_FORCE_QS;
+	} else {
+		/* Handle dyntick-idle and offline CPUs. */
+		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
+	}
+	/* Clear flag to prevent immediate re-entry. */
+	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
+		raw_spin_lock_irq(&rnp->lock);
+		rsp->gp_flags &= ~RCU_GP_FLAG_FQS;
+		raw_spin_unlock_irq(&rnp->lock);
+	}
+	return fqs_state;
+}
 
-	/*
-	 * Ensure that all grace-period and pre-grace-period activity
-	 * is seen before the assignment to rsp->completed.
-	 */
-	smp_mb(); /* See above block comment. */
+/*
+ * Clean up after the old grace period.
+ */
+static void rcu_gp_cleanup(struct rcu_state *rsp)
+{
+	unsigned long gp_duration;
+	struct rcu_data *rdp;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	raw_spin_lock_irq(&rnp->lock);
 	gp_duration = jiffies - rsp->gp_start;
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
@@ -1161,35 +1285,149 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	 * they can do to advance the grace period.  It is therefore
 	 * safe for us to drop the lock in order to mark the grace
 	 * period as completed in all of the rcu_node structures.
-	 *
-	 * But if this CPU needs another grace period, it will take
-	 * care of this while initializing the next grace period.
-	 * We use RCU_WAIT_TAIL instead of the usual RCU_DONE_TAIL
-	 * because the callbacks have not yet been advanced: Those
-	 * callbacks are waiting on the grace period that just now
-	 * completed.
 	 */
-	if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
-		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
+	raw_spin_unlock_irq(&rnp->lock);
 
-		/*
-		 * Propagate new ->completed value to rcu_node structures
-		 * so that other CPUs don't have to wait until the start
-		 * of the next grace period to process their callbacks.
-		 */
-		rcu_for_each_node_breadth_first(rsp, rnp) {
-			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
-			rnp->completed = rsp->gpnum;
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
-		}
-		rnp = rcu_get_root(rsp);
-		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+	/*
+	 * Propagate new ->completed value to rcu_node structures so
+	 * that other CPUs don't have to wait until the start of the next
+	 * grace period to process their callbacks.  This also avoids
+	 * some nasty RCU grace-period initialization races by forcing
+	 * the end of the current grace period to be completely recorded in
+	 * all of the rcu_node structures before the beginning of the next
+	 * grace period is recorded in any of the rcu_node structures.
+	 */
+	rcu_for_each_node_breadth_first(rsp, rnp) {
+		raw_spin_lock_irq(&rnp->lock);
+		rnp->completed = rsp->gpnum;
+		raw_spin_unlock_irq(&rnp->lock);
+		cond_resched();
 	}
+	rnp = rcu_get_root(rsp);
+	raw_spin_lock_irq(&rnp->lock);
 
-	rsp->completed = rsp->gpnum;  /* Declare the grace period complete. */
+	rsp->completed = rsp->gpnum; /* Declare grace period done. */
 	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
 	rsp->fqs_state = RCU_GP_IDLE;
-	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
+	rdp = this_cpu_ptr(rsp->rda);
+	if (cpu_needs_another_gp(rsp, rdp))
+		rsp->gp_flags = 1;
+	raw_spin_unlock_irq(&rnp->lock);
+}
+
+/*
+ * Body of kthread that handles grace periods.
+ */
+static int __noreturn rcu_gp_kthread(void *arg)
+{
+	int fqs_state;
+	unsigned long j;
+	int ret;
+	struct rcu_state *rsp = arg;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	for (;;) {
+
+		/* Handle grace-period start. */
+		for (;;) {
+			wait_event_interruptible(rsp->gp_wq,
+						 rsp->gp_flags &
+						 RCU_GP_FLAG_INIT);
+			if ((rsp->gp_flags & RCU_GP_FLAG_INIT) &&
+			    rcu_gp_init(rsp))
+				break;
+			cond_resched();
+			flush_signals(current);
+		}
+
+		/* Handle quiescent-state forcing. */
+		fqs_state = RCU_SAVE_DYNTICK;
+		j = jiffies_till_first_fqs;
+		if (j > HZ) {
+			j = HZ;
+			jiffies_till_first_fqs = HZ;
+		}
+		for (;;) {
+			rsp->jiffies_force_qs = jiffies + j;
+			ret = wait_event_interruptible_timeout(rsp->gp_wq,
+					(rsp->gp_flags & RCU_GP_FLAG_FQS) ||
+					(!ACCESS_ONCE(rnp->qsmask) &&
+					 !rcu_preempt_blocked_readers_cgp(rnp)),
+					j);
+			/* If grace period done, leave loop. */
+			if (!ACCESS_ONCE(rnp->qsmask) &&
+			    !rcu_preempt_blocked_readers_cgp(rnp))
+				break;
+			/* If time for quiescent-state forcing, do it. */
+			if (ret == 0 || (rsp->gp_flags & RCU_GP_FLAG_FQS)) {
+				fqs_state = rcu_gp_fqs(rsp, fqs_state);
+				cond_resched();
+			} else {
+				/* Deal with stray signal. */
+				cond_resched();
+				flush_signals(current);
+			}
+			j = jiffies_till_next_fqs;
+			if (j > HZ) {
+				j = HZ;
+				jiffies_till_next_fqs = HZ;
+			} else if (j < 1) {
+				j = 1;
+				jiffies_till_next_fqs = 1;
+			}
+		}
+
+		/* Handle grace-period end. */
+		rcu_gp_cleanup(rsp);
+	}
+}
+
+/*
+ * Start a new RCU grace period if warranted, re-initializing the hierarchy
+ * in preparation for detecting the next grace period.  The caller must hold
+ * the root node's ->lock, which is released before return.  Hard irqs must
+ * be disabled.
+ *
+ * Note that it is legal for a dying CPU (which is marked as offline) to
+ * invoke this function.  This can happen when the dying CPU reports its
+ * quiescent state.
+ */
+static void
+rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
+	__releases(rcu_get_root(rsp)->lock)
+{
+	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	if (!rsp->gp_kthread ||
+	    !cpu_needs_another_gp(rsp, rdp)) {
+		/*
+		 * Either we have not yet spawned the grace-period
+		 * task or this CPU does not need another grace period.
+		 * Either way, don't start a new grace period.
+		 */
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+
+	rsp->gp_flags = RCU_GP_FLAG_INIT;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	wake_up(&rsp->gp_wq);
+}
+
+/*
+ * Report a full set of quiescent states to the specified rcu_state
+ * data structure.  This involves cleaning up after the prior grace
+ * period and letting rcu_start_gp() start up the next grace period
+ * if one is needed.  Note that the caller must hold rnp->lock, as
+ * required by rcu_start_gp(), which will release it.
+ */
+static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
+	__releases(rcu_get_root(rsp)->lock)
+{
+	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
+	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
+	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
 }
 
 /*
@@ -1258,7 +1496,7 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
  * based on quiescent states detected in an earlier grace period!
  */
 static void
-rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastgp)
+rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -1266,7 +1504,8 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long las
 
 	rnp = rdp->mynode;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	if (lastgp != rnp->gpnum || rnp->completed == rnp->gpnum) {
+	if (rdp->passed_quiesce == 0 || rdp->gpnum != rnp->gpnum ||
+	    rnp->completed == rnp->gpnum) {
 
 		/*
 		 * The grace period in which this quiescent state was
@@ -1325,7 +1564,7 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 	 * Tell RCU we are done (but rcu_report_qs_rdp() will be the
 	 * judge of that).
 	 */
-	rcu_report_qs_rdp(rdp->cpu, rsp, rdp, rdp->passed_quiesce_gpnum);
+	rcu_report_qs_rdp(rdp->cpu, rsp, rdp);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1390,17 +1629,6 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 	int i;
 	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
 
-	/*
-	 * If there is an rcu_barrier() operation in progress, then
-	 * only the task doing that operation is permitted to adopt
-	 * callbacks.  To do otherwise breaks rcu_barrier() and friends
-	 * by causing them to fail to wait for the callbacks in the
-	 * orphanage.
-	 */
-	if (rsp->rcu_barrier_in_progress &&
-	    rsp->rcu_barrier_in_progress != current)
-		return;
-
 	/* Do the accounting first. */
 	rdp->qlen_lazy += rsp->qlen_lazy;
 	rdp->qlen += rsp->qlen;
@@ -1455,9 +1683,8 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
  * The CPU has been completely removed, and some other CPU is reporting
  * this fact from process context.  Do the remainder of the cleanup,
  * including orphaning the outgoing CPU's RCU callbacks, and also
- * adopting them, if there is no _rcu_barrier() instance running.
- * There can only be one CPU hotplug operation at a time, so no other
- * CPU can be attempting to update rcu_cpu_kthread_task.
+ * adopting them.  There can only be one CPU hotplug operation at a time,
+ * so no other CPU can be attempting to update rcu_cpu_kthread_task.
  */
 static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
@@ -1468,8 +1695,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rdp & rnp. */
 
 	/* Adjust any no-longer-needed kthreads. */
-	rcu_stop_cpu_kthread(cpu);
-	rcu_node_kthread_setaffinity(rnp, -1);
+	rcu_boost_kthread_setaffinity(rnp, -1);
 
 	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
 
@@ -1515,14 +1741,13 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	WARN_ONCE(rdp->qlen != 0 || rdp->nxtlist != NULL,
 		  "rcu_cleanup_dead_cpu: Callbacks on offline CPU %d: qlen=%lu, nxtlist=%p\n",
 		  cpu, rdp->qlen, rdp->nxtlist);
+	init_callback_list(rdp);
+	/* Disallow further callbacks on this CPU. */
+	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
 
-static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
-{
-}
-
 static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 {
 }
@@ -1687,6 +1912,7 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 	struct rcu_node *rnp;
 
 	rcu_for_each_leaf_node(rsp, rnp) {
+		cond_resched();
 		mask = 0;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		if (!rcu_gp_in_progress(rsp)) {
@@ -1723,72 +1949,39 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
  * Force quiescent states on reluctant CPUs, and also detect which
  * CPUs are in dyntick-idle mode.
  */
-static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
+static void force_quiescent_state(struct rcu_state *rsp)
 {
 	unsigned long flags;
-	struct rcu_node *rnp = rcu_get_root(rsp);
-
-	trace_rcu_utilization("Start fqs");
-	if (!rcu_gp_in_progress(rsp)) {
-		trace_rcu_utilization("End fqs");
-		return;  /* No grace period in progress, nothing to force. */
-	}
-	if (!raw_spin_trylock_irqsave(&rsp->fqslock, flags)) {
-		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
-		trace_rcu_utilization("End fqs");
-		return;	/* Someone else is already on the job. */
-	}
-	if (relaxed && ULONG_CMP_GE(rsp->jiffies_force_qs, jiffies))
-		goto unlock_fqs_ret; /* no emergency and done recently. */
-	rsp->n_force_qs++;
-	raw_spin_lock(&rnp->lock);  /* irqs already disabled */
-	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
-	if(!rcu_gp_in_progress(rsp)) {
-		rsp->n_force_qs_ngp++;
-		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
-	}
-	rsp->fqs_active = 1;
-	switch (rsp->fqs_state) {
-	case RCU_GP_IDLE:
-	case RCU_GP_INIT:
-
-		break; /* grace period idle or initializing, ignore. */
-
-	case RCU_SAVE_DYNTICK:
-
-		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
-
-		/* Record dyntick-idle state. */
-		force_qs_rnp(rsp, dyntick_save_progress_counter);
-		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
-		if (rcu_gp_in_progress(rsp))
-			rsp->fqs_state = RCU_FORCE_QS;
-		break;
-
-	case RCU_FORCE_QS:
-
-		/* Check dyntick-idle state, send IPI to laggarts. */
-		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
-
-		/* Leave state in case more forcing is required. */
-
-		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
-		break;
+	bool ret;
+	struct rcu_node *rnp;
+	struct rcu_node *rnp_old = NULL;
+
+	/* Funnel through hierarchy to reduce memory contention. */
+	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
+	for (; rnp != NULL; rnp = rnp->parent) {
+		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
+		      !raw_spin_trylock(&rnp->fqslock);
+		if (rnp_old != NULL)
+			raw_spin_unlock(&rnp_old->fqslock);
+		if (ret) {
+			rsp->n_force_qs_lh++;
+			return;
+		}
+		rnp_old = rnp;
 	}
-	rsp->fqs_active = 0;
-	if (rsp->fqs_need_gp) {
-		raw_spin_unlock(&rsp->fqslock); /* irqs remain disabled */
-		rsp->fqs_need_gp = 0;
-		rcu_start_gp(rsp, flags); /* releases rnp->lock */
-		trace_rcu_utilization("End fqs");
-		return;
+	/* rnp_old == rcu_get_root(rsp), rnp == NULL. */
+
+	/* Reached the root of the rcu_node tree, acquire lock. */
+	raw_spin_lock_irqsave(&rnp_old->lock, flags);
+	raw_spin_unlock(&rnp_old->fqslock);
+	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
+		rsp->n_force_qs_lh++;
+		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
+		return;  /* Someone beat us to it. */
 	}
-	raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
-unlock_fqs_ret:
-	raw_spin_unlock_irqrestore(&rsp->fqslock, flags);
-	trace_rcu_utilization("End fqs");
+	rsp->gp_flags |= RCU_GP_FLAG_FQS;
+	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
+	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
 }
 
 /*
@@ -1805,13 +1998,6 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
 	/*
-	 * If an RCU GP has gone long enough, go check for dyntick
-	 * idle CPUs and, if needed, send resched IPIs.
-	 */
-	if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
-		force_quiescent_state(rsp, 1);
-
-	/*
 	 * Advance callbacks in response to end of earlier grace
 	 * period that some other CPU ended.
 	 */
@@ -1838,6 +2024,8 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	struct rcu_state *rsp;
 
+	if (cpu_is_offline(smp_processor_id()))
+		return;
 	trace_rcu_utilization("Start RCU core");
 	for_each_rcu_flavor(rsp)
 		__rcu_process_callbacks(rsp);
@@ -1909,12 +2097,11 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 			rdp->blimit = LONG_MAX;
 			if (rsp->n_force_qs == rdp->n_force_qs_snap &&
 			    *rdp->nxttail[RCU_DONE_TAIL] != head)
-				force_quiescent_state(rsp, 0);
+				force_quiescent_state(rsp);
 			rdp->n_force_qs_snap = rsp->n_force_qs;
 			rdp->qlen_last_fqs_check = rdp->qlen;
 		}
-	} else if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
-		force_quiescent_state(rsp, 1);
+	}
 }
 
 static void
@@ -1929,8 +2116,6 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	head->func = func;
 	head->next = NULL;
 
-	smp_mb(); /* Ensure RCU update seen before callback registry. */
-
 	/*
 	 * Opportunistically note grace-period endings and beginnings.
 	 * Note that we might see a beginning right after we see an
@@ -1941,6 +2126,12 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp = this_cpu_ptr(rsp->rda);
 
 	/* Add the callback to our list. */
+	if (unlikely(rdp->nxttail[RCU_NEXT_TAIL] == NULL)) {
+		/* _call_rcu() is illegal on offline CPU; leak the callback. */
+		WARN_ON_ONCE(1);
+		local_irq_restore(flags);
+		return;
+	}
 	ACCESS_ONCE(rdp->qlen)++;
 	if (lazy)
 		rdp->qlen_lazy++;
@@ -2195,17 +2386,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	if (rcu_scheduler_fully_active &&
 	    rdp->qs_pending && !rdp->passed_quiesce) {
-
-		/*
-		 * If force_quiescent_state() coming soon and this CPU
-		 * needs a quiescent state, and this is either RCU-sched
-		 * or RCU-bh, force a local reschedule.
-		 */
 		rdp->n_rp_qs_pending++;
-		if (!rdp->preemptible &&
-		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
-				 jiffies))
-			set_need_resched();
 	} else if (rdp->qs_pending && rdp->passed_quiesce) {
 		rdp->n_rp_report_qs++;
 		return 1;
@@ -2235,13 +2416,6 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 		return 1;
 	}
 
-	/* Has an RCU GP gone long enough to send resched IPIs &c? */
-	if (rcu_gp_in_progress(rsp) &&
-	    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies)) {
-		rdp->n_rp_need_fqs++;
-		return 1;
-	}
-
 	/* nothing to do */
 	rdp->n_rp_need_nothing++;
 	return 0;
@@ -2326,13 +2500,10 @@ static void rcu_barrier_func(void *type)
 static void _rcu_barrier(struct rcu_state *rsp)
 {
 	int cpu;
-	unsigned long flags;
 	struct rcu_data *rdp;
-	struct rcu_data rd;
 	unsigned long snap = ACCESS_ONCE(rsp->n_barrier_done);
 	unsigned long snap_done;
 
-	init_rcu_head_on_stack(&rd.barrier_head);
 	_rcu_barrier_trace(rsp, "Begin", -1, snap);
 
 	/* Take mutex to serialize concurrent rcu_barrier() requests. */
@@ -2372,70 +2543,30 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	/*
 	 * Initialize the count to one rather than to zero in order to
 	 * avoid a too-soon return to zero in case of a short grace period
-	 * (or preemption of this task).  Also flag this task as doing
-	 * an rcu_barrier().  This will prevent anyone else from adopting
-	 * orphaned callbacks, which could cause otherwise failure if a
-	 * CPU went offline and quickly came back online.  To see this,
-	 * consider the following sequence of events:
-	 *
-	 * 1.	We cause CPU 0 to post an rcu_barrier_callback() callback.
-	 * 2.	CPU 1 goes offline, orphaning its callbacks.
-	 * 3.	CPU 0 adopts CPU 1's orphaned callbacks.
-	 * 4.	CPU 1 comes back online.
-	 * 5.	We cause CPU 1 to post an rcu_barrier_callback() callback.
-	 * 6.	Both rcu_barrier_callback() callbacks are invoked, awakening
-	 *	us -- but before CPU 1's orphaned callbacks are invoked!!!
+	 * (or preemption of this task).  Exclude CPU-hotplug operations
+	 * to ensure that no offline CPU has callbacks queued.
 	 */
 	init_completion(&rsp->barrier_completion);
 	atomic_set(&rsp->barrier_cpu_count, 1);
-	raw_spin_lock_irqsave(&rsp->onofflock, flags);
-	rsp->rcu_barrier_in_progress = current;
-	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
+	get_online_cpus();
 
 	/*
-	 * Force every CPU with callbacks to register a new callback
-	 * that will tell us when all the preceding callbacks have
-	 * been invoked.  If an offline CPU has callbacks, wait for
-	 * it to either come back online or to finish orphaning those
-	 * callbacks.
+	 * Force each CPU with callbacks to register a new callback.
+	 * When that callback is invoked, we will know that all of the
+	 * corresponding CPU's preceding callbacks have been invoked.
 	 */
-	for_each_possible_cpu(cpu) {
-		preempt_disable();
+	for_each_online_cpu(cpu) {
 		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (cpu_is_offline(cpu)) {
-			_rcu_barrier_trace(rsp, "Offline", cpu,
-					   rsp->n_barrier_done);
-			preempt_enable();
-			while (cpu_is_offline(cpu) && ACCESS_ONCE(rdp->qlen))
-				schedule_timeout_interruptible(1);
-		} else if (ACCESS_ONCE(rdp->qlen)) {
+		if (ACCESS_ONCE(rdp->qlen)) {
 			_rcu_barrier_trace(rsp, "OnlineQ", cpu,
 					   rsp->n_barrier_done);
 			smp_call_function_single(cpu, rcu_barrier_func, rsp, 1);
-			preempt_enable();
 		} else {
 			_rcu_barrier_trace(rsp, "OnlineNQ", cpu,
 					   rsp->n_barrier_done);
-			preempt_enable();
 		}
 	}
-
-	/*
-	 * Now that all online CPUs have rcu_barrier_callback() callbacks
-	 * posted, we can adopt all of the orphaned callbacks and place
-	 * an rcu_barrier_callback() callback after them.  When that is done,
-	 * we are guaranteed to have an rcu_barrier_callback() callback
-	 * following every callback that could possibly have been
-	 * registered before _rcu_barrier() was called.
-	 */
-	raw_spin_lock_irqsave(&rsp->onofflock, flags);
-	rcu_adopt_orphan_cbs(rsp);
-	rsp->rcu_barrier_in_progress = NULL;
-	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
-	atomic_inc(&rsp->barrier_cpu_count);
-	smp_mb__after_atomic_inc(); /* Ensure atomic_inc() before callback. */
-	rd.rsp = rsp;
-	rsp->call(&rd.barrier_head, rcu_barrier_callback);
+	put_online_cpus();
 
 	/*
 	 * Now that we have an rcu_barrier_callback() callback on each
@@ -2456,8 +2587,6 @@ static void _rcu_barrier(struct rcu_state *rsp)
 
 	/* Other rcu_barrier() invocations can now safely proceed. */
 	mutex_unlock(&rsp->barrier_mutex);
-
-	destroy_rcu_head_on_stack(&rd.barrier_head);
 }
 
 /**
@@ -2497,6 +2626,9 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
+#ifdef CONFIG_RCU_USER_QS
+	WARN_ON_ONCE(rdp->dynticks->in_user);
+#endif
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -2523,6 +2655,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
+	init_callback_list(rdp);  /* Re-enable callbacks on this CPU. */
 	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	atomic_set(&rdp->dynticks->dynticks,
 		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
@@ -2555,7 +2688,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 			rdp->completed = rnp->completed;
 			rdp->passed_quiesce = 0;
 			rdp->qs_pending = 0;
-			rdp->passed_quiesce_gpnum = rnp->gpnum - 1;
 			trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuonl");
 		}
 		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
@@ -2594,12 +2726,10 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		break;
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
-		rcu_node_kthread_setaffinity(rnp, -1);
-		rcu_cpu_kthread_setrt(cpu, 1);
+		rcu_boost_kthread_setaffinity(rnp, -1);
 		break;
 	case CPU_DOWN_PREPARE:
-		rcu_node_kthread_setaffinity(rnp, cpu);
-		rcu_cpu_kthread_setrt(cpu, 0);
+		rcu_boost_kthread_setaffinity(rnp, cpu);
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
@@ -2627,6 +2757,28 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 }
 
 /*
+ * Spawn the kthread that handles this RCU flavor's grace periods.
+ */
+static int __init rcu_spawn_gp_kthread(void)
+{
+	unsigned long flags;
+	struct rcu_node *rnp;
+	struct rcu_state *rsp;
+	struct task_struct *t;
+
+	for_each_rcu_flavor(rsp) {
+		t = kthread_run(rcu_gp_kthread, rsp, rsp->name);
+		BUG_ON(IS_ERR(t));
+		rnp = rcu_get_root(rsp);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rsp->gp_kthread = t;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+	return 0;
+}
+early_initcall(rcu_spawn_gp_kthread);
+
+/*
  * This function is invoked towards the end of the scheduler's initialization
  * process.  Before this is called, the idle task might contain
  * RCU read-side critical sections (during which time, this idle
@@ -2661,7 +2813,7 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 	int cprv;
 	int i;
 
-	cprv = NR_CPUS;
+	cprv = nr_cpu_ids;
 	for (i = rcu_num_lvls - 1; i >= 0; i--) {
 		ccur = rsp->levelcnt[i];
 		rsp->levelspread[i] = (cprv + ccur - 1) / ccur;
@@ -2676,10 +2828,14 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 static void __init rcu_init_one(struct rcu_state *rsp,
 		struct rcu_data __percpu *rda)
 {
-	static char *buf[] = { "rcu_node_level_0",
-			       "rcu_node_level_1",
-			       "rcu_node_level_2",
-			       "rcu_node_level_3" };  /* Match MAX_RCU_LVLS */
+	static char *buf[] = { "rcu_node_0",
+			       "rcu_node_1",
+			       "rcu_node_2",
+			       "rcu_node_3" };  /* Match MAX_RCU_LVLS */
+	static char *fqs[] = { "rcu_node_fqs_0",
+			       "rcu_node_fqs_1",
+			       "rcu_node_fqs_2",
+			       "rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
 	int cpustride = 1;
 	int i;
 	int j;
@@ -2704,7 +2860,11 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 			raw_spin_lock_init(&rnp->lock);
 			lockdep_set_class_and_name(&rnp->lock,
 						   &rcu_node_class[i], buf[i]);
-			rnp->gpnum = 0;
+			raw_spin_lock_init(&rnp->fqslock);
+			lockdep_set_class_and_name(&rnp->fqslock,
+						   &rcu_fqs_class[i], fqs[i]);
+			rnp->gpnum = rsp->gpnum;
+			rnp->completed = rsp->completed;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
 			rnp->grplo = j * cpustride;
@@ -2727,6 +2887,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 	}
 
 	rsp->rda = rda;
+	init_waitqueue_head(&rsp->gp_wq);
 	rnp = rsp->level[rcu_num_lvls - 1];
 	for_each_possible_cpu(i) {
 		while (i > rnp->grphi)
@@ -2750,7 +2911,8 @@ static void __init rcu_init_geometry(void)
 	int rcu_capacity[MAX_RCU_LVLS + 1];
 
 	/* If the compile-time values are accurate, just leave. */
-	if (rcu_fanout_leaf == CONFIG_RCU_FANOUT_LEAF)
+	if (rcu_fanout_leaf == CONFIG_RCU_FANOUT_LEAF &&
+	    nr_cpu_ids == NR_CPUS)
 		return;
 
 	/*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4d29169..5faf05d 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -102,6 +102,10 @@ struct rcu_dynticks {
 				    /* idle-period nonlazy_posted snapshot. */
 	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
+#ifdef CONFIG_RCU_USER_QS
+	bool ignore_user_qs;	    /* Treat userspace as extended QS or not */
+	bool in_user;		    /* Is the CPU in userland from RCU POV? */
+#endif
 };
 
 /* RCU's kthread states for tracing. */
@@ -196,12 +200,7 @@ struct rcu_node {
 				/* Refused to boost: not sure why, though. */
 				/*  This can happen due to race conditions. */
 #endif /* #ifdef CONFIG_RCU_BOOST */
-	struct task_struct *node_kthread_task;
-				/* kthread that takes care of this rcu_node */
-				/*  structure, for example, awakening the */
-				/*  per-CPU kthreads as needed. */
-	unsigned int node_kthread_status;
-				/* State of node_kthread_task for tracing. */
+	raw_spinlock_t fqslock ____cacheline_internodealigned_in_smp;
 } ____cacheline_internodealigned_in_smp;
 
 /*
@@ -245,8 +244,6 @@ struct rcu_data {
 					/*  in order to detect GP end. */
 	unsigned long	gpnum;		/* Highest gp number that this CPU */
 					/*  is aware of having started. */
-	unsigned long	passed_quiesce_gpnum;
-					/* gpnum at time of quiescent state. */
 	bool		passed_quiesce;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
@@ -312,11 +309,13 @@ struct rcu_data {
 	unsigned long n_rp_cpu_needs_gp;
 	unsigned long n_rp_gp_completed;
 	unsigned long n_rp_gp_started;
-	unsigned long n_rp_need_fqs;
 	unsigned long n_rp_need_nothing;
 
-	/* 6) _rcu_barrier() callback. */
+	/* 6) _rcu_barrier() and OOM callbacks. */
 	struct rcu_head barrier_head;
+#ifdef CONFIG_RCU_FAST_NO_HZ
+	struct rcu_head oom_head;
+#endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
 
 	int cpu;
 	struct rcu_state *rsp;
@@ -375,20 +374,17 @@ struct rcu_state {
 
 	u8	fqs_state ____cacheline_internodealigned_in_smp;
 						/* Force QS state. */
-	u8	fqs_active;			/* force_quiescent_state() */
-						/*  is running. */
-	u8	fqs_need_gp;			/* A CPU was prevented from */
-						/*  starting a new grace */
-						/*  period because */
-						/*  force_quiescent_state() */
-						/*  was running. */
 	u8	boost;				/* Subject to priority boost. */
 	unsigned long gpnum;			/* Current gp number. */
 	unsigned long completed;		/* # of last completed gp. */
+	struct task_struct *gp_kthread;		/* Task for grace periods. */
+	wait_queue_head_t gp_wq;		/* Where GP task waits. */
+	int gp_flags;				/* Commands for GP task. */
 
 	/* End of fields guarded by root rcu_node's lock. */
 
-	raw_spinlock_t onofflock;		/* exclude on/offline and */
+	raw_spinlock_t onofflock ____cacheline_internodealigned_in_smp;
+						/* exclude on/offline and */
 						/*  starting new GP. */
 	struct rcu_head *orphan_nxtlist;	/* Orphaned callbacks that */
 						/*  need a grace period. */
@@ -398,16 +394,11 @@ struct rcu_state {
 	struct rcu_head **orphan_donetail;	/* Tail of above. */
 	long qlen_lazy;				/* Number of lazy callbacks. */
 	long qlen;				/* Total number of callbacks. */
-	struct task_struct *rcu_barrier_in_progress;
-						/* Task doing rcu_barrier(), */
-						/*  or NULL if no barrier. */
 	struct mutex barrier_mutex;		/* Guards barrier fields. */
 	atomic_t barrier_cpu_count;		/* # CPUs waiting on. */
 	struct completion barrier_completion;	/* Wake at barrier end. */
 	unsigned long n_barrier_done;		/* ++ at start and end of */
 						/*  _rcu_barrier(). */
-	raw_spinlock_t fqslock;			/* Only one task forcing */
-						/*  quiescent states. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
@@ -426,6 +417,10 @@ struct rcu_state {
 	struct list_head flavors;		/* List of RCU flavors. */
 };
 
+/* Values for rcu_state structure's gp_flags field. */
+#define RCU_GP_FLAG_INIT 0x1	/* Need grace-period initialization. */
+#define RCU_GP_FLAG_FQS  0x2	/* Need grace-period quiescent-state forcing. */
+
 extern struct list_head rcu_struct_flavors;
 #define for_each_rcu_flavor(rsp) \
 	list_for_each_entry((rsp), &rcu_struct_flavors, flavors)
@@ -468,7 +463,6 @@ static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
-static void rcu_stop_cpu_kthread(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static int rcu_print_task_stall(struct rcu_node *rnp);
@@ -491,15 +485,9 @@ static void invoke_rcu_callbacks_kthread(void);
 static bool rcu_is_callbacks_kthread(void);
 #ifdef CONFIG_RCU_BOOST
 static void rcu_preempt_do_callbacks(void);
-static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
-					  cpumask_var_t cm);
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
-						 struct rcu_node *rnp,
-						 int rnp_index);
-static void invoke_rcu_node_kthread(struct rcu_node *rnp);
-static void rcu_yield(void (*f)(unsigned long), unsigned long arg);
+						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
-static void rcu_cpu_kthread_setrt(int cpu, int to_rt);
 static void __cpuinit rcu_prepare_kthreads(int cpu);
 static void rcu_prepare_for_idle_init(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 7f3244c..f921154 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -25,6 +25,8 @@
  */
 
 #include <linux/delay.h>
+#include <linux/oom.h>
+#include <linux/smpboot.h>
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -118,7 +120,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
  */
 void rcu_force_quiescent_state(void)
 {
-	force_quiescent_state(&rcu_preempt_state, 0);
+	force_quiescent_state(&rcu_preempt_state);
 }
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
@@ -136,8 +138,6 @@ static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
 
-	rdp->passed_quiesce_gpnum = rdp->gpnum;
-	barrier();
 	if (rdp->passed_quiesce == 0)
 		trace_rcu_grace_period("rcu_preempt", rdp->gpnum, "cpuqs");
 	rdp->passed_quiesce = 1;
@@ -422,9 +422,11 @@ static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
 	unsigned long flags;
 	struct task_struct *t;
 
-	if (!rcu_preempt_blocked_readers_cgp(rnp))
-		return;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	if (!rcu_preempt_blocked_readers_cgp(rnp)) {
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
 	t = list_entry(rnp->gp_tasks,
 		       struct task_struct, rcu_node_entry);
 	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
@@ -584,17 +586,23 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 		raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
 	}
 
+	rnp->gp_tasks = NULL;
+	rnp->exp_tasks = NULL;
 #ifdef CONFIG_RCU_BOOST
-	/* In case root is being boosted and leaf is not. */
+	rnp->boost_tasks = NULL;
+	/*
+	 * In case root is being boosted and leaf was not.  Make sure
+	 * that we boost the tasks blocking the current grace period
+	 * in this case.
+	 */
 	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
 	if (rnp_root->boost_tasks != NULL &&
-	    rnp_root->boost_tasks != rnp_root->gp_tasks)
+	    rnp_root->boost_tasks != rnp_root->gp_tasks &&
+	    rnp_root->boost_tasks != rnp_root->exp_tasks)
 		rnp_root->boost_tasks = rnp_root->gp_tasks;
 	raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
-	rnp->gp_tasks = NULL;
-	rnp->exp_tasks = NULL;
 	return retval;
 }
 
@@ -676,7 +684,7 @@ void synchronize_rcu(void)
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
 static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
-static long sync_rcu_preempt_exp_count;
+static unsigned long sync_rcu_preempt_exp_count;
 static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
 
 /*
@@ -791,7 +799,7 @@ void synchronize_rcu_expedited(void)
 	unsigned long flags;
 	struct rcu_node *rnp;
 	struct rcu_state *rsp = &rcu_preempt_state;
-	long snap;
+	unsigned long snap;
 	int trycount = 0;
 
 	smp_mb(); /* Caller's modifications seen first by other CPUs. */
@@ -799,33 +807,47 @@ void synchronize_rcu_expedited(void)
 	smp_mb(); /* Above access cannot bleed into critical section. */
 
 	/*
+	 * Block CPU-hotplug operations.  This means that any CPU-hotplug
+	 * operation that finds an rcu_node structure with tasks in the
+	 * process of being boosted will know that all tasks blocking
+	 * this expedited grace period will already be in the process of
+	 * being boosted.  This simplifies the process of moving tasks
+	 * from leaf to root rcu_node structures.
+	 */
+	get_online_cpus();
+
+	/*
 	 * Acquire lock, falling back to synchronize_rcu() if too many
 	 * lock-acquisition failures.  Of course, if someone does the
 	 * expedited grace period for us, just leave.
 	 */
 	while (!mutex_trylock(&sync_rcu_preempt_exp_mutex)) {
+		if (ULONG_CMP_LT(snap,
+		    ACCESS_ONCE(sync_rcu_preempt_exp_count))) {
+			put_online_cpus();
+			goto mb_ret; /* Others did our work for us. */
+		}
 		if (trycount++ < 10) {
 			udelay(trycount * num_online_cpus());
 		} else {
+			put_online_cpus();
 			synchronize_rcu();
 			return;
 		}
-		if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
-			goto mb_ret; /* Others did our work for us. */
 	}
-	if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
+	if (ULONG_CMP_LT(snap, ACCESS_ONCE(sync_rcu_preempt_exp_count))) {
+		put_online_cpus();
 		goto unlock_mb_ret; /* Others did our work for us. */
+	}
 
 	/* force all RCU readers onto ->blkd_tasks lists. */
 	synchronize_sched_expedited();
 
-	raw_spin_lock_irqsave(&rsp->onofflock, flags);
-
 	/* Initialize ->expmask for all non-leaf rcu_node structures. */
 	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
-		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rnp->expmask = rnp->qsmaskinit;
-		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
 	/* Snapshot current state of ->blkd_tasks lists. */
@@ -834,7 +856,7 @@ void synchronize_rcu_expedited(void)
 	if (NUM_RCU_NODES > 1)
 		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
 
-	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
+	put_online_cpus();
 
 	/* Wait for snapshotted ->blkd_tasks lists to drain. */
 	rnp = rcu_get_root(rsp);
@@ -1069,6 +1091,16 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
+static void rcu_wake_cond(struct task_struct *t, int status)
+{
+	/*
+	 * If the thread is yielding, only wake it when this
+	 * is invoked from idle
+	 */
+	if (status != RCU_KTHREAD_YIELDING || is_idle_task(current))
+		wake_up_process(t);
+}
+
 /*
  * Carry out RCU priority boosting on the task indicated by ->exp_tasks
  * or ->boost_tasks, advancing the pointer to the next task in the
@@ -1141,17 +1173,6 @@ static int rcu_boost(struct rcu_node *rnp)
 }
 
 /*
- * Timer handler to initiate waking up of boost kthreads that
- * have yielded the CPU due to excessive numbers of tasks to
- * boost.  We wake up the per-rcu_node kthread, which in turn
- * will wake up the booster kthread.
- */
-static void rcu_boost_kthread_timer(unsigned long arg)
-{
-	invoke_rcu_node_kthread((struct rcu_node *)arg);
-}
-
-/*
  * Priority-boosting kthread.  One per leaf rcu_node and one for the
  * root rcu_node.
  */
@@ -1174,8 +1195,9 @@ static int rcu_boost_kthread(void *arg)
 		else
 			spincnt = 0;
 		if (spincnt > 10) {
+			rnp->boost_kthread_status = RCU_KTHREAD_YIELDING;
 			trace_rcu_utilization("End boost kthread@rcu_yield");
-			rcu_yield(rcu_boost_kthread_timer, (unsigned long)rnp);
+			schedule_timeout_interruptible(2);
 			trace_rcu_utilization("Start boost kthread@rcu_yield");
 			spincnt = 0;
 		}
@@ -1191,9 +1213,9 @@ static int rcu_boost_kthread(void *arg)
  * kthread to start boosting them.  If there is an expedited grace
  * period in progress, it is always time to boost.
  *
- * The caller must hold rnp->lock, which this function releases,
- * but irqs remain disabled.  The ->boost_kthread_task is immortal,
- * so we don't need to worry about it going away.
+ * The caller must hold rnp->lock, which this function releases.
+ * The ->boost_kthread_task is immortal, so we don't need to worry
+ * about it going away.
  */
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 {
@@ -1213,8 +1235,8 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 			rnp->boost_tasks = rnp->gp_tasks;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		t = rnp->boost_kthread_task;
-		if (t != NULL)
-			wake_up_process(t);
+		if (t)
+			rcu_wake_cond(t, rnp->boost_kthread_status);
 	} else {
 		rcu_initiate_boost_trace(rnp);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1231,8 +1253,10 @@ static void invoke_rcu_callbacks_kthread(void)
 	local_irq_save(flags);
 	__this_cpu_write(rcu_cpu_has_work, 1);
 	if (__this_cpu_read(rcu_cpu_kthread_task) != NULL &&
-	    current != __this_cpu_read(rcu_cpu_kthread_task))
-		wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
+	    current != __this_cpu_read(rcu_cpu_kthread_task)) {
+		rcu_wake_cond(__this_cpu_read(rcu_cpu_kthread_task),
+			      __this_cpu_read(rcu_cpu_kthread_status));
+	}
 	local_irq_restore(flags);
 }
 
@@ -1245,21 +1269,6 @@ static bool rcu_is_callbacks_kthread(void)
 	return __get_cpu_var(rcu_cpu_kthread_task) == current;
 }
 
-/*
- * Set the affinity of the boost kthread.  The CPU-hotplug locks are
- * held, so no one should be messing with the existence of the boost
- * kthread.
- */
-static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
-					  cpumask_var_t cm)
-{
-	struct task_struct *t;
-
-	t = rnp->boost_kthread_task;
-	if (t != NULL)
-		set_cpus_allowed_ptr(rnp->boost_kthread_task, cm);
-}
-
 #define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
 
 /*
@@ -1276,15 +1285,19 @@ static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
  * Returns zero if all is well, a negated errno otherwise.
  */
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
-						 struct rcu_node *rnp,
-						 int rnp_index)
+						 struct rcu_node *rnp)
 {
+	int rnp_index = rnp - &rsp->node[0];
 	unsigned long flags;
 	struct sched_param sp;
 	struct task_struct *t;
 
 	if (&rcu_preempt_state != rsp)
 		return 0;
+
+	if (!rcu_scheduler_fully_active || rnp->qsmaskinit == 0)
+		return 0;
+
 	rsp->boost = 1;
 	if (rnp->boost_kthread_task != NULL)
 		return 0;
@@ -1301,25 +1314,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-/*
- * Stop the RCU's per-CPU kthread when its CPU goes offline,.
- */
-static void rcu_stop_cpu_kthread(int cpu)
-{
-	struct task_struct *t;
-
-	/* Stop the CPU's kthread. */
-	t = per_cpu(rcu_cpu_kthread_task, cpu);
-	if (t != NULL) {
-		per_cpu(rcu_cpu_kthread_task, cpu) = NULL;
-		kthread_stop(t);
-	}
-}
-
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
 static void rcu_kthread_do_work(void)
 {
 	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
@@ -1327,112 +1321,22 @@ static void rcu_kthread_do_work(void)
 	rcu_preempt_do_callbacks();
 }
 
-/*
- * Wake up the specified per-rcu_node-structure kthread.
- * Because the per-rcu_node kthreads are immortal, we don't need
- * to do anything to keep them alive.
- */
-static void invoke_rcu_node_kthread(struct rcu_node *rnp)
-{
-	struct task_struct *t;
-
-	t = rnp->node_kthread_task;
-	if (t != NULL)
-		wake_up_process(t);
-}
-
-/*
- * Set the specified CPU's kthread to run RT or not, as specified by
- * the to_rt argument.  The CPU-hotplug locks are held, so the task
- * is not going away.
- */
-static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
+static void rcu_cpu_kthread_setup(unsigned int cpu)
 {
-	int policy;
 	struct sched_param sp;
-	struct task_struct *t;
 
-	t = per_cpu(rcu_cpu_kthread_task, cpu);
-	if (t == NULL)
-		return;
-	if (to_rt) {
-		policy = SCHED_FIFO;
-		sp.sched_priority = RCU_KTHREAD_PRIO;
-	} else {
-		policy = SCHED_NORMAL;
-		sp.sched_priority = 0;
-	}
-	sched_setscheduler_nocheck(t, policy, &sp);
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
 }
 
-/*
- * Timer handler to initiate the waking up of per-CPU kthreads that
- * have yielded the CPU due to excess numbers of RCU callbacks.
- * We wake up the per-rcu_node kthread, which in turn will wake up
- * the booster kthread.
- */
-static void rcu_cpu_kthread_timer(unsigned long arg)
+static void rcu_cpu_kthread_park(unsigned int cpu)
 {
-	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
-	struct rcu_node *rnp = rdp->mynode;
-
-	atomic_or(rdp->grpmask, &rnp->wakemask);
-	invoke_rcu_node_kthread(rnp);
+	per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
 }
 
-/*
- * Drop to non-real-time priority and yield, but only after posting a
- * timer that will cause us to regain our real-time priority if we
- * remain preempted.  Either way, we restore our real-time priority
- * before returning.
- */
-static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
+static int rcu_cpu_kthread_should_run(unsigned int cpu)
 {
-	struct sched_param sp;
-	struct timer_list yield_timer;
-	int prio = current->rt_priority;
-
-	setup_timer_on_stack(&yield_timer, f, arg);
-	mod_timer(&yield_timer, jiffies + 2);
-	sp.sched_priority = 0;
-	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
-	set_user_nice(current, 19);
-	schedule();
-	set_user_nice(current, 0);
-	sp.sched_priority = prio;
-	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
-	del_timer(&yield_timer);
-}
-
-/*
- * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
- * This can happen while the corresponding CPU is either coming online
- * or going offline.  We cannot wait until the CPU is fully online
- * before starting the kthread, because the various notifier functions
- * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
- * the corresponding CPU is online.
- *
- * Return 1 if the kthread needs to stop, 0 otherwise.
- *
- * Caller must disable bh.  This function can momentarily enable it.
- */
-static int rcu_cpu_kthread_should_stop(int cpu)
-{
-	while (cpu_is_offline(cpu) ||
-	       !cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)) ||
-	       smp_processor_id() != cpu) {
-		if (kthread_should_stop())
-			return 1;
-		per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
-		per_cpu(rcu_cpu_kthread_cpu, cpu) = raw_smp_processor_id();
-		local_bh_enable();
-		schedule_timeout_uninterruptible(1);
-		if (!cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)))
-			set_cpus_allowed_ptr(current, cpumask_of(cpu));
-		local_bh_disable();
-	}
-	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
-	return 0;
+	return __get_cpu_var(rcu_cpu_has_work);
 }
 
 /*
@@ -1440,138 +1344,35 @@ static int rcu_cpu_kthread_should_stop(int cpu)
  * RCU softirq used in flavors and configurations of RCU that do not
  * support RCU priority boosting.
  */
-static int rcu_cpu_kthread(void *arg)
+static void rcu_cpu_kthread(unsigned int cpu)
 {
-	int cpu = (int)(long)arg;
-	unsigned long flags;
-	int spincnt = 0;
-	unsigned int *statusp = &per_cpu(rcu_cpu_kthread_status, cpu);
-	char work;
-	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
+	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
+	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
+	int spincnt;
 
-	trace_rcu_utilization("Start CPU kthread@init");
-	for (;;) {
-		*statusp = RCU_KTHREAD_WAITING;
-		trace_rcu_utilization("End CPU kthread@rcu_wait");
-		rcu_wait(*workp != 0 || kthread_should_stop());
+	for (spincnt = 0; spincnt < 10; spincnt++) {
 		trace_rcu_utilization("Start CPU kthread@rcu_wait");
 		local_bh_disable();
-		if (rcu_cpu_kthread_should_stop(cpu)) {
-			local_bh_enable();
-			break;
-		}
 		*statusp = RCU_KTHREAD_RUNNING;
-		per_cpu(rcu_cpu_kthread_loops, cpu)++;
-		local_irq_save(flags);
+		this_cpu_inc(rcu_cpu_kthread_loops);
+		local_irq_disable();
 		work = *workp;
 		*workp = 0;
-		local_irq_restore(flags);
+		local_irq_enable();
 		if (work)
 			rcu_kthread_do_work();
 		local_bh_enable();
-		if (*workp != 0)
-			spincnt++;
-		else
-			spincnt = 0;
-		if (spincnt > 10) {
-			*statusp = RCU_KTHREAD_YIELDING;
-			trace_rcu_utilization("End CPU kthread@rcu_yield");
-			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
-			trace_rcu_utilization("Start CPU kthread@rcu_yield");
-			spincnt = 0;
-		}
-	}
-	*statusp = RCU_KTHREAD_STOPPED;
-	trace_rcu_utilization("End CPU kthread@term");
-	return 0;
-}
-
-/*
- * Spawn a per-CPU kthread, setting up affinity and priority.
- * Because the CPU hotplug lock is held, no other CPU will be attempting
- * to manipulate rcu_cpu_kthread_task.  There might be another CPU
- * attempting to access it during boot, but the locking in kthread_bind()
- * will enforce sufficient ordering.
- *
- * Please note that we cannot simply refuse to wake up the per-CPU
- * kthread because kthreads are created in TASK_UNINTERRUPTIBLE state,
- * which can result in softlockup complaints if the task ends up being
- * idle for more than a couple of minutes.
- *
- * However, please note also that we cannot bind the per-CPU kthread to its
- * CPU until that CPU is fully online.  We also cannot wait until the
- * CPU is fully online before we create its per-CPU kthread, as this would
- * deadlock the system when CPU notifiers tried waiting for grace
- * periods.  So we bind the per-CPU kthread to its CPU only if the CPU
- * is online.  If its CPU is not yet fully online, then the code in
- * rcu_cpu_kthread() will wait until it is fully online, and then do
- * the binding.
- */
-static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
-{
-	struct sched_param sp;
-	struct task_struct *t;
-
-	if (!rcu_scheduler_fully_active ||
-	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
-		return 0;
-	t = kthread_create_on_node(rcu_cpu_kthread,
-				   (void *)(long)cpu,
-				   cpu_to_node(cpu),
-				   "rcuc/%d", cpu);
-	if (IS_ERR(t))
-		return PTR_ERR(t);
-	if (cpu_online(cpu))
-		kthread_bind(t, cpu);
-	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
-	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-	per_cpu(rcu_cpu_kthread_task, cpu) = t;
-	wake_up_process(t); /* Get to TASK_INTERRUPTIBLE quickly. */
-	return 0;
-}
-
-/*
- * Per-rcu_node kthread, which is in charge of waking up the per-CPU
- * kthreads when needed.  We ignore requests to wake up kthreads
- * for offline CPUs, which is OK because force_quiescent_state()
- * takes care of this case.
- */
-static int rcu_node_kthread(void *arg)
-{
-	int cpu;
-	unsigned long flags;
-	unsigned long mask;
-	struct rcu_node *rnp = (struct rcu_node *)arg;
-	struct sched_param sp;
-	struct task_struct *t;
-
-	for (;;) {
-		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
-		rcu_wait(atomic_read(&rnp->wakemask) != 0);
-		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		mask = atomic_xchg(&rnp->wakemask, 0);
-		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
-		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
-			if ((mask & 0x1) == 0)
-				continue;
-			preempt_disable();
-			t = per_cpu(rcu_cpu_kthread_task, cpu);
-			if (!cpu_online(cpu) || t == NULL) {
-				preempt_enable();
-				continue;
-			}
-			per_cpu(rcu_cpu_has_work, cpu) = 1;
-			sp.sched_priority = RCU_KTHREAD_PRIO;
-			sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-			preempt_enable();
+		if (*workp == 0) {
+			trace_rcu_utilization("End CPU kthread@rcu_wait");
+			*statusp = RCU_KTHREAD_WAITING;
+			return;
 		}
 	}
-	/* NOTREACHED */
-	rnp->node_kthread_status = RCU_KTHREAD_STOPPED;
-	return 0;
+	*statusp = RCU_KTHREAD_YIELDING;
+	trace_rcu_utilization("Start CPU kthread@rcu_yield");
+	schedule_timeout_interruptible(2);
+	trace_rcu_utilization("End CPU kthread@rcu_yield");
+	*statusp = RCU_KTHREAD_WAITING;
 }
 
 /*
@@ -1583,17 +1384,17 @@ static int rcu_node_kthread(void *arg)
  * no outgoing CPU.  If there are no CPUs left in the affinity set,
  * this function allows the kthread to execute on any CPU.
  */
-static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 {
+	struct task_struct *t = rnp->boost_kthread_task;
+	unsigned long mask = rnp->qsmaskinit;
 	cpumask_var_t cm;
 	int cpu;
-	unsigned long mask = rnp->qsmaskinit;
 
-	if (rnp->node_kthread_task == NULL)
+	if (!t)
 		return;
-	if (!alloc_cpumask_var(&cm, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&cm, GFP_KERNEL))
 		return;
-	cpumask_clear(cm);
 	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1)
 		if ((mask & 0x1) && cpu != outgoingcpu)
 			cpumask_set_cpu(cpu, cm);
@@ -1603,62 +1404,36 @@ static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 			cpumask_clear_cpu(cpu, cm);
 		WARN_ON_ONCE(cpumask_weight(cm) == 0);
 	}
-	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
-	rcu_boost_kthread_setaffinity(rnp, cm);
+	set_cpus_allowed_ptr(t, cm);
 	free_cpumask_var(cm);
 }
 
-/*
- * Spawn a per-rcu_node kthread, setting priority and affinity.
- * Called during boot before online/offline can happen, or, if
- * during runtime, with the main CPU-hotplug locks held.  So only
- * one of these can be executing at a time.
- */
-static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
-						struct rcu_node *rnp)
-{
-	unsigned long flags;
-	int rnp_index = rnp - &rsp->node[0];
-	struct sched_param sp;
-	struct task_struct *t;
-
-	if (!rcu_scheduler_fully_active ||
-	    rnp->qsmaskinit == 0)
-		return 0;
-	if (rnp->node_kthread_task == NULL) {
-		t = kthread_create(rcu_node_kthread, (void *)rnp,
-				   "rcun/%d", rnp_index);
-		if (IS_ERR(t))
-			return PTR_ERR(t);
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		rnp->node_kthread_task = t;
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		sp.sched_priority = 99;
-		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-		wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
-	}
-	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
-}
+static struct smp_hotplug_thread rcu_cpu_thread_spec = {
+	.store			= &rcu_cpu_kthread_task,
+	.thread_should_run	= rcu_cpu_kthread_should_run,
+	.thread_fn		= rcu_cpu_kthread,
+	.thread_comm		= "rcuc/%u",
+	.setup			= rcu_cpu_kthread_setup,
+	.park			= rcu_cpu_kthread_park,
+};
 
 /*
  * Spawn all kthreads -- called as soon as the scheduler is running.
  */
 static int __init rcu_spawn_kthreads(void)
 {
-	int cpu;
 	struct rcu_node *rnp;
+	int cpu;
 
 	rcu_scheduler_fully_active = 1;
-	for_each_possible_cpu(cpu) {
+	for_each_possible_cpu(cpu)
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
-		if (cpu_online(cpu))
-			(void)rcu_spawn_one_cpu_kthread(cpu);
-	}
+	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
 	rnp = rcu_get_root(rcu_state);
-	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+	(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
 	if (NUM_RCU_NODES > 1) {
 		rcu_for_each_leaf_node(rcu_state, rnp)
-			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+			(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
 	}
 	return 0;
 }
@@ -1670,11 +1445,8 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
 	struct rcu_node *rnp = rdp->mynode;
 
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
-	if (rcu_scheduler_fully_active) {
-		(void)rcu_spawn_one_cpu_kthread(cpu);
-		if (rnp->node_kthread_task == NULL)
-			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-	}
+	if (rcu_scheduler_fully_active)
+		(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
@@ -1698,19 +1470,7 @@ static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
 {
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static void rcu_stop_cpu_kthread(int cpu)
-{
-}
-
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
-static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
-{
-}
-
-static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 {
 }
 
@@ -1997,6 +1757,26 @@ static void rcu_prepare_for_idle(int cpu)
 	if (!tne)
 		return;
 
+	/* Adaptive-tick mode, where usermode execution is idle to RCU. */
+	if (!is_idle_task(current)) {
+		rdtp->dyntick_holdoff = jiffies - 1;
+		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
+			trace_rcu_prep_idle("User dyntick with callbacks");
+			rdtp->idle_gp_timer_expires =
+				round_up(jiffies + RCU_IDLE_GP_DELAY,
+					 RCU_IDLE_GP_DELAY);
+		} else if (rcu_cpu_has_callbacks(cpu)) {
+			rdtp->idle_gp_timer_expires =
+				round_jiffies(jiffies + RCU_IDLE_LAZY_GP_DELAY);
+			trace_rcu_prep_idle("User dyntick with lazy callbacks");
+		} else {
+			return;
+		}
+		tp = &rdtp->idle_gp_timer;
+		mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
+		return;
+	}
+
 	/*
 	 * If this is an idle re-entry, for example, due to use of
 	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
@@ -2075,16 +1855,16 @@ static void rcu_prepare_for_idle(int cpu)
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	if (per_cpu(rcu_preempt_data, cpu).nxtlist) {
 		rcu_preempt_qs(cpu);
-		force_quiescent_state(&rcu_preempt_state, 0);
+		force_quiescent_state(&rcu_preempt_state);
 	}
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
 		rcu_sched_qs(cpu);
-		force_quiescent_state(&rcu_sched_state, 0);
+		force_quiescent_state(&rcu_sched_state);
 	}
 	if (per_cpu(rcu_bh_data, cpu).nxtlist) {
 		rcu_bh_qs(cpu);
-		force_quiescent_state(&rcu_bh_state, 0);
+		force_quiescent_state(&rcu_bh_state);
 	}
 
 	/*
@@ -2112,6 +1892,88 @@ static void rcu_idle_count_callbacks_posted(void)
 	__this_cpu_add(rcu_dynticks.nonlazy_posted, 1);
 }
 
+/*
+ * Data for flushing lazy RCU callbacks at OOM time.
+ */
+static atomic_t oom_callback_count;
+static DECLARE_WAIT_QUEUE_HEAD(oom_callback_wq);
+
+/*
+ * RCU OOM callback -- decrement the outstanding count and deliver the
+ * wake-up if we are the last one.
+ */
+static void rcu_oom_callback(struct rcu_head *rhp)
+{
+	if (atomic_dec_and_test(&oom_callback_count))
+		wake_up(&oom_callback_wq);
+}
+
+/*
+ * Post an rcu_oom_notify callback on the current CPU if it has at
+ * least one lazy callback.  This will unnecessarily post callbacks
+ * to CPUs that already have a non-lazy callback at the end of their
+ * callback list, but this is an infrequent operation, so accept some
+ * extra overhead to keep things simple.
+ */
+static void rcu_oom_notify_cpu(void *unused)
+{
+	struct rcu_state *rsp;
+	struct rcu_data *rdp;
+
+	for_each_rcu_flavor(rsp) {
+		rdp = __this_cpu_ptr(rsp->rda);
+		if (rdp->qlen_lazy != 0) {
+			atomic_inc(&oom_callback_count);
+			rsp->call(&rdp->oom_head, rcu_oom_callback);
+		}
+	}
+}
+
+/*
+ * If low on memory, ensure that each CPU has a non-lazy callback.
+ * This will wake up CPUs that have only lazy callbacks, in turn
+ * ensuring that they free up the corresponding memory in a timely manner.
+ * Because an uncertain amount of memory will be freed in some uncertain
+ * timeframe, we do not claim to have freed anything.
+ */
+static int rcu_oom_notify(struct notifier_block *self,
+			  unsigned long notused, void *nfreed)
+{
+	int cpu;
+
+	/* Wait for callbacks from earlier instance to complete. */
+	wait_event(oom_callback_wq, atomic_read(&oom_callback_count) == 0);
+
+	/*
+	 * Prevent premature wakeup: ensure that all increments happen
+	 * before there is a chance of the counter reaching zero.
+	 */
+	atomic_set(&oom_callback_count, 1);
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		smp_call_function_single(cpu, rcu_oom_notify_cpu, NULL, 1);
+		cond_resched();
+	}
+	put_online_cpus();
+
+	/* Unconditionally decrement: no need to wake ourselves up. */
+	atomic_dec(&oom_callback_count);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block rcu_oom_nb = {
+	.notifier_call = rcu_oom_notify
+};
+
+static int __init rcu_register_oom_notifier(void)
+{
+	register_oom_notifier(&rcu_oom_nb);
+	return 0;
+}
+early_initcall(rcu_register_oom_notifier);
+
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 #ifdef CONFIG_RCU_CPU_STALL_INFO
@@ -2122,11 +1984,15 @@ static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 {
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 	struct timer_list *tltp = &rdtp->idle_gp_timer;
+	char c;
 
-	sprintf(cp, "drain=%d %c timer=%lu",
-		rdtp->dyntick_drain,
-		rdtp->dyntick_holdoff == jiffies ? 'H' : '.',
-		timer_pending(tltp) ? tltp->expires - jiffies : -1);
+	c = rdtp->dyntick_holdoff == jiffies ? 'H' : '.';
+	if (timer_pending(tltp))
+		sprintf(cp, "drain=%d %c timer=%lu",
+			rdtp->dyntick_drain, c, tltp->expires - jiffies);
+	else
+		sprintf(cp, "drain=%d %c timer not pending",
+			rdtp->dyntick_drain, c);
 }
 
 #else /* #ifdef CONFIG_RCU_FAST_NO_HZ */
@@ -2194,11 +2060,10 @@ static void zero_cpu_stall_ticks(struct rcu_data *rdp)
 /* Increment ->ticks_this_gp for all flavors of RCU. */
 static void increment_cpu_stall_ticks(void)
 {
-	__get_cpu_var(rcu_sched_data).ticks_this_gp++;
-	__get_cpu_var(rcu_bh_data).ticks_this_gp++;
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	__get_cpu_var(rcu_preempt_data).ticks_this_gp++;
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+	struct rcu_state *rsp;
+
+	for_each_rcu_flavor(rsp)
+		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
 }
 
 #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index abffb48..693513b 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -51,8 +51,8 @@ static int show_rcubarrier(struct seq_file *m, void *unused)
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		seq_printf(m, "%s: %c bcc: %d nbd: %lu\n",
-			   rsp->name, rsp->rcu_barrier_in_progress ? 'B' : '.',
+		seq_printf(m, "%s: bcc: %d nbd: %lu\n",
+			   rsp->name,
 			   atomic_read(&rsp->barrier_cpu_count),
 			   rsp->n_barrier_done);
 	return 0;
@@ -86,12 +86,11 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d pgp=%lu qp=%d",
+	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d qp=%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
 		   rdp->completed, rdp->gpnum,
-		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
-		   rdp->qs_pending);
+		   rdp->passed_quiesce, rdp->qs_pending);
 	seq_printf(m, " dt=%d/%llx/%d df=%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
@@ -108,11 +107,10 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 			rdp->nxttail[RCU_WAIT_TAIL]],
 		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]]);
 #ifdef CONFIG_RCU_BOOST
-	seq_printf(m, " kt=%d/%c/%d ktl=%x",
+	seq_printf(m, " kt=%d/%c ktl=%x",
 		   per_cpu(rcu_cpu_has_work, rdp->cpu),
 		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
 					  rdp->cpu)),
-		   per_cpu(rcu_cpu_kthread_cpu, rdp->cpu),
 		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	seq_printf(m, " b=%ld", rdp->blimit);
@@ -150,12 +148,11 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%d,%s,%lu,%lu,%d,%lu,%d",
+	seq_printf(m, "%d,%s,%lu,%lu,%d,%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? "\"N\"" : "\"Y\"",
 		   rdp->completed, rdp->gpnum,
-		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
-		   rdp->qs_pending);
+		   rdp->passed_quiesce, rdp->qs_pending);
 	seq_printf(m, ",%d,%llx,%d,%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
@@ -186,7 +183,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 	int cpu;
 	struct rcu_state *rsp;
 
-	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
+	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pq\",");
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
 	seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
 #ifdef CONFIG_RCU_BOOST
@@ -386,10 +383,9 @@ static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->n_rp_report_qs,
 		   rdp->n_rp_cb_ready,
 		   rdp->n_rp_cpu_needs_gp);
-	seq_printf(m, "gpc=%ld gps=%ld nf=%ld nn=%ld\n",
+	seq_printf(m, "gpc=%ld gps=%ld nn=%ld\n",
 		   rdp->n_rp_gp_completed,
 		   rdp->n_rp_gp_started,
-		   rdp->n_rp_need_fqs,
 		   rdp->n_rp_need_nothing);
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 649c9f8..3c4dec0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2081,6 +2081,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
+	rcu_switch(prev, next);
 	switch_to(prev, next, prev);
 
 	barrier();
@@ -3468,6 +3469,21 @@ asmlinkage void __sched schedule(void)
 }
 EXPORT_SYMBOL(schedule);
 
+#ifdef CONFIG_RCU_USER_QS
+asmlinkage void __sched schedule_user(void)
+{
+	/*
+	 * If we come here after a random call to set_need_resched(),
+	 * or we have been woken up remotely but the IPI has not yet arrived,
+	 * we haven't yet exited the RCU idle mode. Do it here manually until
+	 * we find a better solution.
+	 */
+	rcu_user_exit();
+	schedule();
+	rcu_user_enter();
+}
+#endif
+
 /**
  * schedule_preempt_disabled - called with preemption disabled
  *
@@ -3569,6 +3585,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
+	rcu_user_exit();
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
@@ -5604,7 +5621,9 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		migrate_tasks(cpu);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		break;
 
+	case CPU_DEAD:
 		calc_load_migrate(rq);
 		break;
 #endif
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 98f60c5..d6c5fc0 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -1,14 +1,22 @@
 /*
  * Common SMP CPU bringup/teardown functions
  */
+#include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/smp.h>
 #include <linux/init.h>
+#include <linux/list.h>
+#include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/export.h>
 #include <linux/percpu.h>
+#include <linux/kthread.h>
+#include <linux/smpboot.h>
 
 #include "smpboot.h"
 
+#ifdef CONFIG_SMP
+
 #ifdef CONFIG_GENERIC_SMP_IDLE_THREAD
 /*
  * For the hotplug case we keep the task structs around and reuse
@@ -65,3 +73,228 @@ void __init idle_threads_init(void)
 	}
 }
 #endif
+
+#endif /* #ifdef CONFIG_SMP */
+
+static LIST_HEAD(hotplug_threads);
+static DEFINE_MUTEX(smpboot_threads_lock);
+
+struct smpboot_thread_data {
+	unsigned int			cpu;
+	unsigned int			status;
+	struct smp_hotplug_thread	*ht;
+};
+
+enum {
+	HP_THREAD_NONE = 0,
+	HP_THREAD_ACTIVE,
+	HP_THREAD_PARKED,
+};
+
+/**
+ * smpboot_thread_fn - percpu hotplug thread loop function
+ * @data:	thread data pointer
+ *
+ * Checks for thread stop and park conditions. Calls the necessary
+ * setup, cleanup, park and unpark functions for the registered
+ * thread.
+ *
+ * Returns 1 when the thread should exit, 0 otherwise.
+ */
+static int smpboot_thread_fn(void *data)
+{
+	struct smpboot_thread_data *td = data;
+	struct smp_hotplug_thread *ht = td->ht;
+
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		preempt_disable();
+		if (kthread_should_stop()) {
+			set_current_state(TASK_RUNNING);
+			preempt_enable();
+			if (ht->cleanup)
+				ht->cleanup(td->cpu, cpu_online(td->cpu));
+			kfree(td);
+			return 0;
+		}
+
+		if (kthread_should_park()) {
+			__set_current_state(TASK_RUNNING);
+			preempt_enable();
+			if (ht->park && td->status == HP_THREAD_ACTIVE) {
+				BUG_ON(td->cpu != smp_processor_id());
+				ht->park(td->cpu);
+				td->status = HP_THREAD_PARKED;
+			}
+			kthread_parkme();
+			/* We might have been woken for stop */
+			continue;
+		}
+
+		BUG_ON(td->cpu != smp_processor_id());
+
+		/* Check for state change setup */
+		switch (td->status) {
+		case HP_THREAD_NONE:
+			preempt_enable();
+			if (ht->setup)
+				ht->setup(td->cpu);
+			td->status = HP_THREAD_ACTIVE;
+			preempt_disable();
+			break;
+		case HP_THREAD_PARKED:
+			preempt_enable();
+			if (ht->unpark)
+				ht->unpark(td->cpu);
+			td->status = HP_THREAD_ACTIVE;
+			preempt_disable();
+			break;
+		}
+
+		if (!ht->thread_should_run(td->cpu)) {
+			preempt_enable();
+			schedule();
+		} else {
+			set_current_state(TASK_RUNNING);
+			preempt_enable();
+			ht->thread_fn(td->cpu);
+		}
+	}
+}
+
+static int
+__smpboot_create_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
+{
+	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
+	struct smpboot_thread_data *td;
+
+	if (tsk)
+		return 0;
+
+	td = kzalloc_node(sizeof(*td), GFP_KERNEL, cpu_to_node(cpu));
+	if (!td)
+		return -ENOMEM;
+	td->cpu = cpu;
+	td->ht = ht;
+
+	tsk = kthread_create_on_cpu(smpboot_thread_fn, td, cpu,
+				    ht->thread_comm);
+	if (IS_ERR(tsk)) {
+		kfree(td);
+		return PTR_ERR(tsk);
+	}
+
+	get_task_struct(tsk);
+	*per_cpu_ptr(ht->store, cpu) = tsk;
+	return 0;
+}
+
+int smpboot_create_threads(unsigned int cpu)
+{
+	struct smp_hotplug_thread *cur;
+	int ret = 0;
+
+	mutex_lock(&smpboot_threads_lock);
+	list_for_each_entry(cur, &hotplug_threads, list) {
+		ret = __smpboot_create_thread(cur, cpu);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&smpboot_threads_lock);
+	return ret;
+}
+
+static void smpboot_unpark_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
+{
+	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
+
+	kthread_unpark(tsk);
+}
+
+void smpboot_unpark_threads(unsigned int cpu)
+{
+	struct smp_hotplug_thread *cur;
+
+	mutex_lock(&smpboot_threads_lock);
+	list_for_each_entry(cur, &hotplug_threads, list)
+		smpboot_unpark_thread(cur, cpu);
+	mutex_unlock(&smpboot_threads_lock);
+}
+
+static void smpboot_park_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
+{
+	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
+
+	if (tsk)
+		kthread_park(tsk);
+}
+
+void smpboot_park_threads(unsigned int cpu)
+{
+	struct smp_hotplug_thread *cur;
+
+	mutex_lock(&smpboot_threads_lock);
+	list_for_each_entry_reverse(cur, &hotplug_threads, list)
+		smpboot_park_thread(cur, cpu);
+	mutex_unlock(&smpboot_threads_lock);
+}
+
+static void smpboot_destroy_threads(struct smp_hotplug_thread *ht)
+{
+	unsigned int cpu;
+
+	/* We need to destroy also the parked threads of offline cpus */
+	for_each_possible_cpu(cpu) {
+		struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
+
+		if (tsk) {
+			kthread_stop(tsk);
+			put_task_struct(tsk);
+			*per_cpu_ptr(ht->store, cpu) = NULL;
+		}
+	}
+}
+
+/**
+ * smpboot_register_percpu_thread - Register a per_cpu thread related to hotplug
+ * @plug_thread:	Hotplug thread descriptor
+ *
+ * Creates and starts the threads on all online cpus.
+ */
+int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
+{
+	unsigned int cpu;
+	int ret = 0;
+
+	mutex_lock(&smpboot_threads_lock);
+	for_each_online_cpu(cpu) {
+		ret = __smpboot_create_thread(plug_thread, cpu);
+		if (ret) {
+			smpboot_destroy_threads(plug_thread);
+			goto out;
+		}
+		smpboot_unpark_thread(plug_thread, cpu);
+	}
+	list_add(&plug_thread->list, &hotplug_threads);
+out:
+	mutex_unlock(&smpboot_threads_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
+
+/**
+ * smpboot_unregister_percpu_thread - Unregister a per_cpu thread related to hotplug
+ * @plug_thread:	Hotplug thread descriptor
+ *
+ * Stops all threads on all possible cpus.
+ */
+void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread)
+{
+	get_online_cpus();
+	mutex_lock(&smpboot_threads_lock);
+	list_del(&plug_thread->list);
+	smpboot_destroy_threads(plug_thread);
+	mutex_unlock(&smpboot_threads_lock);
+	put_online_cpus();
+}
+EXPORT_SYMBOL_GPL(smpboot_unregister_percpu_thread);
diff --git a/kernel/smpboot.h b/kernel/smpboot.h
index 6ef9433..72415a0 100644
--- a/kernel/smpboot.h
+++ b/kernel/smpboot.h
@@ -13,4 +13,8 @@ static inline void idle_thread_set_boot_cpu(void) { }
 static inline void idle_threads_init(void) { }
 #endif
 
+int smpboot_create_threads(unsigned int cpu);
+void smpboot_park_threads(unsigned int cpu);
+void smpboot_unpark_threads(unsigned int cpu);
+
 #endif
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b73e681..5c6a5bd 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/ftrace.h>
 #include <linux/smp.h>
+#include <linux/smpboot.h>
 #include <linux/tick.h>
 
 #define CREATE_TRACE_POINTS
@@ -742,49 +743,22 @@ void __init softirq_init(void)
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
 
-static int run_ksoftirqd(void * __bind_cpu)
+static int ksoftirqd_should_run(unsigned int cpu)
 {
-	set_current_state(TASK_INTERRUPTIBLE);
-
-	while (!kthread_should_stop()) {
-		preempt_disable();
-		if (!local_softirq_pending()) {
-			schedule_preempt_disabled();
-		}
-
-		__set_current_state(TASK_RUNNING);
-
-		while (local_softirq_pending()) {
-			/* Preempt disable stops cpu going offline.
-			   If already offline, we'll be on wrong CPU:
-			   don't process */
-			if (cpu_is_offline((long)__bind_cpu))
-				goto wait_to_die;
-			local_irq_disable();
-			if (local_softirq_pending())
-				__do_softirq();
-			local_irq_enable();
-			sched_preempt_enable_no_resched();
-			cond_resched();
-			preempt_disable();
-			rcu_note_context_switch((long)__bind_cpu);
-		}
-		preempt_enable();
-		set_current_state(TASK_INTERRUPTIBLE);
-	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
+	return local_softirq_pending();
+}
 
-wait_to_die:
-	preempt_enable();
-	/* Wait for kthread_stop */
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		set_current_state(TASK_INTERRUPTIBLE);
+static void run_ksoftirqd(unsigned int cpu)
+{
+	local_irq_disable();
+	if (local_softirq_pending()) {
+		__do_softirq();
+		rcu_note_context_switch(cpu);
+		local_irq_enable();
+		cond_resched();
+		return;
 	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
+	local_irq_enable();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -850,50 +824,14 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 				  unsigned long action,
 				  void *hcpu)
 {
-	int hotcpu = (unsigned long)hcpu;
-	struct task_struct *p;
-
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		p = kthread_create_on_node(run_ksoftirqd,
-					   hcpu,
-					   cpu_to_node(hotcpu),
-					   "ksoftirqd/%d", hotcpu);
-		if (IS_ERR(p)) {
-			printk("ksoftirqd for %i failed\n", hotcpu);
-			return notifier_from_errno(PTR_ERR(p));
-		}
-		kthread_bind(p, hotcpu);
-  		per_cpu(ksoftirqd, hotcpu) = p;
- 		break;
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		wake_up_process(per_cpu(ksoftirqd, hotcpu));
-		break;
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		if (!per_cpu(ksoftirqd, hotcpu))
-			break;
-		/* Unbind so it can run.  Fall thru. */
-		kthread_bind(per_cpu(ksoftirqd, hotcpu),
-			     cpumask_any(cpu_online_mask));
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN: {
-		static const struct sched_param param = {
-			.sched_priority = MAX_RT_PRIO-1
-		};
-
-		p = per_cpu(ksoftirqd, hotcpu);
-		per_cpu(ksoftirqd, hotcpu) = NULL;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
-		kthread_stop(p);
-		takeover_tasklets(hotcpu);
+	case CPU_DEAD_FROZEN:
+		takeover_tasklets((unsigned long)hcpu);
 		break;
-	}
 #endif /* CONFIG_HOTPLUG_CPU */
- 	}
+	}
 	return NOTIFY_OK;
 }
 
@@ -901,14 +839,19 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
+static struct smp_hotplug_thread softirq_threads = {
+	.store			= &ksoftirqd,
+	.thread_should_run	= ksoftirqd_should_run,
+	.thread_fn		= run_ksoftirqd,
+	.thread_comm		= "ksoftirqd/%u",
+};
+
 static __init int spawn_ksoftirqd(void)
 {
-	void *cpu = (void *)(long)smp_processor_id();
-	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
-
-	BUG_ON(err != NOTIFY_OK);
-	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
+
+	BUG_ON(smpboot_register_percpu_thread(&softirq_threads));
+
 	return 0;
 }
 early_initcall(spawn_ksoftirqd);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3a9e5d5..cf5f6b2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -436,7 +436,8 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
 		static int ratelimit;
 
-		if (ratelimit < 10) {
+		if (ratelimit < 10 &&
+		    (local_softirq_pending() & SOFTIRQ_STOP_IDLE_MASK)) {
 			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
 			       (unsigned int) local_softirq_pending());
 			ratelimit++;
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4b1dfba..9d4c8d5 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -22,6 +22,7 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
+#include <linux/smpboot.h>
 
 #include <asm/irq_regs.h>
 #include <linux/kvm_para.h>
@@ -29,16 +30,18 @@
 
 int watchdog_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
+static int __read_mostly watchdog_disabled;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
+static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
+static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
@@ -248,13 +251,15 @@ static void watchdog_overflow_callback(struct perf_event *event,
 	__this_cpu_write(hard_watchdog_warn, false);
 	return;
 }
+#endif /* CONFIG_HARDLOCKUP_DETECTOR */
+
 static void watchdog_interrupt_count(void)
 {
 	__this_cpu_inc(hrtimer_interrupts);
 }
-#else
-static inline void watchdog_interrupt_count(void) { return; }
-#endif /* CONFIG_HARDLOCKUP_DETECTOR */
+
+static int watchdog_nmi_enable(unsigned int cpu);
+static void watchdog_nmi_disable(unsigned int cpu);
 
 /* watchdog kicker functions */
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
@@ -327,49 +332,68 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	return HRTIMER_RESTART;
 }
 
+static void watchdog_set_prio(unsigned int policy, unsigned int prio)
+{
+	struct sched_param param = { .sched_priority = prio };
 
-/*
- * The watchdog thread - touches the timestamp.
- */
-static int watchdog(void *unused)
+	sched_setscheduler(current, policy, &param);
+}
+
+static void watchdog_enable(unsigned int cpu)
 {
-	struct sched_param param = { .sched_priority = 0 };
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
-	/* initialize timestamp */
-	__touch_watchdog();
+	if (!watchdog_enabled) {
+		kthread_park(current);
+		return;
+	}
+
+	/* Enable the perf event */
+	watchdog_nmi_enable(cpu);
 
 	/* kick off the timer for the hardlockup detector */
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer->function = watchdog_timer_fn;
+
 	/* done here because hrtimer_start can only pin to smp_processor_id() */
 	hrtimer_start(hrtimer, ns_to_ktime(get_sample_period()),
 		      HRTIMER_MODE_REL_PINNED);
 
-	set_current_state(TASK_INTERRUPTIBLE);
-	/*
-	 * Run briefly (kicked by the hrtimer callback function) once every
-	 * get_sample_period() seconds (4 seconds by default) to reset the
-	 * softlockup timestamp. If this gets delayed for more than
-	 * 2*watchdog_thresh seconds then the debug-printout triggers in
-	 * watchdog_timer_fn().
-	 */
-	while (!kthread_should_stop()) {
-		__touch_watchdog();
-		schedule();
+	/* initialize timestamp */
+	watchdog_set_prio(SCHED_FIFO, MAX_RT_PRIO - 1);
+	__touch_watchdog();
+}
 
-		if (kthread_should_stop())
-			break;
+static void watchdog_disable(unsigned int cpu)
+{
+	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
-		set_current_state(TASK_INTERRUPTIBLE);
-	}
-	/*
-	 * Drop the policy/priority elevation during thread exit to avoid a
-	 * scheduling latency spike.
-	 */
-	__set_current_state(TASK_RUNNING);
-	sched_setscheduler(current, SCHED_NORMAL, &param);
-	return 0;
+	watchdog_set_prio(SCHED_NORMAL, 0);
+	hrtimer_cancel(hrtimer);
+	/* disable the perf event */
+	watchdog_nmi_disable(cpu);
 }
 
+static int watchdog_should_run(unsigned int cpu)
+{
+	return __this_cpu_read(hrtimer_interrupts) !=
+		__this_cpu_read(soft_lockup_hrtimer_cnt);
+}
+
+/*
+ * The watchdog thread function - touches the timestamp.
+ *
+ * It only runs once every get_sample_period() seconds (4 seconds by
+ * default) to reset the softlockup timestamp. If this gets delayed
+ * for more than 2*watchdog_thresh seconds then the debug-printout
+ * triggers in watchdog_timer_fn().
+ */
+static void watchdog(unsigned int cpu)
+{
+	__this_cpu_write(soft_lockup_hrtimer_cnt,
+			 __this_cpu_read(hrtimer_interrupts));
+	__touch_watchdog();
+}
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 /*
@@ -379,7 +403,7 @@ static int watchdog(void *unused)
  */
 static unsigned long cpu0_err;
 
-static int watchdog_nmi_enable(int cpu)
+static int watchdog_nmi_enable(unsigned int cpu)
 {
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
@@ -433,7 +457,7 @@ out:
 	return 0;
 }
 
-static void watchdog_nmi_disable(int cpu)
+static void watchdog_nmi_disable(unsigned int cpu)
 {
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
@@ -447,107 +471,35 @@ static void watchdog_nmi_disable(int cpu)
 	return;
 }
 #else
-static int watchdog_nmi_enable(int cpu) { return 0; }
-static void watchdog_nmi_disable(int cpu) { return; }
+static int watchdog_nmi_enable(unsigned int cpu) { return 0; }
+static void watchdog_nmi_disable(unsigned int cpu) { return; }
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
 /* prepare/enable/disable routines */
-static void watchdog_prepare_cpu(int cpu)
-{
-	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
-
-	WARN_ON(per_cpu(softlockup_watchdog, cpu));
-	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtimer->function = watchdog_timer_fn;
-}
-
-static int watchdog_enable(int cpu)
-{
-	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
-	int err = 0;
-
-	/* enable the perf event */
-	err = watchdog_nmi_enable(cpu);
-
-	/* Regardless of err above, fall through and start softlockup */
-
-	/* create the watchdog thread */
-	if (!p) {
-		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu), "watchdog/%d", cpu);
-		if (IS_ERR(p)) {
-			pr_err("softlockup watchdog for %i failed\n", cpu);
-			if (!err) {
-				/* if hardlockup hasn't already set this */
-				err = PTR_ERR(p);
-				/* and disable the perf event */
-				watchdog_nmi_disable(cpu);
-			}
-			goto out;
-		}
-		sched_setscheduler(p, SCHED_FIFO, &param);
-		kthread_bind(p, cpu);
-		per_cpu(watchdog_touch_ts, cpu) = 0;
-		per_cpu(softlockup_watchdog, cpu) = p;
-		wake_up_process(p);
-	}
-
-out:
-	return err;
-}
-
-static void watchdog_disable(int cpu)
-{
-	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
-	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
-
-	/*
-	 * cancel the timer first to stop incrementing the stats
-	 * and waking up the kthread
-	 */
-	hrtimer_cancel(hrtimer);
-
-	/* disable the perf event */
-	watchdog_nmi_disable(cpu);
-
-	/* stop the watchdog thread */
-	if (p) {
-		per_cpu(softlockup_watchdog, cpu) = NULL;
-		kthread_stop(p);
-	}
-}
-
 /* sysctl functions */
 #ifdef CONFIG_SYSCTL
 static void watchdog_enable_all_cpus(void)
 {
-	int cpu;
-
-	watchdog_enabled = 0;
-
-	for_each_online_cpu(cpu)
-		if (!watchdog_enable(cpu))
-			/* if any cpu succeeds, watchdog is considered
-			   enabled for the system */
-			watchdog_enabled = 1;
-
-	if (!watchdog_enabled)
-		pr_err("failed to be enabled on some cpus\n");
+	unsigned int cpu;
 
+	if (watchdog_disabled) {
+		watchdog_disabled = 0;
+		for_each_online_cpu(cpu)
+			kthread_unpark(per_cpu(softlockup_watchdog, cpu));
+	}
 }
 
 static void watchdog_disable_all_cpus(void)
 {
-	int cpu;
-
-	for_each_online_cpu(cpu)
-		watchdog_disable(cpu);
+	unsigned int cpu;
 
-	/* if all watchdogs are disabled, then they are disabled for the system */
-	watchdog_enabled = 0;
+	if (!watchdog_disabled) {
+		watchdog_disabled = 1;
+		for_each_online_cpu(cpu)
+			kthread_park(per_cpu(softlockup_watchdog, cpu));
+	}
 }
 
-
 /*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
@@ -557,73 +509,36 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 {
 	int ret;
 
+	if (watchdog_disabled < 0)
+		return -ENODEV;
+
 	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (ret || !write)
-		goto out;
+		return ret;
 
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
 		watchdog_disable_all_cpus();
 
-out:
 	return ret;
 }
 #endif /* CONFIG_SYSCTL */
 
-
-/*
- * Create/destroy watchdog threads as CPUs come and go:
- */
-static int __cpuinit
-cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
-{
-	int hotcpu = (unsigned long)hcpu;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		watchdog_prepare_cpu(hotcpu);
-		break;
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		if (watchdog_enabled)
-			watchdog_enable(hotcpu);
-		break;
-#ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		watchdog_disable(hotcpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		watchdog_disable(hotcpu);
-		break;
-#endif /* CONFIG_HOTPLUG_CPU */
-	}
-
-	/*
-	 * hardlockup and softlockup are not important enough
-	 * to block cpu bring up.  Just always succeed and
-	 * rely on printk output to flag problems.
-	 */
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata cpu_nfb = {
-	.notifier_call = cpu_callback
+static struct smp_hotplug_thread watchdog_threads = {
+	.store			= &softlockup_watchdog,
+	.thread_should_run	= watchdog_should_run,
+	.thread_fn		= watchdog,
+	.thread_comm		= "watchdog/%u",
+	.setup			= watchdog_enable,
+	.park			= watchdog_disable,
+	.unpark			= watchdog_enable,
 };
 
 void __init lockup_detector_init(void)
 {
-	void *cpu = (void *)(long)smp_processor_id();
-	int err;
-
-	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
-	WARN_ON(notifier_to_errno(err));
-
-	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
-	register_cpu_notifier(&cpu_nfb);
-
-	return;
+	if (smpboot_register_percpu_thread(&watchdog_threads)) {
+		pr_err("Failed to create watchdog threads, disabled\n");
+		watchdog_disabled = -ENODEV;
+	}
 }
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2403a63..dacbbe4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -629,6 +629,20 @@ config PROVE_RCU_REPEATEDLY
 
 	 Say N if you are unsure.
 
+config PROVE_RCU_DELAY
+	bool "RCU debugging: preemptible RCU race provocation"
+	depends on DEBUG_KERNEL && PREEMPT_RCU
+	default n
+	help
+	 There is a class of races that involve an unlikely preemption
+	 of __rcu_read_unlock() just after ->rcu_read_lock_nesting has
+	 been set to INT_MIN.  This feature inserts a delay at that
+	 point to increase the probability of these races.
+
+	 Say Y to increase probability of preemption of __rcu_read_unlock().
+
+	 Say N if you are unsure.
+
 config SPARSE_RCU_POINTER
 	bool "RCU debugging: sparse-based checks for pointer usage"
 	default n
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 45eb621..0de83b4 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1483,13 +1483,11 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct kmemleak_object *prev_obj = v;
 	struct kmemleak_object *next_obj = NULL;
-	struct list_head *n = &prev_obj->object_list;
+	struct kmemleak_object *obj = prev_obj;
 
 	++(*pos);
 
-	list_for_each_continue_rcu(n, &object_list) {
-		struct kmemleak_object *obj =
-			list_entry(n, struct kmemleak_object, object_list);
+	list_for_each_entry_continue_rcu(obj, &object_list, object_list) {
 		if (get_object(obj)) {
 			next_obj = obj;
 			break;
