Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab1AIWFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:05:46 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:58740 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab1AIWFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:43 -0500
Message-Id: <20110109220510.887593848@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
        Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [RFC patch 17/28] trace event scsi remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-scsi-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:11 +0000
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
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
CC: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
CC: James Bottomley <James.Bottomley@suse.de>
CC: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/trace/events/scsi.h |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/include/trace/events/scsi.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/scsi.h
+++ linux-2.6-lttng/include/trace/events/scsi.h
@@ -9,6 +9,9 @@
 #include <linux/tracepoint.h>
 #include <linux/trace_seq.h>
 
+#ifndef _TRACE_SCSI_DEF_
+#define _TRACE_SCSI_DEF_
+
 #define scsi_opcode_name(opcode)	{ opcode, #opcode }
 #define show_opcode_name(val)					\
 	__print_symbolic(val,					\
@@ -187,6 +190,8 @@
 const char *scsi_trace_parse_cdb(struct trace_seq*, unsigned char*, int);
 #define __parse_cdb(cdb, len) scsi_trace_parse_cdb(p, cdb, len)
 
+#endif /* _TRACE_SCSI_DEF_ */
+
 TRACE_EVENT(scsi_dispatch_cmd_start,
 
 	TP_PROTO(struct scsi_cmnd *cmd),
@@ -224,7 +229,7 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
-);
+)
 
 TRACE_EVENT(scsi_dispatch_cmd_error,
 
@@ -266,7 +271,7 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __entry->rtn)
-);
+)
 
 DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 
@@ -312,15 +317,15 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeou
 		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
 		  show_msgbyte_name(((__entry->result) >> 8) & 0xff),
 		  show_statusbyte_name(__entry->result & 0xff))
-);
+)
 
 DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
 	     TP_PROTO(struct scsi_cmnd *cmd),
-	     TP_ARGS(cmd));
+	     TP_ARGS(cmd))
 
 DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_timeout,
 	     TP_PROTO(struct scsi_cmnd *cmd),
-	     TP_ARGS(cmd));
+	     TP_ARGS(cmd))
 
 TRACE_EVENT(scsi_eh_wakeup,
 
@@ -337,7 +342,7 @@ TRACE_EVENT(scsi_eh_wakeup,
 	),
 
 	TP_printk("host_no=%u", __entry->host_no)
-);
+)
 
 #endif /*  _TRACE_SCSI_H */
 

