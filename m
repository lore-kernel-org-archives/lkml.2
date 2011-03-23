Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab1CWMzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:55:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:59441 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649Ab1CWMzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:55:08 -0400
Date: Wed, 23 Mar 2011 12:54:46 GMT
From: tip-bot for Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, peterz@infradead.org,
        sergey.senozhatsky@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        sergey.senozhatsky@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110323111722.GA4244@swordfish.minsk.epam.com>
References: <20110323111722.GA4244@swordfish.minsk.epam.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove unused 'rq' variable and cpu_rq() call from alloc_fair_sched_group()
Message-ID: <tip-20dd67407160eac577656cd2f8ee9a1fead960b8@git.kernel.org>
Git-Commit-ID: 20dd67407160eac577656cd2f8ee9a1fead960b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Mar 2011 12:54:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20dd67407160eac577656cd2f8ee9a1fead960b8
Gitweb:     http://git.kernel.org/tip/20dd67407160eac577656cd2f8ee9a1fead960b8
Author:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
AuthorDate: Wed, 23 Mar 2011 13:17:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Mar 2011 13:27:58 +0100

sched: Remove unused 'rq' variable and cpu_rq() call from alloc_fair_sched_group()

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110323111722.GA4244@swordfish.minsk.epam.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 052120d..a361e20 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8443,7 +8443,6 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se;
-	struct rq *rq;
 	int i;
 
 	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
@@ -8456,8 +8455,6 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	tg->shares = NICE_0_LOAD;
 
 	for_each_possible_cpu(i) {
-		rq = cpu_rq(i);
-
 		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
 				      GFP_KERNEL, cpu_to_node(i));
 		if (!cfs_rq)
