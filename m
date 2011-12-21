Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab1LUTK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:10:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab1LUTJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:09:24 -0500
Date: Wed, 21 Dec 2011 14:09:10 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        mingo@elte.hu, davem@davemloft.net, ddaney.cavm@gmail.com,
        pjt@google.com, rth@redhat.com, linux-kernel@vger.kernel.org
Message-Id: <f8742113d3e6d97252d31f96f21a9589cca89762.1324493360.git.jbaron@redhat.com>
In-Reply-To: <cover.1324493360.git.jbaron@redhat.com>
References: <cover.1324493360.git.jbaron@redhat.com>
Subject: [PATCH 2/4] perf: Make use of updated jump label API.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new jump label API.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/perf_event.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 564769c..a91989f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1055,7 +1055,7 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 {
 	struct pt_regs hot_regs;
 
-	if (static_branch(&perf_swevent_enabled[event_id])) {
+	if (static_branch_def_false(&perf_swevent_enabled[event_id])) {
 		if (!regs) {
 			perf_fetch_caller_regs(&hot_regs);
 			regs = &hot_regs;
@@ -1069,7 +1069,7 @@ extern struct jump_label_key_deferred perf_sched_events;
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
-	if (static_branch(&perf_sched_events.key))
+	if (static_branch_def_false(&perf_sched_events.key))
 		__perf_event_task_sched_in(prev, task);
 }
 
@@ -1078,7 +1078,7 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
-	if (static_branch(&perf_sched_events.key))
+	if (static_branch_def_false(&perf_sched_events.key))
 		__perf_event_task_sched_out(prev, next);
 }
 
-- 
1.7.7.3

