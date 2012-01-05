Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2AEN5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:57:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39556 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab2AEN46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:56:58 -0500
Date: Thu, 5 Jan 2012 14:54:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.3
Message-ID: <20120105135432.GA31450@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (11):
      rcu: Detect illegal rcu dereference in extended quiescent state
      rcu: Inform the user about extended quiescent state on PROVE_RCU warning
      rcu: Warn when rcu_read_lock() is used in extended quiescent state
      nohz: Separate out irq exit and idle loop dyntick logic
      nohz: Allow rcu extended quiescent state handling seperately from tick stop
      x86: Enter rcu extended qs after idle notifier call
      x86: Call idle notifier after irq_enter()
      rcu: Fix early call to rcu_idle_enter()
      nohz: Remove tick_nohz_idle_enter_norcu() / tick_nohz_idle_exit_norcu()
      rcu: Don't check irq nesting from rcu idle entry/exit
      rcu: Irq nesting is always 0 on rcu_enter_idle_common

Josh Triplett (1):
      driver-core/cpu: Expose hotpluggability to the rest of the kernel

Kees Cook (1):
      docs: Additional LWN links to RCU API

Paul E. McKenney (49):
      rcu: ->signaled better named ->fqs_state
      rcu: Avoid RCU-preempt expedited grace-period botch
      rcu: Make synchronize_sched_expedited() better at work sharing
      lockdep: Update documentation for lock-class leak detection
      rcu: Track idleness independent of idle tasks
      trace: Allow ftrace_dump() to be called from modules
      rcu: Add failure tracing to rcutorture
      rcu: Document failing tick as cause of RCU CPU stall warning
      rcu: Disable preemption in rcu_is_cpu_idle()
      rcu: Remove one layer of abstraction from PROVE_RCU checking
      rcu: Warn when srcu_read_lock() is used in an extended quiescent state
      rcu: Make srcu_read_lock_held() call common lockdep-enabled function
      powerpc: Tell RCU about idle after hcall tracing
      rcu: Introduce raw SRCU read-side primitives
      rcu: Add documentation for raw SRCU read-side primitives
      rcu: Deconfuse dynticks entry-exit tracing
      rcu: Add more information to the wrong-idle-task complaint
      rcu: Allow dyntick-idle mode for CPUs with callbacks
      rcu: Fix idle-task checks
      rcu: Permit RCU_FAST_NO_HZ to be used by TREE_PREEMPT_RCU
      rcu: Add rcutorture system-shutdown capability
      rcu: Control rcutorture startup from kernel boot parameters
      sched: Add is_idle_task() to handle invalidated uses of idle_cpu()
      rcu: Make RCU use the new is_idle_task() API
      sparc: Make SPARC use the new is_idle_task() API
      kdb: Make KDB use the new is_idle_task() API
      events: Make events use the new is_idle_task() API
      tile: Make tile use the new is_idle_task() API
      rcu: Add rcutorture CPU-hotplug capability
      doc: Add load/store guarantees to Documentation/atomic-ops.txt
      rcu: Update trace_rcu_dyntick() header comment
      rcu: Add tracing for RCU_FAST_NO_HZ
      rcu: Go dyntick-idle more quickly if CPU has serviced current grace period
      rcu: Avoid needlessly IPIing CPUs at GP end
      rcu: Eliminate RCU_FAST_NO_HZ grace-period hang
      rcu: Reduce latency of rcu_prepare_for_idle()
      rcu: Remove dynticks false positives and RCU failures
      rcu: Identify dyntick-idle CPUs on first force_quiescent_state() pass
      rcu: Document same-context read-side constraints
      rcu: Permit dyntick-idle with callbacks pending
      rcu: Keep invoking callbacks if CPU otherwise idle
      rcu: Adaptive dyntick-idle preparation
      rcu: Remove redundant rcu_cpu_stall_suppress declaration
      rcu: Make rcutorture test for hotpluggability before offlining CPUs
      rcu: Add rcutorture tests for srcu_read_lock_raw()
      rcu: Augment rcu_batch_end tracing for idle and callback state
      Revert "rcu: Permit rt_mutex_unlock() with irqs disabled"
      rcu: Apply ACCESS_ONCE() to rcu_boost() return value
      cpu: Export cpu_up()

Thomas Gleixner (2):
      rcu: Omit self-awaken when setting up expedited grace period
      rcu: Remove redundant return from rcu_report_exp_rnp()


 Documentation/RCU/checklist.txt          |    6 +
 Documentation/RCU/rcu.txt                |   10 +-
 Documentation/RCU/stallwarn.txt          |   16 +-
 Documentation/RCU/torture.txt            |   13 ++
 Documentation/RCU/trace.txt              |    4 -
 Documentation/RCU/whatisRCU.txt          |   19 ++-
 Documentation/atomic_ops.txt             |   87 +++++++++
 Documentation/lockdep-design.txt         |   63 +++++++
 arch/arm/kernel/process.c                |    6 +-
 arch/avr32/kernel/process.c              |    6 +-
 arch/blackfin/kernel/process.c           |    6 +-
 arch/microblaze/kernel/process.c         |    6 +-
 arch/mips/kernel/process.c               |    6 +-
 arch/openrisc/kernel/idle.c              |    6 +-
 arch/powerpc/kernel/idle.c               |   15 ++-
 arch/powerpc/platforms/iseries/setup.c   |   12 +-
 arch/powerpc/platforms/pseries/lpar.c    |    4 +
 arch/s390/kernel/process.c               |    6 +-
 arch/sh/kernel/idle.c                    |    6 +-
 arch/sparc/kernel/process_64.c           |    6 +-
 arch/sparc/kernel/setup_32.c             |    2 +-
 arch/tile/kernel/process.c               |    6 +-
 arch/tile/mm/fault.c                     |    4 +-
 arch/um/kernel/process.c                 |    6 +-
 arch/unicore32/kernel/process.c          |    6 +-
 arch/x86/kernel/apic/apic.c              |    6 +-
 arch/x86/kernel/apic/io_apic.c           |    2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
 arch/x86/kernel/irq.c                    |    6 +-
 arch/x86/kernel/process_32.c             |    6 +-
 arch/x86/kernel/process_64.c             |   10 +-
 drivers/base/cpu.c                       |    7 +
 include/linux/cpu.h                      |    1 +
 include/linux/hardirq.h                  |   21 ---
 include/linux/rcupdate.h                 |  115 ++++++++-----
 include/linux/sched.h                    |    8 +
 include/linux/srcu.h                     |   87 ++++++++--
 include/linux/tick.h                     |   11 +-
 include/trace/events/rcu.h               |  122 +++++++++++--
 init/Kconfig                             |   10 +-
 kernel/cpu.c                             |    1 +
 kernel/debug/kdb/kdb_support.c           |    2 +-
 kernel/events/core.c                     |    2 +-
 kernel/lockdep.c                         |   22 +++
 kernel/rcu.h                             |    7 +
 kernel/rcupdate.c                        |   12 ++
 kernel/rcutiny.c                         |  149 +++++++++++++--
 kernel/rcutiny_plugin.h                  |   29 +++-
 kernel/rcutorture.c                      |  225 ++++++++++++++++++++++-
 kernel/rcutree.c                         |  290 +++++++++++++++++++++---------
 kernel/rcutree.h                         |   26 ++--
 kernel/rcutree_plugin.h                  |  289 ++++++++++++++++++++++++------
 kernel/rcutree_trace.c                   |   12 +-
 kernel/rtmutex.c                         |    8 -
 kernel/softirq.c                         |    4 +-
 kernel/time/tick-sched.c                 |   97 ++++++----
 kernel/trace/trace.c                     |    1 +
 58 files changed, 1512 insertions(+), 407 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 0c134f8..bff2d8b 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -328,6 +328,12 @@ over a rather long period of time, but improvements are always welcome!
 	RCU rather than SRCU, because RCU is almost always faster and
 	easier to use than is SRCU.
 
+	If you need to enter your read-side critical section in a
+	hardirq or exception handler, and then exit that same read-side
+	critical section in the task that was interrupted, then you need
+	to srcu_read_lock_raw() and srcu_read_unlock_raw(), which avoid
+	the lockdep checking that would otherwise this practice illegal.
+
 	Also unlike other forms of RCU, explicit initialization
 	and cleanup is required via init_srcu_struct() and
 	cleanup_srcu_struct().	These are passed a "struct srcu_struct"
diff --git a/Documentation/RCU/rcu.txt b/Documentation/RCU/rcu.txt
index 3185270..bf77833 100644
--- a/Documentation/RCU/rcu.txt
+++ b/Documentation/RCU/rcu.txt
@@ -38,11 +38,11 @@ o	How can the updater tell when a grace period has completed
 
 	Preemptible variants of RCU (CONFIG_TREE_PREEMPT_RCU) get the
 	same effect, but require that the readers manipulate CPU-local
-	counters.  These counters allow limited types of blocking
-	within RCU read-side critical sections.  SRCU also uses
-	CPU-local counters, and permits general blocking within
-	RCU read-side critical sections.  These two variants of
-	RCU detect grace periods by sampling these counters.
+	counters.  These counters allow limited types of blocking within
+	RCU read-side critical sections.  SRCU also uses CPU-local
+	counters, and permits general blocking within RCU read-side
+	critical sections.  These variants of RCU detect grace periods
+	by sampling these counters.
 
 o	If I am running on a uniprocessor kernel, which can only do one
 	thing at a time, why should I wait for a grace period?
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 4e95920..083d88c 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -101,6 +101,11 @@ o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
 	CONFIG_TREE_PREEMPT_RCU case, you might see stall-warning
 	messages.
 
+o	A hardware or software issue shuts off the scheduler-clock
+	interrupt on a CPU that is not in dyntick-idle mode.  This
+	problem really has happened, and seems to be most likely to
+	result in RCU CPU stall warnings for CONFIG_NO_HZ=n kernels.
+
 o	A bug in the RCU implementation.
 
 o	A hardware failure.  This is quite unlikely, but has occurred
@@ -109,12 +114,11 @@ o	A hardware failure.  This is quite unlikely, but has occurred
 	This resulted in a series of RCU CPU stall warnings, eventually
 	leading the realization that the CPU had failed.
 
-The RCU, RCU-sched, and RCU-bh implementations have CPU stall
-warning.  SRCU does not have its own CPU stall warnings, but its
-calls to synchronize_sched() will result in RCU-sched detecting
-RCU-sched-related CPU stalls.  Please note that RCU only detects
-CPU stalls when there is a grace period in progress.  No grace period,
-no CPU stall warnings.
+The RCU, RCU-sched, and RCU-bh implementations have CPU stall warning.
+SRCU does not have its own CPU stall warnings, but its calls to
+synchronize_sched() will result in RCU-sched detecting RCU-sched-related
+CPU stalls.  Please note that RCU only detects CPU stalls when there is
+a grace period in progress.  No grace period, no CPU stall warnings.
 
 To diagnose the cause of the stall, inspect the stack traces.
 The offending function will usually be near the top of the stack.
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 783d6c1..d67068d 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -61,11 +61,24 @@ nreaders	This is the number of RCU reading threads supported.
 		To properly exercise RCU implementations with preemptible
 		read-side critical sections.
 
+onoff_interval
+		The number of seconds between each attempt to execute a
+		randomly selected CPU-hotplug operation.  Defaults to
+		zero, which disables CPU hotplugging.  In HOTPLUG_CPU=n
+		kernels, rcutorture will silently refuse to do any
+		CPU-hotplug operations regardless of what value is
+		specified for onoff_interval.
+
 shuffle_interval
 		The number of seconds to keep the test threads affinitied
 		to a particular subset of the CPUs, defaults to 3 seconds.
 		Used in conjunction with test_no_idle_hz.
 
+shutdown_secs	The number of seconds to run the test before terminating
+		the test and powering off the system.  The default is
+		zero, which disables test termination and system shutdown.
+		This capability is useful for automated testing.
+
 stat_interval	The number of seconds between output of torture
 		statistics (via printk()).  Regardless of the interval,
 		statistics are printed when the module is unloaded.
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index aaf65f6..49587ab 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -105,14 +105,10 @@ o	"dt" is the current value of the dyntick counter that is incremented
 	or one greater than the interrupt-nesting depth otherwise.
 	The number after the second "/" is the NMI nesting depth.
 
-	This field is displayed only for CONFIG_NO_HZ kernels.
-
 o	"df" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being in
 	dynticks-idle state.
 
-	This field is displayed only for CONFIG_NO_HZ kernels.
-
 o	"of" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being
 	offline.  In a perfect world, this might never happen, but it
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 6ef6926..6bbe8dc 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -4,6 +4,7 @@ to start learning about RCU:
 1.	What is RCU, Fundamentally?  http://lwn.net/Articles/262464/
 2.	What is RCU? Part 2: Usage   http://lwn.net/Articles/263130/
 3.	RCU part 3: the RCU API      http://lwn.net/Articles/264090/
+4.	The RCU API, 2010 Edition    http://lwn.net/Articles/418853/
 
 
 What is RCU?
@@ -834,6 +835,8 @@ SRCU:	Critical sections	Grace period		Barrier
 
 	srcu_read_lock		synchronize_srcu	N/A
 	srcu_read_unlock	synchronize_srcu_expedited
+	srcu_read_lock_raw
+	srcu_read_unlock_raw
 	srcu_dereference
 
 SRCU:	Initialization/cleanup
@@ -855,27 +858,33 @@ list can be helpful:
 
 a.	Will readers need to block?  If so, you need SRCU.
 
-b.	What about the -rt patchset?  If readers would need to block
+b.	Is it necessary to start a read-side critical section in a
+	hardirq handler or exception handler, and then to complete
+	this read-side critical section in the task that was
+	interrupted?  If so, you need SRCU's srcu_read_lock_raw() and
+	srcu_read_unlock_raw() primitives.
+
+c.	What about the -rt patchset?  If readers would need to block
 	in an non-rt kernel, you need SRCU.  If readers would block
 	in a -rt kernel, but not in a non-rt kernel, SRCU is not
 	necessary.
 
-c.	Do you need to treat NMI handlers, hardirq handlers,
+d.	Do you need to treat NMI handlers, hardirq handlers,
 	and code segments with preemption disabled (whether
 	via preempt_disable(), local_irq_save(), local_bh_disable(),
 	or some other mechanism) as if they were explicit RCU readers?
 	If so, you need RCU-sched.
 
-d.	Do you need RCU grace periods to complete even in the face
+e.	Do you need RCU grace periods to complete even in the face
 	of softirq monopolization of one or more of the CPUs?  For
 	example, is your code subject to network-based denial-of-service
 	attacks?  If so, you need RCU-bh.
 
-e.	Is your workload too update-intensive for normal use of
+f.	Is your workload too update-intensive for normal use of
 	RCU, but inappropriate for other synchronization mechanisms?
 	If so, consider SLAB_DESTROY_BY_RCU.  But please be careful!
 
-f.	Otherwise, use RCU.
+g.	Otherwise, use RCU.
 
 Of course, this all assumes that you have determined that RCU is in fact
 the right tool for your job.
diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 3bd585b..27f2b21 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -84,6 +84,93 @@ compiler optimizes the section accessing atomic_t variables.
 
 *** YOU HAVE BEEN WARNED! ***
 
+Properly aligned pointers, longs, ints, and chars (and unsigned
+equivalents) may be atomically loaded from and stored to in the same
+sense as described for atomic_read() and atomic_set().  The ACCESS_ONCE()
+macro should be used to prevent the compiler from using optimizations
+that might otherwise optimize accesses out of existence on the one hand,
+or that might create unsolicited accesses on the other.
+
+For example consider the following code:
+
+	while (a > 0)
+		do_something();
+
+If the compiler can prove that do_something() does not store to the
+variable a, then the compiler is within its rights transforming this to
+the following:
+
+	tmp = a;
+	if (a > 0)
+		for (;;)
+			do_something();
+
+If you don't want the compiler to do this (and you probably don't), then
+you should use something like the following:
+
+	while (ACCESS_ONCE(a) < 0)
+		do_something();
+
+Alternatively, you could place a barrier() call in the loop.
+
+For another example, consider the following code:
+
+	tmp_a = a;
+	do_something_with(tmp_a);
+	do_something_else_with(tmp_a);
+
+If the compiler can prove that do_something_with() does not store to the
+variable a, then the compiler is within its rights to manufacture an
+additional load as follows:
+
+	tmp_a = a;
+	do_something_with(tmp_a);
+	tmp_a = a;
+	do_something_else_with(tmp_a);
+
+This could fatally confuse your code if it expected the same value
+to be passed to do_something_with() and do_something_else_with().
+
+The compiler would be likely to manufacture this additional load if
+do_something_with() was an inline function that made very heavy use
+of registers: reloading from variable a could save a flush to the
+stack and later reload.  To prevent the compiler from attacking your
+code in this manner, write the following:
+
+	tmp_a = ACCESS_ONCE(a);
+	do_something_with(tmp_a);
+	do_something_else_with(tmp_a);
+
+For a final example, consider the following code, assuming that the
+variable a is set at boot time before the second CPU is brought online
+and never changed later, so that memory barriers are not needed:
+
+	if (a)
+		b = 9;
+	else
+		b = 42;
+
+The compiler is within its rights to manufacture an additional store
+by transforming the above code into the following:
+
+	b = 42;
+	if (a)
+		b = 9;
+
+This could come as a fatal surprise to other code running concurrently
+that expected b to never have the value 42 if a was zero.  To prevent
+the compiler from doing this, write something like:
+
+	if (a)
+		ACCESS_ONCE(b) = 9;
+	else
+		ACCESS_ONCE(b) = 42;
+
+Don't even -think- about doing this without proper use of memory barriers,
+locks, or atomic operations if variable a can change at runtime!
+
+*** WARNING: ACCESS_ONCE() DOES NOT IMPLY A BARRIER! ***
+
 Now, we move onto the atomic operation interfaces typically implemented with
 the help of assembly code.
 
diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
index abf768c..5dbc99c 100644
--- a/Documentation/lockdep-design.txt
+++ b/Documentation/lockdep-design.txt
@@ -221,3 +221,66 @@ when the chain is validated for the first time, is then put into a hash
 table, which hash-table can be checked in a lockfree manner. If the
 locking chain occurs again later on, the hash table tells us that we
 dont have to validate the chain again.
+
+Troubleshooting:
+----------------
+
+The validator tracks a maximum of MAX_LOCKDEP_KEYS number of lock classes.
+Exceeding this number will trigger the following lockdep warning:
+
+	(DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
+
+By default, MAX_LOCKDEP_KEYS is currently set to 8191, and typical
+desktop systems have less than 1,000 lock classes, so this warning
+normally results from lock-class leakage or failure to properly
+initialize locks.  These two problems are illustrated below:
+
+1.	Repeated module loading and unloading while running the validator
+	will result in lock-class leakage.  The issue here is that each
+	load of the module will create a new set of lock classes for
+	that module's locks, but module unloading does not remove old
+	classes (see below discussion of reuse of lock classes for why).
+	Therefore, if that module is loaded and unloaded repeatedly,
+	the number of lock classes will eventually reach the maximum.
+
+2.	Using structures such as arrays that have large numbers of
+	locks that are not explicitly initialized.  For example,
+	a hash table with 8192 buckets where each bucket has its own
+	spinlock_t will consume 8192 lock classes -unless- each spinlock
+	is explicitly initialized at runtime, for example, using the
+	run-time spin_lock_init() as opposed to compile-time initializers
+	such as __SPIN_LOCK_UNLOCKED().  Failure to properly initialize
+	the per-bucket spinlocks would guarantee lock-class overflow.
+	In contrast, a loop that called spin_lock_init() on each lock
+	would place all 8192 locks into a single lock class.
+
+	The moral of this story is that you should always explicitly
+	initialize your locks.
+
+One might argue that the validator should be modified to allow
+lock classes to be reused.  However, if you are tempted to make this
+argument, first review the code and think through the changes that would
+be required, keeping in mind that the lock classes to be removed are
+likely to be linked into the lock-dependency graph.  This turns out to
+be harder to do than to say.
+
+Of course, if you do run out of lock classes, the next thing to do is
+to find the offending lock classes.  First, the following command gives
+you the number of lock classes currently in use along with the maximum:
+
+	grep "lock-classes" /proc/lockdep_stats
+
+This command produces the following output on a modest system:
+
+	 lock-classes:                          748 [max: 8191]
+
+If the number allocated (748 above) increases continually over time,
+then there is likely a leak.  The following command can be used to
+identify the leaking lock classes:
+
+	grep "BD" /proc/lockdep
+
+Run the command and save the output, then compare against the output from
+a later run of this command to identify the leakers.  This same output
+can also help you find situations where runtime lock initialization has
+been omitted.
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 3d0c6fb..e8e8fe5 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -183,7 +183,8 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		leds_event(led_idle_start);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
@@ -213,7 +214,8 @@ void cpu_idle(void)
 			}
 		}
 		leds_event(led_idle_end);
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index ef5a2a0..ea33957 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -34,10 +34,12 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched())
 			cpu_idle_sleep();
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 6a80a9e..8dd0416 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -88,10 +88,12 @@ void cpu_idle(void)
 #endif
 		if (!idle)
 			idle = default_idle;
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched())
 			idle();
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 95cc295..7dcb5bf 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -103,10 +103,12 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched())
 			idle();
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index c47f96e..7955409 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -56,7 +56,8 @@ void __noreturn cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched() && cpu_online(cpu)) {
 #ifdef CONFIG_MIPS_MT_SMTC
 			extern void smtc_idle_loop_hook(void);
@@ -77,7 +78,8 @@ void __noreturn cpu_idle(void)
 		     system_state == SYSTEM_BOOTING))
 			play_dead();
 #endif
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
index d5bc5f8..e5fc7887 100644
--- a/arch/openrisc/kernel/idle.c
+++ b/arch/openrisc/kernel/idle.c
@@ -51,7 +51,8 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -69,7 +70,8 @@ void cpu_idle(void)
 			set_thread_flag(TIF_POLLING_NRFLAG);
 		}
 
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 39a2baa..9c3cd49 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -46,6 +46,12 @@ static int __init powersave_off(char *arg)
 }
 __setup("powersave=off", powersave_off);
 
+#if defined(CONFIG_PPC_PSERIES) && defined(CONFIG_TRACEPOINTS)
+static const bool idle_uses_rcu = 1;
+#else
+static const bool idle_uses_rcu;
+#endif
+
 /*
  * The body of the idle task.
  */
@@ -56,7 +62,10 @@ void cpu_idle(void)
 
 	set_thread_flag(TIF_POLLING_NRFLAG);
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		if (!idle_uses_rcu)
+			rcu_idle_enter();
+
 		while (!need_resched() && !cpu_should_die()) {
 			ppc64_runlatch_off();
 
@@ -93,7 +102,9 @@ void cpu_idle(void)
 
 		HMT_medium();
 		ppc64_runlatch_on();
-		tick_nohz_restart_sched_tick();
+		if (!idle_uses_rcu)
+			rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		if (cpu_should_die())
 			cpu_die();
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index ea0acbd..8fc6258 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -563,7 +563,8 @@ static void yield_shared_processor(void)
 static void iseries_shared_idle(void)
 {
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched() && !hvlpevent_is_pending()) {
 			local_irq_disable();
 			ppc64_runlatch_off();
@@ -577,7 +578,8 @@ static void iseries_shared_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 
 		if (hvlpevent_is_pending())
 			process_iSeries_events();
@@ -593,7 +595,8 @@ static void iseries_dedicated_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		if (!need_resched()) {
 			while (!need_resched()) {
 				ppc64_runlatch_off();
@@ -610,7 +613,8 @@ static void iseries_dedicated_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 27a4950..52d429b 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -555,6 +555,8 @@ void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
 
 	(*depth)++;
 	trace_hcall_entry(opcode, args);
+	if (opcode == H_CEDE)
+		rcu_idle_enter();
 	(*depth)--;
 
 out:
@@ -575,6 +577,8 @@ void __trace_hcall_exit(long opcode, unsigned long retval,
 		goto out;
 
 	(*depth)++;
+	if (opcode == H_CEDE)
+		rcu_idle_exit();
 	trace_hcall_exit(opcode, retval, retbuf);
 	(*depth)--;
 
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 9451b21..3201ae4 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -91,10 +91,12 @@ static void default_idle(void)
 void cpu_idle(void)
 {
 	for (;;) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched())
 			default_idle();
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index db4ecd7..406508d 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -89,7 +89,8 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -111,7 +112,8 @@ void cpu_idle(void)
 			start_critical_timings();
 		}
 
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 3739a06..39d8b05 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -95,12 +95,14 @@ void cpu_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while(1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 
 		while (!need_resched() && !cpu_is_offline(cpu))
 			sparc64_yield(cpu);
 
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 
 		preempt_enable_no_resched();
 
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index fe1e3fc..ffb883d 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -84,7 +84,7 @@ static void prom_sync_me(void)
 
 	prom_printf("PROM SYNC COMMAND...\n");
 	show_free_areas(0);
-	if(current->pid != 0) {
+	if (!is_idle_task(current)) {
 		local_irq_enable();
 		sys_sync();
 		local_irq_disable();
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 9c45d8b..4c1ac6e 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -85,7 +85,8 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched()) {
 			if (cpu_is_offline(cpu))
 				BUG();  /* no HOTPLUG_CPU */
@@ -105,7 +106,8 @@ void cpu_idle(void)
 				local_irq_enable();
 			current_thread_info()->status |= TS_POLLING;
 		}
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 25b7b90..c1eaaa1 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -54,7 +54,7 @@ static noinline void force_sig_info_fault(const char *type, int si_signo,
 	if (unlikely(tsk->pid < 2)) {
 		panic("Signal %d (code %d) at %#lx sent to %s!",
 		      si_signo, si_code & 0xffff, address,
-		      tsk->pid ? "init" : "the idle task");
+		      is_idle_task(tsk) ? "the idle task" : "init");
 	}
 
 	info.si_signo = si_signo;
@@ -515,7 +515,7 @@ no_context:
 
 	if (unlikely(tsk->pid < 2)) {
 		panic("Kernel page fault running %s!",
-		      tsk->pid ? "init" : "the idle task");
+		      is_idle_task(tsk) ? "the idle task" : "init");
 	}
 
 	/*
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index c533835..69f2490 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -246,10 +246,12 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		nsecs = disable_timer();
 		idle_sleep(nsecs);
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 	}
 }
 
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index ba401df..52edc2b 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -55,7 +55,8 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched()) {
 			local_irq_disable();
 			stop_critical_timings();
@@ -63,7 +64,8 @@ void cpu_idle(void)
 			local_irq_enable();
 			start_critical_timings();
 		}
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f98d84c..2cd2d93 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -876,8 +876,8 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	local_apic_timer_interrupt();
 	irq_exit();
 
@@ -1809,8 +1809,8 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	u32 v;
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1846,8 +1846,8 @@ void smp_error_interrupt(struct pt_regs *regs)
 		"Illegal register address",	/* APIC Error Bit 7 */
 	};
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6d939d7..8980555 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2421,8 +2421,8 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 	unsigned vector, me;
 
 	ack_APIC_irq();
-	exit_idle();
 	irq_enter();
+	exit_idle();
 
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 787e06c..ce21561 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -397,8 +397,8 @@ static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
 
 asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 {
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
 	irq_exit();
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index d746df2..aa578ca 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -19,8 +19,8 @@ void (*mce_threshold_vector)(void) = default_threshold_interrupt;
 
 asmlinkage void smp_threshold_interrupt(void)
 {
-	exit_idle();
 	irq_enter();
+	exit_idle();
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
 	irq_exit();
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 429e0c9..5d31e5b 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -181,8 +181,8 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	unsigned vector = ~regs->orig_ax;
 	unsigned irq;
 
-	exit_idle();
 	irq_enter();
+	exit_idle();
 
 	irq = __this_cpu_read(vector_irq[vector]);
 
@@ -209,10 +209,10 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 	ack_APIC_irq();
 
-	exit_idle();
-
 	irq_enter();
 
+	exit_idle();
+
 	inc_irq_stat(x86_platform_ipis);
 
 	if (x86_platform_ipi_callback)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 795b79f..485204f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -99,7 +99,8 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched()) {
 
 			check_pgt_cache();
@@ -116,7 +117,8 @@ void cpu_idle(void)
 				pm_idle();
 			start_critical_timings();
 		}
-		tick_nohz_restart_sched_tick();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3bd7e6e..64e926c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -122,7 +122,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched()) {
 
 			rmb();
@@ -139,8 +139,14 @@ void cpu_idle(void)
 			enter_idle();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
+
+			/* enter_idle() needs rcu for notifiers */
+			rcu_idle_enter();
+
 			if (cpuidle_idle_call())
 				pm_idle();
+
+			rcu_idle_exit();
 			start_critical_timings();
 
 			/* In many cases the interrupt that ended idle
@@ -149,7 +155,7 @@ void cpu_idle(void)
 			__exit_idle();
 		}
 
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 251acea..3991502 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -247,6 +247,13 @@ struct sys_device *get_cpu_sysdev(unsigned cpu)
 }
 EXPORT_SYMBOL_GPL(get_cpu_sysdev);
 
+bool cpu_is_hotpluggable(unsigned cpu)
+{
+	struct sys_device *dev = get_cpu_sysdev(cpu);
+	return dev && container_of(dev, struct cpu, sysdev)->hotpluggable;
+}
+EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
+
 int __init cpu_dev_init(void)
 {
 	int err;
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 6cb60fd..305c263 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -27,6 +27,7 @@ struct cpu {
 
 extern int register_cpu(struct cpu *cpu, int num);
 extern struct sys_device *get_cpu_sysdev(unsigned cpu);
+extern bool cpu_is_hotpluggable(unsigned cpu);
 
 extern int cpu_add_sysdev_attr(struct sysdev_attribute *attr);
 extern void cpu_remove_sysdev_attr(struct sysdev_attribute *attr);
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index f743883..bb7f309 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -139,20 +139,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
 extern void account_system_vtime(struct task_struct *tsk);
 #endif
 
-#if defined(CONFIG_NO_HZ)
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
-extern void rcu_enter_nohz(void);
-extern void rcu_exit_nohz(void);
-
-static inline void rcu_irq_enter(void)
-{
-	rcu_exit_nohz();
-}
-
-static inline void rcu_irq_exit(void)
-{
-	rcu_enter_nohz();
-}
 
 static inline void rcu_nmi_enter(void)
 {
@@ -163,17 +150,9 @@ static inline void rcu_nmi_exit(void)
 }
 
 #else
-extern void rcu_irq_enter(void);
-extern void rcu_irq_exit(void);
 extern void rcu_nmi_enter(void);
 extern void rcu_nmi_exit(void);
 #endif
-#else
-# define rcu_irq_enter() do { } while (0)
-# define rcu_irq_exit() do { } while (0)
-# define rcu_nmi_enter() do { } while (0)
-# define rcu_nmi_exit() do { } while (0)
-#endif /* #if defined(CONFIG_NO_HZ) */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2cf4226..81c04f4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -51,6 +51,8 @@ extern int rcutorture_runnable; /* for sysctl */
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 extern void rcutorture_record_test_transition(void);
 extern void rcutorture_record_progress(unsigned long vernum);
+extern void do_trace_rcu_torture_read(char *rcutorturename,
+				      struct rcu_head *rhp);
 #else
 static inline void rcutorture_record_test_transition(void)
 {
@@ -58,6 +60,12 @@ static inline void rcutorture_record_test_transition(void)
 static inline void rcutorture_record_progress(unsigned long vernum)
 {
 }
+#ifdef CONFIG_RCU_TRACE
+extern void do_trace_rcu_torture_read(char *rcutorturename,
+				      struct rcu_head *rhp);
+#else
+#define do_trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#endif
 #endif
 
 #define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
@@ -177,23 +185,10 @@ extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
-
-#ifdef CONFIG_NO_HZ
-
-extern void rcu_enter_nohz(void);
-extern void rcu_exit_nohz(void);
-
-#else /* #ifdef CONFIG_NO_HZ */
-
-static inline void rcu_enter_nohz(void)
-{
-}
-
-static inline void rcu_exit_nohz(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_NO_HZ */
+extern void rcu_idle_enter(void);
+extern void rcu_idle_exit(void);
+extern void rcu_irq_enter(void);
+extern void rcu_irq_exit(void);
 
 /*
  * Infrastructure to implement the synchronize_() primitives in
@@ -233,22 +228,30 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-extern struct lockdep_map rcu_lock_map;
-# define rcu_read_acquire() \
-		lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+#ifdef CONFIG_PROVE_RCU
+extern int rcu_is_cpu_idle(void);
+#else /* !CONFIG_PROVE_RCU */
+static inline int rcu_is_cpu_idle(void)
+{
+	return 0;
+}
+#endif /* else !CONFIG_PROVE_RCU */
 
-extern struct lockdep_map rcu_bh_lock_map;
-# define rcu_read_acquire_bh() \
-		lock_acquire(&rcu_bh_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release_bh()	lock_release(&rcu_bh_lock_map, 1, _THIS_IP_)
+static inline void rcu_lock_acquire(struct lockdep_map *map)
+{
+	WARN_ON_ONCE(rcu_is_cpu_idle());
+	lock_acquire(map, 0, 0, 2, 1, NULL, _THIS_IP_);
+}
 
-extern struct lockdep_map rcu_sched_lock_map;
-# define rcu_read_acquire_sched() \
-		lock_acquire(&rcu_sched_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release_sched() \
-		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
+static inline void rcu_lock_release(struct lockdep_map *map)
+{
+	WARN_ON_ONCE(rcu_is_cpu_idle());
+	lock_release(map, 1, _THIS_IP_);
+}
 
+extern struct lockdep_map rcu_lock_map;
+extern struct lockdep_map rcu_bh_lock_map;
+extern struct lockdep_map rcu_sched_lock_map;
 extern int debug_lockdep_rcu_enabled(void);
 
 /**
@@ -262,11 +265,18 @@ extern int debug_lockdep_rcu_enabled(void);
  *
  * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
+ *
+ * Note that rcu_read_lock() and the matching rcu_read_unlock() must
+ * occur in the same context, for example, it is illegal to invoke
+ * rcu_read_unlock() in process context if the matching rcu_read_lock()
+ * was invoked from within an irq handler.
  */
 static inline int rcu_read_lock_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+	if (rcu_is_cpu_idle())
+		return 0;
 	return lock_is_held(&rcu_lock_map);
 }
 
@@ -290,6 +300,19 @@ extern int rcu_read_lock_bh_held(void);
  *
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
+ *
+ * Note that if the CPU is in the idle loop from an RCU point of
+ * view (ie: that we are in the section between rcu_idle_enter() and
+ * rcu_idle_exit()) then rcu_read_lock_held() returns false even if the CPU
+ * did an rcu_read_lock().  The reason for this is that RCU ignores CPUs
+ * that are in such a section, considering these as in extended quiescent
+ * state, so such a CPU is effectively never in an RCU read-side critical
+ * section regardless of what RCU primitives it invokes.  This state of
+ * affairs is required --- we need to keep an RCU-free window in idle
+ * where the CPU may possibly enter into low power mode. This way we can
+ * notice an extended quiescent state to other CPUs that started a grace
+ * period. Otherwise we would delay any grace period as long as we run in
+ * the idle task.
  */
 #ifdef CONFIG_PREEMPT_COUNT
 static inline int rcu_read_lock_sched_held(void)
@@ -298,6 +321,8 @@ static inline int rcu_read_lock_sched_held(void)
 
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+	if (rcu_is_cpu_idle())
+		return 0;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
@@ -311,12 +336,8 @@ static inline int rcu_read_lock_sched_held(void)
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
-# define rcu_read_acquire()		do { } while (0)
-# define rcu_read_release()		do { } while (0)
-# define rcu_read_acquire_bh()		do { } while (0)
-# define rcu_read_release_bh()		do { } while (0)
-# define rcu_read_acquire_sched()	do { } while (0)
-# define rcu_read_release_sched()	do { } while (0)
+# define rcu_lock_acquire(a)		do { } while (0)
+# define rcu_lock_release(a)		do { } while (0)
 
 static inline int rcu_read_lock_held(void)
 {
@@ -637,7 +658,7 @@ static inline void rcu_read_lock(void)
 {
 	__rcu_read_lock();
 	__acquire(RCU);
-	rcu_read_acquire();
+	rcu_lock_acquire(&rcu_lock_map);
 }
 
 /*
@@ -657,7 +678,7 @@ static inline void rcu_read_lock(void)
  */
 static inline void rcu_read_unlock(void)
 {
-	rcu_read_release();
+	rcu_lock_release(&rcu_lock_map);
 	__release(RCU);
 	__rcu_read_unlock();
 }
@@ -673,12 +694,17 @@ static inline void rcu_read_unlock(void)
  * critical sections in interrupt context can use just rcu_read_lock(),
  * though this should at least be commented to avoid confusing people
  * reading the code.
+ *
+ * Note that rcu_read_lock_bh() and the matching rcu_read_unlock_bh()
+ * must occur in the same context, for example, it is illegal to invoke
+ * rcu_read_unlock_bh() from one task if the matching rcu_read_lock_bh()
+ * was invoked from some other task.
  */
 static inline void rcu_read_lock_bh(void)
 {
 	local_bh_disable();
 	__acquire(RCU_BH);
-	rcu_read_acquire_bh();
+	rcu_lock_acquire(&rcu_bh_lock_map);
 }
 
 /*
@@ -688,7 +714,7 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
-	rcu_read_release_bh();
+	rcu_lock_release(&rcu_bh_lock_map);
 	__release(RCU_BH);
 	local_bh_enable();
 }
@@ -700,12 +726,17 @@ static inline void rcu_read_unlock_bh(void)
  * are being done using call_rcu_sched() or synchronize_rcu_sched().
  * Read-side critical sections can also be introduced by anything that
  * disables preemption, including local_irq_disable() and friends.
+ *
+ * Note that rcu_read_lock_sched() and the matching rcu_read_unlock_sched()
+ * must occur in the same context, for example, it is illegal to invoke
+ * rcu_read_unlock_sched() from process context if the matching
+ * rcu_read_lock_sched() was invoked from an NMI handler.
  */
 static inline void rcu_read_lock_sched(void)
 {
 	preempt_disable();
 	__acquire(RCU_SCHED);
-	rcu_read_acquire_sched();
+	rcu_lock_acquire(&rcu_sched_lock_map);
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -722,7 +753,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
-	rcu_read_release_sched();
+	rcu_lock_release(&rcu_sched_lock_map);
 	__release(RCU_SCHED);
 	preempt_enable();
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c4f3e9..4a7e4d3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2070,6 +2070,14 @@ extern int sched_setscheduler(struct task_struct *, int,
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
 extern struct task_struct *idle_task(int cpu);
+/**
+ * is_idle_task - is the specified task an idle task?
+ * @tsk: the task in question.
+ */
+static inline bool is_idle_task(struct task_struct *p)
+{
+	return p->pid == 0;
+}
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
 
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 58971e8..e1b0059 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -28,6 +28,7 @@
 #define _LINUX_SRCU_H
 
 #include <linux/mutex.h>
+#include <linux/rcupdate.h>
 
 struct srcu_struct_array {
 	int c[2];
@@ -60,18 +61,10 @@ int __init_srcu_struct(struct srcu_struct *sp, const char *name,
 	__init_srcu_struct((sp), #sp, &__srcu_key); \
 })
 
-# define srcu_read_acquire(sp) \
-		lock_acquire(&(sp)->dep_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define srcu_read_release(sp) \
-		lock_release(&(sp)->dep_map, 1, _THIS_IP_)
-
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 int init_srcu_struct(struct srcu_struct *sp);
 
-# define srcu_read_acquire(sp)  do { } while (0)
-# define srcu_read_release(sp)  do { } while (0)
-
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 void cleanup_srcu_struct(struct srcu_struct *sp);
@@ -90,12 +83,32 @@ long srcu_batches_completed(struct srcu_struct *sp);
  * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
  * this assumes we are in an SRCU read-side critical section unless it can
  * prove otherwise.
+ *
+ * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * and while lockdep is disabled.
+ *
+ * Note that if the CPU is in the idle loop from an RCU point of view
+ * (ie: that we are in the section between rcu_idle_enter() and
+ * rcu_idle_exit()) then srcu_read_lock_held() returns false even if
+ * the CPU did an srcu_read_lock().  The reason for this is that RCU
+ * ignores CPUs that are in such a section, considering these as in
+ * extended quiescent state, so such a CPU is effectively never in an
+ * RCU read-side critical section regardless of what RCU primitives it
+ * invokes.  This state of affairs is required --- we need to keep an
+ * RCU-free window in idle where the CPU may possibly enter into low
+ * power mode. This way we can notice an extended quiescent state to
+ * other CPUs that started a grace period. Otherwise we would delay any
+ * grace period as long as we run in the idle task.
  */
 static inline int srcu_read_lock_held(struct srcu_struct *sp)
 {
-	if (debug_locks)
-		return lock_is_held(&sp->dep_map);
-	return 1;
+	if (rcu_is_cpu_idle())
+		return 0;
+
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+
+	return lock_is_held(&sp->dep_map);
 }
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
@@ -145,12 +158,17 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
  * one way to indirectly wait on an SRCU grace period is to acquire
  * a mutex that is held elsewhere while calling synchronize_srcu() or
  * synchronize_srcu_expedited().
+ *
+ * Note that srcu_read_lock() and the matching srcu_read_unlock() must
+ * occur in the same context, for example, it is illegal to invoke
+ * srcu_read_unlock() in an irq handler if the matching srcu_read_lock()
+ * was invoked in process context.
  */
 static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 {
 	int retval = __srcu_read_lock(sp);
 
-	srcu_read_acquire(sp);
+	rcu_lock_acquire(&(sp)->dep_map);
 	return retval;
 }
 
@@ -164,8 +182,51 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__releases(sp)
 {
-	srcu_read_release(sp);
+	rcu_lock_release(&(sp)->dep_map);
+	__srcu_read_unlock(sp, idx);
+}
+
+/**
+ * srcu_read_lock_raw - register a new reader for an SRCU-protected structure.
+ * @sp: srcu_struct in which to register the new reader.
+ *
+ * Enter an SRCU read-side critical section.  Similar to srcu_read_lock(),
+ * but avoids the RCU-lockdep checking.  This means that it is legal to
+ * use srcu_read_lock_raw() in one context, for example, in an exception
+ * handler, and then have the matching srcu_read_unlock_raw() in another
+ * context, for example in the task that took the exception.
+ *
+ * However, the entire SRCU read-side critical section must reside within a
+ * single task.  For example, beware of using srcu_read_lock_raw() in
+ * a device interrupt handler and srcu_read_unlock() in the interrupted
+ * task:  This will not work if interrupts are threaded.
+ */
+static inline int srcu_read_lock_raw(struct srcu_struct *sp)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+	ret =  __srcu_read_lock(sp);
+	local_irq_restore(flags);
+	return ret;
+}
+
+/**
+ * srcu_read_unlock_raw - unregister reader from an SRCU-protected structure.
+ * @sp: srcu_struct in which to unregister the old reader.
+ * @idx: return value from corresponding srcu_read_lock_raw().
+ *
+ * Exit an SRCU read-side critical section without lockdep-RCU checking.
+ * See srcu_read_lock_raw() for more details.
+ */
+static inline void srcu_read_unlock_raw(struct srcu_struct *sp, int idx)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__srcu_read_unlock(sp, idx);
+	local_irq_restore(flags);
 }
 
 #endif
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..ab8be90 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -7,6 +7,7 @@
 #define _LINUX_TICK_H
 
 #include <linux/clockchips.h>
+#include <linux/irqflags.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -121,14 +122,16 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
-extern void tick_nohz_stop_sched_tick(int inidle);
-extern void tick_nohz_restart_sched_tick(void);
+extern void tick_nohz_idle_enter(void);
+extern void tick_nohz_idle_exit(void);
+extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
-static inline void tick_nohz_stop_sched_tick(int inidle) { }
-static inline void tick_nohz_restart_sched_tick(void) { }
+static inline void tick_nohz_idle_enter(void) { }
+static inline void tick_nohz_idle_exit(void) { }
+
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
 	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 669fbd6..d2d88be 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -241,24 +241,73 @@ TRACE_EVENT(rcu_fqs,
 
 /*
  * Tracepoint for dyntick-idle entry/exit events.  These take a string
- * as argument: "Start" for entering dyntick-idle mode and "End" for
- * leaving it.
+ * as argument: "Start" for entering dyntick-idle mode, "End" for
+ * leaving it, "--=" for events moving towards idle, and "++=" for events
+ * moving away from idle.  "Error on entry: not idle task" and "Error on
+ * exit: not idle task" indicate that a non-idle task is erroneously
+ * toying with the idle loop.
+ *
+ * These events also take a pair of numbers, which indicate the nesting
+ * depth before and after the event of interest.  Note that task-related
+ * events use the upper bits of each number, while interrupt-related
+ * events use the lower bits.
  */
 TRACE_EVENT(rcu_dyntick,
 
-	TP_PROTO(char *polarity),
+	TP_PROTO(char *polarity, long long oldnesting, long long newnesting),
 
-	TP_ARGS(polarity),
+	TP_ARGS(polarity, oldnesting, newnesting),
 
 	TP_STRUCT__entry(
 		__field(char *, polarity)
+		__field(long long, oldnesting)
+		__field(long long, newnesting)
 	),
 
 	TP_fast_assign(
 		__entry->polarity = polarity;
+		__entry->oldnesting = oldnesting;
+		__entry->newnesting = newnesting;
+	),
+
+	TP_printk("%s %llx %llx", __entry->polarity,
+		  __entry->oldnesting, __entry->newnesting)
+);
+
+/*
+ * Tracepoint for RCU preparation for idle, the goal being to get RCU
+ * processing done so that the current CPU can shut off its scheduling
+ * clock and enter dyntick-idle mode.  One way to accomplish this is
+ * to drain all RCU callbacks from this CPU, and the other is to have
+ * done everything RCU requires for the current grace period.  In this
+ * latter case, the CPU will be awakened at the end of the current grace
+ * period in order to process the remainder of its callbacks.
+ *
+ * These tracepoints take a string as argument:
+ *
+ *	"No callbacks": Nothing to do, no callbacks on this CPU.
+ *	"In holdoff": Nothing to do, holding off after unsuccessful attempt.
+ *	"Begin holdoff": Attempt failed, don't retry until next jiffy.
+ *	"Dyntick with callbacks": Entering dyntick-idle despite callbacks.
+ *	"More callbacks": Still more callbacks, try again to clear them out.
+ *	"Callbacks drained": All callbacks processed, off to dyntick idle!
+ *	"Timer": Timer fired to cause CPU to continue processing callbacks.
+ */
+TRACE_EVENT(rcu_prep_idle,
+
+	TP_PROTO(char *reason),
+
+	TP_ARGS(reason),
+
+	TP_STRUCT__entry(
+		__field(char *, reason)
+	),
+
+	TP_fast_assign(
+		__entry->reason = reason;
 	),
 
-	TP_printk("%s", __entry->polarity)
+	TP_printk("%s", __entry->reason)
 );
 
 /*
@@ -412,27 +461,71 @@ TRACE_EVENT(rcu_invoke_kfree_callback,
 
 /*
  * Tracepoint for exiting rcu_do_batch after RCU callbacks have been
- * invoked.  The first argument is the name of the RCU flavor and
- * the second argument is number of callbacks actually invoked.
+ * invoked.  The first argument is the name of the RCU flavor,
+ * the second argument is number of callbacks actually invoked,
+ * the third argument (cb) is whether or not any of the callbacks that
+ * were ready to invoke at the beginning of this batch are still
+ * queued, the fourth argument (nr) is the return value of need_resched(),
+ * the fifth argument (iit) is 1 if the current task is the idle task,
+ * and the sixth argument (risk) is the return value from
+ * rcu_is_callbacks_kthread().
  */
 TRACE_EVENT(rcu_batch_end,
 
-	TP_PROTO(char *rcuname, int callbacks_invoked),
+	TP_PROTO(char *rcuname, int callbacks_invoked,
+		 bool cb, bool nr, bool iit, bool risk),
 
-	TP_ARGS(rcuname, callbacks_invoked),
+	TP_ARGS(rcuname, callbacks_invoked, cb, nr, iit, risk),
 
 	TP_STRUCT__entry(
 		__field(char *, rcuname)
 		__field(int, callbacks_invoked)
+		__field(bool, cb)
+		__field(bool, nr)
+		__field(bool, iit)
+		__field(bool, risk)
 	),
 
 	TP_fast_assign(
 		__entry->rcuname = rcuname;
 		__entry->callbacks_invoked = callbacks_invoked;
+		__entry->cb = cb;
+		__entry->nr = nr;
+		__entry->iit = iit;
+		__entry->risk = risk;
+	),
+
+	TP_printk("%s CBs-invoked=%d idle=%c%c%c%c",
+		  __entry->rcuname, __entry->callbacks_invoked,
+		  __entry->cb ? 'C' : '.',
+		  __entry->nr ? 'S' : '.',
+		  __entry->iit ? 'I' : '.',
+		  __entry->risk ? 'R' : '.')
+);
+
+/*
+ * Tracepoint for rcutorture readers.  The first argument is the name
+ * of the RCU flavor from rcutorture's viewpoint and the second argument
+ * is the callback address.
+ */
+TRACE_EVENT(rcu_torture_read,
+
+	TP_PROTO(char *rcutorturename, struct rcu_head *rhp),
+
+	TP_ARGS(rcutorturename, rhp),
+
+	TP_STRUCT__entry(
+		__field(char *, rcutorturename)
+		__field(struct rcu_head *, rhp)
+	),
+
+	TP_fast_assign(
+		__entry->rcutorturename = rcutorturename;
+		__entry->rhp = rhp;
 	),
 
-	TP_printk("%s CBs-invoked=%d",
-		  __entry->rcuname, __entry->callbacks_invoked)
+	TP_printk("%s torture read %p",
+		  __entry->rcutorturename, __entry->rhp)
 );
 
 #else /* #ifdef CONFIG_RCU_TRACE */
@@ -443,13 +536,16 @@ TRACE_EVENT(rcu_batch_end,
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks) do { } while (0)
 #define trace_rcu_fqs(rcuname, gpnum, cpu, qsevent) do { } while (0)
-#define trace_rcu_dyntick(polarity) do { } while (0)
+#define trace_rcu_dyntick(polarity, oldnesting, newnesting) do { } while (0)
+#define trace_rcu_prep_idle(reason) do { } while (0)
 #define trace_rcu_callback(rcuname, rhp, qlen) do { } while (0)
 #define trace_rcu_kfree_callback(rcuname, rhp, offset, qlen) do { } while (0)
 #define trace_rcu_batch_start(rcuname, qlen, blimit) do { } while (0)
 #define trace_rcu_invoke_callback(rcuname, rhp) do { } while (0)
 #define trace_rcu_invoke_kfree_callback(rcuname, rhp, offset) do { } while (0)
-#define trace_rcu_batch_end(rcuname, callbacks_invoked) do { } while (0)
+#define trace_rcu_batch_end(rcuname, callbacks_invoked, cb, nr, iit, risk) \
+	do { } while (0)
+#define trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
diff --git a/init/Kconfig b/init/Kconfig
index 43298f9..82b6a4c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -469,14 +469,14 @@ config RCU_FANOUT_EXACT
 
 config RCU_FAST_NO_HZ
 	bool "Accelerate last non-dyntick-idle CPU's grace periods"
-	depends on TREE_RCU && NO_HZ && SMP
+	depends on NO_HZ && SMP
 	default n
 	help
 	  This option causes RCU to attempt to accelerate grace periods
-	  in order to allow the final CPU to enter dynticks-idle state
-	  more quickly.  On the other hand, this option increases the
-	  overhead of the dynticks-idle checking, particularly on systems
-	  with large numbers of CPUs.
+	  in order to allow CPUs to enter dynticks-idle state more
+	  quickly.  On the other hand, this option increases the overhead
+	  of the dynticks-idle checking, particularly on systems with
+	  large numbers of CPUs.
 
 	  Say Y if energy efficiency is critically important, particularly
 	  	if you have relatively few CPUs.
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 563f136..9d448dd 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -380,6 +380,7 @@ out:
 	cpu_maps_update_done();
 	return err;
 }
+EXPORT_SYMBOL_GPL(cpu_up);
 
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;
diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
index 5532dd3..7d6fb40 100644
--- a/kernel/debug/kdb/kdb_support.c
+++ b/kernel/debug/kdb/kdb_support.c
@@ -636,7 +636,7 @@ char kdb_task_state_char (const struct task_struct *p)
 		(p->exit_state & EXIT_ZOMBIE) ? 'Z' :
 		(p->exit_state & EXIT_DEAD) ? 'E' :
 		(p->state & TASK_INTERRUPTIBLE) ? 'S' : '?';
-	if (p->pid == 0) {
+	if (is_idle_task(p)) {
 		/* Idle task.  Is it really idle, apart from the kdb
 		 * interrupt? */
 		if (!kdb_task_has_cpu(p) || kgdb_info[cpu].irq_depth == 1) {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d3b9df5..923c6b5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5362,7 +5362,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	regs = get_irq_regs();
 
 	if (regs && !perf_exclude_event(event, regs)) {
-		if (!(event->attr.exclude_idle && current->pid == 0))
+		if (!(event->attr.exclude_idle && is_idle_task(current)))
 			if (perf_event_overflow(event, &data, regs))
 				ret = HRTIMER_NORESTART;
 	}
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index b2e08c9..f45c681 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4170,6 +4170,28 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	printk("%s:%d %s!\n", file, line, s);
 	printk("\nother info that might help us debug this:\n\n");
 	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
+
+	/*
+	 * If a CPU is in the RCU-free window in idle (ie: in the section
+	 * between rcu_idle_enter() and rcu_idle_exit(), then RCU
+	 * considers that CPU to be in an "extended quiescent state",
+	 * which means that RCU will be completely ignoring that CPU.
+	 * Therefore, rcu_read_lock() and friends have absolutely no
+	 * effect on a CPU running in that state. In other words, even if
+	 * such an RCU-idle CPU has called rcu_read_lock(), RCU might well
+	 * delete data structures out from under it.  RCU really has no
+	 * choice here: we need to keep an RCU-free window in idle where
+	 * the CPU may possibly enter into low power mode. This way we can
+	 * notice an extended quiescent state to other CPUs that started a grace
+	 * period. Otherwise we would delay any grace period as long as we run
+	 * in the idle task.
+	 *
+	 * So complain bitterly if someone does call rcu_read_lock(),
+	 * rcu_read_lock_bh() and so on from extended quiescent states.
+	 */
+	if (rcu_is_cpu_idle())
+		printk("RCU used illegally from extended quiescent state!\n");
+
 	lockdep_print_held_locks(curr);
 	printk("\nstack backtrace:\n");
 	dump_stack();
diff --git a/kernel/rcu.h b/kernel/rcu.h
index f600868..aa88baa 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -30,6 +30,13 @@
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
 /*
+ * Process-level increment to ->dynticks_nesting field.  This allows for
+ * architectures that use half-interrupts and half-exceptions from
+ * process context.
+ */
+#define DYNTICK_TASK_NESTING (LLONG_MAX / 2 - 1)
+
+/*
  * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
  * by call_rcu() and rcu callback execution, and are therefore not part of the
  * RCU API. Leaving in rcupdate.h because they are used by all RCU flavors.
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index c5b98e5..2bc4e13 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -93,6 +93,8 @@ int rcu_read_lock_bh_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+	if (rcu_is_cpu_idle())
+		return 0;
 	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
@@ -316,3 +318,13 @@ struct debug_obj_descr rcuhead_debug_descr = {
 };
 EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
 #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) || defined(CONFIG_RCU_TRACE)
+void do_trace_rcu_torture_read(char *rcutorturename, struct rcu_head *rhp)
+{
+	trace_rcu_torture_read(rcutorturename, rhp);
+}
+EXPORT_SYMBOL_GPL(do_trace_rcu_torture_read);
+#else
+#define do_trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#endif
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 636af6d..977296d 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -53,31 +53,137 @@ static void __call_rcu(struct rcu_head *head,
 
 #include "rcutiny_plugin.h"
 
-#ifdef CONFIG_NO_HZ
+static long long rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
 
-static long rcu_dynticks_nesting = 1;
+/* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
+static void rcu_idle_enter_common(long long oldval)
+{
+	if (rcu_dynticks_nesting) {
+		RCU_TRACE(trace_rcu_dyntick("--=",
+					    oldval, rcu_dynticks_nesting));
+		return;
+	}
+	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
+	if (!is_idle_task(current)) {
+		struct task_struct *idle = idle_task(smp_processor_id());
+
+		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
+					    oldval, rcu_dynticks_nesting));
+		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
+	}
+	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
+}
 
 /*
- * Enter dynticks-idle mode, which is an extended quiescent state
- * if we have fully entered that mode (i.e., if the new value of
- * dynticks_nesting is zero).
+ * Enter idle, which is an extended quiescent state if we have fully
+ * entered that mode (i.e., if the new value of dynticks_nesting is zero).
  */
-void rcu_enter_nohz(void)
+void rcu_idle_enter(void)
 {
-	if (--rcu_dynticks_nesting == 0)
-		rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
+	unsigned long flags;
+	long long oldval;
+
+	local_irq_save(flags);
+	oldval = rcu_dynticks_nesting;
+	rcu_dynticks_nesting = 0;
+	rcu_idle_enter_common(oldval);
+	local_irq_restore(flags);
 }
 
 /*
- * Exit dynticks-idle mode, so that we are no longer in an extended
- * quiescent state.
+ * Exit an interrupt handler towards idle.
  */
-void rcu_exit_nohz(void)
+void rcu_irq_exit(void)
+{
+	unsigned long flags;
+	long long oldval;
+
+	local_irq_save(flags);
+	oldval = rcu_dynticks_nesting;
+	rcu_dynticks_nesting--;
+	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
+	rcu_idle_enter_common(oldval);
+	local_irq_restore(flags);
+}
+
+/* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcutree.c. */
+static void rcu_idle_exit_common(long long oldval)
 {
+	if (oldval) {
+		RCU_TRACE(trace_rcu_dyntick("++=",
+					    oldval, rcu_dynticks_nesting));
+		return;
+	}
+	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
+	if (!is_idle_task(current)) {
+		struct task_struct *idle = idle_task(smp_processor_id());
+
+		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
+			  oldval, rcu_dynticks_nesting));
+		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
+	}
+}
+
+/*
+ * Exit idle, so that we are no longer in an extended quiescent state.
+ */
+void rcu_idle_exit(void)
+{
+	unsigned long flags;
+	long long oldval;
+
+	local_irq_save(flags);
+	oldval = rcu_dynticks_nesting;
+	WARN_ON_ONCE(oldval != 0);
+	rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
+	rcu_idle_exit_common(oldval);
+	local_irq_restore(flags);
+}
+
+/*
+ * Enter an interrupt handler, moving away from idle.
+ */
+void rcu_irq_enter(void)
+{
+	unsigned long flags;
+	long long oldval;
+
+	local_irq_save(flags);
+	oldval = rcu_dynticks_nesting;
 	rcu_dynticks_nesting++;
+	WARN_ON_ONCE(rcu_dynticks_nesting == 0);
+	rcu_idle_exit_common(oldval);
+	local_irq_restore(flags);
+}
+
+#ifdef CONFIG_PROVE_RCU
+
+/*
+ * Test whether RCU thinks that the current CPU is idle.
+ */
+int rcu_is_cpu_idle(void)
+{
+	return !rcu_dynticks_nesting;
 }
+EXPORT_SYMBOL(rcu_is_cpu_idle);
+
+#endif /* #ifdef CONFIG_PROVE_RCU */
 
-#endif /* #ifdef CONFIG_NO_HZ */
+/*
+ * Test whether the current CPU was interrupted from idle.  Nested
+ * interrupts don't count, we must be running at the first interrupt
+ * level.
+ */
+int rcu_is_cpu_rrupt_from_idle(void)
+{
+	return rcu_dynticks_nesting <= 0;
+}
 
 /*
  * Helper function for rcu_sched_qs() and rcu_bh_qs().
@@ -126,14 +232,13 @@ void rcu_bh_qs(int cpu)
 
 /*
  * Check to see if the scheduling-clock interrupt came from an extended
- * quiescent state, and, if so, tell RCU about it.
+ * quiescent state, and, if so, tell RCU about it.  This function must
+ * be called from hardirq context.  It is normally called from the
+ * scheduling-clock interrupt.
  */
 void rcu_check_callbacks(int cpu, int user)
 {
-	if (user ||
-	    (idle_cpu(cpu) &&
-	     !in_softirq() &&
-	     hardirq_count() <= (1 << HARDIRQ_SHIFT)))
+	if (user || rcu_is_cpu_rrupt_from_idle())
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
 		rcu_bh_qs(cpu);
@@ -154,7 +259,11 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	/* If no RCU callbacks ready to invoke, just return. */
 	if (&rcp->rcucblist == rcp->donetail) {
 		RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, -1));
-		RCU_TRACE(trace_rcu_batch_end(rcp->name, 0));
+		RCU_TRACE(trace_rcu_batch_end(rcp->name, 0,
+					      ACCESS_ONCE(rcp->rcucblist),
+					      need_resched(),
+					      is_idle_task(current),
+					      rcu_is_callbacks_kthread()));
 		return;
 	}
 
@@ -183,7 +292,9 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		RCU_TRACE(cb_count++);
 	}
 	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
-	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count));
+	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count, 0, need_resched(),
+				      is_idle_task(current),
+				      rcu_is_callbacks_kthread()));
 }
 
 static void rcu_process_callbacks(struct softirq_action *unused)
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 2b0484a..9cb1ae4 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -312,8 +312,8 @@ static int rcu_boost(void)
 	rt_mutex_lock(&mtx);
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
 
-	return rcu_preempt_ctrlblk.boost_tasks != NULL ||
-	       rcu_preempt_ctrlblk.exp_tasks != NULL;
+	return ACCESS_ONCE(rcu_preempt_ctrlblk.boost_tasks) != NULL ||
+	       ACCESS_ONCE(rcu_preempt_ctrlblk.exp_tasks) != NULL;
 }
 
 /*
@@ -885,6 +885,19 @@ static void invoke_rcu_callbacks(void)
 	wake_up(&rcu_kthread_wq);
 }
 
+#ifdef CONFIG_RCU_TRACE
+
+/*
+ * Is the current CPU running the RCU-callbacks kthread?
+ * Caller must have preemption disabled.
+ */
+static bool rcu_is_callbacks_kthread(void)
+{
+	return rcu_kthread_task == current;
+}
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
 /*
  * This kthread invokes RCU callbacks whose grace periods have
  * elapsed.  It is awakened as needed, and takes the place of the
@@ -938,6 +951,18 @@ void invoke_rcu_callbacks(void)
 	raise_softirq(RCU_SOFTIRQ);
 }
 
+#ifdef CONFIG_RCU_TRACE
+
+/*
+ * There is no callback kthread, so this thread is never it.
+ */
+static bool rcu_is_callbacks_kthread(void)
+{
+	return false;
+}
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
 void rcu_init(void)
 {
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 764825c..88f17b8 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -61,9 +61,11 @@ static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
 static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
 static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static int irqreader = 1;	/* RCU readers from irq (timers). */
-static int fqs_duration = 0;	/* Duration of bursts (us), 0 to disable. */
-static int fqs_holdoff = 0;	/* Hold time within burst (us). */
+static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
+static int fqs_holdoff;		/* Hold time within burst (us). */
 static int fqs_stutter = 3;	/* Wait time between bursts (s). */
+static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
+static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
 static int test_boost = 1;	/* Test RCU prio boost: 0=no, 1=maybe, 2=yes. */
 static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
 static int test_boost_duration = 4; /* Duration of each boost test, seconds. */
@@ -91,6 +93,10 @@ module_param(fqs_holdoff, int, 0444);
 MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
 module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
+module_param(onoff_interval, int, 0444);
+MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
+module_param(shutdown_secs, int, 0444);
+MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), zero to disable.");
 module_param(test_boost, int, 0444);
 MODULE_PARM_DESC(test_boost, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
 module_param(test_boost_interval, int, 0444);
@@ -119,6 +125,10 @@ static struct task_struct *shuffler_task;
 static struct task_struct *stutter_task;
 static struct task_struct *fqs_task;
 static struct task_struct *boost_tasks[NR_CPUS];
+static struct task_struct *shutdown_task;
+#ifdef CONFIG_HOTPLUG_CPU
+static struct task_struct *onoff_task;
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -149,6 +159,10 @@ static long n_rcu_torture_boost_rterror;
 static long n_rcu_torture_boost_failure;
 static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
+static long n_offline_attempts;
+static long n_offline_successes;
+static long n_online_attempts;
+static long n_online_successes;
 static struct list_head rcu_torture_removed;
 static cpumask_var_t shuffle_tmp_mask;
 
@@ -160,6 +174,8 @@ static int stutter_pause_test;
 #define RCUTORTURE_RUNNABLE_INIT 0
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
+module_param(rcutorture_runnable, int, 0444);
+MODULE_PARM_DESC(rcutorture_runnable, "Start rcutorture at boot");
 
 #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU)
 #define rcu_can_boost() 1
@@ -167,6 +183,7 @@ int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 #define rcu_can_boost() 0
 #endif /* #else #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
 
+static unsigned long shutdown_time;	/* jiffies to system shutdown. */
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
 DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
 					/*  and boost task create/destroy. */
@@ -182,6 +199,9 @@ static int fullstop = FULLSTOP_RMMOD;
  */
 static DEFINE_MUTEX(fullstop_mutex);
 
+/* Forward reference. */
+static void rcu_torture_cleanup(void);
+
 /*
  * Detect and respond to a system shutdown.
  */
@@ -612,6 +632,30 @@ static struct rcu_torture_ops srcu_ops = {
 	.name		= "srcu"
 };
 
+static int srcu_torture_read_lock_raw(void) __acquires(&srcu_ctl)
+{
+	return srcu_read_lock_raw(&srcu_ctl);
+}
+
+static void srcu_torture_read_unlock_raw(int idx) __releases(&srcu_ctl)
+{
+	srcu_read_unlock_raw(&srcu_ctl, idx);
+}
+
+static struct rcu_torture_ops srcu_raw_ops = {
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock_raw,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock_raw,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu_raw"
+};
+
 static void srcu_torture_synchronize_expedited(void)
 {
 	synchronize_srcu_expedited(&srcu_ctl);
@@ -913,6 +957,18 @@ rcu_torture_fakewriter(void *arg)
 	return 0;
 }
 
+void rcutorture_trace_dump(void)
+{
+	static atomic_t beenhere = ATOMIC_INIT(0);
+
+	if (atomic_read(&beenhere))
+		return;
+	if (atomic_xchg(&beenhere, 1) != 0)
+		return;
+	do_trace_rcu_torture_read(cur_ops->name, (struct rcu_head *)~0UL);
+	ftrace_dump(DUMP_ALL);
+}
+
 /*
  * RCU torture reader from timer handler.  Dereferences rcu_torture_current,
  * incrementing the corresponding element of the pipeline array.  The
@@ -934,6 +990,7 @@ static void rcu_torture_timer(unsigned long unused)
 				  rcu_read_lock_bh_held() ||
 				  rcu_read_lock_sched_held() ||
 				  srcu_read_lock_held(&srcu_ctl));
+	do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 	if (p == NULL) {
 		/* Leave because rcu_torture_writer is not yet underway */
 		cur_ops->readunlock(idx);
@@ -951,6 +1008,8 @@ static void rcu_torture_timer(unsigned long unused)
 		/* Should not happen, but... */
 		pipe_count = RCU_TORTURE_PIPE_LEN;
 	}
+	if (pipe_count > 1)
+		rcutorture_trace_dump();
 	__this_cpu_inc(rcu_torture_count[pipe_count]);
 	completed = cur_ops->completed() - completed;
 	if (completed > RCU_TORTURE_PIPE_LEN) {
@@ -994,6 +1053,7 @@ rcu_torture_reader(void *arg)
 					  rcu_read_lock_bh_held() ||
 					  rcu_read_lock_sched_held() ||
 					  srcu_read_lock_held(&srcu_ctl));
+		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 		if (p == NULL) {
 			/* Wait for rcu_torture_writer to get underway */
 			cur_ops->readunlock(idx);
@@ -1009,6 +1069,8 @@ rcu_torture_reader(void *arg)
 			/* Should not happen, but... */
 			pipe_count = RCU_TORTURE_PIPE_LEN;
 		}
+		if (pipe_count > 1)
+			rcutorture_trace_dump();
 		__this_cpu_inc(rcu_torture_count[pipe_count]);
 		completed = cur_ops->completed() - completed;
 		if (completed > RCU_TORTURE_PIPE_LEN) {
@@ -1056,7 +1118,8 @@ rcu_torture_printk(char *page)
 	cnt += sprintf(&page[cnt],
 		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d "
 		       "rtmbe: %d rtbke: %ld rtbre: %ld "
-		       "rtbf: %ld rtb: %ld nt: %ld",
+		       "rtbf: %ld rtb: %ld nt: %ld "
+		       "onoff: %ld/%ld:%ld/%ld",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
 		       list_empty(&rcu_torture_freelist),
@@ -1068,7 +1131,11 @@ rcu_torture_printk(char *page)
 		       n_rcu_torture_boost_rterror,
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
-		       n_rcu_torture_timers);
+		       n_rcu_torture_timers,
+		       n_online_successes,
+		       n_online_attempts,
+		       n_offline_successes,
+		       n_offline_attempts);
 	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
 	    n_rcu_torture_boost_ktrerror != 0 ||
 	    n_rcu_torture_boost_rterror != 0 ||
@@ -1232,12 +1299,14 @@ rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 		"shuffle_interval=%d stutter=%d irqreader=%d "
 		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
 		"test_boost=%d/%d test_boost_interval=%d "
-		"test_boost_duration=%d\n",
+		"test_boost_duration=%d shutdown_secs=%d "
+		"onoff_interval=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
 		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
 		test_boost, cur_ops->can_boost,
-		test_boost_interval, test_boost_duration);
+		test_boost_interval, test_boost_duration, shutdown_secs,
+		onoff_interval);
 }
 
 static struct notifier_block rcutorture_shutdown_nb = {
@@ -1287,6 +1356,131 @@ static int rcutorture_booster_init(int cpu)
 	return 0;
 }
 
+/*
+ * Cause the rcutorture test to shutdown the system after the test has
+ * run for the time specified by the shutdown_secs module parameter.
+ */
+static int
+rcu_torture_shutdown(void *arg)
+{
+	long delta;
+	unsigned long jiffies_snap;
+
+	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
+	jiffies_snap = ACCESS_ONCE(jiffies);
+	while (ULONG_CMP_LT(jiffies_snap, shutdown_time) &&
+	       !kthread_should_stop()) {
+		delta = shutdown_time - jiffies_snap;
+		if (verbose)
+			printk(KERN_ALERT "%s" TORTURE_FLAG
+			       "rcu_torture_shutdown task: %lu "
+			       "jiffies remaining\n",
+			       torture_type, delta);
+		schedule_timeout_interruptible(delta);
+		jiffies_snap = ACCESS_ONCE(jiffies);
+	}
+	if (kthread_should_stop()) {
+		VERBOSE_PRINTK_STRING("rcu_torture_shutdown task stopping");
+		return 0;
+	}
+
+	/* OK, shut down the system. */
+
+	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task shutting down system");
+	shutdown_task = NULL;	/* Avoid self-kill deadlock. */
+	rcu_torture_cleanup();	/* Get the success/failure message. */
+	kernel_power_off();	/* Shut down the system. */
+	return 0;
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Execute random CPU-hotplug operations at the interval specified
+ * by the onoff_interval.
+ */
+static int
+rcu_torture_onoff(void *arg)
+{
+	int cpu;
+	int maxcpu = -1;
+	DEFINE_RCU_RANDOM(rand);
+
+	VERBOSE_PRINTK_STRING("rcu_torture_onoff task started");
+	for_each_online_cpu(cpu)
+		maxcpu = cpu;
+	WARN_ON(maxcpu < 0);
+	while (!kthread_should_stop()) {
+		cpu = (rcu_random(&rand) >> 4) % (maxcpu + 1);
+		if (cpu_online(cpu) && cpu_is_hotpluggable(cpu)) {
+			if (verbose)
+				printk(KERN_ALERT "%s" TORTURE_FLAG
+				       "rcu_torture_onoff task: offlining %d\n",
+				       torture_type, cpu);
+			n_offline_attempts++;
+			if (cpu_down(cpu) == 0) {
+				if (verbose)
+					printk(KERN_ALERT "%s" TORTURE_FLAG
+					       "rcu_torture_onoff task: "
+					       "offlined %d\n",
+					       torture_type, cpu);
+				n_offline_successes++;
+			}
+		} else if (cpu_is_hotpluggable(cpu)) {
+			if (verbose)
+				printk(KERN_ALERT "%s" TORTURE_FLAG
+				       "rcu_torture_onoff task: onlining %d\n",
+				       torture_type, cpu);
+			n_online_attempts++;
+			if (cpu_up(cpu) == 0) {
+				if (verbose)
+					printk(KERN_ALERT "%s" TORTURE_FLAG
+					       "rcu_torture_onoff task: "
+					       "onlined %d\n",
+					       torture_type, cpu);
+				n_online_successes++;
+			}
+		}
+		schedule_timeout_interruptible(onoff_interval * HZ);
+	}
+	VERBOSE_PRINTK_STRING("rcu_torture_onoff task stopping");
+	return 0;
+}
+
+static int
+rcu_torture_onoff_init(void)
+{
+	if (onoff_interval <= 0)
+		return 0;
+	onoff_task = kthread_run(rcu_torture_onoff, NULL, "rcu_torture_onoff");
+	if (IS_ERR(onoff_task)) {
+		onoff_task = NULL;
+		return PTR_ERR(onoff_task);
+	}
+	return 0;
+}
+
+static void rcu_torture_onoff_cleanup(void)
+{
+	if (onoff_task == NULL)
+		return;
+	VERBOSE_PRINTK_STRING("Stopping rcu_torture_onoff task");
+	kthread_stop(onoff_task);
+}
+
+#else /* #ifdef CONFIG_HOTPLUG_CPU */
+
+static void
+rcu_torture_onoff_init(void)
+{
+}
+
+static void rcu_torture_onoff_cleanup(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
+
 static int rcutorture_cpu_notify(struct notifier_block *self,
 				 unsigned long action, void *hcpu)
 {
@@ -1391,6 +1585,11 @@ rcu_torture_cleanup(void)
 		for_each_possible_cpu(i)
 			rcutorture_booster_cleanup(i);
 	}
+	if (shutdown_task != NULL) {
+		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shutdown task");
+		kthread_stop(shutdown_task);
+	}
+	rcu_torture_onoff_cleanup();
 
 	/* Wait for all RCU callbacks to fire.  */
 
@@ -1416,7 +1615,7 @@ rcu_torture_init(void)
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
 		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
-		  &srcu_ops, &srcu_expedited_ops,
+		  &srcu_ops, &srcu_raw_ops, &srcu_expedited_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
@@ -1607,6 +1806,18 @@ rcu_torture_init(void)
 			}
 		}
 	}
+	if (shutdown_secs > 0) {
+		shutdown_time = jiffies + shutdown_secs * HZ;
+		shutdown_task = kthread_run(rcu_torture_shutdown, NULL,
+					    "rcu_torture_shutdown");
+		if (IS_ERR(shutdown_task)) {
+			firsterr = PTR_ERR(shutdown_task);
+			VERBOSE_PRINTK_ERRSTRING("Failed to create shutdown");
+			shutdown_task = NULL;
+			goto unwind;
+		}
+	}
+	rcu_torture_onoff_init();
 	register_reboot_notifier(&rcutorture_shutdown_nb);
 	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6b76d81..6c4a672 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -69,7 +69,7 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 		NUM_RCU_LVL_3, \
 		NUM_RCU_LVL_4, /* == MAX_RCU_LVLS */ \
 	}, \
-	.signaled = RCU_GP_IDLE, \
+	.fqs_state = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
 	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.onofflock), \
@@ -195,12 +195,10 @@ void rcu_note_context_switch(int cpu)
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
-#ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
-	.dynticks_nesting = 1,
+	.dynticks_nesting = DYNTICK_TASK_NESTING,
 	.dynticks = ATOMIC_INIT(1),
 };
-#endif /* #ifdef CONFIG_NO_HZ */
 
 static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
 static int qhimark = 10000;	/* If this many pending, ignore blimit. */
@@ -328,11 +326,11 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
-	/* If preemptible RCU, no point in sending reschedule IPI. */
-	if (rdp->preemptible)
-		return 0;
-
-	/* The CPU is online, so send it a reschedule IPI. */
+	/*
+	 * The CPU is online, so send it a reschedule IPI.  This forces
+	 * it through the scheduler, and (inefficiently) also handles cases
+	 * where idle loops fail to inform RCU about the CPU being idle.
+	 */
 	if (rdp->cpu != smp_processor_id())
 		smp_send_reschedule(rdp->cpu);
 	else
@@ -343,59 +341,181 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 
 #endif /* #ifdef CONFIG_SMP */
 
-#ifdef CONFIG_NO_HZ
+/*
+ * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
+ *
+ * If the new value of the ->dynticks_nesting counter now is zero,
+ * we really have entered idle, and must do the appropriate accounting.
+ * The caller must have disabled interrupts.
+ */
+static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
+{
+	trace_rcu_dyntick("Start", oldval, 0);
+	if (!is_idle_task(current)) {
+		struct task_struct *idle = idle_task(smp_processor_id());
+
+		trace_rcu_dyntick("Error on entry: not idle task", oldval, 0);
+		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
+	}
+	rcu_prepare_for_idle(smp_processor_id());
+	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
+	smp_mb__before_atomic_inc();  /* See above. */
+	atomic_inc(&rdtp->dynticks);
+	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
+	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+}
 
 /**
- * rcu_enter_nohz - inform RCU that current CPU is entering nohz
+ * rcu_idle_enter - inform RCU that current CPU is entering idle
  *
- * Enter nohz mode, in other words, -leave- the mode in which RCU
+ * Enter idle mode, in other words, -leave- the mode in which RCU
  * read-side critical sections can occur.  (Though RCU read-side
- * critical sections can occur in irq handlers in nohz mode, a possibility
- * handled by rcu_irq_enter() and rcu_irq_exit()).
+ * critical sections can occur in irq handlers in idle, a possibility
+ * handled by irq_enter() and irq_exit().)
+ *
+ * We crowbar the ->dynticks_nesting field to zero to allow for
+ * the possibility of usermode upcalls having messed up our count
+ * of interrupt nesting level during the prior busy period.
  */
-void rcu_enter_nohz(void)
+void rcu_idle_enter(void)
 {
 	unsigned long flags;
+	long long oldval;
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (--rdtp->dynticks_nesting) {
-		local_irq_restore(flags);
-		return;
-	}
-	trace_rcu_dyntick("Start");
-	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
-	smp_mb__before_atomic_inc();  /* See above. */
-	atomic_inc(&rdtp->dynticks);
-	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
-	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	oldval = rdtp->dynticks_nesting;
+	rdtp->dynticks_nesting = 0;
+	rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
 
-/*
- * rcu_exit_nohz - inform RCU that current CPU is leaving nohz
+/**
+ * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
+ *
+ * Exit from an interrupt handler, which might possibly result in entering
+ * idle mode, in other words, leaving the mode in which read-side critical
+ * sections can occur.
  *
- * Exit nohz mode, in other words, -enter- the mode in which RCU
- * read-side critical sections normally occur.
+ * This code assumes that the idle loop never does anything that might
+ * result in unbalanced calls to irq_enter() and irq_exit().  If your
+ * architecture violates this assumption, RCU will give you what you
+ * deserve, good and hard.  But very infrequently and irreproducibly.
+ *
+ * Use things like work queues to work around this limitation.
+ *
+ * You have been warned.
  */
-void rcu_exit_nohz(void)
+void rcu_irq_exit(void)
 {
 	unsigned long flags;
+	long long oldval;
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (rdtp->dynticks_nesting++) {
-		local_irq_restore(flags);
-		return;
-	}
+	oldval = rdtp->dynticks_nesting;
+	rdtp->dynticks_nesting--;
+	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
+	if (rdtp->dynticks_nesting)
+		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
+	else
+		rcu_idle_enter_common(rdtp, oldval);
+	local_irq_restore(flags);
+}
+
+/*
+ * rcu_idle_exit_common - inform RCU that current CPU is moving away from idle
+ *
+ * If the new value of the ->dynticks_nesting counter was previously zero,
+ * we really have exited idle, and must do the appropriate accounting.
+ * The caller must have disabled interrupts.
+ */
+static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
+{
 	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
-	trace_rcu_dyntick("End");
+	rcu_cleanup_after_idle(smp_processor_id());
+	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
+	if (!is_idle_task(current)) {
+		struct task_struct *idle = idle_task(smp_processor_id());
+
+		trace_rcu_dyntick("Error on exit: not idle task",
+				  oldval, rdtp->dynticks_nesting);
+		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
+	}
+}
+
+/**
+ * rcu_idle_exit - inform RCU that current CPU is leaving idle
+ *
+ * Exit idle mode, in other words, -enter- the mode in which RCU
+ * read-side critical sections can occur.
+ *
+ * We crowbar the ->dynticks_nesting field to DYNTICK_TASK_NESTING to
+ * allow for the possibility of usermode upcalls messing up our count
+ * of interrupt nesting level during the busy period that is just
+ * now starting.
+ */
+void rcu_idle_exit(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+	long long oldval;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = rdtp->dynticks_nesting;
+	WARN_ON_ONCE(oldval != 0);
+	rdtp->dynticks_nesting = DYNTICK_TASK_NESTING;
+	rcu_idle_exit_common(rdtp, oldval);
+	local_irq_restore(flags);
+}
+
+/**
+ * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
+ *
+ * Enter an interrupt handler, which might possibly result in exiting
+ * idle mode, in other words, entering the mode in which read-side critical
+ * sections can occur.
+ *
+ * Note that the Linux kernel is fully capable of entering an interrupt
+ * handler that it never exits, for example when doing upcalls to
+ * user mode!  This code assumes that the idle loop never does upcalls to
+ * user mode.  If your architecture does do upcalls from the idle loop (or
+ * does anything else that results in unbalanced calls to the irq_enter()
+ * and irq_exit() functions), RCU will give you what you deserve, good
+ * and hard.  But very infrequently and irreproducibly.
+ *
+ * Use things like work queues to work around this limitation.
+ *
+ * You have been warned.
+ */
+void rcu_irq_enter(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+	long long oldval;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	oldval = rdtp->dynticks_nesting;
+	rdtp->dynticks_nesting++;
+	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
+	if (oldval)
+		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
+	else
+		rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
 
@@ -442,27 +562,37 @@ void rcu_nmi_exit(void)
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 }
 
+#ifdef CONFIG_PROVE_RCU
+
 /**
- * rcu_irq_enter - inform RCU of entry to hard irq context
+ * rcu_is_cpu_idle - see if RCU thinks that the current CPU is idle
  *
- * If the CPU was idle with dynamic ticks active, this updates the
- * rdtp->dynticks to let the RCU handling know that the CPU is active.
+ * If the current CPU is in its idle loop and is neither in an interrupt
+ * or NMI handler, return true.
  */
-void rcu_irq_enter(void)
+int rcu_is_cpu_idle(void)
 {
-	rcu_exit_nohz();
+	int ret;
+
+	preempt_disable();
+	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
+	preempt_enable();
+	return ret;
 }
+EXPORT_SYMBOL(rcu_is_cpu_idle);
+
+#endif /* #ifdef CONFIG_PROVE_RCU */
 
 /**
- * rcu_irq_exit - inform RCU of exit from hard irq context
+ * rcu_is_cpu_rrupt_from_idle - see if idle or immediately interrupted from idle
  *
- * If the CPU was idle with dynamic ticks active, update the rdp->dynticks
- * to put let the RCU handling be aware that the CPU is going back to idle
- * with no ticks.
+ * If the current CPU is idle or running at a first-level (not nested)
+ * interrupt from idle, return true.  The caller must have at least
+ * disabled preemption.
  */
-void rcu_irq_exit(void)
+int rcu_is_cpu_rrupt_from_idle(void)
 {
-	rcu_enter_nohz();
+	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
 }
 
 #ifdef CONFIG_SMP
@@ -475,7 +605,7 @@ void rcu_irq_exit(void)
 static int dyntick_save_progress_counter(struct rcu_data *rdp)
 {
 	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
-	return 0;
+	return (rdp->dynticks_snap & 0x1) == 0;
 }
 
 /*
@@ -512,26 +642,6 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #endif /* #ifdef CONFIG_SMP */
 
-#else /* #ifdef CONFIG_NO_HZ */
-
-#ifdef CONFIG_SMP
-
-static int dyntick_save_progress_counter(struct rcu_data *rdp)
-{
-	return 0;
-}
-
-static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
-{
-	return rcu_implicit_offline_qs(rdp);
-}
-
-#endif /* #ifdef CONFIG_SMP */
-
-#endif /* #else #ifdef CONFIG_NO_HZ */
-
-int rcu_cpu_stall_suppress __read_mostly;
-
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	rsp->gp_start = jiffies;
@@ -866,8 +976,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/* Advance to a new grace period and initialize state. */
 	rsp->gpnum++;
 	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
-	WARN_ON_ONCE(rsp->signaled == RCU_GP_INIT);
-	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
+	WARN_ON_ONCE(rsp->fqs_state == RCU_GP_INIT);
+	rsp->fqs_state = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
 
@@ -877,7 +987,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
 		rnp->completed = rsp->completed;
-		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
+		rsp->fqs_state = RCU_SIGNAL_INIT; /* force_quiescent_state OK */
 		rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
 		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
@@ -927,7 +1037,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock(&rnp->lock);		/* irqs already disabled. */
-	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
+	rsp->fqs_state = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
@@ -991,7 +1101,7 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 
 	rsp->completed = rsp->gpnum;  /* Declare the grace period complete. */
 	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
-	rsp->signaled = RCU_GP_IDLE;
+	rsp->fqs_state = RCU_GP_IDLE;
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
 }
 
@@ -1221,7 +1331,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	else
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
-		rcu_report_exp_rnp(rsp, rnp);
+		rcu_report_exp_rnp(rsp, rnp, true);
 	rcu_node_kthread_setaffinity(rnp, -1);
 }
 
@@ -1263,7 +1373,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
 		trace_rcu_batch_start(rsp->name, 0, 0);
-		trace_rcu_batch_end(rsp->name, 0);
+		trace_rcu_batch_end(rsp->name, 0, !!ACCESS_ONCE(rdp->nxtlist),
+				    need_resched(), is_idle_task(current),
+				    rcu_is_callbacks_kthread());
 		return;
 	}
 
@@ -1291,12 +1403,17 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 		debug_rcu_head_unqueue(list);
 		__rcu_reclaim(rsp->name, list);
 		list = next;
-		if (++count >= bl)
+		/* Stop only if limit reached and CPU has something to do. */
+		if (++count >= bl &&
+		    (need_resched() ||
+		     (!is_idle_task(current) && !rcu_is_callbacks_kthread())))
 			break;
 	}
 
 	local_irq_save(flags);
-	trace_rcu_batch_end(rsp->name, count);
+	trace_rcu_batch_end(rsp->name, count, !!list, need_resched(),
+			    is_idle_task(current),
+			    rcu_is_callbacks_kthread());
 
 	/* Update count, and requeue any remaining callbacks. */
 	rdp->qlen -= count;
@@ -1334,16 +1451,14 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
  * (user mode or idle loop for rcu, non-softirq execution for rcu_bh).
  * Also schedule RCU core processing.
  *
- * This function must be called with hardirqs disabled.  It is normally
+ * This function must be called from hardirq context.  It is normally
  * invoked from the scheduling-clock interrupt.  If rcu_pending returns
  * false, there is no point in invoking rcu_check_callbacks().
  */
 void rcu_check_callbacks(int cpu, int user)
 {
 	trace_rcu_utilization("Start scheduler-tick");
-	if (user ||
-	    (idle_cpu(cpu) && rcu_scheduler_active &&
-	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+	if (user || rcu_is_cpu_rrupt_from_idle()) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
@@ -1457,7 +1572,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
 	}
 	rsp->fqs_active = 1;
-	switch (rsp->signaled) {
+	switch (rsp->fqs_state) {
 	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
@@ -1473,7 +1588,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		force_qs_rnp(rsp, dyntick_save_progress_counter);
 		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
 		if (rcu_gp_in_progress(rsp))
-			rsp->signaled = RCU_FORCE_QS;
+			rsp->fqs_state = RCU_FORCE_QS;
 		break;
 
 	case RCU_FORCE_QS:
@@ -1812,7 +1927,7 @@ static int rcu_pending(int cpu)
  * by the current CPU, even if none need be done immediately, returning
  * 1 if so.
  */
-static int rcu_needs_cpu_quick_check(int cpu)
+static int rcu_cpu_has_callbacks(int cpu)
 {
 	/* RCU callbacks either ready or pending? */
 	return per_cpu(rcu_sched_data, cpu).nxtlist ||
@@ -1913,9 +2028,9 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
 	rdp->qlen = 0;
-#ifdef CONFIG_NO_HZ
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-#endif /* #ifdef CONFIG_NO_HZ */
+	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_NESTING);
+	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1942,6 +2057,10 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
+	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_NESTING;
+	atomic_set(&rdp->dynticks->dynticks,
+		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
+	rcu_prepare_for_idle_init(cpu);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*
@@ -2023,6 +2142,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		rcu_send_cbs_to_online(&rcu_bh_state);
 		rcu_send_cbs_to_online(&rcu_sched_state);
 		rcu_preempt_send_cbs_to_online();
+		rcu_cleanup_after_idle(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 849ce9e..fddff92 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -84,9 +84,10 @@
  * Dynticks per-CPU state.
  */
 struct rcu_dynticks {
-	int dynticks_nesting;	/* Track irq/process nesting level. */
-	int dynticks_nmi_nesting; /* Track NMI nesting level. */
-	atomic_t dynticks;	/* Even value for dynticks-idle, else odd. */
+	long long dynticks_nesting; /* Track irq/process nesting level. */
+				    /* Process level is worth LLONG_MAX/2. */
+	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
+	atomic_t dynticks;	    /* Even value for idle, else odd. */
 };
 
 /* RCU's kthread states for tracing. */
@@ -274,16 +275,12 @@ struct rcu_data {
 					/* did other CPU force QS recently? */
 	long		blimit;		/* Upper limit on a processed batch */
 
-#ifdef CONFIG_NO_HZ
 	/* 3) dynticks interface. */
 	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
 	int dynticks_snap;		/* Per-GP tracking for dynticks. */
-#endif /* #ifdef CONFIG_NO_HZ */
 
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
-#ifdef CONFIG_NO_HZ
 	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
-#endif /* #ifdef CONFIG_NO_HZ */
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
 	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
@@ -302,16 +299,12 @@ struct rcu_data {
 	struct rcu_state *rsp;
 };
 
-/* Values for signaled field in struct rcu_state. */
+/* Values for fqs_state field in struct rcu_state. */
 #define RCU_GP_IDLE		0	/* No grace period in progress. */
 #define RCU_GP_INIT		1	/* Grace period being initialized. */
 #define RCU_SAVE_DYNTICK	2	/* Need to scan dyntick state. */
 #define RCU_FORCE_QS		3	/* Need to force quiescent state. */
-#ifdef CONFIG_NO_HZ
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
-#else /* #ifdef CONFIG_NO_HZ */
-#define RCU_SIGNAL_INIT		RCU_FORCE_QS
-#endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
 
@@ -361,7 +354,7 @@ struct rcu_state {
 
 	/* The following fields are guarded by the root rcu_node's lock. */
 
-	u8	signaled ____cacheline_internodealigned_in_smp;
+	u8	fqs_state ____cacheline_internodealigned_in_smp;
 						/* Force QS state. */
 	u8	fqs_active;			/* force_quiescent_state() */
 						/*  is running. */
@@ -451,7 +444,8 @@ static void rcu_preempt_check_callbacks(int cpu);
 static void rcu_preempt_process_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
-static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
+			       bool wake);
 #endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
 static int rcu_preempt_pending(int cpu);
 static int rcu_preempt_needs_cpu(int cpu);
@@ -461,6 +455,7 @@ static void __init __rcu_init_preempt(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
 static void invoke_rcu_callbacks_kthread(void);
+static bool rcu_is_callbacks_kthread(void);
 #ifdef CONFIG_RCU_BOOST
 static void rcu_preempt_do_callbacks(void);
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
@@ -473,5 +468,8 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 static void rcu_cpu_kthread_setrt(int cpu, int to_rt);
 static void __cpuinit rcu_prepare_kthreads(int cpu);
+static void rcu_prepare_for_idle_init(int cpu);
+static void rcu_cleanup_after_idle(int cpu);
+static void rcu_prepare_for_idle(int cpu);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 4b9b9f8..8bb35d7 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -312,6 +312,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
+	int empty_exp_now;
 	unsigned long flags;
 	struct list_head *np;
 #ifdef CONFIG_RCU_BOOST
@@ -382,8 +383,10 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		/*
 		 * If this was the last task on the current list, and if
 		 * we aren't waiting on any CPUs, report the quiescent state.
-		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock.
+		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock,
+		 * so we must take a snapshot of the expedited state.
 		 */
+		empty_exp_now = !rcu_preempted_readers_exp(rnp);
 		if (!empty && !rcu_preempt_blocked_readers_cgp(rnp)) {
 			trace_rcu_quiescent_state_report("preempt_rcu",
 							 rnp->gpnum,
@@ -406,8 +409,8 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		 * If this was the last task on the expedited lists,
 		 * then we need to report up the rcu_node hierarchy.
 		 */
-		if (!empty_exp && !rcu_preempted_readers_exp(rnp))
-			rcu_report_exp_rnp(&rcu_preempt_state, rnp);
+		if (!empty_exp && empty_exp_now)
+			rcu_report_exp_rnp(&rcu_preempt_state, rnp, true);
 	} else {
 		local_irq_restore(flags);
 	}
@@ -729,9 +732,13 @@ static int sync_rcu_preempt_exp_done(struct rcu_node *rnp)
  * recursively up the tree.  (Calm down, calm down, we do the recursion
  * iteratively!)
  *
+ * Most callers will set the "wake" flag, but the task initiating the
+ * expedited grace period need not wake itself.
+ *
  * Caller must hold sync_rcu_preempt_exp_mutex.
  */
-static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
+			       bool wake)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -744,7 +751,8 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 		}
 		if (rnp->parent == NULL) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			wake_up(&sync_rcu_preempt_exp_wq);
+			if (wake)
+				wake_up(&sync_rcu_preempt_exp_wq);
 			break;
 		}
 		mask = rnp->grpmask;
@@ -777,7 +785,7 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 		must_wait = 1;
 	}
 	if (!must_wait)
-		rcu_report_exp_rnp(rsp, rnp);
+		rcu_report_exp_rnp(rsp, rnp, false); /* Don't wake self. */
 }
 
 /*
@@ -1069,9 +1077,9 @@ EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
  * report on tasks preempted in RCU read-side critical sections during
  * expedited RCU grace periods.
  */
-static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
+			       bool wake)
 {
-	return;
 }
 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
@@ -1157,8 +1165,6 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
-static struct lock_class_key rcu_boost_class;
-
 /*
  * Carry out RCU priority boosting on the task indicated by ->exp_tasks
  * or ->boost_tasks, advancing the pointer to the next task in the
@@ -1221,15 +1227,13 @@ static int rcu_boost(struct rcu_node *rnp)
 	 */
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
-	/* Avoid lockdep false positives.  This rt_mutex is its own thing. */
-	lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
-				   "rcu_boost_mutex");
 	t->rcu_boost_mutex = &mtx;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
 
-	return rnp->exp_tasks != NULL || rnp->boost_tasks != NULL;
+	return ACCESS_ONCE(rnp->exp_tasks) != NULL ||
+	       ACCESS_ONCE(rnp->boost_tasks) != NULL;
 }
 
 /*
@@ -1329,6 +1333,15 @@ static void invoke_rcu_callbacks_kthread(void)
 }
 
 /*
+ * Is the current CPU running the RCU-callbacks kthread?
+ * Caller must have preemption disabled.
+ */
+static bool rcu_is_callbacks_kthread(void)
+{
+	return __get_cpu_var(rcu_cpu_kthread_task) == current;
+}
+
+/*
  * Set the affinity of the boost kthread.  The CPU-hotplug locks are
  * held, so no one should be messing with the existence of the boost
  * kthread.
@@ -1772,6 +1785,11 @@ static void invoke_rcu_callbacks_kthread(void)
 	WARN_ON_ONCE(1);
 }
 
+static bool rcu_is_callbacks_kthread(void)
+{
+	return false;
+}
+
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
 {
 }
@@ -1907,7 +1925,7 @@ void synchronize_sched_expedited(void)
 		 * grace period works for us.
 		 */
 		get_online_cpus();
-		snap = atomic_read(&sync_sched_expedited_started) - 1;
+		snap = atomic_read(&sync_sched_expedited_started);
 		smp_mb(); /* ensure read is before try_stop_cpus(). */
 	}
 
@@ -1939,88 +1957,243 @@ EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
  * 1 if so.  This function is part of the RCU implementation; it is -not-
  * an exported member of the RCU API.
  *
- * Because we have preemptible RCU, just check whether this CPU needs
- * any flavor of RCU.  Do not chew up lots of CPU cycles with preemption
- * disabled in a most-likely vain attempt to cause RCU not to need this CPU.
+ * Because we not have RCU_FAST_NO_HZ, just check whether this CPU needs
+ * any flavor of RCU.
  */
 int rcu_needs_cpu(int cpu)
 {
-	return rcu_needs_cpu_quick_check(cpu);
+	return rcu_cpu_has_callbacks(cpu);
+}
+
+/*
+ * Because we do not have RCU_FAST_NO_HZ, don't bother initializing for it.
+ */
+static void rcu_prepare_for_idle_init(int cpu)
+{
+}
+
+/*
+ * Because we do not have RCU_FAST_NO_HZ, don't bother cleaning up
+ * after it.
+ */
+static void rcu_cleanup_after_idle(int cpu)
+{
+}
+
+/*
+ * Do the idle-entry grace-period work, which, because CONFIG_RCU_FAST_NO_HZ=y,
+ * is nothing.
+ */
+static void rcu_prepare_for_idle(int cpu)
+{
 }
 
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
-#define RCU_NEEDS_CPU_FLUSHES 5
+/*
+ * This code is invoked when a CPU goes idle, at which point we want
+ * to have the CPU do everything required for RCU so that it can enter
+ * the energy-efficient dyntick-idle mode.  This is handled by a
+ * state machine implemented by rcu_prepare_for_idle() below.
+ *
+ * The following three proprocessor symbols control this state machine:
+ *
+ * RCU_IDLE_FLUSHES gives the maximum number of times that we will attempt
+ *	to satisfy RCU.  Beyond this point, it is better to incur a periodic
+ *	scheduling-clock interrupt than to loop through the state machine
+ *	at full power.
+ * RCU_IDLE_OPT_FLUSHES gives the number of RCU_IDLE_FLUSHES that are
+ *	optional if RCU does not need anything immediately from this
+ *	CPU, even if this CPU still has RCU callbacks queued.  The first
+ *	times through the state machine are mandatory: we need to give
+ *	the state machine a chance to communicate a quiescent state
+ *	to the RCU core.
+ * RCU_IDLE_GP_DELAY gives the number of jiffies that a CPU is permitted
+ *	to sleep in dyntick-idle mode with RCU callbacks pending.  This
+ *	is sized to be roughly one RCU grace period.  Those energy-efficiency
+ *	benchmarkers who might otherwise be tempted to set this to a large
+ *	number, be warned: Setting RCU_IDLE_GP_DELAY too high can hang your
+ *	system.  And if you are -that- concerned about energy efficiency,
+ *	just power the system down and be done with it!
+ *
+ * The values below work well in practice.  If future workloads require
+ * adjustment, they can be converted into kernel config parameters, though
+ * making the state machine smarter might be a better option.
+ */
+#define RCU_IDLE_FLUSHES 5		/* Number of dyntick-idle tries. */
+#define RCU_IDLE_OPT_FLUSHES 3		/* Optional dyntick-idle tries. */
+#define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
+
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
+static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
+static ktime_t rcu_idle_gp_wait;
 
 /*
- * Check to see if any future RCU-related work will need to be done
- * by the current CPU, even if none need be done immediately, returning
- * 1 if so.  This function is part of the RCU implementation; it is -not-
- * an exported member of the RCU API.
+ * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
+ * callbacks on this CPU, (2) this CPU has not yet attempted to enter
+ * dyntick-idle mode, or (3) this CPU is in the process of attempting to
+ * enter dyntick-idle mode.  Otherwise, if we have recently tried and failed
+ * to enter dyntick-idle mode, we refuse to try to enter it.  After all,
+ * it is better to incur scheduling-clock interrupts than to spin
+ * continuously for the same time duration!
+ */
+int rcu_needs_cpu(int cpu)
+{
+	/* If no callbacks, RCU doesn't need the CPU. */
+	if (!rcu_cpu_has_callbacks(cpu))
+		return 0;
+	/* Otherwise, RCU needs the CPU only if it recently tried and failed. */
+	return per_cpu(rcu_dyntick_holdoff, cpu) == jiffies;
+}
+
+/*
+ * Timer handler used to force CPU to start pushing its remaining RCU
+ * callbacks in the case where it entered dyntick-idle mode with callbacks
+ * pending.  The hander doesn't really need to do anything because the
+ * real work is done upon re-entry to idle, or by the next scheduling-clock
+ * interrupt should idle not be re-entered.
+ */
+static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
+{
+	trace_rcu_prep_idle("Timer");
+	return HRTIMER_NORESTART;
+}
+
+/*
+ * Initialize the timer used to pull CPUs out of dyntick-idle mode.
+ */
+static void rcu_prepare_for_idle_init(int cpu)
+{
+	static int firsttime = 1;
+	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
+
+	hrtimer_init(hrtp, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtp->function = rcu_idle_gp_timer_func;
+	if (firsttime) {
+		unsigned int upj = jiffies_to_usecs(RCU_IDLE_GP_DELAY);
+
+		rcu_idle_gp_wait = ns_to_ktime(upj * (u64)1000);
+		firsttime = 0;
+	}
+}
+
+/*
+ * Clean up for exit from idle.  Because we are exiting from idle, there
+ * is no longer any point to rcu_idle_gp_timer, so cancel it.  This will
+ * do nothing if this timer is not active, so just cancel it unconditionally.
+ */
+static void rcu_cleanup_after_idle(int cpu)
+{
+	hrtimer_cancel(&per_cpu(rcu_idle_gp_timer, cpu));
+}
+
+/*
+ * Check to see if any RCU-related work can be done by the current CPU,
+ * and if so, schedule a softirq to get it done.  This function is part
+ * of the RCU implementation; it is -not- an exported member of the RCU API.
  *
- * Because we are not supporting preemptible RCU, attempt to accelerate
- * any current grace periods so that RCU no longer needs this CPU, but
- * only if all other CPUs are already in dynticks-idle mode.  This will
- * allow the CPU cores to be powered down immediately, as opposed to after
- * waiting many milliseconds for grace periods to elapse.
+ * The idea is for the current CPU to clear out all work required by the
+ * RCU core for the current grace period, so that this CPU can be permitted
+ * to enter dyntick-idle mode.  In some cases, it will need to be awakened
+ * at the end of the grace period by whatever CPU ends the grace period.
+ * This allows CPUs to go dyntick-idle more quickly, and to reduce the
+ * number of wakeups by a modest integer factor.
  *
  * Because it is not legal to invoke rcu_process_callbacks() with irqs
  * disabled, we do one pass of force_quiescent_state(), then do a
  * invoke_rcu_core() to cause rcu_process_callbacks() to be invoked
  * later.  The per-cpu rcu_dyntick_drain variable controls the sequencing.
+ *
+ * The caller must have disabled interrupts.
  */
-int rcu_needs_cpu(int cpu)
+static void rcu_prepare_for_idle(int cpu)
 {
-	int c = 0;
-	int snap;
-	int thatcpu;
-
-	/* Check for being in the holdoff period. */
-	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies)
-		return rcu_needs_cpu_quick_check(cpu);
-
-	/* Don't bother unless we are the last non-dyntick-idle CPU. */
-	for_each_online_cpu(thatcpu) {
-		if (thatcpu == cpu)
-			continue;
-		snap = atomic_add_return(0, &per_cpu(rcu_dynticks,
-						     thatcpu).dynticks);
-		smp_mb(); /* Order sampling of snap with end of grace period. */
-		if ((snap & 0x1) != 0) {
-			per_cpu(rcu_dyntick_drain, cpu) = 0;
-			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
-			return rcu_needs_cpu_quick_check(cpu);
-		}
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	/*
+	 * If there are no callbacks on this CPU, enter dyntick-idle mode.
+	 * Also reset state to avoid prejudicing later attempts.
+	 */
+	if (!rcu_cpu_has_callbacks(cpu)) {
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+		per_cpu(rcu_dyntick_drain, cpu) = 0;
+		local_irq_restore(flags);
+		trace_rcu_prep_idle("No callbacks");
+		return;
+	}
+
+	/*
+	 * If in holdoff mode, just return.  We will presumably have
+	 * refrained from disabling the scheduling-clock tick.
+	 */
+	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies) {
+		local_irq_restore(flags);
+		trace_rcu_prep_idle("In holdoff");
+		return;
 	}
 
 	/* Check and update the rcu_dyntick_drain sequencing. */
 	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* First time through, initialize the counter. */
-		per_cpu(rcu_dyntick_drain, cpu) = RCU_NEEDS_CPU_FLUSHES;
+		per_cpu(rcu_dyntick_drain, cpu) = RCU_IDLE_FLUSHES;
+	} else if (per_cpu(rcu_dyntick_drain, cpu) <= RCU_IDLE_OPT_FLUSHES &&
+		   !rcu_pending(cpu)) {
+		/* Can we go dyntick-idle despite still having callbacks? */
+		trace_rcu_prep_idle("Dyntick with callbacks");
+		per_cpu(rcu_dyntick_drain, cpu) = 0;
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+		hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
+			      rcu_idle_gp_wait, HRTIMER_MODE_REL);
+		return; /* Nothing more to do immediately. */
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
-		return rcu_needs_cpu_quick_check(cpu);
+		local_irq_restore(flags);
+		trace_rcu_prep_idle("Begin holdoff");
+		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
+		return;
 	}
 
-	/* Do one step pushing remaining RCU callbacks through. */
+	/*
+	 * Do one step of pushing the remaining RCU callbacks through
+	 * the RCU core state machine.
+	 */
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	if (per_cpu(rcu_preempt_data, cpu).nxtlist) {
+		local_irq_restore(flags);
+		rcu_preempt_qs(cpu);
+		force_quiescent_state(&rcu_preempt_state, 0);
+		local_irq_save(flags);
+	}
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
+		local_irq_restore(flags);
 		rcu_sched_qs(cpu);
 		force_quiescent_state(&rcu_sched_state, 0);
-		c = c || per_cpu(rcu_sched_data, cpu).nxtlist;
+		local_irq_save(flags);
 	}
 	if (per_cpu(rcu_bh_data, cpu).nxtlist) {
+		local_irq_restore(flags);
 		rcu_bh_qs(cpu);
 		force_quiescent_state(&rcu_bh_state, 0);
-		c = c || per_cpu(rcu_bh_data, cpu).nxtlist;
+		local_irq_save(flags);
 	}
 
-	/* If RCU callbacks are still pending, RCU still needs this CPU. */
-	if (c)
+	/*
+	 * If RCU callbacks are still pending, RCU still needs this CPU.
+	 * So try forcing the callbacks through the grace period.
+	 */
+	if (rcu_cpu_has_callbacks(cpu)) {
+		local_irq_restore(flags);
+		trace_rcu_prep_idle("More callbacks");
 		invoke_rcu_core();
-	return c;
+	} else {
+		local_irq_restore(flags);
+		trace_rcu_prep_idle("Callbacks drained");
+	}
 }
 
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 9feffa4..654cfe6 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -67,13 +67,11 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->completed, rdp->gpnum,
 		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
 		   rdp->qs_pending);
-#ifdef CONFIG_NO_HZ
-	seq_printf(m, " dt=%d/%d/%d df=%lu",
+	seq_printf(m, " dt=%d/%llx/%d df=%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-#endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
 	seq_printf(m, " ql=%ld qs=%c%c%c%c",
 		   rdp->qlen,
@@ -141,13 +139,11 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->completed, rdp->gpnum,
 		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
 		   rdp->qs_pending);
-#ifdef CONFIG_NO_HZ
-	seq_printf(m, ",%d,%d,%d,%lu",
+	seq_printf(m, ",%d,%llx,%d,%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-#endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
 	seq_printf(m, ",%ld,\"%c%c%c%c\"", rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
@@ -171,9 +167,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
-#ifdef CONFIG_NO_HZ
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
-#endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"qs\"");
 #ifdef CONFIG_RCU_BOOST
 	seq_puts(m, "\"kt\",\"ktl\"");
@@ -278,7 +272,7 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	gpnum = rsp->gpnum;
 	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
 		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
-		   rsp->completed, gpnum, rsp->signaled,
+		   rsp->completed, gpnum, rsp->fqs_state,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index f9d8482..a242e69 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -579,7 +579,6 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		    struct rt_mutex_waiter *waiter)
 {
 	int ret = 0;
-	int was_disabled;
 
 	for (;;) {
 		/* Try to acquire the lock: */
@@ -602,17 +601,10 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 		raw_spin_unlock(&lock->wait_lock);
 
-		was_disabled = irqs_disabled();
-		if (was_disabled)
-			local_irq_enable();
-
 		debug_rt_mutex_print_deadlock(waiter);
 
 		schedule_rt_mutex(lock);
 
-		if (was_disabled)
-			local_irq_disable();
-
 		raw_spin_lock(&lock->wait_lock);
 		set_current_state(state);
 	}
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 2c71d91..4eb3a0f 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -347,12 +347,12 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
-	rcu_irq_exit();
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
 	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
-		tick_nohz_stop_sched_tick(0);
+		tick_nohz_irq_exit();
 #endif
+	rcu_irq_exit();
 	preempt_enable_no_resched();
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4042064..0ec8b83 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -275,42 +275,17 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
-/**
- * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
- *
- * When the next event is more than a tick into the future, stop the idle tick
- * Called either from the idle loop or from irq_exit() when an idle period was
- * just interrupted by an interrupt which did not cause a reschedule.
- */
-void tick_nohz_stop_sched_tick(int inidle)
+static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 {
-	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
-	struct tick_sched *ts;
+	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
 	int cpu;
 
-	local_irq_save(flags);
-
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
-	/*
-	 * Call to tick_nohz_start_idle stops the last_update_time from being
-	 * updated. Thus, it must not be called in the event we are called from
-	 * irq_exit() with the prior state different than idle.
-	 */
-	if (!inidle && !ts->inidle)
-		goto end;
-
-	/*
-	 * Set ts->inidle unconditionally. Even if the system did not
-	 * switch to NOHZ mode the cpu frequency governers rely on the
-	 * update of the idle time accounting in tick_nohz_start_idle().
-	 */
-	ts->inidle = 1;
-
 	now = tick_nohz_start_idle(cpu, ts);
 
 	/*
@@ -326,10 +301,10 @@ void tick_nohz_stop_sched_tick(int inidle)
 	}
 
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
-		goto end;
+		return;
 
 	if (need_resched())
-		goto end;
+		return;
 
 	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
 		static int ratelimit;
@@ -339,7 +314,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 			       (unsigned int) local_softirq_pending());
 			ratelimit++;
 		}
-		goto end;
+		return;
 	}
 
 	ts->idle_calls++;
@@ -434,7 +409,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
-			rcu_enter_nohz();
 		}
 
 		ts->idle_sleeps++;
@@ -472,8 +446,56 @@ out:
 	ts->next_jiffies = next_jiffies;
 	ts->last_jiffies = last_jiffies;
 	ts->sleep_length = ktime_sub(dev->next_event, now);
-end:
-	local_irq_restore(flags);
+}
+
+/**
+ * tick_nohz_idle_enter - stop the idle tick from the idle task
+ *
+ * When the next event is more than a tick into the future, stop the idle tick
+ * Called when we start the idle loop.
+ *
+ * The arch is responsible of calling:
+ *
+ * - rcu_idle_enter() after its last use of RCU before the CPU is put
+ *  to sleep.
+ * - rcu_idle_exit() before the first use of RCU after the CPU is woken up.
+ */
+void tick_nohz_idle_enter(void)
+{
+	struct tick_sched *ts;
+
+	WARN_ON_ONCE(irqs_disabled());
+
+	local_irq_disable();
+
+	ts = &__get_cpu_var(tick_cpu_sched);
+	/*
+	 * set ts->inidle unconditionally. even if the system did not
+	 * switch to nohz mode the cpu frequency governers rely on the
+	 * update of the idle time accounting in tick_nohz_start_idle().
+	 */
+	ts->inidle = 1;
+	tick_nohz_stop_sched_tick(ts);
+
+	local_irq_enable();
+}
+
+/**
+ * tick_nohz_irq_exit - update next tick event from interrupt exit
+ *
+ * When an interrupt fires while we are idle and it doesn't cause
+ * a reschedule, it may still add, modify or delete a timer, enqueue
+ * an RCU callback, etc...
+ * So we need to re-calculate and reprogram the next tick event.
+ */
+void tick_nohz_irq_exit(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (!ts->inidle)
+		return;
+
+	tick_nohz_stop_sched_tick(ts);
 }
 
 /**
@@ -515,11 +537,13 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 }
 
 /**
- * tick_nohz_restart_sched_tick - restart the idle tick from the idle task
+ * tick_nohz_idle_exit - restart the idle tick from the idle task
  *
  * Restart the idle tick when the CPU is woken up from idle
+ * This also exit the RCU extended quiescent state. The CPU
+ * can use RCU again after this function is called.
  */
-void tick_nohz_restart_sched_tick(void)
+void tick_nohz_idle_exit(void)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
@@ -529,6 +553,7 @@ void tick_nohz_restart_sched_tick(void)
 	ktime_t now;
 
 	local_irq_disable();
+
 	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
 		now = ktime_get();
 
@@ -543,8 +568,6 @@ void tick_nohz_restart_sched_tick(void)
 
 	ts->inidle = 0;
 
-	rcu_exit_nohz();
-
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f2bd275..a043d22 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4775,6 +4775,7 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 {
 	__ftrace_dump(true, oops_dump_mode);
 }
+EXPORT_SYMBOL_GPL(ftrace_dump);
 
 __init static int tracer_alloc_buffers(void)
 {
