Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0LGCP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:15:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab0LGCNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:13:30 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=nkGb5ECdRNcA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=1nSz6Ew-AAAA:8 a=meVymXHHAAAA:8 a=pmJiZM8Am-pUpP864NQA:9 a=hekDWnYJaDs_JvJfsvSTtOsHLtYA:4 a=jEp0ucaQiEUA:10 a=nj4rVwXhlm8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101207021328.207196531@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 20:58:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gregory Haskins <ghaskins@novell.com>
Subject: [RFC][PATCH 01/10] sched: Change rt_task(prev) in pre_schedule_rt to likely
References: <20101207015834.196176991@goodmis.org>
Content-Disposition: inline; filename=0001-sched-Change-rt_task-prev-in-pre_schedule_rt-to-like.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As found with the branch annotation profiler, the unlikely(rt_task(prev))
in pre_schedule_rt() is always wrong. In fact it should be likely due to
the fact that we got to this function because we used prev's scheduling
class (which had to be rt).

Change the unlikely(rt_task(prev)) to likely(rt_task(prev))

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bea7d79..7a5c4db 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1474,7 +1474,7 @@ skip:
 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
+	if (likely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
 		pull_rt_task(rq);
 }
 
-- 
1.7.2.3


