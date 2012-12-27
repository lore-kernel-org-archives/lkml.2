Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab2L0CuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:50:04 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58858 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2L0Ctt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:49:49 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-e4-50dbb74a3ed5
From: Namhyung Kim <namhyung@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Steven Rostedt <rostedt@goodmis.org>,
        Fredereic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/2] tracing: Use sched_clock_cpu for trace_clock_global
Date: Thu, 27 Dec 2012 11:49:45 +0900
Message-Id: <1356576585-28782-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356576585-28782-1-git-send-email-namhyung@kernel.org>
References: <1356576585-28782-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For systems have unstable sched_clock, all cpu_clock() does is enable/
disable local irq during call to sched_clock().  And for stable systems
they are same.

As in trace_clock_global(), we already does it for local irq, calling
sched_clock_cpu() directly would be appropriate.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Fredereic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 394783531cbb..795f077978a8 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -86,7 +86,7 @@ u64 notrace trace_clock_global(void)
 	local_irq_save(flags);
 
 	this_cpu = raw_smp_processor_id();
-	now = cpu_clock(this_cpu);
+	now = sched_clock_cpu(this_cpu);
 	/*
 	 * If in an NMI context then dont risk lockups and return the
 	 * cpu_clock() time:
-- 
1.7.11.7

