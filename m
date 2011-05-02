Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab1EBVhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:37:54 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:37953 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab1EBVhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:37:51 -0400
Message-Id: <20110502213215.037905794@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mel Gorman <mel@csn.ul.ie>, Dave Chinner <dchinner@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC patch 23/32] trace event writeback remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-writeback-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:15 +0000
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
CC: Mel Gorman <mel@csn.ul.ie>
CC: Dave Chinner <dchinner@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Jeff Moyer <jmoyer@redhat.com>
---
 include/trace/events/writeback.h |   53 +++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

Index: linux-2.6-lttng/include/trace/events/writeback.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/writeback.h
+++ linux-2.6-lttng/include/trace/events/writeback.h
@@ -8,8 +8,13 @@
 #include <linux/device.h>
 #include <linux/writeback.h>
 
+#ifndef _TRACE_WRITEBACK_DEF_
+#define _TRACE_WRITEBACK_DEF_
+
 struct wb_writeback_work;
 
+#endif /* _TRACE_WRITEBACK_DEF_ */
+
 DECLARE_EVENT_CLASS(writeback_work_class,
 	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_work *work),
 	TP_ARGS(bdi, work),
@@ -41,14 +46,14 @@ DECLARE_EVENT_CLASS(writeback_work_class
 		  __entry->range_cyclic,
 		  __entry->for_background
 	)
-);
+)
 #define DEFINE_WRITEBACK_WORK_EVENT(name) \
 DEFINE_EVENT(writeback_work_class, name, \
 	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_work *work), \
 	TP_ARGS(bdi, work))
-DEFINE_WRITEBACK_WORK_EVENT(writeback_nothread);
-DEFINE_WRITEBACK_WORK_EVENT(writeback_queue);
-DEFINE_WRITEBACK_WORK_EVENT(writeback_exec);
+DEFINE_WRITEBACK_WORK_EVENT(writeback_nothread)
+DEFINE_WRITEBACK_WORK_EVENT(writeback_queue)
+DEFINE_WRITEBACK_WORK_EVENT(writeback_exec)
 
 TRACE_EVENT(writeback_pages_written,
 	TP_PROTO(long pages_written),
@@ -60,7 +65,7 @@ TRACE_EVENT(writeback_pages_written,
 		__entry->pages		= pages_written;
 	),
 	TP_printk("%ld", __entry->pages)
-);
+)
 
 DECLARE_EVENT_CLASS(writeback_class,
 	TP_PROTO(struct backing_dev_info *bdi),
@@ -74,20 +79,20 @@ DECLARE_EVENT_CLASS(writeback_class,
 	TP_printk("bdi %s",
 		  __entry->name
 	)
-);
+)
 #define DEFINE_WRITEBACK_EVENT(name) \
 DEFINE_EVENT(writeback_class, name, \
 	TP_PROTO(struct backing_dev_info *bdi), \
 	TP_ARGS(bdi))
 
-DEFINE_WRITEBACK_EVENT(writeback_nowork);
-DEFINE_WRITEBACK_EVENT(writeback_wake_background);
-DEFINE_WRITEBACK_EVENT(writeback_wake_thread);
-DEFINE_WRITEBACK_EVENT(writeback_wake_forker_thread);
-DEFINE_WRITEBACK_EVENT(writeback_bdi_register);
-DEFINE_WRITEBACK_EVENT(writeback_bdi_unregister);
-DEFINE_WRITEBACK_EVENT(writeback_thread_start);
-DEFINE_WRITEBACK_EVENT(writeback_thread_stop);
+DEFINE_WRITEBACK_EVENT(writeback_nowork)
+DEFINE_WRITEBACK_EVENT(writeback_wake_background)
+DEFINE_WRITEBACK_EVENT(writeback_wake_thread)
+DEFINE_WRITEBACK_EVENT(writeback_wake_forker_thread)
+DEFINE_WRITEBACK_EVENT(writeback_bdi_register)
+DEFINE_WRITEBACK_EVENT(writeback_bdi_unregister)
+DEFINE_WRITEBACK_EVENT(writeback_thread_start)
+DEFINE_WRITEBACK_EVENT(writeback_thread_stop)
 
 DECLARE_EVENT_CLASS(wbc_class,
 	TP_PROTO(struct writeback_control *wbc, struct backing_dev_info *bdi),
@@ -144,13 +149,13 @@ DECLARE_EVENT_CLASS(wbc_class,
 DEFINE_EVENT(wbc_class, name, \
 	TP_PROTO(struct writeback_control *wbc, struct backing_dev_info *bdi), \
 	TP_ARGS(wbc, bdi))
-DEFINE_WBC_EVENT(wbc_writeback_start);
-DEFINE_WBC_EVENT(wbc_writeback_written);
-DEFINE_WBC_EVENT(wbc_writeback_wait);
-DEFINE_WBC_EVENT(wbc_balance_dirty_start);
-DEFINE_WBC_EVENT(wbc_balance_dirty_written);
-DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
-DEFINE_WBC_EVENT(wbc_writepage);
+DEFINE_WBC_EVENT(wbc_writeback_start)
+DEFINE_WBC_EVENT(wbc_writeback_written)
+DEFINE_WBC_EVENT(wbc_writeback_wait)
+DEFINE_WBC_EVENT(wbc_balance_dirty_start)
+DEFINE_WBC_EVENT(wbc_balance_dirty_written)
+DEFINE_WBC_EVENT(wbc_balance_dirty_wait)
+DEFINE_WBC_EVENT(wbc_writepage)
 
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
@@ -171,21 +176,21 @@ DECLARE_EVENT_CLASS(writeback_congest_wa
 	TP_printk("usec_timeout=%u usec_delayed=%u",
 			__entry->usec_timeout,
 			__entry->usec_delayed)
-);
+)
 
 DEFINE_EVENT(writeback_congest_waited_template, writeback_congestion_wait,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
 
 	TP_ARGS(usec_timeout, usec_delayed)
-);
+)
 
 DEFINE_EVENT(writeback_congest_waited_template, writeback_wait_iff_congested,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
 
 	TP_ARGS(usec_timeout, usec_delayed)
-);
+)
 
 #endif /* _TRACE_WRITEBACK_H */
 

