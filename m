Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab0FRKUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:20:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:47024 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833Ab0FRKUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:20:20 -0400
Date: Fri, 18 Jun 2010 10:19:49 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100610230948.GA25911@redhat.com>
References: <20100610230948.GA25911@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: task_tick_rt: Remove the obsolete ->signal != NULL check
Message-ID: <tip-c32b4fce799d3a6157df9048d03e429956c58818@git.kernel.org>
Git-Commit-ID: c32b4fce799d3a6157df9048d03e429956c58818
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:19:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c32b4fce799d3a6157df9048d03e429956c58818
Gitweb:     http://git.kernel.org/tip/c32b4fce799d3a6157df9048d03e429956c58818
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 11 Jun 2010 01:09:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Jun 2010 10:46:56 +0200

sched: task_tick_rt: Remove the obsolete ->signal != NULL check

Remove the obsolete ->signal != NULL check in watchdog().
Since ea6d290c ->signal can't be NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100610230948.GA25911@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 8afb953..d10c80e 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1663,9 +1663,6 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 {
 	unsigned long soft, hard;
 
-	if (!p->signal)
-		return;
-
 	/* max may change after cur was read, this will be fixed next tick */
 	soft = task_rlimit(p, RLIMIT_RTTIME);
 	hard = task_rlimit_max(p, RLIMIT_RTTIME);
