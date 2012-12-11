Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2LKIEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:04:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49154 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2LKIEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:04:01 -0500
Date: Tue, 11 Dec 2012 09:03:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.8
Message-ID: <20121211080354.GA21330@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest RCU git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   HEAD: 630e1e0bcddfda9566462d4f9a0d58b31c29d467 Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

The major features of this tree are:
    
     1. A first version of no-callbacks CPUs.  This version prohibits
      	offlining CPU 0, but only when enabled via CONFIG_RCU_NOCB_CPU=y.
      	Relaxing this constraint is in progress, but not yet ready
      	for prime time.  These commits were posted to LKML at
      	https://lkml.org/lkml/2012/10/30/724.
    
     2. Changes to SRCU that allows statically initialized srcu_struct
      	structures.  These commits were posted to LKML at
      	https://lkml.org/lkml/2012/10/30/296.
    
     3. Restructuring of RCU's debugfs output.  These commits were posted
      	to LKML at https://lkml.org/lkml/2012/10/30/341.
    
     4. Additional CPU-hotplug/RCU improvements, posted to LKML at
      	https://lkml.org/lkml/2012/10/30/327.
      	Note that the commit eliminating __stop_machine() was judged to
      	be too-high of risk, so is deferred to 3.9.
    
     5. Changes to RCU's idle interface, most notably a new module
      	parameter that redirects normal grace-period operations to
      	their expedited equivalents.  These were posted to LKML at
      	https://lkml.org/lkml/2012/10/30/739.
    
     6. Additional diagnostics for RCU's CPU stall warning facility,
      	posted to LKML at https://lkml.org/lkml/2012/10/30/315.
        The most notable change reduces the
      	default RCU CPU stall-warning time from 60 seconds to 21 seconds,
      	so that it once again happens sooner than the softlockup timeout.
    
     7. Documentation updates, which were posted to LKML at
      	https://lkml.org/lkml/2012/10/30/280.
      	A couple of late-breaking changes were posted at
      	https://lkml.org/lkml/2012/11/16/634 and
      	https://lkml.org/lkml/2012/11/16/547.
    
     8. Miscellaneous fixes, which were posted to LKML at
      	https://lkml.org/lkml/2012/10/30/309.
    
     9. Finally, a fix for an lockdep-RCU splat was posted to LKML
      	at https://lkml.org/lkml/2012/11/7/486.

 Thanks,

	Ingo

------------------>
Antti P Miettinen (1):
      rcu: Add a module parameter to force use of expedited RCU primitives

Dhaval Giani (1):
      rcu: Correct the name of a reference in list of RCU papers

Eric Dumazet (1):
      rcu: Fix batch-limit size problem

Frederic Weisbecker (2):
      rcu: Remove rcu_switch()
      context_tracking: New context tracking susbsystem

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

Paul E. McKenney (26):
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
      rcu: Add callback-free CPUs
      rcu: Separate accounting of callbacks from callback-free CPUs
      sched: Mark RCU reader in sched_show_task()

Paul Gortmaker (1):
      rcu: Wordsmith help text for RCU_USER_QS kernel parameter


 Documentation/RCU/RTFP.txt                         |   2 +-
 Documentation/RCU/checklist.txt                    |  17 +-
 Documentation/RCU/listRCU.txt                      |   2 +-
 Documentation/RCU/rcuref.txt                       |  61 ++-
 Documentation/RCU/trace.txt                        | 396 +++++++++++---------
 Documentation/RCU/whatisRCU.txt                    |  17 +-
 Documentation/kernel-parameters.txt                |  21 ++
 Documentation/memory-barriers.txt                  |   9 +-
 arch/Kconfig                                       |  15 +-
 arch/um/drivers/mconsole_kern.c                    |   2 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/include/asm/{rcu.h => context_tracking.h} |  15 +-
 arch/x86/kernel/entry_64.S                         |   2 +-
 arch/x86/kernel/ptrace.c                           |   7 +-
 arch/x86/kernel/signal.c                           |   5 +-
 arch/x86/kernel/traps.c                            |   2 +-
 arch/x86/mm/fault.c                                |   2 +-
 include/linux/context_tracking.h                   |  18 +
 include/linux/rculist.h                            |  17 -
 include/linux/rcupdate.h                           |  29 +-
 include/linux/sched.h                              |  10 +-
 include/linux/srcu.h                               |  34 ++
 include/trace/events/rcu.h                         |   1 +
 init/Kconfig                                       |  67 ++--
 kernel/Makefile                                    |   1 +
 kernel/context_tracking.c                          |  83 +++++
 kernel/ksysfs.c                                    |  18 +
 kernel/rcu.h                                       |   2 +
 kernel/rcupdate.c                                  |   3 +
 kernel/rcutiny.c                                   |   2 +-
 kernel/rcutiny_plugin.h                            |   5 +-
 kernel/rcutorture.c                                |  54 +--
 kernel/rcutree.c                                   | 347 ++++++++++-------
 kernel/rcutree.h                                   |  67 +++-
 kernel/rcutree_plugin.h                            | 415 ++++++++++++++++++++-
 kernel/rcutree_trace.c                             | 330 ++++++++--------
 kernel/sched/core.c                                |  23 +-
 kernel/srcu.c                                      |  16 +-
 lib/Kconfig.debug                                  |   2 +-
 39 files changed, 1493 insertions(+), 628 deletions(-)
 rename arch/x86/include/asm/{rcu.h => context_tracking.h} (63%)
 create mode 100644 include/linux/context_tracking.h
 create mode 100644 kernel/context_tracking.c

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 7c1dfb1..7f40c72 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -186,7 +186,7 @@ Bibtex Entries
 
 @article{Kung80
 ,author="H. T. Kung and Q. Lehman"
-,title="Concurrent Maintenance of Binary Search Trees"
+,title="Concurrent Manipulation of Binary Search Trees"
 ,Year="1980"
 ,Month="September"
 ,journal="ACM Transactions on Database Systems"
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index cdb20d4..31ef8fe 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -271,15 +271,14 @@ over a rather long period of time, but improvements are always welcome!
 	The same cautions apply to call_rcu_bh() and call_rcu_sched().
 
 9.	All RCU list-traversal primitives, which include
-	rcu_dereference(), list_for_each_entry_rcu(),
-	list_for_each_continue_rcu(), and list_for_each_safe_rcu(),
-	must be either within an RCU read-side critical section or
-	must be protected by appropriate update-side locks.  RCU
-	read-side critical sections are delimited by rcu_read_lock()
-	and rcu_read_unlock(), or by similar primitives such as
-	rcu_read_lock_bh() and rcu_read_unlock_bh(), in which case
-	the matching rcu_dereference() primitive must be used in order
-	to keep lockdep happy, in this case, rcu_dereference_bh().
+	rcu_dereference(), list_for_each_entry_rcu(), and
+	list_for_each_safe_rcu(), must be either within an RCU read-side
+	critical section or must be protected by appropriate update-side
+	locks.	RCU read-side critical sections are delimited by
+	rcu_read_lock() and rcu_read_unlock(), or by similar primitives
+	such as rcu_read_lock_bh() and rcu_read_unlock_bh(), in which
+	case the matching rcu_dereference() primitive must be used in
+	order to keep lockdep happy, in this case, rcu_dereference_bh().
 
 	The reason that it is permissible to use RCU list-traversal
 	primitives when the update-side lock is held is that doing so
diff --git a/Documentation/RCU/listRCU.txt b/Documentation/RCU/listRCU.txt
index 4349c14..adb5a37 100644
--- a/Documentation/RCU/listRCU.txt
+++ b/Documentation/RCU/listRCU.txt
@@ -205,7 +205,7 @@ RCU ("read-copy update") its name.  The RCU code is as follows:
 				audit_copy_rule(&ne->rule, &e->rule);
 				ne->rule.action = newaction;
 				ne->rule.file_count = newfield_count;
-				list_replace_rcu(e, ne);
+				list_replace_rcu(&e->list, &ne->list);
 				call_rcu(&e->rcu, audit_free_rule);
 				return 0;
 			}
diff --git a/Documentation/RCU/rcuref.txt b/Documentation/RCU/rcuref.txt
index 4202ad0..141d531 100644
--- a/Documentation/RCU/rcuref.txt
+++ b/Documentation/RCU/rcuref.txt
@@ -20,7 +20,7 @@ release_referenced()			delete()
 {					{
     ...					    write_lock(&list_lock);
     atomic_dec(&el->rc, relfunc)	    ...
-    ...					    delete_element
+    ...					    remove_element
 }					    write_unlock(&list_lock);
  					    ...
 					    if (atomic_dec_and_test(&el->rc))
@@ -52,7 +52,7 @@ release_referenced()			delete()
 {					{
     ...					    spin_lock(&list_lock);
     if (atomic_dec_and_test(&el->rc))       ...
-        call_rcu(&el->head, el_free);       delete_element
+        call_rcu(&el->head, el_free);       remove_element
     ...                                     spin_unlock(&list_lock);
 } 					    ...
 					    if (atomic_dec_and_test(&el->rc))
@@ -64,3 +64,60 @@ Sometimes, a reference to the element needs to be obtained in the
 update (write) stream.  In such cases, atomic_inc_not_zero() might be
 overkill, since we hold the update-side spinlock.  One might instead
 use atomic_inc() in such cases.
+
+It is not always convenient to deal with "FAIL" in the
+search_and_reference() code path.  In such cases, the
+atomic_dec_and_test() may be moved from delete() to el_free()
+as follows:
+
+1.					2.
+add()					search_and_reference()
+{					{
+    alloc_object			    rcu_read_lock();
+    ...					    search_for_element
+    atomic_set(&el->rc, 1);		    atomic_inc(&el->rc);
+    spin_lock(&list_lock);		    ...
+
+    add_element				    rcu_read_unlock();
+    ...					}
+    spin_unlock(&list_lock);		4.
+}					delete()
+3.					{
+release_referenced()			    spin_lock(&list_lock);
+{					    ...
+    ...					    remove_element
+    if (atomic_dec_and_test(&el->rc))       spin_unlock(&list_lock);
+        kfree(el);			    ...
+    ...                                     call_rcu(&el->head, el_free);
+} 					    ...
+5.					}
+void el_free(struct rcu_head *rhp)
+{
+    release_referenced();
+}
+
+The key point is that the initial reference added by add() is not removed
+until after a grace period has elapsed following removal.  This means that
+search_and_reference() cannot find this element, which means that the value
+of el->rc cannot increase.  Thus, once it reaches zero, there are no
+readers that can or ever will be able to reference the element.  The
+element can therefore safely be freed.  This in turn guarantees that if
+any reader finds the element, that reader may safely acquire a reference
+without checking the value of the reference counter.
+
+In cases where delete() can sleep, synchronize_rcu() can be called from
+delete(), so that el_free() can be subsumed into delete as follows:
+
+4.
+delete()
+{
+    spin_lock(&list_lock);
+    ...
+    remove_element
+    spin_unlock(&list_lock);
+    ...
+    synchronize_rcu();
+    if (atomic_dec_and_test(&el->rc))
+    	kfree(el);
+    ...
+}
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 672d190..c776968 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -10,51 +10,63 @@ for rcutree and next for rcutiny.
 
 CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
 
-These implementations of RCU provides several debugfs files under the
+These implementations of RCU provide several debugfs directories under the
 top-level directory "rcu":
 
-rcu/rcudata:
+rcu/rcu_bh
+rcu/rcu_preempt
+rcu/rcu_sched
+
+Each directory contains files for the corresponding flavor of RCU.
+Note that rcu/rcu_preempt is only present for CONFIG_TREE_PREEMPT_RCU.
+For CONFIG_TREE_RCU, the RCU flavor maps onto the RCU-sched flavor,
+so that activity for both appears in rcu/rcu_sched.
+
+In addition, the following file appears in the top-level directory:
+rcu/rcutorture.  This file displays rcutorture test progress.  The output
+of "cat rcu/rcutorture" looks as follows:
+
+rcutorture test sequence: 0 (test in progress)
+rcutorture update version number: 615
+
+The first line shows the number of rcutorture tests that have completed
+since boot.  If a test is currently running, the "(test in progress)"
+string will appear as shown above.  The second line shows the number of
+update cycles that the current test has started, or zero if there is
+no test in progress.
+
+
+Within each flavor directory (rcu/rcu_bh, rcu/rcu_sched, and possibly
+also rcu/rcu_preempt) the following files will be present:
+
+rcudata:
 	Displays fields in struct rcu_data.
-rcu/rcudata.csv:
-	Comma-separated values spreadsheet version of rcudata.
-rcu/rcugp:
+rcuexp:
+	Displays statistics for expedited grace periods.
+rcugp:
 	Displays grace-period counters.
-rcu/rcuhier:
+rcuhier:
 	Displays the struct rcu_node hierarchy.
-rcu/rcu_pending:
+rcu_pending:
 	Displays counts of the reasons rcu_pending() decided that RCU had
 	work to do.
-rcu/rcutorture:
-	Displays rcutorture test progress.
-rcu/rcuboost:
+rcuboost:
 	Displays RCU boosting statistics.  Only present if
 	CONFIG_RCU_BOOST=y.
 
-The output of "cat rcu/rcudata" looks as follows:
-
-rcu_sched:
-  0 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=545/1/0 df=50 of=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
-  1 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=967/1/0 df=58 of=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
-  2 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1081/1/0 df=175 of=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
-  3 c=20942 g=20943 pq=1 pgp=20942 qp=1 dt=1846/0/0 df=404 of=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
-  4 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=369/1/0 df=83 of=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
-  5 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=381/1/0 df=64 of=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
-  6 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1037/1/0 df=183 of=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
-  7 c=20897 g=20897 pq=1 pgp=20896 qp=0 dt=1572/0/0 df=382 of=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
-rcu_bh:
-  0 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=545/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
-  1 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=967/1/0 df=3 of=0 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
-  2 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1081/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
-  3 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1846/0/0 df=8 of=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
-  4 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=369/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
-  5 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=381/1/0 df=4 of=0 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
-  6 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1037/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
-  7 c=1474 g=1474 pq=1 pgp=1473 qp=0 dt=1572/0/0 df=8 of=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
-
-The first section lists the rcu_data structures for rcu_sched, the second
-for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
-additional section for rcu_preempt.  Each section has one line per CPU,
-or eight for this 8-CPU system.  The fields are as follows:
+The output of "cat rcu/rcu_preempt/rcudata" looks as follows:
+
+  0!c=30455 g=30456 pq=1 qp=1 dt=126535/140000000000000/0 df=2002 of=4 ql=0/0 qs=N... b=10 ci=74572 nci=0 co=1131 ca=716
+  1!c=30719 g=30720 pq=1 qp=0 dt=132007/140000000000000/0 df=1874 of=10 ql=0/0 qs=N... b=10 ci=123209 nci=0 co=685 ca=982
+  2!c=30150 g=30151 pq=1 qp=1 dt=138537/140000000000000/0 df=1707 of=8 ql=0/0 qs=N... b=10 ci=80132 nci=0 co=1328 ca=1458
+  3 c=31249 g=31250 pq=1 qp=0 dt=107255/140000000000000/0 df=1749 of=6 ql=0/450 qs=NRW. b=10 ci=151700 nci=0 co=509 ca=622
+  4!c=29502 g=29503 pq=1 qp=1 dt=83647/140000000000000/0 df=965 of=5 ql=0/0 qs=N... b=10 ci=65643 nci=0 co=1373 ca=1521
+  5 c=31201 g=31202 pq=1 qp=1 dt=70422/0/0 df=535 of=7 ql=0/0 qs=.... b=10 ci=58500 nci=0 co=764 ca=698
+  6!c=30253 g=30254 pq=1 qp=1 dt=95363/140000000000000/0 df=780 of=5 ql=0/0 qs=N... b=10 ci=100607 nci=0 co=1414 ca=1353
+  7 c=31178 g=31178 pq=1 qp=0 dt=91536/0/0 df=547 of=4 ql=0/0 qs=.... b=10 ci=109819 nci=0 co=1115 ca=969
+
+This file has one line per CPU, or eight for this 8-CPU system.
+The fields are as follows:
 
 o	The number at the beginning of each line is the CPU number.
 	CPUs numbers followed by an exclamation mark are offline,
@@ -64,11 +76,13 @@ o	The number at the beginning of each line is the CPU number.
 	substantially larger than the number of actual CPUs.
 
 o	"c" is the count of grace periods that this CPU believes have
-	completed.  Offlined CPUs and CPUs in dynticks idle mode may
-	lag quite a ways behind, for example, CPU 6 under "rcu_sched"
-	above, which has been offline through not quite 40,000 RCU grace
-	periods.  It is not unusual to see CPUs lagging by thousands of
-	grace periods.
+	completed.  Offlined CPUs and CPUs in dynticks idle mode may lag
+	quite a ways behind, for example, CPU 4 under "rcu_sched" above,
+	which has been offline through 16 RCU grace periods.  It is not
+	unusual to see offline CPUs lagging by thousands of grace periods.
+	Note that although the grace-period number is an unsigned long,
+	it is printed out as a signed long to allow more human-friendly
+	representation near boot time.
 
 o	"g" is the count of grace periods that this CPU believes have
 	started.  Again, offlined CPUs and CPUs in dynticks idle mode
@@ -84,30 +98,25 @@ o	"pq" indicates that this CPU has passed through a quiescent state
 	CPU has not yet reported that fact, (2) some other CPU has not
 	yet reported for this grace period, or (3) both.
 
-o	"pgp" indicates which grace period the last-observed quiescent
-	state for this CPU corresponds to.  This is important for handling
-	the race between CPU 0 reporting an extended dynticks-idle
-	quiescent state for CPU 1 and CPU 1 suddenly waking up and
-	reporting its own quiescent state.  If CPU 1 was the last CPU
-	for the current grace period, then the CPU that loses this race
-	will attempt to incorrectly mark CPU 1 as having checked in for
-	the next grace period!
-
 o	"qp" indicates that RCU still expects a quiescent state from
 	this CPU.  Offlined CPUs and CPUs in dyntick idle mode might
 	well have qp=1, which is OK: RCU is still ignoring them.
 
 o	"dt" is the current value of the dyntick counter that is incremented
-	when entering or leaving dynticks idle state, either by the
-	scheduler or by irq.  This number is even if the CPU is in
-	dyntick idle mode and odd otherwise.  The number after the first
-	"/" is the interrupt nesting depth when in dyntick-idle state,
-	or one greater than the interrupt-nesting depth otherwise.
-	The number after the second "/" is the NMI nesting depth.
+	when entering or leaving idle, either due to a context switch or
+	due to an interrupt.  This number is even if the CPU is in idle
+	from RCU's viewpoint and odd otherwise.  The number after the
+	first "/" is the interrupt nesting depth when in idle state,
+	or a large number added to the interrupt-nesting depth when
+	running a non-idle task.  Some architectures do not accurately
+	count interrupt nesting when running in non-idle kernel context,
+	which can result in interesting anomalies such as negative
+	interrupt-nesting levels.  The number after the second "/"
+	is the NMI nesting depth.
 
 o	"df" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being in
-	dynticks-idle state.
+	idle state.
 
 o	"of" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being
@@ -120,9 +129,13 @@ o	"of" is the number of times that some other CPU has forced a
 	error, so it makes sense to err conservatively.
 
 o	"ql" is the number of RCU callbacks currently residing on
-	this CPU.  This is the total number of callbacks, regardless
-	of what state they are in (new, waiting for grace period to
-	start, waiting for grace period to end, ready to invoke).
+	this CPU.  The first number is the number of "lazy" callbacks
+	that are known to RCU to only be freeing memory, and the number
+	after the "/" is the total number of callbacks, lazy or not.
+	These counters count callbacks regardless of what phase of
+	grace-period processing that they are in (new, waiting for
+	grace period to start, waiting for grace period to end, ready
+	to invoke).
 
 o	"qs" gives an indication of the state of the callback queue
 	with four characters:
@@ -150,6 +163,43 @@ o	"qs" gives an indication of the state of the callback queue
 	If there are no callbacks in a given one of the above states,
 	the corresponding character is replaced by ".".
 
+o	"b" is the batch limit for this CPU.  If more than this number
+	of RCU callbacks is ready to invoke, then the remainder will
+	be deferred.
+
+o	"ci" is the number of RCU callbacks that have been invoked for
+	this CPU.  Note that ci+nci+ql is the number of callbacks that have
+	been registered in absence of CPU-hotplug activity.
+
+o	"nci" is the number of RCU callbacks that have been offloaded from
+	this CPU.  This will always be zero unless the kernel was built
+	with CONFIG_RCU_NOCB_CPU=y and the "rcu_nocbs=" kernel boot
+	parameter was specified.
+
+o	"co" is the number of RCU callbacks that have been orphaned due to
+	this CPU going offline.  These orphaned callbacks have been moved
+	to an arbitrarily chosen online CPU.
+
+o	"ca" is the number of RCU callbacks that have been adopted by this
+	CPU due to other CPUs going offline.  Note that ci+co-ca+ql is
+	the number of RCU callbacks registered on this CPU.
+
+
+Kernels compiled with CONFIG_RCU_BOOST=y display the following from
+/debug/rcu/rcu_preempt/rcudata:
+
+  0!c=12865 g=12866 pq=1 qp=1 dt=83113/140000000000000/0 df=288 of=11 ql=0/0 qs=N... kt=0/O ktl=944 b=10 ci=60709 nci=0 co=748 ca=871
+  1 c=14407 g=14408 pq=1 qp=0 dt=100679/140000000000000/0 df=378 of=7 ql=0/119 qs=NRW. kt=0/W ktl=9b6 b=10 ci=109740 nci=0 co=589 ca=485
+  2 c=14407 g=14408 pq=1 qp=0 dt=105486/0/0 df=90 of=9 ql=0/89 qs=NRW. kt=0/W ktl=c0c b=10 ci=83113 nci=0 co=533 ca=490
+  3 c=14407 g=14408 pq=1 qp=0 dt=107138/0/0 df=142 of=8 ql=0/188 qs=NRW. kt=0/W ktl=b96 b=10 ci=121114 nci=0 co=426 ca=290
+  4 c=14405 g=14406 pq=1 qp=1 dt=50238/0/0 df=706 of=7 ql=0/0 qs=.... kt=0/W ktl=812 b=10 ci=34929 nci=0 co=643 ca=114
+  5!c=14168 g=14169 pq=1 qp=0 dt=45465/140000000000000/0 df=161 of=11 ql=0/0 qs=N... kt=0/O ktl=b4d b=10 ci=47712 nci=0 co=677 ca=722
+  6 c=14404 g=14405 pq=1 qp=0 dt=59454/0/0 df=94 of=6 ql=0/0 qs=.... kt=0/W ktl=e57 b=10 ci=55597 nci=0 co=701 ca=811
+  7 c=14407 g=14408 pq=1 qp=1 dt=68850/0/0 df=31 of=8 ql=0/0 qs=.... kt=0/W ktl=14bd b=10 ci=77475 nci=0 co=508 ca=1042
+
+This is similar to the output discussed above, but contains the following
+additional fields:
+
 o	"kt" is the per-CPU kernel-thread state.  The digit preceding
 	the first slash is zero if there is no work pending and 1
 	otherwise.  The character between the first pair of slashes is
@@ -184,35 +234,51 @@ o	"ktl" is the low-order 16 bits (in hexadecimal) of the count of
 
 	This field is displayed only for CONFIG_RCU_BOOST kernels.
 
-o	"b" is the batch limit for this CPU.  If more than this number
-	of RCU callbacks is ready to invoke, then the remainder will
-	be deferred.
 
-o	"ci" is the number of RCU callbacks that have been invoked for
-	this CPU.  Note that ci+ql is the number of callbacks that have
-	been registered in absence of CPU-hotplug activity.
+The output of "cat rcu/rcu_preempt/rcuexp" looks as follows:
 
-o	"co" is the number of RCU callbacks that have been orphaned due to
-	this CPU going offline.  These orphaned callbacks have been moved
-	to an arbitrarily chosen online CPU.
+s=21872 d=21872 w=0 tf=0 wd1=0 wd2=0 n=0 sc=21872 dt=21872 dl=0 dx=21872
+
+These fields are as follows:
+
+o	"s" is the starting sequence number.
 
-o	"ca" is the number of RCU callbacks that have been adopted due to
-	other CPUs going offline.  Note that ci+co-ca+ql is the number of
-	RCU callbacks registered on this CPU.
+o	"d" is the ending sequence number.  When the starting and ending
+	numbers differ, there is an expedited grace period in progress.
 
-There is also an rcu/rcudata.csv file with the same information in
-comma-separated-variable spreadsheet format.
+o	"w" is the number of times that the sequence numbers have been
+	in danger of wrapping.
 
+o	"tf" is the number of times that contention has resulted in a
+	failure to begin an expedited grace period.
 
-The output of "cat rcu/rcugp" looks as follows:
+o	"wd1" and "wd2" are the number of times that an attempt to
+	start an expedited grace period found that someone else had
+	completed an expedited grace period that satisfies the
+	attempted request.  "Our work is done."
 
-rcu_sched: completed=33062  gpnum=33063
-rcu_bh: completed=464  gpnum=464
+o	"n" is number of times that contention was so great that
+	the request was demoted from an expedited grace period to
+	a normal grace period.
+
+o	"sc" is the number of times that the attempt to start a
+	new expedited grace period succeeded.
+
+o	"dt" is the number of times that we attempted to update
+	the "d" counter.
+
+o	"dl" is the number of times that we failed to update the "d"
+	counter.
+
+o	"dx" is the number of times that we succeeded in updating
+	the "d" counter.
 
-Again, this output is for both "rcu_sched" and "rcu_bh".  Note that
-kernels built with CONFIG_TREE_PREEMPT_RCU will have an additional
-"rcu_preempt" line.  The fields are taken from the rcu_state structure,
-and are as follows:
+
+The output of "cat rcu/rcu_preempt/rcugp" looks as follows:
+
+completed=31249  gpnum=31250  age=1  max=18
+
+These fields are taken from the rcu_state structure, and are as follows:
 
 o	"completed" is the number of grace periods that have completed.
 	It is comparable to the "c" field from rcu/rcudata in that a
@@ -220,44 +286,42 @@ o	"completed" is the number of grace periods that have completed.
 	that the corresponding RCU grace period has completed.
 
 o	"gpnum" is the number of grace periods that have started.  It is
-	comparable to the "g" field from rcu/rcudata in that a CPU
-	whose "g" field matches the value of "gpnum" is aware that the
-	corresponding RCU grace period has started.
+	similarly comparable to the "g" field from rcu/rcudata in that
+	a CPU whose "g" field matches the value of "gpnum" is aware that
+	the corresponding RCU grace period has started.
+
+	If these two fields are equal, then there is no grace period
+	in progress, in other words, RCU is idle.  On the other hand,
+	if the two fields differ (as they are above), then an RCU grace
+	period is in progress.
 
-	If these two fields are equal (as they are for "rcu_bh" above),
-	then there is no grace period in progress, in other words, RCU
-	is idle.  On the other hand, if the two fields differ (as they
-	do for "rcu_sched" above), then an RCU grace period is in progress.
+o	"age" is the number of jiffies that the current grace period
+	has extended for, or zero if there is no grace period currently
+	in effect.
 
+o	"max" is the age in jiffies of the longest-duration grace period
+	thus far.
 
-The output of "cat rcu/rcuhier" looks as follows, with very long lines:
+The output of "cat rcu/rcu_preempt/rcuhier" looks as follows:
 
-c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6
-1/1 ..>. 0:127 ^0
-3/3 ..>. 0:35 ^0    0/0 ..>. 36:71 ^1    0/0 ..>. 72:107 ^2    0/0 ..>. 108:127 ^3
-3/3f ..>. 0:5 ^0    2/3 ..>. 6:11 ^1    0/0 ..>. 12:17 ^2    0/0 ..>. 18:23 ^3    0/0 ..>. 24:29 ^4    0/0 ..>. 30:35 ^5    0/0 ..>. 36:41 ^0    0/0 ..>. 42:47 ^1    0/0 ..>. 48:53 ^2    0/0 ..>. 54:59 ^3    0/0 ..>. 60:65 ^4    0/0 ..>. 66:71 ^5    0/0 ..>. 72:77 ^0    0/0 ..>. 78:83 ^1    0/0 ..>. 84:89 ^2    0/0 ..>. 90:95 ^3    0/0 ..>. 96:101 ^4    0/0 ..>. 102:107 ^5    0/0 ..>. 108:113 ^0    0/0 ..>. 114:119 ^1    0/0 ..>. 120:125 ^2    0/0 ..>. 126:127 ^3
-rcu_bh:
-c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
-0/1 ..>. 0:127 ^0
-0/3 ..>. 0:35 ^0    0/0 ..>. 36:71 ^1    0/0 ..>. 72:107 ^2    0/0 ..>. 108:127 ^3
-0/3f ..>. 0:5 ^0    0/3 ..>. 6:11 ^1    0/0 ..>. 12:17 ^2    0/0 ..>. 18:23 ^3    0/0 ..>. 24:29 ^4    0/0 ..>. 30:35 ^5    0/0 ..>. 36:41 ^0    0/0 ..>. 42:47 ^1    0/0 ..>. 48:53 ^2    0/0 ..>. 54:59 ^3    0/0 ..>. 60:65 ^4    0/0 ..>. 66:71 ^5    0/0 ..>. 72:77 ^0    0/0 ..>. 78:83 ^1    0/0 ..>. 84:89 ^2    0/0 ..>. 90:95 ^3    0/0 ..>. 96:101 ^4    0/0 ..>. 102:107 ^5    0/0 ..>. 108:113 ^0    0/0 ..>. 114:119 ^1    0/0 ..>. 120:125 ^2    0/0 ..>. 126:127 ^3
+c=14407 g=14408 s=0 jfq=2 j=c863 nfqs=12040/nfqsng=0(12040) fqlh=1051 oqlen=0/0
+3/3 ..>. 0:7 ^0
+e/e ..>. 0:3 ^0    d/d ..>. 4:7 ^1
 
-This is once again split into "rcu_sched" and "rcu_bh" portions,
-and CONFIG_TREE_PREEMPT_RCU kernels will again have an additional
-"rcu_preempt" section.  The fields are as follows:
+The fields are as follows:
 
-o	"c" is exactly the same as "completed" under rcu/rcugp.
+o	"c" is exactly the same as "completed" under rcu/rcu_preempt/rcugp.
 
-o	"g" is exactly the same as "gpnum" under rcu/rcugp.
+o	"g" is exactly the same as "gpnum" under rcu/rcu_preempt/rcugp.
 
-o	"s" is the "signaled" state that drives force_quiescent_state()'s
+o	"s" is the current state of the force_quiescent_state()
 	state machine.
 
 o	"jfq" is the number of jiffies remaining for this grace period
 	before force_quiescent_state() is invoked to help push things
-	along.  Note that CPUs in dyntick-idle mode throughout the grace
-	period will not report on their own, but rather must be check by
-	some other CPU via force_quiescent_state().
+	along.	Note that CPUs in idle mode throughout the grace period
+	will not report on their own, but rather must be check by some
+	other CPU via force_quiescent_state().
 
 o	"j" is the low-order four hex digits of the jiffies counter.
 	Yes, Paul did run into a number of problems that turned out to
@@ -268,7 +332,8 @@ o	"nfqs" is the number of calls to force_quiescent_state() since
 
 o	"nfqsng" is the number of useless calls to force_quiescent_state(),
 	where there wasn't actually a grace period active.  This can
-	happen due to races.  The number in parentheses is the difference
+	no longer happen due to grace-period processing being pushed
+	into a kthread.  The number in parentheses is the difference
 	between "nfqs" and "nfqsng", or the number of times that
 	force_quiescent_state() actually did some real work.
 
@@ -276,28 +341,27 @@ o	"fqlh" is the number of calls to force_quiescent_state() that
 	exited immediately (without even being counted in nfqs above)
 	due to contention on ->fqslock.
 
-o	Each element of the form "1/1 0:127 ^0" represents one struct
-	rcu_node.  Each line represents one level of the hierarchy, from
-	root to leaves.  It is best to think of the rcu_data structures
-	as forming yet another level after the leaves.  Note that there
-	might be either one, two, or three levels of rcu_node structures,
-	depending on the relationship between CONFIG_RCU_FANOUT and
-	CONFIG_NR_CPUS.
+o	Each element of the form "3/3 ..>. 0:7 ^0" represents one rcu_node
+	structure.  Each line represents one level of the hierarchy,
+	from root to leaves.  It is best to think of the rcu_data
+	structures as forming yet another level after the leaves.
+	Note that there might be either one, two, three, or even four
+	levels of rcu_node structures, depending on the relationship
+	between CONFIG_RCU_FANOUT, CONFIG_RCU_FANOUT_LEAF (possibly
+	adjusted using the rcu_fanout_leaf kernel boot parameter), and
+	CONFIG_NR_CPUS (possibly adjusted using the nr_cpu_ids count of
+	possible CPUs for the booting hardware).
 
 	o	The numbers separated by the "/" are the qsmask followed
 		by the qsmaskinit.  The qsmask will have one bit
-		set for each entity in the next lower level that
-		has not yet checked in for the current grace period.
+		set for each entity in the next lower level that has
+		not yet checked in for the current grace period ("e"
+		indicating CPUs 5, 6, and 7 in the example above).
 		The qsmaskinit will have one bit for each entity that is
 		currently expected to check in during each grace period.
 		The value of qsmaskinit is assigned to that of qsmask
 		at the beginning of each grace period.
 
-		For example, for "rcu_sched", the qsmask of the first
-		entry of the lowest level is 0x14, meaning that we
-		are still waiting for CPUs 2 and 4 to check in for the
-		current grace period.
-
 	o	The characters separated by the ">" indicate the state
 		of the blocked-tasks lists.  A "G" preceding the ">"
 		indicates that at least one task blocked in an RCU
@@ -312,48 +376,39 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 		A "." character appears if the corresponding condition
 		does not hold, so that "..>." indicates that no tasks
 		are blocked.  In contrast, "GE>T" indicates maximal
-		inconvenience from blocked tasks.
+		inconvenience from blocked tasks.  CONFIG_TREE_RCU
+		builds of the kernel will always show "..>.".
 
 	o	The numbers separated by the ":" are the range of CPUs
 		served by this struct rcu_node.  This can be helpful
 		in working out how the hierarchy is wired together.
 
-		For example, the first entry at the lowest level shows
-		"0:5", indicating that it covers CPUs 0 through 5.
+		For example, the example rcu_node structure shown above
+		has "0:7", indicating that it covers CPUs 0 through 7.
 
 	o	The number after the "^" indicates the bit in the
-		next higher level rcu_node structure that this
-		rcu_node structure corresponds to.
-
-		For example, the first entry at the lowest level shows
-		"^0", indicating that it corresponds to bit zero in
-		the first entry at the middle level.
-
-
-The output of "cat rcu/rcu_pending" looks as follows:
-
-rcu_sched:
-  0 np=255892 qsp=53936 rpq=85 cbr=0 cng=14417 gpc=10033 gps=24320 nn=146741
-  1 np=261224 qsp=54638 rpq=33 cbr=0 cng=25723 gpc=16310 gps=2849 nn=155792
-  2 np=237496 qsp=49664 rpq=23 cbr=0 cng=2762 gpc=45478 gps=1762 nn=136629
-  3 np=236249 qsp=48766 rpq=98 cbr=0 cng=286 gpc=48049 gps=1218 nn=137723
-  4 np=221310 qsp=46850 rpq=7 cbr=0 cng=26 gpc=43161 gps=4634 nn=123110
-  5 np=237332 qsp=48449 rpq=9 cbr=0 cng=54 gpc=47920 gps=3252 nn=137456
-  6 np=219995 qsp=46718 rpq=12 cbr=0 cng=50 gpc=42098 gps=6093 nn=120834
-  7 np=249893 qsp=49390 rpq=42 cbr=0 cng=72 gpc=38400 gps=17102 nn=144888
-rcu_bh:
-  0 np=146741 qsp=1419 rpq=6 cbr=0 cng=6 gpc=0 gps=0 nn=145314
-  1 np=155792 qsp=12597 rpq=3 cbr=0 cng=0 gpc=4 gps=8 nn=143180
-  2 np=136629 qsp=18680 rpq=1 cbr=0 cng=0 gpc=7 gps=6 nn=117936
-  3 np=137723 qsp=2843 rpq=0 cbr=0 cng=0 gpc=10 gps=7 nn=134863
-  4 np=123110 qsp=12433 rpq=0 cbr=0 cng=0 gpc=4 gps=2 nn=110671
-  5 np=137456 qsp=4210 rpq=1 cbr=0 cng=0 gpc=6 gps=5 nn=133235
-  6 np=120834 qsp=9902 rpq=2 cbr=0 cng=0 gpc=6 gps=3 nn=110921
-  7 np=144888 qsp=26336 rpq=0 cbr=0 cng=0 gpc=8 gps=2 nn=118542
-
-As always, this is once again split into "rcu_sched" and "rcu_bh"
-portions, with CONFIG_TREE_PREEMPT_RCU kernels having an additional
-"rcu_preempt" section.  The fields are as follows:
+		next higher level rcu_node structure that this rcu_node
+		structure corresponds to.  For example, the "d/d ..>. 4:7
+		^1" has a "1" in this position, indicating that it
+		corresponds to the "1" bit in the "3" shown in the
+		"3/3 ..>. 0:7 ^0" entry on the next level up.
+
+
+The output of "cat rcu/rcu_sched/rcu_pending" looks as follows:
+
+  0!np=26111 qsp=29 rpq=5386 cbr=1 cng=570 gpc=3674 gps=577 nn=15903
+  1!np=28913 qsp=35 rpq=6097 cbr=1 cng=448 gpc=3700 gps=554 nn=18113
+  2!np=32740 qsp=37 rpq=6202 cbr=0 cng=476 gpc=4627 gps=546 nn=20889
+  3 np=23679 qsp=22 rpq=5044 cbr=1 cng=415 gpc=3403 gps=347 nn=14469
+  4!np=30714 qsp=4 rpq=5574 cbr=0 cng=528 gpc=3931 gps=639 nn=20042
+  5 np=28910 qsp=2 rpq=5246 cbr=0 cng=428 gpc=4105 gps=709 nn=18422
+  6!np=38648 qsp=5 rpq=7076 cbr=0 cng=840 gpc=4072 gps=961 nn=25699
+  7 np=37275 qsp=2 rpq=6873 cbr=0 cng=868 gpc=3416 gps=971 nn=25147
+
+The fields are as follows:
+
+o	The leading number is the CPU number, with "!" indicating
+	an offline CPU.
 
 o	"np" is the number of times that __rcu_pending() has been invoked
 	for the corresponding flavor of RCU.
@@ -377,38 +432,23 @@ o	"gpc" is the number of times that an old grace period had
 o	"gps" is the number of times that a new grace period had started,
 	but this CPU was not yet aware of it.
 
-o	"nn" is the number of times that this CPU needed nothing.  Alert
-	readers will note that the rcu "nn" number for a given CPU very
-	closely matches the rcu_bh "np" number for that same CPU.  This
-	is due to short-circuit evaluation in rcu_pending().
-
-
-The output of "cat rcu/rcutorture" looks as follows:
-
-rcutorture test sequence: 0 (test in progress)
-rcutorture update version number: 615
-
-The first line shows the number of rcutorture tests that have completed
-since boot.  If a test is currently running, the "(test in progress)"
-string will appear as shown above.  The second line shows the number of
-update cycles that the current test has started, or zero if there is
-no test in progress.
+o	"nn" is the number of times that this CPU needed nothing.
 
 
 The output of "cat rcu/rcuboost" looks as follows:
 
-0:5 tasks=.... kt=W ntb=0 neb=0 nnb=0 j=2f95 bt=300f
-     balk: nt=0 egt=989 bt=0 nb=0 ny=0 nos=16
-6:7 tasks=.... kt=W ntb=0 neb=0 nnb=0 j=2f95 bt=300f
-     balk: nt=0 egt=225 bt=0 nb=0 ny=0 nos=6
+0:3 tasks=.... kt=W ntb=0 neb=0 nnb=0 j=c864 bt=c894
+    balk: nt=0 egt=4695 bt=0 nb=0 ny=56 nos=0
+4:7 tasks=.... kt=W ntb=0 neb=0 nnb=0 j=c864 bt=c894
+    balk: nt=0 egt=6541 bt=0 nb=0 ny=126 nos=0
 
 This information is output only for rcu_preempt.  Each two-line entry
 corresponds to a leaf rcu_node strcuture.  The fields are as follows:
 
 o	"n:m" is the CPU-number range for the corresponding two-line
 	entry.  In the sample output above, the first entry covers
-	CPUs zero through five and the second entry covers CPUs 6
-	and 7.
+	CPUs zero through three and the second entry covers CPUs four
+	through seven.
 
 o	"tasks=TNEB" gives the state of the various segments of the
 	rnp->blocked_tasks list:
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index bf0f6de..0cc7820 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -499,6 +499,8 @@ The foo_reclaim() function might appear as follows:
 	{
 		struct foo *fp = container_of(rp, struct foo, rcu);
 
+		foo_cleanup(fp->a);
+
 		kfree(fp);
 	}
 
@@ -521,6 +523,12 @@ o	Use call_rcu() -after- removing a data element from an
 	read-side critical sections that might be referencing that
 	data item.
 
+If the callback for call_rcu() is not doing anything more than calling
+kfree() on the structure, you can use kfree_rcu() instead of call_rcu()
+to avoid having to write your own callback:
+
+	kfree_rcu(old_fp, rcu);
+
 Again, see checklist.txt for additional rules governing the use of RCU.
 
 
@@ -773,8 +781,8 @@ a single atomic update, converting to RCU will require special care.
 
 Also, the presence of synchronize_rcu() means that the RCU version of
 delete() can now block.  If this is a problem, there is a callback-based
-mechanism that never blocks, namely call_rcu(), that can be used in
-place of synchronize_rcu().
+mechanism that never blocks, namely call_rcu() or kfree_rcu(), that can
+be used in place of synchronize_rcu().
 
 
 7.  FULL LIST OF RCU APIs
@@ -789,9 +797,7 @@ RCU list traversal:
 	list_for_each_entry_rcu
 	hlist_for_each_entry_rcu
 	hlist_nulls_for_each_entry_rcu
-
-	list_for_each_continue_rcu	(to be deprecated in favor of new
-					 list_for_each_entry_continue_rcu)
+	list_for_each_entry_continue_rcu
 
 RCU pointer/list update:
 
@@ -813,6 +819,7 @@ RCU:	Critical sections	Grace period		Barrier
 	rcu_read_unlock		synchronize_rcu
 	rcu_dereference		synchronize_rcu_expedited
 				call_rcu
+				kfree_rcu
 
 
 bh:	Critical sections	Grace period		Barrier
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..9d2e5cb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2394,6 +2394,27 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
 			See Documentation/blockdev/ramdisk.txt.
 
+	rcu_nocbs=	[KNL,BOOT]
+			In kernels built with CONFIG_RCU_NOCB_CPU=y, set
+			the specified list of CPUs to be no-callback CPUs.
+			Invocation of these CPUs' RCU callbacks will
+			be offloaded to "rcuoN" kthreads created for
+			that purpose.  This reduces OS jitter on the
+			offloaded CPUs, which can be useful for HPC and
+			real-time workloads.  It can also improve energy
+			efficiency for asymmetric multiprocessors.
+
+	rcu_nocbs_poll	[KNL,BOOT]
+			Rather than requiring that offloaded CPUs
+			(specified by rcu_nocbs= above) explicitly
+			awaken the corresponding "rcuoN" kthreads,
+			make these kthreads poll for callbacks.
+			This improves the real-time response for the
+			offloaded CPUs by relieving them of the need to
+			wake up the corresponding kthread, but degrades
+			energy efficiency by requiring that the kthreads
+			periodically wake up to do the polling.
+
 	rcutree.blimit=	[KNL,BOOT]
 			Set maximum number of finished RCU callbacks to process
 			in one batch.
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 2759f7c..3c4e1b3 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -251,12 +251,13 @@ And there are a number of things that _must_ or _must_not_ be assumed:
 
      And for:
 
-	*A = X; Y = *A;
+	*A = X; *(A + 4) = Y;
 
-     we may get either of:
+     we may get any of:
 
-	STORE *A = X; Y = LOAD *A;
-	STORE *A = Y = X;
+	STORE *A = X; STORE *(A + 4) = Y;
+	STORE *(A + 4) = Y; STORE *A = X;
+	STORE {*A, *(A + 4) } = {X, Y};
 
 
 =========================
diff --git a/arch/Kconfig b/arch/Kconfig
index 366ec06..cc74aae 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -300,15 +300,16 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
-config HAVE_RCU_USER_QS
+config HAVE_CONTEXT_TRACKING
 	bool
 	help
-	  Provide kernel entry/exit hooks necessary for userspace
-	  RCU extended quiescent state. Syscalls need to be wrapped inside
-	  rcu_user_exit()-rcu_user_enter() through the slow path using
-	  TIF_NOHZ flag. Exceptions handlers must be wrapped as well. Irqs
-	  are already protected inside rcu_irq_enter/rcu_irq_exit() but
-	  preemption or signal handling on irq exit still need to be protected.
+	  Provide kernel/user boundaries probes necessary for subsystems
+	  that need it, such as userspace RCU extended quiescent state.
+	  Syscalls need to be wrapped inside user_exit()-user_enter() through
+	  the slow path using TIF_NOHZ flag. Exceptions handlers must be
+	  wrapped as well. Irqs are already protected inside
+	  rcu_irq_enter/rcu_irq_exit() but preemption or signal handling on
+	  irq exit still need to be protected.
 
 config HAVE_VIRT_CPU_ACCOUNTING
 	bool
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 79ccfe6..49e3b49 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -648,7 +648,7 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
-	rcu_switch(from, to);
+	rcu_user_hooks_switch(from, to);
 	switch_to(from, to, from);
 }
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..110cfad 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -106,7 +106,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
-	select HAVE_RCU_USER_QS if X86_64
+	select HAVE_CONTEXT_TRACKING if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select GENERIC_KERNEL_THREAD
 	select GENERIC_KERNEL_EXECVE
diff --git a/arch/x86/include/asm/rcu.h b/arch/x86/include/asm/context_tracking.h
similarity index 63%
rename from arch/x86/include/asm/rcu.h
rename to arch/x86/include/asm/context_tracking.h
index d1ac07a..1616562 100644
--- a/arch/x86/include/asm/rcu.h
+++ b/arch/x86/include/asm/context_tracking.h
@@ -1,27 +1,26 @@
-#ifndef _ASM_X86_RCU_H
-#define _ASM_X86_RCU_H
+#ifndef _ASM_X86_CONTEXT_TRACKING_H
+#define _ASM_X86_CONTEXT_TRACKING_H
 
 #ifndef __ASSEMBLY__
-
-#include <linux/rcupdate.h>
+#include <linux/context_tracking.h>
 #include <asm/ptrace.h>
 
 static inline void exception_enter(struct pt_regs *regs)
 {
-	rcu_user_exit();
+	user_exit();
 }
 
 static inline void exception_exit(struct pt_regs *regs)
 {
-#ifdef CONFIG_RCU_USER_QS
+#ifdef CONFIG_CONTEXT_TRACKING
 	if (user_mode(regs))
-		rcu_user_enter();
+		user_enter();
 #endif
 }
 
 #else /* __ASSEMBLY__ */
 
-#ifdef CONFIG_RCU_USER_QS
+#ifdef CONFIG_CONTEXT_TRACKING
 # define SCHEDULE_USER call schedule_user
 #else
 # define SCHEDULE_USER call schedule
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1328fe4..2a3806b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -56,7 +56,7 @@
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
 #include <asm/asm.h>
-#include <asm/rcu.h>
+#include <asm/context_tracking.h>
 #include <asm/smap.h>
 #include <linux/err.h>
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 974b67e..b629bbe 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -23,6 +23,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/rcupdate.h>
 #include <linux/module.h>
+#include <linux/context_tracking.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -1491,7 +1492,7 @@ long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	rcu_user_exit();
+	user_exit();
 
 	/*
 	 * If we stepped into a sysenter/syscall insn, it trapped in
@@ -1546,7 +1547,7 @@ void syscall_trace_leave(struct pt_regs *regs)
 	 * or do_notify_resume(), in which case we can be in RCU
 	 * user mode.
 	 */
-	rcu_user_exit();
+	user_exit();
 
 	audit_syscall_exit(regs);
 
@@ -1564,5 +1565,5 @@ void syscall_trace_leave(struct pt_regs *regs)
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
 
-	rcu_user_enter();
+	user_enter();
 }
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 70b27ee..fbbb604 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -22,6 +22,7 @@
 #include <linux/uaccess.h>
 #include <linux/user-return-notifier.h>
 #include <linux/uprobes.h>
+#include <linux/context_tracking.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
@@ -816,7 +817,7 @@ static void do_signal(struct pt_regs *regs)
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
-	rcu_user_exit();
+	user_exit();
 
 #ifdef CONFIG_X86_MCE
 	/* notify userspace of pending MCEs */
@@ -838,7 +839,7 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
 		fire_user_return_notifiers();
 
-	rcu_user_enter();
+	user_enter();
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8276dc6..eb85866 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -55,7 +55,7 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/mce.h>
-#include <asm/rcu.h>
+#include <asm/context_tracking.h>
 
 #include <asm/mach_traps.h>
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8e13ecb..7a529cb 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -18,7 +18,7 @@
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
 #include <asm/fixmap.h>			/* VSYSCALL_START		*/
-#include <asm/rcu.h>			/* exception_enter(), ...	*/
+#include <asm/context_tracking.h>	/* exception_enter(), ...	*/
 
 /*
  * Page fault error code bits:
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
new file mode 100644
index 0000000..e24339c
--- /dev/null
+++ b/include/linux/context_tracking.h
@@ -0,0 +1,18 @@
+#ifndef _LINUX_CONTEXT_TRACKING_H
+#define _LINUX_CONTEXT_TRACKING_H
+
+#ifdef CONFIG_CONTEXT_TRACKING
+#include <linux/sched.h>
+
+extern void user_enter(void);
+extern void user_exit(void);
+extern void context_tracking_task_switch(struct task_struct *prev,
+					 struct task_struct *next);
+#else
+static inline void user_enter(void) { }
+static inline void user_exit(void) { }
+static inline void context_tracking_task_switch(struct task_struct *prev,
+						struct task_struct *next) { }
+#endif /* !CONFIG_CONTEXT_TRACKING */
+
+#endif
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e0f0fab..c92dd28 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -286,23 +286,6 @@ static inline void list_splice_init_rcu(struct list_head *list,
 		&pos->member != (head); \
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
-
-/**
- * list_for_each_continue_rcu
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * Iterate over an rcu-protected list, continuing after current point.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = rcu_dereference_raw(list_next_rcu(pos)); \
-		(pos) != (head); \
-		(pos) = rcu_dereference_raw(list_next_rcu(pos)))
-
 /**
  * list_for_each_entry_continue_rcu - continue iteration over list of given type
  * @pos:	the type * to use as a loop cursor.
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7c968e4..275aa3f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -90,6 +90,25 @@ extern void do_trace_rcu_torture_read(char *rcutorturename,
  * that started after call_rcu() was invoked.  RCU read-side critical
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
+ *
+ * Note that all CPUs must agree that the grace period extended beyond
+ * all pre-existing RCU read-side critical section.  On systems with more
+ * than one CPU, this means that when "func()" is invoked, each CPU is
+ * guaranteed to have executed a full memory barrier since the end of its
+ * last RCU read-side critical section whose beginning preceded the call
+ * to call_rcu().  It also means that each CPU executing an RCU read-side
+ * critical section that continues beyond the start of "func()" must have
+ * executed a memory barrier after the call_rcu() but before the beginning
+ * of that RCU read-side critical section.  Note that these guarantees
+ * include CPUs that are offline, idle, or executing in user mode, as
+ * well as CPUs that are executing in the kernel.
+ *
+ * Furthermore, if CPU A invoked call_rcu() and CPU B invoked the
+ * resulting RCU callback function "func()", then both CPU A and CPU B are
+ * guaranteed to execute a full memory barrier during the time interval
+ * between the call to call_rcu() and the invocation of "func()" -- even
+ * if CPU A and CPU B are the same CPU (but again only if the system has
+ * more than one CPU).
  */
 extern void call_rcu(struct rcu_head *head,
 			      void (*func)(struct rcu_head *head));
@@ -118,6 +137,9 @@ extern void call_rcu(struct rcu_head *head,
  *  OR
  *  - rcu_read_lock_bh() and rcu_read_unlock_bh(), if in process context.
  *  These may be nested.
+ *
+ * See the description of call_rcu() for more detailed information on
+ * memory ordering guarantees.
  */
 extern void call_rcu_bh(struct rcu_head *head,
 			void (*func)(struct rcu_head *head));
@@ -137,6 +159,9 @@ extern void call_rcu_bh(struct rcu_head *head,
  *  OR
  *  anything that disables preemption.
  *  These may be nested.
+ *
+ * See the description of call_rcu() for more detailed information on
+ * memory ordering guarantees.
  */
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
@@ -197,13 +222,13 @@ extern void rcu_user_enter(void);
 extern void rcu_user_exit(void);
 extern void rcu_user_enter_after_irq(void);
 extern void rcu_user_exit_after_irq(void);
-extern void rcu_user_hooks_switch(struct task_struct *prev,
-				  struct task_struct *next);
 #else
 static inline void rcu_user_enter(void) { }
 static inline void rcu_user_exit(void) { }
 static inline void rcu_user_enter_after_irq(void) { }
 static inline void rcu_user_exit_after_irq(void) { }
+static inline void rcu_user_hooks_switch(struct task_struct *prev,
+					 struct task_struct *next) { }
 #endif /* CONFIG_RCU_USER_QS */
 
 extern void exit_rcu(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..530c52e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -109,6 +109,8 @@ extern void update_cpu_load_nohz(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
+extern void dump_cpu_task(int cpu);
+
 struct seq_file;
 struct cfs_rq;
 struct task_group;
@@ -1844,14 +1846,6 @@ static inline void rcu_copy_process(struct task_struct *p)
 
 #endif
 
-static inline void rcu_switch(struct task_struct *prev,
-			      struct task_struct *next)
-{
-#ifdef CONFIG_RCU_USER_QS
-	rcu_user_hooks_switch(prev, next);
-#endif
-}
-
 static inline void tsk_restore_flags(struct task_struct *task,
 				unsigned long orig_flags, unsigned long flags)
 {
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 55a5c52..6eb691b 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -16,8 +16,10 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2006
+ * Copyright (C) Fujitsu, 2012
  *
  * Author: Paul McKenney <paulmck@us.ibm.com>
+ *	   Lai Jiangshan <laijs@cn.fujitsu.com>
  *
  * For detailed explanation of Read-Copy Update mechanism see -
  * 		Documentation/RCU/ *.txt
@@ -40,6 +42,8 @@ struct rcu_batch {
 	struct rcu_head *head, **tail;
 };
 
+#define RCU_BATCH_INIT(name) { NULL, &(name.head) }
+
 struct srcu_struct {
 	unsigned completed;
 	struct srcu_struct_array __percpu *per_cpu_ref;
@@ -70,12 +74,42 @@ int __init_srcu_struct(struct srcu_struct *sp, const char *name,
 	__init_srcu_struct((sp), #sp, &__srcu_key); \
 })
 
+#define __SRCU_DEP_MAP_INIT(srcu_name)	.dep_map = { .name = #srcu_name },
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 int init_srcu_struct(struct srcu_struct *sp);
 
+#define __SRCU_DEP_MAP_INIT(srcu_name)
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+void process_srcu(struct work_struct *work);
+
+#define __SRCU_STRUCT_INIT(name)					\
+	{								\
+		.completed = -300,					\
+		.per_cpu_ref = &name##_srcu_array,			\
+		.queue_lock = __SPIN_LOCK_UNLOCKED(name.queue_lock),	\
+		.running = false,					\
+		.batch_queue = RCU_BATCH_INIT(name.batch_queue),	\
+		.batch_check0 = RCU_BATCH_INIT(name.batch_check0),	\
+		.batch_check1 = RCU_BATCH_INIT(name.batch_check1),	\
+		.batch_done = RCU_BATCH_INIT(name.batch_done),		\
+		.work = __DELAYED_WORK_INITIALIZER(name.work, process_srcu, 0),\
+		__SRCU_DEP_MAP_INIT(name)				\
+	}
+
+/*
+ * define and init a srcu struct at build time.
+ * dont't call init_srcu_struct() nor cleanup_srcu_struct() on it.
+ */
+#define DEFINE_SRCU(name)						\
+	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
+	struct srcu_struct name = __SRCU_STRUCT_INIT(name);
+
+#define DEFINE_STATIC_SRCU(name)					\
+	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
+	static struct srcu_struct name = __SRCU_STRUCT_INIT(name);
+
 /**
  * call_srcu() - Queue a callback for invocation after an SRCU grace period
  * @sp: srcu_struct in queue the callback
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 5bde94d..d4f559b 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -549,6 +549,7 @@ TRACE_EVENT(rcu_torture_read,
  *	"EarlyExit": rcu_barrier_callback() piggybacked, thus early exit.
  *	"Inc1": rcu_barrier_callback() piggyback check counter incremented.
  *	"Offline": rcu_barrier_callback() found offline CPU
+ *	"OnlineNoCB": rcu_barrier_callback() found online no-CBs CPU.
  *	"OnlineQ": rcu_barrier_callback() found online CPU with callbacks.
  *	"OnlineNQ": rcu_barrier_callback() found online CPU, no callbacks.
  *	"IRQ": An rcu_barrier_callback() callback posted on remote CPU.
diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..2054e04 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -486,35 +486,35 @@ config PREEMPT_RCU
 	  This option enables preemptible-RCU code that is common between
 	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
 
+config CONTEXT_TRACKING
+       bool
+
 config RCU_USER_QS
 	bool "Consider userspace as in RCU extended quiescent state"
-	depends on HAVE_RCU_USER_QS && SMP
+	depends on HAVE_CONTEXT_TRACKING && SMP
+	select CONTEXT_TRACKING
 	help
 	  This option sets hooks on kernel / userspace boundaries and
 	  puts RCU in extended quiescent state when the CPU runs in
 	  userspace. It means that when a CPU runs in userspace, it is
 	  excluded from the global RCU state machine and thus doesn't
-	  to keep the timer tick on for RCU.
+	  try to keep the timer tick on for RCU.
 
 	  Unless you want to hack and help the development of the full
-	  tickless feature, you shouldn't enable this option. It adds
-	  unnecessary overhead.
+	  dynticks mode, you shouldn't enable this option.  It also
+	  adds unnecessary overhead.
 
 	  If unsure say N
 
-config RCU_USER_QS_FORCE
-	bool "Force userspace extended QS by default"
-	depends on RCU_USER_QS
+config CONTEXT_TRACKING_FORCE
+	bool "Force context tracking"
+	depends on CONTEXT_TRACKING
 	help
-	  Set the hooks in user/kernel boundaries by default in order to
-	  test this feature that treats userspace as an extended quiescent
-	  state until we have a real user like a full adaptive nohz option.
-
-	  Unless you want to hack and help the development of the full
-	  tickless feature, you shouldn't enable this option. It adds
-	  unnecessary overhead.
-
-	  If unsure say N
+	  Probe on user/kernel boundaries by default in order to
+	  test the features that rely on it such as userspace RCU extended
+	  quiescent states.
+	  This test is there for debugging until we have a real user like the
+	  full dynticks mode.
 
 config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
@@ -582,14 +582,13 @@ config RCU_FAST_NO_HZ
 	depends on NO_HZ && SMP
 	default n
 	help
-	  This option causes RCU to attempt to accelerate grace periods
-	  in order to allow CPUs to enter dynticks-idle state more
-	  quickly.  On the other hand, this option increases the overhead
-	  of the dynticks-idle checking, particularly on systems with
-	  large numbers of CPUs.
+	  This option causes RCU to attempt to accelerate grace periods in
+	  order to allow CPUs to enter dynticks-idle state more quickly.
+	  On the other hand, this option increases the overhead of the
+	  dynticks-idle checking, thus degrading scheduling latency.
 
-	  Say Y if energy efficiency is critically important, particularly
-	  	if you have relatively few CPUs.
+	  Say Y if energy efficiency is critically important, and you don't
+	  	care about real-time response.
 
 	  Say N if you are unsure.
 
@@ -655,6 +654,28 @@ config RCU_BOOST_DELAY
 
 	  Accept the default if unsure.
 
+config RCU_NOCB_CPU
+	bool "Offload RCU callback processing from boot-selected CPUs"
+	depends on TREE_RCU || TREE_PREEMPT_RCU
+	default n
+	help
+	  Use this option to reduce OS jitter for aggressive HPC or
+	  real-time workloads.	It can also be used to offload RCU
+	  callback invocation to energy-efficient CPUs in battery-powered
+	  asymmetric multiprocessors.
+
+	  This option offloads callback invocation from the set of
+	  CPUs specified at boot time by the rcu_nocbs parameter.
+	  For each such CPU, a kthread ("rcuoN") will be created to
+	  invoke callbacks, where the "N" is the CPU being offloaded.
+	  Nothing prevents this kthread from running on the specified
+	  CPUs, but (1) the kthreads may be preempted between each
+	  callback, and (2) affinity or cgroups can be used to force
+	  the kthreads to run on whatever set of CPUs is desired.
+
+	  Say Y here if you want reduced OS jitter on selected CPUs.
+	  Say N here if you are unsure.
+
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
diff --git a/kernel/Makefile b/kernel/Makefile
index 86e3285..ac0d533 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
+obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
new file mode 100644
index 0000000..e0e07fd
--- /dev/null
+++ b/kernel/context_tracking.c
@@ -0,0 +1,83 @@
+#include <linux/context_tracking.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+
+struct context_tracking {
+	/*
+	 * When active is false, hooks are not set to
+	 * minimize overhead: TIF flags are cleared
+	 * and calls to user_enter/exit are ignored. This
+	 * may be further optimized using static keys.
+	 */
+	bool active;
+	enum {
+		IN_KERNEL = 0,
+		IN_USER,
+	} state;
+};
+
+static DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
+#ifdef CONFIG_CONTEXT_TRACKING_FORCE
+	.active = true,
+#endif
+};
+
+void user_enter(void)
+{
+	unsigned long flags;
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
+
+	WARN_ON_ONCE(!current->mm);
+
+	local_irq_save(flags);
+	if (__this_cpu_read(context_tracking.active) &&
+	    __this_cpu_read(context_tracking.state) != IN_USER) {
+		__this_cpu_write(context_tracking.state, IN_USER);
+		rcu_user_enter();
+	}
+	local_irq_restore(flags);
+}
+
+void user_exit(void)
+{
+	unsigned long flags;
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
+
+	local_irq_save(flags);
+	if (__this_cpu_read(context_tracking.state) == IN_USER) {
+		__this_cpu_write(context_tracking.state, IN_KERNEL);
+		rcu_user_exit();
+	}
+	local_irq_restore(flags);
+}
+
+void context_tracking_task_switch(struct task_struct *prev,
+			     struct task_struct *next)
+{
+	if (__this_cpu_read(context_tracking.active)) {
+		clear_tsk_thread_flag(prev, TIF_NOHZ);
+		set_tsk_thread_flag(next, TIF_NOHZ);
+	}
+}
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 4e316e1..8715a79 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -141,6 +141,23 @@ static ssize_t fscaps_show(struct kobject *kobj,
 }
 KERNEL_ATTR_RO(fscaps);
 
+int rcu_expedited;
+static ssize_t rcu_expedited_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", rcu_expedited);
+}
+static ssize_t rcu_expedited_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	if (kstrtoint(buf, 0, &rcu_expedited))
+		return -EINVAL;
+
+	return count;
+}
+KERNEL_ATTR_RW(rcu_expedited);
+
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
@@ -182,6 +199,7 @@ static struct attribute * kernel_attrs[] = {
 	&kexec_crash_size_attr.attr,
 	&vmcoreinfo_attr.attr,
 #endif
+	&rcu_expedited_attr.attr,
 	NULL
 };
 
diff --git a/kernel/rcu.h b/kernel/rcu.h
index 8ba99cd..20dfba5 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -109,4 +109,6 @@ static inline bool __rcu_reclaim(char *rn, struct rcu_head *head)
 	}
 }
 
+extern int rcu_expedited;
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 29ca1c6..a2cf761 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -46,12 +46,15 @@
 #include <linux/export.h>
 #include <linux/hardirq.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/rcu.h>
 
 #include "rcu.h"
 
+module_param(rcu_expedited, int, 0);
+
 #ifdef CONFIG_PREEMPT_RCU
 
 /*
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e4c6a59..e7dce58 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -195,7 +195,7 @@ EXPORT_SYMBOL(rcu_is_cpu_idle);
  */
 int rcu_is_cpu_rrupt_from_idle(void)
 {
-	return rcu_dynticks_nesting <= 0;
+	return rcu_dynticks_nesting <= 1;
 }
 
 /*
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 3d01902..f85016a 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -706,7 +706,10 @@ void synchronize_rcu(void)
 		return;
 
 	/* Once we get past the fastpath checks, same code as rcu_barrier(). */
-	rcu_barrier();
+	if (rcu_expedited)
+		synchronize_rcu_expedited();
+	else
+		rcu_barrier();
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index aaa7b9f..31dea01 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -339,7 +339,6 @@ rcu_stutter_wait(char *title)
 
 struct rcu_torture_ops {
 	void (*init)(void);
-	void (*cleanup)(void);
 	int (*readlock)(void);
 	void (*read_delay)(struct rcu_random_state *rrsp);
 	void (*readunlock)(int idx);
@@ -431,7 +430,6 @@ static void rcu_torture_deferred_free(struct rcu_torture *p)
 
 static struct rcu_torture_ops rcu_ops = {
 	.init		= NULL,
-	.cleanup	= NULL,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
 	.readunlock	= rcu_torture_read_unlock,
@@ -475,7 +473,6 @@ static void rcu_sync_torture_init(void)
 
 static struct rcu_torture_ops rcu_sync_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
 	.readunlock	= rcu_torture_read_unlock,
@@ -493,7 +490,6 @@ static struct rcu_torture_ops rcu_sync_ops = {
 
 static struct rcu_torture_ops rcu_expedited_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_torture_read_unlock,
@@ -536,7 +532,6 @@ static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
 
 static struct rcu_torture_ops rcu_bh_ops = {
 	.init		= NULL,
-	.cleanup	= NULL,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
@@ -553,7 +548,6 @@ static struct rcu_torture_ops rcu_bh_ops = {
 
 static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
@@ -570,7 +564,6 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 
 static struct rcu_torture_ops rcu_bh_expedited_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
@@ -589,19 +582,7 @@ static struct rcu_torture_ops rcu_bh_expedited_ops = {
  * Definitions for srcu torture testing.
  */
 
-static struct srcu_struct srcu_ctl;
-
-static void srcu_torture_init(void)
-{
-	init_srcu_struct(&srcu_ctl);
-	rcu_sync_torture_init();
-}
-
-static void srcu_torture_cleanup(void)
-{
-	synchronize_srcu(&srcu_ctl);
-	cleanup_srcu_struct(&srcu_ctl);
-}
+DEFINE_STATIC_SRCU(srcu_ctl);
 
 static int srcu_torture_read_lock(void) __acquires(&srcu_ctl)
 {
@@ -672,8 +653,7 @@ static int srcu_torture_stats(char *page)
 }
 
 static struct rcu_torture_ops srcu_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
@@ -687,8 +667,7 @@ static struct rcu_torture_ops srcu_ops = {
 };
 
 static struct rcu_torture_ops srcu_sync_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
@@ -712,8 +691,7 @@ static void srcu_torture_read_unlock_raw(int idx) __releases(&srcu_ctl)
 }
 
 static struct rcu_torture_ops srcu_raw_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock_raw,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock_raw,
@@ -727,8 +705,7 @@ static struct rcu_torture_ops srcu_raw_ops = {
 };
 
 static struct rcu_torture_ops srcu_raw_sync_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock_raw,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock_raw,
@@ -747,8 +724,7 @@ static void srcu_torture_synchronize_expedited(void)
 }
 
 static struct rcu_torture_ops srcu_expedited_ops = {
-	.init		= srcu_torture_init,
-	.cleanup	= srcu_torture_cleanup,
+	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
@@ -783,7 +759,6 @@ static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
 
 static struct rcu_torture_ops sched_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
@@ -799,7 +774,6 @@ static struct rcu_torture_ops sched_ops = {
 
 static struct rcu_torture_ops sched_sync_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
@@ -814,7 +788,6 @@ static struct rcu_torture_ops sched_sync_ops = {
 
 static struct rcu_torture_ops sched_expedited_ops = {
 	.init		= rcu_sync_torture_init,
-	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
@@ -1396,12 +1369,16 @@ rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 		 "fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
 		 "test_boost=%d/%d test_boost_interval=%d "
 		 "test_boost_duration=%d shutdown_secs=%d "
+		 "stall_cpu=%d stall_cpu_holdoff=%d "
+		 "n_barrier_cbs=%d "
 		 "onoff_interval=%d onoff_holdoff=%d\n",
 		 torture_type, tag, nrealreaders, nfakewriters,
 		 stat_interval, verbose, test_no_idle_hz, shuffle_interval,
 		 stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
 		 test_boost, cur_ops->can_boost,
 		 test_boost_interval, test_boost_duration, shutdown_secs,
+		 stall_cpu, stall_cpu_holdoff,
+		 n_barrier_cbs,
 		 onoff_interval, onoff_holdoff);
 }
 
@@ -1502,6 +1479,7 @@ rcu_torture_onoff(void *arg)
 	unsigned long delta;
 	int maxcpu = -1;
 	DEFINE_RCU_RANDOM(rand);
+	int ret;
 	unsigned long starttime;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_onoff task started");
@@ -1522,7 +1500,13 @@ rcu_torture_onoff(void *arg)
 					 torture_type, cpu);
 			starttime = jiffies;
 			n_offline_attempts++;
-			if (cpu_down(cpu) == 0) {
+			ret = cpu_down(cpu);
+			if (ret) {
+				if (verbose)
+					pr_alert("%s" TORTURE_FLAG
+						 "rcu_torture_onoff task: offline %d failed: errno %d\n",
+						 torture_type, cpu, ret);
+			} else {
 				if (verbose)
 					pr_alert("%s" TORTURE_FLAG
 						 "rcu_torture_onoff task: offlined %d\n",
@@ -1936,8 +1920,6 @@ rcu_torture_cleanup(void)
 
 	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
 
-	if (cur_ops->cleanup)
-		cur_ops->cleanup();
 	if (atomic_read(&n_rcu_torture_error) || n_rcu_torture_barrier_error)
 		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
 	else if (n_online_successes != n_online_attempts ||
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..e441b77 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -68,9 +68,9 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 	.level = { &sname##_state.node[0] }, \
 	.call = cr, \
 	.fqs_state = RCU_GP_IDLE, \
-	.gpnum = -300, \
-	.completed = -300, \
-	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.onofflock), \
+	.gpnum = 0UL - 300UL, \
+	.completed = 0UL - 300UL, \
+	.orphan_lock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.orphan_lock), \
 	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
 	.orphan_donetail = &sname##_state.orphan_donelist, \
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
@@ -207,18 +207,15 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
-#if defined(CONFIG_RCU_USER_QS) && !defined(CONFIG_RCU_USER_QS_FORCE)
-	.ignore_user_qs = true,
-#endif
 };
 
-static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
-static int qhimark = 10000;	/* If this many pending, ignore blimit. */
-static int qlowmark = 100;	/* Once only this many pending, use blimit. */
+static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
+static long qhimark = 10000;	/* If this many pending, ignore blimit. */
+static long qlowmark = 100;	/* Once only this many pending, use blimit. */
 
-module_param(blimit, int, 0444);
-module_param(qhimark, int, 0444);
-module_param(qlowmark, int, 0444);
+module_param(blimit, long, 0444);
+module_param(qhimark, long, 0444);
+module_param(qlowmark, long, 0444);
 
 int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
 int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
@@ -303,7 +300,8 @@ EXPORT_SYMBOL_GPL(rcu_sched_force_quiescent_state);
 static int
 cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 {
-	return &rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL];
+	return &rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL] &&
+	       rdp->nxttail[RCU_DONE_TAIL] != NULL;
 }
 
 /*
@@ -312,8 +310,11 @@ cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	return *rdp->nxttail[RCU_DONE_TAIL +
-			     ACCESS_ONCE(rsp->completed) != rdp->completed] &&
+	struct rcu_head **ntp;
+
+	ntp = rdp->nxttail[RCU_DONE_TAIL +
+			   (ACCESS_ONCE(rsp->completed) != rdp->completed)];
+	return rdp->nxttail[RCU_DONE_TAIL] && ntp && *ntp &&
 	       !rcu_gp_in_progress(rsp);
 }
 
@@ -416,29 +417,7 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
  */
 void rcu_user_enter(void)
 {
-	unsigned long flags;
-	struct rcu_dynticks *rdtp;
-
-	/*
-	 * Some contexts may involve an exception occuring in an irq,
-	 * leading to that nesting:
-	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
-	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
-	 * helpers are enough to protect RCU uses inside the exception. So
-	 * just return immediately if we detect we are in an IRQ.
-	 */
-	if (in_interrupt())
-		return;
-
-	WARN_ON_ONCE(!current->mm);
-
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (!rdtp->ignore_user_qs && !rdtp->in_user) {
-		rdtp->in_user = true;
-		rcu_eqs_enter(true);
-	}
-	local_irq_restore(flags);
+	rcu_eqs_enter(1);
 }
 
 /**
@@ -575,27 +554,7 @@ EXPORT_SYMBOL_GPL(rcu_idle_exit);
  */
 void rcu_user_exit(void)
 {
-	unsigned long flags;
-	struct rcu_dynticks *rdtp;
-
-	/*
-	 * Some contexts may involve an exception occuring in an irq,
-	 * leading to that nesting:
-	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
-	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
-	 * helpers are enough to protect RCU uses inside the exception. So
-	 * just return immediately if we detect we are in an IRQ.
-	 */
-	if (in_interrupt())
-		return;
-
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (rdtp->in_user) {
-		rdtp->in_user = false;
-		rcu_eqs_exit(true);
-	}
-	local_irq_restore(flags);
+	rcu_eqs_exit(1);
 }
 
 /**
@@ -718,21 +677,6 @@ int rcu_is_cpu_idle(void)
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 
-#ifdef CONFIG_RCU_USER_QS
-void rcu_user_hooks_switch(struct task_struct *prev,
-			   struct task_struct *next)
-{
-	struct rcu_dynticks *rdtp;
-
-	/* Interrupts are disabled in context switch */
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (!rdtp->ignore_user_qs) {
-		clear_tsk_thread_flag(prev, TIF_NOHZ);
-		set_tsk_thread_flag(next, TIF_NOHZ);
-	}
-}
-#endif /* #ifdef CONFIG_RCU_USER_QS */
-
 #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
 
 /*
@@ -873,6 +817,29 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
 }
 
+/*
+ * Dump stacks of all tasks running on stalled CPUs.  This is a fallback
+ * for architectures that do not implement trigger_all_cpu_backtrace().
+ * The NMI-triggered stack traces are more accurate because they are
+ * printed by the target CPU.
+ */
+static void rcu_dump_cpu_stacks(struct rcu_state *rsp)
+{
+	int cpu;
+	unsigned long flags;
+	struct rcu_node *rnp;
+
+	rcu_for_each_leaf_node(rsp, rnp) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		if (rnp->qsmask != 0) {
+			for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
+				if (rnp->qsmask & (1UL << cpu))
+					dump_cpu_task(rnp->grplo + cpu);
+		}
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+}
+
 static void print_other_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;
@@ -880,6 +847,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	unsigned long flags;
 	int ndetected = 0;
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	long totqlen = 0;
 
 	/* Only let one CPU complain about others per time interval. */
 
@@ -924,12 +892,15 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	print_cpu_stall_info_end();
-	printk(KERN_CONT "(detected by %d, t=%ld jiffies)\n",
-	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
+	for_each_possible_cpu(cpu)
+		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
+	pr_cont("(detected by %d, t=%ld jiffies, g=%lu, c=%lu, q=%lu)\n",
+	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
+	       rsp->gpnum, rsp->completed, totqlen);
 	if (ndetected == 0)
 		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
 	else if (!trigger_all_cpu_backtrace())
-		dump_stack();
+		rcu_dump_cpu_stacks(rsp);
 
 	/* Complain about tasks blocking the grace period. */
 
@@ -940,8 +911,10 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 static void print_cpu_stall(struct rcu_state *rsp)
 {
+	int cpu;
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	long totqlen = 0;
 
 	/*
 	 * OK, time to rat on ourselves...
@@ -952,7 +925,10 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	print_cpu_stall_info_begin();
 	print_cpu_stall_info(rsp, smp_processor_id());
 	print_cpu_stall_info_end();
-	printk(KERN_CONT " (t=%lu jiffies)\n", jiffies - rsp->gp_start);
+	for_each_possible_cpu(cpu)
+		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
+	pr_cont(" (t=%lu jiffies g=%lu c=%lu q=%lu)\n",
+		jiffies - rsp->gp_start, rsp->gpnum, rsp->completed, totqlen);
 	if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
@@ -1091,6 +1067,7 @@ static void init_callback_list(struct rcu_data *rdp)
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
+	init_nocb_callback_list(rdp);
 }
 
 /*
@@ -1404,15 +1381,37 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	    !cpu_needs_another_gp(rsp, rdp)) {
 		/*
 		 * Either we have not yet spawned the grace-period
-		 * task or this CPU does not need another grace period.
+		 * task, this CPU does not need another grace period,
+		 * or a grace period is already in progress.
 		 * Either way, don't start a new grace period.
 		 */
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 
+	/*
+	 * Because there is no grace period in progress right now,
+	 * any callbacks we have up to this point will be satisfied
+	 * by the next grace period.  So promote all callbacks to be
+	 * handled after the end of the next grace period.  If the
+	 * CPU is not yet aware of the end of the previous grace period,
+	 * we need to allow for the callback advancement that will
+	 * occur when it does become aware.  Deadlock prevents us from
+	 * making it aware at this point: We cannot acquire a leaf
+	 * rcu_node ->lock while holding the root rcu_node ->lock.
+	 */
+	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	if (rdp->completed == rsp->completed)
+		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock(&rnp->lock); /* Interrupts remain disabled. */
+
+	/* Ensure that CPU is aware of completion of last grace period. */
+	rcu_process_gp_end(rsp, rdp);
+	local_irq_restore(flags);
+
+	/* Wake up rcu_gp_kthread() to start the grace period. */
 	wake_up(&rsp->gp_wq);
 }
 
@@ -1573,16 +1572,20 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 /*
  * Send the specified CPU's RCU callbacks to the orphanage.  The
  * specified CPU must be offline, and the caller must hold the
- * ->onofflock.
+ * ->orphan_lock.
  */
 static void
 rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 			  struct rcu_node *rnp, struct rcu_data *rdp)
 {
+	/* No-CBs CPUs do not have orphanable callbacks. */
+	if (is_nocb_cpu(rdp->cpu))
+		return;
+
 	/*
 	 * Orphan the callbacks.  First adjust the counts.  This is safe
-	 * because ->onofflock excludes _rcu_barrier()'s adoption of
-	 * the callbacks, thus no memory barrier is required.
+	 * because _rcu_barrier() excludes CPU-hotplug operations, so it
+	 * cannot be running now.  Thus no memory barrier is required.
 	 */
 	if (rdp->nxtlist != NULL) {
 		rsp->qlen_lazy += rdp->qlen_lazy;
@@ -1623,13 +1626,17 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 
 /*
  * Adopt the RCU callbacks from the specified rcu_state structure's
- * orphanage.  The caller must hold the ->onofflock.
+ * orphanage.  The caller must hold the ->orphan_lock.
  */
 static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 {
 	int i;
 	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
 
+	/* No-CBs CPUs are handled specially. */
+	if (rcu_nocb_adopt_orphan_cbs(rsp, rdp))
+		return;
+
 	/* Do the accounting first. */
 	rdp->qlen_lazy += rsp->qlen_lazy;
 	rdp->qlen += rsp->qlen;
@@ -1702,7 +1709,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 
 	/* Exclude any attempts to start a new grace period. */
 	mutex_lock(&rsp->onoff_mutex);
-	raw_spin_lock_irqsave(&rsp->onofflock, flags);
+	raw_spin_lock_irqsave(&rsp->orphan_lock, flags);
 
 	/* Orphan the dead CPU's callbacks, and adopt them if appropriate. */
 	rcu_send_cbs_to_orphanage(cpu, rsp, rnp, rdp);
@@ -1729,10 +1736,10 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	/*
 	 * We still hold the leaf rcu_node structure lock here, and
 	 * irqs are still disabled.  The reason for this subterfuge is
-	 * because invoking rcu_report_unblock_qs_rnp() with ->onofflock
+	 * because invoking rcu_report_unblock_qs_rnp() with ->orphan_lock
 	 * held leads to deadlock.
 	 */
-	raw_spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
+	raw_spin_unlock(&rsp->orphan_lock); /* irqs remain disabled. */
 	rnp = rdp->mynode;
 	if (need_report & RCU_OFL_TASKS_NORM_GP)
 		rcu_report_unblock_qs_rnp(rnp, flags);
@@ -1769,7 +1776,8 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int bl, count, count_lazy, i;
+	long bl, count, count_lazy;
+	int i;
 
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
@@ -2107,9 +2115,15 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 	}
 }
 
+/*
+ * Helper function for call_rcu() and friends.  The cpu argument will
+ * normally be -1, indicating "currently running CPU".  It may specify
+ * a CPU only if that CPU is a no-CBs CPU.  Currently, only _rcu_barrier()
+ * is expected to specify a CPU.
+ */
 static void
 __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
-	   struct rcu_state *rsp, bool lazy)
+	   struct rcu_state *rsp, int cpu, bool lazy)
 {
 	unsigned long flags;
 	struct rcu_data *rdp;
@@ -2129,9 +2143,14 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp = this_cpu_ptr(rsp->rda);
 
 	/* Add the callback to our list. */
-	if (unlikely(rdp->nxttail[RCU_NEXT_TAIL] == NULL)) {
+	if (unlikely(rdp->nxttail[RCU_NEXT_TAIL] == NULL) || cpu != -1) {
+		int offline;
+
+		if (cpu != -1)
+			rdp = per_cpu_ptr(rsp->rda, cpu);
+		offline = !__call_rcu_nocb(rdp, head, lazy);
+		WARN_ON_ONCE(offline);
 		/* _call_rcu() is illegal on offline CPU; leak the callback. */
-		WARN_ON_ONCE(1);
 		local_irq_restore(flags);
 		return;
 	}
@@ -2160,7 +2179,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
  */
 void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_sched_state, 0);
+	__call_rcu(head, func, &rcu_sched_state, -1, 0);
 }
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
@@ -2169,7 +2188,7 @@ EXPORT_SYMBOL_GPL(call_rcu_sched);
  */
 void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_bh_state, 0);
+	__call_rcu(head, func, &rcu_bh_state, -1, 0);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
@@ -2205,10 +2224,28 @@ static inline int rcu_blocking_is_gp(void)
  * rcu_read_lock_sched().
  *
  * This means that all preempt_disable code sequences, including NMI and
- * hardware-interrupt handlers, in progress on entry will have completed
- * before this primitive returns.  However, this does not guarantee that
- * softirq handlers will have completed, since in some kernels, these
- * handlers can run in process context, and can block.
+ * non-threaded hardware-interrupt handlers, in progress on entry will
+ * have completed before this primitive returns.  However, this does not
+ * guarantee that softirq handlers will have completed, since in some
+ * kernels, these handlers can run in process context, and can block.
+ *
+ * Note that this guarantee implies further memory-ordering guarantees.
+ * On systems with more than one CPU, when synchronize_sched() returns,
+ * each CPU is guaranteed to have executed a full memory barrier since the
+ * end of its last RCU-sched read-side critical section whose beginning
+ * preceded the call to synchronize_sched().  In addition, each CPU having
+ * an RCU read-side critical section that extends beyond the return from
+ * synchronize_sched() is guaranteed to have executed a full memory barrier
+ * after the beginning of synchronize_sched() and before the beginning of
+ * that RCU read-side critical section.  Note that these guarantees include
+ * CPUs that are offline, idle, or executing in user mode, as well as CPUs
+ * that are executing in the kernel.
+ *
+ * Furthermore, if CPU A invoked synchronize_sched(), which returned
+ * to its caller on CPU B, then both CPU A and CPU B are guaranteed
+ * to have executed a full memory barrier during the execution of
+ * synchronize_sched() -- even if CPU A and CPU B are the same CPU (but
+ * again only if the system has more than one CPU).
  *
  * This primitive provides the guarantees made by the (now removed)
  * synchronize_kernel() API.  In contrast, synchronize_rcu() only
@@ -2224,7 +2261,10 @@ void synchronize_sched(void)
 			   "Illegal synchronize_sched() in RCU-sched read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
-	wait_rcu_gp(call_rcu_sched);
+	if (rcu_expedited)
+		synchronize_sched_expedited();
+	else
+		wait_rcu_gp(call_rcu_sched);
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
@@ -2236,6 +2276,9 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
  * read-side critical sections have completed.  RCU read-side critical
  * sections are delimited by rcu_read_lock_bh() and rcu_read_unlock_bh(),
  * and may be nested.
+ *
+ * See the description of synchronize_sched() for more detailed information
+ * on memory ordering guarantees.
  */
 void synchronize_rcu_bh(void)
 {
@@ -2245,13 +2288,13 @@ void synchronize_rcu_bh(void)
 			   "Illegal synchronize_rcu_bh() in RCU-bh read-side critical section");
 	if (rcu_blocking_is_gp())
 		return;
-	wait_rcu_gp(call_rcu_bh);
+	if (rcu_expedited)
+		synchronize_rcu_bh_expedited();
+	else
+		wait_rcu_gp(call_rcu_bh);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
-static atomic_t sync_sched_expedited_started = ATOMIC_INIT(0);
-static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
-
 static int synchronize_sched_expedited_cpu_stop(void *data)
 {
 	/*
@@ -2308,10 +2351,32 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
  */
 void synchronize_sched_expedited(void)
 {
-	int firstsnap, s, snap, trycount = 0;
+	long firstsnap, s, snap;
+	int trycount = 0;
+	struct rcu_state *rsp = &rcu_sched_state;
+
+	/*
+	 * If we are in danger of counter wrap, just do synchronize_sched().
+	 * By allowing sync_sched_expedited_started to advance no more than
+	 * ULONG_MAX/8 ahead of sync_sched_expedited_done, we are ensuring
+	 * that more than 3.5 billion CPUs would be required to force a
+	 * counter wrap on a 32-bit system.  Quite a few more CPUs would of
+	 * course be required on a 64-bit system.
+	 */
+	if (ULONG_CMP_GE((ulong)atomic_long_read(&rsp->expedited_start),
+			 (ulong)atomic_long_read(&rsp->expedited_done) +
+			 ULONG_MAX / 8)) {
+		synchronize_sched();
+		atomic_long_inc(&rsp->expedited_wrap);
+		return;
+	}
 
-	/* Note that atomic_inc_return() implies full memory barrier. */
-	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
+	/*
+	 * Take a ticket.  Note that atomic_inc_return() implies a
+	 * full memory barrier.
+	 */
+	snap = atomic_long_inc_return(&rsp->expedited_start);
+	firstsnap = snap;
 	get_online_cpus();
 	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
 
@@ -2323,48 +2388,65 @@ void synchronize_sched_expedited(void)
 			     synchronize_sched_expedited_cpu_stop,
 			     NULL) == -EAGAIN) {
 		put_online_cpus();
+		atomic_long_inc(&rsp->expedited_tryfail);
+
+		/* Check to see if someone else did our work for us. */
+		s = atomic_long_read(&rsp->expedited_done);
+		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
+			/* ensure test happens before caller kfree */
+			smp_mb__before_atomic_inc(); /* ^^^ */
+			atomic_long_inc(&rsp->expedited_workdone1);
+			return;
+		}
 
 		/* No joy, try again later.  Or just synchronize_sched(). */
 		if (trycount++ < 10) {
 			udelay(trycount * num_online_cpus());
 		} else {
-			synchronize_sched();
+			wait_rcu_gp(call_rcu_sched);
+			atomic_long_inc(&rsp->expedited_normal);
 			return;
 		}
 
-		/* Check to see if someone else did our work for us. */
-		s = atomic_read(&sync_sched_expedited_done);
-		if (UINT_CMP_GE((unsigned)s, (unsigned)firstsnap)) {
-			smp_mb(); /* ensure test happens before caller kfree */
+		/* Recheck to see if someone else did our work for us. */
+		s = atomic_long_read(&rsp->expedited_done);
+		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
+			/* ensure test happens before caller kfree */
+			smp_mb__before_atomic_inc(); /* ^^^ */
+			atomic_long_inc(&rsp->expedited_workdone2);
 			return;
 		}
 
 		/*
 		 * Refetching sync_sched_expedited_started allows later
-		 * callers to piggyback on our grace period.  We subtract
-		 * 1 to get the same token that the last incrementer got.
-		 * We retry after they started, so our grace period works
-		 * for them, and they started after our first try, so their
-		 * grace period works for us.
+		 * callers to piggyback on our grace period.  We retry
+		 * after they started, so our grace period works for them,
+		 * and they started after our first try, so their grace
+		 * period works for us.
 		 */
 		get_online_cpus();
-		snap = atomic_read(&sync_sched_expedited_started);
+		snap = atomic_long_read(&rsp->expedited_start);
 		smp_mb(); /* ensure read is before try_stop_cpus(). */
 	}
+	atomic_long_inc(&rsp->expedited_stoppedcpus);
 
 	/*
 	 * Everyone up to our most recent fetch is covered by our grace
 	 * period.  Update the counter, but only if our work is still
 	 * relevant -- which it won't be if someone who started later
-	 * than we did beat us to the punch.
+	 * than we did already did their update.
 	 */
 	do {
-		s = atomic_read(&sync_sched_expedited_done);
-		if (UINT_CMP_GE((unsigned)s, (unsigned)snap)) {
-			smp_mb(); /* ensure test happens before caller kfree */
+		atomic_long_inc(&rsp->expedited_done_tries);
+		s = atomic_long_read(&rsp->expedited_done);
+		if (ULONG_CMP_GE((ulong)s, (ulong)snap)) {
+			/* ensure test happens before caller kfree */
+			smp_mb__before_atomic_inc(); /* ^^^ */
+			atomic_long_inc(&rsp->expedited_done_lost);
 			break;
 		}
-	} while (atomic_cmpxchg(&sync_sched_expedited_done, s, snap) != s);
+	} while (atomic_long_cmpxchg(&rsp->expedited_done, s, snap) != s);
+	atomic_long_inc(&rsp->expedited_done_exit);
 
 	put_online_cpus();
 }
@@ -2558,9 +2640,17 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * When that callback is invoked, we will know that all of the
 	 * corresponding CPU's preceding callbacks have been invoked.
 	 */
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
+		if (!cpu_online(cpu) && !is_nocb_cpu(cpu))
+			continue;
 		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (ACCESS_ONCE(rdp->qlen)) {
+		if (is_nocb_cpu(cpu)) {
+			_rcu_barrier_trace(rsp, "OnlineNoCB", cpu,
+					   rsp->n_barrier_done);
+			atomic_inc(&rsp->barrier_cpu_count);
+			__call_rcu(&rdp->barrier_head, rcu_barrier_callback,
+				   rsp, cpu, 0);
+		} else if (ACCESS_ONCE(rdp->qlen)) {
 			_rcu_barrier_trace(rsp, "OnlineQ", cpu,
 					   rsp->n_barrier_done);
 			smp_call_function_single(cpu, rcu_barrier_func, rsp, 1);
@@ -2634,6 +2724,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 #endif
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
+	rcu_boot_init_nocb_percpu_data(rdp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
@@ -2715,6 +2806,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 	struct rcu_state *rsp;
+	int ret = NOTIFY_OK;
 
 	trace_rcu_utilization("Start CPU hotplug");
 	switch (action) {
@@ -2728,7 +2820,10 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		rcu_boost_kthread_setaffinity(rnp, -1);
 		break;
 	case CPU_DOWN_PREPARE:
-		rcu_boost_kthread_setaffinity(rnp, cpu);
+		if (nocb_cpu_expendable(cpu))
+			rcu_boost_kthread_setaffinity(rnp, cpu);
+		else
+			ret = NOTIFY_BAD;
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
@@ -2752,7 +2847,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		break;
 	}
 	trace_rcu_utilization("End CPU hotplug");
-	return NOTIFY_OK;
+	return ret;
 }
 
 /*
@@ -2772,6 +2867,7 @@ static int __init rcu_spawn_gp_kthread(void)
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rsp->gp_kthread = t;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		rcu_spawn_nocb_kthreads(rsp);
 	}
 	return 0;
 }
@@ -2967,6 +3063,7 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
+	rcu_init_nocb();
 	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index a240f03..4b69291 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -287,6 +287,7 @@ struct rcu_data {
 	long		qlen_last_fqs_check;
 					/* qlen at last check for QS forcing */
 	unsigned long	n_cbs_invoked;	/* count of RCU cbs invoked. */
+	unsigned long	n_nocbs_invoked; /* count of no-CBs RCU cbs invoked. */
 	unsigned long   n_cbs_orphaned; /* RCU cbs orphaned by dying CPU */
 	unsigned long   n_cbs_adopted;  /* RCU cbs adopted from dying CPU */
 	unsigned long	n_force_qs_snap;
@@ -317,6 +318,18 @@ struct rcu_data {
 	struct rcu_head oom_head;
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
 
+	/* 7) Callback offloading. */
+#ifdef CONFIG_RCU_NOCB_CPU
+	struct rcu_head *nocb_head;	/* CBs waiting for kthread. */
+	struct rcu_head **nocb_tail;
+	atomic_long_t nocb_q_count;	/* # CBs waiting for kthread */
+	atomic_long_t nocb_q_count_lazy; /*  (approximate). */
+	int nocb_p_count;		/* # CBs being invoked by kthread */
+	int nocb_p_count_lazy;		/*  (approximate). */
+	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
+	struct task_struct *nocb_kthread;
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
+
 	int cpu;
 	struct rcu_state *rsp;
 };
@@ -369,6 +382,12 @@ struct rcu_state {
 	struct rcu_data __percpu *rda;		/* pointer of percu rcu_data. */
 	void (*call)(struct rcu_head *head,	/* call_rcu() flavor. */
 		     void (*func)(struct rcu_head *head));
+#ifdef CONFIG_RCU_NOCB_CPU
+	void (*call_remote)(struct rcu_head *head,
+		     void (*func)(struct rcu_head *head));
+						/* call_rcu() flavor, but for */
+						/*  placing on remote CPU. */
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 	/* The following fields are guarded by the root rcu_node's lock. */
 
@@ -383,9 +402,8 @@ struct rcu_state {
 
 	/* End of fields guarded by root rcu_node's lock. */
 
-	raw_spinlock_t onofflock ____cacheline_internodealigned_in_smp;
-						/* exclude on/offline and */
-						/*  starting new GP. */
+	raw_spinlock_t orphan_lock ____cacheline_internodealigned_in_smp;
+						/* Protect following fields. */
 	struct rcu_head *orphan_nxtlist;	/* Orphaned callbacks that */
 						/*  need a grace period. */
 	struct rcu_head **orphan_nxttail;	/* Tail of above. */
@@ -394,7 +412,7 @@ struct rcu_state {
 	struct rcu_head **orphan_donetail;	/* Tail of above. */
 	long qlen_lazy;				/* Number of lazy callbacks. */
 	long qlen;				/* Total number of callbacks. */
-	/* End of fields guarded by onofflock. */
+	/* End of fields guarded by orphan_lock. */
 
 	struct mutex onoff_mutex;		/* Coordinate hotplug & GPs. */
 
@@ -405,6 +423,18 @@ struct rcu_state {
 						/*  _rcu_barrier(). */
 	/* End of fields guarded by barrier_mutex. */
 
+	atomic_long_t expedited_start;		/* Starting ticket. */
+	atomic_long_t expedited_done;		/* Done ticket. */
+	atomic_long_t expedited_wrap;		/* # near-wrap incidents. */
+	atomic_long_t expedited_tryfail;	/* # acquisition failures. */
+	atomic_long_t expedited_workdone1;	/* # done by others #1. */
+	atomic_long_t expedited_workdone2;	/* # done by others #2. */
+	atomic_long_t expedited_normal;		/* # fallbacks to normal. */
+	atomic_long_t expedited_stoppedcpus;	/* # successful stop_cpus. */
+	atomic_long_t expedited_done_tries;	/* # tries to update _done. */
+	atomic_long_t expedited_done_lost;	/* # times beaten to _done. */
+	atomic_long_t expedited_done_exit;	/* # times exited _done loop. */
+
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
@@ -428,6 +458,8 @@ struct rcu_state {
 #define RCU_GP_FLAG_FQS  0x2	/* Need grace-period quiescent-state forcing. */
 
 extern struct list_head rcu_struct_flavors;
+
+/* Sequence through rcu_state structures for each RCU flavor. */
 #define for_each_rcu_flavor(rsp) \
 	list_for_each_entry((rsp), &rcu_struct_flavors, flavors)
 
@@ -504,5 +536,32 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
 static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
+static bool is_nocb_cpu(int cpu);
+static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
+			    bool lazy);
+static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
+				      struct rcu_data *rdp);
+static bool nocb_cpu_expendable(int cpu);
+static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
+static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
+static void init_nocb_callback_list(struct rcu_data *rdp);
+static void __init rcu_init_nocb(void);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
+
+#ifdef CONFIG_RCU_TRACE
+#ifdef CONFIG_RCU_NOCB_CPU
+/* Sum up queue lengths for tracing. */
+static inline void rcu_nocb_q_lengths(struct rcu_data *rdp, long *ql, long *qll)
+{
+	*ql = atomic_long_read(&rdp->nocb_q_count) + rdp->nocb_p_count;
+	*qll = atomic_long_read(&rdp->nocb_q_count_lazy) + rdp->nocb_p_count_lazy;
+}
+#else /* #ifdef CONFIG_RCU_NOCB_CPU */
+static inline void rcu_nocb_q_lengths(struct rcu_data *rdp, long *ql, long *qll)
+{
+	*ql = 0;
+	*qll = 0;
+}
+#endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
+#endif /* #ifdef CONFIG_RCU_TRACE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f921154..f6e5ec2 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -25,6 +25,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/gfp.h>
 #include <linux/oom.h>
 #include <linux/smpboot.h>
 
@@ -36,6 +37,14 @@
 #define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
 #endif
 
+#ifdef CONFIG_RCU_NOCB_CPU
+static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
+static bool have_rcu_nocb_mask;	    /* Was rcu_nocb_mask allocated? */
+static bool rcu_nocb_poll;	    /* Offload kthread are to poll. */
+module_param(rcu_nocb_poll, bool, 0444);
+static char __initdata nocb_buf[NR_CPUS * 5];
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
+
 /*
  * Check the RCU kernel configuration parameters and print informative
  * messages about anything out of the ordinary.  If you like #ifdef, you
@@ -76,6 +85,18 @@ static void __init rcu_bootup_announce_oddness(void)
 		printk(KERN_INFO "\tExperimental boot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
 	if (nr_cpu_ids != NR_CPUS)
 		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
+#ifdef CONFIG_RCU_NOCB_CPU
+	if (have_rcu_nocb_mask) {
+		if (cpumask_test_cpu(0, rcu_nocb_mask)) {
+			cpumask_clear_cpu(0, rcu_nocb_mask);
+			pr_info("\tCPU 0: illegal no-CBs CPU (cleared).\n");
+		}
+		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
+		pr_info("\tExperimental no-CBs CPUs: %s.\n", nocb_buf);
+		if (rcu_nocb_poll)
+			pr_info("\tExperimental polled no-CBs CPUs.\n");
+	}
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 }
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
@@ -642,7 +663,7 @@ static void rcu_preempt_do_callbacks(void)
  */
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_preempt_state, 0);
+	__call_rcu(head, func, &rcu_preempt_state, -1, 0);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
@@ -656,7 +677,7 @@ EXPORT_SYMBOL_GPL(call_rcu);
 void kfree_call_rcu(struct rcu_head *head,
 		    void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_preempt_state, 1);
+	__call_rcu(head, func, &rcu_preempt_state, -1, 1);
 }
 EXPORT_SYMBOL_GPL(kfree_call_rcu);
 
@@ -670,6 +691,9 @@ EXPORT_SYMBOL_GPL(kfree_call_rcu);
  * concurrently with new RCU read-side critical sections that began while
  * synchronize_rcu() was waiting.  RCU read-side critical sections are
  * delimited by rcu_read_lock() and rcu_read_unlock(), and may be nested.
+ *
+ * See the description of synchronize_sched() for more detailed information
+ * on memory ordering guarantees.
  */
 void synchronize_rcu(void)
 {
@@ -679,7 +703,10 @@ void synchronize_rcu(void)
 			   "Illegal synchronize_rcu() in RCU read-side critical section");
 	if (!rcu_scheduler_active)
 		return;
-	wait_rcu_gp(call_rcu);
+	if (rcu_expedited)
+		synchronize_rcu_expedited();
+	else
+		wait_rcu_gp(call_rcu);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
@@ -757,7 +784,8 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
  * grace period for the specified rcu_node structure.  If there are no such
  * tasks, report it up the rcu_node hierarchy.
  *
- * Caller must hold sync_rcu_preempt_exp_mutex and rsp->onofflock.
+ * Caller must hold sync_rcu_preempt_exp_mutex and must exclude
+ * CPU hotplug operations.
  */
 static void
 sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
@@ -831,7 +859,7 @@ void synchronize_rcu_expedited(void)
 			udelay(trycount * num_online_cpus());
 		} else {
 			put_online_cpus();
-			synchronize_rcu();
+			wait_rcu_gp(call_rcu);
 			return;
 		}
 	}
@@ -875,6 +903,11 @@ EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
 /**
  * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
+ *
+ * Note that this primitive does not necessarily wait for an RCU grace period
+ * to complete.  For example, if there are no RCU callbacks queued anywhere
+ * in the system, then rcu_barrier() is within its rights to return
+ * immediately, without waiting for anything, much less an RCU grace period.
  */
 void rcu_barrier(void)
 {
@@ -1013,7 +1046,7 @@ static void rcu_preempt_check_callbacks(int cpu)
 void kfree_call_rcu(struct rcu_head *head,
 		    void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_sched_state, 1);
+	__call_rcu(head, func, &rcu_sched_state, -1, 1);
 }
 EXPORT_SYMBOL_GPL(kfree_call_rcu);
 
@@ -2092,3 +2125,373 @@ static void increment_cpu_stall_ticks(void)
 }
 
 #endif /* #else #ifdef CONFIG_RCU_CPU_STALL_INFO */
+
+#ifdef CONFIG_RCU_NOCB_CPU
+
+/*
+ * Offload callback processing from the boot-time-specified set of CPUs
+ * specified by rcu_nocb_mask.  For each CPU in the set, there is a
+ * kthread created that pulls the callbacks from the corresponding CPU,
+ * waits for a grace period to elapse, and invokes the callbacks.
+ * The no-CBs CPUs do a wake_up() on their kthread when they insert
+ * a callback into any empty list, unless the rcu_nocb_poll boot parameter
+ * has been specified, in which case each kthread actively polls its
+ * CPU.  (Which isn't so great for energy efficiency, but which does
+ * reduce RCU's overhead on that CPU.)
+ *
+ * This is intended to be used in conjunction with Frederic Weisbecker's
+ * adaptive-idle work, which would seriously reduce OS jitter on CPUs
+ * running CPU-bound user-mode computations.
+ *
+ * Offloading of callback processing could also in theory be used as
+ * an energy-efficiency measure because CPUs with no RCU callbacks
+ * queued are more aggressive about entering dyntick-idle mode.
+ */
+
+
+/* Parse the boot-time rcu_nocb_mask CPU list from the kernel parameters. */
+static int __init rcu_nocb_setup(char *str)
+{
+	alloc_bootmem_cpumask_var(&rcu_nocb_mask);
+	have_rcu_nocb_mask = true;
+	cpulist_parse(str, rcu_nocb_mask);
+	return 1;
+}
+__setup("rcu_nocbs=", rcu_nocb_setup);
+
+/* Is the specified CPU a no-CPUs CPU? */
+static bool is_nocb_cpu(int cpu)
+{
+	if (have_rcu_nocb_mask)
+		return cpumask_test_cpu(cpu, rcu_nocb_mask);
+	return false;
+}
+
+/*
+ * Enqueue the specified string of rcu_head structures onto the specified
+ * CPU's no-CBs lists.  The CPU is specified by rdp, the head of the
+ * string by rhp, and the tail of the string by rhtp.  The non-lazy/lazy
+ * counts are supplied by rhcount and rhcount_lazy.
+ *
+ * If warranted, also wake up the kthread servicing this CPUs queues.
+ */
+static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
+				    struct rcu_head *rhp,
+				    struct rcu_head **rhtp,
+				    int rhcount, int rhcount_lazy)
+{
+	int len;
+	struct rcu_head **old_rhpp;
+	struct task_struct *t;
+
+	/* Enqueue the callback on the nocb list and update counts. */
+	old_rhpp = xchg(&rdp->nocb_tail, rhtp);
+	ACCESS_ONCE(*old_rhpp) = rhp;
+	atomic_long_add(rhcount, &rdp->nocb_q_count);
+	atomic_long_add(rhcount_lazy, &rdp->nocb_q_count_lazy);
+
+	/* If we are not being polled and there is a kthread, awaken it ... */
+	t = ACCESS_ONCE(rdp->nocb_kthread);
+	if (rcu_nocb_poll | !t)
+		return;
+	len = atomic_long_read(&rdp->nocb_q_count);
+	if (old_rhpp == &rdp->nocb_head) {
+		wake_up(&rdp->nocb_wq); /* ... only if queue was empty ... */
+		rdp->qlen_last_fqs_check = 0;
+	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
+		wake_up_process(t); /* ... or if many callbacks queued. */
+		rdp->qlen_last_fqs_check = LONG_MAX / 2;
+	}
+	return;
+}
+
+/*
+ * This is a helper for __call_rcu(), which invokes this when the normal
+ * callback queue is inoperable.  If this is not a no-CBs CPU, this
+ * function returns failure back to __call_rcu(), which can complain
+ * appropriately.
+ *
+ * Otherwise, this function queues the callback where the corresponding
+ * "rcuo" kthread can find it.
+ */
+static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
+			    bool lazy)
+{
+
+	if (!is_nocb_cpu(rdp->cpu))
+		return 0;
+	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy);
+	return 1;
+}
+
+/*
+ * Adopt orphaned callbacks on a no-CBs CPU, or return 0 if this is
+ * not a no-CBs CPU.
+ */
+static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
+						     struct rcu_data *rdp)
+{
+	long ql = rsp->qlen;
+	long qll = rsp->qlen_lazy;
+
+	/* If this is not a no-CBs CPU, tell the caller to do it the old way. */
+	if (!is_nocb_cpu(smp_processor_id()))
+		return 0;
+	rsp->qlen = 0;
+	rsp->qlen_lazy = 0;
+
+	/* First, enqueue the donelist, if any.  This preserves CB ordering. */
+	if (rsp->orphan_donelist != NULL) {
+		__call_rcu_nocb_enqueue(rdp, rsp->orphan_donelist,
+					rsp->orphan_donetail, ql, qll);
+		ql = qll = 0;
+		rsp->orphan_donelist = NULL;
+		rsp->orphan_donetail = &rsp->orphan_donelist;
+	}
+	if (rsp->orphan_nxtlist != NULL) {
+		__call_rcu_nocb_enqueue(rdp, rsp->orphan_nxtlist,
+					rsp->orphan_nxttail, ql, qll);
+		ql = qll = 0;
+		rsp->orphan_nxtlist = NULL;
+		rsp->orphan_nxttail = &rsp->orphan_nxtlist;
+	}
+	return 1;
+}
+
+/*
+ * There must be at least one non-no-CBs CPU in operation at any given
+ * time, because no-CBs CPUs are not capable of initiating grace periods
+ * independently.  This function therefore complains if the specified
+ * CPU is the last non-no-CBs CPU, allowing the CPU-hotplug system to
+ * avoid offlining the last such CPU.  (Recursion is a wonderful thing,
+ * but you have to have a base case!)
+ */
+static bool nocb_cpu_expendable(int cpu)
+{
+	cpumask_var_t non_nocb_cpus;
+	int ret;
+
+	/*
+	 * If there are no no-CB CPUs or if this CPU is not a no-CB CPU,
+	 * then offlining this CPU is harmless.  Let it happen.
+	 */
+	if (!have_rcu_nocb_mask || is_nocb_cpu(cpu))
+		return 1;
+
+	/* If no memory, play it safe and keep the CPU around. */
+	if (!alloc_cpumask_var(&non_nocb_cpus, GFP_NOIO))
+		return 0;
+	cpumask_andnot(non_nocb_cpus, cpu_online_mask, rcu_nocb_mask);
+	cpumask_clear_cpu(cpu, non_nocb_cpus);
+	ret = !cpumask_empty(non_nocb_cpus);
+	free_cpumask_var(non_nocb_cpus);
+	return ret;
+}
+
+/*
+ * Helper structure for remote registry of RCU callbacks.
+ * This is needed for when a no-CBs CPU needs to start a grace period.
+ * If it just invokes call_rcu(), the resulting callback will be queued,
+ * which can result in deadlock.
+ */
+struct rcu_head_remote {
+	struct rcu_head *rhp;
+	call_rcu_func_t *crf;
+	void (*func)(struct rcu_head *rhp);
+};
+
+/*
+ * Register a callback as specified by the rcu_head_remote struct.
+ * This function is intended to be invoked via smp_call_function_single().
+ */
+static void call_rcu_local(void *arg)
+{
+	struct rcu_head_remote *rhrp =
+		container_of(arg, struct rcu_head_remote, rhp);
+
+	rhrp->crf(rhrp->rhp, rhrp->func);
+}
+
+/*
+ * Set up an rcu_head_remote structure and the invoke call_rcu_local()
+ * on CPU 0 (which is guaranteed to be a non-no-CBs CPU) via
+ * smp_call_function_single().
+ */
+static void invoke_crf_remote(struct rcu_head *rhp,
+			      void (*func)(struct rcu_head *rhp),
+			      call_rcu_func_t crf)
+{
+	struct rcu_head_remote rhr;
+
+	rhr.rhp = rhp;
+	rhr.crf = crf;
+	rhr.func = func;
+	smp_call_function_single(0, call_rcu_local, &rhr, 1);
+}
+
+/*
+ * Helper functions to be passed to wait_rcu_gp(), each of which
+ * invokes invoke_crf_remote() to register a callback appropriately.
+ */
+static void __maybe_unused
+call_rcu_preempt_remote(struct rcu_head *rhp,
+			void (*func)(struct rcu_head *rhp))
+{
+	invoke_crf_remote(rhp, func, call_rcu);
+}
+static void call_rcu_bh_remote(struct rcu_head *rhp,
+			       void (*func)(struct rcu_head *rhp))
+{
+	invoke_crf_remote(rhp, func, call_rcu_bh);
+}
+static void call_rcu_sched_remote(struct rcu_head *rhp,
+				  void (*func)(struct rcu_head *rhp))
+{
+	invoke_crf_remote(rhp, func, call_rcu_sched);
+}
+
+/*
+ * Per-rcu_data kthread, but only for no-CBs CPUs.  Each kthread invokes
+ * callbacks queued by the corresponding no-CBs CPU.
+ */
+static int rcu_nocb_kthread(void *arg)
+{
+	int c, cl;
+	struct rcu_head *list;
+	struct rcu_head *next;
+	struct rcu_head **tail;
+	struct rcu_data *rdp = arg;
+
+	/* Each pass through this loop invokes one batch of callbacks */
+	for (;;) {
+		/* If not polling, wait for next batch of callbacks. */
+		if (!rcu_nocb_poll)
+			wait_event(rdp->nocb_wq, rdp->nocb_head);
+		list = ACCESS_ONCE(rdp->nocb_head);
+		if (!list) {
+			schedule_timeout_interruptible(1);
+			continue;
+		}
+
+		/*
+		 * Extract queued callbacks, update counts, and wait
+		 * for a grace period to elapse.
+		 */
+		ACCESS_ONCE(rdp->nocb_head) = NULL;
+		tail = xchg(&rdp->nocb_tail, &rdp->nocb_head);
+		c = atomic_long_xchg(&rdp->nocb_q_count, 0);
+		cl = atomic_long_xchg(&rdp->nocb_q_count_lazy, 0);
+		ACCESS_ONCE(rdp->nocb_p_count) += c;
+		ACCESS_ONCE(rdp->nocb_p_count_lazy) += cl;
+		wait_rcu_gp(rdp->rsp->call_remote);
+
+		/* Each pass through the following loop invokes a callback. */
+		trace_rcu_batch_start(rdp->rsp->name, cl, c, -1);
+		c = cl = 0;
+		while (list) {
+			next = list->next;
+			/* Wait for enqueuing to complete, if needed. */
+			while (next == NULL && &list->next != tail) {
+				schedule_timeout_interruptible(1);
+				next = list->next;
+			}
+			debug_rcu_head_unqueue(list);
+			local_bh_disable();
+			if (__rcu_reclaim(rdp->rsp->name, list))
+				cl++;
+			c++;
+			local_bh_enable();
+			list = next;
+		}
+		trace_rcu_batch_end(rdp->rsp->name, c, !!list, 0, 0, 1);
+		ACCESS_ONCE(rdp->nocb_p_count) -= c;
+		ACCESS_ONCE(rdp->nocb_p_count_lazy) -= cl;
+		rdp->n_nocbs_invoked += c;
+	}
+	return 0;
+}
+
+/* Initialize per-rcu_data variables for no-CBs CPUs. */
+static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
+{
+	rdp->nocb_tail = &rdp->nocb_head;
+	init_waitqueue_head(&rdp->nocb_wq);
+}
+
+/* Create a kthread for each RCU flavor for each no-CBs CPU. */
+static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
+{
+	int cpu;
+	struct rcu_data *rdp;
+	struct task_struct *t;
+
+	if (rcu_nocb_mask == NULL)
+		return;
+	for_each_cpu(cpu, rcu_nocb_mask) {
+		rdp = per_cpu_ptr(rsp->rda, cpu);
+		t = kthread_run(rcu_nocb_kthread, rdp, "rcuo%d", cpu);
+		BUG_ON(IS_ERR(t));
+		ACCESS_ONCE(rdp->nocb_kthread) = t;
+	}
+}
+
+/* Prevent __call_rcu() from enqueuing callbacks on no-CBs CPUs */
+static void init_nocb_callback_list(struct rcu_data *rdp)
+{
+	if (rcu_nocb_mask == NULL ||
+	    !cpumask_test_cpu(rdp->cpu, rcu_nocb_mask))
+		return;
+	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
+}
+
+/* Initialize the ->call_remote fields in the rcu_state structures. */
+static void __init rcu_init_nocb(void)
+{
+#ifdef CONFIG_PREEMPT_RCU
+	rcu_preempt_state.call_remote = call_rcu_preempt_remote;
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+	rcu_bh_state.call_remote = call_rcu_bh_remote;
+	rcu_sched_state.call_remote = call_rcu_sched_remote;
+}
+
+#else /* #ifdef CONFIG_RCU_NOCB_CPU */
+
+static bool is_nocb_cpu(int cpu)
+{
+	return false;
+}
+
+static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
+			    bool lazy)
+{
+	return 0;
+}
+
+static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
+						     struct rcu_data *rdp)
+{
+	return 0;
+}
+
+static bool nocb_cpu_expendable(int cpu)
+{
+	return 1;
+}
+
+static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
+{
+}
+
+static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
+{
+}
+
+static void init_nocb_callback_list(struct rcu_data *rdp)
+{
+}
+
+static void __init rcu_init_nocb(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 693513b..0d095dc 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,29 +46,58 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
-static int show_rcubarrier(struct seq_file *m, void *unused)
+#define ulong2long(a) (*(long *)(&(a)))
+
+static int r_open(struct inode *inode, struct file *file,
+					const struct seq_operations *op)
 {
-	struct rcu_state *rsp;
+	int ret = seq_open(file, op);
+	if (!ret) {
+		struct seq_file *m = (struct seq_file *)file->private_data;
+		m->private = inode->i_private;
+	}
+	return ret;
+}
+
+static void *r_start(struct seq_file *m, loff_t *pos)
+{
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+	*pos = cpumask_next(*pos - 1, cpu_possible_mask);
+	if ((*pos) < nr_cpu_ids)
+		return per_cpu_ptr(rsp->rda, *pos);
+	return NULL;
+}
 
-	for_each_rcu_flavor(rsp)
-		seq_printf(m, "%s: bcc: %d nbd: %lu\n",
-			   rsp->name,
-			   atomic_read(&rsp->barrier_cpu_count),
-			   rsp->n_barrier_done);
+static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return r_start(m, pos);
+}
+
+static void r_stop(struct seq_file *m, void *v)
+{
+}
+
+static int show_rcubarrier(struct seq_file *m, void *v)
+{
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+	seq_printf(m, "bcc: %d nbd: %lu\n",
+		   atomic_read(&rsp->barrier_cpu_count),
+		   rsp->n_barrier_done);
 	return 0;
 }
 
 static int rcubarrier_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, show_rcubarrier, NULL);
+	return single_open(file, show_rcubarrier, inode->i_private);
 }
 
 static const struct file_operations rcubarrier_fops = {
 	.owner = THIS_MODULE,
 	.open = rcubarrier_open,
 	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
+	.llseek = no_llseek,
+	.release = seq_release,
 };
 
 #ifdef CONFIG_RCU_BOOST
@@ -84,12 +113,14 @@ static char convert_kthread_status(unsigned int kthread_status)
 
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
+	long ql, qll;
+
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d qp=%d",
+	seq_printf(m, "%3d%cc=%ld g=%ld pq=%d qp=%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
-		   rdp->completed, rdp->gpnum,
+		   ulong2long(rdp->completed), ulong2long(rdp->gpnum),
 		   rdp->passed_quiesce, rdp->qs_pending);
 	seq_printf(m, " dt=%d/%llx/%d df=%lu",
 		   atomic_read(&rdp->dynticks->dynticks),
@@ -97,8 +128,11 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
 	seq_printf(m, " of=%lu", rdp->offline_fqs);
+	rcu_nocb_q_lengths(rdp, &ql, &qll);
+	qll += rdp->qlen_lazy;
+	ql += rdp->qlen;
 	seq_printf(m, " ql=%ld/%ld qs=%c%c%c%c",
-		   rdp->qlen_lazy, rdp->qlen,
+		   qll, ql,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
 		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
@@ -114,101 +148,67 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	seq_printf(m, " b=%ld", rdp->blimit);
-	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
-		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
+	seq_printf(m, " ci=%lu nci=%lu co=%lu ca=%lu\n",
+		   rdp->n_cbs_invoked, rdp->n_nocbs_invoked,
+		   rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
-static int show_rcudata(struct seq_file *m, void *unused)
+static int show_rcudata(struct seq_file *m, void *v)
 {
-	int cpu;
-	struct rcu_state *rsp;
-
-	for_each_rcu_flavor(rsp) {
-		seq_printf(m, "%s:\n", rsp->name);
-		for_each_possible_cpu(cpu)
-			print_one_rcu_data(m, per_cpu_ptr(rsp->rda, cpu));
-	}
+	print_one_rcu_data(m, (struct rcu_data *)v);
 	return 0;
 }
 
+static const struct seq_operations rcudate_op = {
+	.start = r_start,
+	.next  = r_next,
+	.stop  = r_stop,
+	.show  = show_rcudata,
+};
+
 static int rcudata_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, show_rcudata, NULL);
+	return r_open(inode, file, &rcudate_op);
 }
 
 static const struct file_operations rcudata_fops = {
 	.owner = THIS_MODULE,
 	.open = rcudata_open,
 	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
+	.llseek = no_llseek,
+	.release = seq_release,
 };
 
-static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
-{
-	if (!rdp->beenonline)
-		return;
-	seq_printf(m, "%d,%s,%lu,%lu,%d,%d",
-		   rdp->cpu,
-		   cpu_is_offline(rdp->cpu) ? "\"N\"" : "\"Y\"",
-		   rdp->completed, rdp->gpnum,
-		   rdp->passed_quiesce, rdp->qs_pending);
-	seq_printf(m, ",%d,%llx,%d,%lu",
-		   atomic_read(&rdp->dynticks->dynticks),
-		   rdp->dynticks->dynticks_nesting,
-		   rdp->dynticks->dynticks_nmi_nesting,
-		   rdp->dynticks_fqs);
-	seq_printf(m, ",%lu", rdp->offline_fqs);
-	seq_printf(m, ",%ld,%ld,\"%c%c%c%c\"", rdp->qlen_lazy, rdp->qlen,
-		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
-			rdp->nxttail[RCU_NEXT_TAIL]],
-		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
-			rdp->nxttail[RCU_NEXT_READY_TAIL]],
-		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
-			rdp->nxttail[RCU_WAIT_TAIL]],
-		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]]);
-#ifdef CONFIG_RCU_BOOST
-	seq_printf(m, ",%d,\"%c\"",
-		   per_cpu(rcu_cpu_has_work, rdp->cpu),
-		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
-					  rdp->cpu)));
-#endif /* #ifdef CONFIG_RCU_BOOST */
-	seq_printf(m, ",%ld", rdp->blimit);
-	seq_printf(m, ",%lu,%lu,%lu\n",
-		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
-}
-
-static int show_rcudata_csv(struct seq_file *m, void *unused)
+static int show_rcuexp(struct seq_file *m, void *v)
 {
-	int cpu;
-	struct rcu_state *rsp;
-
-	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pq\",");
-	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
-	seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
-#ifdef CONFIG_RCU_BOOST
-	seq_puts(m, "\"kt\",\"ktl\"");
-#endif /* #ifdef CONFIG_RCU_BOOST */
-	seq_puts(m, ",\"b\",\"ci\",\"co\",\"ca\"\n");
-	for_each_rcu_flavor(rsp) {
-		seq_printf(m, "\"%s:\"\n", rsp->name);
-		for_each_possible_cpu(cpu)
-			print_one_rcu_data_csv(m, per_cpu_ptr(rsp->rda, cpu));
-	}
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+
+	seq_printf(m, "s=%lu d=%lu w=%lu tf=%lu wd1=%lu wd2=%lu n=%lu sc=%lu dt=%lu dl=%lu dx=%lu\n",
+		   atomic_long_read(&rsp->expedited_start),
+		   atomic_long_read(&rsp->expedited_done),
+		   atomic_long_read(&rsp->expedited_wrap),
+		   atomic_long_read(&rsp->expedited_tryfail),
+		   atomic_long_read(&rsp->expedited_workdone1),
+		   atomic_long_read(&rsp->expedited_workdone2),
+		   atomic_long_read(&rsp->expedited_normal),
+		   atomic_long_read(&rsp->expedited_stoppedcpus),
+		   atomic_long_read(&rsp->expedited_done_tries),
+		   atomic_long_read(&rsp->expedited_done_lost),
+		   atomic_long_read(&rsp->expedited_done_exit));
 	return 0;
 }
 
-static int rcudata_csv_open(struct inode *inode, struct file *file)
+static int rcuexp_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, show_rcudata_csv, NULL);
+	return single_open(file, show_rcuexp, inode->i_private);
 }
 
-static const struct file_operations rcudata_csv_fops = {
+static const struct file_operations rcuexp_fops = {
 	.owner = THIS_MODULE,
-	.open = rcudata_csv_open,
+	.open = rcuexp_open,
 	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
+	.llseek = no_llseek,
+	.release = seq_release,
 };
 
 #ifdef CONFIG_RCU_BOOST
@@ -254,27 +254,11 @@ static const struct file_operations rcu_node_boost_fops = {
 	.owner = THIS_MODULE,
 	.open = rcu_node_boost_open,
 	.read = seq_read,
-	.llseek = seq_lseek,
+	.llseek = no_llseek,
 	.release = single_release,
 };
 
-/*
- * Create the rcuboost debugfs entry.  Standard error return.
- */
-static int rcu_boost_trace_create_file(struct dentry *rcudir)
-{
-	return !debugfs_create_file("rcuboost", 0444, rcudir, NULL,
-				    &rcu_node_boost_fops);
-}
-
-#else /* #ifdef CONFIG_RCU_BOOST */
-
-static int rcu_boost_trace_create_file(struct dentry *rcudir)
-{
-	return 0;  /* There cannot be an error if we didn't create it! */
-}
-
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
+#endif /* #ifdef CONFIG_RCU_BOOST */
 
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
@@ -283,8 +267,9 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_node *rnp;
 
 	gpnum = rsp->gpnum;
-	seq_printf(m, "%s: c=%lu g=%lu s=%d jfq=%ld j=%x ",
-		   rsp->name, rsp->completed, gpnum, rsp->fqs_state,
+	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x ",
+		   ulong2long(rsp->completed), ulong2long(gpnum),
+		   rsp->fqs_state,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff));
 	seq_printf(m, "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld/%ld\n",
@@ -306,26 +291,24 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	seq_puts(m, "\n");
 }
 
-static int show_rcuhier(struct seq_file *m, void *unused)
+static int show_rcuhier(struct seq_file *m, void *v)
 {
-	struct rcu_state *rsp;
-
-	for_each_rcu_flavor(rsp)
-		print_one_rcu_state(m, rsp);
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+	print_one_rcu_state(m, rsp);
 	return 0;
 }
 
 static int rcuhier_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, show_rcuhier, NULL);
+	return single_open(file, show_rcuhier, inode->i_private);
 }
 
 static const struct file_operations rcuhier_fops = {
 	.owner = THIS_MODULE,
 	.open = rcuhier_open,
 	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
+	.llseek = no_llseek,
+	.release = seq_release,
 };
 
 static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
@@ -338,42 +321,42 @@ static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_node *rnp = &rsp->node[0];
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	completed = rsp->completed;
-	gpnum = rsp->gpnum;
-	if (rsp->completed == rsp->gpnum)
+	completed = ACCESS_ONCE(rsp->completed);
+	gpnum = ACCESS_ONCE(rsp->gpnum);
+	if (completed == gpnum)
 		gpage = 0;
 	else
 		gpage = jiffies - rsp->gp_start;
 	gpmax = rsp->gp_max;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	seq_printf(m, "%s: completed=%ld  gpnum=%lu  age=%ld  max=%ld\n",
-		   rsp->name, completed, gpnum, gpage, gpmax);
+	seq_printf(m, "completed=%ld  gpnum=%ld  age=%ld  max=%ld\n",
+		   ulong2long(completed), ulong2long(gpnum), gpage, gpmax);
 }
 
-static int show_rcugp(struct seq_file *m, void *unused)
+static int show_rcugp(struct seq_file *m, void *v)
 {
-	struct rcu_state *rsp;
-
-	for_each_rcu_flavor(rsp)
-		show_one_rcugp(m, rsp);
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+	show_one_rcugp(m, rsp);
 	return 0;
 }
 
 static int rcugp_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, show_rcugp, NULL);
+	return single_open(file, show_rcugp, inode->i_private);
 }
 
 static const struct file_operations rcugp_fops = {
 	.owner = THIS_MODULE,
 	.open = rcugp_open,
 	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
+	.llseek = no_llseek,
+	.release = seq_release,
 };
 
 static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 {
+	if (!rdp->beenonline)
+		return;
 	seq_printf(m, "%3d%cnp=%ld ",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
@@ -389,34 +372,30 @@ static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->n_rp_need_nothing);
 }
 
-static int show_rcu_pending(struct seq_file *m, void *unused)
+static int show_rcu_pending(struct seq_file *m, void *v)
 {
-	int cpu;
-	struct rcu_data *rdp;
-	struct rcu_state *rsp;
-
-	for_each_rcu_flavor(rsp) {
-		seq_printf(m, "%s:\n", rsp->name);
-		for_each_possible_cpu(cpu) {
-			rdp = per_cpu_ptr(rsp->rda, cpu);
-			if (rdp->beenonline)
-				print_one_rcu_pending(m, rdp);
-		}
-	}
+	print_one_rcu_pending(m, (struct rcu_data *)v);
 	return 0;
 }
 
+static const struct seq_operations rcu_pending_op = {
+	.start = r_start,
+	.next  = r_next,
+	.stop  = r_stop,
+	.show  = show_rcu_pending,
+};
+
 static int rcu_pending_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, show_rcu_pending, NULL);
+	return r_open(inode, file, &rcu_pending_op);
 }
 
 static const struct file_operations rcu_pending_fops = {
 	.owner = THIS_MODULE,
 	.open = rcu_pending_open,
 	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
+	.llseek = no_llseek,
+	.release = seq_release,
 };
 
 static int show_rcutorture(struct seq_file *m, void *unused)
@@ -446,43 +425,58 @@ static struct dentry *rcudir;
 
 static int __init rcutree_trace_init(void)
 {
+	struct rcu_state *rsp;
 	struct dentry *retval;
+	struct dentry *rspdir;
 
 	rcudir = debugfs_create_dir("rcu", NULL);
 	if (!rcudir)
 		goto free_out;
 
-	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
-						NULL, &rcubarrier_fops);
-	if (!retval)
-		goto free_out;
-
-	retval = debugfs_create_file("rcudata", 0444, rcudir,
-						NULL, &rcudata_fops);
-	if (!retval)
-		goto free_out;
-
-	retval = debugfs_create_file("rcudata.csv", 0444, rcudir,
-						NULL, &rcudata_csv_fops);
-	if (!retval)
-		goto free_out;
-
-	if (rcu_boost_trace_create_file(rcudir))
-		goto free_out;
+	for_each_rcu_flavor(rsp) {
+		rspdir = debugfs_create_dir(rsp->name, rcudir);
+		if (!rspdir)
+			goto free_out;
+
+		retval = debugfs_create_file("rcudata", 0444,
+				rspdir, rsp, &rcudata_fops);
+		if (!retval)
+			goto free_out;
+
+		retval = debugfs_create_file("rcuexp", 0444,
+				rspdir, rsp, &rcuexp_fops);
+		if (!retval)
+			goto free_out;
+
+		retval = debugfs_create_file("rcu_pending", 0444,
+				rspdir, rsp, &rcu_pending_fops);
+		if (!retval)
+			goto free_out;
+
+		retval = debugfs_create_file("rcubarrier", 0444,
+				rspdir, rsp, &rcubarrier_fops);
+		if (!retval)
+			goto free_out;
 
-	retval = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
-	if (!retval)
-		goto free_out;
+#ifdef CONFIG_RCU_BOOST
+		if (rsp == &rcu_preempt_state) {
+			retval = debugfs_create_file("rcuboost", 0444,
+				rspdir, NULL, &rcu_node_boost_fops);
+			if (!retval)
+				goto free_out;
+		}
+#endif
 
-	retval = debugfs_create_file("rcuhier", 0444, rcudir,
-						NULL, &rcuhier_fops);
-	if (!retval)
-		goto free_out;
+		retval = debugfs_create_file("rcugp", 0444,
+				rspdir, rsp, &rcugp_fops);
+		if (!retval)
+			goto free_out;
 
-	retval = debugfs_create_file("rcu_pending", 0444, rcudir,
-						NULL, &rcu_pending_fops);
-	if (!retval)
-		goto free_out;
+		retval = debugfs_create_file("rcuhier", 0444,
+				rspdir, rsp, &rcuhier_fops);
+		if (!retval)
+			goto free_out;
+	}
 
 	retval = debugfs_create_file("rcutorture", 0444, rcudir,
 						NULL, &rcutorture_fops);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..80f80df 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -72,6 +72,7 @@
 #include <linux/slab.h>
 #include <linux/init_task.h>
 #include <linux/binfmts.h>
+#include <linux/context_tracking.h>
 
 #include <asm/switch_to.h>
 #include <asm/tlb.h>
@@ -1886,8 +1887,8 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
 #endif
 
+	context_tracking_task_switch(prev, next);
 	/* Here we just switch the register state and the stack. */
-	rcu_switch(prev, next);
 	switch_to(prev, next, prev);
 
 	barrier();
@@ -2911,7 +2912,7 @@ asmlinkage void __sched schedule(void)
 }
 EXPORT_SYMBOL(schedule);
 
-#ifdef CONFIG_RCU_USER_QS
+#ifdef CONFIG_CONTEXT_TRACKING
 asmlinkage void __sched schedule_user(void)
 {
 	/*
@@ -2920,9 +2921,9 @@ asmlinkage void __sched schedule_user(void)
 	 * we haven't yet exited the RCU idle mode. Do it here manually until
 	 * we find a better solution.
 	 */
-	rcu_user_exit();
+	user_exit();
 	schedule();
-	rcu_user_enter();
+	user_enter();
 }
 #endif
 
@@ -3027,7 +3028,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
-	rcu_user_exit();
+	user_exit();
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
@@ -4474,6 +4475,7 @@ static const char stat_nam[] = TASK_STATE_TO_CHAR_STR;
 void sched_show_task(struct task_struct *p)
 {
 	unsigned long free = 0;
+	int ppid;
 	unsigned state;
 
 	state = p->state ? __ffs(p->state) + 1 : 0;
@@ -4493,8 +4495,11 @@ void sched_show_task(struct task_struct *p)
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
+	rcu_read_lock();
+	ppid = task_pid_nr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
-		task_pid_nr(p), task_pid_nr(rcu_dereference(p->real_parent)),
+		task_pid_nr(p), ppid,
 		(unsigned long)task_thread_info(p)->flags);
 
 	show_stack(p, NULL);
@@ -8076,3 +8081,9 @@ struct cgroup_subsys cpuacct_subsys = {
 	.base_cftypes = files,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
+
+void dump_cpu_task(int cpu)
+{
+	pr_info("Task dump for CPU %d:\n", cpu);
+	sched_show_task(cpu_curr(cpu));
+}
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 97c465e..2b85982 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -16,8 +16,10 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2006
+ * Copyright (C) Fujitsu, 2012
  *
  * Author: Paul McKenney <paulmck@us.ibm.com>
+ *	   Lai Jiangshan <laijs@cn.fujitsu.com>
  *
  * For detailed explanation of Read-Copy Update mechanism see -
  * 		Documentation/RCU/ *.txt
@@ -34,6 +36,10 @@
 #include <linux/delay.h>
 #include <linux/srcu.h>
 
+#include <trace/events/rcu.h>
+
+#include "rcu.h"
+
 /*
  * Initialize an rcu_batch structure to empty.
  */
@@ -92,9 +98,6 @@ static inline void rcu_batch_move(struct rcu_batch *to, struct rcu_batch *from)
 	}
 }
 
-/* single-thread state-machine */
-static void process_srcu(struct work_struct *work);
-
 static int init_srcu_struct_fields(struct srcu_struct *sp)
 {
 	sp->completed = 0;
@@ -464,7 +467,9 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
  */
 void synchronize_srcu(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_TRYCOUNT);
+	__synchronize_srcu(sp, rcu_expedited
+			   ? SYNCHRONIZE_SRCU_EXP_TRYCOUNT
+			   : SYNCHRONIZE_SRCU_TRYCOUNT);
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 
@@ -637,7 +642,7 @@ static void srcu_reschedule(struct srcu_struct *sp)
 /*
  * This is the work-queue function that handles SRCU grace periods.
  */
-static void process_srcu(struct work_struct *work)
+void process_srcu(struct work_struct *work)
 {
 	struct srcu_struct *sp;
 
@@ -648,3 +653,4 @@ static void process_srcu(struct work_struct *work)
 	srcu_invoke_callbacks(sp);
 	srcu_reschedule(sp);
 }
+EXPORT_SYMBOL_GPL(process_srcu);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28e9d6c9..41faf0b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -972,7 +972,7 @@ config RCU_CPU_STALL_TIMEOUT
 	int "RCU CPU stall timeout in seconds"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
 	range 3 300
-	default 60
+	default 21
 	help
 	  If a given RCU grace period extends more than the specified
 	  number of seconds, a CPU stall warning is printed.  If the
