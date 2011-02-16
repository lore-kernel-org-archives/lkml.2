Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab1BPIew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:34:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60679 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1BPIes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:34:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hlt15uA+gqifFXgqJ2KDi3p5N1qV8cnEEC9/r5e9ETrT5+Im2on1+Hy0xA4Xq6Tjvc
         glUw+9B90b+zIHu75f6HQQLG15+1vMSjRPygyOb7rEc73+LtQM159LkdO4y24dtk4142
         wYob/0a3IGbzTYUbaVYY7FINoff+NNtyavVcI=
Date: Wed, 16 Feb 2011 09:34:42 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Dmitry Torokhov <dtor@mail.ru>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        David Woodhouse <dwmw2@infradead.org>, Alex Dubov <oakad@yahoo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] workqueue, freezer: unify spelling of 'freeze' + 'able' to
 'freezable'
Message-ID: <20110216083442.GB19830@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two spellings in use for 'freeze' + 'able' - 'freezable' and
'freezeable'.  The former is the more prominent one.  The latter is
mostly used by workqueue and in a few other odd places.  Unify the
spelling to 'freezable'.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
---
I'd like to push this through wq#fixes-2.6.38 branch as routing this
type of changes through linux-next usually only increases the amount
of conflicts.  Rafael, can you please ack if you agree?

Thanks.

 Documentation/workqueue.txt      |    4 ++--
 drivers/memstick/core/memstick.c |    2 +-
 drivers/misc/tifm_core.c         |    2 +-
 drivers/misc/vmw_balloon.c       |    2 +-
 drivers/mtd/nand/r852.c          |    2 +-
 drivers/mtd/sm_ftl.c             |    2 +-
 drivers/net/can/mcp251x.c        |    2 +-
 drivers/tty/serial/max3100.c     |    2 +-
 drivers/tty/serial/max3107.c     |    2 +-
 fs/gfs2/glock.c                  |    4 ++--
 fs/gfs2/main.c                   |    2 +-
 include/linux/freezer.h          |    2 +-
 include/linux/sched.h            |    2 +-
 include/linux/workqueue.h        |    8 ++++----
 kernel/power/main.c              |    2 +-
 kernel/power/process.c           |    6 +++---
 kernel/workqueue.c               |   24 ++++++++++++------------
 17 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
index 996a27d..01c513f 100644
--- a/Documentation/workqueue.txt
+++ b/Documentation/workqueue.txt
@@ -190,9 +190,9 @@ resources, scheduled and executed.
 	* Long running CPU intensive workloads which can be better
 	  managed by the system scheduler.
 
-  WQ_FREEZEABLE
+  WQ_FREEZABLE
 
-	A freezeable wq participates in the freeze phase of the system
+	A freezable wq participates in the freeze phase of the system
 	suspend operations.  Work items on the wq are drained and no
 	new work item starts execution until thawed.
 
diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index e9a3eab..8c1d85e 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -621,7 +621,7 @@ static int __init memstick_init(void)
 {
 	int rc;
 
-	workqueue = create_freezeable_workqueue("kmemstick");
+	workqueue = create_freezable_workqueue("kmemstick");
 	if (!workqueue)
 		return -ENOMEM;
 
diff --git a/drivers/misc/tifm_core.c b/drivers/misc/tifm_core.c
index 5f6852d..44d4475 100644
--- a/drivers/misc/tifm_core.c
+++ b/drivers/misc/tifm_core.c
@@ -329,7 +329,7 @@ static int __init tifm_init(void)
 {
 	int rc;
 
-	workqueue = create_freezeable_workqueue("tifm");
+	workqueue = create_freezable_workqueue("tifm");
 	if (!workqueue)
 		return -ENOMEM;
 
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 4d2ea8e..6df5a55 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -785,7 +785,7 @@ static int __init vmballoon_init(void)
 	if (x86_hyper != &x86_hyper_vmware)
 		return -ENODEV;
 
-	vmballoon_wq = create_freezeable_workqueue("vmmemctl");
+	vmballoon_wq = create_freezable_workqueue("vmmemctl");
 	if (!vmballoon_wq) {
 		pr_err("failed to create workqueue\n");
 		return -ENOMEM;
diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index d9d7efb..6322d1f 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -930,7 +930,7 @@ int  r852_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 
 	init_completion(&dev->dma_done);
 
-	dev->card_workqueue = create_freezeable_workqueue(DRV_NAME);
+	dev->card_workqueue = create_freezable_workqueue(DRV_NAME);
 
 	if (!dev->card_workqueue)
 		goto error9;
diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
index 67822cf..ac0d6a8 100644
--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -1258,7 +1258,7 @@ static struct mtd_blktrans_ops sm_ftl_ops = {
 static __init int sm_module_init(void)
 {
 	int error = 0;
-	cache_flush_workqueue = create_freezeable_workqueue("smflush");
+	cache_flush_workqueue = create_freezable_workqueue("smflush");
 
 	if (IS_ERR(cache_flush_workqueue))
 		return PTR_ERR(cache_flush_workqueue);
diff --git a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
index 7ab534a..7513c45 100644
--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -940,7 +940,7 @@ static int mcp251x_open(struct net_device *net)
 		goto open_unlock;
 	}
 
-	priv->wq = create_freezeable_workqueue("mcp251x_wq");
+	priv->wq = create_freezable_workqueue("mcp251x_wq");
 	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
 	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
 
diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index beb1afa..7b951ad 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -601,7 +601,7 @@ static int max3100_startup(struct uart_port *port)
 	s->rts = 0;
 
 	sprintf(b, "max3100-%d", s->minor);
-	s->workqueue = create_freezeable_workqueue(b);
+	s->workqueue = create_freezable_workqueue(b);
 	if (!s->workqueue) {
 		dev_warn(&s->spi->dev, "cannot create workqueue\n");
 		return -EBUSY;
diff --git a/drivers/tty/serial/max3107.c b/drivers/tty/serial/max3107.c
index 910870e..750b4f6 100644
--- a/drivers/tty/serial/max3107.c
+++ b/drivers/tty/serial/max3107.c
@@ -833,7 +833,7 @@ static int max3107_startup(struct uart_port *port)
 	struct max3107_port *s = container_of(port, struct max3107_port, port);
 
 	/* Initialize work queue */
-	s->workqueue = create_freezeable_workqueue("max3107");
+	s->workqueue = create_freezable_workqueue("max3107");
 	if (!s->workqueue) {
 		dev_err(&s->spi->dev, "Workqueue creation failed\n");
 		return -EBUSY;
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 08a8beb..7cd9a5a 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1779,11 +1779,11 @@ int __init gfs2_glock_init(void)
 #endif
 
 	glock_workqueue = alloc_workqueue("glock_workqueue", WQ_MEM_RECLAIM |
-					  WQ_HIGHPRI | WQ_FREEZEABLE, 0);
+					  WQ_HIGHPRI | WQ_FREEZABLE, 0);
 	if (IS_ERR(glock_workqueue))
 		return PTR_ERR(glock_workqueue);
 	gfs2_delete_workqueue = alloc_workqueue("delete_workqueue",
-						WQ_MEM_RECLAIM | WQ_FREEZEABLE,
+						WQ_MEM_RECLAIM | WQ_FREEZABLE,
 						0);
 	if (IS_ERR(gfs2_delete_workqueue)) {
 		destroy_workqueue(glock_workqueue);
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index ebef7ab..85ba027 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -144,7 +144,7 @@ static int __init init_gfs2_fs(void)
 
 	error = -ENOMEM;
 	gfs_recovery_wq = alloc_workqueue("gfs_recovery",
-					  WQ_MEM_RECLAIM | WQ_FREEZEABLE, 0);
+					  WQ_MEM_RECLAIM | WQ_FREEZABLE, 0);
 	if (!gfs_recovery_wq)
 		goto fail_wq;
 
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index da7e52b..1effc8b 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -109,7 +109,7 @@ static inline void freezer_count(void)
 }
 
 /*
- * Check if the task should be counted as freezeable by the freezer
+ * Check if the task should be counted as freezable by the freezer
  */
 static inline int freezer_should_skip(struct task_struct *p)
 {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..777d8a5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1744,7 +1744,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
-#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
+#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezable */
 #define PF_FREEZER_NOSIG 0x80000000	/* Freezer won't send signals to it */
 
 /*
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 1ac1158..f7998a3 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -250,7 +250,7 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 enum {
 	WQ_NON_REENTRANT	= 1 << 0, /* guarantee non-reentrance */
 	WQ_UNBOUND		= 1 << 1, /* not bound to any cpu */
-	WQ_FREEZEABLE		= 1 << 2, /* freeze during suspend */
+	WQ_FREEZABLE		= 1 << 2, /* freeze during suspend */
 	WQ_MEM_RECLAIM		= 1 << 3, /* may be used for memory reclaim */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
@@ -318,7 +318,7 @@ __alloc_workqueue_key(const char *name, unsigned int flags, int max_active,
 /**
  * alloc_ordered_workqueue - allocate an ordered workqueue
  * @name: name of the workqueue
- * @flags: WQ_* flags (only WQ_FREEZEABLE and WQ_MEM_RECLAIM are meaningful)
+ * @flags: WQ_* flags (only WQ_FREEZABLE and WQ_MEM_RECLAIM are meaningful)
  *
  * Allocate an ordered workqueue.  An ordered workqueue executes at
  * most one work item at any given time in the queued order.  They are
@@ -335,8 +335,8 @@ alloc_ordered_workqueue(const char *name, unsigned int flags)
 
 #define create_workqueue(name)					\
 	alloc_workqueue((name), WQ_MEM_RECLAIM, 1)
-#define create_freezeable_workqueue(name)			\
-	alloc_workqueue((name), WQ_FREEZEABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
+#define create_freezable_workqueue(name)			\
+	alloc_workqueue((name), WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
 #define create_singlethread_workqueue(name)			\
 	alloc_workqueue((name), WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
 
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 7b5db6a..7018530 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -326,7 +326,7 @@ EXPORT_SYMBOL_GPL(pm_wq);
 
 static int __init pm_start_workqueue(void)
 {
-	pm_wq = alloc_workqueue("pm", WQ_FREEZEABLE, 0);
+	pm_wq = alloc_workqueue("pm", WQ_FREEZABLE, 0);
 
 	return pm_wq ? 0 : -ENOMEM;
 }
diff --git a/kernel/power/process.c b/kernel/power/process.c
index d6d2a10..0cf3a27 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -22,7 +22,7 @@
  */
 #define TIMEOUT	(20 * HZ)
 
-static inline int freezeable(struct task_struct * p)
+static inline int freezable(struct task_struct * p)
 {
 	if ((p == current) ||
 	    (p->flags & PF_NOFREEZE) ||
@@ -53,7 +53,7 @@ static int try_to_freeze_tasks(bool sig_only)
 		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (frozen(p) || !freezeable(p))
+			if (frozen(p) || !freezable(p))
 				continue;
 
 			if (!freeze_task(p, sig_only))
@@ -167,7 +167,7 @@ static void thaw_tasks(bool nosig_only)
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
-		if (!freezeable(p))
+		if (!freezable(p))
 			continue;
 
 		if (nosig_only && should_send_signal(p))
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 90a17ca..88a3e34 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2965,7 +2965,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	 */
 	spin_lock(&workqueue_lock);
 
-	if (workqueue_freezing && wq->flags & WQ_FREEZEABLE)
+	if (workqueue_freezing && wq->flags & WQ_FREEZABLE)
 		for_each_cwq_cpu(cpu, wq)
 			get_cwq(cpu, wq)->max_active = 0;
 
@@ -3077,7 +3077,7 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
 		spin_lock_irq(&gcwq->lock);
 
-		if (!(wq->flags & WQ_FREEZEABLE) ||
+		if (!(wq->flags & WQ_FREEZABLE) ||
 		    !(gcwq->flags & GCWQ_FREEZING))
 			get_cwq(gcwq->cpu, wq)->max_active = max_active;
 
@@ -3327,7 +3327,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * want to get it over with ASAP - spam rescuers, wake up as
 	 * many idlers as necessary and create new ones till the
 	 * worklist is empty.  Note that if the gcwq is frozen, there
-	 * may be frozen works in freezeable cwqs.  Don't declare
+	 * may be frozen works in freezable cwqs.  Don't declare
 	 * completion while frozen.
 	 */
 	while (gcwq->nr_workers != gcwq->nr_idle ||
@@ -3585,9 +3585,9 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
 /**
  * freeze_workqueues_begin - begin freezing workqueues
  *
- * Start freezing workqueues.  After this function returns, all
- * freezeable workqueues will queue new works to their frozen_works
- * list instead of gcwq->worklist.
+ * Start freezing workqueues.  After this function returns, all freezable
+ * workqueues will queue new works to their frozen_works list instead of
+ * gcwq->worklist.
  *
  * CONTEXT:
  * Grabs and releases workqueue_lock and gcwq->lock's.
@@ -3613,7 +3613,7 @@ void freeze_workqueues_begin(void)
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
-			if (cwq && wq->flags & WQ_FREEZEABLE)
+			if (cwq && wq->flags & WQ_FREEZABLE)
 				cwq->max_active = 0;
 		}
 
@@ -3624,7 +3624,7 @@ void freeze_workqueues_begin(void)
 }
 
 /**
- * freeze_workqueues_busy - are freezeable workqueues still busy?
+ * freeze_workqueues_busy - are freezable workqueues still busy?
  *
  * Check whether freezing is complete.  This function must be called
  * between freeze_workqueues_begin() and thaw_workqueues().
@@ -3633,8 +3633,8 @@ void freeze_workqueues_begin(void)
  * Grabs and releases workqueue_lock.
  *
  * RETURNS:
- * %true if some freezeable workqueues are still busy.  %false if
- * freezing is complete.
+ * %true if some freezable workqueues are still busy.  %false if freezing
+ * is complete.
  */
 bool freeze_workqueues_busy(void)
 {
@@ -3654,7 +3654,7 @@ bool freeze_workqueues_busy(void)
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
-			if (!cwq || !(wq->flags & WQ_FREEZEABLE))
+			if (!cwq || !(wq->flags & WQ_FREEZABLE))
 				continue;
 
 			BUG_ON(cwq->nr_active < 0);
@@ -3699,7 +3699,7 @@ void thaw_workqueues(void)
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
-			if (!cwq || !(wq->flags & WQ_FREEZEABLE))
+			if (!cwq || !(wq->flags & WQ_FREEZABLE))
 				continue;
 
 			/* restore max_active and repopulate worklist */
-- 
1.7.1

