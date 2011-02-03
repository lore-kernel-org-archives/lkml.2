Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1BCOMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:12:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:51374 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab1BCOL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:11:59 -0500
Date: Thu, 3 Feb 2011 14:11:32 GMT
From: tip-bot for Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110201094715.798c4f86@annuminas.surriel.com>
References: <20110201094715.798c4f86@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Check the right ->nr_running in yield_task_fair()
Message-ID: <tip-725e7580aaf98e9f7b22b8ccfc640ad0c09e2b08@git.kernel.org>
Git-Commit-ID: 725e7580aaf98e9f7b22b8ccfc640ad0c09e2b08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Feb 2011 14:11:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  725e7580aaf98e9f7b22b8ccfc640ad0c09e2b08
Gitweb:     http://git.kernel.org/tip/725e7580aaf98e9f7b22b8ccfc640ad0c09e2b08
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Tue, 1 Feb 2011 09:47:15 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Feb 2011 14:20:32 +0100

sched: Check the right ->nr_running in yield_task_fair()

With CONFIG_FAIR_GROUP_SCHED, each task_group has its own cfs_rq.
Yielding to a task from another cfs_rq may be worthwhile, since
a process calling yield typically cannot use the CPU right now.

Therefor, we want to check the per-cpu nr_running, not the
cgroup local one.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110201094715.798c4f86@annuminas.surriel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 55040f3..4de9905 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1331,7 +1331,7 @@ static void yield_task_fair(struct rq *rq)
 	/*
 	 * Are we the only task in the tree?
 	 */
-	if (unlikely(cfs_rq->nr_running == 1))
+	if (unlikely(rq->nr_running == 1))
 		return;
 
 	clear_buddies(cfs_rq, se);
