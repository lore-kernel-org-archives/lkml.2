Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2DIMvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:51:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34099 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab2DIMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:51:49 -0400
MIME-Version: 1.0
Date: Mon, 9 Apr 2012 20:51:49 +0800
Message-ID: <CAJd=RBDhm-Tr_9OrO3oz9zhps53yWSKQ9tvtdq_03A+tc0FnuQ@mail.gmail.com>
Subject: [PATCH] DLS: fix check_preempt_curr_dl
From: Hillf Danton <dhillf@gmail.com>
To: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If not sure the CPU of waker is the CPU of wakee, we have to check the
current task of given runqueue.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_dl.c	Mon Apr  9 19:39:56 2012
+++ b/kernel/sched_dl.c	Mon Apr  9 20:42:08 2012
@@ -888,9 +888,9 @@ static void check_preempt_curr_dl(struct
 	 * let us try to decide what's the best thing to do...
 	 */
 	if ((p->dl.deadline == rq->curr->dl.deadline) &&
-	    !need_resched())
+					!test_tsk_need_resched(rq->curr))
 		check_preempt_equal_dl(rq, p);
-#endif /* CONFIG_SMP */
+#endif
 }

 #ifdef CONFIG_SCHED_HRTICK
--
