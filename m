Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab0JXNOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 09:14:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:45938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564Ab0JXNOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 09:14:08 -0400
Date: Sun, 24 Oct 2010 13:13:38 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rakib.mullick@gmail.com, peterz@infradead.org, oleg@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
In-Reply-To: <AANLkTi=REu0WzOp5N=nVT1=ZJ=ZA+MZFV+4CHSJ3Q-Yv@mail.gmail.com>
References: <AANLkTi=REu0WzOp5N=nVT1=ZJ=ZA+MZFV+4CHSJ3Q-Yv@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched_stat: Update sched_info_queue/dequeue() code comments
Message-ID: <tip-d4a6f3c32c39132318454e77d59ab14b06f6eb02@git.kernel.org>
Git-Commit-ID: d4a6f3c32c39132318454e77d59ab14b06f6eb02
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 24 Oct 2010 13:13:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4a6f3c32c39132318454e77d59ab14b06f6eb02
Gitweb:     http://git.kernel.org/tip/d4a6f3c32c39132318454e77d59ab14b06f6eb02
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Sun, 24 Oct 2010 16:28:47 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 24 Oct 2010 13:29:01 +0200

sched_stat: Update sched_info_queue/dequeue() code comments

Remove some sched_info_queue(), sched_info_dequeue() code comment.
We no longer belongs to the era of O(1) and we don't use active or expired
array anymore.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <AANLkTi=REu0WzOp5N=nVT1=ZJ=ZA+MZFV+4CHSJ3Q-Yv@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_stats.h |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 25c2f96..48ddf43 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -157,15 +157,7 @@ static inline void sched_info_reset_dequeued(struct task_struct *t)
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
