Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab1EBWFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:05:15 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48831 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758893Ab1EBWFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:05:04 -0400
Message-Id: <20110502213213.043784689@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFC patch 11/32] trace event module remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-module-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/trace/events/module.h |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/include/trace/events/module.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/module.h
+++ linux-2.6-lttng/include/trace/events/module.h
@@ -18,6 +18,9 @@
 
 #ifdef CONFIG_MODULES
 
+#ifndef _TRACE_MODULE_DEF_
+#define _TRACE_MODULE_DEF_
+
 struct module;
 
 #define show_module_flags(flags) __print_flags(flags, "",	\
@@ -25,6 +28,8 @@ struct module;
 	{ (1UL << TAINT_FORCED_MODULE),		"F" },		\
 	{ (1UL << TAINT_CRAP),			"C" })
 
+#endif /* _TRACE_MODULE_DEF_ */
+
 TRACE_EVENT(module_load,
 
 	TP_PROTO(struct module *mod),
@@ -42,7 +47,7 @@ TRACE_EVENT(module_load,
 	),
 
 	TP_printk("%s %s", __get_str(name), show_module_flags(__entry->taints))
-);
+)
 
 TRACE_EVENT(module_free,
 
@@ -59,7 +64,7 @@ TRACE_EVENT(module_free,
 	),
 
 	TP_printk("%s", __get_str(name))
-);
+)
 
 #ifdef CONFIG_MODULE_UNLOAD
 /* trace_module_get/put are only used if CONFIG_MODULE_UNLOAD is defined */
@@ -84,21 +89,21 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_printk("%s call_site=%pf refcnt=%d",
 		  __get_str(name), (void *)__entry->ip, __entry->refcnt)
-);
+)
 
 DEFINE_EVENT(module_refcnt, module_get,
 
 	TP_PROTO(struct module *mod, unsigned long ip),
 
 	TP_ARGS(mod, ip)
-);
+)
 
 DEFINE_EVENT(module_refcnt, module_put,
 
 	TP_PROTO(struct module *mod, unsigned long ip),
 
 	TP_ARGS(mod, ip)
-);
+)
 #endif /* CONFIG_MODULE_UNLOAD */
 
 TRACE_EVENT(module_request,
@@ -121,7 +126,7 @@ TRACE_EVENT(module_request,
 
 	TP_printk("%s wait=%d call_site=%pf",
 		  __get_str(name), (int)__entry->wait, (void *)__entry->ip)
-);
+)
 
 #endif /* CONFIG_MODULES */
 

