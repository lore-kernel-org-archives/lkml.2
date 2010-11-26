Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0KZPDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:03:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:40277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab0KZPD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:03:29 -0500
Date: Fri, 26 Nov 2010 15:03:04 GMT
From: tip-bot for Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, knikanth@suse.de, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, knikanth@suse.de, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <201011261237.09187.knikanth@suse.de>
References: <201011261237.09187.knikanth@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused argument dest_cpu to migrate_task()
Message-ID: <tip-b7a2b39d9b7703ccf068f549c8dc3465fc41d015@git.kernel.org>
Git-Commit-ID: b7a2b39d9b7703ccf068f549c8dc3465fc41d015
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:03:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7a2b39d9b7703ccf068f549c8dc3465fc41d015
Gitweb:     http://git.kernel.org/tip/b7a2b39d9b7703ccf068f549c8dc3465fc41d015
Author:     Nikanth Karthikesan <knikanth@suse.de>
AuthorDate: Fri, 26 Nov 2010 12:37:09 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:05:36 +0100

sched: Remove unused argument dest_cpu to migrate_task()

Remove unused argument, 'dest_cpu' of migrate_task(), and pass runqueue,
as it is always known at the call site.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <201011261237.09187.knikanth@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index abe7aec..35a6373 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2061,10 +2061,8 @@ static int migration_cpu_stop(void *data);
  * The task's runqueue lock must be held.
  * Returns true if you have to wait for migration thread.
  */
-static bool migrate_task(struct task_struct *p, int dest_cpu)
+static bool migrate_task(struct task_struct *p, struct rq *rq)
 {
-	struct rq *rq = task_rq(p);
-
 	/*
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
@@ -3224,7 +3222,7 @@ void sched_exec(void)
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
 	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
-	    likely(cpu_active(dest_cpu)) && migrate_task(p, dest_cpu)) {
+	    likely(cpu_active(dest_cpu)) && migrate_task(p, rq)) {
 		struct migration_arg arg = { p, dest_cpu };
 
 		task_rq_unlock(rq, &flags);
@@ -5504,7 +5502,7 @@ again:
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (migrate_task(p, dest_cpu)) {
+	if (migrate_task(p, rq)) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, &flags);
