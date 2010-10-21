Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0JUMzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:55:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab0JUMzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:55:46 -0400
Date: Thu, 21 Oct 2010 14:55:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v2.6.37
Message-ID: <20101021125507.GA470@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-rcu-for-linus

( The tree affects more files than usual, due to the Sparse based RCU checking 
  changes. )

 Thanks,

	Ingo

------------------>
Arnd Bergmann (13):
      rculist: avoid __rcu annotations
      cgroups: __rcu annotations
      credentials: rcu annotation
      keys: __rcu annotations
      nfs: __rcu annotations
      input: __rcu annotations
      net/netfilter: __rcu annotations
      kvm: add __rcu annotations
      notifiers: __rcu annotations
      radix-tree: __rcu annotations
      idr: __rcu annotations
      kernel: __rcu annotations
      vhost: add __rcu annotations

Christian Dietrich (1):
      kernel: Remove undead ifdef CONFIG_DEBUG_LOCK_ALLOC

Dongdong Deng (1):
      rcu: using ACCESS_ONCE() to observe the jiffies_stall/rnp->qsmask value

Lai Jiangshan (2):
      rcutorture: add random preemption
      rcu: simplify the usage of percpu data

Mathieu Desnoyers (1):
      rcu head remove init

Paul E. McKenney (32):
      net: convert to rcu_dereference_index_check()
      rcu: define __rcu address space modifier for sparse
      rcu: add shiny new debug assists to Documentation/RCU/checklist.txt
      rcu: make CPU stall warning timeout configurable
      rcu: add boot parameter to suppress RCU CPU stall warning messages
      rcu: improve kerneldoc for rcu_read_lock(), call_rcu(), and synchronize_rcu()
      Update documentation to note the passage of INIT_RCU_HEAD()
      Update call_rcu() usage, add synchronize_rcu()
      rcu: allow RCU CPU stall warning messages to be controlled in /sys
      rcu: restrict TREE_RCU to SMP builds with !PREEMPT
      rcu: Allow RCU CPU stall warnings to be off at boot, but manually enablable
      rcu: Fix RCU_FANOUT help message
      rcu: Add a TINY_PREEMPT_RCU
      rcu: update obsolete rcu_read_lock() comment.
      rcu: refer RCU CPU stall-warning victims to stallwarn.txt
      rcu: permit suppressing current grace period's CPU stall warnings
      rcu: repair code-duplication FIXMEs
      rcu: document ways of stalling updates in low-memory situations
      rcu: Upgrade srcu_read_lock() docbook about SRCU grace periods
      rcu: combine duplicate code, courtesy of CONFIG_PREEMPT_RCU
      rcu: apply TINY_PREEMPT_RCU read-side speedup to TREE_PREEMPT_RCU
      rcu: add comment stating that list_empty() applies to RCU-protected lists
      rcu: upgrade stallwarn.txt documentation for CPU-bound RT processes
      rcu: performance fixes to TINY_PREEMPT_RCU callback checking
      rcu: fix _oddness handling of verbose stall warnings
      rcu: only one evaluation of arg in rcu_dereference_check() unless sparse
      rcu: fix sparse errors in rcutorture.c
      rcu: Add tracing data to support queueing models
      rcu: Add advice to PROVE_RCU_REPEATEDLY kernel config parameter
      rcu: move check from rcu_dereference_bh to rcu_read_lock_bh_held
      net: suppress RCU lockdep false positive in sock_update_classid
      sched: suppress RCU lockdep splat in task_fork_fair

Peter Zijlstra (1):
      sched: fix RCU lockdep splat from task_group()

Tetsuo Handa (1):
      Add RCU check for find_task_by_vpid().


 Documentation/DocBook/kernel-locking.tmpl |   14 +-
 Documentation/RCU/checklist.txt           |   46 ++-
 Documentation/RCU/stallwarn.txt           |   18 +
 Documentation/RCU/trace.txt               |   13 +-
 drivers/input/evdev.c                     |    2 +-
 drivers/vhost/net.c                       |   16 +-
 drivers/vhost/vhost.c                     |   22 +-
 drivers/vhost/vhost.h                     |   10 +-
 include/linux/cgroup.h                    |    4 +-
 include/linux/compiler.h                  |    4 +
 include/linux/cred.h                      |    2 +-
 include/linux/fdtable.h                   |    6 +-
 include/linux/fs.h                        |    2 +-
 include/linux/genhd.h                     |    6 +-
 include/linux/hardirq.h                   |    2 +-
 include/linux/idr.h                       |    4 +-
 include/linux/init_task.h                 |   14 +-
 include/linux/input.h                     |    2 +-
 include/linux/iocontext.h                 |    2 +-
 include/linux/key.h                       |    3 +-
 include/linux/kvm_host.h                  |    2 +-
 include/linux/mm_types.h                  |    2 +-
 include/linux/nfs_fs.h                    |    2 +-
 include/linux/notifier.h                  |   10 +-
 include/linux/radix-tree.h                |    4 +-
 include/linux/rculist.h                   |   62 +++-
 include/linux/rculist_nulls.h             |   16 +-
 include/linux/rcupdate.h                  |  490 +++++++++++++++++--------
 include/linux/rcutiny.h                   |  104 +++---
 include/linux/rcutree.h                   |   57 +---
 include/linux/sched.h                     |   16 +-
 include/linux/srcu.h                      |   34 ++-
 include/linux/sunrpc/auth_gss.h           |    4 +-
 include/net/cls_cgroup.h                  |    3 +-
 include/net/netfilter/nf_conntrack.h      |    2 +-
 init/Kconfig                              |   26 ++-
 kernel/Makefile                           |    1 +
 kernel/cgroup.c                           |    2 +-
 kernel/pid.c                              |    3 +-
 kernel/rcupdate.c                         |    8 +-
 kernel/rcutiny.c                          |   33 +-
 kernel/rcutiny_plugin.h                   |  582 ++++++++++++++++++++++++++++-
 kernel/rcutorture.c                       |   17 +-
 kernel/rcutree.c                          |   92 +++--
 kernel/rcutree.h                          |   20 +-
 kernel/rcutree_plugin.h                   |   47 ++-
 kernel/rcutree_trace.c                    |   12 +-
 kernel/sched.c                            |   12 +
 kernel/sched_fair.c                       |    5 +-
 kernel/srcu.c                             |    2 -
 lib/Kconfig.debug                         |   41 ++
 lib/radix-tree.c                          |    2 +-
 net/core/sock.c                           |    5 +-
 net/ipv4/netfilter/nf_nat_core.c          |    2 +-
 net/netfilter/core.c                      |    2 +-
 net/netfilter/nf_conntrack_ecache.c       |    4 +-
 net/netfilter/nf_conntrack_extend.c       |    2 +-
 net/netfilter/nf_conntrack_proto.c        |    4 +-
 net/netfilter/nf_log.c                    |    2 +-
 net/netfilter/nf_queue.c                  |    2 +-
 60 files changed, 1454 insertions(+), 474 deletions(-)

diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index a0d479d..f66f4df 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1645,7 +1645,9 @@ the amount of locking which needs to be done.
       all the readers who were traversing the list when we deleted the
       element are finished.  We use <function>call_rcu()</function> to
       register a callback which will actually destroy the object once
-      the readers are finished.
+      all pre-existing readers are finished.  Alternatively,
+      <function>synchronize_rcu()</function> may be used to block until
+      all pre-existing are finished.
     </para>
     <para>
       But how does Read Copy Update know when the readers are
@@ -1714,7 +1716,7 @@ the amount of locking which needs to be done.
 -        object_put(obj);
 +        list_del_rcu(&amp;obj-&gt;list);
          cache_num--;
-+        call_rcu(&amp;obj-&gt;rcu, cache_delete_rcu, obj);
++        call_rcu(&amp;obj-&gt;rcu, cache_delete_rcu);
  }
 
  /* Must be holding cache_lock */
@@ -1725,14 +1727,6 @@ the amount of locking which needs to be done.
          if (++cache_num > MAX_CACHE_SIZE) {
                  struct object *i, *outcast = NULL;
                  list_for_each_entry(i, &amp;cache, list) {
-@@ -85,6 +94,7 @@
-         obj-&gt;popularity = 0;
-         atomic_set(&amp;obj-&gt;refcnt, 1); /* The cache holds a reference */
-         spin_lock_init(&amp;obj-&gt;lock);
-+        INIT_RCU_HEAD(&amp;obj-&gt;rcu);
-
-         spin_lock_irqsave(&amp;cache_lock, flags);
-         __cache_add(obj);
 @@ -104,12 +114,11 @@
  struct object *cache_find(int id)
  {
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 790d1a8..0c134f8 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -218,13 +218,22 @@ over a rather long period of time, but improvements are always welcome!
 	include:
 
 	a.	Keeping a count of the number of data-structure elements
-		used by the RCU-protected data structure, including those
-		waiting for a grace period to elapse.  Enforce a limit
-		on this number, stalling updates as needed to allow
-		previously deferred frees to complete.
-
-		Alternatively, limit only the number awaiting deferred
-		free rather than the total number of elements.
+		used by the RCU-protected data structure, including
+		those waiting for a grace period to elapse.  Enforce a
+		limit on this number, stalling updates as needed to allow
+		previously deferred frees to complete.	Alternatively,
+		limit only the number awaiting deferred free rather than
+		the total number of elements.
+
+		One way to stall the updates is to acquire the update-side
+		mutex.	(Don't try this with a spinlock -- other CPUs
+		spinning on the lock could prevent the grace period
+		from ever ending.)  Another way to stall the updates
+		is for the updates to use a wrapper function around
+		the memory allocator, so that this wrapper function
+		simulates OOM when there is too much memory awaiting an
+		RCU grace period.  There are of course many other
+		variations on this theme.
 
 	b.	Limiting update rate.  For example, if updates occur only
 		once per hour, then no explicit rate limiting is required,
@@ -365,3 +374,26 @@ over a rather long period of time, but improvements are always welcome!
 	and the compiler to freely reorder code into and out of RCU
 	read-side critical sections.  It is the responsibility of the
 	RCU update-side primitives to deal with this.
+
+17.	Use CONFIG_PROVE_RCU, CONFIG_DEBUG_OBJECTS_RCU_HEAD, and
+	the __rcu sparse checks to validate your RCU code.  These
+	can help find problems as follows:
+
+	CONFIG_PROVE_RCU: check that accesses to RCU-protected data
+		structures are carried out under the proper RCU
+		read-side critical section, while holding the right
+		combination of locks, or whatever other conditions
+		are appropriate.
+
+	CONFIG_DEBUG_OBJECTS_RCU_HEAD: check that you don't pass the
+		same object to call_rcu() (or friends) before an RCU
+		grace period has elapsed since the last time that you
+		passed that same object to call_rcu() (or friends).
+
+	__rcu sparse checks: tag the pointer to the RCU-protected data
+		structure with __rcu, and sparse will warn you if you
+		access that pointer without the services of one of the
+		variants of rcu_dereference().
+
+	These debugging aids can help you find problems that are
+	otherwise extremely difficult to spot.
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 44c6dcc..862c08e 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -80,6 +80,24 @@ o	A CPU looping with bottom halves disabled.  This condition can
 o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the kernel
 	without invoking schedule().
 
+o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
+	happen to preempt a low-priority task in the middle of an RCU
+	read-side critical section.   This is especially damaging if
+	that low-priority task is not permitted to run on any other CPU,
+	in which case the next RCU grace period can never complete, which
+	will eventually cause the system to run out of memory and hang.
+	While the system is in the process of running itself out of
+	memory, you might see stall-warning messages.
+
+o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
+	is running at a higher priority than the RCU softirq threads.
+	This will prevent RCU callbacks from ever being invoked,
+	and in a CONFIG_TREE_PREEMPT_RCU kernel will further prevent
+	RCU grace periods from ever completing.  Either way, the
+	system will eventually run out of memory and hang.  In the
+	CONFIG_TREE_PREEMPT_RCU case, you might see stall-warning
+	messages.
+
 o	A bug in the RCU implementation.
 
 o	A hardware failure.  This is quite unlikely, but has occurred
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index efd8cc9..a851118 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -125,6 +125,17 @@ o	"b" is the batch limit for this CPU.  If more than this number
 	of RCU callbacks is ready to invoke, then the remainder will
 	be deferred.
 
+o	"ci" is the number of RCU callbacks that have been invoked for
+	this CPU.  Note that ci+ql is the number of callbacks that have
+	been registered in absence of CPU-hotplug activity.
+
+o	"co" is the number of RCU callbacks that have been orphaned due to
+	this CPU going offline.
+
+o	"ca" is the number of RCU callbacks that have been adopted due to
+	other CPUs going offline.  Note that ci+co-ca+ql is the number of
+	RCU callbacks registered on this CPU.
+
 There is also an rcu/rcudata.csv file with the same information in
 comma-separated-variable spreadsheet format.
 
@@ -180,7 +191,7 @@ o	"s" is the "signaled" state that drives force_quiescent_state()'s
 
 o	"jfq" is the number of jiffies remaining for this grace period
 	before force_quiescent_state() is invoked to help push things
-	along.  Note that CPUs in dyntick-idle mode thoughout the grace
+	along.  Note that CPUs in dyntick-idle mode throughout the grace
 	period will not report on their own, but rather must be check by
 	some other CPU via force_quiescent_state().
 
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index c908c5f..5808731 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -28,7 +28,7 @@ struct evdev {
 	int minor;
 	struct input_handle handle;
 	wait_queue_head_t wait;
-	struct evdev_client *grab;
+	struct evdev_client __rcu *grab;
 	struct list_head client_list;
 	spinlock_t client_lock; /* protects client_list */
 	struct mutex mutex;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7c80082..17927b1 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -127,7 +127,10 @@ static void handle_tx(struct vhost_net *net)
 	size_t len, total_len = 0;
 	int err, wmem;
 	size_t hdr_size;
-	struct socket *sock = rcu_dereference(vq->private_data);
+	struct socket *sock;
+
+	sock = rcu_dereference_check(vq->private_data,
+				     lockdep_is_held(&vq->mutex));
 	if (!sock)
 		return;
 
@@ -582,7 +585,10 @@ static void vhost_net_disable_vq(struct vhost_net *n,
 static void vhost_net_enable_vq(struct vhost_net *n,
 				struct vhost_virtqueue *vq)
 {
-	struct socket *sock = vq->private_data;
+	struct socket *sock;
+
+	sock = rcu_dereference_protected(vq->private_data,
+					 lockdep_is_held(&vq->mutex));
 	if (!sock)
 		return;
 	if (vq == n->vqs + VHOST_NET_VQ_TX) {
@@ -598,7 +604,8 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
 	struct socket *sock;
 
 	mutex_lock(&vq->mutex);
-	sock = vq->private_data;
+	sock = rcu_dereference_protected(vq->private_data,
+					 lockdep_is_held(&vq->mutex));
 	vhost_net_disable_vq(n, vq);
 	rcu_assign_pointer(vq->private_data, NULL);
 	mutex_unlock(&vq->mutex);
@@ -736,7 +743,8 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	}
 
 	/* start polling new socket */
-	oldsock = vq->private_data;
+	oldsock = rcu_dereference_protected(vq->private_data,
+					    lockdep_is_held(&vq->mutex));
 	if (sock != oldsock) {
                 vhost_net_disable_vq(n, vq);
                 rcu_assign_pointer(vq->private_data, sock);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index dd3d6f7..8b5a1b3 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -320,7 +320,7 @@ long vhost_dev_reset_owner(struct vhost_dev *dev)
 	vhost_dev_cleanup(dev);
 
 	memory->nregions = 0;
-	dev->memory = memory;
+	RCU_INIT_POINTER(dev->memory, memory);
 	return 0;
 }
 
@@ -352,8 +352,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 		fput(dev->log_file);
 	dev->log_file = NULL;
 	/* No one will access memory at this point */
-	kfree(dev->memory);
-	dev->memory = NULL;
+	kfree(rcu_dereference_protected(dev->memory,
+					lockdep_is_held(&dev->mutex)));
+	RCU_INIT_POINTER(dev->memory, NULL);
 	if (dev->mm)
 		mmput(dev->mm);
 	dev->mm = NULL;
@@ -440,14 +441,22 @@ static int vq_access_ok(unsigned int num,
 /* Caller should have device mutex but not vq mutex */
 int vhost_log_access_ok(struct vhost_dev *dev)
 {
-	return memory_access_ok(dev, dev->memory, 1);
+	struct vhost_memory *mp;
+
+	mp = rcu_dereference_protected(dev->memory,
+				       lockdep_is_held(&dev->mutex));
+	return memory_access_ok(dev, mp, 1);
 }
 
 /* Verify access for write logging. */
 /* Caller should have vq mutex and device mutex */
 static int vq_log_access_ok(struct vhost_virtqueue *vq, void __user *log_base)
 {
-	return vq_memory_access_ok(log_base, vq->dev->memory,
+	struct vhost_memory *mp;
+
+	mp = rcu_dereference_protected(vq->dev->memory,
+				       lockdep_is_held(&vq->mutex));
+	return vq_memory_access_ok(log_base, mp,
 			    vhost_has_feature(vq->dev, VHOST_F_LOG_ALL)) &&
 		(!vq->log_used || log_access_ok(log_base, vq->log_addr,
 					sizeof *vq->used +
@@ -487,7 +496,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 		kfree(newmem);
 		return -EFAULT;
 	}
-	oldmem = d->memory;
+	oldmem = rcu_dereference_protected(d->memory,
+					   lockdep_is_held(&d->mutex));
 	rcu_assign_pointer(d->memory, newmem);
 	synchronize_rcu();
 	kfree(oldmem);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index afd7729..af3c11d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -106,7 +106,7 @@ struct vhost_virtqueue {
 	 * vhost_work execution acts instead of rcu_read_lock() and the end of
 	 * vhost_work execution acts instead of rcu_read_lock().
 	 * Writers use virtqueue mutex. */
-	void *private_data;
+	void __rcu *private_data;
 	/* Log write descriptors */
 	void __user *log_base;
 	struct vhost_log log[VHOST_NET_MAX_SG];
@@ -116,7 +116,7 @@ struct vhost_dev {
 	/* Readers use RCU to access memory table pointer
 	 * log base pointer and features.
 	 * Writers use mutex below.*/
-	struct vhost_memory *memory;
+	struct vhost_memory __rcu *memory;
 	struct mm_struct *mm;
 	struct mutex mutex;
 	unsigned acked_features;
@@ -173,7 +173,11 @@ enum {
 
 static inline int vhost_has_feature(struct vhost_dev *dev, int bit)
 {
-	unsigned acked_features = rcu_dereference(dev->acked_features);
+	unsigned acked_features;
+
+	acked_features =
+		rcu_dereference_index_check(dev->acked_features,
+					    lockdep_is_held(&dev->mutex));
 	return acked_features & (1 << bit);
 }
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0c99102..709dfb9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -75,7 +75,7 @@ struct cgroup_subsys_state {
 
 	unsigned long flags;
 	/* ID for this css, if possible */
-	struct css_id *id;
+	struct css_id __rcu *id;
 };
 
 /* bits in struct cgroup_subsys_state flags field */
@@ -205,7 +205,7 @@ struct cgroup {
 	struct list_head children;	/* my children */
 
 	struct cgroup *parent;		/* my parent */
-	struct dentry *dentry;	  	/* cgroup fs entry, RCU protected */
+	struct dentry __rcu *dentry;	/* cgroup fs entry, RCU protected */
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c1a62c5..320d6c9 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -16,7 +16,11 @@
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 # define __percpu	__attribute__((noderef, address_space(3)))
+#ifdef CONFIG_SPARSE_RCU_POINTER
+# define __rcu		__attribute__((noderef, address_space(4)))
+#else
 # define __rcu
+#endif
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
 #else
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 4d2c395..4aaeab3 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -84,7 +84,7 @@ struct thread_group_cred {
 	atomic_t	usage;
 	pid_t		tgid;			/* thread group process ID */
 	spinlock_t	lock;
-	struct key	*session_keyring;	/* keyring inherited over fork */
+	struct key __rcu *session_keyring;	/* keyring inherited over fork */
 	struct key	*process_keyring;	/* keyring private to this process */
 	struct rcu_head	rcu;			/* RCU deletion hook */
 };
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index f59ed29..133c0ba 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -31,7 +31,7 @@ struct embedded_fd_set {
 
 struct fdtable {
 	unsigned int max_fds;
-	struct file ** fd;      /* current fd array */
+	struct file __rcu **fd;      /* current fd array */
 	fd_set *close_on_exec;
 	fd_set *open_fds;
 	struct rcu_head rcu;
@@ -46,7 +46,7 @@ struct files_struct {
    * read mostly part
    */
 	atomic_t count;
-	struct fdtable *fdt;
+	struct fdtable __rcu *fdt;
 	struct fdtable fdtab;
   /*
    * written part on a separate cache line in SMP
@@ -55,7 +55,7 @@ struct files_struct {
 	int next_fd;
 	struct embedded_fd_set close_on_exec_init;
 	struct embedded_fd_set open_fds_init;
-	struct file * fd_array[NR_OPEN_DEFAULT];
+	struct file __rcu * fd_array[NR_OPEN_DEFAULT];
 };
 
 #define rcu_dereference_check_fdtable(files, fdtfd) \
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..3168dcf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1384,7 +1384,7 @@ struct super_block {
 	 * Saved mount options for lazy filesystems using
 	 * generic_show_options()
 	 */
-	char *s_options;
+	char __rcu *s_options;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5f2f4c4..af3f06b 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -129,8 +129,8 @@ struct blk_scsi_cmd_filter {
 struct disk_part_tbl {
 	struct rcu_head rcu_head;
 	int len;
-	struct hd_struct *last_lookup;
-	struct hd_struct *part[];
+	struct hd_struct __rcu *last_lookup;
+	struct hd_struct __rcu *part[];
 };
 
 struct gendisk {
@@ -149,7 +149,7 @@ struct gendisk {
 	 * non-critical accesses use RCU.  Always access through
 	 * helpers.
 	 */
-	struct disk_part_tbl *part_tbl;
+	struct disk_part_tbl __rcu *part_tbl;
 	struct hd_struct part0;
 
 	const struct block_device_operations *fops;
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d5b3876..1f4517d 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -139,7 +139,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
 #endif
 
 #if defined(CONFIG_NO_HZ)
-#if defined(CONFIG_TINY_RCU)
+#if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
 extern void rcu_enter_nohz(void);
 extern void rcu_exit_nohz(void);
 
diff --git a/include/linux/idr.h b/include/linux/idr.h
index e968db7..cdb715e 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -50,14 +50,14 @@
 
 struct idr_layer {
 	unsigned long		 bitmap; /* A zero bit means "space here" */
-	struct idr_layer	*ary[1<<IDR_BITS];
+	struct idr_layer __rcu	*ary[1<<IDR_BITS];
 	int			 count;	 /* When zero, we can release it */
 	int			 layer;	 /* distance from leaf */
 	struct rcu_head		 rcu_head;
 };
 
 struct idr {
-	struct idr_layer *top;
+	struct idr_layer __rcu *top;
 	struct idr_layer *id_free;
 	int		  layers; /* only valid without concurrent changes */
 	int		  id_free_cnt;
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f43fa5..2fea6c8 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -82,11 +82,17 @@ extern struct group_info init_groups;
 # define CAP_INIT_BSET  CAP_FULL_SET
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
+#define INIT_TASK_RCU_TREE_PREEMPT()					\
+	.rcu_blocked_node = NULL,
+#else
+#define INIT_TASK_RCU_TREE_PREEMPT(tsk)
+#endif
+#ifdef CONFIG_PREEMPT_RCU
 #define INIT_TASK_RCU_PREEMPT(tsk)					\
 	.rcu_read_lock_nesting = 0,					\
 	.rcu_read_unlock_special = 0,					\
-	.rcu_blocked_node = NULL,					\
-	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),
+	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
+	INIT_TASK_RCU_TREE_PREEMPT()
 #else
 #define INIT_TASK_RCU_PREEMPT(tsk)
 #endif
@@ -137,8 +143,8 @@ extern struct cred init_cred;
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
-	.real_cred	= &init_cred,					\
-	.cred		= &init_cred,					\
+	RCU_INIT_POINTER(.real_cred, &init_cred),			\
+	RCU_INIT_POINTER(.cred, &init_cred),				\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(tsk.cred_guard_mutex),		\
 	.comm		= "swapper",					\
diff --git a/include/linux/input.h b/include/linux/input.h
index 896a922..d6ae176 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1196,7 +1196,7 @@ struct input_dev {
 	int (*flush)(struct input_dev *dev, struct file *file);
 	int (*event)(struct input_dev *dev, unsigned int type, unsigned int code, int value);
 
-	struct input_handle *grab;
+	struct input_handle __rcu *grab;
 
 	spinlock_t event_lock;
 	struct mutex mutex;
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 64d5291..3e70b21 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -53,7 +53,7 @@ struct io_context {
 
 	struct radix_tree_root radix_root;
 	struct hlist_head cic_list;
-	void *ioc_data;
+	void __rcu *ioc_data;
 };
 
 static inline struct io_context *ioc_task_link(struct io_context *ioc)
diff --git a/include/linux/key.h b/include/linux/key.h
index cd50dfa..3db0adc 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -178,8 +178,9 @@ struct key {
 	 */
 	union {
 		unsigned long		value;
+		void __rcu		*rcudata;
 		void			*data;
-		struct keyring_list	*subscriptions;
+		struct keyring_list __rcu *subscriptions;
 	} payload;
 };
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c13cc48..ac740b2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -205,7 +205,7 @@ struct kvm {
 
 	struct mutex irq_lock;
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
-	struct kvm_irq_routing_table *irq_routing;
+	struct kvm_irq_routing_table __rcu *irq_routing;
 	struct hlist_head mask_notifier_list;
 	struct hlist_head irq_ack_notifier_list;
 #endif
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ee7e258..cb57d65 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -299,7 +299,7 @@ struct mm_struct {
 	 * new_owner->mm == mm
 	 * new_owner->alloc_lock is held
 	 */
-	struct task_struct *owner;
+	struct task_struct __rcu *owner;
 #endif
 
 #ifdef CONFIG_PROC_FS
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 508f8cf..d0edf7d 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -185,7 +185,7 @@ struct nfs_inode {
 	struct nfs4_cached_acl	*nfs4_acl;
         /* NFSv4 state */
 	struct list_head	open_states;
-	struct nfs_delegation	*delegation;
+	struct nfs_delegation __rcu *delegation;
 	fmode_t			 delegation_state;
 	struct rw_semaphore	rwsem;
 #endif /* CONFIG_NFS_V4*/
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index b2f1a4d..2026f9e 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -49,28 +49,28 @@
 
 struct notifier_block {
 	int (*notifier_call)(struct notifier_block *, unsigned long, void *);
-	struct notifier_block *next;
+	struct notifier_block __rcu *next;
 	int priority;
 };
 
 struct atomic_notifier_head {
 	spinlock_t lock;
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 struct blocking_notifier_head {
 	struct rw_semaphore rwsem;
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 struct raw_notifier_head {
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 struct srcu_notifier_head {
 	struct mutex mutex;
 	struct srcu_struct srcu;
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 #define ATOMIC_INIT_NOTIFIER_HEAD(name) do {	\
diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 634b8e6..a39cbed 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -47,6 +47,8 @@ static inline void *radix_tree_indirect_to_ptr(void *ptr)
 {
 	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
 }
+#define radix_tree_indirect_to_ptr(ptr) \
+	radix_tree_indirect_to_ptr((void __force *)(ptr))
 
 static inline int radix_tree_is_indirect_ptr(void *ptr)
 {
@@ -61,7 +63,7 @@ static inline int radix_tree_is_indirect_ptr(void *ptr)
 struct radix_tree_root {
 	unsigned int		height;
 	gfp_t			gfp_mask;
-	struct radix_tree_node	*rnode;
+	struct radix_tree_node	__rcu *rnode;
 };
 
 #define RADIX_TREE_INIT(mask)	{					\
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 4ec3b38..f31ef61 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -10,6 +10,21 @@
 #include <linux/rcupdate.h>
 
 /*
+ * Why is there no list_empty_rcu()?  Because list_empty() serves this
+ * purpose.  The list_empty() function fetches the RCU-protected pointer
+ * and compares it to the address of the list head, but neither dereferences
+ * this pointer itself nor provides this pointer to the caller.  Therefore,
+ * it is not necessary to use rcu_dereference(), so that list_empty() can
+ * be used anywhere you would want to use a list_empty_rcu().
+ */
+
+/*
+ * return the ->next pointer of a list_head in an rcu safe
+ * way, we must not access it directly
+ */
+#define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
+
+/*
  * Insert a new entry between two known consecutive entries.
  *
  * This is only for internal list manipulation where we know
@@ -20,7 +35,7 @@ static inline void __list_add_rcu(struct list_head *new,
 {
 	new->next = next;
 	new->prev = prev;
-	rcu_assign_pointer(prev->next, new);
+	rcu_assign_pointer(list_next_rcu(prev), new);
 	next->prev = new;
 }
 
@@ -138,7 +153,7 @@ static inline void list_replace_rcu(struct list_head *old,
 {
 	new->next = old->next;
 	new->prev = old->prev;
-	rcu_assign_pointer(new->prev->next, new);
+	rcu_assign_pointer(list_next_rcu(new->prev), new);
 	new->next->prev = new;
 	old->prev = LIST_POISON2;
 }
@@ -193,7 +208,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	 */
 
 	last->next = at;
-	rcu_assign_pointer(head->next, first);
+	rcu_assign_pointer(list_next_rcu(head), first);
 	first->prev = head;
 	at->prev = last;
 }
@@ -208,7 +223,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
 #define list_entry_rcu(ptr, type, member) \
-	container_of(rcu_dereference_raw(ptr), type, member)
+	({typeof (*ptr) __rcu *__ptr = (typeof (*ptr) __rcu __force *)ptr; \
+	 container_of((typeof(ptr))rcu_dereference_raw(__ptr), type, member); \
+	})
 
 /**
  * list_first_entry_rcu - get the first element from a list
@@ -225,9 +242,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	list_entry_rcu((ptr)->next, type, member)
 
 #define __list_for_each_rcu(pos, head) \
-	for (pos = rcu_dereference_raw((head)->next); \
+	for (pos = rcu_dereference_raw(list_next_rcu(head)); \
 		pos != (head); \
-		pos = rcu_dereference_raw(pos->next))
+		pos = rcu_dereference_raw(list_next_rcu((pos)))
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
@@ -257,9 +274,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = rcu_dereference_raw((pos)->next); \
+	for ((pos) = rcu_dereference_raw(list_next_rcu(pos)); \
 		prefetch((pos)->next), (pos) != (head); \
-		(pos) = rcu_dereference_raw((pos)->next))
+		(pos) = rcu_dereference_raw(list_next_rcu(pos)))
 
 /**
  * list_for_each_entry_continue_rcu - continue iteration over list of given type
@@ -314,12 +331,19 @@ static inline void hlist_replace_rcu(struct hlist_node *old,
 
 	new->next = next;
 	new->pprev = old->pprev;
-	rcu_assign_pointer(*new->pprev, new);
+	rcu_assign_pointer(*(struct hlist_node __rcu **)new->pprev, new);
 	if (next)
 		new->next->pprev = &new->next;
 	old->pprev = LIST_POISON2;
 }
 
+/*
+ * return the first or the next element in an RCU protected hlist
+ */
+#define hlist_first_rcu(head)	(*((struct hlist_node __rcu **)(&(head)->first)))
+#define hlist_next_rcu(node)	(*((struct hlist_node __rcu **)(&(node)->next)))
+#define hlist_pprev_rcu(node)	(*((struct hlist_node __rcu **)((node)->pprev)))
+
 /**
  * hlist_add_head_rcu
  * @n: the element to add to the hash list.
@@ -346,7 +370,7 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
 
 	n->next = first;
 	n->pprev = &h->first;
-	rcu_assign_pointer(h->first, n);
+	rcu_assign_pointer(hlist_first_rcu(h), n);
 	if (first)
 		first->pprev = &n->next;
 }
@@ -374,7 +398,7 @@ static inline void hlist_add_before_rcu(struct hlist_node *n,
 {
 	n->pprev = next->pprev;
 	n->next = next;
-	rcu_assign_pointer(*(n->pprev), n);
+	rcu_assign_pointer(hlist_pprev_rcu(n), n);
 	next->pprev = &n->next;
 }
 
@@ -401,15 +425,15 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
 {
 	n->next = prev->next;
 	n->pprev = &prev->next;
-	rcu_assign_pointer(prev->next, n);
+	rcu_assign_pointer(hlist_next_rcu(prev), n);
 	if (n->next)
 		n->next->pprev = &n->next;
 }
 
-#define __hlist_for_each_rcu(pos, head)			\
-	for (pos = rcu_dereference((head)->first);	\
-	     pos && ({ prefetch(pos->next); 1; });	\
-	     pos = rcu_dereference(pos->next))
+#define __hlist_for_each_rcu(pos, head)				\
+	for (pos = rcu_dereference(hlist_first_rcu(head));	\
+	     pos && ({ prefetch(pos->next); 1; });		\
+	     pos = rcu_dereference(hlist_next_rcu(pos)))
 
 /**
  * hlist_for_each_entry_rcu - iterate over rcu list of given type
@@ -422,11 +446,11 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
-	for (pos = rcu_dereference_raw((head)->first);			 \
+#define hlist_for_each_entry_rcu(tpos, pos, head, member)		\
+	for (pos = rcu_dereference_raw(hlist_first_rcu(head));		\
 		pos && ({ prefetch(pos->next); 1; }) &&			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference_raw(pos->next))
+		pos = rcu_dereference_raw(hlist_next_rcu(pos)))
 
 /**
  * hlist_for_each_entry_rcu_bh - iterate over rcu list of given type
diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index b70ffe5..2ae1371 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -37,6 +37,12 @@ static inline void hlist_nulls_del_init_rcu(struct hlist_nulls_node *n)
 	}
 }
 
+#define hlist_nulls_first_rcu(head) \
+	(*((struct hlist_nulls_node __rcu __force **)&(head)->first))
+
+#define hlist_nulls_next_rcu(node) \
+	(*((struct hlist_nulls_node __rcu __force **)&(node)->next))
+
 /**
  * hlist_nulls_del_rcu - deletes entry from hash list without re-initialization
  * @n: the element to delete from the hash list.
@@ -88,7 +94,7 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
 
 	n->next = first;
 	n->pprev = &h->first;
-	rcu_assign_pointer(h->first, n);
+	rcu_assign_pointer(hlist_nulls_first_rcu(h), n);
 	if (!is_a_nulls(first))
 		first->pprev = &n->next;
 }
@@ -100,11 +106,11 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
  * @member:	the name of the hlist_nulls_node within the struct.
  *
  */
-#define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member) \
-	for (pos = rcu_dereference_raw((head)->first);			 \
-		(!is_a_nulls(pos)) &&			\
+#define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member)			\
+	for (pos = rcu_dereference_raw(hlist_nulls_first_rcu(head));		\
+		(!is_a_nulls(pos)) &&						\
 		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference_raw(pos->next))
+		pos = rcu_dereference_raw(hlist_nulls_next_rcu(pos)))
 
 #endif
 #endif
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 83af1f8..03cda7b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -41,11 +41,15 @@
 #include <linux/lockdep.h>
 #include <linux/completion.h>
 #include <linux/debugobjects.h>
+#include <linux/compiler.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
+#define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
+#define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
+
 /**
  * struct rcu_head - callback structure for use with RCU
  * @next: next update requests in a list
@@ -57,29 +61,94 @@ struct rcu_head {
 };
 
 /* Exported common interfaces */
-extern void rcu_barrier(void);
+extern void call_rcu_sched(struct rcu_head *head,
+			   void (*func)(struct rcu_head *rcu));
+extern void synchronize_sched(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
 extern void synchronize_sched_expedited(void);
 extern int sched_expedited_torture_stats(char *page);
 
+static inline void __rcu_read_lock_bh(void)
+{
+	local_bh_disable();
+}
+
+static inline void __rcu_read_unlock_bh(void)
+{
+	local_bh_enable();
+}
+
+#ifdef CONFIG_PREEMPT_RCU
+
+extern void __rcu_read_lock(void);
+extern void __rcu_read_unlock(void);
+void synchronize_rcu(void);
+
+/*
+ * Defined as a macro as it is a very low level header included from
+ * areas that don't even know about current.  This gives the rcu_read_lock()
+ * nesting depth, but makes sense only if CONFIG_PREEMPT_RCU -- in other
+ * types of kernel builds, the rcu_read_lock() nesting depth is unknowable.
+ */
+#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
+
+#else /* #ifdef CONFIG_PREEMPT_RCU */
+
+static inline void __rcu_read_lock(void)
+{
+	preempt_disable();
+}
+
+static inline void __rcu_read_unlock(void)
+{
+	preempt_enable();
+}
+
+static inline void synchronize_rcu(void)
+{
+	synchronize_sched();
+}
+
+static inline int rcu_preempt_depth(void)
+{
+	return 0;
+}
+
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+
 /* Internal to kernel */
 extern void rcu_init(void);
+extern void rcu_sched_qs(int cpu);
+extern void rcu_bh_qs(int cpu);
+extern void rcu_check_callbacks(int cpu, int user);
+struct notifier_block;
+
+#ifdef CONFIG_NO_HZ
+
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
+
+#else /* #ifdef CONFIG_NO_HZ */
+
+static inline void rcu_enter_nohz(void)
+{
+}
+
+static inline void rcu_exit_nohz(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_NO_HZ */
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
-#elif defined(CONFIG_TINY_RCU)
+#elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
 #include <linux/rcutiny.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
-#define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
-#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
-#define INIT_RCU_HEAD(ptr) do { \
-       (ptr)->next = NULL; (ptr)->func = NULL; \
-} while (0)
-
 /*
  * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
  * initialization and destruction of rcu_head on the stack. rcu_head structures
@@ -120,14 +189,15 @@ extern struct lockdep_map rcu_sched_lock_map;
 extern int debug_lockdep_rcu_enabled(void);
 
 /**
- * rcu_read_lock_held - might we be in RCU read-side critical section?
+ * rcu_read_lock_held() - might we be in RCU read-side critical section?
  *
  * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an RCU
  * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
  * this assumes we are in an RCU read-side critical section unless it can
- * prove otherwise.
+ * prove otherwise.  This is useful for debug checks in functions that
+ * require that they be called within an RCU read-side critical section.
  *
- * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
  */
 static inline int rcu_read_lock_held(void)
@@ -144,14 +214,16 @@ static inline int rcu_read_lock_held(void)
 extern int rcu_read_lock_bh_held(void);
 
 /**
- * rcu_read_lock_sched_held - might we be in RCU-sched read-side critical section?
+ * rcu_read_lock_sched_held() - might we be in RCU-sched read-side critical section?
  *
  * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an
  * RCU-sched read-side critical section.  In absence of
  * CONFIG_DEBUG_LOCK_ALLOC, this assumes we are in an RCU-sched read-side
  * critical section unless it can prove otherwise.  Note that disabling
  * of preemption (including disabling irqs) counts as an RCU-sched
- * read-side critical section.
+ * read-side critical section.  This is useful for debug checks in functions
+ * that required that they be called within an RCU-sched read-side
+ * critical section.
  *
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
@@ -211,7 +283,11 @@ static inline int rcu_read_lock_sched_held(void)
 
 extern int rcu_my_thread_group_empty(void);
 
-#define __do_rcu_dereference_check(c)					\
+/**
+ * rcu_lockdep_assert - emit lockdep splat if specified condition not met
+ * @c: condition to check
+ */
+#define rcu_lockdep_assert(c)						\
 	do {								\
 		static bool __warned;					\
 		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
@@ -220,41 +296,163 @@ extern int rcu_my_thread_group_empty(void);
 		}							\
 	} while (0)
 
+#else /* #ifdef CONFIG_PROVE_RCU */
+
+#define rcu_lockdep_assert(c) do { } while (0)
+
+#endif /* #else #ifdef CONFIG_PROVE_RCU */
+
+/*
+ * Helper functions for rcu_dereference_check(), rcu_dereference_protected()
+ * and rcu_assign_pointer().  Some of these could be folded into their
+ * callers, but they are left separate in order to ease introduction of
+ * multiple flavors of pointers to match the multiple flavors of RCU
+ * (e.g., __rcu_bh, * __rcu_sched, and __srcu), should this make sense in
+ * the future.
+ */
+
+#ifdef __CHECKER__
+#define rcu_dereference_sparse(p, space) \
+	((void)(((typeof(*p) space *)p) == p))
+#else /* #ifdef __CHECKER__ */
+#define rcu_dereference_sparse(p, space)
+#endif /* #else #ifdef __CHECKER__ */
+
+#define __rcu_access_pointer(p, space) \
+	({ \
+		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
+		rcu_dereference_sparse(p, space); \
+		((typeof(*p) __force __kernel *)(_________p1)); \
+	})
+#define __rcu_dereference_check(p, c, space) \
+	({ \
+		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
+		rcu_lockdep_assert(c); \
+		rcu_dereference_sparse(p, space); \
+		smp_read_barrier_depends(); \
+		((typeof(*p) __force __kernel *)(_________p1)); \
+	})
+#define __rcu_dereference_protected(p, c, space) \
+	({ \
+		rcu_lockdep_assert(c); \
+		rcu_dereference_sparse(p, space); \
+		((typeof(*p) __force __kernel *)(p)); \
+	})
+
+#define __rcu_dereference_index_check(p, c) \
+	({ \
+		typeof(p) _________p1 = ACCESS_ONCE(p); \
+		rcu_lockdep_assert(c); \
+		smp_read_barrier_depends(); \
+		(_________p1); \
+	})
+#define __rcu_assign_pointer(p, v, space) \
+	({ \
+		if (!__builtin_constant_p(v) || \
+		    ((v) != NULL)) \
+			smp_wmb(); \
+		(p) = (typeof(*v) __force space *)(v); \
+	})
+
+
+/**
+ * rcu_access_pointer() - fetch RCU pointer with no dereferencing
+ * @p: The pointer to read
+ *
+ * Return the value of the specified RCU-protected pointer, but omit the
+ * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
+ * when the value of this pointer is accessed, but the pointer is not
+ * dereferenced, for example, when testing an RCU-protected pointer against
+ * NULL.  Although rcu_access_pointer() may also be used in cases where
+ * update-side locks prevent the value of the pointer from changing, you
+ * should instead use rcu_dereference_protected() for this use case.
+ */
+#define rcu_access_pointer(p) __rcu_access_pointer((p), __rcu)
+
 /**
- * rcu_dereference_check - rcu_dereference with debug checking
+ * rcu_dereference_check() - rcu_dereference with debug checking
  * @p: The pointer to read, prior to dereferencing
  * @c: The conditions under which the dereference will take place
  *
  * Do an rcu_dereference(), but check that the conditions under which the
- * dereference will take place are correct.  Typically the conditions indicate
- * the various locking conditions that should be held at that point.  The check
- * should return true if the conditions are satisfied.
+ * dereference will take place are correct.  Typically the conditions
+ * indicate the various locking conditions that should be held at that
+ * point.  The check should return true if the conditions are satisfied.
+ * An implicit check for being in an RCU read-side critical section
+ * (rcu_read_lock()) is included.
  *
  * For example:
  *
- *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
- *					      lockdep_is_held(&foo->lock));
+ *	bar = rcu_dereference_check(foo->bar, lockdep_is_held(&foo->lock));
  *
  * could be used to indicate to lockdep that foo->bar may only be dereferenced
- * if either the RCU read lock is held, or that the lock required to replace
+ * if either rcu_read_lock() is held, or that the lock required to replace
  * the bar struct at foo->bar is held.
  *
  * Note that the list of conditions may also include indications of when a lock
  * need not be held, for example during initialisation or destruction of the
  * target struct:
  *
- *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
- *					      lockdep_is_held(&foo->lock) ||
+ *	bar = rcu_dereference_check(foo->bar, lockdep_is_held(&foo->lock) ||
  *					      atomic_read(&foo->usage) == 0);
+ *
+ * Inserts memory barriers on architectures that require them
+ * (currently only the Alpha), prevents the compiler from refetching
+ * (and from merging fetches), and, more importantly, documents exactly
+ * which pointers are protected by RCU and checks that the pointer is
+ * annotated as __rcu.
  */
 #define rcu_dereference_check(p, c) \
-	({ \
-		__do_rcu_dereference_check(c); \
-		rcu_dereference_raw(p); \
-	})
+	__rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)
+
+/**
+ * rcu_dereference_bh_check() - rcu_dereference_bh with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * This is the RCU-bh counterpart to rcu_dereference_check().
+ */
+#define rcu_dereference_bh_check(p, c) \
+	__rcu_dereference_check((p), rcu_read_lock_bh_held() || (c), __rcu)
 
 /**
- * rcu_dereference_protected - fetch RCU pointer when updates prevented
+ * rcu_dereference_sched_check() - rcu_dereference_sched with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * This is the RCU-sched counterpart to rcu_dereference_check().
+ */
+#define rcu_dereference_sched_check(p, c) \
+	__rcu_dereference_check((p), rcu_read_lock_sched_held() || (c), \
+				__rcu)
+
+#define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
+
+/**
+ * rcu_dereference_index_check() - rcu_dereference for indices with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * Similar to rcu_dereference_check(), but omits the sparse checking.
+ * This allows rcu_dereference_index_check() to be used on integers,
+ * which can then be used as array indices.  Attempting to use
+ * rcu_dereference_check() on an integer will give compiler warnings
+ * because the sparse address-space mechanism relies on dereferencing
+ * the RCU-protected pointer.  Dereferencing integers is not something
+ * that even gcc will put up with.
+ *
+ * Note that this function does not implicitly check for RCU read-side
+ * critical sections.  If this function gains lots of uses, it might
+ * make sense to provide versions for each flavor of RCU, but it does
+ * not make sense as of early 2010.
+ */
+#define rcu_dereference_index_check(p, c) \
+	__rcu_dereference_index_check((p), (c))
+
+/**
+ * rcu_dereference_protected() - fetch RCU pointer when updates prevented
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
  *
  * Return the value of the specified RCU-protected pointer, but omit
  * both the smp_read_barrier_depends() and the ACCESS_ONCE().  This
@@ -263,35 +461,61 @@ extern int rcu_my_thread_group_empty(void);
  * prevent the compiler from repeating this reference or combining it
  * with other references, so it should not be used without protection
  * of appropriate locks.
+ *
+ * This function is only for update-side use.  Using this function
+ * when protected only by rcu_read_lock() will result in infrequent
+ * but very ugly failures.
  */
 #define rcu_dereference_protected(p, c) \
-	({ \
-		__do_rcu_dereference_check(c); \
-		(p); \
-	})
+	__rcu_dereference_protected((p), (c), __rcu)
 
-#else /* #ifdef CONFIG_PROVE_RCU */
+/**
+ * rcu_dereference_bh_protected() - fetch RCU-bh pointer when updates prevented
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * This is the RCU-bh counterpart to rcu_dereference_protected().
+ */
+#define rcu_dereference_bh_protected(p, c) \
+	__rcu_dereference_protected((p), (c), __rcu)
 
-#define rcu_dereference_check(p, c)	rcu_dereference_raw(p)
-#define rcu_dereference_protected(p, c) (p)
+/**
+ * rcu_dereference_sched_protected() - fetch RCU-sched pointer when updates prevented
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * This is the RCU-sched counterpart to rcu_dereference_protected().
+ */
+#define rcu_dereference_sched_protected(p, c) \
+	__rcu_dereference_protected((p), (c), __rcu)
 
-#endif /* #else #ifdef CONFIG_PROVE_RCU */
 
 /**
- * rcu_access_pointer - fetch RCU pointer with no dereferencing
+ * rcu_dereference() - fetch RCU-protected pointer for dereferencing
+ * @p: The pointer to read, prior to dereferencing
  *
- * Return the value of the specified RCU-protected pointer, but omit the
- * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
- * when the value of this pointer is accessed, but the pointer is not
- * dereferenced, for example, when testing an RCU-protected pointer against
- * NULL.  This may also be used in cases where update-side locks prevent
- * the value of the pointer from changing, but rcu_dereference_protected()
- * is a lighter-weight primitive for this use case.
+ * This is a simple wrapper around rcu_dereference_check().
+ */
+#define rcu_dereference(p) rcu_dereference_check(p, 0)
+
+/**
+ * rcu_dereference_bh() - fetch an RCU-bh-protected pointer for dereferencing
+ * @p: The pointer to read, prior to dereferencing
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define rcu_dereference_bh(p) rcu_dereference_bh_check(p, 0)
+
+/**
+ * rcu_dereference_sched() - fetch RCU-sched-protected pointer for dereferencing
+ * @p: The pointer to read, prior to dereferencing
+ *
+ * Makes rcu_dereference_check() do the dirty work.
  */
-#define rcu_access_pointer(p)	ACCESS_ONCE(p)
+#define rcu_dereference_sched(p) rcu_dereference_sched_check(p, 0)
 
 /**
- * rcu_read_lock - mark the beginning of an RCU read-side critical section.
+ * rcu_read_lock() - mark the beginning of an RCU read-side critical section
  *
  * When synchronize_rcu() is invoked on one CPU while other CPUs
  * are within RCU read-side critical sections, then the
@@ -302,7 +526,7 @@ extern int rcu_my_thread_group_empty(void);
  * until after the all the other CPUs exit their critical sections.
  *
  * Note, however, that RCU callbacks are permitted to run concurrently
- * with RCU read-side critical sections.  One way that this can happen
+ * with new RCU read-side critical sections.  One way that this can happen
  * is via the following sequence of events: (1) CPU 0 enters an RCU
  * read-side critical section, (2) CPU 1 invokes call_rcu() to register
  * an RCU callback, (3) CPU 0 exits the RCU read-side critical section,
@@ -317,7 +541,20 @@ extern int rcu_my_thread_group_empty(void);
  * will be deferred until the outermost RCU read-side critical section
  * completes.
  *
- * It is illegal to block while in an RCU read-side critical section.
+ * You can avoid reading and understanding the next paragraph by
+ * following this rule: don't put anything in an rcu_read_lock() RCU
+ * read-side critical section that would block in a !PREEMPT kernel.
+ * But if you want the full story, read on!
+ *
+ * In non-preemptible RCU implementations (TREE_RCU and TINY_RCU), it
+ * is illegal to block while in an RCU read-side critical section.  In
+ * preemptible RCU implementations (TREE_PREEMPT_RCU and TINY_PREEMPT_RCU)
+ * in CONFIG_PREEMPT kernel builds, RCU read-side critical sections may
+ * be preempted, but explicit blocking is illegal.  Finally, in preemptible
+ * RCU implementations in real-time (CONFIG_PREEMPT_RT) kernel builds,
+ * RCU read-side critical sections may be preempted and they may also
+ * block, but only when acquiring spinlocks that are subject to priority
+ * inheritance.
  */
 static inline void rcu_read_lock(void)
 {
@@ -337,7 +574,7 @@ static inline void rcu_read_lock(void)
  */
 
 /**
- * rcu_read_unlock - marks the end of an RCU read-side critical section.
+ * rcu_read_unlock() - marks the end of an RCU read-side critical section.
  *
  * See rcu_read_lock() for more information.
  */
@@ -349,15 +586,16 @@ static inline void rcu_read_unlock(void)
 }
 
 /**
- * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
+ * rcu_read_lock_bh() - mark the beginning of an RCU-bh critical section
  *
  * This is equivalent of rcu_read_lock(), but to be used when updates
- * are being done using call_rcu_bh(). Since call_rcu_bh() callbacks
- * consider completion of a softirq handler to be a quiescent state,
- * a process in RCU read-side critical section must be protected by
- * disabling softirqs. Read-side critical sections in interrupt context
- * can use just rcu_read_lock().
- *
+ * are being done using call_rcu_bh() or synchronize_rcu_bh(). Since
+ * both call_rcu_bh() and synchronize_rcu_bh() consider completion of a
+ * softirq handler to be a quiescent state, a process in RCU read-side
+ * critical section must be protected by disabling softirqs. Read-side
+ * critical sections in interrupt context can use just rcu_read_lock(),
+ * though this should at least be commented to avoid confusing people
+ * reading the code.
  */
 static inline void rcu_read_lock_bh(void)
 {
@@ -379,13 +617,12 @@ static inline void rcu_read_unlock_bh(void)
 }
 
 /**
- * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
+ * rcu_read_lock_sched() - mark the beginning of a RCU-sched critical section
  *
- * Should be used with either
- * - synchronize_sched()
- * or
- * - call_rcu_sched() and rcu_barrier_sched()
- * on the write-side to insure proper synchronization.
+ * This is equivalent of rcu_read_lock(), but to be used when updates
+ * are being done using call_rcu_sched() or synchronize_rcu_sched().
+ * Read-side critical sections can also be introduced by anything that
+ * disables preemption, including local_irq_disable() and friends.
  */
 static inline void rcu_read_lock_sched(void)
 {
@@ -420,54 +657,14 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 	preempt_enable_notrace();
 }
 
-
 /**
- * rcu_dereference_raw - fetch an RCU-protected pointer
+ * rcu_assign_pointer() - assign to RCU-protected pointer
+ * @p: pointer to assign to
+ * @v: value to assign (publish)
  *
- * The caller must be within some flavor of RCU read-side critical
- * section, or must be otherwise preventing the pointer from changing,
- * for example, by holding an appropriate lock.  This pointer may later
- * be safely dereferenced.  It is the caller's responsibility to have
- * done the right thing, as this primitive does no checking of any kind.
- *
- * Inserts memory barriers on architectures that require them
- * (currently only the Alpha), and, more importantly, documents
- * exactly which pointers are protected by RCU.
- */
-#define rcu_dereference_raw(p)	({ \
-				typeof(p) _________p1 = ACCESS_ONCE(p); \
-				smp_read_barrier_depends(); \
-				(_________p1); \
-				})
-
-/**
- * rcu_dereference - fetch an RCU-protected pointer, checking for RCU
- *
- * Makes rcu_dereference_check() do the dirty work.
- */
-#define rcu_dereference(p) \
-	rcu_dereference_check(p, rcu_read_lock_held())
-
-/**
- * rcu_dereference_bh - fetch an RCU-protected pointer, checking for RCU-bh
- *
- * Makes rcu_dereference_check() do the dirty work.
- */
-#define rcu_dereference_bh(p) \
-		rcu_dereference_check(p, rcu_read_lock_bh_held() || irqs_disabled())
-
-/**
- * rcu_dereference_sched - fetch RCU-protected pointer, checking for RCU-sched
- *
- * Makes rcu_dereference_check() do the dirty work.
- */
-#define rcu_dereference_sched(p) \
-		rcu_dereference_check(p, rcu_read_lock_sched_held())
-
-/**
- * rcu_assign_pointer - assign (publicize) a pointer to a newly
- * initialized structure that will be dereferenced by RCU read-side
- * critical sections.  Returns the value assigned.
+ * Assigns the specified value to the specified RCU-protected
+ * pointer, ensuring that any concurrent RCU readers will see
+ * any prior initialization.  Returns the value assigned.
  *
  * Inserts memory barriers on architectures that require them
  * (pretty much all of them other than x86), and also prevents
@@ -476,14 +673,17 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * call documents which pointers will be dereferenced by RCU read-side
  * code.
  */
-
 #define rcu_assign_pointer(p, v) \
-	({ \
-		if (!__builtin_constant_p(v) || \
-		    ((v) != NULL)) \
-			smp_wmb(); \
-		(p) = (v); \
-	})
+	__rcu_assign_pointer((p), (v), __rcu)
+
+/**
+ * RCU_INIT_POINTER() - initialize an RCU protected pointer
+ *
+ * Initialize an RCU-protected pointer in such a way to avoid RCU-lockdep
+ * splats.
+ */
+#define RCU_INIT_POINTER(p, v) \
+		p = (typeof(*v) __force __rcu *)(v)
 
 /* Infrastructure to implement the synchronize_() primitives. */
 
@@ -494,26 +694,37 @@ struct rcu_synchronize {
 
 extern void wakeme_after_rcu(struct rcu_head  *head);
 
+#ifdef CONFIG_PREEMPT_RCU
+
 /**
- * call_rcu - Queue an RCU callback for invocation after a grace period.
+ * call_rcu() - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
+ * @func: actual callback function to be invoked after the grace period
  *
- * The update function will be invoked some time after a full grace
- * period elapses, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all pre-existing RCU read-side
+ * critical sections have completed.  However, the callback function
+ * might well execute concurrently with RCU read-side critical sections
+ * that started after call_rcu() was invoked.  RCU read-side critical
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
 extern void call_rcu(struct rcu_head *head,
 			      void (*func)(struct rcu_head *head));
 
+#else /* #ifdef CONFIG_PREEMPT_RCU */
+
+/* In classic RCU, call_rcu() is just call_rcu_sched(). */
+#define	call_rcu	call_rcu_sched
+
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+
 /**
- * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
+ * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
  * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
+ * @func: actual callback function to be invoked after the grace period
  *
- * The update function will be invoked some time after a full grace
+ * The callback function will be invoked some time after a full grace
  * period elapses, in other words after all currently executing RCU
  * read-side critical sections have completed. call_rcu_bh() assumes
  * that the read-side critical sections end on completion of a softirq
@@ -566,37 +777,4 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
-#ifndef CONFIG_PROVE_RCU
-#define __do_rcu_dereference_check(c) do { } while (0)
-#endif /* #ifdef CONFIG_PROVE_RCU */
-
-#define __rcu_dereference_index_check(p, c) \
-	({ \
-		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		__do_rcu_dereference_check(c); \
-		smp_read_barrier_depends(); \
-		(_________p1); \
-	})
-
-/**
- * rcu_dereference_index_check() - rcu_dereference for indices with debug checking
- * @p: The pointer to read, prior to dereferencing
- * @c: The conditions under which the dereference will take place
- *
- * Similar to rcu_dereference_check(), but omits the sparse checking.
- * This allows rcu_dereference_index_check() to be used on integers,
- * which can then be used as array indices.  Attempting to use
- * rcu_dereference_check() on an integer will give compiler warnings
- * because the sparse address-space mechanism relies on dereferencing
- * the RCU-protected pointer.  Dereferencing integers is not something
- * that even gcc will put up with.
- *
- * Note that this function does not implicitly check for RCU read-side
- * critical sections.  If this function gains lots of uses, it might
- * make sense to provide versions for each flavor of RCU, but it does
- * not make sense as of early 2010.
- */
-#define rcu_dereference_index_check(p, c) \
-	__rcu_dereference_index_check((p), (c))
-
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index e2e8931..13877cb 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,103 +27,101 @@
 
 #include <linux/cache.h>
 
-void rcu_sched_qs(int cpu);
-void rcu_bh_qs(int cpu);
-static inline void rcu_note_context_switch(int cpu)
-{
-	rcu_sched_qs(cpu);
-}
+#define rcu_init_sched()	do { } while (0)
 
-#define __rcu_read_lock()	preempt_disable()
-#define __rcu_read_unlock()	preempt_enable()
-#define __rcu_read_lock_bh()	local_bh_disable()
-#define __rcu_read_unlock_bh()	local_bh_enable()
-#define call_rcu_sched		call_rcu
+#ifdef CONFIG_TINY_RCU
 
-#define rcu_init_sched()	do { } while (0)
-extern void rcu_check_callbacks(int cpu, int user);
+static inline void synchronize_rcu_expedited(void)
+{
+	synchronize_sched();	/* Only one CPU, so pretty fast anyway!!! */
+}
 
-static inline int rcu_needs_cpu(int cpu)
+static inline void rcu_barrier(void)
 {
-	return 0;
+	rcu_barrier_sched();  /* Only one CPU, so only one list of callbacks! */
 }
 
-/*
- * Return the number of grace periods.
- */
-static inline long rcu_batches_completed(void)
+#else /* #ifdef CONFIG_TINY_RCU */
+
+void rcu_barrier(void);
+void synchronize_rcu_expedited(void);
+
+#endif /* #else #ifdef CONFIG_TINY_RCU */
+
+static inline void synchronize_rcu_bh(void)
 {
-	return 0;
+	synchronize_sched();
 }
 
-/*
- * Return the number of bottom-half grace periods.
- */
-static inline long rcu_batches_completed_bh(void)
+static inline void synchronize_rcu_bh_expedited(void)
 {
-	return 0;
+	synchronize_sched();
 }
 
-static inline void rcu_force_quiescent_state(void)
+#ifdef CONFIG_TINY_RCU
+
+static inline void rcu_preempt_note_context_switch(void)
 {
 }
 
-static inline void rcu_bh_force_quiescent_state(void)
+static inline void exit_rcu(void)
 {
 }
 
-static inline void rcu_sched_force_quiescent_state(void)
+static inline int rcu_needs_cpu(int cpu)
 {
+	return 0;
 }
 
-extern void synchronize_sched(void);
+#else /* #ifdef CONFIG_TINY_RCU */
+
+void rcu_preempt_note_context_switch(void);
+extern void exit_rcu(void);
+int rcu_preempt_needs_cpu(void);
 
-static inline void synchronize_rcu(void)
+static inline int rcu_needs_cpu(int cpu)
 {
-	synchronize_sched();
+	return rcu_preempt_needs_cpu();
 }
 
-static inline void synchronize_rcu_bh(void)
+#endif /* #else #ifdef CONFIG_TINY_RCU */
+
+static inline void rcu_note_context_switch(int cpu)
 {
-	synchronize_sched();
+	rcu_sched_qs(cpu);
+	rcu_preempt_note_context_switch();
 }
 
-static inline void synchronize_rcu_expedited(void)
+/*
+ * Return the number of grace periods.
+ */
+static inline long rcu_batches_completed(void)
 {
-	synchronize_sched();
+	return 0;
 }
 
-static inline void synchronize_rcu_bh_expedited(void)
+/*
+ * Return the number of bottom-half grace periods.
+ */
+static inline long rcu_batches_completed_bh(void)
 {
-	synchronize_sched();
+	return 0;
 }
 
-struct notifier_block;
-
-#ifdef CONFIG_NO_HZ
-
-extern void rcu_enter_nohz(void);
-extern void rcu_exit_nohz(void);
-
-#else /* #ifdef CONFIG_NO_HZ */
-
-static inline void rcu_enter_nohz(void)
+static inline void rcu_force_quiescent_state(void)
 {
 }
 
-static inline void rcu_exit_nohz(void)
+static inline void rcu_bh_force_quiescent_state(void)
 {
 }
 
-#endif /* #else #ifdef CONFIG_NO_HZ */
-
-static inline void exit_rcu(void)
+static inline void rcu_sched_force_quiescent_state(void)
 {
 }
 
-static inline int rcu_preempt_depth(void)
+static inline void rcu_cpu_stall_reset(void)
 {
-	return 0;
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c0ed1c0..95518e6 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,64 +30,23 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
-struct notifier_block;
-
-extern void rcu_sched_qs(int cpu);
-extern void rcu_bh_qs(int cpu);
 extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
+extern void rcu_cpu_stall_reset(void);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
-extern void __rcu_read_lock(void);
-extern void __rcu_read_unlock(void);
-extern void synchronize_rcu(void);
 extern void exit_rcu(void);
 
-/*
- * Defined as macro as it is a very low level header
- * included from areas that don't even know about current
- */
-#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
-
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-static inline void __rcu_read_lock(void)
-{
-	preempt_disable();
-}
-
-static inline void __rcu_read_unlock(void)
-{
-	preempt_enable();
-}
-
-#define synchronize_rcu synchronize_sched
-
 static inline void exit_rcu(void)
 {
 }
 
-static inline int rcu_preempt_depth(void)
-{
-	return 0;
-}
-
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-static inline void __rcu_read_lock_bh(void)
-{
-	local_bh_disable();
-}
-static inline void __rcu_read_unlock_bh(void)
-{
-	local_bh_enable();
-}
-
-extern void call_rcu_sched(struct rcu_head *head,
-			   void (*func)(struct rcu_head *rcu));
 extern void synchronize_rcu_bh(void);
-extern void synchronize_sched(void);
 extern void synchronize_rcu_expedited(void);
 
 static inline void synchronize_rcu_bh_expedited(void)
@@ -95,7 +54,7 @@ static inline void synchronize_rcu_bh_expedited(void)
 	synchronize_sched_expedited();
 }
 
-extern void rcu_check_callbacks(int cpu, int user);
+extern void rcu_barrier(void);
 
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
@@ -104,18 +63,6 @@ extern void rcu_force_quiescent_state(void);
 extern void rcu_bh_force_quiescent_state(void);
 extern void rcu_sched_force_quiescent_state(void);
 
-#ifdef CONFIG_NO_HZ
-void rcu_enter_nohz(void);
-void rcu_exit_nohz(void);
-#else /* CONFIG_NO_HZ */
-static inline void rcu_enter_nohz(void)
-{
-}
-static inline void rcu_exit_nohz(void)
-{
-}
-#endif /* CONFIG_NO_HZ */
-
 /* A context switch is a grace period for RCU-sched and RCU-bh. */
 static inline int rcu_blocking_is_gp(void)
 {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1e2a6db..e18473f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1202,11 +1202,13 @@ struct task_struct {
 	unsigned int policy;
 	cpumask_t cpus_allowed;
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
 	char rcu_read_unlock_special;
-	struct rcu_node *rcu_blocked_node;
 	struct list_head rcu_node_entry;
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	struct rcu_node *rcu_blocked_node;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
@@ -1288,9 +1290,9 @@ struct task_struct {
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	const struct cred *real_cred;	/* objective and real subjective task
+	const struct cred __rcu *real_cred; /* objective and real subjective task
 					 * credentials (COW) */
-	const struct cred *cred;	/* effective (overridable) subjective task
+	const struct cred __rcu *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
@@ -1418,7 +1420,7 @@ struct task_struct {
 #endif
 #ifdef CONFIG_CGROUPS
 	/* Control Group info protected by css_set_lock */
-	struct css_set *cgroups;
+	struct css_set __rcu *cgroups;
 	/* cg_list protected by css_set_lock and tsk->alloc_lock */
 	struct list_head cg_list;
 #endif
@@ -1740,7 +1742,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
 #define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
@@ -1749,7 +1751,9 @@ static inline void rcu_copy_process(struct task_struct *p)
 {
 	p->rcu_read_lock_nesting = 0;
 	p->rcu_read_unlock_special = 0;
+#ifdef CONFIG_TREE_PREEMPT_RCU
 	p->rcu_blocked_node = NULL;
+#endif
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 4d5d2f5..58971e8 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -108,19 +108,43 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /**
- * srcu_dereference - fetch SRCU-protected pointer with checking
+ * srcu_dereference_check - fetch SRCU-protected pointer for later dereferencing
+ * @p: the pointer to fetch and protect for later dereferencing
+ * @sp: pointer to the srcu_struct, which is used to check that we
+ *	really are in an SRCU read-side critical section.
+ * @c: condition to check for update-side use
  *
- * Makes rcu_dereference_check() do the dirty work.
+ * If PROVE_RCU is enabled, invoking this outside of an RCU read-side
+ * critical section will result in an RCU-lockdep splat, unless @c evaluates
+ * to 1.  The @c argument will normally be a logical expression containing
+ * lockdep_is_held() calls.
  */
-#define srcu_dereference(p, sp) \
-		rcu_dereference_check(p, srcu_read_lock_held(sp))
+#define srcu_dereference_check(p, sp, c) \
+	__rcu_dereference_check((p), srcu_read_lock_held(sp) || (c), __rcu)
+
+/**
+ * srcu_dereference - fetch SRCU-protected pointer for later dereferencing
+ * @p: the pointer to fetch and protect for later dereferencing
+ * @sp: pointer to the srcu_struct, which is used to check that we
+ *	really are in an SRCU read-side critical section.
+ *
+ * Makes rcu_dereference_check() do the dirty work.  If PROVE_RCU
+ * is enabled, invoking this outside of an RCU read-side critical
+ * section will result in an RCU-lockdep splat.
+ */
+#define srcu_dereference(p, sp) srcu_dereference_check((p), (sp), 0)
 
 /**
  * srcu_read_lock - register a new reader for an SRCU-protected structure.
  * @sp: srcu_struct in which to register the new reader.
  *
  * Enter an SRCU read-side critical section.  Note that SRCU read-side
- * critical sections may be nested.
+ * critical sections may be nested.  However, it is illegal to
+ * call anything that waits on an SRCU grace period for the same
+ * srcu_struct, whether directly or indirectly.  Please note that
+ * one way to indirectly wait on an SRCU grace period is to acquire
+ * a mutex that is held elsewhere while calling synchronize_srcu() or
+ * synchronize_srcu_expedited().
  */
 static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 {
diff --git a/include/linux/sunrpc/auth_gss.h b/include/linux/sunrpc/auth_gss.h
index 671538d..8eee9db 100644
--- a/include/linux/sunrpc/auth_gss.h
+++ b/include/linux/sunrpc/auth_gss.h
@@ -69,7 +69,7 @@ struct gss_cl_ctx {
 	enum rpc_gss_proc	gc_proc;
 	u32			gc_seq;
 	spinlock_t		gc_seq_lock;
-	struct gss_ctx		*gc_gss_ctx;
+	struct gss_ctx __rcu	*gc_gss_ctx;
 	struct xdr_netobj	gc_wire_ctx;
 	u32			gc_win;
 	unsigned long		gc_expiry;
@@ -80,7 +80,7 @@ struct gss_upcall_msg;
 struct gss_cred {
 	struct rpc_cred		gc_base;
 	enum rpc_gss_svc	gc_service;
-	struct gss_cl_ctx	*gc_ctx;
+	struct gss_cl_ctx __rcu	*gc_ctx;
 	struct gss_upcall_msg	*gc_upcall;
 	unsigned long		gc_upcall_timestamp;
 	unsigned char		gc_machine_cred : 1;
diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index ef6c24a..a4dc5b0 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -51,7 +51,8 @@ static inline u32 task_cls_classid(struct task_struct *p)
 		return 0;
 
 	rcu_read_lock();
-	id = rcu_dereference(net_cls_subsys_id);
+	id = rcu_dereference_index_check(net_cls_subsys_id,
+					 rcu_read_lock_held());
 	if (id >= 0)
 		classid = container_of(task_subsys_state(p, id),
 				       struct cgroup_cls_state, css)->classid;
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index e624dae..caf17db 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -75,7 +75,7 @@ struct nf_conntrack_helper;
 /* nf_conn feature for connections that have a helper */
 struct nf_conn_help {
 	/* Helper. if any */
-	struct nf_conntrack_helper *helper;
+	struct nf_conntrack_helper __rcu *helper;
 
 	union nf_conntrack_help help;
 
diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..a619a1a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -340,6 +340,7 @@ choice
 
 config TREE_RCU
 	bool "Tree-based hierarchical RCU"
+	depends on !PREEMPT && SMP
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP system with hundreds or
@@ -347,7 +348,7 @@ config TREE_RCU
 	  smaller systems.
 
 config TREE_PREEMPT_RCU
-	bool "Preemptable tree-based hierarchical RCU"
+	bool "Preemptible tree-based hierarchical RCU"
 	depends on PREEMPT
 	help
 	  This option selects the RCU implementation that is
@@ -365,8 +366,22 @@ config TINY_RCU
 	  is not required.  This option greatly reduces the
 	  memory footprint of RCU.
 
+config TINY_PREEMPT_RCU
+	bool "Preemptible UP-only small-memory-footprint RCU"
+	depends on !SMP && PREEMPT
+	help
+	  This option selects the RCU implementation that is designed
+	  for real-time UP systems.  This option greatly reduces the
+	  memory footprint of RCU.
+
 endchoice
 
+config PREEMPT_RCU
+	def_bool ( TREE_PREEMPT_RCU || TINY_PREEMPT_RCU )
+	help
+	  This option enables preemptible-RCU code that is common between
+	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
+
 config RCU_TRACE
 	bool "Enable tracing for RCU"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
@@ -387,9 +402,12 @@ config RCU_FANOUT
 	help
 	  This option controls the fanout of hierarchical implementations
 	  of RCU, allowing RCU to work efficiently on machines with
-	  large numbers of CPUs.  This value must be at least the cube
-	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
-	  systems and up to 262,144 for 64-bit systems.
+	  large numbers of CPUs.  This value must be at least the fourth
+	  root of NR_CPUS, which allows NR_CPUS to be insanely large.
+	  The default value of RCU_FANOUT should be used for production
+	  systems, but if you are stress-testing the RCU implementation
+	  itself, small RCU_FANOUT values allow you to test large-system
+	  code paths on small(er) systems.
 
 	  Select a specific number if testing RCU itself.
 	  Take the default if unsure.
diff --git a/kernel/Makefile b/kernel/Makefile
index 0b72d1a..17046b6 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
 obj-$(CONFIG_TINY_RCU) += rcutiny.o
+obj-$(CONFIG_TINY_PREEMPT_RCU) += rcutiny.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c9483d8..291ba3d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -138,7 +138,7 @@ struct css_id {
 	 * is called after synchronize_rcu(). But for safe use, css_is_removed()
 	 * css_tryget() should be used for avoiding race.
 	 */
-	struct cgroup_subsys_state *css;
+	struct cgroup_subsys_state __rcu *css;
 	/*
 	 * ID of this css.
 	 */
diff --git a/kernel/pid.c b/kernel/pid.c
index d55c6fb..39b65b6 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -401,7 +401,7 @@ struct task_struct *pid_task(struct pid *pid, enum pid_type type)
 	struct task_struct *result = NULL;
 	if (pid) {
 		struct hlist_node *first;
-		first = rcu_dereference_check(pid->tasks[type].first,
+		first = rcu_dereference_check(hlist_first_rcu(&pid->tasks[type]),
 					      rcu_read_lock_held() ||
 					      lockdep_tasklist_lock_is_held());
 		if (first)
@@ -416,6 +416,7 @@ EXPORT_SYMBOL(pid_task);
  */
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
+	rcu_lockdep_assert(rcu_read_lock_held());
 	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
 }
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 4d16983..a23a57a 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -73,12 +73,14 @@ int debug_lockdep_rcu_enabled(void)
 EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
 
 /**
- * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
+ * rcu_read_lock_bh_held() - might we be in RCU-bh read-side critical section?
  *
  * Check for bottom half being disabled, which covers both the
  * CONFIG_PROVE_RCU and not cases.  Note that if someone uses
  * rcu_read_lock_bh(), but then later enables BH, lockdep (if enabled)
- * will show the situation.
+ * will show the situation.  This is useful for debug checks in functions
+ * that require that they be called within an RCU read-side critical
+ * section.
  *
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot.
  */
@@ -86,7 +88,7 @@ int rcu_read_lock_bh_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-	return in_softirq();
+	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 196ec02..d806735 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -59,6 +59,14 @@ int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+/* Forward declarations for rcutiny_plugin.h. */
+static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp);
+static void __call_rcu(struct rcu_head *head,
+		       void (*func)(struct rcu_head *rcu),
+		       struct rcu_ctrlblk *rcp);
+
+#include "rcutiny_plugin.h"
+
 #ifdef CONFIG_NO_HZ
 
 static long rcu_dynticks_nesting = 1;
@@ -140,6 +148,7 @@ void rcu_check_callbacks(int cpu, int user)
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
 		rcu_bh_qs(cpu);
+	rcu_preempt_check_callbacks();
 }
 
 /*
@@ -162,6 +171,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	*rcp->donetail = NULL;
 	if (rcp->curtail == rcp->donetail)
 		rcp->curtail = &rcp->rcucblist;
+	rcu_preempt_remove_callbacks(rcp);
 	rcp->donetail = &rcp->rcucblist;
 	local_irq_restore(flags);
 
@@ -182,6 +192,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_sched_ctrlblk);
 	__rcu_process_callbacks(&rcu_bh_ctrlblk);
+	rcu_preempt_process_callbacks();
 }
 
 /*
@@ -223,15 +234,15 @@ static void __call_rcu(struct rcu_head *head,
 }
 
 /*
- * Post an RCU callback to be invoked after the end of an RCU grace
+ * Post an RCU callback to be invoked after the end of an RCU-sched grace
  * period.  But since we have but one CPU, that would be after any
  * quiescent state.
  */
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
 	__call_rcu(head, func, &rcu_sched_ctrlblk);
 }
-EXPORT_SYMBOL_GPL(call_rcu);
+EXPORT_SYMBOL_GPL(call_rcu_sched);
 
 /*
  * Post an RCU bottom-half callback to be invoked after any subsequent
@@ -243,20 +254,6 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
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
 void rcu_barrier_bh(void)
 {
 	struct rcu_synchronize rcu;
@@ -289,5 +286,3 @@ void __init rcu_init(void)
 {
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
-
-#include "rcutiny_plugin.h"
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index d223a92..6ceca4f 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -1,7 +1,7 @@
 /*
- * Read-Copy Update mechanism for mutual exclusion (tree-based version)
+ * Read-Copy Update mechanism for mutual exclusion, the Bloatwatch edition
  * Internal non-public definitions that provide either classic
- * or preemptable semantics.
+ * or preemptible semantics.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -17,11 +17,587 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
- * Copyright IBM Corporation, 2009
+ * Copyright (c) 2010 Linaro
  *
  * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
  */
 
+#ifdef CONFIG_TINY_PREEMPT_RCU
+
+#include <linux/delay.h>
+
+/* Global control variables for preemptible RCU. */
+struct rcu_preempt_ctrlblk {
+	struct rcu_ctrlblk rcb;	/* curtail: ->next ptr of last CB for GP. */
+	struct rcu_head **nexttail;
+				/* Tasks blocked in a preemptible RCU */
+				/*  read-side critical section while an */
+				/*  preemptible-RCU grace period is in */
+				/*  progress must wait for a later grace */
+				/*  period.  This pointer points to the */
+				/*  ->next pointer of the last task that */
+				/*  must wait for a later grace period, or */
+				/*  to &->rcb.rcucblist if there is no */
+				/*  such task. */
+	struct list_head blkd_tasks;
+				/* Tasks blocked in RCU read-side critical */
+				/*  section.  Tasks are placed at the head */
+				/*  of this list and age towards the tail. */
+	struct list_head *gp_tasks;
+				/* Pointer to the first task blocking the */
+				/*  current grace period, or NULL if there */
+				/*  is not such task. */
+	struct list_head *exp_tasks;
+				/* Pointer to first task blocking the */
+				/*  current expedited grace period, or NULL */
+				/*  if there is no such task.  If there */
+				/*  is no current expedited grace period, */
+				/*  then there cannot be any such task. */
+	u8 gpnum;		/* Current grace period. */
+	u8 gpcpu;		/* Last grace period blocked by the CPU. */
+	u8 completed;		/* Last grace period completed. */
+				/*  If all three are equal, RCU is idle. */
+};
+
+static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
+	.rcb.donetail = &rcu_preempt_ctrlblk.rcb.rcucblist,
+	.rcb.curtail = &rcu_preempt_ctrlblk.rcb.rcucblist,
+	.nexttail = &rcu_preempt_ctrlblk.rcb.rcucblist,
+	.blkd_tasks = LIST_HEAD_INIT(rcu_preempt_ctrlblk.blkd_tasks),
+};
+
+static int rcu_preempted_readers_exp(void);
+static void rcu_report_exp_done(void);
+
+/*
+ * Return true if the CPU has not yet responded to the current grace period.
+ */
+static int rcu_cpu_blocking_cur_gp(void)
+{
+	return rcu_preempt_ctrlblk.gpcpu != rcu_preempt_ctrlblk.gpnum;
+}
+
+/*
+ * Check for a running RCU reader.  Because there is only one CPU,
+ * there can be but one running RCU reader at a time.  ;-)
+ */
+static int rcu_preempt_running_reader(void)
+{
+	return current->rcu_read_lock_nesting;
+}
+
+/*
+ * Check for preempted RCU readers blocking any grace period.
+ * If the caller needs a reliable answer, it must disable hard irqs.
+ */
+static int rcu_preempt_blocked_readers_any(void)
+{
+	return !list_empty(&rcu_preempt_ctrlblk.blkd_tasks);
+}
+
+/*
+ * Check for preempted RCU readers blocking the current grace period.
+ * If the caller needs a reliable answer, it must disable hard irqs.
+ */
+static int rcu_preempt_blocked_readers_cgp(void)
+{
+	return rcu_preempt_ctrlblk.gp_tasks != NULL;
+}
+
+/*
+ * Return true if another preemptible-RCU grace period is needed.
+ */
+static int rcu_preempt_needs_another_gp(void)
+{
+	return *rcu_preempt_ctrlblk.rcb.curtail != NULL;
+}
+
+/*
+ * Return true if a preemptible-RCU grace period is in progress.
+ * The caller must disable hardirqs.
+ */
+static int rcu_preempt_gp_in_progress(void)
+{
+	return rcu_preempt_ctrlblk.completed != rcu_preempt_ctrlblk.gpnum;
+}
+
+/*
+ * Record a preemptible-RCU quiescent state for the specified CPU.  Note
+ * that this just means that the task currently running on the CPU is
+ * in a quiescent state.  There might be any number of tasks blocked
+ * while in an RCU read-side critical section.
+ *
+ * Unlike the other rcu_*_qs() functions, callers to this function
+ * must disable irqs in order to protect the assignment to
+ * ->rcu_read_unlock_special.
+ *
+ * Because this is a single-CPU implementation, the only way a grace
+ * period can end is if the CPU is in a quiescent state.  The reason is
+ * that a blocked preemptible-RCU reader can exit its critical section
+ * only if the CPU is running it at the time.  Therefore, when the
+ * last task blocking the current grace period exits its RCU read-side
+ * critical section, neither the CPU nor blocked tasks will be stopping
+ * the current grace period.  (In contrast, SMP implementations
+ * might have CPUs running in RCU read-side critical sections that
+ * block later grace periods -- but this is not possible given only
+ * one CPU.)
+ */
+static void rcu_preempt_cpu_qs(void)
+{
+	/* Record both CPU and task as having responded to current GP. */
+	rcu_preempt_ctrlblk.gpcpu = rcu_preempt_ctrlblk.gpnum;
+	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+
+	/*
+	 * If there is no GP, or if blocked readers are still blocking GP,
+	 * then there is nothing more to do.
+	 */
+	if (!rcu_preempt_gp_in_progress() || rcu_preempt_blocked_readers_cgp())
+		return;
+
+	/* Advance callbacks. */
+	rcu_preempt_ctrlblk.completed = rcu_preempt_ctrlblk.gpnum;
+	rcu_preempt_ctrlblk.rcb.donetail = rcu_preempt_ctrlblk.rcb.curtail;
+	rcu_preempt_ctrlblk.rcb.curtail = rcu_preempt_ctrlblk.nexttail;
+
+	/* If there are no blocked readers, next GP is done instantly. */
+	if (!rcu_preempt_blocked_readers_any())
+		rcu_preempt_ctrlblk.rcb.donetail = rcu_preempt_ctrlblk.nexttail;
+
+	/* If there are done callbacks, make RCU_SOFTIRQ process them. */
+	if (*rcu_preempt_ctrlblk.rcb.donetail != NULL)
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Start a new RCU grace period if warranted.  Hard irqs must be disabled.
+ */
+static void rcu_preempt_start_gp(void)
+{
+	if (!rcu_preempt_gp_in_progress() && rcu_preempt_needs_another_gp()) {
+
+		/* Official start of GP. */
+		rcu_preempt_ctrlblk.gpnum++;
+
+		/* Any blocked RCU readers block new GP. */
+		if (rcu_preempt_blocked_readers_any())
+			rcu_preempt_ctrlblk.gp_tasks =
+				rcu_preempt_ctrlblk.blkd_tasks.next;
+
+		/* If there is no running reader, CPU is done with GP. */
+		if (!rcu_preempt_running_reader())
+			rcu_preempt_cpu_qs();
+	}
+}
+
+/*
+ * We have entered the scheduler, and the current task might soon be
+ * context-switched away from.  If this task is in an RCU read-side
+ * critical section, we will no longer be able to rely on the CPU to
+ * record that fact, so we enqueue the task on the blkd_tasks list.
+ * If the task started after the current grace period began, as recorded
+ * by ->gpcpu, we enqueue at the beginning of the list.  Otherwise
+ * before the element referenced by ->gp_tasks (or at the tail if
+ * ->gp_tasks is NULL) and point ->gp_tasks at the newly added element.
+ * The task will dequeue itself when it exits the outermost enclosing
+ * RCU read-side critical section.  Therefore, the current grace period
+ * cannot be permitted to complete until the ->gp_tasks pointer becomes
+ * NULL.
+ *
+ * Caller must disable preemption.
+ */
+void rcu_preempt_note_context_switch(void)
+{
+	struct task_struct *t = current;
+	unsigned long flags;
+
+	local_irq_save(flags); /* must exclude scheduler_tick(). */
+	if (rcu_preempt_running_reader() &&
+	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
+
+		/* Possibly blocking in an RCU read-side critical section. */
+		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
+
+		/*
+		 * If this CPU has already checked in, then this task
+		 * will hold up the next grace period rather than the
+		 * current grace period.  Queue the task accordingly.
+		 * If the task is queued for the current grace period
+		 * (i.e., this CPU has not yet passed through a quiescent
+		 * state for the current grace period), then as long
+		 * as that task remains queued, the current grace period
+		 * cannot end.
+		 */
+		list_add(&t->rcu_node_entry, &rcu_preempt_ctrlblk.blkd_tasks);
+		if (rcu_cpu_blocking_cur_gp())
+			rcu_preempt_ctrlblk.gp_tasks = &t->rcu_node_entry;
+	}
+
+	/*
+	 * Either we were not in an RCU read-side critical section to
+	 * begin with, or we have now recorded that critical section
+	 * globally.  Either way, we can now note a quiescent state
+	 * for this CPU.  Again, if we were in an RCU read-side critical
+	 * section, and if that critical section was blocking the current
+	 * grace period, then the fact that the task has been enqueued
+	 * means that current grace period continues to be blocked.
+	 */
+	rcu_preempt_cpu_qs();
+	local_irq_restore(flags);
+}
+
+/*
+ * Tiny-preemptible RCU implementation for rcu_read_lock().
+ * Just increment ->rcu_read_lock_nesting, shared state will be updated
+ * if we block.
+ */
+void __rcu_read_lock(void)
+{
+	current->rcu_read_lock_nesting++;
+	barrier();  /* needed if we ever invoke rcu_read_lock in rcutiny.c */
+}
+EXPORT_SYMBOL_GPL(__rcu_read_lock);
+
+/*
+ * Handle special cases during rcu_read_unlock(), such as needing to
+ * notify RCU core processing or task having blocked during the RCU
+ * read-side critical section.
+ */
+static void rcu_read_unlock_special(struct task_struct *t)
+{
+	int empty;
+	int empty_exp;
+	unsigned long flags;
+	struct list_head *np;
+	int special;
+
+	/*
+	 * NMI handlers cannot block and cannot safely manipulate state.
+	 * They therefore cannot possibly be special, so just leave.
+	 */
+	if (in_nmi())
+		return;
+
+	local_irq_save(flags);
+
+	/*
+	 * If RCU core is waiting for this CPU to exit critical section,
+	 * let it know that we have done so.
+	 */
+	special = t->rcu_read_unlock_special;
+	if (special & RCU_READ_UNLOCK_NEED_QS)
+		rcu_preempt_cpu_qs();
+
+	/* Hardware IRQ handlers cannot block. */
+	if (in_irq()) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	/* Clean up if blocked during RCU read-side critical section. */
+	if (special & RCU_READ_UNLOCK_BLOCKED) {
+		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
+
+		/*
+		 * Remove this task from the ->blkd_tasks list and adjust
+		 * any pointers that might have been referencing it.
+		 */
+		empty = !rcu_preempt_blocked_readers_cgp();
+		empty_exp = rcu_preempt_ctrlblk.exp_tasks == NULL;
+		np = t->rcu_node_entry.next;
+		if (np == &rcu_preempt_ctrlblk.blkd_tasks)
+			np = NULL;
+		list_del(&t->rcu_node_entry);
+		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.gp_tasks)
+			rcu_preempt_ctrlblk.gp_tasks = np;
+		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.exp_tasks)
+			rcu_preempt_ctrlblk.exp_tasks = np;
+		INIT_LIST_HEAD(&t->rcu_node_entry);
+
+		/*
+		 * If this was the last task on the current list, and if
+		 * we aren't waiting on the CPU, report the quiescent state
+		 * and start a new grace period if needed.
+		 */
+		if (!empty && !rcu_preempt_blocked_readers_cgp()) {
+			rcu_preempt_cpu_qs();
+			rcu_preempt_start_gp();
+		}
+
+		/*
+		 * If this was the last task on the expedited lists,
+		 * then we need wake up the waiting task.
+		 */
+		if (!empty_exp && rcu_preempt_ctrlblk.exp_tasks == NULL)
+			rcu_report_exp_done();
+	}
+	local_irq_restore(flags);
+}
+
+/*
+ * Tiny-preemptible RCU implementation for rcu_read_unlock().
+ * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
+ * invoke rcu_read_unlock_special() to clean up after a context switch
+ * in an RCU read-side critical section and other special cases.
+ */
+void __rcu_read_unlock(void)
+{
+	struct task_struct *t = current;
+
+	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
+	--t->rcu_read_lock_nesting;
+	barrier();  /* decrement before load of ->rcu_read_unlock_special */
+	if (t->rcu_read_lock_nesting == 0 &&
+	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+		rcu_read_unlock_special(t);
+#ifdef CONFIG_PROVE_LOCKING
+	WARN_ON_ONCE(t->rcu_read_lock_nesting < 0);
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
+}
+EXPORT_SYMBOL_GPL(__rcu_read_unlock);
+
+/*
+ * Check for a quiescent state from the current CPU.  When a task blocks,
+ * the task is recorded in the rcu_preempt_ctrlblk structure, which is
+ * checked elsewhere.  This is called from the scheduling-clock interrupt.
+ *
+ * Caller must disable hard irqs.
+ */
+static void rcu_preempt_check_callbacks(void)
+{
+	struct task_struct *t = current;
+
+	if (rcu_preempt_gp_in_progress() &&
+	    (!rcu_preempt_running_reader() ||
+	     !rcu_cpu_blocking_cur_gp()))
+		rcu_preempt_cpu_qs();
+	if (&rcu_preempt_ctrlblk.rcb.rcucblist !=
+	    rcu_preempt_ctrlblk.rcb.donetail)
+		raise_softirq(RCU_SOFTIRQ);
+	if (rcu_preempt_gp_in_progress() &&
+	    rcu_cpu_blocking_cur_gp() &&
+	    rcu_preempt_running_reader())
+		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
+}
+
+/*
+ * TINY_PREEMPT_RCU has an extra callback-list tail pointer to
+ * update, so this is invoked from __rcu_process_callbacks() to
+ * handle that case.  Of course, it is invoked for all flavors of
+ * RCU, but RCU callbacks can appear only on one of the lists, and
+ * neither ->nexttail nor ->donetail can possibly be NULL, so there
+ * is no need for an explicit check.
+ */
+static void rcu_preempt_remove_callbacks(struct rcu_ctrlblk *rcp)
+{
+	if (rcu_preempt_ctrlblk.nexttail == rcp->donetail)
+		rcu_preempt_ctrlblk.nexttail = &rcp->rcucblist;
+}
+
+/*
+ * Process callbacks for preemptible RCU.
+ */
+static void rcu_preempt_process_callbacks(void)
+{
+	__rcu_process_callbacks(&rcu_preempt_ctrlblk.rcb);
+}
+
+/*
+ * Queue a preemptible -RCU callback for invocation after a grace period.
+ */
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	unsigned long flags;
+
+	debug_rcu_head_queue(head);
+	head->func = func;
+	head->next = NULL;
+
+	local_irq_save(flags);
+	*rcu_preempt_ctrlblk.nexttail = head;
+	rcu_preempt_ctrlblk.nexttail = &head->next;
+	rcu_preempt_start_gp();  /* checks to see if GP needed. */
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+void rcu_barrier(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_rcu_head_on_stack(&rcu.head);
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier);
+
+/*
+ * synchronize_rcu - wait until a grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full grace
+ * period has elapsed, in other words after all currently executing RCU
+ * read-side critical sections have completed.  RCU read-side critical
+ * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
+ * and may be nested.
+ */
+void synchronize_rcu(void)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	if (!rcu_scheduler_active)
+		return;
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+	WARN_ON_ONCE(rcu_preempt_running_reader());
+	if (!rcu_preempt_blocked_readers_any())
+		return;
+
+	/* Once we get past the fastpath checks, same code as rcu_barrier(). */
+	rcu_barrier();
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu);
+
+static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
+static unsigned long sync_rcu_preempt_exp_count;
+static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
+
+/*
+ * Return non-zero if there are any tasks in RCU read-side critical
+ * sections blocking the current preemptible-RCU expedited grace period.
+ * If there is no preemptible-RCU expedited grace period currently in
+ * progress, returns zero unconditionally.
+ */
+static int rcu_preempted_readers_exp(void)
+{
+	return rcu_preempt_ctrlblk.exp_tasks != NULL;
+}
+
+/*
+ * Report the exit from RCU read-side critical section for the last task
+ * that queued itself during or before the current expedited preemptible-RCU
+ * grace period.
+ */
+static void rcu_report_exp_done(void)
+{
+	wake_up(&sync_rcu_preempt_exp_wq);
+}
+
+/*
+ * Wait for an rcu-preempt grace period, but expedite it.  The basic idea
+ * is to rely in the fact that there is but one CPU, and that it is
+ * illegal for a task to invoke synchronize_rcu_expedited() while in a
+ * preemptible-RCU read-side critical section.  Therefore, any such
+ * critical sections must correspond to blocked tasks, which must therefore
+ * be on the ->blkd_tasks list.  So just record the current head of the
+ * list in the ->exp_tasks pointer, and wait for all tasks including and
+ * after the task pointed to by ->exp_tasks to drain.
+ */
+void synchronize_rcu_expedited(void)
+{
+	unsigned long flags;
+	struct rcu_preempt_ctrlblk *rpcp = &rcu_preempt_ctrlblk;
+	unsigned long snap;
+
+	barrier(); /* ensure prior action seen before grace period. */
+
+	WARN_ON_ONCE(rcu_preempt_running_reader());
+
+	/*
+	 * Acquire lock so that there is only one preemptible RCU grace
+	 * period in flight.  Of course, if someone does the expedited
+	 * grace period for us while we are acquiring the lock, just leave.
+	 */
+	snap = sync_rcu_preempt_exp_count + 1;
+	mutex_lock(&sync_rcu_preempt_exp_mutex);
+	if (ULONG_CMP_LT(snap, sync_rcu_preempt_exp_count))
+		goto unlock_mb_ret; /* Others did our work for us. */
+
+	local_irq_save(flags);
+
+	/*
+	 * All RCU readers have to already be on blkd_tasks because
+	 * we cannot legally be executing in an RCU read-side critical
+	 * section.
+	 */
+
+	/* Snapshot current head of ->blkd_tasks list. */
+	rpcp->exp_tasks = rpcp->blkd_tasks.next;
+	if (rpcp->exp_tasks == &rpcp->blkd_tasks)
+		rpcp->exp_tasks = NULL;
+	local_irq_restore(flags);
+
+	/* Wait for tail of ->blkd_tasks list to drain. */
+	if (rcu_preempted_readers_exp())
+		wait_event(sync_rcu_preempt_exp_wq,
+			   !rcu_preempted_readers_exp());
+
+	/* Clean up and exit. */
+	barrier(); /* ensure expedited GP seen before counter increment. */
+	sync_rcu_preempt_exp_count++;
+unlock_mb_ret:
+	mutex_unlock(&sync_rcu_preempt_exp_mutex);
+	barrier(); /* ensure subsequent action seen after grace period. */
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
+
+/*
+ * Does preemptible RCU need the CPU to stay out of dynticks mode?
+ */
+int rcu_preempt_needs_cpu(void)
+{
+	if (!rcu_preempt_running_reader())
+		rcu_preempt_cpu_qs();
+	return rcu_preempt_ctrlblk.rcb.rcucblist != NULL;
+}
+
+/*
+ * Check for a task exiting while in a preemptible -RCU read-side
+ * critical section, clean up if so.  No need to issue warnings,
+ * as debug_check_no_locks_held() already does this if lockdep
+ * is enabled.
+ */
+void exit_rcu(void)
+{
+	struct task_struct *t = current;
+
+	if (t->rcu_read_lock_nesting == 0)
+		return;
+	t->rcu_read_lock_nesting = 1;
+	rcu_read_unlock();
+}
+
+#else /* #ifdef CONFIG_TINY_PREEMPT_RCU */
+
+/*
+ * Because preemptible RCU does not exist, it never has any callbacks
+ * to check.
+ */
+static void rcu_preempt_check_callbacks(void)
+{
+}
+
+/*
+ * Because preemptible RCU does not exist, it never has any callbacks
+ * to remove.
+ */
+static void rcu_preempt_remove_callbacks(struct rcu_ctrlblk *rcp)
+{
+}
+
+/*
+ * Because preemptible RCU does not exist, it never has any callbacks
+ * to process.
+ */
+static void rcu_preempt_process_callbacks(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_TINY_PREEMPT_RCU */
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 #include <linux/kernel_stat.h>
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 2e2726d..9d8e8fb 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -120,7 +120,7 @@ struct rcu_torture {
 };
 
 static LIST_HEAD(rcu_torture_freelist);
-static struct rcu_torture *rcu_torture_current;
+static struct rcu_torture __rcu *rcu_torture_current;
 static long rcu_torture_current_version;
 static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
 static DEFINE_SPINLOCK(rcu_torture_lock);
@@ -153,8 +153,10 @@ int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 #define FULLSTOP_SHUTDOWN 1	/* System shutdown with rcutorture running. */
 #define FULLSTOP_RMMOD    2	/* Normal rmmod of rcutorture. */
 static int fullstop = FULLSTOP_RMMOD;
-DEFINE_MUTEX(fullstop_mutex);	/* Protect fullstop transitions and spawning */
-				/*  of kthreads. */
+/*
+ * Protect fullstop transitions and spawning of kthreads.
+ */
+static DEFINE_MUTEX(fullstop_mutex);
 
 /*
  * Detect and respond to a system shutdown.
@@ -303,6 +305,10 @@ static void rcu_read_delay(struct rcu_random_state *rrsp)
 		mdelay(longdelay_ms);
 	if (!(rcu_random(rrsp) % (nrealreaders * 2 * shortdelay_us)))
 		udelay(shortdelay_us);
+#ifdef CONFIG_PREEMPT
+	if (!preempt_count() && !(rcu_random(rrsp) % (nrealreaders * 20000)))
+		preempt_schedule();  /* No QS if preempt_disable() in effect */
+#endif
 }
 
 static void rcu_torture_read_unlock(int idx) __releases(RCU)
@@ -536,6 +542,8 @@ static void srcu_read_delay(struct rcu_random_state *rrsp)
 	delay = rcu_random(rrsp) % (nrealreaders * 2 * longdelay * uspertick);
 	if (!delay)
 		schedule_timeout_interruptible(longdelay);
+	else
+		rcu_read_delay(rrsp);
 }
 
 static void srcu_torture_read_unlock(int idx) __releases(&srcu_ctl)
@@ -731,7 +739,8 @@ rcu_torture_writer(void *arg)
 			continue;
 		rp->rtort_pipe_count = 0;
 		udelay(rcu_random(&rand) & 0x3ff);
-		old_rp = rcu_torture_current;
+		old_rp = rcu_dereference_check(rcu_torture_current,
+					       current == writer_task);
 		rp->rtort_mbtest = 1;
 		rcu_assign_pointer(rcu_torture_current, rp);
 		smp_wmb(); /* Mods to old_rp must follow rcu_assign_pointer() */
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d5bc439..ccdc04c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -143,6 +143,11 @@ module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+int rcu_cpu_stall_suppress __read_mostly = RCU_CPU_STALL_SUPPRESS_INIT;
+module_param(rcu_cpu_stall_suppress, int, 0644);
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
 
@@ -450,7 +455,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
-int rcu_cpu_stall_panicking __read_mostly;
+int rcu_cpu_stall_suppress __read_mostly;
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
@@ -482,8 +487,11 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	rcu_print_task_stall(rnp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
-	/* OK, time to rat on our buddy... */
-
+	/*
+	 * OK, time to rat on our buddy...
+	 * See Documentation/RCU/stallwarn.txt for info on how to debug
+	 * RCU CPU stall warnings.
+	 */
 	printk(KERN_ERR "INFO: %s detected stalls on CPUs/tasks: {",
 	       rsp->name);
 	rcu_for_each_leaf_node(rsp, rnp) {
@@ -512,6 +520,11 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	/*
+	 * OK, time to rat on ourselves...
+	 * See Documentation/RCU/stallwarn.txt for info on how to debug
+	 * RCU CPU stall warnings.
+	 */
 	printk(KERN_ERR "INFO: %s detected stall on CPU %d (t=%lu jiffies)\n",
 	       rsp->name, smp_processor_id(), jiffies - rsp->gp_start);
 	trigger_all_cpu_backtrace();
@@ -530,11 +543,11 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	long delta;
 	struct rcu_node *rnp;
 
-	if (rcu_cpu_stall_panicking)
+	if (rcu_cpu_stall_suppress)
 		return;
-	delta = jiffies - rsp->jiffies_stall;
+	delta = jiffies - ACCESS_ONCE(rsp->jiffies_stall);
 	rnp = rdp->mynode;
-	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
+	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && delta >= 0) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
@@ -548,10 +561,26 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 
 static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
 {
-	rcu_cpu_stall_panicking = 1;
+	rcu_cpu_stall_suppress = 1;
 	return NOTIFY_DONE;
 }
 
+/**
+ * rcu_cpu_stall_reset - prevent further stall warnings in current grace period
+ *
+ * Set the stall-warning timeout way off into the future, thus preventing
+ * any RCU CPU stall-warning messages from appearing in the current set of
+ * RCU grace periods.
+ *
+ * The caller must disable hard irqs.
+ */
+void rcu_cpu_stall_reset(void)
+{
+	rcu_sched_state.jiffies_stall = jiffies + ULONG_MAX / 2;
+	rcu_bh_state.jiffies_stall = jiffies + ULONG_MAX / 2;
+	rcu_preempt_stall_reset();
+}
+
 static struct notifier_block rcu_panic_block = {
 	.notifier_call = rcu_panic,
 };
@@ -571,6 +600,10 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 }
 
+void rcu_cpu_stall_reset(void)
+{
+}
+
 static void __init check_cpu_stall_init(void)
 {
 }
@@ -712,7 +745,7 @@ static void
 rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
-	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
+	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
@@ -960,7 +993,7 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
 {
 	int i;
-	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
+	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 
 	if (rdp->nxtlist == NULL)
 		return;  /* irqs disabled, so comparison is stable. */
@@ -971,6 +1004,7 @@ static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
 	rsp->orphan_qlen += rdp->qlen;
+	rdp->n_cbs_orphaned += rdp->qlen;
 	rdp->qlen = 0;
 	raw_spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
 }
@@ -984,7 +1018,7 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
-	rdp = rsp->rda[smp_processor_id()];
+	rdp = this_cpu_ptr(rsp->rda);
 	if (rsp->orphan_cbs_list == NULL) {
 		raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 		return;
@@ -992,6 +1026,7 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 	*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_list;
 	rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_tail;
 	rdp->qlen += rsp->orphan_qlen;
+	rdp->n_cbs_adopted += rsp->orphan_qlen;
 	rsp->orphan_cbs_list = NULL;
 	rsp->orphan_cbs_tail = &rsp->orphan_cbs_list;
 	rsp->orphan_qlen = 0;
@@ -1007,7 +1042,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	unsigned long flags;
 	unsigned long mask;
 	int need_report = 0;
-	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp;
 
 	/* Exclude any attempts to start a new grace period. */
@@ -1123,6 +1158,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Update count, and requeue any remaining callbacks. */
 	rdp->qlen -= count;
+	rdp->n_cbs_invoked += count;
 	if (list != NULL) {
 		*tail = rdp->nxtlist;
 		rdp->nxtlist = list;
@@ -1226,7 +1262,8 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 		cpu = rnp->grplo;
 		bit = 1;
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
-			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
+			if ((rnp->qsmask & bit) != 0 &&
+			    f(per_cpu_ptr(rsp->rda, cpu)))
 				mask |= bit;
 		}
 		if (mask != 0) {
@@ -1402,7 +1439,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 * a quiescent state betweentimes.
 	 */
 	local_irq_save(flags);
-	rdp = rsp->rda[smp_processor_id()];
+	rdp = this_cpu_ptr(rsp->rda);
 	rcu_process_gp_end(rsp, rdp);
 	check_for_new_grace_period(rsp, rdp);
 
@@ -1701,7 +1738,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
 	int i;
-	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
@@ -1729,7 +1766,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 {
 	unsigned long flags;
 	unsigned long mask;
-	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
@@ -1865,7 +1902,8 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 /*
  * Helper function for rcu_init() that initializes one rcu_state structure.
  */
-static void __init rcu_init_one(struct rcu_state *rsp)
+static void __init rcu_init_one(struct rcu_state *rsp,
+		struct rcu_data __percpu *rda)
 {
 	static char *buf[] = { "rcu_node_level_0",
 			       "rcu_node_level_1",
@@ -1918,37 +1956,23 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		}
 	}
 
+	rsp->rda = rda;
 	rnp = rsp->level[NUM_RCU_LVLS - 1];
 	for_each_possible_cpu(i) {
 		while (i > rnp->grphi)
 			rnp++;
-		rsp->rda[i]->mynode = rnp;
+		per_cpu_ptr(rsp->rda, i)->mynode = rnp;
 		rcu_boot_init_percpu_data(i, rsp);
 	}
 }
 
-/*
- * Helper macro for __rcu_init() and __rcu_init_preempt().  To be used
- * nowhere else!  Assigns leaf node pointers into each CPU's rcu_data
- * structure.
- */
-#define RCU_INIT_FLAVOR(rsp, rcu_data) \
-do { \
-	int i; \
-	\
-	for_each_possible_cpu(i) { \
-		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
-	} \
-	rcu_init_one(rsp); \
-} while (0)
-
 void __init rcu_init(void)
 {
 	int cpu;
 
 	rcu_bootup_announce();
-	RCU_INIT_FLAVOR(&rcu_sched_state, rcu_sched_data);
-	RCU_INIT_FLAVOR(&rcu_bh_state, rcu_bh_data);
+	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
+	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 14c040b..91d4170 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -202,6 +202,9 @@ struct rcu_data {
 	long		qlen;		/* # of queued callbacks */
 	long		qlen_last_fqs_check;
 					/* qlen at last check for QS forcing */
+	unsigned long	n_cbs_invoked;	/* count of RCU cbs invoked. */
+	unsigned long	n_cbs_orphaned;	/* RCU cbs sent to orphanage. */
+	unsigned long	n_cbs_adopted;	/* RCU cbs adopted from orphanage. */
 	unsigned long	n_force_qs_snap;
 					/* did other CPU force QS recently? */
 	long		blimit;		/* Upper limit on a processed batch */
@@ -254,19 +257,23 @@ struct rcu_data {
 #define RCU_STALL_DELAY_DELTA	       0
 #endif
 
-#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ + RCU_STALL_DELAY_DELTA)
+#define RCU_SECONDS_TILL_STALL_CHECK   (CONFIG_RCU_CPU_STALL_TIMEOUT * HZ + \
+					RCU_STALL_DELAY_DELTA)
 						/* for rsp->jiffies_stall */
-#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ + RCU_STALL_DELAY_DELTA)
+#define RCU_SECONDS_TILL_STALL_RECHECK (3 * RCU_SECONDS_TILL_STALL_CHECK + 30)
 						/* for rsp->jiffies_stall */
 #define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
 						/*  to take at least one */
 						/*  scheduling clock irq */
 						/*  before ratting on them. */
 
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE
+#define RCU_CPU_STALL_SUPPRESS_INIT 0
+#else
+#define RCU_CPU_STALL_SUPPRESS_INIT 1
+#endif
 
-#define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
-#define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
  * RCU global state, including node hierarchy.  This hierarchy is
@@ -283,7 +290,7 @@ struct rcu_state {
 	struct rcu_node *level[NUM_RCU_LVLS];	/* Hierarchy levels. */
 	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
 	u8 levelspread[NUM_RCU_LVLS];		/* kids/node in each level. */
-	struct rcu_data *rda[NR_CPUS];		/* array of rdp pointers. */
+	struct rcu_data __percpu *rda;		/* pointer of percu rcu_data. */
 
 	/* The following fields are guarded by the root rcu_node's lock. */
 
@@ -365,6 +372,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
+static void rcu_preempt_stall_reset(void);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 0e4f420..71a4147 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -57,7 +57,7 @@ static void __init rcu_bootup_announce_oddness(void)
 	printk(KERN_INFO
 	       "\tRCU-based detection of stalled CPUs is disabled.\n");
 #endif
-#ifndef CONFIG_RCU_CPU_STALL_VERBOSE
+#if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
 	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
 #endif
 #if NUM_RCU_LVL_4 != 0
@@ -154,7 +154,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
-		rdp = rcu_preempt_state.rda[cpu];
+		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
@@ -201,7 +201,7 @@ static void rcu_preempt_note_context_switch(int cpu)
  */
 void __rcu_read_lock(void)
 {
-	ACCESS_ONCE(current->rcu_read_lock_nesting)++;
+	current->rcu_read_lock_nesting++;
 	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_lock);
@@ -344,7 +344,9 @@ void __rcu_read_unlock(void)
 	struct task_struct *t = current;
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
-	if (--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
+	--t->rcu_read_lock_nesting;
+	barrier();  /* decrement before load of ->rcu_read_unlock_special */
+	if (t->rcu_read_lock_nesting == 0 &&
 	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 		rcu_read_unlock_special(t);
 #ifdef CONFIG_PROVE_LOCKING
@@ -417,6 +419,16 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 	}
 }
 
+/*
+ * Suppress preemptible RCU's CPU stall warnings by pushing the
+ * time of the next stall-warning message comfortably far into the
+ * future.
+ */
+static void rcu_preempt_stall_reset(void)
+{
+	rcu_preempt_state.jiffies_stall = jiffies + ULONG_MAX / 2;
+}
+
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
@@ -546,9 +558,11 @@ EXPORT_SYMBOL_GPL(call_rcu);
  *
  * Control will return to the caller some time after a full grace
  * period has elapsed, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
- * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
- * and may be nested.
+ * read-side critical sections have completed.  Note, however, that
+ * upon return from synchronize_rcu(), the caller might well be executing
+ * concurrently with new RCU read-side critical sections that began while
+ * synchronize_rcu() was waiting.  RCU read-side critical sections are
+ * delimited by rcu_read_lock() and rcu_read_unlock(), and may be nested.
  */
 void synchronize_rcu(void)
 {
@@ -771,7 +785,7 @@ static void rcu_preempt_send_cbs_to_orphanage(void)
  */
 static void __init __rcu_init_preempt(void)
 {
-	RCU_INIT_FLAVOR(&rcu_preempt_state, rcu_preempt_data);
+	rcu_init_one(&rcu_preempt_state, &rcu_preempt_data);
 }
 
 /*
@@ -865,6 +879,14 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 {
 }
 
+/*
+ * Because preemptible RCU does not exist, there is no need to suppress
+ * its CPU stall warnings.
+ */
+static void rcu_preempt_stall_reset(void)
+{
+}
+
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
@@ -919,15 +941,6 @@ static void rcu_preempt_process_callbacks(void)
 }
 
 /*
- * In classic RCU, call_rcu() is just call_rcu_sched().
- */
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
-{
-	call_rcu_sched(head, func);
-}
-EXPORT_SYMBOL_GPL(call_rcu);
-
-/*
  * Wait for an rcu-preempt grace period, but make it happen quickly.
  * But because preemptable RCU does not exist, map to rcu-sched.
  */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 36c95b4..d15430b 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -64,7 +64,9 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld b=%ld\n", rdp->qlen, rdp->blimit);
+	seq_printf(m, " ql=%ld b=%ld", rdp->qlen, rdp->blimit);
+	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
+		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
 #define PRINT_RCU_DATA(name, func, m) \
@@ -119,7 +121,9 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, ",%ld,%ld\n", rdp->qlen, rdp->blimit);
+	seq_printf(m, ",%ld,%ld", rdp->qlen, rdp->blimit);
+	seq_printf(m, ",%lu,%lu,%lu\n",
+		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
 static int show_rcudata_csv(struct seq_file *m, void *unused)
@@ -128,7 +132,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 #ifdef CONFIG_NO_HZ
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
-	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\"\n");
+	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\",\"ci\",\"co\",\"ca\"\n");
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	seq_puts(m, "\"rcu_preempt:\"\n");
 	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data_csv, m);
@@ -262,7 +266,7 @@ static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_data *rdp;
 
 	for_each_possible_cpu(cpu) {
-		rdp = rsp->rda[cpu];
+		rdp = per_cpu_ptr(rsp->rda, cpu);
 		if (rdp->beenonline)
 			print_one_rcu_pending(m, rdp);
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index dc85ceb..ae8f75a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5337,7 +5337,19 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	idle->se.exec_start = sched_clock();
 
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
+	/*
+	 * We're having a chicken and egg problem, even though we are
+	 * holding rq->lock, the cpu isn't yet set to this cpu so the
+	 * lockdep check in task_group() will fail.
+	 *
+	 * Similar case to sched_fork(). / Alternatively we could
+	 * use task_rq_lock() here and obtain the other rq->lock.
+	 *
+	 * Silence PROVE_RCU
+	 */
+	rcu_read_lock();
 	__set_task_cpu(idle, cpu);
+	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
 #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index db3f674..5f996d3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3751,8 +3751,11 @@ static void task_fork_fair(struct task_struct *p)
 
 	update_rq_clock(rq);
 
-	if (unlikely(task_cpu(p) != this_cpu))
+	if (unlikely(task_cpu(p) != this_cpu)) {
+		rcu_read_lock();
 		__set_task_cpu(p, this_cpu);
+		rcu_read_unlock();
+	}
 
 	update_curr(cfs_rq);
 
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 2980da3..c71e075 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -46,11 +46,9 @@ static int init_srcu_struct_fields(struct srcu_struct *sp)
 int __init_srcu_struct(struct srcu_struct *sp, const char *name,
 		       struct lock_class_key *key)
 {
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/* Don't re-initialize a lock while it is held. */
 	debug_check_no_locks_freed((void *)sp, sizeof(*sp));
 	lockdep_init_map(&sp->dep_map, name, key, 0);
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 	return init_srcu_struct_fields(sp);
 }
 EXPORT_SYMBOL_GPL(__init_srcu_struct);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1b4afd2..9886cf5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -539,6 +539,23 @@ config PROVE_RCU_REPEATEDLY
 	 disabling, allowing multiple RCU-lockdep warnings to be printed
 	 on a single reboot.
 
+	 Say Y to allow multiple RCU-lockdep warnings per boot.
+
+	 Say N if you are unsure.
+
+config SPARSE_RCU_POINTER
+	bool "RCU debugging: sparse-based checks for pointer usage"
+	default n
+	help
+	 This feature enables the __rcu sparse annotation for
+	 RCU-protected pointers.  This annotation will cause sparse
+	 to flag any non-RCU used of annotated pointers.  This can be
+	 helpful when debugging RCU usage.  Please note that this feature
+	 is not intended to enforce code cleanliness; it is instead merely
+	 a debugging aid.
+
+	 Say Y to make sparse flag questionable use of RCU-protected pointers
+
 	 Say N if you are unsure.
 
 config LOCKDEP
@@ -832,6 +849,30 @@ config RCU_CPU_STALL_DETECTOR
 
 	  Say Y if you are unsure.
 
+config RCU_CPU_STALL_TIMEOUT
+	int "RCU CPU stall timeout in seconds"
+	depends on RCU_CPU_STALL_DETECTOR
+	range 3 300
+	default 60
+	help
+	  If a given RCU grace period extends more than the specified
+	  number of seconds, a CPU stall warning is printed.  If the
+	  RCU grace period persists, additional CPU stall warnings are
+	  printed at more widely spaced intervals.
+
+config RCU_CPU_STALL_DETECTOR_RUNNABLE
+	bool "RCU CPU stall checking starts automatically at boot"
+	depends on RCU_CPU_STALL_DETECTOR
+	default y
+	help
+	  If set, start checking for RCU CPU stalls immediately on
+	  boot.  Otherwise, RCU CPU stall checking must be manually
+	  enabled.
+
+	  Say Y if you are unsure.
+
+	  Say N if you wish to suppress RCU CPU stall checking during boot.
+
 config RCU_CPU_STALL_VERBOSE
 	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
 	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index efd16fa..6f412ab4 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -49,7 +49,7 @@ struct radix_tree_node {
 	unsigned int	height;		/* Height from the bottom */
 	unsigned int	count;
 	struct rcu_head	rcu_head;
-	void		*slots[RADIX_TREE_MAP_SIZE];
+	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
 	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
 };
 
diff --git a/net/core/sock.c b/net/core/sock.c
index ef30e9d..7d99e13 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1078,8 +1078,11 @@ static void sk_prot_free(struct proto *prot, struct sock *sk)
 #ifdef CONFIG_CGROUPS
 void sock_update_classid(struct sock *sk)
 {
-	u32 classid = task_cls_classid(current);
+	u32 classid;
 
+	rcu_read_lock();  /* doing current task, which cannot vanish. */
+	classid = task_cls_classid(current);
+	rcu_read_unlock();
 	if (classid && classid != sk->sk_classid)
 		sk->sk_classid = classid;
 }
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 8c8632d..957c924 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -38,7 +38,7 @@ static DEFINE_SPINLOCK(nf_nat_lock);
 static struct nf_conntrack_l3proto *l3proto __read_mostly;
 
 #define MAX_IP_NAT_PROTO 256
-static const struct nf_nat_protocol *nf_nat_protos[MAX_IP_NAT_PROTO]
+static const struct nf_nat_protocol __rcu *nf_nat_protos[MAX_IP_NAT_PROTO]
 						__read_mostly;
 
 static inline const struct nf_nat_protocol *
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 78b505d..fdaec7d 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -27,7 +27,7 @@
 
 static DEFINE_MUTEX(afinfo_mutex);
 
-const struct nf_afinfo *nf_afinfo[NFPROTO_NUMPROTO] __read_mostly;
+const struct nf_afinfo __rcu *nf_afinfo[NFPROTO_NUMPROTO] __read_mostly;
 EXPORT_SYMBOL(nf_afinfo);
 
 int nf_register_afinfo(const struct nf_afinfo *afinfo)
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index cdcc764..5702de3 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -26,10 +26,10 @@
 
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
-struct nf_ct_event_notifier *nf_conntrack_event_cb __read_mostly;
+struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_event_cb);
 
-struct nf_exp_event_notifier *nf_expect_event_cb __read_mostly;
+struct nf_exp_event_notifier __rcu *nf_expect_event_cb __read_mostly;
 EXPORT_SYMBOL_GPL(nf_expect_event_cb);
 
 /* deliver cached events and clear cache entry - must be called with locally
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 8d9e4c94..bd82450 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -16,7 +16,7 @@
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
-static struct nf_ct_ext_type *nf_ct_ext_types[NF_CT_EXT_NUM];
+static struct nf_ct_ext_type __rcu *nf_ct_ext_types[NF_CT_EXT_NUM];
 static DEFINE_MUTEX(nf_ct_ext_type_mutex);
 
 void __nf_ct_ext_destroy(struct nf_conn *ct)
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 5886ba1..ed6d929 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -28,8 +28,8 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-static struct nf_conntrack_l4proto **nf_ct_protos[PF_MAX] __read_mostly;
-struct nf_conntrack_l3proto *nf_ct_l3protos[AF_MAX] __read_mostly;
+static struct nf_conntrack_l4proto __rcu **nf_ct_protos[PF_MAX] __read_mostly;
+struct nf_conntrack_l3proto __rcu *nf_ct_l3protos[AF_MAX] __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_l3protos);
 
 static DEFINE_MUTEX(nf_ct_proto_mutex);
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 7df37fd..b07393e 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -16,7 +16,7 @@
 #define NF_LOG_PREFIXLEN		128
 #define NFLOGGER_NAME_LEN		64
 
-static const struct nf_logger *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
+static const struct nf_logger __rcu *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
 static struct list_head nf_loggers_l[NFPROTO_NUMPROTO] __read_mostly;
 static DEFINE_MUTEX(nf_log_mutex);
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 78b3cf9..74aebed 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -18,7 +18,7 @@
  * long term mutex.  The handler must provide an an outfn() to accept packets
  * for queueing and must reinject all packets it receives, no matter what.
  */
-static const struct nf_queue_handler *queue_handler[NFPROTO_NUMPROTO] __read_mostly;
+static const struct nf_queue_handler __rcu *queue_handler[NFPROTO_NUMPROTO] __read_mostly;
 
 static DEFINE_MUTEX(queue_handler_mutex);
 
