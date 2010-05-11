Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0EKDJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:09:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab0EKDJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:09:12 -0400
X-Authority-Analysis: v=1.1 cv=OMZqYO3L41gFG4eI735GctFZkIqa2t9YKv4cWfI71LE= c=1 sm=0 a=xy4a3M8ij0oA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=Z4Rwk6OoAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=iRrFxeVTYHbQNZdbrRgA:9 a=MdYbQJTnQu1bAF1be6EA:7 a=BVPYyhIVMf1ixIfLdVWZlY1mS4AA:4 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=jbrJJM5MRmoA:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=oUQuMaGMe1cA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100511030909.485664288@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 May 2010 23:00:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 02/10 -v3][RFC] tracepoints: Add check trace callback type
References: <20100511030020.837892321@goodmis.org>
Content-Disposition: inline; filename=0002-tracepoints-Add-check-trace-callback-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

This check is meant to be used by tracepoint users which do a direct cast of
callbacks to (void *) for direct registration, thus bypassing the
register_trace_##name and unregister_trace_##name checks.

This permits to ensure that the callback type matches the function type at the
call site, but without generating any code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20100430165959.GA25605@Krystal>
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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 1d85f9a..8d5e4f6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -137,9 +137,11 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
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
@@ -168,6 +170,9 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	static inline int unregister_trace_##name(void (*probe)(proto))	\
 	{								\
 		return -ENOSYS;						\
+	}								\
+	static inline void check_trace_callback_type_##name(void (*cb)(proto)) \
+	{								\
 	}
 
 #define DEFINE_TRACE_FN(name, reg, unreg)
-- 
1.7.0


