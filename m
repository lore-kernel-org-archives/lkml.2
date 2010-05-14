Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522Ab0ENTdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:33:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab0ENT3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:29:17 -0400
X-Authority-Analysis: v=1.1 cv=QBaIlYAip0cLYvdi/Wu3On4+kilSXYulM+a9j4asJ0c= c=1 sm=0 a=Otkvz5De_Y8A:10 a=UBIxAjGgU1YA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=7d_E57ReAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8 a=JfrnYn6hAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=aRxwj0jBu9btZCKQ5NkA:9 a=MdYbQJTnQu1bAF1be6EA:7 a=Lur0vIgR7g6bnk8DvSBUADHxdnQA:4 a=D6-X0JM3zdQA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jbrJJM5MRmoA:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=oUQuMaGMe1cA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100514192914.080757779@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 May 2010 15:22:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/13 v3] tracepoints: Add check trace callback type
References: <20100514192246.079025623@goodmis.org>
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

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20100430165959.GA25605@Krystal>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Li Zefan <lizf@cn.fujitsu.com>
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


