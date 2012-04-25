Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080Ab2DYNqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:46:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954Ab2DYNqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:46:19 -0400
Date: Wed, 25 Apr 2012 06:45:51 -0700
From: tip-bot for Mark Brown <broonie@opensource.wolfsonmicro.com>
Message-ID: <tip-6e48b550d1f5f1919e6500547ae14a73fbf66c7b@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com,
        broonie@opensource.wolfsonmicro.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de
In-Reply-To: <1334307179-21255-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334307179-21255-1-git-send-email-broonie@opensource.wolfsonmicro.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing:
  Fix build breakage without CONFIG_PERF_EVENTS (again)
Git-Commit-ID: 6e48b550d1f5f1919e6500547ae14a73fbf66c7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:45:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e48b550d1f5f1919e6500547ae14a73fbf66c7b
Gitweb:     http://git.kernel.org/tip/6e48b550d1f5f1919e6500547ae14a73fbf66c7b
Author:     Mark Brown <broonie@opensource.wolfsonmicro.com>
AuthorDate: Fri, 13 Apr 2012 09:52:59 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 13 Apr 2012 21:37:04 -0400

tracing: Fix build breakage without CONFIG_PERF_EVENTS (again)

Today's -next fails to link for me:

kernel/built-in.o:(.data+0x178e50): undefined reference to `perf_ftrace_event_register'

It looks like multiple fixes have been merged for the issue fixed by
commit fa73dc9 (tracing: Fix build breakage without CONFIG_PERF_EVENTS)
though I can't identify the other changes that have gone in at the
minute, it's possible that the changes which caused the breakage fixed
by the previous commit got dropped but the fix made it in.

Link: http://lkml.kernel.org/r/1334307179-21255-1-git-send-email-broonie@opensource.wolfsonmicro.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 95059f0..f95d65d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -836,11 +836,11 @@ extern const char *__stop___trace_bprintk_fmt[];
 		     filter)
 #include "trace_entries.h"
 
-#ifdef CONFIG_FUNCTION_TRACER
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_FUNCTION_TRACER)
 int perf_ftrace_event_register(struct ftrace_event_call *call,
 			       enum trace_reg type, void *data);
 #else
 #define perf_ftrace_event_register NULL
-#endif /* CONFIG_FUNCTION_TRACER */
+#endif
 
 #endif /* _LINUX_KERNEL_TRACE_H */
