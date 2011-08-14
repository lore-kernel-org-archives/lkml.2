Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1HNQEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:04:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:52033 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1HNQER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:04:17 -0400
Date: Sun, 14 Aug 2011 16:03:58 GMT
From: tip-bot for Hillf Danton <dhillf@gmail.com>
Message-ID: <tip-1812a643ccbfeb61a00a7f0d7219606e63d8815b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, dhillf@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, yong.zhang0@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, dhillf@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, yong.zhang0@gmail.com,
        mingo@elte.hu
In-Reply-To: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove resetting exec_start in put_prev_task_rt()
Git-Commit-ID: 1812a643ccbfeb61a00a7f0d7219606e63d8815b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:04:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1812a643ccbfeb61a00a7f0d7219606e63d8815b
Gitweb:     http://git.kernel.org/tip/1812a643ccbfeb61a00a7f0d7219606e63d8815b
Author:     Hillf Danton <dhillf@gmail.com>
AuthorDate: Thu, 16 Jun 2011 21:55:21 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:00:50 +0200

sched: Remove resetting exec_start in put_prev_task_rt()

There's no reason to clean the exec_start in put_prev_task_rt() as it is reset
when the task gets back to the run queue. This saves us doing a store() in the
fast path.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Link: http://lkml.kernel.org/r/BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 8e18945..70107a3 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1178,7 +1178,6 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);
-	p->se.exec_start = 0;
 
 	/*
 	 * The previous task needs to be made eligible for pushing
