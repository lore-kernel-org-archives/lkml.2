Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0LNB2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:28:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64375 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758891Ab0LNB2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:28:47 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=kBLP2dr1vAAA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=Tty9oNO6AAAA:8 a=meVymXHHAAAA:8 a=iewJ9w5EJ2zEKgshMfYA:9 a=DkNFvcuDawZY5gvKWpgA:7 a=6OcdsQP4VvHtutY5oB4Si8ZS2QgA:4 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101214012845.318261615@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 20:28:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/4] sched: Cleanup pre_schedule_rt
References: <20101214012803.142630411@goodmis.org>
Content-Disposition: inline; filename=0001-sched-Cleanup-pre_schedule_rt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>

Since [commit 9a897c5a:
sched: RT-balance, replace hooks with pre/post schedule and wakeup methods]
we must call pre_schedule_rt if prev is rt task.
So condition rt_task(prev) is always true and the 'unlikely' declaration is
simply incorrect.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bea7d79..1ab66a2 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1474,7 +1474,7 @@ skip:
 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
+	if (rq->rt.highest_prio.curr > prev->prio)
 		pull_rt_task(rq);
 }
 
-- 
1.7.2.3


