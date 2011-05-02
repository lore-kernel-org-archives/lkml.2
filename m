Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab1EBWEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:04:54 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40587 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521Ab1EBWEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:04:52 -0400
Message-Id: <20110502213216.548856740@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        liubo <liubo2009@cn.fujitsu.com>
Subject: [RFC patch 32/32] trace event btrfs remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-btrfs-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:16 +0000
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
CC: liubo <liubo2009@cn.fujitsu.com>
---
 include/trace/events/btrfs.h |   57 +++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

Index: linux-2.6-lttng/include/trace/events/btrfs.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/btrfs.h
+++ linux-2.6-lttng/include/trace/events/btrfs.h
@@ -7,6 +7,9 @@
 #include <linux/writeback.h>
 #include <linux/tracepoint.h>
 
+#ifndef _TRACE_BTRFS_DEF_
+#define _TRACE_BTRFS_DEF_
+
 struct btrfs_root;
 struct btrfs_fs_info;
 struct btrfs_inode;
@@ -19,6 +22,8 @@ struct btrfs_delayed_ref_head;
 struct map_lookup;
 struct extent_buffer;
 
+#endif /* _TRACE_BTRFS_DEF_ */
+
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
 		{ BTRFS_TREE_BLOCK_REF_KEY, 	"TREE_BLOCK_REF" },	\
@@ -63,7 +68,7 @@ TRACE_EVENT(btrfs_transaction_commit,
 	TP_printk("root = %llu(%s), gen = %llu",
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long long)__entry->generation)
-);
+)
 
 DECLARE_EVENT_CLASS(btrfs__inode,
 
@@ -101,28 +106,28 @@ DECLARE_EVENT_CLASS(btrfs__inode,
 		  (unsigned long long)__entry->disk_i_size,
 		  (unsigned long long)__entry->last_trans,
 		  (unsigned long long)__entry->logged_trans)
-);
+)
 
 DEFINE_EVENT(btrfs__inode, btrfs_inode_new,
 
 	TP_PROTO(struct inode *inode),
 
 	TP_ARGS(inode)
-);
+)
 
 DEFINE_EVENT(btrfs__inode, btrfs_inode_request,
 
 	TP_PROTO(struct inode *inode),
 
 	TP_ARGS(inode)
-);
+)
 
 DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 
 	TP_PROTO(struct inode *inode),
 
 	TP_ARGS(inode)
-);
+)
 
 #define __show_map_type(type)						\
 	__print_symbolic(type,						\
@@ -183,7 +188,7 @@ TRACE_EVENT(btrfs_get_extent,
 		  (unsigned long long)__entry->block_len,
 		  show_map_flags(__entry->flags),
 		  __entry->refs, __entry->compress_type)
-);
+)
 
 #define show_ordered_flags(flags)					\
 	__print_symbolic(flags,					\
@@ -240,35 +245,35 @@ DECLARE_EVENT_CLASS(btrfs__ordered_exten
 		  (unsigned long long)__entry->bytes_left,
 		  show_ordered_flags(__entry->flags),
 		  __entry->compress_type, __entry->refs)
-);
+)
 
 DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_add,
 
 	TP_PROTO(struct inode *inode, struct btrfs_ordered_extent *ordered),
 
 	TP_ARGS(inode, ordered)
-);
+)
 
 DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_remove,
 
 	TP_PROTO(struct inode *inode, struct btrfs_ordered_extent *ordered),
 
 	TP_ARGS(inode, ordered)
-);
+)
 
 DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_start,
 
 	TP_PROTO(struct inode *inode, struct btrfs_ordered_extent *ordered),
 
 	TP_ARGS(inode, ordered)
-);
+)
 
 DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_put,
 
 	TP_PROTO(struct inode *inode, struct btrfs_ordered_extent *ordered),
 
 	TP_ARGS(inode, ordered)
-);
+)
 
 DECLARE_EVENT_CLASS(btrfs__writepage,
 
@@ -319,7 +324,7 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		  __entry->nonblocking, __entry->for_kupdate,
 		  __entry->for_reclaim, __entry->range_cyclic,
 		  (unsigned long)__entry->writeback_index)
-);
+)
 
 DEFINE_EVENT(btrfs__writepage, __extent_writepage,
 
@@ -327,7 +332,7 @@ DEFINE_EVENT(btrfs__writepage, __extent_
 		 struct writeback_control *wbc),
 
 	TP_ARGS(page, inode, wbc)
-);
+)
 
 TRACE_EVENT(btrfs_writepage_end_io_hook,
 
@@ -360,7 +365,7 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
 		  (unsigned long)__entry->ino, (unsigned long)__entry->index,
 		  (unsigned long long)__entry->start,
 		  (unsigned long long)__entry->end, __entry->uptodate)
-);
+)
 
 TRACE_EVENT(btrfs_sync_file,
 
@@ -390,7 +395,7 @@ TRACE_EVENT(btrfs_sync_file,
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long)__entry->ino, (unsigned long)__entry->parent,
 		  __entry->datasync)
-);
+)
 
 TRACE_EVENT(btrfs_sync_fs,
 
@@ -407,7 +412,7 @@ TRACE_EVENT(btrfs_sync_fs,
 	),
 
 	TP_printk("wait = %d", __entry->wait)
-);
+)
 
 #define show_ref_action(action)						\
 	__print_symbolic(action,					\
@@ -454,7 +459,7 @@ TRACE_EVENT(btrfs_delayed_tree_ref,
 		  show_root_type(__entry->parent),
 		  show_root_type(__entry->ref_root),
 		  __entry->level, show_ref_type(__entry->type))
-);
+)
 
 TRACE_EVENT(btrfs_delayed_data_ref,
 
@@ -497,7 +502,7 @@ TRACE_EVENT(btrfs_delayed_data_ref,
 		  (unsigned long long)__entry->owner,
 		  (unsigned long long)__entry->offset,
 		  show_ref_type(__entry->type))
-);
+)
 
 TRACE_EVENT(btrfs_delayed_ref_head,
 
@@ -526,7 +531,7 @@ TRACE_EVENT(btrfs_delayed_ref_head,
 		  (unsigned long long)__entry->num_bytes,
 		  show_ref_action(__entry->action),
 		  __entry->is_data)
-);
+)
 
 #define show_chunk_type(type)					\
 	__print_flags(type, "|",				\
@@ -570,7 +575,7 @@ DECLARE_EVENT_CLASS(btrfs__chunk,
 		  (unsigned long long)__entry->size,
 		  __entry->num_stripes, __entry->sub_stripes,
 		  show_chunk_type(__entry->type))
-);
+)
 
 DEFINE_EVENT(btrfs__chunk,  btrfs_chunk_alloc,
 
@@ -578,7 +583,7 @@ DEFINE_EVENT(btrfs__chunk,  btrfs_chunk_
 		 u64 offset, u64 size),
 
 	TP_ARGS(root, map, offset, size)
-);
+)
 
 DEFINE_EVENT(btrfs__chunk,  btrfs_chunk_free,
 
@@ -586,7 +591,7 @@ DEFINE_EVENT(btrfs__chunk,  btrfs_chunk_
 		 u64 offset, u64 size),
 
 	TP_ARGS(root, map, offset, size)
-);
+)
 
 TRACE_EVENT(btrfs_cow_block,
 
@@ -621,7 +626,7 @@ TRACE_EVENT(btrfs_cow_block,
 		  __entry->buf_level,
 		  (unsigned long long)__entry->cow_start,
 		  __entry->cow_level)
-);
+)
 
 DECLARE_EVENT_CLASS(btrfs__reserved_extent,
 
@@ -645,21 +650,21 @@ DECLARE_EVENT_CLASS(btrfs__reserved_exte
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long long)__entry->start,
 		  (unsigned long long)__entry->len)
-);
+)
 
 DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_alloc,
 
 	TP_PROTO(struct btrfs_root *root, u64 start, u64 len),
 
 	TP_ARGS(root, start, len)
-);
+)
 
 DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_free,
 
 	TP_PROTO(struct btrfs_root *root, u64 start, u64 len),
 
 	TP_ARGS(root, start, len)
-);
+)
 
 #endif /* _TRACE_BTRFS_H */
 

