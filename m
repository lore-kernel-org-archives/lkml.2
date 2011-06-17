Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab1FQB7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:59:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60224 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab1FQB7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:59:19 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=IgatxnWLDGkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oHPBDzVnkOnvCgxldaAA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110617015918.232117378@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Jun 2011 21:55:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>, Hillf Danton <dhillf@gmail.com>
Subject: [RFC][PATCH 2/7] sched: Remove noop in next_prio()
References: <20110617015516.301117218@goodmis.org>
Content-Disposition: inline; filename=0002-sched-Remove-noop-in-next_prio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

When computing the next priority for a given run-queue, the check for
RT priority of the task determined by the pick_next_highest_task_rt()
function could be removed, since only RT tasks are returned by the
function.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
Link: http://lkml.kernel.org/r/BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 9b8d5dc..a6f1f64 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -692,7 +692,7 @@ static inline int next_prio(struct rq *rq)
 {
 	struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
 
-	if (next && rt_prio(next->prio))
+	if (next)
 		return next->prio;
 	else
 		return MAX_RT_PRIO;
-- 
1.7.4.4


