Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030328Ab2CWTek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:34:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466Ab2CWTei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:34:38 -0400
X-Authority-Analysis: v=2.0 cv=LrMQOwhc c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Pfmnb9fCRyIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=a_U1oVfrAAAA:8 a=meVymXHHAAAA:8 a=8zfsAEaaXGeNgXxmyHEA:9 a=PUjeQqilurYA:10 a=k4qQewaewV0A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332531275.23924.69.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.4] tracing: Fix ftrace stack trace entries
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, ingo Molnar <mingo@kernel.org>,
        Wolfgang Mauerer <wolfgang.mauerer@siemens.com>,
        stable <stable@vger.kernel.org>
Date: Fri, 23 Mar 2012 15:34:35 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 01de982abf8c9e10fc3089e10585cd2cc914bdab


Wolfgang Mauerer (1):
      tracing: Fix ftrace stack trace entries

----
 kernel/trace/trace_entries.h |   16 ++++++++++++----
 kernel/trace/trace_export.c  |    2 +-
 2 files changed, 13 insertions(+), 5 deletions(-)
---------------------------
commit 01de982abf8c9e10fc3089e10585cd2cc914bdab
Author: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Date:   Thu Mar 22 11:18:20 2012 +0100

    tracing: Fix ftrace stack trace entries
    
    8 hex characters tell only half the tale for 64 bit CPUs,
    so use the appropriate length.
    
    Link: http://lkml.kernel.org/r/1332411501-8059-2-git-send-email-wolfgang.mauerer@siemens.com
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 9336590..205dcac 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -156,6 +156,12 @@ FTRACE_ENTRY_DUP(wakeup, ctx_switch_entry,
 
 #define FTRACE_STACK_ENTRIES	8
 
+#ifndef CONFIG_64BIT
+# define IP_FMT "%08lx"
+#else
+# define IP_FMT "%016lx"
+#endif
+
 FTRACE_ENTRY(kernel_stack, stack_entry,
 
 	TRACE_STACK,
@@ -165,8 +171,9 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 		__dynamic_array(unsigned long,	caller	)
 	),
 
-	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
-		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+	F_printk("\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
 		 __entry->caller[6], __entry->caller[7])
@@ -181,8 +188,9 @@ FTRACE_ENTRY(user_stack, userstack_entry,
 		__array(	unsigned long,	caller, FTRACE_STACK_ENTRIES	)
 	),
 
-	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
-		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+	F_printk("\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
+		 "\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n",
 		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
 		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
 		 __entry->caller[6], __entry->caller[7])
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index bbeec31..ad4000c 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -150,7 +150,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 #define __dynamic_array(type, item)
 
 #undef F_printk
-#define F_printk(fmt, args...) #fmt ", "  __stringify(args)
+#define F_printk(fmt, args...) __stringify(fmt) ", "  __stringify(args)
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\


