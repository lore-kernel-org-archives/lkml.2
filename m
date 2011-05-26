Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab1EZNI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:08:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56241 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1EZNI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:08:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hqluiq7y7LZGeyBRcGz7xE6DXs0A9lmPHEBA8RALbYjq2WydTxHz8P+51aat5uKYKP
         e19uDr2f5r+dpeDy2IpiP7SRE60YWnRxutc3+afinx/7oN6tuAryD7TRHagBIeqXO2+m
         KGZ+JoILJiFG2Dm/p73R7G2Hf7zXDZEPvk5w8=
MIME-Version: 1.0
Date: Thu, 26 May 2011 21:08:56 +0800
Message-ID: <BANLkTin1QYAx7as41t78-n0giLSBWoToVA@mail.gmail.com>
Subject: [PATCH] sched: remove noop in pre_schedule_rt()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking task to be RT is removed since only RT task is served here.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- tip-git/kernel/sched_rt.c	Sun May 22 20:12:01 2011
+++ sched_rt.c	Thu May 26 21:11:19 2011
@@ -1516,7 +1516,7 @@ skip:
 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
+	if (rq->rt.highest_prio.curr > prev->prio)
 		pull_rt_task(rq);
 }
