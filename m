Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab0JXK2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 06:28:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42801 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab0JXK2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 06:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hXW9szF+JlO3w7QvaU3TeXZTI3eXOljoZ8frJFXieXCCwYZ6gzai3RkarSRxdO5dMV
         52Mecxg78hb+uHa1fruMXT1zs/C+eCJkrWvqPMe7HIEKlzujvm6ReJ9zLgT0ysUxYdA9
         sIVm28uCU8fLnrgxRRL+CUDm7PJa0dGfoFYCw=
MIME-Version: 1.0
Date: Sun, 24 Oct 2010 16:28:47 +0600
Message-ID: <AANLkTi=REu0WzOp5N=nVT1=ZJ=ZA+MZFV+4CHSJ3Q-Yv@mail.gmail.com>
Subject: [PATCH] sched_stat: Update sched_info_queue/dequeue() code comment.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Remove some sched_info_queue(), sched_info_dequeue() code comment.
 We no longer belongs to the era of O(1) and we don't use active or expired
 array anymore.



Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 25c2f96..48ddf43 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -157,15 +157,7 @@ static inline void
sched_info_reset_dequeued(struct task_struct *t)
 }

 /*
- * Called when a process is dequeued from the active array and given
- * the cpu.  We should note that with the exception of interactive
- * tasks, the expired queue will become the active queue after the active
- * queue is empty, without explicitly dequeuing and requeuing tasks in the
- * expired queue.  (Interactive tasks may be requeued directly to the
- * active queue, thus delaying tasks in the expired queue from running;
- * see scheduler_tick()).
- *
- * Though we are interested in knowing how long it was from the *first* time a
+ * We are interested in knowing how long it was from the *first* time a
  * task was queued to the time that it finally hit a cpu, we call this routine
  * from dequeue_task() to account for possible rq->clock skew across cpus. The
  * delta taken on each cpu would annul the skew.
@@ -203,16 +195,6 @@ static void sched_info_arrive(struct task_struct *t)
 }

 /*
- * Called when a process is queued into either the active or expired
- * array.  The time is noted and later used to determine how long we
- * had to wait for us to reach the cpu.  Since the expired queue will
- * become the active queue after active queue is empty, without dequeuing
- * and requeuing any tasks, we are interested in queuing to either. It
- * is unusual but not impossible for tasks to be dequeued and immediately
- * requeued in the same or another array: this can happen in sched_yield(),
- * set_user_nice(), and even load_balance() as it moves tasks from runqueue
- * to runqueue.
- *
  * This function is only called from enqueue_task(), but also only updates
  * the timestamp if it is already not set.  It's assumed that
  * sched_info_dequeued() will clear that stamp when appropriate.
