Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab0KWKWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:22:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:48383 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0KWKWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:22:44 -0500
Date: Tue, 23 Nov 2010 10:22:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix UP build breakage
Message-ID: <tip-70caf8a6c13c2279b35f2ad6b644815533d6c476@git.kernel.org>
Git-Commit-ID: 70caf8a6c13c2279b35f2ad6b644815533d6c476
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Nov 2010 10:22:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70caf8a6c13c2279b35f2ad6b644815533d6c476
Gitweb:     http://git.kernel.org/tip/70caf8a6c13c2279b35f2ad6b644815533d6c476
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 20 Nov 2010 00:53:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Nov 2010 10:29:07 +0100

sched: Fix UP build breakage

The recent cgroup-scheduling rework caused a UP build problem.

Cc: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 390ce30..82fd884 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -562,7 +562,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->load_unacc_exec_time += delta_exec;
 	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
 		update_cfs_load(cfs_rq, 0);
