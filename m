Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690Ab2DLUZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:25:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3825 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab2DLUZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:25:02 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=pAjnK2qy4rYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=wggVRkVUAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5YWXfo7AIRkxRmx-P0oA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334262300.23924.348.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.4] tracing: Fix build breakage without
 CONFIG_PERF_EVENTS (again)
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Date: Thu, 12 Apr 2012 16:25:00 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Linux mainline compile is broken for archs that can disable CONFIG_PERF_EVENTS.
Without this patch, arm fails to build, but with it, it works fine.

The breakage went in during the 3.4 merge window.

-- Steve


Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 12524b1bcf06b86bba3869772084a5fd7a0db61d


Mark Brown (1):
      tracing: Fix build breakage without CONFIG_PERF_EVENTS (again)

----
 kernel/trace/trace.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)
---------------------------
commit 12524b1bcf06b86bba3869772084a5fd7a0db61d
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Wed Apr 11 09:20:29 2012 +0100

    tracing: Fix build breakage without CONFIG_PERF_EVENTS (again)
    
    Today's -next fails to link for me:
    
    kernel/built-in.o:(.data+0x178e50): undefined reference to `perf_ftrace_event_register'
    
    It looks like multiple fixes have been merged for the issue fixed by
    commit fa73dc9 (tracing: Fix build breakage without CONFIG_PERF_EVENTS)
    though I can't identify the other changes that have gone in at the
    minute, it's possible that the changes which caused the breakage fixed
    by the previous commit got dropped but the fix made it in.
    
    Link: http://lkml.kernel.org/r/1334132429-6091-1-git-send-email-broonie@opensource.wolfsonmicro.com
    
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 95059f0..ff639ca 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -836,11 +836,15 @@ extern const char *__stop___trace_bprintk_fmt[];
 		     filter)
 #include "trace_entries.h"
 
+#ifdef CONFIG_PERF_EVENTS
 #ifdef CONFIG_FUNCTION_TRACER
 int perf_ftrace_event_register(struct ftrace_event_call *call,
 			       enum trace_reg type, void *data);
 #else
 #define perf_ftrace_event_register NULL
 #endif /* CONFIG_FUNCTION_TRACER */
+#else
+#define perf_ftrace_event_register NULL
+#endif /* CONFIG_PERF_EVENTS */
 
 #endif /* _LINUX_KERNEL_TRACE_H */


