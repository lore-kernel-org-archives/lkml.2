Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1FQB7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:59:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab1FQB7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:59:21 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=65Ev7lBb6mkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=UC-ONSXTy2KUzNwaElIA:9 a=Y3cTEihHMm-g29bCKGgA:7 a=MSl-tDqOz04A:10 a=_RhRFcbxBZMA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110617015919.519061866@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Jun 2011 21:55:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>, Hillf Danton <dhillf@gmail.com>
Subject: [RFC][PATCH 5/7] sched: Remove resetting exec_start in put_prev_task_rt()
References: <20110617015516.301117218@goodmis.org>
Content-Disposition: inline; filename=0005-sched-Remove-resetting-exec_start-in-put_prev_task_r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

There's no reason to clean the exec_start in put_prev_task_rt() as it is reset
when the task gets back to the run queue. This saves us doing a store() in the
fast path.

Cc: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
Link: http://lkml.kernel.org/r/BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 7737d41..1546c1c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1166,7 +1166,6 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);
-	p->se.exec_start = 0;
 
 	/*
 	 * The previous task needs to be made eligible for pushing
-- 
1.7.4.4


