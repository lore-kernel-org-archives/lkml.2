Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab1JZNbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:31:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40605 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab1JZNbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:31:12 -0400
Date: Wed, 26 Oct 2011 15:29:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.2
Message-ID: <20111026132915.GA24631@elte.hu>
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
Andi Kleen (1):
      rcu: Fix mismatched variable in rcutree_trace.c

Eric Dumazet (2):
      rcu: Use kthread_create_on_node()
      rcu: Make rcu_assign_pointer() unconditionally insert a memory barrier

Michal Hocko (1):
      rcu: Not necessary to pass rcu_read_lock_held() to rcu_dereference_protected()

Mike Galbraith (1):
      rcu: Wire up RCU_BOOST_PRIO for rcutree

Paul E. McKenney (38):
      rcu: Update documentation to flag RCU_BOOST trace information
      rcu: Restore checks for blocking in RCU read-side critical sections
      rcu: Move rcu_head definition to types.h
      rcu: Update rcutorture documentation
      rcu: Abstract common code for RCU grace-period-wait primitives
      rcu: Catch rcutorture up to new RCU API additions
      rcu: Fix RCU's NMI documentation
      rcu: Drive configuration directly from SMP and PREEMPT
      rcu: Don't destroy rcu_torture_boost() callback until it is done
      rcu: Add event-tracing for RCU callback invocation
      rcu: Event-trace markers for computing RCU CPU utilization
      rcu: Put names into TINY_RCU structures under RCU_TRACE
      rcu: Add RCU type to callback-invocation tracing
      rcu: Update comments to reflect softirqs vs. kthreads
      rcu: Move RCU_BOOST declarations to allow compiler checking
      rcu: Add event-trace markers to TREE_RCU kthreads
      rcu: Make TINY_RCU also use softirq for RCU_BOOST=n
      rcu: Add grace-period, quiescent-state, and call_rcu trace events
      rcu: Simplify quiescent-state accounting
      rcu: Update documentation for additional RCU lockdep functions
      rcu: Remove unused and redundant interfaces
      rcu: Allow rcutorture's stat_interval parameter to be changed at runtime
      rcu: Document interpretation of RCU-lockdep splats
      rcu: Eliminate in_irq() checks in rcu_enter_nohz()
      rcu: Make rcu_implicit_dynticks_qs() locals be correct size
      rcu: Improve rcu_assign_pointer() and RCU_INIT_POINTER() documentation
      rcu: Move __rcu_read_unlock()'s barrier() within if-statement
      rcu: Dump local stack if cannot dump all CPUs' stacks
      rcu: Prevent early boot set_need_resched() from __rcu_pending()
      rcu: Simplify unboosting checks
      rcu: Prohibit grace periods during early boot
      rcu: Suppress NMI backtraces when stall ends before dump
      rcu: Avoid having just-onlined CPU resched itself when RCU is idle
      rcu: Permit rt_mutex_unlock() with irqs disabled
      rcu: Make rcu_torture_fqs() exit loops at end of test
      rcu: Make rcu_torture_boost() exit loops at end of test
      rcu: Remove rcu_needs_cpu_flush() to avoid false quiescent states
      rcu: Move propagation of ->completed from rcu_start_gp() to rcu_report_qs_rsp()

Shaohua Li (1):
      rcu: Avoid unnecessary self-wakeup of per-CPU kthreads

Shi, Alex (1):
      nohz: Remove nohz_cpu_mask


 Documentation/RCU/NMI-RCU.txt       |    2 +-
 Documentation/RCU/lockdep-splat.txt |  110 +++++++++
 Documentation/RCU/lockdep.txt       |   34 ++-
 Documentation/RCU/torture.txt       |  137 ++++++++---
 Documentation/RCU/trace.txt         |   38 ++--
 include/linux/lockdep.h             |    2 +-
 include/linux/rcupdate.h            |  300 +++++++++++-------------
 include/linux/rcutiny.h             |   20 ++-
 include/linux/rcutree.h             |    2 +
 include/linux/sched.h               |    4 -
 include/linux/types.h               |   10 +
 include/trace/events/rcu.h          |  459 +++++++++++++++++++++++++++++++++++
 init/Kconfig                        |    6 +-
 kernel/lockdep.c                    |   84 ++++---
 kernel/pid.c                        |    4 +-
 kernel/rcu.h                        |   85 +++++++
 kernel/rcupdate.c                   |   26 ++-
 kernel/rcutiny.c                    |  117 ++-------
 kernel/rcutiny_plugin.h             |  134 +++++++----
 kernel/rcutorture.c                 |   77 +++----
 kernel/rcutree.c                    |  290 ++++++++++++++--------
 kernel/rcutree.h                    |   17 +-
 kernel/rcutree_plugin.h             |  150 +++++++-----
 kernel/rcutree_trace.c              |   13 +-
 kernel/rtmutex.c                    |    8 +
 kernel/sched.c                      |   13 +-
 kernel/time/tick-sched.c            |    6 -
 27 files changed, 1489 insertions(+), 659 deletions(-)
 create mode 100644 Documentation/RCU/lockdep-splat.txt
 create mode 100644 include/trace/events/rcu.h
 create mode 100644 kernel/rcu.h

diff --git a/Documentation/RCU/NMI-RCU.txt b/Documentation/RCU/NMI-RCU.txt
index bf82851..687777f 100644
--- a/Documentation/RCU/NMI-RCU.txt
+++ b/Documentation/RCU/NMI-RCU.txt
@@ -95,7 +95,7 @@ not to return until all ongoing NMI handlers exit.  It is therefore safe
 to free up the handler's data as soon as synchronize_sched() returns.
 
 Important note: for this to work, the architecture in question must
-invoke irq_enter() and irq_exit() on NMI entry and exit, respectively.
+invoke nmi_enter() and nmi_exit() on NMI entry and exit, respectively.
 
 
 Answer to Quick Quiz
diff --git a/Documentation/RCU/lockdep-splat.txt b/Documentation/RCU/lockdep-splat.txt
new file mode 100644
index 0000000..bf90611
--- /dev/null
+++ b/Documentation/RCU/lockdep-splat.txt
@@ -0,0 +1,110 @@
+Lockdep-RCU was added to the Linux kernel in early 2010
+(http://lwn.net/Articles/371986/).  This facility checks for some common
+misuses of the RCU API, most notably using one of the rcu_dereference()
+family to access an RCU-protected pointer without the proper protection.
+When such misuse is detected, an lockdep-RCU splat is emitted.
+
+The usual cause of a lockdep-RCU slat is someone accessing an
+RCU-protected data structure without either (1) being in the right kind of
+RCU read-side critical section or (2) holding the right update-side lock.
+This problem can therefore be serious: it might result in random memory
+overwriting or worse.  There can of course be false positives, this
+being the real world and all that.
+
+So let's look at an example RCU lockdep splat from 3.0-rc5, one that
+has long since been fixed:
+
+===============================
+[ INFO: suspicious RCU usage. ]
+-------------------------------
+block/cfq-iosched.c:2776 suspicious rcu_dereference_protected() usage!
+
+other info that might help us debug this:
+
+
+rcu_scheduler_active = 1, debug_locks = 0
+3 locks held by scsi_scan_6/1552:
+ #0:  (&shost->scan_mutex){+.+.+.}, at: [<ffffffff8145efca>]
+scsi_scan_host_selected+0x5a/0x150
+ #1:  (&eq->sysfs_lock){+.+...}, at: [<ffffffff812a5032>]
+elevator_exit+0x22/0x60
+ #2:  (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffff812b6233>]
+cfq_exit_queue+0x43/0x190
+
+stack backtrace:
+Pid: 1552, comm: scsi_scan_6 Not tainted 3.0.0-rc5 #17
+Call Trace:
+ [<ffffffff810abb9b>] lockdep_rcu_dereference+0xbb/0xc0
+ [<ffffffff812b6139>] __cfq_exit_single_io_context+0xe9/0x120
+ [<ffffffff812b626c>] cfq_exit_queue+0x7c/0x190
+ [<ffffffff812a5046>] elevator_exit+0x36/0x60
+ [<ffffffff812a802a>] blk_cleanup_queue+0x4a/0x60
+ [<ffffffff8145cc09>] scsi_free_queue+0x9/0x10
+ [<ffffffff81460944>] __scsi_remove_device+0x84/0xd0
+ [<ffffffff8145dca3>] scsi_probe_and_add_lun+0x353/0xb10
+ [<ffffffff817da069>] ? error_exit+0x29/0xb0
+ [<ffffffff817d98ed>] ? _raw_spin_unlock_irqrestore+0x3d/0x80
+ [<ffffffff8145e722>] __scsi_scan_target+0x112/0x680
+ [<ffffffff812c690d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
+ [<ffffffff817da069>] ? error_exit+0x29/0xb0
+ [<ffffffff812bcc60>] ? kobject_del+0x40/0x40
+ [<ffffffff8145ed16>] scsi_scan_channel+0x86/0xb0
+ [<ffffffff8145f0b0>] scsi_scan_host_selected+0x140/0x150
+ [<ffffffff8145f149>] do_scsi_scan_host+0x89/0x90
+ [<ffffffff8145f170>] do_scan_async+0x20/0x160
+ [<ffffffff8145f150>] ? do_scsi_scan_host+0x90/0x90
+ [<ffffffff810975b6>] kthread+0xa6/0xb0
+ [<ffffffff817db154>] kernel_thread_helper+0x4/0x10
+ [<ffffffff81066430>] ? finish_task_switch+0x80/0x110
+ [<ffffffff817d9c04>] ? retint_restore_args+0xe/0xe
+ [<ffffffff81097510>] ? __init_kthread_worker+0x70/0x70
+ [<ffffffff817db150>] ? gs_change+0xb/0xb
+
+Line 2776 of block/cfq-iosched.c in v3.0-rc5 is as follows:
+
+	if (rcu_dereference(ioc->ioc_data) == cic) {
+
+This form says that it must be in a plain vanilla RCU read-side critical
+section, but the "other info" list above shows that this is not the
+case.  Instead, we hold three locks, one of which might be RCU related.
+And maybe that lock really does protect this reference.  If so, the fix
+is to inform RCU, perhaps by changing __cfq_exit_single_io_context() to
+take the struct request_queue "q" from cfq_exit_queue() as an argument,
+which would permit us to invoke rcu_dereference_protected as follows:
+
+	if (rcu_dereference_protected(ioc->ioc_data,
+				      lockdep_is_held(&q->queue_lock)) == cic) {
+
+With this change, there would be no lockdep-RCU splat emitted if this
+code was invoked either from within an RCU read-side critical section
+or with the ->queue_lock held.  In particular, this would have suppressed
+the above lockdep-RCU splat because ->queue_lock is held (see #2 in the
+list above).
+
+On the other hand, perhaps we really do need an RCU read-side critical
+section.  In this case, the critical section must span the use of the
+return value from rcu_dereference(), or at least until there is some
+reference count incremented or some such.  One way to handle this is to
+add rcu_read_lock() and rcu_read_unlock() as follows:
+
+	rcu_read_lock();
+	if (rcu_dereference(ioc->ioc_data) == cic) {
+		spin_lock(&ioc->lock);
+		rcu_assign_pointer(ioc->ioc_data, NULL);
+		spin_unlock(&ioc->lock);
+	}
+	rcu_read_unlock();
+
+With this change, the rcu_dereference() is always within an RCU
+read-side critical section, which again would have suppressed the
+above lockdep-RCU splat.
+
+But in this particular case, we don't actually deference the pointer
+returned from rcu_dereference().  Instead, that pointer is just compared
+to the cic pointer, which means that the rcu_dereference() can be replaced
+by rcu_access_pointer() as follows:
+
+	if (rcu_access_pointer(ioc->ioc_data) == cic) {
+
+Because it is legal to invoke rcu_access_pointer() without protection,
+this change would also suppress the above lockdep-RCU splat.
diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
index d7a49b2..a102d4b 100644
--- a/Documentation/RCU/lockdep.txt
+++ b/Documentation/RCU/lockdep.txt
@@ -32,9 +32,27 @@ checking of rcu_dereference() primitives:
 	srcu_dereference(p, sp):
 		Check for SRCU read-side critical section.
 	rcu_dereference_check(p, c):
-		Use explicit check expression "c".  This is useful in
-		code that is invoked by both readers and updaters.
-	rcu_dereference_raw(p)
+		Use explicit check expression "c" along with
+		rcu_read_lock_held().  This is useful in code that is
+		invoked by both RCU readers and updaters.
+	rcu_dereference_bh_check(p, c):
+		Use explicit check expression "c" along with
+		rcu_read_lock_bh_held().  This is useful in code that
+		is invoked by both RCU-bh readers and updaters.
+	rcu_dereference_sched_check(p, c):
+		Use explicit check expression "c" along with
+		rcu_read_lock_sched_held().  This is useful in code that
+		is invoked by both RCU-sched readers and updaters.
+	srcu_dereference_check(p, c):
+		Use explicit check expression "c" along with
+		srcu_read_lock_held()().  This is useful in code that
+		is invoked by both SRCU readers and updaters.
+	rcu_dereference_index_check(p, c):
+		Use explicit check expression "c", but the caller
+		must supply one of the rcu_read_lock_held() functions.
+		This is useful in code that uses RCU-protected arrays
+		that is invoked by both RCU readers and updaters.
+	rcu_dereference_raw(p):
 		Don't check.  (Use sparingly, if at all.)
 	rcu_dereference_protected(p, c):
 		Use explicit check expression "c", and omit all barriers
@@ -48,13 +66,11 @@ checking of rcu_dereference() primitives:
 		value of the pointer itself, for example, against NULL.
 
 The rcu_dereference_check() check expression can be any boolean
-expression, but would normally include one of the rcu_read_lock_held()
-family of functions and a lockdep expression.  However, any boolean
-expression can be used.  For a moderately ornate example, consider
-the following:
+expression, but would normally include a lockdep expression.  However,
+any boolean expression can be used.  For a moderately ornate example,
+consider the following:
 
 	file = rcu_dereference_check(fdt->fd[fd],
-				     rcu_read_lock_held() ||
 				     lockdep_is_held(&files->file_lock) ||
 				     atomic_read(&files->count) == 1);
 
@@ -62,7 +78,7 @@ This expression picks up the pointer "fdt->fd[fd]" in an RCU-safe manner,
 and, if CONFIG_PROVE_RCU is configured, verifies that this expression
 is used in:
 
-1.	An RCU read-side critical section, or
+1.	An RCU read-side critical section (implicit), or
 2.	with files->file_lock held, or
 3.	on an unshared files_struct.
 
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 5d90167..783d6c1 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -42,7 +42,7 @@ fqs_holdoff	Holdoff time (in microseconds) between consecutive calls
 fqs_stutter	Wait time (in seconds) between consecutive bursts
 		of calls to force_quiescent_state().
 
-irqreaders	Says to invoke RCU readers from irq level.  This is currently
+irqreader	Says to invoke RCU readers from irq level.  This is currently
 		done via timers.  Defaults to "1" for variants of RCU that
 		permit this.  (Or, more accurately, variants of RCU that do
 		-not- permit this know to ignore this variable.)
@@ -79,19 +79,68 @@ stutter		The length of time to run the test before pausing for this
 		Specifying "stutter=0" causes the test to run continuously
 		without pausing, which is the old default behavior.
 
+test_boost	Whether or not to test the ability of RCU to do priority
+		boosting.  Defaults to "test_boost=1", which performs
+		RCU priority-inversion testing only if the selected
+		RCU implementation supports priority boosting.  Specifying
+		"test_boost=0" never performs RCU priority-inversion
+		testing.  Specifying "test_boost=2" performs RCU
+		priority-inversion testing even if the selected RCU
+		implementation does not support RCU priority boosting,
+		which can be used to test rcutorture's ability to
+		carry out RCU priority-inversion testing.
+
+test_boost_interval
+		The number of seconds in an RCU priority-inversion test
+		cycle.	Defaults to "test_boost_interval=7".  It is
+		usually wise for this value to be relatively prime to
+		the value selected for "stutter".
+
+test_boost_duration
+		The number of seconds to do RCU priority-inversion testing
+		within any given "test_boost_interval".  Defaults to
+		"test_boost_duration=4".
+
 test_no_idle_hz	Whether or not to test the ability of RCU to operate in
 		a kernel that disables the scheduling-clock interrupt to
 		idle CPUs.  Boolean parameter, "1" to test, "0" otherwise.
 		Defaults to omitting this test.
 
-torture_type	The type of RCU to test: "rcu" for the rcu_read_lock() API,
-		"rcu_sync" for rcu_read_lock() with synchronous reclamation,
-		"rcu_bh" for the rcu_read_lock_bh() API, "rcu_bh_sync" for
-		rcu_read_lock_bh() with synchronous reclamation, "srcu" for
-		the "srcu_read_lock()" API, "sched" for the use of
-		preempt_disable() together with synchronize_sched(),
-		and "sched_expedited" for the use of preempt_disable()
-		with synchronize_sched_expedited().
+torture_type	The type of RCU to test, with string values as follows:
+
+		"rcu":  rcu_read_lock(), rcu_read_unlock() and call_rcu().
+
+		"rcu_sync":  rcu_read_lock(), rcu_read_unlock(), and
+			synchronize_rcu().
+
+		"rcu_expedited": rcu_read_lock(), rcu_read_unlock(), and
+			synchronize_rcu_expedited().
+
+		"rcu_bh": rcu_read_lock_bh(), rcu_read_unlock_bh(), and
+			call_rcu_bh().
+
+		"rcu_bh_sync": rcu_read_lock_bh(), rcu_read_unlock_bh(),
+			and synchronize_rcu_bh().
+
+		"rcu_bh_expedited": rcu_read_lock_bh(), rcu_read_unlock_bh(),
+			and synchronize_rcu_bh_expedited().
+
+		"srcu": srcu_read_lock(), srcu_read_unlock() and
+			synchronize_srcu().
+
+		"srcu_expedited": srcu_read_lock(), srcu_read_unlock() and
+			synchronize_srcu_expedited().
+
+		"sched": preempt_disable(), preempt_enable(), and
+			call_rcu_sched().
+
+		"sched_sync": preempt_disable(), preempt_enable(), and
+			synchronize_sched().
+
+		"sched_expedited": preempt_disable(), preempt_enable(), and
+			synchronize_sched_expedited().
+
+		Defaults to "rcu".
 
 verbose		Enable debug printk()s.  Default is disabled.
 
@@ -100,12 +149,12 @@ OUTPUT
 
 The statistics output is as follows:
 
-	rcu-torture: --- Start of test: nreaders=16 stat_interval=0 verbose=0
-	rcu-torture: rtc: 0000000000000000 ver: 1916 tfle: 0 rta: 1916 rtaf: 0 rtf: 1915
-	rcu-torture: Reader Pipe:  1466408 9747 0 0 0 0 0 0 0 0 0
-	rcu-torture: Reader Batch:  1464477 11678 0 0 0 0 0 0 0 0
-	rcu-torture: Free-Block Circulation:  1915 1915 1915 1915 1915 1915 1915 1915 1915 1915 0
-	rcu-torture: --- End of test
+	rcu-torture:--- Start of test: nreaders=16 nfakewriters=4 stat_interval=30 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
+	rcu-torture: rtc:           (null) ver: 155441 tfle: 0 rta: 155441 rtaf: 8884 rtf: 155440 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3055767
+	rcu-torture: Reader Pipe:  727860534 34213 0 0 0 0 0 0 0 0 0
+	rcu-torture: Reader Batch:  727877838 17003 0 0 0 0 0 0 0 0 0
+	rcu-torture: Free-Block Circulation:  155440 155440 155440 155440 155440 155440 155440 155440 155440 155440 0
+	rcu-torture:--- End of test: SUCCESS: nreaders=16 nfakewriters=4 stat_interval=30 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
 
 The command "dmesg | grep torture:" will extract this information on
 most systems.  On more esoteric configurations, it may be necessary to
@@ -113,26 +162,55 @@ use other commands to access the output of the printk()s used by
 the RCU torture test.  The printk()s use KERN_ALERT, so they should
 be evident.  ;-)
 
+The first and last lines show the rcutorture module parameters, and the
+last line shows either "SUCCESS" or "FAILURE", based on rcutorture's
+automatic determination as to whether RCU operated correctly.
+
 The entries are as follows:
 
 o	"rtc": The hexadecimal address of the structure currently visible
 	to readers.
 
-o	"ver": The number of times since boot that the rcutw writer task
+o	"ver": The number of times since boot that the RCU writer task
 	has changed the structure visible to readers.
 
 o	"tfle": If non-zero, indicates that the "torture freelist"
-	containing structure to be placed into the "rtc" area is empty.
+	containing structures to be placed into the "rtc" area is empty.
 	This condition is important, since it can fool you into thinking
 	that RCU is working when it is not.  :-/
 
 o	"rta": Number of structures allocated from the torture freelist.
 
 o	"rtaf": Number of allocations from the torture freelist that have
-	failed due to the list being empty.
+	failed due to the list being empty.  It is not unusual for this
+	to be non-zero, but it is bad for it to be a large fraction of
+	the value indicated by "rta".
 
 o	"rtf": Number of frees into the torture freelist.
 
+o	"rtmbe": A non-zero value indicates that rcutorture believes that
+	rcu_assign_pointer() and rcu_dereference() are not working
+	correctly.  This value should be zero.
+
+o	"rtbke": rcutorture was unable to create the real-time kthreads
+	used to force RCU priority inversion.  This value should be zero.
+
+o	"rtbre": Although rcutorture successfully created the kthreads
+	used to force RCU priority inversion, it was unable to set them
+	to the real-time priority level of 1.  This value should be zero.
+
+o	"rtbf": The number of times that RCU priority boosting failed
+	to resolve RCU priority inversion.
+
+o	"rtb": The number of times that rcutorture attempted to force
+	an RCU priority inversion condition.  If you are testing RCU
+	priority boosting via the "test_boost" module parameter, this
+	value should be non-zero.
+
+o	"nt": The number of times rcutorture ran RCU read-side code from
+	within a timer handler.  This value should be non-zero only
+	if you specified the "irqreader" module parameter.
+
 o	"Reader Pipe": Histogram of "ages" of structures seen by readers.
 	If any entries past the first two are non-zero, RCU is broken.
 	And rcutorture prints the error flag string "!!!" to make sure
@@ -162,26 +240,15 @@ o	"Free-Block Circulation": Shows the number of torture structures
 	somehow gets incremented farther than it should.
 
 Different implementations of RCU can provide implementation-specific
-additional information.  For example, SRCU provides the following:
+additional information.  For example, SRCU provides the following
+additional line:
 
-	srcu-torture: rtc: f8cf46a8 ver: 355 tfle: 0 rta: 356 rtaf: 0 rtf: 346 rtmbe: 0
-	srcu-torture: Reader Pipe:  559738 939 0 0 0 0 0 0 0 0 0
-	srcu-torture: Reader Batch:  560434 243 0 0 0 0 0 0 0 0
-	srcu-torture: Free-Block Circulation:  355 354 353 352 351 350 349 348 347 346 0
 	srcu-torture: per-CPU(idx=1): 0(0,1) 1(0,1) 2(0,0) 3(0,1)
 
-The first four lines are similar to those for RCU.  The last line shows
-the per-CPU counter state.  The numbers in parentheses are the values
-of the "old" and "current" counters for the corresponding CPU.  The
-"idx" value maps the "old" and "current" values to the underlying array,
-and is useful for debugging.
-
-Similarly, sched_expedited RCU provides the following:
-
-	sched_expedited-torture: rtc: d0000000016c1880 ver: 1090796 tfle: 0 rta: 1090796 rtaf: 0 rtf: 1090787 rtmbe: 0 nt: 27713319
-	sched_expedited-torture: Reader Pipe:  12660320201 95875 0 0 0 0 0 0 0 0 0
-	sched_expedited-torture: Reader Batch:  12660424885 0 0 0 0 0 0 0 0 0 0
-	sched_expedited-torture: Free-Block Circulation:  1090795 1090795 1090794 1090793 1090792 1090791 1090790 1090789 1090788 1090787 0
+This line shows the per-CPU counter state.  The numbers in parentheses are
+the values of the "old" and "current" counters for the corresponding CPU.
+The "idx" value maps the "old" and "current" values to the underlying
+array, and is useful for debugging.
 
 
 USAGE
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 8173cec..aaf65f6 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -33,23 +33,23 @@ rcu/rcuboost:
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=545/1/0 df=50 of=0 ri=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
-  1 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=967/1/0 df=58 of=0 ri=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
-  2 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=1081/1/0 df=175 of=0 ri=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
-  3 c=20942 g=20943 pq=1 pqc=20942 qp=1 dt=1846/0/0 df=404 of=0 ri=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
-  4 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=369/1/0 df=83 of=0 ri=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
-  5 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=381/1/0 df=64 of=0 ri=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
-  6 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=1037/1/0 df=183 of=0 ri=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
-  7 c=20897 g=20897 pq=1 pqc=20896 qp=0 dt=1572/0/0 df=382 of=0 ri=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
+  0 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=545/1/0 df=50 of=0 ri=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
+  1 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=967/1/0 df=58 of=0 ri=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
+  2 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1081/1/0 df=175 of=0 ri=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
+  3 c=20942 g=20943 pq=1 pgp=20942 qp=1 dt=1846/0/0 df=404 of=0 ri=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
+  4 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=369/1/0 df=83 of=0 ri=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
+  5 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=381/1/0 df=64 of=0 ri=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
+  6 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1037/1/0 df=183 of=0 ri=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
+  7 c=20897 g=20897 pq=1 pgp=20896 qp=0 dt=1572/0/0 df=382 of=0 ri=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
 rcu_bh:
-  0 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=545/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
-  1 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=967/1/0 df=3 of=0 ri=1 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
-  2 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1081/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
-  3 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1846/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
-  4 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=369/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
-  5 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=381/1/0 df=4 of=0 ri=1 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
-  6 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1037/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
-  7 c=1474 g=1474 pq=1 pqc=1473 qp=0 dt=1572/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
+  0 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=545/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
+  1 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=967/1/0 df=3 of=0 ri=1 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
+  2 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1081/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
+  3 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1846/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
+  4 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=369/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
+  5 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=381/1/0 df=4 of=0 ri=1 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
+  6 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1037/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
+  7 c=1474 g=1474 pq=1 pgp=1473 qp=0 dt=1572/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -84,7 +84,7 @@ o	"pq" indicates that this CPU has passed through a quiescent state
 	CPU has not yet reported that fact, (2) some other CPU has not
 	yet reported for this grace period, or (3) both.
 
-o	"pqc" indicates which grace period the last-observed quiescent
+o	"pgp" indicates which grace period the last-observed quiescent
 	state for this CPU corresponds to.  This is important for handling
 	the race between CPU 0 reporting an extended dynticks-idle
 	quiescent state for CPU 1 and CPU 1 suddenly waking up and
@@ -184,10 +184,14 @@ o	"kt" is the per-CPU kernel-thread state.  The digit preceding
 	The number after the final slash is the CPU that the kthread
 	is actually running on.
 
+	This field is displayed only for CONFIG_RCU_BOOST kernels.
+
 o	"ktl" is the low-order 16 bits (in hexadecimal) of the count of
 	the number of times that this CPU's per-CPU kthread has gone
 	through its loop servicing invoke_rcu_cpu_kthread() requests.
 
+	This field is displayed only for CONFIG_RCU_BOOST kernels.
+
 o	"b" is the batch limit for this CPU.  If more than this number
 	of RCU callbacks is ready to invoke, then the remainder will
 	be deferred.
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index ef820a3..b6a56e3 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -548,7 +548,7 @@ do {									\
 #endif
 
 #ifdef CONFIG_PROVE_RCU
-extern void lockdep_rcu_dereference(const char *file, const int line);
+void lockdep_rcu_suspicious(const char *file, const int line, const char *s);
 #endif
 
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8f4f881..2cf4226 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -33,6 +33,7 @@
 #ifndef __LINUX_RCUPDATE_H
 #define __LINUX_RCUPDATE_H
 
+#include <linux/types.h>
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
@@ -64,32 +65,74 @@ static inline void rcutorture_record_progress(unsigned long vernum)
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
 
+/* Exported common interfaces */
+
+#ifdef CONFIG_PREEMPT_RCU
+
 /**
- * struct rcu_head - callback structure for use with RCU
- * @next: next update requests in a list
- * @func: actual update function to call after the grace period.
+ * call_rcu() - Queue an RCU callback for invocation after a grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual callback function to be invoked after the grace period
+ *
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all pre-existing RCU read-side
+ * critical sections have completed.  However, the callback function
+ * might well execute concurrently with RCU read-side critical sections
+ * that started after call_rcu() was invoked.  RCU read-side critical
+ * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
+ * and may be nested.
  */
-struct rcu_head {
-	struct rcu_head *next;
-	void (*func)(struct rcu_head *head);
-};
+extern void call_rcu(struct rcu_head *head,
+			      void (*func)(struct rcu_head *head));
 
-/* Exported common interfaces */
+#else /* #ifdef CONFIG_PREEMPT_RCU */
+
+/* In classic RCU, call_rcu() is just call_rcu_sched(). */
+#define	call_rcu	call_rcu_sched
+
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+
+/**
+ * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual callback function to be invoked after the grace period
+ *
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all currently executing RCU
+ * read-side critical sections have completed. call_rcu_bh() assumes
+ * that the read-side critical sections end on completion of a softirq
+ * handler. This means that read-side critical sections in process
+ * context must not be interrupted by softirqs. This interface is to be
+ * used when most of the read-side critical sections are in softirq context.
+ * RCU read-side critical sections are delimited by :
+ *  - rcu_read_lock() and  rcu_read_unlock(), if in interrupt context.
+ *  OR
+ *  - rcu_read_lock_bh() and rcu_read_unlock_bh(), if in process context.
+ *  These may be nested.
+ */
+extern void call_rcu_bh(struct rcu_head *head,
+			void (*func)(struct rcu_head *head));
+
+/**
+ * call_rcu_sched() - Queue an RCU for invocation after sched grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual callback function to be invoked after the grace period
+ *
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all currently executing RCU
+ * read-side critical sections have completed. call_rcu_sched() assumes
+ * that the read-side critical sections end on enabling of preemption
+ * or on voluntary preemption.
+ * RCU read-side critical sections are delimited by :
+ *  - rcu_read_lock_sched() and  rcu_read_unlock_sched(),
+ *  OR
+ *  anything that disables preemption.
+ *  These may be nested.
+ */
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
-extern void synchronize_sched(void);
-extern void rcu_barrier_bh(void);
-extern void rcu_barrier_sched(void);
-
-static inline void __rcu_read_lock_bh(void)
-{
-	local_bh_disable();
-}
 
-static inline void __rcu_read_unlock_bh(void)
-{
-	local_bh_enable();
-}
+extern void synchronize_sched(void);
 
 #ifdef CONFIG_PREEMPT_RCU
 
@@ -152,6 +195,15 @@ static inline void rcu_exit_nohz(void)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
+/*
+ * Infrastructure to implement the synchronize_() primitives in
+ * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
+ */
+
+typedef void call_rcu_func_t(struct rcu_head *head,
+			     void (*func)(struct rcu_head *head));
+void wait_rcu_gp(call_rcu_func_t crf);
+
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
 #elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
@@ -297,19 +349,31 @@ extern int rcu_my_thread_group_empty(void);
 /**
  * rcu_lockdep_assert - emit lockdep splat if specified condition not met
  * @c: condition to check
+ * @s: informative message
  */
-#define rcu_lockdep_assert(c)						\
+#define rcu_lockdep_assert(c, s)					\
 	do {								\
 		static bool __warned;					\
 		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
 			__warned = true;				\
-			lockdep_rcu_dereference(__FILE__, __LINE__);	\
+			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\
 		}							\
 	} while (0)
 
+#define rcu_sleep_check()						\
+	do {								\
+		rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),	\
+				   "Illegal context switch in RCU-bh"	\
+				   " read-side critical section");	\
+		rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),	\
+				   "Illegal context switch in RCU-sched"\
+				   " read-side critical section");	\
+	} while (0)
+
 #else /* #ifdef CONFIG_PROVE_RCU */
 
-#define rcu_lockdep_assert(c) do { } while (0)
+#define rcu_lockdep_assert(c, s) do { } while (0)
+#define rcu_sleep_check() do { } while (0)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
@@ -338,14 +402,16 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_dereference_check(p, c, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, "suspicious rcu_dereference_check()" \
+				      " usage"); \
 		rcu_dereference_sparse(p, space); \
 		smp_read_barrier_depends(); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_protected(p, c, space) \
 	({ \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, "suspicious rcu_dereference_protected()" \
+				      " usage"); \
 		rcu_dereference_sparse(p, space); \
 		((typeof(*p) __force __kernel *)(p)); \
 	})
@@ -359,15 +425,15 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_dereference_index_check(p, c) \
 	({ \
 		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, \
+				   "suspicious rcu_dereference_index_check()" \
+				   " usage"); \
 		smp_read_barrier_depends(); \
 		(_________p1); \
 	})
 #define __rcu_assign_pointer(p, v, space) \
 	({ \
-		if (!__builtin_constant_p(v) || \
-		    ((v) != NULL)) \
-			smp_wmb(); \
+		smp_wmb(); \
 		(p) = (typeof(*v) __force space *)(v); \
 	})
 
@@ -500,26 +566,6 @@ extern int rcu_my_thread_group_empty(void);
 #define rcu_dereference_protected(p, c) \
 	__rcu_dereference_protected((p), (c), __rcu)
 
-/**
- * rcu_dereference_bh_protected() - fetch RCU-bh pointer when updates prevented
- * @p: The pointer to read, prior to dereferencing
- * @c: The conditions under which the dereference will take place
- *
- * This is the RCU-bh counterpart to rcu_dereference_protected().
- */
-#define rcu_dereference_bh_protected(p, c) \
-	__rcu_dereference_protected((p), (c), __rcu)
-
-/**
- * rcu_dereference_sched_protected() - fetch RCU-sched pointer when updates prevented
- * @p: The pointer to read, prior to dereferencing
- * @c: The conditions under which the dereference will take place
- *
- * This is the RCU-sched counterpart to rcu_dereference_protected().
- */
-#define rcu_dereference_sched_protected(p, c) \
-	__rcu_dereference_protected((p), (c), __rcu)
-
 
 /**
  * rcu_dereference() - fetch RCU-protected pointer for dereferencing
@@ -630,7 +676,7 @@ static inline void rcu_read_unlock(void)
  */
 static inline void rcu_read_lock_bh(void)
 {
-	__rcu_read_lock_bh();
+	local_bh_disable();
 	__acquire(RCU_BH);
 	rcu_read_acquire_bh();
 }
@@ -644,7 +690,7 @@ static inline void rcu_read_unlock_bh(void)
 {
 	rcu_read_release_bh();
 	__release(RCU_BH);
-	__rcu_read_unlock_bh();
+	local_bh_enable();
 }
 
 /**
@@ -698,11 +744,18 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * any prior initialization.  Returns the value assigned.
  *
  * Inserts memory barriers on architectures that require them
- * (pretty much all of them other than x86), and also prevents
- * the compiler from reordering the code that initializes the
- * structure after the pointer assignment.  More importantly, this
- * call documents which pointers will be dereferenced by RCU read-side
- * code.
+ * (which is most of them), and also prevents the compiler from
+ * reordering the code that initializes the structure after the pointer
+ * assignment.  More importantly, this call documents which pointers
+ * will be dereferenced by RCU read-side code.
+ *
+ * In some special cases, you may use RCU_INIT_POINTER() instead
+ * of rcu_assign_pointer().  RCU_INIT_POINTER() is a bit faster due
+ * to the fact that it does not constrain either the CPU or the compiler.
+ * That said, using RCU_INIT_POINTER() when you should have used
+ * rcu_assign_pointer() is a very bad thing that results in
+ * impossible-to-diagnose memory corruption.  So please be careful.
+ * See the RCU_INIT_POINTER() comment header for details.
  */
 #define rcu_assign_pointer(p, v) \
 	__rcu_assign_pointer((p), (v), __rcu)
@@ -710,105 +763,38 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 /**
  * RCU_INIT_POINTER() - initialize an RCU protected pointer
  *
- * Initialize an RCU-protected pointer in such a way to avoid RCU-lockdep
- * splats.
+ * Initialize an RCU-protected pointer in special cases where readers
+ * do not need ordering constraints on the CPU or the compiler.  These
+ * special cases are:
+ *
+ * 1.	This use of RCU_INIT_POINTER() is NULLing out the pointer -or-
+ * 2.	The caller has taken whatever steps are required to prevent
+ *	RCU readers from concurrently accessing this pointer -or-
+ * 3.	The referenced data structure has already been exposed to
+ *	readers either at compile time or via rcu_assign_pointer() -and-
+ *	a.	You have not made -any- reader-visible changes to
+ *		this structure since then -or-
+ *	b.	It is OK for readers accessing this structure from its
+ *		new location to see the old state of the structure.  (For
+ *		example, the changes were to statistical counters or to
+ *		other state where exact synchronization is not required.)
+ *
+ * Failure to follow these rules governing use of RCU_INIT_POINTER() will
+ * result in impossible-to-diagnose memory corruption.  As in the structures
+ * will look OK in crash dumps, but any concurrent RCU readers might
+ * see pre-initialized values of the referenced data structure.  So
+ * please be very careful how you use RCU_INIT_POINTER()!!!
+ *
+ * If you are creating an RCU-protected linked structure that is accessed
+ * by a single external-to-structure RCU-protected pointer, then you may
+ * use RCU_INIT_POINTER() to initialize the internal RCU-protected
+ * pointers, but you must use rcu_assign_pointer() to initialize the
+ * external-to-structure pointer -after- you have completely initialized
+ * the reader-accessible portions of the linked structure.
  */
 #define RCU_INIT_POINTER(p, v) \
 		p = (typeof(*v) __force __rcu *)(v)
 
-/* Infrastructure to implement the synchronize_() primitives. */
-
-struct rcu_synchronize {
-	struct rcu_head head;
-	struct completion completion;
-};
-
-extern void wakeme_after_rcu(struct rcu_head  *head);
-
-#ifdef CONFIG_PREEMPT_RCU
-
-/**
- * call_rcu() - Queue an RCU callback for invocation after a grace period.
- * @head: structure to be used for queueing the RCU updates.
- * @func: actual callback function to be invoked after the grace period
- *
- * The callback function will be invoked some time after a full grace
- * period elapses, in other words after all pre-existing RCU read-side
- * critical sections have completed.  However, the callback function
- * might well execute concurrently with RCU read-side critical sections
- * that started after call_rcu() was invoked.  RCU read-side critical
- * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
- * and may be nested.
- */
-extern void call_rcu(struct rcu_head *head,
-			      void (*func)(struct rcu_head *head));
-
-#else /* #ifdef CONFIG_PREEMPT_RCU */
-
-/* In classic RCU, call_rcu() is just call_rcu_sched(). */
-#define	call_rcu	call_rcu_sched
-
-#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
-
-/**
- * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
- * @head: structure to be used for queueing the RCU updates.
- * @func: actual callback function to be invoked after the grace period
- *
- * The callback function will be invoked some time after a full grace
- * period elapses, in other words after all currently executing RCU
- * read-side critical sections have completed. call_rcu_bh() assumes
- * that the read-side critical sections end on completion of a softirq
- * handler. This means that read-side critical sections in process
- * context must not be interrupted by softirqs. This interface is to be
- * used when most of the read-side critical sections are in softirq context.
- * RCU read-side critical sections are delimited by :
- *  - rcu_read_lock() and  rcu_read_unlock(), if in interrupt context.
- *  OR
- *  - rcu_read_lock_bh() and rcu_read_unlock_bh(), if in process context.
- *  These may be nested.
- */
-extern void call_rcu_bh(struct rcu_head *head,
-			void (*func)(struct rcu_head *head));
-
-/*
- * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
- * by call_rcu() and rcu callback execution, and are therefore not part of the
- * RCU API. Leaving in rcupdate.h because they are used by all RCU flavors.
- */
-
-#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
-# define STATE_RCU_HEAD_READY	0
-# define STATE_RCU_HEAD_QUEUED	1
-
-extern struct debug_obj_descr rcuhead_debug_descr;
-
-static inline void debug_rcu_head_queue(struct rcu_head *head)
-{
-	WARN_ON_ONCE((unsigned long)head & 0x3);
-	debug_object_activate(head, &rcuhead_debug_descr);
-	debug_object_active_state(head, &rcuhead_debug_descr,
-				  STATE_RCU_HEAD_READY,
-				  STATE_RCU_HEAD_QUEUED);
-}
-
-static inline void debug_rcu_head_unqueue(struct rcu_head *head)
-{
-	debug_object_active_state(head, &rcuhead_debug_descr,
-				  STATE_RCU_HEAD_QUEUED,
-				  STATE_RCU_HEAD_READY);
-	debug_object_deactivate(head, &rcuhead_debug_descr);
-}
-#else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
-static inline void debug_rcu_head_queue(struct rcu_head *head)
-{
-}
-
-static inline void debug_rcu_head_unqueue(struct rcu_head *head)
-{
-}
-#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
-
 static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
 {
 	return offset < 4096;
@@ -827,18 +813,6 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 	call_rcu(head, (rcu_callback)offset);
 }
 
-extern void kfree(const void *);
-
-static inline void __rcu_reclaim(struct rcu_head *head)
-{
-	unsigned long offset = (unsigned long)head->func;
-
-	if (__is_kfree_rcu_offset(offset))
-		kfree((void *)head - offset);
-	else
-		head->func(head);
-}
-
 /**
  * kfree_rcu() - kfree an object after a grace period.
  * @ptr:	pointer to kfree
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 52b3e02..00b7a5e 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,9 +27,23 @@
 
 #include <linux/cache.h>
 
+#ifdef CONFIG_RCU_BOOST
 static inline void rcu_init(void)
 {
 }
+#else /* #ifdef CONFIG_RCU_BOOST */
+void rcu_init(void);
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
+static inline void rcu_barrier_bh(void)
+{
+	wait_rcu_gp(call_rcu_bh);
+}
+
+static inline void rcu_barrier_sched(void)
+{
+	wait_rcu_gp(call_rcu_sched);
+}
 
 #ifdef CONFIG_TINY_RCU
 
@@ -45,9 +59,13 @@ static inline void rcu_barrier(void)
 
 #else /* #ifdef CONFIG_TINY_RCU */
 
-void rcu_barrier(void);
 void synchronize_rcu_expedited(void);
 
+static inline void rcu_barrier(void)
+{
+	wait_rcu_gp(call_rcu);
+}
+
 #endif /* #else #ifdef CONFIG_TINY_RCU */
 
 static inline void synchronize_rcu_bh(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index e65d066..6745846 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -67,6 +67,8 @@ static inline void synchronize_rcu_bh_expedited(void)
 }
 
 extern void rcu_barrier(void);
+extern void rcu_barrier_bh(void);
+extern void rcu_barrier_sched(void);
 
 extern unsigned long rcutorture_testseq;
 extern unsigned long rcutorture_vernum;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..acca435 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -270,7 +270,6 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(int cpu);
 
-extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
 extern int get_nohz_timer_target(void);
@@ -1260,9 +1259,6 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
 	char rcu_read_unlock_special;
-#if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU)
-	int rcu_boosted;
-#endif /* #if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU) */
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
diff --git a/include/linux/types.h b/include/linux/types.h
index 176da8c..57a9723 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -238,6 +238,16 @@ struct ustat {
 	char			f_fpack[6];
 };
 
+/**
+ * struct rcu_head - callback structure for use with RCU
+ * @next: next update requests in a list
+ * @func: actual update function to call after the grace period.
+ */
+struct rcu_head {
+	struct rcu_head *next;
+	void (*func)(struct rcu_head *head);
+};
+
 #endif	/* __KERNEL__ */
 #endif /*  __ASSEMBLY__ */
 #endif /* _LINUX_TYPES_H */
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
new file mode 100644
index 0000000..669fbd6
--- /dev/null
+++ b/include/trace/events/rcu.h
@@ -0,0 +1,459 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rcu
+
+#if !defined(_TRACE_RCU_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RCU_H
+
+#include <linux/tracepoint.h>
+
+/*
+ * Tracepoint for start/end markers used for utilization calculations.
+ * By convention, the string is of the following forms:
+ *
+ * "Start <activity>" -- Mark the start of the specified activity,
+ *			 such as "context switch".  Nesting is permitted.
+ * "End <activity>" -- Mark the end of the specified activity.
+ *
+ * An "@" character within "<activity>" is a comment character: Data
+ * reduction scripts will ignore the "@" and the remainder of the line.
+ */
+TRACE_EVENT(rcu_utilization,
+
+	TP_PROTO(char *s),
+
+	TP_ARGS(s),
+
+	TP_STRUCT__entry(
+		__field(char *, s)
+	),
+
+	TP_fast_assign(
+		__entry->s = s;
+	),
+
+	TP_printk("%s", __entry->s)
+);
+
+#ifdef CONFIG_RCU_TRACE
+
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+
+/*
+ * Tracepoint for grace-period events: starting and ending a grace
+ * period ("start" and "end", respectively), a CPU noting the start
+ * of a new grace period or the end of an old grace period ("cpustart"
+ * and "cpuend", respectively), a CPU passing through a quiescent
+ * state ("cpuqs"), a CPU coming online or going offline ("cpuonl"
+ * and "cpuofl", respectively), and a CPU being kicked for being too
+ * long in dyntick-idle mode ("kick").
+ */
+TRACE_EVENT(rcu_grace_period,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, char *gpevent),
+
+	TP_ARGS(rcuname, gpnum, gpevent),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(char *, gpevent)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->gpevent = gpevent;
+	),
+
+	TP_printk("%s %lu %s",
+		  __entry->rcuname, __entry->gpnum, __entry->gpevent)
+);
+
+/*
+ * Tracepoint for grace-period-initialization events.  These are
+ * distinguished by the type of RCU, the new grace-period number, the
+ * rcu_node structure level, the starting and ending CPU covered by the
+ * rcu_node structure, and the mask of CPUs that will be waited for.
+ * All but the type of RCU are extracted from the rcu_node structure.
+ */
+TRACE_EVENT(rcu_grace_period_init,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, u8 level,
+		 int grplo, int grphi, unsigned long qsmask),
+
+	TP_ARGS(rcuname, gpnum, level, grplo, grphi, qsmask),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(u8, level)
+		__field(int, grplo)
+		__field(int, grphi)
+		__field(unsigned long, qsmask)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->level = level;
+		__entry->grplo = grplo;
+		__entry->grphi = grphi;
+		__entry->qsmask = qsmask;
+	),
+
+	TP_printk("%s %lu %u %d %d %lx",
+		  __entry->rcuname, __entry->gpnum, __entry->level,
+		  __entry->grplo, __entry->grphi, __entry->qsmask)
+);
+
+/*
+ * Tracepoint for tasks blocking within preemptible-RCU read-side
+ * critical sections.  Track the type of RCU (which one day might
+ * include SRCU), the grace-period number that the task is blocking
+ * (the current or the next), and the task's PID.
+ */
+TRACE_EVENT(rcu_preempt_task,
+
+	TP_PROTO(char *rcuname, int pid, unsigned long gpnum),
+
+	TP_ARGS(rcuname, pid, gpnum),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(int, pid)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->pid = pid;
+	),
+
+	TP_printk("%s %lu %d",
+		  __entry->rcuname, __entry->gpnum, __entry->pid)
+);
+
+/*
+ * Tracepoint for tasks that blocked within a given preemptible-RCU
+ * read-side critical section exiting that critical section.  Track the
+ * type of RCU (which one day might include SRCU) and the task's PID.
+ */
+TRACE_EVENT(rcu_unlock_preempted_task,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, int pid),
+
+	TP_ARGS(rcuname, gpnum, pid),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(int, pid)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->pid = pid;
+	),
+
+	TP_printk("%s %lu %d", __entry->rcuname, __entry->gpnum, __entry->pid)
+);
+
+/*
+ * Tracepoint for quiescent-state-reporting events.  These are
+ * distinguished by the type of RCU, the grace-period number, the
+ * mask of quiescent lower-level entities, the rcu_node structure level,
+ * the starting and ending CPU covered by the rcu_node structure, and
+ * whether there are any blocked tasks blocking the current grace period.
+ * All but the type of RCU are extracted from the rcu_node structure.
+ */
+TRACE_EVENT(rcu_quiescent_state_report,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum,
+		 unsigned long mask, unsigned long qsmask,
+		 u8 level, int grplo, int grphi, int gp_tasks),
+
+	TP_ARGS(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(unsigned long, mask)
+		__field(unsigned long, qsmask)
+		__field(u8, level)
+		__field(int, grplo)
+		__field(int, grphi)
+		__field(u8, gp_tasks)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->mask = mask;
+		__entry->qsmask = qsmask;
+		__entry->level = level;
+		__entry->grplo = grplo;
+		__entry->grphi = grphi;
+		__entry->gp_tasks = gp_tasks;
+	),
+
+	TP_printk("%s %lu %lx>%lx %u %d %d %u",
+		  __entry->rcuname, __entry->gpnum,
+		  __entry->mask, __entry->qsmask, __entry->level,
+		  __entry->grplo, __entry->grphi, __entry->gp_tasks)
+);
+
+/*
+ * Tracepoint for quiescent states detected by force_quiescent_state().
+ * These trace events include the type of RCU, the grace-period number
+ * that was blocked by the CPU, the CPU itself, and the type of quiescent
+ * state, which can be "dti" for dyntick-idle mode, "ofl" for CPU offline,
+ * or "kick" when kicking a CPU that has been in dyntick-idle mode for
+ * too long.
+ */
+TRACE_EVENT(rcu_fqs,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, int cpu, char *qsevent),
+
+	TP_ARGS(rcuname, gpnum, cpu, qsevent),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(int, cpu)
+		__field(char *, qsevent)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->cpu = cpu;
+		__entry->qsevent = qsevent;
+	),
+
+	TP_printk("%s %lu %d %s",
+		  __entry->rcuname, __entry->gpnum,
+		  __entry->cpu, __entry->qsevent)
+);
+
+#endif /* #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) */
+
+/*
+ * Tracepoint for dyntick-idle entry/exit events.  These take a string
+ * as argument: "Start" for entering dyntick-idle mode and "End" for
+ * leaving it.
+ */
+TRACE_EVENT(rcu_dyntick,
+
+	TP_PROTO(char *polarity),
+
+	TP_ARGS(polarity),
+
+	TP_STRUCT__entry(
+		__field(char *, polarity)
+	),
+
+	TP_fast_assign(
+		__entry->polarity = polarity;
+	),
+
+	TP_printk("%s", __entry->polarity)
+);
+
+/*
+ * Tracepoint for the registration of a single RCU callback function.
+ * The first argument is the type of RCU, the second argument is
+ * a pointer to the RCU callback itself, and the third element is the
+ * new RCU callback queue length for the current CPU.
+ */
+TRACE_EVENT(rcu_callback,
+
+	TP_PROTO(char *rcuname, struct rcu_head *rhp, long qlen),
+
+	TP_ARGS(rcuname, rhp, qlen),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(void *, rhp)
+		__field(void *, func)
+		__field(long, qlen)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->rhp = rhp;
+		__entry->func = rhp->func;
+		__entry->qlen = qlen;
+	),
+
+	TP_printk("%s rhp=%p func=%pf %ld",
+		  __entry->rcuname, __entry->rhp, __entry->func, __entry->qlen)
+);
+
+/*
+ * Tracepoint for the registration of a single RCU callback of the special
+ * kfree() form.  The first argument is the RCU type, the second argument
+ * is a pointer to the RCU callback, the third argument is the offset
+ * of the callback within the enclosing RCU-protected data structure,
+ * and the fourth argument is the new RCU callback queue length for the
+ * current CPU.
+ */
+TRACE_EVENT(rcu_kfree_callback,
+
+	TP_PROTO(char *rcuname, struct rcu_head *rhp, unsigned long offset,
+		 long qlen),
+
+	TP_ARGS(rcuname, rhp, offset, qlen),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(void *, rhp)
+		__field(unsigned long, offset)
+		__field(long, qlen)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->rhp = rhp;
+		__entry->offset = offset;
+		__entry->qlen = qlen;
+	),
+
+	TP_printk("%s rhp=%p func=%ld %ld",
+		  __entry->rcuname, __entry->rhp, __entry->offset,
+		  __entry->qlen)
+);
+
+/*
+ * Tracepoint for marking the beginning rcu_do_batch, performed to start
+ * RCU callback invocation.  The first argument is the RCU flavor,
+ * the second is the total number of callbacks (including those that
+ * are not yet ready to be invoked), and the third argument is the
+ * current RCU-callback batch limit.
+ */
+TRACE_EVENT(rcu_batch_start,
+
+	TP_PROTO(char *rcuname, long qlen, int blimit),
+
+	TP_ARGS(rcuname, qlen, blimit),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(long, qlen)
+		__field(int, blimit)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->qlen = qlen;
+		__entry->blimit = blimit;
+	),
+
+	TP_printk("%s CBs=%ld bl=%d",
+		  __entry->rcuname, __entry->qlen, __entry->blimit)
+);
+
+/*
+ * Tracepoint for the invocation of a single RCU callback function.
+ * The first argument is the type of RCU, and the second argument is
+ * a pointer to the RCU callback itself.
+ */
+TRACE_EVENT(rcu_invoke_callback,
+
+	TP_PROTO(char *rcuname, struct rcu_head *rhp),
+
+	TP_ARGS(rcuname, rhp),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(void *, rhp)
+		__field(void *, func)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->rhp = rhp;
+		__entry->func = rhp->func;
+	),
+
+	TP_printk("%s rhp=%p func=%pf",
+		  __entry->rcuname, __entry->rhp, __entry->func)
+);
+
+/*
+ * Tracepoint for the invocation of a single RCU callback of the special
+ * kfree() form.  The first argument is the RCU flavor, the second
+ * argument is a pointer to the RCU callback, and the third argument
+ * is the offset of the callback within the enclosing RCU-protected
+ * data structure.
+ */
+TRACE_EVENT(rcu_invoke_kfree_callback,
+
+	TP_PROTO(char *rcuname, struct rcu_head *rhp, unsigned long offset),
+
+	TP_ARGS(rcuname, rhp, offset),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(void *, rhp)
+		__field(unsigned long, offset)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->rhp = rhp;
+		__entry->offset	= offset;
+	),
+
+	TP_printk("%s rhp=%p func=%ld",
+		  __entry->rcuname, __entry->rhp, __entry->offset)
+);
+
+/*
+ * Tracepoint for exiting rcu_do_batch after RCU callbacks have been
+ * invoked.  The first argument is the name of the RCU flavor and
+ * the second argument is number of callbacks actually invoked.
+ */
+TRACE_EVENT(rcu_batch_end,
+
+	TP_PROTO(char *rcuname, int callbacks_invoked),
+
+	TP_ARGS(rcuname, callbacks_invoked),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(int, callbacks_invoked)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->callbacks_invoked = callbacks_invoked;
+	),
+
+	TP_printk("%s CBs-invoked=%d",
+		  __entry->rcuname, __entry->callbacks_invoked)
+);
+
+#else /* #ifdef CONFIG_RCU_TRACE */
+
+#define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
+#define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, qsmask) do { } while (0)
+#define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
+#define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
+#define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks) do { } while (0)
+#define trace_rcu_fqs(rcuname, gpnum, cpu, qsevent) do { } while (0)
+#define trace_rcu_dyntick(polarity) do { } while (0)
+#define trace_rcu_callback(rcuname, rhp, qlen) do { } while (0)
+#define trace_rcu_kfree_callback(rcuname, rhp, offset, qlen) do { } while (0)
+#define trace_rcu_batch_start(rcuname, qlen, blimit) do { } while (0)
+#define trace_rcu_invoke_callback(rcuname, rhp) do { } while (0)
+#define trace_rcu_invoke_kfree_callback(rcuname, rhp, offset) do { } while (0)
+#define trace_rcu_batch_end(rcuname, callbacks_invoked) do { } while (0)
+
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
+#endif /* _TRACE_RCU_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/init/Kconfig b/init/Kconfig
index d627783..dc7e27b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -391,7 +391,7 @@ config TREE_RCU
 
 config TREE_PREEMPT_RCU
 	bool "Preemptible tree-based hierarchical RCU"
-	depends on PREEMPT
+	depends on PREEMPT && SMP
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
@@ -401,7 +401,7 @@ config TREE_PREEMPT_RCU
 
 config TINY_RCU
 	bool "UP-only small-memory-footprint RCU"
-	depends on !SMP
+	depends on !PREEMPT && !SMP
 	help
 	  This option selects the RCU implementation that is
 	  designed for UP systems from which real-time response
@@ -410,7 +410,7 @@ config TINY_RCU
 
 config TINY_PREEMPT_RCU
 	bool "Preemptible UP-only small-memory-footprint RCU"
-	depends on !SMP && PREEMPT
+	depends on PREEMPT && !SMP
 	help
 	  This option selects the RCU implementation that is designed
 	  for real-time UP systems.  This option greatly reduces the
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 91d67ce..1e48f1c 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1129,10 +1129,11 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth,
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n=======================================================\n");
-	printk(  "[ INFO: possible circular locking dependency detected ]\n");
+	printk("\n");
+	printk("======================================================\n");
+	printk("[ INFO: possible circular locking dependency detected ]\n");
 	print_kernel_version();
-	printk(  "-------------------------------------------------------\n");
+	printk("-------------------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
 	print_lock(check_src);
@@ -1463,11 +1464,12 @@ print_bad_irq_dependency(struct task_struct *curr,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n======================================================\n");
-	printk(  "[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
+	printk("\n");
+	printk("======================================================\n");
+	printk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
 		irqclass, irqclass);
 	print_kernel_version();
-	printk(  "------------------------------------------------------\n");
+	printk("------------------------------------------------------\n");
 	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
 		curr->comm, task_pid_nr(curr),
 		curr->hardirq_context, hardirq_count() >> HARDIRQ_SHIFT,
@@ -1692,10 +1694,11 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n=============================================\n");
-	printk(  "[ INFO: possible recursive locking detected ]\n");
+	printk("\n");
+	printk("=============================================\n");
+	printk("[ INFO: possible recursive locking detected ]\n");
 	print_kernel_version();
-	printk(  "---------------------------------------------\n");
+	printk("---------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
 	print_lock(next);
@@ -2177,10 +2180,11 @@ print_usage_bug(struct task_struct *curr, struct held_lock *this,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n=================================\n");
-	printk(  "[ INFO: inconsistent lock state ]\n");
+	printk("\n");
+	printk("=================================\n");
+	printk("[ INFO: inconsistent lock state ]\n");
 	print_kernel_version();
-	printk(  "---------------------------------\n");
+	printk("---------------------------------\n");
 
 	printk("inconsistent {%s} -> {%s} usage.\n",
 		usage_str[prev_bit], usage_str[new_bit]);
@@ -2241,10 +2245,11 @@ print_irq_inversion_bug(struct task_struct *curr,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n=========================================================\n");
-	printk(  "[ INFO: possible irq lock inversion dependency detected ]\n");
+	printk("\n");
+	printk("=========================================================\n");
+	printk("[ INFO: possible irq lock inversion dependency detected ]\n");
 	print_kernel_version();
-	printk(  "---------------------------------------------------------\n");
+	printk("---------------------------------------------------------\n");
 	printk("%s/%d just changed the state of lock:\n",
 		curr->comm, task_pid_nr(curr));
 	print_lock(this);
@@ -3065,9 +3070,10 @@ print_unlock_inbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n=====================================\n");
-	printk(  "[ BUG: bad unlock balance detected! ]\n");
-	printk(  "-------------------------------------\n");
+	printk("\n");
+	printk("=====================================\n");
+	printk("[ BUG: bad unlock balance detected! ]\n");
+	printk("-------------------------------------\n");
 	printk("%s/%d is trying to release lock (",
 		curr->comm, task_pid_nr(curr));
 	print_lockdep_cache(lock);
@@ -3478,9 +3484,10 @@ print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n=================================\n");
-	printk(  "[ BUG: bad contention detected! ]\n");
-	printk(  "---------------------------------\n");
+	printk("\n");
+	printk("=================================\n");
+	printk("[ BUG: bad contention detected! ]\n");
+	printk("---------------------------------\n");
 	printk("%s/%d is trying to contend lock (",
 		curr->comm, task_pid_nr(curr));
 	print_lockdep_cache(lock);
@@ -3839,9 +3846,10 @@ print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
 	if (debug_locks_silent)
 		return;
 
-	printk("\n=========================\n");
-	printk(  "[ BUG: held lock freed! ]\n");
-	printk(  "-------------------------\n");
+	printk("\n");
+	printk("=========================\n");
+	printk("[ BUG: held lock freed! ]\n");
+	printk("-------------------------\n");
 	printk("%s/%d is freeing memory %p-%p, with a lock still held there!\n",
 		curr->comm, task_pid_nr(curr), mem_from, mem_to-1);
 	print_lock(hlock);
@@ -3895,9 +3903,10 @@ static void print_held_locks_bug(struct task_struct *curr)
 	if (debug_locks_silent)
 		return;
 
-	printk("\n=====================================\n");
-	printk(  "[ BUG: lock held at task exit time! ]\n");
-	printk(  "-------------------------------------\n");
+	printk("\n");
+	printk("=====================================\n");
+	printk("[ BUG: lock held at task exit time! ]\n");
+	printk("-------------------------------------\n");
 	printk("%s/%d is exiting with locks still held!\n",
 		curr->comm, task_pid_nr(curr));
 	lockdep_print_held_locks(curr);
@@ -3991,16 +4000,17 @@ void lockdep_sys_exit(void)
 	if (unlikely(curr->lockdep_depth)) {
 		if (!debug_locks_off())
 			return;
-		printk("\n================================================\n");
-		printk(  "[ BUG: lock held when returning to user space! ]\n");
-		printk(  "------------------------------------------------\n");
+		printk("\n");
+		printk("================================================\n");
+		printk("[ BUG: lock held when returning to user space! ]\n");
+		printk("------------------------------------------------\n");
 		printk("%s/%d is leaving the kernel with locks still held!\n",
 				curr->comm, curr->pid);
 		lockdep_print_held_locks(curr);
 	}
 }
 
-void lockdep_rcu_dereference(const char *file, const int line)
+void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 {
 	struct task_struct *curr = current;
 
@@ -4009,15 +4019,15 @@ void lockdep_rcu_dereference(const char *file, const int line)
 		return;
 #endif /* #ifdef CONFIG_PROVE_RCU_REPEATEDLY */
 	/* Note: the following can be executed concurrently, so be careful. */
-	printk("\n===================================================\n");
-	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
-	printk(  "---------------------------------------------------\n");
-	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
-			file, line);
+	printk("\n");
+	printk("===============================\n");
+	printk("[ INFO: suspicious RCU usage. ]\n");
+	printk("-------------------------------\n");
+	printk("%s:%d %s!\n", file, line, s);
 	printk("\nother info that might help us debug this:\n\n");
 	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
 	lockdep_print_held_locks(curr);
 	printk("\nstack backtrace:\n");
 	dump_stack();
 }
-EXPORT_SYMBOL_GPL(lockdep_rcu_dereference);
+EXPORT_SYMBOL_GPL(lockdep_rcu_suspicious);
diff --git a/kernel/pid.c b/kernel/pid.c
index e432057..8cafe7e 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -418,7 +418,9 @@ EXPORT_SYMBOL(pid_task);
  */
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
-	rcu_lockdep_assert(rcu_read_lock_held());
+	rcu_lockdep_assert(rcu_read_lock_held(),
+			   "find_task_by_pid_ns() needs rcu_read_lock()"
+			   " protection");
 	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
 }
 
diff --git a/kernel/rcu.h b/kernel/rcu.h
new file mode 100644
index 0000000..f600868
--- /dev/null
+++ b/kernel/rcu.h
@@ -0,0 +1,85 @@
+/*
+ * Read-Copy Update definitions shared among RCU implementations.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2011
+ *
+ * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ */
+
+#ifndef __LINUX_RCU_H
+#define __LINUX_RCU_H
+
+#ifdef CONFIG_RCU_TRACE
+#define RCU_TRACE(stmt) stmt
+#else /* #ifdef CONFIG_RCU_TRACE */
+#define RCU_TRACE(stmt)
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
+/*
+ * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
+ * by call_rcu() and rcu callback execution, and are therefore not part of the
+ * RCU API. Leaving in rcupdate.h because they are used by all RCU flavors.
+ */
+
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+# define STATE_RCU_HEAD_READY	0
+# define STATE_RCU_HEAD_QUEUED	1
+
+extern struct debug_obj_descr rcuhead_debug_descr;
+
+static inline void debug_rcu_head_queue(struct rcu_head *head)
+{
+	WARN_ON_ONCE((unsigned long)head & 0x3);
+	debug_object_activate(head, &rcuhead_debug_descr);
+	debug_object_active_state(head, &rcuhead_debug_descr,
+				  STATE_RCU_HEAD_READY,
+				  STATE_RCU_HEAD_QUEUED);
+}
+
+static inline void debug_rcu_head_unqueue(struct rcu_head *head)
+{
+	debug_object_active_state(head, &rcuhead_debug_descr,
+				  STATE_RCU_HEAD_QUEUED,
+				  STATE_RCU_HEAD_READY);
+	debug_object_deactivate(head, &rcuhead_debug_descr);
+}
+#else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+static inline void debug_rcu_head_queue(struct rcu_head *head)
+{
+}
+
+static inline void debug_rcu_head_unqueue(struct rcu_head *head)
+{
+}
+#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+
+extern void kfree(const void *);
+
+static inline void __rcu_reclaim(char *rn, struct rcu_head *head)
+{
+	unsigned long offset = (unsigned long)head->func;
+
+	if (__is_kfree_rcu_offset(offset)) {
+		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
+		kfree((void *)head - offset);
+	} else {
+		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
+		head->func(head);
+	}
+}
+
+#endif /* __LINUX_RCU_H */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index ddddb32..ca0d23b 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -46,6 +46,11 @@
 #include <linux/module.h>
 #include <linux/hardirq.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/rcu.h>
+
+#include "rcu.h"
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
@@ -94,11 +99,16 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+struct rcu_synchronize {
+	struct rcu_head head;
+	struct completion completion;
+};
+
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
  */
-void wakeme_after_rcu(struct rcu_head  *head)
+static void wakeme_after_rcu(struct rcu_head  *head)
 {
 	struct rcu_synchronize *rcu;
 
@@ -106,6 +116,20 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	complete(&rcu->completion);
 }
 
+void wait_rcu_gp(call_rcu_func_t crf)
+{
+	struct rcu_synchronize rcu;
+
+	init_rcu_head_on_stack(&rcu.head);
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	crf(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
+}
+EXPORT_SYMBOL_GPL(wait_rcu_gp);
+
 #ifdef CONFIG_PROVE_RCU
 /*
  * wrapper function to avoid #include problems.
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 7bbac7d..da775c8 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -37,16 +37,17 @@
 #include <linux/cpu.h>
 #include <linux/prefetch.h>
 
-/* Controls for rcu_kthread() kthread, replacing RCU_SOFTIRQ used previously. */
-static struct task_struct *rcu_kthread_task;
-static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
-static unsigned long have_rcu_kthread_work;
+#ifdef CONFIG_RCU_TRACE
+#include <trace/events/rcu.h>
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
+#include "rcu.h"
 
 /* Forward declarations for rcutiny_plugin.h. */
 struct rcu_ctrlblk;
-static void invoke_rcu_kthread(void);
-static void rcu_process_callbacks(struct rcu_ctrlblk *rcp);
-static int rcu_kthread(void *arg);
+static void invoke_rcu_callbacks(void);
+static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp);
+static void rcu_process_callbacks(struct softirq_action *unused);
 static void __call_rcu(struct rcu_head *head,
 		       void (*func)(struct rcu_head *rcu),
 		       struct rcu_ctrlblk *rcp);
@@ -96,16 +97,6 @@ static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 }
 
 /*
- * Wake up rcu_kthread() to process callbacks now eligible for invocation
- * or to boost readers.
- */
-static void invoke_rcu_kthread(void)
-{
-	have_rcu_kthread_work = 1;
-	wake_up(&rcu_kthread_wq);
-}
-
-/*
  * Record an rcu quiescent state.  And an rcu_bh quiescent state while we
  * are at it, given that any rcu quiescent state is also an rcu_bh
  * quiescent state.  Use "+" instead of "||" to defeat short circuiting.
@@ -117,7 +108,7 @@ void rcu_sched_qs(int cpu)
 	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
 	    rcu_qsctr_help(&rcu_bh_ctrlblk))
-		invoke_rcu_kthread();
+		invoke_rcu_callbacks();
 	local_irq_restore(flags);
 }
 
@@ -130,7 +121,7 @@ void rcu_bh_qs(int cpu)
 
 	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
-		invoke_rcu_kthread();
+		invoke_rcu_callbacks();
 	local_irq_restore(flags);
 }
 
@@ -154,18 +145,23 @@ void rcu_check_callbacks(int cpu, int user)
  * Invoke the RCU callbacks on the specified rcu_ctrlkblk structure
  * whose grace period has elapsed.
  */
-static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
+static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 {
+	char *rn = NULL;
 	struct rcu_head *next, *list;
 	unsigned long flags;
 	RCU_TRACE(int cb_count = 0);
 
 	/* If no RCU callbacks ready to invoke, just return. */
-	if (&rcp->rcucblist == rcp->donetail)
+	if (&rcp->rcucblist == rcp->donetail) {
+		RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, -1));
+		RCU_TRACE(trace_rcu_batch_end(rcp->name, 0));
 		return;
+	}
 
 	/* Move the ready-to-invoke callbacks to a local list. */
 	local_irq_save(flags);
+	RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, -1));
 	list = rcp->rcucblist;
 	rcp->rcucblist = *rcp->donetail;
 	*rcp->donetail = NULL;
@@ -176,49 +172,26 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	local_irq_restore(flags);
 
 	/* Invoke the callbacks on the local list. */
+	RCU_TRACE(rn = rcp->name);
 	while (list) {
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
 		local_bh_disable();
-		__rcu_reclaim(list);
+		__rcu_reclaim(rn, list);
 		local_bh_enable();
 		list = next;
 		RCU_TRACE(cb_count++);
 	}
 	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
+	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count));
 }
 
-/*
- * This kthread invokes RCU callbacks whose grace periods have
- * elapsed.  It is awakened as needed, and takes the place of the
- * RCU_SOFTIRQ that was used previously for this purpose.
- * This is a kthread, but it is never stopped, at least not until
- * the system goes down.
- */
-static int rcu_kthread(void *arg)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
-	unsigned long work;
-	unsigned long morework;
-	unsigned long flags;
-
-	for (;;) {
-		wait_event_interruptible(rcu_kthread_wq,
-					 have_rcu_kthread_work != 0);
-		morework = rcu_boost();
-		local_irq_save(flags);
-		work = have_rcu_kthread_work;
-		have_rcu_kthread_work = morework;
-		local_irq_restore(flags);
-		if (work) {
-			rcu_process_callbacks(&rcu_sched_ctrlblk);
-			rcu_process_callbacks(&rcu_bh_ctrlblk);
-			rcu_preempt_process_callbacks();
-		}
-		schedule_timeout_interruptible(1); /* Leave CPU for others. */
-	}
-
-	return 0;  /* Not reached, but needed to shut gcc up. */
+	__rcu_process_callbacks(&rcu_sched_ctrlblk);
+	__rcu_process_callbacks(&rcu_bh_ctrlblk);
+	rcu_preempt_process_callbacks();
 }
 
 /*
@@ -280,45 +253,3 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 	__call_rcu(head, func, &rcu_bh_ctrlblk);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
-
-void rcu_barrier_bh(void)
-{
-	struct rcu_synchronize rcu;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_bh(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier_bh);
-
-void rcu_barrier_sched(void)
-{
-	struct rcu_synchronize rcu;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_sched(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier_sched);
-
-/*
- * Spawn the kthread that invokes RCU callbacks.
- */
-static int __init rcu_spawn_kthreads(void)
-{
-	struct sched_param sp;
-
-	rcu_kthread_task = kthread_run(rcu_kthread, NULL, "rcu_kthread");
-	sp.sched_priority = RCU_BOOST_PRIO;
-	sched_setscheduler_nocheck(rcu_kthread_task, SCHED_FIFO, &sp);
-	return 0;
-}
-early_initcall(rcu_spawn_kthreads);
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index f259c67..02aa713 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -26,29 +26,26 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 
-#ifdef CONFIG_RCU_TRACE
-#define RCU_TRACE(stmt)	stmt
-#else /* #ifdef CONFIG_RCU_TRACE */
-#define RCU_TRACE(stmt)
-#endif /* #else #ifdef CONFIG_RCU_TRACE */
-
 /* Global control variables for rcupdate callback mechanism. */
 struct rcu_ctrlblk {
 	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
 	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
 	struct rcu_head **curtail;	/* ->next pointer of last CB. */
 	RCU_TRACE(long qlen);		/* Number of pending CBs. */
+	RCU_TRACE(char *name);		/* Name of RCU type. */
 };
 
 /* Definition for rcupdate control block. */
 static struct rcu_ctrlblk rcu_sched_ctrlblk = {
 	.donetail	= &rcu_sched_ctrlblk.rcucblist,
 	.curtail	= &rcu_sched_ctrlblk.rcucblist,
+	RCU_TRACE(.name = "rcu_sched")
 };
 
 static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.donetail	= &rcu_bh_ctrlblk.rcucblist,
 	.curtail	= &rcu_bh_ctrlblk.rcucblist,
+	RCU_TRACE(.name = "rcu_bh")
 };
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -131,6 +128,7 @@ static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
 	.rcb.curtail = &rcu_preempt_ctrlblk.rcb.rcucblist,
 	.nexttail = &rcu_preempt_ctrlblk.rcb.rcucblist,
 	.blkd_tasks = LIST_HEAD_INIT(rcu_preempt_ctrlblk.blkd_tasks),
+	RCU_TRACE(.rcb.name = "rcu_preempt")
 };
 
 static int rcu_preempted_readers_exp(void);
@@ -247,6 +245,13 @@ static void show_tiny_preempt_stats(struct seq_file *m)
 
 #include "rtmutex_common.h"
 
+#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
+
+/* Controls for rcu_kthread() kthread. */
+static struct task_struct *rcu_kthread_task;
+static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
+static unsigned long have_rcu_kthread_work;
+
 /*
  * Carry out RCU priority boosting on the task indicated by ->boost_tasks,
  * and advance ->boost_tasks to the next task in the ->blkd_tasks list.
@@ -334,7 +339,7 @@ static int rcu_initiate_boost(void)
 		if (rcu_preempt_ctrlblk.exp_tasks == NULL)
 			rcu_preempt_ctrlblk.boost_tasks =
 				rcu_preempt_ctrlblk.gp_tasks;
-		invoke_rcu_kthread();
+		invoke_rcu_callbacks();
 	} else
 		RCU_TRACE(rcu_initiate_boost_trace());
 	return 1;
@@ -353,14 +358,6 @@ static void rcu_preempt_boost_start_gp(void)
 #else /* #ifdef CONFIG_RCU_BOOST */
 
 /*
- * If there is no RCU priority boosting, we don't boost.
- */
-static int rcu_boost(void)
-{
-	return 0;
-}
-
-/*
  * If there is no RCU priority boosting, we don't initiate boosting,
  * but we do indicate whether there are blocked readers blocking the
  * current grace period.
@@ -427,7 +424,7 @@ static void rcu_preempt_cpu_qs(void)
 
 	/* If there are done callbacks, cause them to be invoked. */
 	if (*rcu_preempt_ctrlblk.rcb.donetail != NULL)
-		invoke_rcu_kthread();
+		invoke_rcu_callbacks();
 }
 
 /*
@@ -648,7 +645,7 @@ static void rcu_preempt_check_callbacks(void)
 		rcu_preempt_cpu_qs();
 	if (&rcu_preempt_ctrlblk.rcb.rcucblist !=
 	    rcu_preempt_ctrlblk.rcb.donetail)
-		invoke_rcu_kthread();
+		invoke_rcu_callbacks();
 	if (rcu_preempt_gp_in_progress() &&
 	    rcu_cpu_blocking_cur_gp() &&
 	    rcu_preempt_running_reader())
@@ -674,7 +671,7 @@ static void rcu_preempt_remove_callbacks(struct rcu_ctrlblk *rcp)
  */
 static void rcu_preempt_process_callbacks(void)
 {
-	rcu_process_callbacks(&rcu_preempt_ctrlblk.rcb);
+	__rcu_process_callbacks(&rcu_preempt_ctrlblk.rcb);
 }
 
 /*
@@ -697,20 +694,6 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
-void rcu_barrier(void)
-{
-	struct rcu_synchronize rcu;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier);
-
 /*
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -864,15 +847,6 @@ static void show_tiny_preempt_stats(struct seq_file *m)
 #endif /* #ifdef CONFIG_RCU_TRACE */
 
 /*
- * Because preemptible RCU does not exist, it is never necessary to
- * boost preempted RCU readers.
- */
-static int rcu_boost(void)
-{
-	return 0;
-}
-
-/*
  * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
  */
@@ -898,6 +872,78 @@ static void rcu_preempt_process_callbacks(void)
 
 #endif /* #else #ifdef CONFIG_TINY_PREEMPT_RCU */
 
+#ifdef CONFIG_RCU_BOOST
+
+/*
+ * Wake up rcu_kthread() to process callbacks now eligible for invocation
+ * or to boost readers.
+ */
+static void invoke_rcu_callbacks(void)
+{
+	have_rcu_kthread_work = 1;
+	wake_up(&rcu_kthread_wq);
+}
+
+/*
+ * This kthread invokes RCU callbacks whose grace periods have
+ * elapsed.  It is awakened as needed, and takes the place of the
+ * RCU_SOFTIRQ that is used for this purpose when boosting is disabled.
+ * This is a kthread, but it is never stopped, at least not until
+ * the system goes down.
+ */
+static int rcu_kthread(void *arg)
+{
+	unsigned long work;
+	unsigned long morework;
+	unsigned long flags;
+
+	for (;;) {
+		wait_event_interruptible(rcu_kthread_wq,
+					 have_rcu_kthread_work != 0);
+		morework = rcu_boost();
+		local_irq_save(flags);
+		work = have_rcu_kthread_work;
+		have_rcu_kthread_work = morework;
+		local_irq_restore(flags);
+		if (work)
+			rcu_process_callbacks(NULL);
+		schedule_timeout_interruptible(1); /* Leave CPU for others. */
+	}
+
+	return 0;  /* Not reached, but needed to shut gcc up. */
+}
+
+/*
+ * Spawn the kthread that invokes RCU callbacks.
+ */
+static int __init rcu_spawn_kthreads(void)
+{
+	struct sched_param sp;
+
+	rcu_kthread_task = kthread_run(rcu_kthread, NULL, "rcu_kthread");
+	sp.sched_priority = RCU_BOOST_PRIO;
+	sched_setscheduler_nocheck(rcu_kthread_task, SCHED_FIFO, &sp);
+	return 0;
+}
+early_initcall(rcu_spawn_kthreads);
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+/*
+ * Start up softirq processing of callbacks.
+ */
+void invoke_rcu_callbacks(void)
+{
+	raise_softirq(RCU_SOFTIRQ);
+}
+
+void rcu_init(void)
+{
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #include <linux/kernel_stat.h>
 
@@ -913,12 +959,6 @@ void __init rcu_scheduler_starting(void)
 
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
-#ifdef CONFIG_RCU_BOOST
-#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
-#else /* #ifdef CONFIG_RCU_BOOST */
-#define RCU_BOOST_PRIO 1
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
-
 #ifdef CONFIG_RCU_TRACE
 
 #ifdef CONFIG_RCU_BOOST
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 98f51b1..764825c 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -73,7 +73,7 @@ module_param(nreaders, int, 0444);
 MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
 module_param(nfakewriters, int, 0444);
 MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
-module_param(stat_interval, int, 0444);
+module_param(stat_interval, int, 0644);
 MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
 module_param(verbose, bool, 0444);
 MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
@@ -480,30 +480,6 @@ static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
 	call_rcu_bh(&p->rtort_rcu, rcu_torture_cb);
 }
 
-struct rcu_bh_torture_synchronize {
-	struct rcu_head head;
-	struct completion completion;
-};
-
-static void rcu_bh_torture_wakeme_after_cb(struct rcu_head *head)
-{
-	struct rcu_bh_torture_synchronize *rcu;
-
-	rcu = container_of(head, struct rcu_bh_torture_synchronize, head);
-	complete(&rcu->completion);
-}
-
-static void rcu_bh_torture_synchronize(void)
-{
-	struct rcu_bh_torture_synchronize rcu;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	call_rcu_bh(&rcu.head, rcu_bh_torture_wakeme_after_cb);
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
-}
-
 static struct rcu_torture_ops rcu_bh_ops = {
 	.init		= NULL,
 	.cleanup	= NULL,
@@ -512,7 +488,7 @@ static struct rcu_torture_ops rcu_bh_ops = {
 	.readunlock	= rcu_bh_torture_read_unlock,
 	.completed	= rcu_bh_torture_completed,
 	.deferred_free	= rcu_bh_torture_deferred_free,
-	.sync		= rcu_bh_torture_synchronize,
+	.sync		= synchronize_rcu_bh,
 	.cb_barrier	= rcu_barrier_bh,
 	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
@@ -528,7 +504,7 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.readunlock	= rcu_bh_torture_read_unlock,
 	.completed	= rcu_bh_torture_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= rcu_bh_torture_synchronize,
+	.sync		= synchronize_rcu_bh,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
@@ -536,6 +512,22 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.name		= "rcu_bh_sync"
 };
 
+static struct rcu_torture_ops rcu_bh_expedited_ops = {
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= rcu_bh_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= rcu_bh_torture_read_unlock,
+	.completed	= rcu_bh_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= synchronize_rcu_bh_expedited,
+	.cb_barrier	= NULL,
+	.fqs		= rcu_bh_force_quiescent_state,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_bh_expedited"
+};
+
 /*
  * Definitions for srcu torture testing.
  */
@@ -659,11 +651,6 @@ static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
 	call_rcu_sched(&p->rtort_rcu, rcu_torture_cb);
 }
 
-static void sched_torture_synchronize(void)
-{
-	synchronize_sched();
-}
-
 static struct rcu_torture_ops sched_ops = {
 	.init		= rcu_sync_torture_init,
 	.cleanup	= NULL,
@@ -672,7 +659,7 @@ static struct rcu_torture_ops sched_ops = {
 	.readunlock	= sched_torture_read_unlock,
 	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sched_torture_deferred_free,
-	.sync		= sched_torture_synchronize,
+	.sync		= synchronize_sched,
 	.cb_barrier	= rcu_barrier_sched,
 	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= NULL,
@@ -688,7 +675,7 @@ static struct rcu_torture_ops sched_sync_ops = {
 	.readunlock	= sched_torture_read_unlock,
 	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= sched_torture_synchronize,
+	.sync		= synchronize_sched,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= NULL,
@@ -754,7 +741,7 @@ static int rcu_torture_boost(void *arg)
 	do {
 		/* Wait for the next test interval. */
 		oldstarttime = boost_starttime;
-		while (jiffies - oldstarttime > ULONG_MAX / 2) {
+		while (ULONG_CMP_LT(jiffies, oldstarttime)) {
 			schedule_timeout_uninterruptible(1);
 			rcu_stutter_wait("rcu_torture_boost");
 			if (kthread_should_stop() ||
@@ -765,7 +752,7 @@ static int rcu_torture_boost(void *arg)
 		/* Do one boost-test interval. */
 		endtime = oldstarttime + test_boost_duration * HZ;
 		call_rcu_time = jiffies;
-		while (jiffies - endtime > ULONG_MAX / 2) {
+		while (ULONG_CMP_LT(jiffies, endtime)) {
 			/* If we don't have a callback in flight, post one. */
 			if (!rbi.inflight) {
 				smp_mb(); /* RCU core before ->inflight = 1. */
@@ -792,7 +779,8 @@ static int rcu_torture_boost(void *arg)
 		 * interval.  Besides, we are running at RT priority,
 		 * so delays should be relatively rare.
 		 */
-		while (oldstarttime == boost_starttime) {
+		while (oldstarttime == boost_starttime &&
+		       !kthread_should_stop()) {
 			if (mutex_trylock(&boost_mutex)) {
 				boost_starttime = jiffies +
 						  test_boost_interval * HZ;
@@ -809,11 +797,11 @@ checkwait:	rcu_stutter_wait("rcu_torture_boost");
 
 	/* Clean up and exit. */
 	VERBOSE_PRINTK_STRING("rcu_torture_boost task stopping");
-	destroy_rcu_head_on_stack(&rbi.rcu);
 	rcutorture_shutdown_absorb("rcu_torture_boost");
 	while (!kthread_should_stop() || rbi.inflight)
 		schedule_timeout_uninterruptible(1);
 	smp_mb(); /* order accesses to ->inflight before stack-frame death. */
+	destroy_rcu_head_on_stack(&rbi.rcu);
 	return 0;
 }
 
@@ -831,11 +819,13 @@ rcu_torture_fqs(void *arg)
 	VERBOSE_PRINTK_STRING("rcu_torture_fqs task started");
 	do {
 		fqs_resume_time = jiffies + fqs_stutter * HZ;
-		while (jiffies - fqs_resume_time > LONG_MAX) {
+		while (ULONG_CMP_LT(jiffies, fqs_resume_time) &&
+		       !kthread_should_stop()) {
 			schedule_timeout_interruptible(1);
 		}
 		fqs_burst_remaining = fqs_duration;
-		while (fqs_burst_remaining > 0) {
+		while (fqs_burst_remaining > 0 &&
+		       !kthread_should_stop()) {
 			cur_ops->fqs();
 			udelay(fqs_holdoff);
 			fqs_burst_remaining -= fqs_holdoff;
@@ -1280,8 +1270,9 @@ static int rcutorture_booster_init(int cpu)
 	/* Don't allow time recalculation while creating a new task. */
 	mutex_lock(&boost_mutex);
 	VERBOSE_PRINTK_STRING("Creating rcu_torture_boost task");
-	boost_tasks[cpu] = kthread_create(rcu_torture_boost, NULL,
-					  "rcu_torture_boost");
+	boost_tasks[cpu] = kthread_create_on_node(rcu_torture_boost, NULL,
+						  cpu_to_node(cpu),
+						  "rcu_torture_boost");
 	if (IS_ERR(boost_tasks[cpu])) {
 		retval = PTR_ERR(boost_tasks[cpu]);
 		VERBOSE_PRINTK_STRING("rcu_torture_boost task create failed");
@@ -1424,7 +1415,7 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
-		  &rcu_bh_ops, &rcu_bh_sync_ops,
+		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
 		  &srcu_ops, &srcu_expedited_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ba06207..e234eb9 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -52,13 +52,16 @@
 #include <linux/prefetch.h>
 
 #include "rcutree.h"
+#include <trace/events/rcu.h>
+
+#include "rcu.h"
 
 /* Data structures. */
 
 static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 
 #define RCU_STATE_INITIALIZER(structname) { \
-	.level = { &structname.node[0] }, \
+	.level = { &structname##_state.node[0] }, \
 	.levelcnt = { \
 		NUM_RCU_LVL_0,  /* root of hierarchy. */ \
 		NUM_RCU_LVL_1, \
@@ -69,17 +72,17 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
-	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname.onofflock), \
-	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname.fqslock), \
+	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.onofflock), \
+	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
 	.name = #structname, \
 }
 
-struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched_state);
+struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched);
 DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 
-struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
+struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 static struct rcu_state *rcu_state;
@@ -128,8 +131,6 @@ static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 
-#define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
-
 /*
  * Track the rcutorture test sequence number and the update version
  * number within a given test.  The rcutorture_testseq is incremented
@@ -156,33 +157,41 @@ static int rcu_gp_in_progress(struct rcu_state *rsp)
  * Note a quiescent state.  Because we do not need to know
  * how many quiescent states passed, just if there was at least
  * one since the start of the grace period, this just sets a flag.
+ * The caller must have disabled preemption.
  */
 void rcu_sched_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
 
-	rdp->passed_quiesc_completed = rdp->gpnum - 1;
+	rdp->passed_quiesce_gpnum = rdp->gpnum;
 	barrier();
-	rdp->passed_quiesc = 1;
+	if (rdp->passed_quiesce == 0)
+		trace_rcu_grace_period("rcu_sched", rdp->gpnum, "cpuqs");
+	rdp->passed_quiesce = 1;
 }
 
 void rcu_bh_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
 
-	rdp->passed_quiesc_completed = rdp->gpnum - 1;
+	rdp->passed_quiesce_gpnum = rdp->gpnum;
 	barrier();
-	rdp->passed_quiesc = 1;
+	if (rdp->passed_quiesce == 0)
+		trace_rcu_grace_period("rcu_bh", rdp->gpnum, "cpuqs");
+	rdp->passed_quiesce = 1;
 }
 
 /*
  * Note a context switch.  This is a quiescent state for RCU-sched,
  * and requires special handling for preemptible RCU.
+ * The caller must have disabled preemption.
  */
 void rcu_note_context_switch(int cpu)
 {
+	trace_rcu_utilization("Start context switch");
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
+	trace_rcu_utilization("End context switch");
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
@@ -193,7 +202,7 @@ DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 };
 #endif /* #ifdef CONFIG_NO_HZ */
 
-static int blimit = 10;		/* Maximum callbacks per softirq. */
+static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
 static int qhimark = 10000;	/* If this many pending, ignore blimit. */
 static int qlowmark = 100;	/* Once only this many pending, use blimit. */
 
@@ -314,6 +323,7 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 	 * trust its state not to change because interrupts are disabled.
 	 */
 	if (cpu_is_offline(rdp->cpu)) {
+		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
 		rdp->offline_fqs++;
 		return 1;
 	}
@@ -354,19 +364,13 @@ void rcu_enter_nohz(void)
 		local_irq_restore(flags);
 		return;
 	}
+	trace_rcu_dyntick("Start");
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 	local_irq_restore(flags);
-
-	/* If the interrupt queued a callback, get out of dyntick mode. */
-	if (in_irq() &&
-	    (__get_cpu_var(rcu_sched_data).nxtlist ||
-	     __get_cpu_var(rcu_bh_data).nxtlist ||
-	     rcu_preempt_needs_cpu(smp_processor_id())))
-		set_need_resched();
 }
 
 /*
@@ -391,6 +395,7 @@ void rcu_exit_nohz(void)
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	trace_rcu_dyntick("End");
 	local_irq_restore(flags);
 }
 
@@ -481,11 +486,11 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
  */
 static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 {
-	unsigned long curr;
-	unsigned long snap;
+	unsigned int curr;
+	unsigned int snap;
 
-	curr = (unsigned long)atomic_add_return(0, &rdp->dynticks->dynticks);
-	snap = (unsigned long)rdp->dynticks_snap;
+	curr = (unsigned int)atomic_add_return(0, &rdp->dynticks->dynticks);
+	snap = (unsigned int)rdp->dynticks_snap;
 
 	/*
 	 * If the CPU passed through or entered a dynticks idle phase with
@@ -495,7 +500,8 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	 * read-side critical section that started before the beginning
 	 * of the current RCU grace period.
 	 */
-	if ((curr & 0x1) == 0 || ULONG_CMP_GE(curr, snap + 2)) {
+	if ((curr & 0x1) == 0 || UINT_CMP_GE(curr, snap + 2)) {
+		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "dti");
 		rdp->dynticks_fqs++;
 		return 1;
 	}
@@ -537,6 +543,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	int cpu;
 	long delta;
 	unsigned long flags;
+	int ndetected;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Only let one CPU complain about others per time interval. */
@@ -553,7 +560,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	 * Now rat on any tasks that got kicked up to the root rcu_node
 	 * due to CPU offlining.
 	 */
-	rcu_print_task_stall(rnp);
+	ndetected = rcu_print_task_stall(rnp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
@@ -565,17 +572,22 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       rsp->name);
 	rcu_for_each_leaf_node(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		rcu_print_task_stall(rnp);
+		ndetected += rcu_print_task_stall(rnp);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		if (rnp->qsmask == 0)
 			continue;
 		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
-			if (rnp->qsmask & (1UL << cpu))
+			if (rnp->qsmask & (1UL << cpu)) {
 				printk(" %d", rnp->grplo + cpu);
+				ndetected++;
+			}
 	}
 	printk("} (detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
-	trigger_all_cpu_backtrace();
+	if (ndetected == 0)
+		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
+	else if (!trigger_all_cpu_backtrace())
+		dump_stack();
 
 	/* If so configured, complain about tasks blocking the grace period. */
 
@@ -596,7 +608,8 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	 */
 	printk(KERN_ERR "INFO: %s detected stall on CPU %d (t=%lu jiffies)\n",
 	       rsp->name, smp_processor_id(), jiffies - rsp->gp_start);
-	trigger_all_cpu_backtrace();
+	if (!trigger_all_cpu_backtrace())
+		dump_stack();
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
@@ -678,9 +691,10 @@ static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct
 		 * go looking for one.
 		 */
 		rdp->gpnum = rnp->gpnum;
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpustart");
 		if (rnp->qsmask & rdp->grpmask) {
 			rdp->qs_pending = 1;
-			rdp->passed_quiesc = 0;
+			rdp->passed_quiesce = 0;
 		} else
 			rdp->qs_pending = 0;
 	}
@@ -741,6 +755,7 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuend");
 
 		/*
 		 * If we were in an extended quiescent state, we may have
@@ -826,31 +841,31 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
-		if (cpu_needs_another_gp(rsp, rdp))
-			rsp->fqs_need_gp = 1;
-		if (rnp->completed == rsp->completed) {
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			return;
-		}
-		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
+	if (!rcu_scheduler_fully_active ||
+	    !cpu_needs_another_gp(rsp, rdp)) {
+		/*
+		 * Either the scheduler hasn't yet spawned the first
+		 * non-idle task or this CPU does not need another
+		 * grace period.  Either way, don't start a new grace
+		 * period.
+		 */
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
 
+	if (rsp->fqs_active) {
 		/*
-		 * Propagate new ->completed value to rcu_node structures
-		 * so that other CPUs don't have to wait until the start
-		 * of the next grace period to process their callbacks.
+		 * This CPU needs a grace period, but force_quiescent_state()
+		 * is running.  Tell it to start one on this CPU's behalf.
 		 */
-		rcu_for_each_node_breadth_first(rsp, rnp) {
-			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
-			rnp->completed = rsp->completed;
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
-		}
-		local_irq_restore(flags);
+		rsp->fqs_need_gp = 1;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 
 	/* Advance to a new grace period and initialize state. */
 	rsp->gpnum++;
+	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
 	WARN_ON_ONCE(rsp->signaled == RCU_GP_INIT);
 	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
@@ -865,6 +880,9 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
+		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
+					    rnp->level, rnp->grplo,
+					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -901,6 +919,9 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
+		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
+					    rnp->level, rnp->grplo,
+					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
@@ -922,6 +943,8 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
 	unsigned long gp_duration;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 
@@ -933,7 +956,41 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	gp_duration = jiffies - rsp->gp_start;
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
-	rsp->completed = rsp->gpnum;
+
+	/*
+	 * We know the grace period is complete, but to everyone else
+	 * it appears to still be ongoing.  But it is also the case
+	 * that to everyone else it looks like there is nothing that
+	 * they can do to advance the grace period.  It is therefore
+	 * safe for us to drop the lock in order to mark the grace
+	 * period as completed in all of the rcu_node structures.
+	 *
+	 * But if this CPU needs another grace period, it will take
+	 * care of this while initializing the next grace period.
+	 * We use RCU_WAIT_TAIL instead of the usual RCU_DONE_TAIL
+	 * because the callbacks have not yet been advanced: Those
+	 * callbacks are waiting on the grace period that just now
+	 * completed.
+	 */
+	if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
+		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
+
+		/*
+		 * Propagate new ->completed value to rcu_node structures
+		 * so that other CPUs don't have to wait until the start
+		 * of the next grace period to process their callbacks.
+		 */
+		rcu_for_each_node_breadth_first(rsp, rnp) {
+			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+			rnp->completed = rsp->gpnum;
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		}
+		rnp = rcu_get_root(rsp);
+		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+	}
+
+	rsp->completed = rsp->gpnum;  /* Declare the grace period complete. */
+	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
 	rsp->signaled = RCU_GP_IDLE;
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
 }
@@ -962,6 +1019,10 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
 			return;
 		}
 		rnp->qsmask &= ~mask;
+		trace_rcu_quiescent_state_report(rsp->name, rnp->gpnum,
+						 mask, rnp->qsmask, rnp->level,
+						 rnp->grplo, rnp->grphi,
+						 !!rnp->gp_tasks);
 		if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {
 
 			/* Other bits still set at this level, so done. */
@@ -1000,7 +1061,7 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
  * based on quiescent states detected in an earlier grace period!
  */
 static void
-rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
+rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastgp)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -1008,17 +1069,15 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long las
 
 	rnp = rdp->mynode;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	if (lastcomp != rnp->completed) {
+	if (lastgp != rnp->gpnum || rnp->completed == rnp->gpnum) {
 
 		/*
-		 * Someone beat us to it for this grace period, so leave.
-		 * The race with GP start is resolved by the fact that we
-		 * hold the leaf rcu_node lock, so that the per-CPU bits
-		 * cannot yet be initialized -- so we would simply find our
-		 * CPU's bit already cleared in rcu_report_qs_rnp() if this
-		 * race occurred.
+		 * The grace period in which this quiescent state was
+		 * recorded has ended, so don't report it upwards.
+		 * We will instead need a new quiescent state that lies
+		 * within the current grace period.
 		 */
-		rdp->passed_quiesc = 0;	/* try again later! */
+		rdp->passed_quiesce = 0;	/* need qs for new gp. */
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -1062,14 +1121,14 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 	 * Was there a quiescent state since the beginning of the grace
 	 * period? If no, then exit and wait for the next call.
 	 */
-	if (!rdp->passed_quiesc)
+	if (!rdp->passed_quiesce)
 		return;
 
 	/*
 	 * Tell RCU we are done (but rcu_report_qs_rdp() will be the
 	 * judge of that).
 	 */
-	rcu_report_qs_rdp(rdp->cpu, rsp, rdp, rdp->passed_quiesc_completed);
+	rcu_report_qs_rdp(rdp->cpu, rsp, rdp, rdp->passed_quiesce_gpnum);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1130,11 +1189,20 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		if (rnp->qsmaskinit != 0) {
 			if (rnp != rdp->mynode)
 				raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			else
+				trace_rcu_grace_period(rsp->name,
+						       rnp->gpnum + 1 -
+						       !!(rnp->qsmask & mask),
+						       "cpuofl");
 			break;
 		}
-		if (rnp == rdp->mynode)
+		if (rnp == rdp->mynode) {
+			trace_rcu_grace_period(rsp->name,
+					       rnp->gpnum + 1 -
+					       !!(rnp->qsmask & mask),
+					       "cpuofl");
 			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
-		else
+		} else
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		mask = rnp->grpmask;
 		rnp = rnp->parent;
@@ -1190,17 +1258,22 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int count;
+	int bl, count;
 
 	/* If no callbacks are ready, just return.*/
-	if (!cpu_has_callbacks_ready_to_invoke(rdp))
+	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
+		trace_rcu_batch_start(rsp->name, 0, 0);
+		trace_rcu_batch_end(rsp->name, 0);
 		return;
+	}
 
 	/*
 	 * Extract the list of ready callbacks, disabling to prevent
 	 * races with call_rcu() from interrupt handlers.
 	 */
 	local_irq_save(flags);
+	bl = rdp->blimit;
+	trace_rcu_batch_start(rsp->name, rdp->qlen, bl);
 	list = rdp->nxtlist;
 	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
 	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
@@ -1216,13 +1289,14 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
-		__rcu_reclaim(list);
+		__rcu_reclaim(rsp->name, list);
 		list = next;
-		if (++count >= rdp->blimit)
+		if (++count >= bl)
 			break;
 	}
 
 	local_irq_save(flags);
+	trace_rcu_batch_end(rsp->name, count);
 
 	/* Update count, and requeue any remaining callbacks. */
 	rdp->qlen -= count;
@@ -1250,7 +1324,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	local_irq_restore(flags);
 
-	/* Re-raise the RCU softirq if there are callbacks remaining. */
+	/* Re-invoke RCU core processing if there are callbacks remaining. */
 	if (cpu_has_callbacks_ready_to_invoke(rdp))
 		invoke_rcu_core();
 }
@@ -1258,7 +1332,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 /*
  * Check to see if this CPU is in a non-context-switch quiescent state
  * (user mode or idle loop for rcu, non-softirq execution for rcu_bh).
- * Also schedule the RCU softirq handler.
+ * Also schedule RCU core processing.
  *
  * This function must be called with hardirqs disabled.  It is normally
  * invoked from the scheduling-clock interrupt.  If rcu_pending returns
@@ -1266,6 +1340,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
+	trace_rcu_utilization("Start scheduler-tick");
 	if (user ||
 	    (idle_cpu(cpu) && rcu_scheduler_active &&
 	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
@@ -1299,6 +1374,7 @@ void rcu_check_callbacks(int cpu, int user)
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
 		invoke_rcu_core();
+	trace_rcu_utilization("End scheduler-tick");
 }
 
 #ifdef CONFIG_SMP
@@ -1360,10 +1436,14 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	if (!rcu_gp_in_progress(rsp))
+	trace_rcu_utilization("Start fqs");
+	if (!rcu_gp_in_progress(rsp)) {
+		trace_rcu_utilization("End fqs");
 		return;  /* No grace period in progress, nothing to force. */
+	}
 	if (!raw_spin_trylock_irqsave(&rsp->fqslock, flags)) {
 		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
+		trace_rcu_utilization("End fqs");
 		return;	/* Someone else is already on the job. */
 	}
 	if (relaxed && ULONG_CMP_GE(rsp->jiffies_force_qs, jiffies))
@@ -1412,11 +1492,13 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		raw_spin_unlock(&rsp->fqslock); /* irqs remain disabled */
 		rsp->fqs_need_gp = 0;
 		rcu_start_gp(rsp, flags); /* releases rnp->lock */
+		trace_rcu_utilization("End fqs");
 		return;
 	}
 	raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 unlock_fqs_ret:
 	raw_spin_unlock_irqrestore(&rsp->fqslock, flags);
+	trace_rcu_utilization("End fqs");
 }
 
 #else /* #ifdef CONFIG_SMP */
@@ -1429,9 +1511,9 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 #endif /* #else #ifdef CONFIG_SMP */
 
 /*
- * This does the RCU processing work from softirq context for the
- * specified rcu_state and rcu_data structures.  This may be called
- * only from the CPU to whom the rdp belongs.
+ * This does the RCU core processing work for the specified rcu_state
+ * and rcu_data structures.  This may be called only from the CPU to
+ * whom the rdp belongs.
  */
 static void
 __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
@@ -1468,24 +1550,24 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
- * Do softirq processing for the current CPU.
+ * Do RCU core processing for the current CPU.
  */
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
+	trace_rcu_utilization("Start RCU core");
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
 	rcu_preempt_process_callbacks();
-
-	/* If we are last CPU on way to dyntick-idle mode, accelerate it. */
-	rcu_needs_cpu_flush();
+	trace_rcu_utilization("End RCU core");
 }
 
 /*
- * Wake up the current CPU's kthread.  This replaces raise_softirq()
- * in earlier versions of RCU.  Note that because we are running on
- * the current CPU with interrupts disabled, the rcu_cpu_kthread_task
- * cannot disappear out from under us.
+ * Schedule RCU callback invocation.  If the specified type of RCU
+ * does not support RCU priority boosting, just do a direct call,
+ * otherwise wake up the per-CPU kernel kthread.  Note that because we
+ * are running on the current CPU with interrupts disabled, the
+ * rcu_cpu_kthread_task cannot disappear out from under us.
  */
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
@@ -1530,6 +1612,12 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 	rdp->qlen++;
 
+	if (__is_kfree_rcu_offset((unsigned long)func))
+		trace_rcu_kfree_callback(rsp->name, head, (unsigned long)func,
+					 rdp->qlen);
+	else
+		trace_rcu_callback(rsp->name, head, rdp->qlen);
+
 	/* If interrupts were disabled, don't dive into RCU core. */
 	if (irqs_disabled_flags(flags)) {
 		local_irq_restore(flags);
@@ -1613,18 +1701,9 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
  */
 void synchronize_sched(void)
 {
-	struct rcu_synchronize rcu;
-
 	if (rcu_blocking_is_gp())
 		return;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_sched(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
+	wait_rcu_gp(call_rcu_sched);
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
@@ -1639,18 +1718,9 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
  */
 void synchronize_rcu_bh(void)
 {
-	struct rcu_synchronize rcu;
-
 	if (rcu_blocking_is_gp())
 		return;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_bh(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
+	wait_rcu_gp(call_rcu_bh);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
@@ -1671,7 +1741,8 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	check_cpu_stall(rsp, rdp);
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
-	if (rdp->qs_pending && !rdp->passed_quiesc) {
+	if (rcu_scheduler_fully_active &&
+	    rdp->qs_pending && !rdp->passed_quiesce) {
 
 		/*
 		 * If force_quiescent_state() coming soon and this CPU
@@ -1683,7 +1754,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
 				 jiffies))
 			set_need_resched();
-	} else if (rdp->qs_pending && rdp->passed_quiesc) {
+	} else if (rdp->qs_pending && rdp->passed_quiesce) {
 		rdp->n_rp_report_qs++;
 		return 1;
 	}
@@ -1846,6 +1917,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 #endif /* #ifdef CONFIG_NO_HZ */
 	rdp->cpu = cpu;
+	rdp->rsp = rsp;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
@@ -1865,8 +1937,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
-	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->preemptible = preemptible;
 	rdp->qlen_last_fqs_check = 0;
@@ -1891,9 +1961,17 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 		rnp->qsmaskinit |= mask;
 		mask = rnp->grpmask;
 		if (rnp == rdp->mynode) {
-			rdp->gpnum = rnp->completed; /* if GP in progress... */
+			/*
+			 * If there is a grace period in progress, we will
+			 * set up to wait for it next time we run the
+			 * RCU core code.
+			 */
+			rdp->gpnum = rnp->completed;
 			rdp->completed = rnp->completed;
-			rdp->passed_quiesc_completed = rnp->completed - 1;
+			rdp->passed_quiesce = 0;
+			rdp->qs_pending = 0;
+			rdp->passed_quiesce_gpnum = rnp->gpnum - 1;
+			trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuonl");
 		}
 		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
 		rnp = rnp->parent;
@@ -1919,6 +1997,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 
+	trace_rcu_utilization("Start CPU hotplug");
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
@@ -1954,6 +2033,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	default:
 		break;
 	}
+	trace_rcu_utilization("End CPU hotplug");
 	return NOTIFY_OK;
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 01b2ccd..849ce9e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -230,9 +230,9 @@ struct rcu_data {
 					/*  in order to detect GP end. */
 	unsigned long	gpnum;		/* Highest gp number that this CPU */
 					/*  is aware of having started. */
-	unsigned long	passed_quiesc_completed;
-					/* Value of completed at time of qs. */
-	bool		passed_quiesc;	/* User-mode/idle loop etc. */
+	unsigned long	passed_quiesce_gpnum;
+					/* gpnum at time of quiescent state. */
+	bool		passed_quiesce;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
 	bool		preemptible;	/* Preemptible RCU? */
@@ -299,6 +299,7 @@ struct rcu_data {
 	unsigned long n_rp_need_nothing;
 
 	int cpu;
+	struct rcu_state *rsp;
 };
 
 /* Values for signaled field in struct rcu_state. */
@@ -417,6 +418,13 @@ extern struct rcu_state rcu_preempt_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+#ifdef CONFIG_RCU_BOOST
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+DECLARE_PER_CPU(int, rcu_cpu_kthread_cpu);
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
+DECLARE_PER_CPU(char, rcu_cpu_has_work);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 #ifndef RCU_TREE_NONCORE
 
 /* Forward declarations for rcutree_plugin.h */
@@ -430,7 +438,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 static void rcu_stop_cpu_kthread(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
-static void rcu_print_task_stall(struct rcu_node *rnp);
+static int rcu_print_task_stall(struct rcu_node *rnp);
 static void rcu_preempt_stall_reset(void);
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
@@ -450,7 +458,6 @@ static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
-static void rcu_needs_cpu_flush(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
 static void invoke_rcu_callbacks_kthread(void);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 8aafbb8..4b9b9f8 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -27,6 +27,14 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 
+#define RCU_KTHREAD_PRIO 1
+
+#ifdef CONFIG_RCU_BOOST
+#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
+#else
+#define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
+#endif
+
 /*
  * Check the RCU kernel configuration parameters and print informative
  * messages about anything out of the ordinary.  If you like #ifdef, you
@@ -64,7 +72,7 @@ static void __init rcu_bootup_announce_oddness(void)
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
-struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
+struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
@@ -122,9 +130,11 @@ static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
 
-	rdp->passed_quiesc_completed = rdp->gpnum - 1;
+	rdp->passed_quiesce_gpnum = rdp->gpnum;
 	barrier();
-	rdp->passed_quiesc = 1;
+	if (rdp->passed_quiesce == 0)
+		trace_rcu_grace_period("rcu_preempt", rdp->gpnum, "cpuqs");
+	rdp->passed_quiesce = 1;
 	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 }
 
@@ -190,6 +200,11 @@ static void rcu_preempt_note_context_switch(int cpu)
 			if (rnp->qsmask & rdp->grpmask)
 				rnp->gp_tasks = &t->rcu_node_entry;
 		}
+		trace_rcu_preempt_task(rdp->rsp->name,
+				       t->pid,
+				       (rnp->qsmask & rdp->grpmask)
+				       ? rnp->gpnum
+				       : rnp->gpnum + 1);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else if (t->rcu_read_lock_nesting < 0 &&
 		   t->rcu_read_unlock_special) {
@@ -299,6 +314,9 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 	int empty_exp;
 	unsigned long flags;
 	struct list_head *np;
+#ifdef CONFIG_RCU_BOOST
+	struct rt_mutex *rbmp = NULL;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	struct rcu_node *rnp;
 	int special;
 
@@ -344,6 +362,9 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
 		np = rcu_next_node_entry(t, rnp);
 		list_del_init(&t->rcu_node_entry);
+		t->rcu_blocked_node = NULL;
+		trace_rcu_unlock_preempted_task("rcu_preempt",
+						rnp->gpnum, t->pid);
 		if (&t->rcu_node_entry == rnp->gp_tasks)
 			rnp->gp_tasks = np;
 		if (&t->rcu_node_entry == rnp->exp_tasks)
@@ -351,30 +372,34 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		if (&t->rcu_node_entry == rnp->boost_tasks)
 			rnp->boost_tasks = np;
-		/* Snapshot and clear ->rcu_boosted with rcu_node lock held. */
-		if (t->rcu_boosted) {
-			special |= RCU_READ_UNLOCK_BOOSTED;
-			t->rcu_boosted = 0;
+		/* Snapshot/clear ->rcu_boost_mutex with rcu_node lock held. */
+		if (t->rcu_boost_mutex) {
+			rbmp = t->rcu_boost_mutex;
+			t->rcu_boost_mutex = NULL;
 		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
-		t->rcu_blocked_node = NULL;
 
 		/*
 		 * If this was the last task on the current list, and if
 		 * we aren't waiting on any CPUs, report the quiescent state.
 		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock.
 		 */
-		if (empty)
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		else
+		if (!empty && !rcu_preempt_blocked_readers_cgp(rnp)) {
+			trace_rcu_quiescent_state_report("preempt_rcu",
+							 rnp->gpnum,
+							 0, rnp->qsmask,
+							 rnp->level,
+							 rnp->grplo,
+							 rnp->grphi,
+							 !!rnp->gp_tasks);
 			rcu_report_unblock_qs_rnp(rnp, flags);
+		} else
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (special & RCU_READ_UNLOCK_BOOSTED) {
-			rt_mutex_unlock(t->rcu_boost_mutex);
-			t->rcu_boost_mutex = NULL;
-		}
+		if (rbmp)
+			rt_mutex_unlock(rbmp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -399,10 +424,10 @@ void __rcu_read_unlock(void)
 {
 	struct task_struct *t = current;
 
-	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
 	if (t->rcu_read_lock_nesting != 1)
 		--t->rcu_read_lock_nesting;
 	else {
+		barrier();  /* critical section before exit code. */
 		t->rcu_read_lock_nesting = INT_MIN;
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
@@ -466,16 +491,20 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
  * Scan the current list of tasks blocked within RCU read-side critical
  * sections, printing out the tid of each.
  */
-static void rcu_print_task_stall(struct rcu_node *rnp)
+static int rcu_print_task_stall(struct rcu_node *rnp)
 {
 	struct task_struct *t;
+	int ndetected = 0;
 
 	if (!rcu_preempt_blocked_readers_cgp(rnp))
-		return;
+		return 0;
 	t = list_entry(rnp->gp_tasks,
 		       struct task_struct, rcu_node_entry);
-	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
+	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry) {
 		printk(" P%d", t->pid);
+		ndetected++;
+	}
+	return ndetected;
 }
 
 /*
@@ -656,18 +685,9 @@ EXPORT_SYMBOL_GPL(call_rcu);
  */
 void synchronize_rcu(void)
 {
-	struct rcu_synchronize rcu;
-
 	if (!rcu_scheduler_active)
 		return;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
+	wait_rcu_gp(call_rcu);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
@@ -968,8 +988,9 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
  * Because preemptible RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
  */
-static void rcu_print_task_stall(struct rcu_node *rnp)
+static int rcu_print_task_stall(struct rcu_node *rnp)
 {
+	return 0;
 }
 
 /*
@@ -1136,6 +1157,8 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
+static struct lock_class_key rcu_boost_class;
+
 /*
  * Carry out RCU priority boosting on the task indicated by ->exp_tasks
  * or ->boost_tasks, advancing the pointer to the next task in the
@@ -1198,8 +1221,10 @@ static int rcu_boost(struct rcu_node *rnp)
 	 */
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
+	/* Avoid lockdep false positives.  This rt_mutex is its own thing. */
+	lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
+				   "rcu_boost_mutex");
 	t->rcu_boost_mutex = &mtx;
-	t->rcu_boosted = 1;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
@@ -1228,9 +1253,12 @@ static int rcu_boost_kthread(void *arg)
 	int spincnt = 0;
 	int more2boost;
 
+	trace_rcu_utilization("Start boost kthread@init");
 	for (;;) {
 		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
+		trace_rcu_utilization("End boost kthread@rcu_wait");
 		rcu_wait(rnp->boost_tasks || rnp->exp_tasks);
+		trace_rcu_utilization("Start boost kthread@rcu_wait");
 		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
 		more2boost = rcu_boost(rnp);
 		if (more2boost)
@@ -1238,11 +1266,14 @@ static int rcu_boost_kthread(void *arg)
 		else
 			spincnt = 0;
 		if (spincnt > 10) {
+			trace_rcu_utilization("End boost kthread@rcu_yield");
 			rcu_yield(rcu_boost_kthread_timer, (unsigned long)rnp);
+			trace_rcu_utilization("Start boost kthread@rcu_yield");
 			spincnt = 0;
 		}
 	}
 	/* NOTREACHED */
+	trace_rcu_utilization("End boost kthread@notreached");
 	return 0;
 }
 
@@ -1291,11 +1322,9 @@ static void invoke_rcu_callbacks_kthread(void)
 
 	local_irq_save(flags);
 	__this_cpu_write(rcu_cpu_has_work, 1);
-	if (__this_cpu_read(rcu_cpu_kthread_task) == NULL) {
-		local_irq_restore(flags);
-		return;
-	}
-	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
+	if (__this_cpu_read(rcu_cpu_kthread_task) != NULL &&
+	    current != __this_cpu_read(rcu_cpu_kthread_task))
+		wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
 	local_irq_restore(flags);
 }
 
@@ -1343,13 +1372,13 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (rnp->boost_kthread_task != NULL)
 		return 0;
 	t = kthread_create(rcu_boost_kthread, (void *)rnp,
-			   "rcub%d", rnp_index);
+			   "rcub/%d", rnp_index);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sp.sched_priority = RCU_BOOST_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
 	return 0;
@@ -1444,6 +1473,7 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
 {
 	struct sched_param sp;
 	struct timer_list yield_timer;
+	int prio = current->rt_priority;
 
 	setup_timer_on_stack(&yield_timer, f, arg);
 	mod_timer(&yield_timer, jiffies + 2);
@@ -1451,7 +1481,8 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
 	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
 	set_user_nice(current, 19);
 	schedule();
-	sp.sched_priority = RCU_KTHREAD_PRIO;
+	set_user_nice(current, 0);
+	sp.sched_priority = prio;
 	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
 	del_timer(&yield_timer);
 }
@@ -1489,7 +1520,8 @@ static int rcu_cpu_kthread_should_stop(int cpu)
 
 /*
  * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
- * earlier RCU softirq.
+ * RCU softirq used in flavors and configurations of RCU that do not
+ * support RCU priority boosting.
  */
 static int rcu_cpu_kthread(void *arg)
 {
@@ -1500,9 +1532,12 @@ static int rcu_cpu_kthread(void *arg)
 	char work;
 	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
 
+	trace_rcu_utilization("Start CPU kthread@init");
 	for (;;) {
 		*statusp = RCU_KTHREAD_WAITING;
+		trace_rcu_utilization("End CPU kthread@rcu_wait");
 		rcu_wait(*workp != 0 || kthread_should_stop());
+		trace_rcu_utilization("Start CPU kthread@rcu_wait");
 		local_bh_disable();
 		if (rcu_cpu_kthread_should_stop(cpu)) {
 			local_bh_enable();
@@ -1523,11 +1558,14 @@ static int rcu_cpu_kthread(void *arg)
 			spincnt = 0;
 		if (spincnt > 10) {
 			*statusp = RCU_KTHREAD_YIELDING;
+			trace_rcu_utilization("End CPU kthread@rcu_yield");
 			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
+			trace_rcu_utilization("Start CPU kthread@rcu_yield");
 			spincnt = 0;
 		}
 	}
 	*statusp = RCU_KTHREAD_STOPPED;
+	trace_rcu_utilization("End CPU kthread@term");
 	return 0;
 }
 
@@ -1560,7 +1598,10 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	if (!rcu_scheduler_fully_active ||
 	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
 		return 0;
-	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
+	t = kthread_create_on_node(rcu_cpu_kthread,
+				   (void *)(long)cpu,
+				   cpu_to_node(cpu),
+				   "rcuc/%d", cpu);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	if (cpu_online(cpu))
@@ -1669,7 +1710,7 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 		return 0;
 	if (rnp->node_kthread_task == NULL) {
 		t = kthread_create(rcu_node_kthread, (void *)rnp,
-				   "rcun%d", rnp_index);
+				   "rcun/%d", rnp_index);
 		if (IS_ERR(t))
 			return PTR_ERR(t);
 		raw_spin_lock_irqsave(&rnp->lock, flags);
@@ -1907,15 +1948,6 @@ int rcu_needs_cpu(int cpu)
 	return rcu_needs_cpu_quick_check(cpu);
 }
 
-/*
- * Check to see if we need to continue a callback-flush operations to
- * allow the last CPU to enter dyntick-idle mode.  But fast dyntick-idle
- * entry is not configured, so we never do need to.
- */
-static void rcu_needs_cpu_flush(void)
-{
-}
-
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 #define RCU_NEEDS_CPU_FLUSHES 5
@@ -1991,20 +2023,4 @@ int rcu_needs_cpu(int cpu)
 	return c;
 }
 
-/*
- * Check to see if we need to continue a callback-flush operations to
- * allow the last CPU to enter dyntick-idle mode.
- */
-static void rcu_needs_cpu_flush(void)
-{
-	int cpu = smp_processor_id();
-	unsigned long flags;
-
-	if (per_cpu(rcu_dyntick_drain, cpu) <= 0)
-		return;
-	local_irq_save(flags);
-	(void)rcu_needs_cpu(cpu);
-	local_irq_restore(flags);
-}
-
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 3b0c098..9feffa4 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -48,11 +48,6 @@
 
 #ifdef CONFIG_RCU_BOOST
 
-DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
-DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
-DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
-DECLARE_PER_CPU(char, rcu_cpu_has_work);
-
 static char convert_kthread_status(unsigned int kthread_status)
 {
 	if (kthread_status > RCU_KTHREAD_MAX)
@@ -66,11 +61,11 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d pqc=%lu qp=%d",
+	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d pgp=%lu qp=%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
 		   rdp->completed, rdp->gpnum,
-		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
+		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
 		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
 	seq_printf(m, " dt=%d/%d/%d df=%lu",
@@ -144,7 +139,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? "\"N\"" : "\"Y\"",
 		   rdp->completed, rdp->gpnum,
-		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
+		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
 		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
 	seq_printf(m, ",%d,%d,%d,%lu",
@@ -175,7 +170,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 
 static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
-	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pqc\",\"pq\",");
+	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
 #ifdef CONFIG_NO_HZ
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 255e166..5e8d9cc 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -579,6 +579,7 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		    struct rt_mutex_waiter *waiter)
 {
 	int ret = 0;
+	int was_disabled;
 
 	for (;;) {
 		/* Try to acquire the lock: */
@@ -601,10 +602,17 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 		raw_spin_unlock(&lock->wait_lock);
 
+		was_disabled = irqs_disabled();
+		if (was_disabled)
+			local_irq_enable();
+
 		debug_rt_mutex_print_deadlock(waiter);
 
 		schedule_rt_mutex(lock);
 
+		if (was_disabled)
+			local_irq_disable();
+
 		raw_spin_lock(&lock->wait_lock);
 		set_current_state(state);
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index ec5f472..3e55256 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4237,6 +4237,7 @@ static inline void schedule_debug(struct task_struct *prev)
 	 */
 	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
 		__schedule_bug(prev);
+	rcu_sleep_check();
 
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
@@ -5979,15 +5980,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 }
 
 /*
- * In a system that switches off the HZ timer nohz_cpu_mask
- * indicates which cpus entered this state. This is used
- * in the rcu update to wait only for active cpus. For system
- * which do not switch off the HZ timer nohz_cpu_mask should
- * always be CPU_BITS_NONE.
- */
-cpumask_var_t nohz_cpu_mask;
-
-/*
  * Increase the granularity value when there are more CPUs,
  * because with more CPUs the 'effective latency' as visible
  * to users decreases. But the relationship is not linear,
@@ -8199,8 +8191,6 @@ void __init sched_init(void)
 	 */
 	current->sched_class = &fair_sched_class;
 
-	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
-	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_NO_HZ
@@ -8230,6 +8220,7 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 {
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
+	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
 	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..eb98e55 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -139,7 +139,6 @@ static void tick_nohz_update_jiffies(ktime_t now)
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long flags;
 
-	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 	ts->idle_waketime = now;
 
 	local_irq_save(flags);
@@ -389,9 +388,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 		else
 			expires.tv64 = KTIME_MAX;
 
-		if (delta_jiffies > 1)
-			cpumask_set_cpu(cpu, nohz_cpu_mask);
-
 		/* Skip reprogram of event if its not changed */
 		if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
 			goto out;
@@ -441,7 +437,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * softirq.
 		 */
 		tick_do_update_jiffies64(ktime_get());
-		cpumask_clear_cpu(cpu, nohz_cpu_mask);
 	}
 	raise_softirq_irqoff(TIMER_SOFTIRQ);
 out:
@@ -524,7 +519,6 @@ void tick_nohz_restart_sched_tick(void)
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
-	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	/*
