Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab1DITXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:23:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab1DITWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:22:46 -0400
Message-Id: <20110409192142.090431763@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 09 Apr 2011 21:17:48 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 9/9] perf: De-schedule a task context when removing the last event
References: <20110409191739.813727025@chello.nl>
Content-Disposition: inline; filename=perf-deactivate-on-close.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1114,6 +1114,10 @@ static int __perf_remove_from_context(vo
 	raw_spin_lock(&ctx->lock);
 	event_sched_out(event, cpuctx, ctx);
 	list_del_event(event, ctx);
+	if (!ctx->nr_events && cpuctx->task_ctx == ctx) {
+		ctx->is_active = 0;
+		cpuctx->task_ctx = NULL;
+	}
 	raw_spin_unlock(&ctx->lock);
 
 	return 0;


