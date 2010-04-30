Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab0D3TKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:10:08 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:34178 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757660Ab0D3RAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:00:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMyn2ktGGNqG/2dsb2JhbACdH3K+e4USBA
Date: Fri, 30 Apr 2010 12:59:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] tracepoints: add check trace callback type
Message-ID: <20100430165959.GA25605@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:50:15 up 23 days,  2:43,  4 users,  load average: 0.13, 0.11,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This check is meant to be used by tracepoint users which do a direct cast of
callbacks to (void *) for direct registration, thus bypassing the
register_trace_##name and unregister_trace_##name checks.

This permits to ensure that the callback type matches the function type at the
call site, but without generating any code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu> 
CC: Andrew Morton <akpm@linux-foundation.org> 
CC: Thomas Gleixner <tglx@linutronix.de> 
CC: Peter Zijlstra <peterz@infradead.org> 
CC: Frederic Weisbecker <fweisbec@gmail.com> 
CC: Arnaldo Carvalho de Melo <acme@redhat.com> 
CC: Lai Jiangshan <laijs@cn.fujitsu.com> 
CC: Li Zefan <lizf@cn.fujitsu.com> 
CC: Masami Hiramatsu <mhiramat@redhat.com> 
CC: Christoph Hellwig <hch@lst.de>
---
 include/linux/tracepoint.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux.trees.git/include/linux/tracepoint.h
===================================================================
--- linux.trees.git.orig/include/linux/tracepoint.h	2010-04-30 12:32:39.000000000 -0400
+++ linux.trees.git/include/linux/tracepoint.h	2010-04-30 12:57:55.000000000 -0400
@@ -78,9 +78,11 @@ struct tracepoint {
 	static inline int unregister_trace_##name(void (*probe)(proto))	\
 	{								\
 		return tracepoint_probe_unregister(#name, (void *)probe);\
+	}								\
+	static inline void check_trace_callback_type_##name(void (*cb)(proto)) \
+	{								\
 	}
 
-
 #define DEFINE_TRACE_FN(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
@@ -112,6 +114,9 @@ extern void tracepoint_update_probe_rang
 	static inline int unregister_trace_##name(void (*probe)(proto))	\
 	{								\
 		return -ENOSYS;						\
+	}								\
+	static inline void check_trace_callback_type_##name(void (*cb)(proto)) \
+	{								\
 	}
 
 #define DEFINE_TRACE_FN(name, reg, unreg)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
