Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab0FPQIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:08:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:33953 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759207Ab0FPQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:06:35 -0400
Message-Id: <20100616160238.347022826@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 16 Jun 2010 18:00:31 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/8] perf: Unindent labels
References: <20100616160027.590430763@chello.nl>
Content-Disposition: inline; filename=perf-whitespace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup random annoying style bits

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -147,7 +147,7 @@ perf_lock_task_context(struct task_struc
 	struct perf_event_context *ctx;
 
 	rcu_read_lock();
- retry:
+retry:
 	ctx = rcu_dereference(task->perf_event_ctxp);
 	if (ctx) {
 		/*
@@ -601,7 +601,7 @@ void perf_event_disable(struct perf_even
 		return;
 	}
 
- retry:
+retry:
 	task_oncpu_function_call(task, __perf_event_disable, event);
 
 	raw_spin_lock_irq(&ctx->lock);
@@ -831,7 +831,7 @@ static void __perf_install_in_context(vo
 	if (!err && !ctx->task && cpuctx->max_pertask)
 		cpuctx->max_pertask--;
 
- unlock:
+unlock:
 	perf_enable();
 
 	raw_spin_unlock(&ctx->lock);
@@ -904,10 +904,12 @@ static void __perf_event_mark_enabled(st
 
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	event->tstamp_enabled = ctx->time - event->total_time_enabled;
-	list_for_each_entry(sub, &event->sibling_list, group_entry)
-		if (sub->state >= PERF_EVENT_STATE_INACTIVE)
+	list_for_each_entry(sub, &event->sibling_list, group_entry) {
+		if (sub->state >= PERF_EVENT_STATE_INACTIVE) {
 			sub->tstamp_enabled =
 				ctx->time - sub->total_time_enabled;
+		}
+	}
 }
 
 /*
@@ -973,7 +975,7 @@ static void __perf_event_enable(void *in
 		}
 	}
 
- unlock:
+unlock:
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -1014,7 +1016,7 @@ void perf_event_enable(struct perf_event
 	if (event->state == PERF_EVENT_STATE_ERROR)
 		event->state = PERF_EVENT_STATE_OFF;
 
- retry:
+retry:
 	raw_spin_unlock_irq(&ctx->lock);
 	task_oncpu_function_call(task, __perf_event_enable, event);
 
@@ -1034,7 +1036,7 @@ void perf_event_enable(struct perf_event
 	if (event->state == PERF_EVENT_STATE_OFF)
 		__perf_event_mark_enabled(event, ctx);
 
- out:
+out:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
@@ -1074,17 +1076,19 @@ static void ctx_sched_out(struct perf_ev
 	if (!ctx->nr_active)
 		goto out_enable;
 
-	if (event_type & EVENT_PINNED)
+	if (event_type & EVENT_PINNED) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
+	}
 
-	if (event_type & EVENT_FLEXIBLE)
+	if (event_type & EVENT_FLEXIBLE) {
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
+	}
 
  out_enable:
 	perf_enable();
- out:
+out:
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -1323,9 +1327,10 @@ ctx_flexible_sched_in(struct perf_event_
 		if (event->cpu != -1 && event->cpu != smp_processor_id())
 			continue;
 
-		if (group_can_go_on(event, cpuctx, can_add_hw))
+		if (group_can_go_on(event, cpuctx, can_add_hw)) {
 			if (group_sched_in(event, cpuctx, ctx))
 				can_add_hw = 0;
+		}
 	}
 }
 
@@ -1355,7 +1360,7 @@ ctx_sched_in(struct perf_event_context *
 		ctx_flexible_sched_in(ctx, cpuctx);
 
 	perf_enable();
- out:
+out:
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -1696,7 +1701,7 @@ static void perf_event_enable_on_exec(st
 	raw_spin_unlock(&ctx->lock);
 
 	perf_event_task_sched_in(task);
- out:
+out:
 	local_irq_restore(flags);
 }
 
@@ -1825,7 +1830,7 @@ static struct perf_event_context *find_g
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto errout;
 
- retry:
+retry:
 	ctx = perf_lock_task_context(task, &flags);
 	if (ctx) {
 		unclone_ctx(ctx);
@@ -1853,7 +1858,7 @@ static struct perf_event_context *find_g
 	put_task_struct(task);
 	return ctx;
 
- errout:
+errout:
 	put_task_struct(task);
 	return ERR_PTR(err);
 }
@@ -3044,7 +3049,7 @@ again:
 	if (handle->wakeup != local_read(&buffer->wakeup))
 		perf_output_wakeup(handle);
 
- out:
+out:
 	preempt_enable();
 }
 
@@ -4347,7 +4352,7 @@ static int swevent_hlist_get_cpu(struct 
 		rcu_assign_pointer(cpuctx->swevent_hlist, hlist);
 	}
 	cpuctx->hlist_refcount++;
- exit:
+exit:
 	mutex_unlock(&cpuctx->hlist_mutex);
 
 	return err;
@@ -4372,7 +4377,7 @@ static int swevent_hlist_get(struct perf
 	put_online_cpus();
 
 	return 0;
- fail:
+fail:
 	for_each_possible_cpu(cpu) {
 		if (cpu == failed_cpu)
 			break;


