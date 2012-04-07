Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2DGHtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 03:49:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54978 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2DGHtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 03:49:11 -0400
MIME-Version: 1.0
Date: Sat, 7 Apr 2012 15:49:10 +0800
Message-ID: <CAJd=RBDKe_fX0ROdbs8sqeqJmjWtUmtSTtF1kMLbdOvt0a6UHQ@mail.gmail.com>
Subject: [PATCH] DLS: add dl_time_equal helper in deadline scheduler
From: Hillf Danton <dhillf@gmail.com>
To: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

A tiny helper, dl_time_equal, is added for easing readers.

And dl_entity_preempt is redefined to be bool, and its comment is also changed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_dl.c	Sat Apr  7 15:00:28 2012
+++ b/kernel/sched_dl.c	Sat Apr  7 15:20:10 2012
@@ -16,16 +16,21 @@
  */
 static const struct sched_class dl_sched_class;

-static inline int dl_time_before(u64 a, u64 b)
+static inline bool dl_time_equal(u64 a, u64 b)
+{
+	return a == b;
+}
+
+static inline bool dl_time_before(u64 a, u64 b)
 {
 	return (s64)(a - b) < 0;
 }

 /*
- * Tells if entity @a should preempt entity @b.
+ * Return true if entity @a could preempt entity @b in term of deadline
  */
-static inline
-int dl_entity_preempt(struct sched_dl_entity *a, struct sched_dl_entity *b)
+static inline bool
+dl_entity_preempt(struct sched_dl_entity *a, struct sched_dl_entity *b)
 {
 	return dl_time_before(a->deadline, b->deadline);
 }
@@ -885,7 +890,7 @@ static void check_preempt_curr_dl(struct
 	 * In the unlikely case current and p have the same deadline
 	 * let us try to decide what's the best thing to do...
 	 */
-	if ((s64)(p->dl.deadline - rq->curr->dl.deadline) == 0 &&
+	if (dl_time_equal(p->dl.deadline, rq->curr->dl.deadline) &&
 	    !need_resched())
 		check_preempt_equal_dl(rq, p);
 #endif /* CONFIG_SMP */
--
