Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1G0NYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:24:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39150 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab1G0NYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:24:09 -0400
MIME-Version: 1.0
Date: Wed, 27 Jul 2011 21:24:08 +0800
Message-ID: <CAJd=RBCUekxXLEkn60G-4XC6A-H0i5QunGUNajub76kFZ2FAyg@mail.gmail.com>
Subject: [RFC] sched: no preempt by RT task of throttled task group
From: Hillf Danton <dhillf@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the newly woken task is member of a throttled task group, the current task
should not be preempted, since the woken task is not eligible for schedule.

Would you please, Paul, give ideas on defining throttled task group, say

	task_group_throttled(task_group(task))

for a given RT task, since it is too hard to understand the teaching that
runqueue is never throttled but task group could.

Thanks,
Hillf
---
 kernel/sched_rt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 97540f0..c6762eb 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1090,6 +1090,8 @@ static void check_preempt_equal_prio(struct rq
*rq, struct task_struct *p)
  */
 static void check_preempt_curr_rt(struct rq *rq, struct task_struct
*p, int flags)
 {
+	if (rt_rq_throttled(rt_rq_of_se(&p->rt)))
+		return;
 	if (p->prio < rq->curr->prio) {
 		resched_task(rq->curr);
 		return;
