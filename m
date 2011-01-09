Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1AIWKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:10:30 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35708 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1AIWF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:28 -0500
Message-Id: <20110109220509.267222950@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>
Subject: [RFC patch 07/28] trace event jbd2 remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-jbd2-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:09 +0000
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
CC: Theodore Ts'o <tytso@mit.edu>
---
 include/trace/events/jbd2.h |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

Index: linux-2.6-lttng/include/trace/events/jbd2.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/jbd2.h
+++ linux-2.6-lttng/include/trace/events/jbd2.h
@@ -7,9 +7,14 @@
 #include <linux/jbd2.h>
 #include <linux/tracepoint.h>
 
+#ifndef _TRACE_JBD2_DEF_
+#define _TRACE_JBD2_DEF_
+
 struct transaction_chp_stats_s;
 struct transaction_run_stats_s;
 
+#endif /* _TRACE_JBD2_DEF_ */
+
 TRACE_EVENT(jbd2_checkpoint,
 
 	TP_PROTO(journal_t *journal, int result),
@@ -30,7 +35,7 @@ TRACE_EVENT(jbd2_checkpoint,
 
 	TP_printk("dev %d,%d result %d",
 		  __entry->dev_major, __entry->dev_minor, __entry->result)
-);
+)
 
 DECLARE_EVENT_CLASS(jbd2_commit,
 
@@ -55,35 +60,35 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 	TP_printk("dev %d,%d transaction %d sync %d",
 		  __entry->dev_major, __entry->dev_minor,
 		  __entry->transaction, __entry->sync_commit)
-);
+)
 
 DEFINE_EVENT(jbd2_commit, jbd2_start_commit,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
-);
+)
 
 DEFINE_EVENT(jbd2_commit, jbd2_commit_locking,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
-);
+)
 
 DEFINE_EVENT(jbd2_commit, jbd2_commit_flushing,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
-);
+)
 
 DEFINE_EVENT(jbd2_commit, jbd2_commit_logging,
 
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
 
 	TP_ARGS(journal, commit_transaction)
-);
+)
 
 TRACE_EVENT(jbd2_end_commit,
 	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
@@ -109,7 +114,7 @@ TRACE_EVENT(jbd2_end_commit,
 	TP_printk("dev %d,%d transaction %d sync %d head %d",
 		  __entry->dev_major, __entry->dev_minor,
 		  __entry->transaction, __entry->sync_commit, __entry->head)
-);
+)
 
 TRACE_EVENT(jbd2_submit_inode_data,
 	TP_PROTO(struct inode *inode),
@@ -131,7 +136,7 @@ TRACE_EVENT(jbd2_submit_inode_data,
 	TP_printk("dev %d,%d ino %lu",
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino)
-);
+)
 
 TRACE_EVENT(jbd2_run_stats,
 	TP_PROTO(dev_t dev, unsigned long tid,
@@ -177,7 +182,7 @@ TRACE_EVENT(jbd2_run_stats,
 		  jiffies_to_msecs(__entry->logging),
 		  __entry->handle_count, __entry->blocks,
 		  __entry->blocks_logged)
-);
+)
 
 TRACE_EVENT(jbd2_checkpoint_stats,
 	TP_PROTO(dev_t dev, unsigned long tid,
@@ -210,7 +215,7 @@ TRACE_EVENT(jbd2_checkpoint_stats,
 		  __entry->dev_major, __entry->dev_minor, __entry->tid,
 		  jiffies_to_msecs(__entry->chp_time),
 		  __entry->forced_to_close, __entry->written, __entry->dropped)
-);
+)
 
 TRACE_EVENT(jbd2_cleanup_journal_tail,
 
@@ -241,7 +246,7 @@ TRACE_EVENT(jbd2_cleanup_journal_tail,
 		  __entry->dev_major, __entry->dev_minor,
 		  __entry->tail_sequence, __entry->first_tid,
 		  __entry->block_nr, __entry->freed)
-);
+)
 
 #endif /* _TRACE_JBD2_H */
 

