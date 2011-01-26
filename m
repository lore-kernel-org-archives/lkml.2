Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1AZMLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:11:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:39703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab1AZMLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:11:10 -0500
Date: Wed, 26 Jan 2011 12:10:40 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110122044852.007092349@google.com>
References: <20110122044852.007092349@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use rq->clock_task instead of rq->clock for correctly maintaining load averages
Message-ID: <tip-05ca62c6ca17f39b88fa956d5ebc1fa6e93ad5e3@git.kernel.org>
Git-Commit-ID: 05ca62c6ca17f39b88fa956d5ebc1fa6e93ad5e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:10:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05ca62c6ca17f39b88fa956d5ebc1fa6e93ad5e3
Gitweb:     http://git.kernel.org/tip/05ca62c6ca17f39b88fa956d5ebc1fa6e93ad5e3
Author:     Paul Turner <pjt@google.com>
AuthorDate: Fri, 21 Jan 2011 20:45:02 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:31:03 +0100

sched: Use rq->clock_task instead of rq->clock for correctly maintaining load averages

The delta in clock_task is a more fair attribution of how much time a tg has
been contributing load to the current cpu.

While not really important it also means we're more in sync (by magnitude)
with respect to periodic updates (since __update_curr deltas are clock_task
based).

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110122044852.007092349@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1997383..0c26e2d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -725,7 +725,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 	if (cfs_rq->tg == &root_task_group)
 		return;
 
-	now = rq_of(cfs_rq)->clock;
+	now = rq_of(cfs_rq)->clock_task;
 	delta = now - cfs_rq->load_stamp;
 
 	/* truncate load history at 4 idle periods */
