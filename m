Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1AIWIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:08:49 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:56318 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab1AIWFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:36 -0500
Message-Id: <20110109220510.076060539@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFC patch 12/28] trace event module remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-module-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:10 +0000
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
@@ -8,6 +8,9 @@
 
 #ifdef CONFIG_MODULES
 
+#ifndef _TRACE_MODULE_DEF_
+#define _TRACE_MODULE_DEF_
+
 struct module;
 
 #define show_module_flags(flags) __print_flags(flags, "",	\
@@ -15,6 +18,8 @@ struct module;
 	{ (1UL << TAINT_FORCED_MODULE),		"F" },		\
 	{ (1UL << TAINT_CRAP),			"C" })
 
+#endif /* _TRACE_MODULE_DEF_ */
+
 TRACE_EVENT(module_load,
 
 	TP_PROTO(struct module *mod),
@@ -32,7 +37,7 @@ TRACE_EVENT(module_load,
 	),
 
 	TP_printk("%s %s", __get_str(name), show_module_flags(__entry->taints))
-);
+)
 
 TRACE_EVENT(module_free,
 
@@ -49,7 +54,7 @@ TRACE_EVENT(module_free,
 	),
 
 	TP_printk("%s", __get_str(name))
-);
+)
 
 #ifdef CONFIG_MODULE_UNLOAD
 /* trace_module_get/put are only used if CONFIG_MODULE_UNLOAD is defined */
@@ -74,21 +79,21 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
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
@@ -111,7 +116,7 @@ TRACE_EVENT(module_request,
 
 	TP_printk("%s wait=%d call_site=%pf",
 		  __get_str(name), (int)__entry->wait, (void *)__entry->ip)
-);
+)
 
 #endif /* CONFIG_MODULES */
 

