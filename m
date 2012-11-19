Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2KSF3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:51 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53033 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2KSF3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:49 -0500
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 21/58] kernel/events/core.c: Mark internal function static
Date: Sun, 18 Nov 2012 21:28:00 -0800
Message-Id: <1353302917-13995-22-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of kernel/events/core.c references perf_cgroup_switch,
perf_init_event, or perf_event_init_context; mark these functions
static.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/events/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dbccf83..01ba4db 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -351,7 +351,7 @@ perf_cgroup_set_timestamp(struct task_struct *task,
  * mode SWOUT : schedule out everything
  * mode SWIN : schedule in based on cgroup for next
  */
-void perf_cgroup_switch(struct task_struct *task, int mode)
+static void perf_cgroup_switch(struct task_struct *task, int mode)
 {
 	struct perf_cpu_context *cpuctx;
 	struct pmu *pmu;
@@ -6064,7 +6064,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	free_pmu_context(pmu);
 }
 
-struct pmu *perf_init_event(struct perf_event *event)
+static struct pmu *perf_init_event(struct perf_event *event)
 {
 	struct pmu *pmu = NULL;
 	int idx;
@@ -7139,7 +7139,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 /*
  * Initialize the perf_event context in task_struct
  */
-int perf_event_init_context(struct task_struct *child, int ctxn)
+static int perf_event_init_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event_context *child_ctx, *parent_ctx;
 	struct perf_event_context *cloned_ctx;
-- 
1.7.10.4

