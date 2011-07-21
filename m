Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1GUSaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:30:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:49915 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1GUSaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:30:06 -0400
Date: Thu, 21 Jul 2011 18:29:44 GMT
From: tip-bot for Jan Schoenherr <schnhrr@cs.tu-berlin.de>
Message-ID: <tip-045176d22f08bc0b650a028df0f62fc3c2747699@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, schnhrr@cs.tu-berlin.de, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schnhrr@cs.tu-berlin.de, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1310580816-10861-3-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1310580816-10861-3-git-send-email-schnhrr@cs.tu-berlin.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused function cpu_cfs_rq()
Git-Commit-ID: 045176d22f08bc0b650a028df0f62fc3c2747699
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 18:29:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  045176d22f08bc0b650a028df0f62fc3c2747699
Gitweb:     http://git.kernel.org/tip/045176d22f08bc0b650a028df0f62fc3c2747699
Author:     Jan Schoenherr <schnhrr@cs.tu-berlin.de>
AuthorDate: Wed, 13 Jul 2011 20:13:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 18:01:49 +0200

sched: Remove unused function cpu_cfs_rq()

The last reference to cpu_cfs_rq() was removed with commit 88ec22d3
("sched: Remove the cfs_rq dependency from set_task_cpu()"). Thus,
remove this function, too.

Signed-off-by: Jan Schoenherr <schnhrr@cs.tu-berlin.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1310580816-10861-3-git-send-email-schnhrr@cs.tu-berlin.de
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 180bcf1..0588c0b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -135,14 +135,6 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 	return grp->my_q;
 }
 
-/* Given a group's cfs_rq on one cpu, return its corresponding cfs_rq on
- * another cpu ('this_cpu')
- */
-static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
-{
-	return cfs_rq->tg->cfs_rq[this_cpu];
-}
-
 static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	if (!cfs_rq->on_list) {
@@ -271,11 +263,6 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 	return NULL;
 }
 
-static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
-{
-	return &cpu_rq(this_cpu)->cfs;
-}
-
 static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
 }
