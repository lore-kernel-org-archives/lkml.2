Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1GVMzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 08:55:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:42366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1GVMzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 08:55:52 -0400
Date: Fri, 22 Jul 2011 12:55:35 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Message-ID: <tip-0f3171438fc917b9f6b8b60dbb7a3fff9a0f68fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1311297271.3938.1352.camel@minggr.sh.intel.com>
References: <1311297271.3938.1352.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Cleanup duplicate local variable in [enqueue|dequeue]_task_fair
Git-Commit-ID: 0f3171438fc917b9f6b8b60dbb7a3fff9a0f68fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jul 2011 12:55:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f3171438fc917b9f6b8b60dbb7a3fff9a0f68fd
Gitweb:     http://git.kernel.org/tip/0f3171438fc917b9f6b8b60dbb7a3fff9a0f68fd
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Fri, 22 Jul 2011 09:14:31 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Jul 2011 12:47:22 +0200

sched: Cleanup duplicate local variable in [enqueue|dequeue]_task_fair

No need to define a new "cfs_rq" variable in the "for" block.
Just use the one at the top of the function.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1311297271.3938.1352.camel@minggr.sh.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a2ecbaa..bc8ee99 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1317,7 +1317,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	}
 
 	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
@@ -1360,7 +1360,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	}
 
 	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
