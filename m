Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0IWMfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:35:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:56191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab0IWMfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:35:16 -0400
Message-ID: <4C9B497B.4060302@kernel.org>
Date: Thu, 23 Sep 2010 14:35:07 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC] workqueue: remove in_workqueue_context()
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 23 Sep 2010 12:35:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a25909a4 (lockdep: Add an in_workqueue_context() lockdep-based
test function) added in_workqueue_context() but there hasn't been any
in-kernel user and the lockdep annotation in workqueue is scheduled to
change.  Remove the unused function.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
Paul, I was looking through lockdep annotations to see how they can be
improved and noticed that in_workqueue_context() isn't used by anyone
and it seems like there hasn't been any in-kernel user either.  Can
this be removed or do you expect to use it somewhere?

Thanks.

 include/linux/workqueue.h |    4 ----
 kernel/workqueue.c        |   15 ---------------
 2 files changed, 19 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index e33ff4a..f6eaf56 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -429,8 +429,4 @@ extern bool freeze_workqueues_busy(void);
 extern void thaw_workqueues(void);
 #endif /* CONFIG_FREEZER */

-#ifdef CONFIG_LOCKDEP
-int in_workqueue_context(struct workqueue_struct *wq);
-#endif
-
 #endif
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 19e4bc1..c758e78 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -310,21 +310,6 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 	     (cpu) < WORK_CPU_NONE;					\
 	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, (wq)))

-#ifdef CONFIG_LOCKDEP
-/**
- * in_workqueue_context() - in context of specified workqueue?
- * @wq: the workqueue of interest
- *
- * Checks lockdep state to see if the current task is executing from
- * within a workqueue item.  This function exists only if lockdep is
- * enabled.
- */
-int in_workqueue_context(struct workqueue_struct *wq)
-{
-	return lock_is_held(&wq->lockdep_map);
-}
-#endif
-
 #ifdef CONFIG_DEBUG_OBJECTS_WORK

 static struct debug_obj_descr work_debug_descr;
