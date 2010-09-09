Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0IITsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:48:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:32976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab0IITsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:48:40 -0400
Date: Thu, 9 Sep 2010 19:48:20 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Unindent labels
Message-ID: <tip-9ed6060d286b1eb55974d09080f442f809408c42@git.kernel.org>
Git-Commit-ID: 9ed6060d286b1eb55974d09080f442f809408c42
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:48:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ed6060d286b1eb55974d09080f442f809408c42
Gitweb:     http://git.kernel.org/tip/9ed6060d286b1eb55974d09080f442f809408c42
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 Jun 2010 17:36:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:28 +0200

perf: Unindent labels

Fixup random annoying style bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   43 ++++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 288ce43..149ca18 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -147,7 +147,7 @@ perf_lock_task_context(struct task_struct *task, unsigned long *flags)
 	struct perf_event_context *ctx;
 
 	rcu_read_lock();
- retry:
+retry:
 	ctx = rcu_dereference(task->perf_event_ctxp);
 	if (ctx) {
 		/*
@@ -619,7 +619,7 @@ void perf_event_disable(struct perf_event *event)
 		return;
 	}
 
- retry:
+retry:
 	task_oncpu_function_call(task, __perf_event_disable, event);
 
 	raw_spin_lock_irq(&ctx->lock);
@@ -849,7 +849,7 @@ static void __perf_install_in_context(void *info)
 	if (!err && !ctx->task && cpuctx->max_pertask)
 		cpuctx->max_pertask--;
 
- unlock:
+unlock:
 	perf_enable();
 
 	raw_spin_unlock(&ctx->lock);
@@ -922,10 +922,12 @@ static void __perf_event_mark_enabled(struct perf_event *event,
 
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
@@ -991,7 +993,7 @@ static void __perf_event_enable(void *info)
 		}
 	}
 
- unlock:
+unlock:
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -1032,7 +1034,7 @@ void perf_event_enable(struct perf_event *event)
 	if (event->state == PERF_EVENT_STATE_ERROR)
 		event->state = PERF_EVENT_STATE_OFF;
 
- retry:
+retry:
 	raw_spin_unlock_irq(&ctx->lock);
 	task_oncpu_function_call(task, __perf_event_enable, event);
 
@@ -1052,7 +1054,7 @@ void perf_event_enable(struct perf_event *event)
 	if (event->state == PERF_EVENT_STATE_OFF)
 		__perf_event_mark_enabled(event, ctx);
 
- out:
+out:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
@@ -1092,17 +1094,19 @@ static void ctx_sched_out(struct perf_event_context *ctx,
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
 
@@ -1341,9 +1345,10 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		if (event->cpu != -1 && event->cpu != smp_processor_id())
 			continue;
 
-		if (group_can_go_on(event, cpuctx, can_add_hw))
+		if (group_can_go_on(event, cpuctx, can_add_hw)) {
 			if (group_sched_in(event, cpuctx, ctx))
 				can_add_hw = 0;
+		}
 	}
 }
 
@@ -1373,7 +1378,7 @@ ctx_sched_in(struct perf_event_context *ctx,
 		ctx_flexible_sched_in(ctx, cpuctx);
 
 	perf_enable();
- out:
+out:
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -1714,7 +1719,7 @@ static void perf_event_enable_on_exec(struct task_struct *task)
 	raw_spin_unlock(&ctx->lock);
 
 	perf_event_task_sched_in(task);
- out:
+out:
 	local_irq_restore(flags);
 }
 
@@ -2053,7 +2058,7 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto errout;
 
- retry:
+retry:
 	ctx = perf_lock_task_context(task, &flags);
 	if (ctx) {
 		unclone_ctx(ctx);
@@ -2081,7 +2086,7 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
 	put_task_struct(task);
 	return ctx;
 
- errout:
+errout:
 	put_task_struct(task);
 	return ERR_PTR(err);
 }
@@ -3264,7 +3269,7 @@ again:
 	if (handle->wakeup != local_read(&buffer->wakeup))
 		perf_output_wakeup(handle);
 
- out:
+out:
 	preempt_enable();
 }
 
@@ -4562,7 +4567,7 @@ static int swevent_hlist_get_cpu(struct perf_event *event, int cpu)
 		rcu_assign_pointer(cpuctx->swevent_hlist, hlist);
 	}
 	cpuctx->hlist_refcount++;
- exit:
+exit:
 	mutex_unlock(&cpuctx->hlist_mutex);
 
 	return err;
@@ -4587,7 +4592,7 @@ static int swevent_hlist_get(struct perf_event *event)
 	put_online_cpus();
 
 	return 0;
- fail:
+fail:
 	for_each_possible_cpu(cpu) {
 		if (cpu == failed_cpu)
 			break;
