Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab0DOJTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 05:19:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:35469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601Ab0DOJTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:19:17 -0400
Date: Thu, 15 Apr 2010 09:18:37 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, efault@gmx.de, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, peterz@infradead.org, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <1271309399.14779.17.camel@marge.simson.net>
References: <1271309399.14779.17.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix UP update_avg() build warning
Message-ID: <tip-09a40af5240de02d848247ab82440ad75b31ab11@git.kernel.org>
Git-Commit-ID: 09a40af5240de02d848247ab82440ad75b31ab11
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 09:18:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09a40af5240de02d848247ab82440ad75b31ab11
Gitweb:     http://git.kernel.org/tip/09a40af5240de02d848247ab82440ad75b31ab11
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 15 Apr 2010 07:29:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Apr 2010 09:36:47 +0200

sched: Fix UP update_avg() build warning

update_avg() is only used for SMP builds, move it to the nearest
SMP block.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1271309399.14779.17.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ab562ae..de0da71 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1872,12 +1872,6 @@ static void set_load_weight(struct task_struct *p)
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }
 
-static void update_avg(u64 *avg, u64 sample)
-{
-	s64 diff = sample - *avg;
-	*avg += diff >> 3;
-}
-
 static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_rq_clock(rq);
@@ -2332,6 +2326,12 @@ int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_
 
 	return cpu;
 }
+
+static void update_avg(u64 *avg, u64 sample)
+{
+	s64 diff = sample - *avg;
+	*avg += diff >> 3;
+}
 #endif
 
 /***
