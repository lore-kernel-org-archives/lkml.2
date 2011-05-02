Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab1EBWFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:05:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57353 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886Ab1EBWFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:05:10 -0400
Message-Id: <20110502213212.181691455@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>
Subject: [RFC patch 06/32] trace event jbd2 remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-jbd2-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:12 +0000
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
@@ -28,7 +33,7 @@ TRACE_EVENT(jbd2_checkpoint,
 
 	TP_printk("dev %s result %d",
 		  jbd2_dev_to_name(__entry->dev), __entry->result)
-);
+)
 
 DECLARE_EVENT_CLASS(jbd2_commit,
 
@@ -51,35 +56,35 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 	TP_printk("dev %s transaction %d sync %d",
 		  jbd2_dev_to_name(__entry->dev), __entry->transaction,
 		  __entry->sync_commit)
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
@@ -103,7 +108,7 @@ TRACE_EVENT(jbd2_end_commit,
 	TP_printk("dev %s transaction %d sync %d head %d",
 		  jbd2_dev_to_name(__entry->dev), __entry->transaction,
 		  __entry->sync_commit, __entry->head)
-);
+)
 
 TRACE_EVENT(jbd2_submit_inode_data,
 	TP_PROTO(struct inode *inode),
@@ -122,7 +127,7 @@ TRACE_EVENT(jbd2_submit_inode_data,
 
 	TP_printk("dev %s ino %lu",
 		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino)
-);
+)
 
 TRACE_EVENT(jbd2_run_stats,
 	TP_PROTO(dev_t dev, unsigned long tid,
@@ -166,7 +171,7 @@ TRACE_EVENT(jbd2_run_stats,
 		  jiffies_to_msecs(__entry->logging),
 		  __entry->handle_count, __entry->blocks,
 		  __entry->blocks_logged)
-);
+)
 
 TRACE_EVENT(jbd2_checkpoint_stats,
 	TP_PROTO(dev_t dev, unsigned long tid,
@@ -197,7 +202,7 @@ TRACE_EVENT(jbd2_checkpoint_stats,
 		  jbd2_dev_to_name(__entry->dev), __entry->tid,
 		  jiffies_to_msecs(__entry->chp_time),
 		  __entry->forced_to_close, __entry->written, __entry->dropped)
-);
+)
 
 TRACE_EVENT(jbd2_cleanup_journal_tail,
 
@@ -225,7 +230,7 @@ TRACE_EVENT(jbd2_cleanup_journal_tail,
 	TP_printk("dev %s from %u to %u offset %lu freed %lu",
 		  jbd2_dev_to_name(__entry->dev), __entry->tail_sequence,
 		  __entry->first_tid, __entry->block_nr, __entry->freed)
-);
+)
 
 #endif /* _TRACE_JBD2_H */
 

