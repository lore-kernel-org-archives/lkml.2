Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1FNWhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 18:37:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44828 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1FNWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 18:36:59 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=KhJpOiBgMmsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=wK5BP5vcLrgx6EhhWtEA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110614223657.450239027@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Jun 2011 18:36:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH 1/2] sched: Fix need_resched() when checking peempt
References: <20110614223623.876681637@goodmis.org>
Content-Disposition: inline; filename=0001-sched-Fix-need_resched-when-checking-peempt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

The RT preempt check tests the wrong task if NEED_RESCHED is set. It currently
checks the local CPU task. It is suppose to check the task that is running on
the run queue we are about to wake another task on.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Link: http://lkml.kernel.org/r/BANLkTi=e=69xvJZ1+56xzuFyhmdN0hZHRQ@mail.gmail.com
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 88725c9..9b8d5dc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1096,7 +1096,7 @@ static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int flag
 	 * to move current somewhere else, making room for our non-migratable
 	 * task.
 	 */
-	if (p->prio == rq->curr->prio && !need_resched())
+	if (p->prio == rq->curr->prio && !test_tsk_need_resched(rq->curr))
 		check_preempt_equal_prio(rq, p);
 #endif
 }
-- 
1.7.4.4


