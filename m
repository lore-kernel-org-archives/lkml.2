Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab1EBBWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:22:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46901 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab1EBBTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:19:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=vA+ogolutdsk2YqGPQEIv4RkS8BOT2/g3mnDnwHcBXxZNgdn/Vf/VWpr8bwXSEDTl
	h+rMQkx+bQfGdVckxc0kQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 06/19] sched: update source_load(), target_load() and weighted_cpuload() to use u64
Date: Sun,  1 May 2011 18:19:04 -0700
Message-Id: <1304299157-25769-7-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

source_load(), target_load() and weighted_cpuload() refer to values in
rq->cpu_load, which is now u64. Update these functions to return u64 as well.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f2eb816..a49ef0e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1473,7 +1473,7 @@ static int tg_nop(struct task_group *tg, void *data)
 
 #ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
-static unsigned long weighted_cpuload(const int cpu)
+static u64 weighted_cpuload(const int cpu)
 {
 	return cpu_rq(cpu)->load.weight;
 }
@@ -1485,10 +1485,10 @@ static unsigned long weighted_cpuload(const int cpu)
  * We want to under-estimate the load of migration sources, to
  * balance conservatively.
  */
-static unsigned long source_load(int cpu, int type)
+static u64 source_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
+	u64 total = weighted_cpuload(cpu);
 
 	if (type == 0 || !sched_feat(LB_BIAS))
 		return total;
@@ -1500,10 +1500,10 @@ static unsigned long source_load(int cpu, int type)
  * Return a high guess at the load of a migration-target cpu weighted
  * according to the scheduling class and "nice" value.
  */
-static unsigned long target_load(int cpu, int type)
+static u64 target_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
+	u64 total = weighted_cpuload(cpu);
 
 	if (type == 0 || !sched_feat(LB_BIAS))
 		return total;
-- 
1.7.3.1

