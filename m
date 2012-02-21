Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2BUUDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:03:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab2BUUD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:03:29 -0500
Date: Tue, 21 Feb 2012 15:03:08 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Message-Id: <70665b8c27c81bb930e2facec738acdf42643765.1329851692.git.jbaron@redhat.com>
In-Reply-To: <cover.1329851692.git.jbaron@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
Subject: [PATCH 05/10] perf: update to use 'very_unlikely()'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update perf functions with api change: static_branch() -> very_unlikely().

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/perf_event.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 412b790..041d02b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1066,7 +1066,7 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 {
 	struct pt_regs hot_regs;
 
-	if (static_branch(&perf_swevent_enabled[event_id])) {
+	if (very_unlikely(&perf_swevent_enabled[event_id])) {
 		if (!regs) {
 			perf_fetch_caller_regs(&hot_regs);
 			regs = &hot_regs;
@@ -1080,7 +1080,7 @@ extern struct jump_label_key_deferred perf_sched_events;
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
-	if (static_branch(&perf_sched_events.key))
+	if (very_unlikely(&perf_sched_events.key))
 		__perf_event_task_sched_in(prev, task);
 }
 
@@ -1089,7 +1089,7 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
-	if (static_branch(&perf_sched_events.key))
+	if (very_unlikely(&perf_sched_events.key))
 		__perf_event_task_sched_out(prev, next);
 }
 
-- 
1.7.7.5

