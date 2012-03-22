Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030905Ab2CVVUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:20:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab2CVVUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:20:35 -0400
Date: Thu, 22 Mar 2012 14:20:19 -0700
From: tip-bot for Mark Brown <broonie@opensource.wolfsonmicro.com>
Message-ID: <tip-fa73dc9400516945bcbae8d98c23393bcefe1440@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        broonie@opensource.wolfsonmicro.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, jolsa@redhat.com, fweisbec@gmail.com,
        broonie@opensource.wolfsonmicro.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing:
  Fix build breakage without CONFIG_PERF_EVENTS
Git-Commit-ID: fa73dc9400516945bcbae8d98c23393bcefe1440
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 22 Mar 2012 14:20:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa73dc9400516945bcbae8d98c23393bcefe1440
Gitweb:     http://git.kernel.org/tip/fa73dc9400516945bcbae8d98c23393bcefe1440
Author:     Mark Brown <broonie@opensource.wolfsonmicro.com>
AuthorDate: Tue, 28 Feb 2012 11:02:46 +0000
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 13 Mar 2012 18:34:59 -0400

tracing: Fix build breakage without CONFIG_PERF_EVENTS

Today's -next fails to build for me:

  CC      kernel/trace/trace_export.o
In file included from kernel/trace/trace_export.c:197: kernel/trace/trace_entries.h:58: error: 'perf_ftrace_event_register' undeclared here (not in a function)
make[2]: *** [kernel/trace/trace_export.o] Error 1
make[1]: *** [kernel/trace] Error 2
make: *** [kernel] Error 2

because as of ced390 (ftrace, perf: Add support to use function
tracepoint in perf) perf_trace_event_register() is declared in trace.h
only if CONFIG_PERF_EVENTS is enabled but I don't have that set.

Ensure that we always have a definition of perf_trace_event_register()
by making the definition unconditional.

Link: http://lkml.kernel.org/r/1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ce887c0..95059f0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -836,13 +836,11 @@ extern const char *__stop___trace_bprintk_fmt[];
 		     filter)
 #include "trace_entries.h"
 
-#ifdef CONFIG_PERF_EVENTS
 #ifdef CONFIG_FUNCTION_TRACER
 int perf_ftrace_event_register(struct ftrace_event_call *call,
 			       enum trace_reg type, void *data);
 #else
 #define perf_ftrace_event_register NULL
 #endif /* CONFIG_FUNCTION_TRACER */
-#endif /* CONFIG_PERF_EVENTS */
 
 #endif /* _LINUX_KERNEL_TRACE_H */
