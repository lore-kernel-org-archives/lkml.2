Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1DTUw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7879 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab1DTUwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=DJd+lVn2RcTpNVM6RhZWM2G4gDgAGy+CiMjhAeMvmKe2X+HDGqoj64Y1Xqj+UfxDW
	ufdATyg30wfwb15UjW9PQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 06/18] sched: update source_load(), target_load() and weighted_cpuload() to use u64
Date: Wed, 20 Apr 2011 13:51:25 -0700
Message-Id: <1303332697-16426-7-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
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
index 175764b..f0adb0e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1474,7 +1474,7 @@ static int tg_nop(struct task_group *tg, void *data)
 
 #ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
-static unsigned long weighted_cpuload(const int cpu)
+static u64 weighted_cpuload(const int cpu)
 {
 	return cpu_rq(cpu)->load.weight;
 }
@@ -1486,10 +1486,10 @@ static unsigned long weighted_cpuload(const int cpu)
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
@@ -1501,10 +1501,10 @@ static unsigned long source_load(int cpu, int type)
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

