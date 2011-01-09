Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1AIWGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:06:19 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53814 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab1AIWF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:58 -0500
Message-Id: <20110109220512.512120254@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        Alex Elder <aelder@sgi.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC patch 27/28] trace event fs remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-fs-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.  Remove extra trailing
semicolons at the end of XFS and GFS2 trace event declarations.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Alex Elder <aelder@sgi.com>
CC: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/gfs2/trace_gfs2.h         |   26 +-
 fs/xfs/linux-2.6/xfs_trace.h |  513 +++++++++++++++++++++----------------------
 2 files changed, 272 insertions(+), 267 deletions(-)

Index: linux-2.6-lttng/fs/gfs2/trace_gfs2.h
===================================================================
--- linux-2.6-lttng.orig/fs/gfs2/trace_gfs2.h
+++ linux-2.6-lttng/fs/gfs2/trace_gfs2.h
@@ -42,8 +42,8 @@
 	{(1UL << GLF_FROZEN),			"F" },		\
 	{(1UL << GLF_QUEUED),			"q" })
 
-#ifndef NUMPTY
-#define NUMPTY
+#ifndef _TRACE_GFS2_DEF_
+#define _TRACE_GFS2_DEF_
 static inline u8 glock_trace_state(unsigned int state)
 {
 	switch(state) {
@@ -56,7 +56,7 @@ static inline u8 glock_trace_state(unsig
 	}
 	return DLM_LOCK_NL;
 }
-#endif
+#endif /* _TRACE_GFS2_DEF_ */
 
 /* Section 1 - Locking
  *
@@ -105,7 +105,7 @@ TRACE_EVENT(gfs2_glock_state_change,
 		  glock_trace_name(__entry->tgt_state),
 		  glock_trace_name(__entry->dmt_state),
 		  show_glock_flags(__entry->flags))
-);
+)
 
 /* State change -> unlocked, glock is being deallocated */
 TRACE_EVENT(gfs2_glock_put,
@@ -137,7 +137,7 @@ TRACE_EVENT(gfs2_glock_put,
 		  glock_trace_name(DLM_LOCK_IV),
 		  show_glock_flags(__entry->flags))
 
-);
+)
 
 /* Callback (local or remote) requesting lock demotion */
 TRACE_EVENT(gfs2_demote_rq,
@@ -171,7 +171,7 @@ TRACE_EVENT(gfs2_demote_rq,
                   glock_trace_name(__entry->dmt_state),
 		  show_glock_flags(__entry->flags))
 
-);
+)
 
 /* Promotion/grant of a glock */
 TRACE_EVENT(gfs2_promote,
@@ -201,7 +201,7 @@ TRACE_EVENT(gfs2_promote,
 		  (unsigned long long)__entry->glnum,
 		  __entry->first ? "first": "other",
 		  glock_trace_name(__entry->state))
-);
+)
 
 /* Queue/dequeue a lock request */
 TRACE_EVENT(gfs2_glock_queue,
@@ -231,7 +231,7 @@ TRACE_EVENT(gfs2_glock_queue,
 		  (unsigned long long)__entry->glnum,
 		  __entry->queue ? "" : "de",
 		  glock_trace_name(__entry->state))
-);
+)
 
 /* Section 2 - Log/journal
  *
@@ -270,7 +270,7 @@ TRACE_EVENT(gfs2_pin,
 		  (unsigned long long)__entry->block,
 		  (unsigned long)__entry->len,
 		  (unsigned long long)__entry->ino)
-);
+)
 
 /* Flushing the log */
 TRACE_EVENT(gfs2_log_flush,
@@ -295,7 +295,7 @@ TRACE_EVENT(gfs2_log_flush,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->start ? "start" : "end",
 		  (unsigned long long)__entry->log_seq)
-);
+)
 
 /* Reserving/releasing blocks in the log */
 TRACE_EVENT(gfs2_log_blocks,
@@ -316,7 +316,7 @@ TRACE_EVENT(gfs2_log_blocks,
 
 	TP_printk("%u,%u log reserve %d", MAJOR(__entry->dev),
 		  MINOR(__entry->dev), __entry->blocks)
-);
+)
 
 /* Section 3 - bmap
  *
@@ -364,7 +364,7 @@ TRACE_EVENT(gfs2_bmap,
 		  (unsigned long long)__entry->pblock,
 		  __entry->state, __entry->create ? "create " : "nocreate",
 		  __entry->errno)
-);
+)
 
 /* Keep track of blocks as they are allocated/freed */
 TRACE_EVENT(gfs2_block_alloc,
@@ -396,7 +396,7 @@ TRACE_EVENT(gfs2_block_alloc,
 		  (unsigned long long)__entry->start,
 		  (unsigned long)__entry->len,
 		  block_state_name(__entry->block_state))
-);
+)
 
 #endif /* _TRACE_GFS2_H */
 
Index: linux-2.6-lttng/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6-lttng.orig/fs/xfs/linux-2.6/xfs_trace.h
+++ linux-2.6-lttng/fs/xfs/linux-2.6/xfs_trace.h
@@ -23,6 +23,9 @@
 
 #include <linux/tracepoint.h>
 
+#ifndef _TRACE_XFS_DEF_
+#define _TRACE_XFS_DEF_
+
 struct xfs_agf;
 struct xfs_alloc_arg;
 struct xfs_attr_list_context;
@@ -37,6 +40,8 @@ struct xlog_recover_item;
 struct xfs_buf_log_format;
 struct xfs_inode_log_format;
 
+#endif /* _TRACE_XFS_DEF_ */
+
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
 	TP_ARGS(ctx),
@@ -86,14 +91,14 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 DEFINE_EVENT(xfs_attr_list_class, name, \
 	TP_PROTO(struct xfs_attr_list_context *ctx), \
 	TP_ARGS(ctx))
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf_all);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf_end);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_full);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_add);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_wrong_blk);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf_all)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf_end)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_full)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_add)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_wrong_blk)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound)
 
 DECLARE_EVENT_CLASS(xfs_perag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
@@ -116,18 +121,18 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 		  __entry->agno,
 		  __entry->refcount,
 		  (char *)__entry->caller_ip)
-);
+)
 
 #define DEFINE_PERAG_REF_EVENT(name)	\
 DEFINE_EVENT(xfs_perag_class, name,	\
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,	\
 		 unsigned long caller_ip),					\
 	TP_ARGS(mp, agno, refcount, caller_ip))
-DEFINE_PERAG_REF_EVENT(xfs_perag_get);
-DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
-DEFINE_PERAG_REF_EVENT(xfs_perag_put);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
+DEFINE_PERAG_REF_EVENT(xfs_perag_get)
+DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag)
+DEFINE_PERAG_REF_EVENT(xfs_perag_put)
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim)
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim)
 
 TRACE_EVENT(xfs_attr_list_node_descend,
 	TP_PROTO(struct xfs_attr_list_context *ctx,
@@ -179,7 +184,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
 		   __entry->bt_hashval,
 		   __entry->bt_before)
-);
+)
 
 TRACE_EVENT(xfs_iext_insert,
 	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx,
@@ -218,7 +223,7 @@ TRACE_EVENT(xfs_iext_insert,
 		  __entry->blockcount,
 		  __entry->state,
 		  (char *)__entry->caller_ip)
-);
+)
 
 DECLARE_EVENT_CLASS(xfs_bmap_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state,
@@ -269,10 +274,10 @@ DEFINE_EVENT(xfs_bmap_class, name, \
 	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state, \
 		 unsigned long caller_ip), \
 	TP_ARGS(ip, idx, state, caller_ip))
-DEFINE_BMAP_EVENT(xfs_iext_remove);
-DEFINE_BMAP_EVENT(xfs_bmap_pre_update);
-DEFINE_BMAP_EVENT(xfs_bmap_post_update);
-DEFINE_BMAP_EVENT(xfs_extlist);
+DEFINE_BMAP_EVENT(xfs_iext_remove)
+DEFINE_BMAP_EVENT(xfs_bmap_pre_update)
+DEFINE_BMAP_EVENT(xfs_bmap_post_update)
+DEFINE_BMAP_EVENT(xfs_extlist)
 
 DECLARE_EVENT_CLASS(xfs_buf_class,
 	TP_PROTO(struct xfs_buf *bp, unsigned long caller_ip),
@@ -313,37 +318,37 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 DEFINE_EVENT(xfs_buf_class, name, \
 	TP_PROTO(struct xfs_buf *bp, unsigned long caller_ip), \
 	TP_ARGS(bp, caller_ip))
-DEFINE_BUF_EVENT(xfs_buf_init);
-DEFINE_BUF_EVENT(xfs_buf_free);
-DEFINE_BUF_EVENT(xfs_buf_hold);
-DEFINE_BUF_EVENT(xfs_buf_rele);
-DEFINE_BUF_EVENT(xfs_buf_iodone);
-DEFINE_BUF_EVENT(xfs_buf_iorequest);
-DEFINE_BUF_EVENT(xfs_buf_bawrite);
-DEFINE_BUF_EVENT(xfs_buf_bdwrite);
-DEFINE_BUF_EVENT(xfs_buf_lock);
-DEFINE_BUF_EVENT(xfs_buf_lock_done);
-DEFINE_BUF_EVENT(xfs_buf_cond_lock);
-DEFINE_BUF_EVENT(xfs_buf_unlock);
-DEFINE_BUF_EVENT(xfs_buf_iowait);
-DEFINE_BUF_EVENT(xfs_buf_iowait_done);
-DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
-DEFINE_BUF_EVENT(xfs_buf_delwri_dequeue);
-DEFINE_BUF_EVENT(xfs_buf_delwri_split);
-DEFINE_BUF_EVENT(xfs_buf_get_uncached);
-DEFINE_BUF_EVENT(xfs_bdstrat_shut);
-DEFINE_BUF_EVENT(xfs_buf_item_relse);
-DEFINE_BUF_EVENT(xfs_buf_item_iodone);
-DEFINE_BUF_EVENT(xfs_buf_item_iodone_async);
-DEFINE_BUF_EVENT(xfs_buf_error_relse);
-DEFINE_BUF_EVENT(xfs_trans_read_buf_io);
-DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
+DEFINE_BUF_EVENT(xfs_buf_init)
+DEFINE_BUF_EVENT(xfs_buf_free)
+DEFINE_BUF_EVENT(xfs_buf_hold)
+DEFINE_BUF_EVENT(xfs_buf_rele)
+DEFINE_BUF_EVENT(xfs_buf_iodone)
+DEFINE_BUF_EVENT(xfs_buf_iorequest)
+DEFINE_BUF_EVENT(xfs_buf_bawrite)
+DEFINE_BUF_EVENT(xfs_buf_bdwrite)
+DEFINE_BUF_EVENT(xfs_buf_lock)
+DEFINE_BUF_EVENT(xfs_buf_lock_done)
+DEFINE_BUF_EVENT(xfs_buf_cond_lock)
+DEFINE_BUF_EVENT(xfs_buf_unlock)
+DEFINE_BUF_EVENT(xfs_buf_iowait)
+DEFINE_BUF_EVENT(xfs_buf_iowait_done)
+DEFINE_BUF_EVENT(xfs_buf_delwri_queue)
+DEFINE_BUF_EVENT(xfs_buf_delwri_dequeue)
+DEFINE_BUF_EVENT(xfs_buf_delwri_split)
+DEFINE_BUF_EVENT(xfs_buf_get_uncached)
+DEFINE_BUF_EVENT(xfs_bdstrat_shut)
+DEFINE_BUF_EVENT(xfs_buf_item_relse)
+DEFINE_BUF_EVENT(xfs_buf_item_iodone)
+DEFINE_BUF_EVENT(xfs_buf_item_iodone_async)
+DEFINE_BUF_EVENT(xfs_buf_error_relse)
+DEFINE_BUF_EVENT(xfs_trans_read_buf_io)
+DEFINE_BUF_EVENT(xfs_trans_read_buf_shut)
 
 /* not really buffer traces, but the buf provides useful information */
-DEFINE_BUF_EVENT(xfs_btree_corrupt);
-DEFINE_BUF_EVENT(xfs_da_btree_corrupt);
-DEFINE_BUF_EVENT(xfs_reset_dqcounts);
-DEFINE_BUF_EVENT(xfs_inode_item_push);
+DEFINE_BUF_EVENT(xfs_btree_corrupt)
+DEFINE_BUF_EVENT(xfs_da_btree_corrupt)
+DEFINE_BUF_EVENT(xfs_reset_dqcounts)
+DEFINE_BUF_EVENT(xfs_inode_item_push)
 
 /* pass flags explicitly */
 DECLARE_EVENT_CLASS(xfs_buf_flags_class,
@@ -385,9 +390,9 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 DEFINE_EVENT(xfs_buf_flags_class, name, \
 	TP_PROTO(struct xfs_buf *bp, unsigned flags, unsigned long caller_ip), \
 	TP_ARGS(bp, flags, caller_ip))
-DEFINE_BUF_FLAGS_EVENT(xfs_buf_find);
-DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
-DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_find)
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_get)
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_read)
 
 TRACE_EVENT(xfs_buf_ioerror,
 	TP_PROTO(struct xfs_buf *bp, int error, unsigned long caller_ip),
@@ -425,7 +430,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 		  __entry->error,
 		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
 		  (void *)__entry->caller_ip)
-);
+)
 
 DECLARE_EVENT_CLASS(xfs_buf_item_class,
 	TP_PROTO(struct xfs_buf_log_item *bip),
@@ -479,31 +484,31 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 DEFINE_EVENT(xfs_buf_item_class, name, \
 	TP_PROTO(struct xfs_buf_log_item *bip), \
 	TP_ARGS(bip))
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_trylock);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pushbuf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf_recur);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb_recur);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf_recur);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_log_buf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_brelse);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_bjoin);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size_stale)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format_stale)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin_stale)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_trylock)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock_stale)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pushbuf)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf_recur)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb_recur)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf_recur)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_log_buf)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_brelse)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bjoin)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_binval)
 
 DECLARE_EVENT_CLASS(xfs_lock_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags,
@@ -558,32 +563,32 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
 DEFINE_EVENT(xfs_inode_class, name, \
 	TP_PROTO(struct xfs_inode *ip), \
 	TP_ARGS(ip))
-DEFINE_INODE_EVENT(xfs_iget_skip);
-DEFINE_INODE_EVENT(xfs_iget_reclaim);
-DEFINE_INODE_EVENT(xfs_iget_reclaim_fail);
-DEFINE_INODE_EVENT(xfs_iget_hit);
-DEFINE_INODE_EVENT(xfs_iget_miss);
-
-DEFINE_INODE_EVENT(xfs_getattr);
-DEFINE_INODE_EVENT(xfs_setattr);
-DEFINE_INODE_EVENT(xfs_readlink);
-DEFINE_INODE_EVENT(xfs_alloc_file_space);
-DEFINE_INODE_EVENT(xfs_free_file_space);
-DEFINE_INODE_EVENT(xfs_readdir);
+DEFINE_INODE_EVENT(xfs_iget_skip)
+DEFINE_INODE_EVENT(xfs_iget_reclaim)
+DEFINE_INODE_EVENT(xfs_iget_reclaim_fail)
+DEFINE_INODE_EVENT(xfs_iget_hit)
+DEFINE_INODE_EVENT(xfs_iget_miss)
+
+DEFINE_INODE_EVENT(xfs_getattr)
+DEFINE_INODE_EVENT(xfs_setattr)
+DEFINE_INODE_EVENT(xfs_readlink)
+DEFINE_INODE_EVENT(xfs_alloc_file_space)
+DEFINE_INODE_EVENT(xfs_free_file_space)
+DEFINE_INODE_EVENT(xfs_readdir)
 #ifdef CONFIG_XFS_POSIX_ACL
-DEFINE_INODE_EVENT(xfs_check_acl);
+DEFINE_INODE_EVENT(xfs_check_acl)
 #endif
-DEFINE_INODE_EVENT(xfs_vm_bmap);
-DEFINE_INODE_EVENT(xfs_file_ioctl);
-DEFINE_INODE_EVENT(xfs_file_compat_ioctl);
-DEFINE_INODE_EVENT(xfs_ioctl_setattr);
-DEFINE_INODE_EVENT(xfs_file_fsync);
-DEFINE_INODE_EVENT(xfs_destroy_inode);
-DEFINE_INODE_EVENT(xfs_write_inode);
-DEFINE_INODE_EVENT(xfs_evict_inode);
+DEFINE_INODE_EVENT(xfs_vm_bmap)
+DEFINE_INODE_EVENT(xfs_file_ioctl)
+DEFINE_INODE_EVENT(xfs_file_compat_ioctl)
+DEFINE_INODE_EVENT(xfs_ioctl_setattr)
+DEFINE_INODE_EVENT(xfs_file_fsync)
+DEFINE_INODE_EVENT(xfs_destroy_inode)
+DEFINE_INODE_EVENT(xfs_write_inode)
+DEFINE_INODE_EVENT(xfs_evict_inode)
 
-DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
-DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
+DEFINE_INODE_EVENT(xfs_dquot_dqalloc)
+DEFINE_INODE_EVENT(xfs_dquot_dqdetach)
 
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
@@ -614,11 +619,11 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 DEFINE_EVENT(xfs_iref_class, name, \
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip), \
 	TP_ARGS(ip, caller_ip))
-DEFINE_IREF_EVENT(xfs_ihold);
-DEFINE_IREF_EVENT(xfs_irele);
-DEFINE_IREF_EVENT(xfs_inode_pin);
-DEFINE_IREF_EVENT(xfs_inode_unpin);
-DEFINE_IREF_EVENT(xfs_inode_unpin_nowait);
+DEFINE_IREF_EVENT(xfs_ihold)
+DEFINE_IREF_EVENT(xfs_irele)
+DEFINE_IREF_EVENT(xfs_inode_pin)
+DEFINE_IREF_EVENT(xfs_inode_unpin)
+DEFINE_IREF_EVENT(xfs_inode_unpin_nowait)
 
 DECLARE_EVENT_CLASS(xfs_namespace_class,
 	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name),
@@ -643,11 +648,11 @@ DECLARE_EVENT_CLASS(xfs_namespace_class,
 DEFINE_EVENT(xfs_namespace_class, name, \
 	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name), \
 	TP_ARGS(dp, name))
-DEFINE_NAMESPACE_EVENT(xfs_remove);
-DEFINE_NAMESPACE_EVENT(xfs_link);
-DEFINE_NAMESPACE_EVENT(xfs_lookup);
-DEFINE_NAMESPACE_EVENT(xfs_create);
-DEFINE_NAMESPACE_EVENT(xfs_symlink);
+DEFINE_NAMESPACE_EVENT(xfs_remove)
+DEFINE_NAMESPACE_EVENT(xfs_link)
+DEFINE_NAMESPACE_EVENT(xfs_lookup)
+DEFINE_NAMESPACE_EVENT(xfs_create)
+DEFINE_NAMESPACE_EVENT(xfs_symlink)
 
 TRACE_EVENT(xfs_rename,
 	TP_PROTO(struct xfs_inode *src_dp, struct xfs_inode *target_dp,
@@ -729,31 +734,31 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 DEFINE_EVENT(xfs_dquot_class, name, \
 	TP_PROTO(struct xfs_dquot *dqp), \
 	TP_ARGS(dqp))
-DEFINE_DQUOT_EVENT(xfs_dqadjust);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_unlink);
-DEFINE_DQUOT_EVENT(xfs_dqattach_found);
-DEFINE_DQUOT_EVENT(xfs_dqattach_get);
-DEFINE_DQUOT_EVENT(xfs_dqinit);
-DEFINE_DQUOT_EVENT(xfs_dqreuse);
-DEFINE_DQUOT_EVENT(xfs_dqalloc);
-DEFINE_DQUOT_EVENT(xfs_dqtobp_read);
-DEFINE_DQUOT_EVENT(xfs_dqread);
-DEFINE_DQUOT_EVENT(xfs_dqread_fail);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_found);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_want);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_freelist);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_done);
-DEFINE_DQUOT_EVENT(xfs_dqget_hit);
-DEFINE_DQUOT_EVENT(xfs_dqget_miss);
-DEFINE_DQUOT_EVENT(xfs_dqput);
-DEFINE_DQUOT_EVENT(xfs_dqput_wait);
-DEFINE_DQUOT_EVENT(xfs_dqput_free);
-DEFINE_DQUOT_EVENT(xfs_dqrele);
-DEFINE_DQUOT_EVENT(xfs_dqflush);
-DEFINE_DQUOT_EVENT(xfs_dqflush_force);
-DEFINE_DQUOT_EVENT(xfs_dqflush_done);
+DEFINE_DQUOT_EVENT(xfs_dqadjust)
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_want)
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty)
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_unlink)
+DEFINE_DQUOT_EVENT(xfs_dqattach_found)
+DEFINE_DQUOT_EVENT(xfs_dqattach_get)
+DEFINE_DQUOT_EVENT(xfs_dqinit)
+DEFINE_DQUOT_EVENT(xfs_dqreuse)
+DEFINE_DQUOT_EVENT(xfs_dqalloc)
+DEFINE_DQUOT_EVENT(xfs_dqtobp_read)
+DEFINE_DQUOT_EVENT(xfs_dqread)
+DEFINE_DQUOT_EVENT(xfs_dqread_fail)
+DEFINE_DQUOT_EVENT(xfs_dqlookup_found)
+DEFINE_DQUOT_EVENT(xfs_dqlookup_want)
+DEFINE_DQUOT_EVENT(xfs_dqlookup_freelist)
+DEFINE_DQUOT_EVENT(xfs_dqlookup_done)
+DEFINE_DQUOT_EVENT(xfs_dqget_hit)
+DEFINE_DQUOT_EVENT(xfs_dqget_miss)
+DEFINE_DQUOT_EVENT(xfs_dqput)
+DEFINE_DQUOT_EVENT(xfs_dqput_wait)
+DEFINE_DQUOT_EVENT(xfs_dqput_free)
+DEFINE_DQUOT_EVENT(xfs_dqrele)
+DEFINE_DQUOT_EVENT(xfs_dqflush)
+DEFINE_DQUOT_EVENT(xfs_dqflush_force)
+DEFINE_DQUOT_EVENT(xfs_dqflush_done)
 
 DECLARE_EVENT_CLASS(xfs_loggrant_class,
 	TP_PROTO(struct log *log, struct xlog_ticket *tic),
@@ -824,30 +829,30 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 DEFINE_EVENT(xfs_loggrant_class, name, \
 	TP_PROTO(struct log *log, struct xlog_ticket *tic), \
 	TP_ARGS(log, tic))
-DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm);
-DEFINE_LOGGRANT_EVENT(xfs_log_done_perm);
-DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
-DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm)
+DEFINE_LOGGRANT_EVENT(xfs_log_done_perm)
+DEFINE_LOGGRANT_EVENT(xfs_log_reserve)
+DEFINE_LOGGRANT_EVENT(xfs_log_umount_write)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_error)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub)
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter)
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit)
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub)
 
 DECLARE_EVENT_CLASS(xfs_file_class,
 	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),
@@ -885,11 +890,11 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 DEFINE_EVENT(xfs_file_class, name,	\
 	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),	\
 	TP_ARGS(ip, count, offset, flags))
-DEFINE_RW_EVENT(xfs_file_read);
-DEFINE_RW_EVENT(xfs_file_buffered_write);
-DEFINE_RW_EVENT(xfs_file_direct_write);
-DEFINE_RW_EVENT(xfs_file_splice_read);
-DEFINE_RW_EVENT(xfs_file_splice_write);
+DEFINE_RW_EVENT(xfs_file_read)
+DEFINE_RW_EVENT(xfs_file_buffered_write)
+DEFINE_RW_EVENT(xfs_file_direct_write)
+DEFINE_RW_EVENT(xfs_file_splice_read)
+DEFINE_RW_EVENT(xfs_file_splice_write)
 
 DECLARE_EVENT_CLASS(xfs_page_class,
 	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),
@@ -931,9 +936,9 @@ DECLARE_EVENT_CLASS(xfs_page_class,
 DEFINE_EVENT(xfs_page_class, name,	\
 	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),	\
 	TP_ARGS(inode, page, off))
-DEFINE_PAGE_EVENT(xfs_writepage);
-DEFINE_PAGE_EVENT(xfs_releasepage);
-DEFINE_PAGE_EVENT(xfs_invalidatepage);
+DEFINE_PAGE_EVENT(xfs_writepage)
+DEFINE_PAGE_EVENT(xfs_releasepage)
+DEFINE_PAGE_EVENT(xfs_invalidatepage)
 
 DECLARE_EVENT_CLASS(xfs_iomap_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
@@ -983,9 +988,9 @@ DEFINE_EVENT(xfs_iomap_class, name,	\
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,	\
 		 int flags, struct xfs_bmbt_irec *irec),		\
 	TP_ARGS(ip, offset, count, flags, irec))
-DEFINE_IOMAP_EVENT(xfs_iomap_enter);
-DEFINE_IOMAP_EVENT(xfs_iomap_found);
-DEFINE_IOMAP_EVENT(xfs_iomap_alloc);
+DEFINE_IOMAP_EVENT(xfs_iomap_enter)
+DEFINE_IOMAP_EVENT(xfs_iomap_found)
+DEFINE_IOMAP_EVENT(xfs_iomap_alloc)
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
@@ -1014,14 +1019,14 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		  __entry->new_size,
 		  __entry->offset,
 		  __entry->count)
-);
+)
 
 #define DEFINE_SIMPLE_IO_EVENT(name)	\
 DEFINE_EVENT(xfs_simple_io_class, name,	\
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),	\
 	TP_ARGS(ip, offset, count))
-DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
-DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
+DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc)
+DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert)
 
 
 TRACE_EVENT(xfs_itruncate_start,
@@ -1055,7 +1060,7 @@ TRACE_EVENT(xfs_itruncate_start,
 		  __entry->new_size,
 		  __entry->toss_start,
 		  __entry->toss_finish)
-);
+)
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
@@ -1083,8 +1088,8 @@ DECLARE_EVENT_CLASS(xfs_itrunc_class,
 DEFINE_EVENT(xfs_itrunc_class, name, \
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size), \
 	TP_ARGS(ip, new_size))
-DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_start);
-DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_end);
+DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_start)
+DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_end)
 
 TRACE_EVENT(xfs_pagecache_inval,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t start, xfs_off_t finish),
@@ -1109,7 +1114,7 @@ TRACE_EVENT(xfs_pagecache_inval,
 		  __entry->size,
 		  __entry->start,
 		  __entry->finish)
-);
+)
 
 TRACE_EVENT(xfs_bunmap,
 	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t bno, xfs_filblks_t len,
@@ -1143,7 +1148,7 @@ TRACE_EVENT(xfs_bunmap,
 		  __print_flags(__entry->flags, "|", XFS_BMAPI_FLAGS),
 		  (void *)__entry->caller_ip)
 
-);
+)
 
 #define XFS_BUSY_SYNC \
 	{ 0,	"async" }, \
@@ -1180,7 +1185,7 @@ TRACE_EVENT(xfs_alloc_busy,
 		  __entry->len,
 		  __print_symbolic(__entry->sync, XFS_BUSY_SYNC))
 
-);
+)
 
 TRACE_EVENT(xfs_alloc_unbusy,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -1203,7 +1208,7 @@ TRACE_EVENT(xfs_alloc_unbusy,
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len)
-);
+)
 
 #define XFS_BUSY_STATES \
 	{ 0,	"missing" }, \
@@ -1233,7 +1238,7 @@ TRACE_EVENT(xfs_alloc_busysearch,
 		  __entry->agbno,
 		  __entry->len,
 		  __print_symbolic(__entry->found, XFS_BUSY_STATES))
-);
+)
 
 TRACE_EVENT(xfs_trans_commit_lsn,
 	TP_PROTO(struct xfs_trans *trans),
@@ -1252,7 +1257,7 @@ TRACE_EVENT(xfs_trans_commit_lsn,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->tp,
 		  __entry->lsn)
-);
+)
 
 TRACE_EVENT(xfs_agf,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags,
@@ -1309,7 +1314,7 @@ TRACE_EVENT(xfs_agf,
 		  __entry->freeblks,
 		  __entry->longest,
 		  (void *)__entry->caller_ip)
-);
+)
 
 TRACE_EVENT(xfs_free_extent,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
@@ -1343,7 +1348,7 @@ TRACE_EVENT(xfs_free_extent,
 			(__entry->haveright ? "both" : "left") :
 			(__entry->haveright ? "right" : "none"))
 
-);
+)
 
 DECLARE_EVENT_CLASS(xfs_alloc_class,
 	TP_PROTO(struct xfs_alloc_arg *args),
@@ -1419,27 +1424,27 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 DEFINE_EVENT(xfs_alloc_class, name, \
 	TP_PROTO(struct xfs_alloc_arg *args), \
 	TP_ARGS(args))
-DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_neither);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_freelist);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_badargs);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_nofix);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
+DEFINE_ALLOC_EVENT(xfs_alloc_exact_done)
+DEFINE_ALLOC_EVENT(xfs_alloc_exact_error)
+DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft)
+DEFINE_ALLOC_EVENT(xfs_alloc_near_first)
+DEFINE_ALLOC_EVENT(xfs_alloc_near_greater)
+DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser)
+DEFINE_ALLOC_EVENT(xfs_alloc_near_error)
+DEFINE_ALLOC_EVENT(xfs_alloc_size_neither)
+DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry)
+DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft)
+DEFINE_ALLOC_EVENT(xfs_alloc_size_done)
+DEFINE_ALLOC_EVENT(xfs_alloc_size_error)
+DEFINE_ALLOC_EVENT(xfs_alloc_small_freelist)
+DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough)
+DEFINE_ALLOC_EVENT(xfs_alloc_small_done)
+DEFINE_ALLOC_EVENT(xfs_alloc_small_error)
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_badargs)
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_nofix)
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp)
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed)
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed)
 
 DECLARE_EVENT_CLASS(xfs_dir2_class,
 	TP_PROTO(struct xfs_da_args *args),
@@ -1479,31 +1484,31 @@ DECLARE_EVENT_CLASS(xfs_dir2_class,
 DEFINE_EVENT(xfs_dir2_class, name, \
 	TP_PROTO(struct xfs_da_args *args), \
 	TP_ARGS(args))
-DEFINE_DIR2_EVENT(xfs_dir2_sf_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_create);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_toino4);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_toino8);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_to_block);
-DEFINE_DIR2_EVENT(xfs_dir2_block_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_block_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_block_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_block_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_block_to_sf);
-DEFINE_DIR2_EVENT(xfs_dir2_block_to_leaf);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_block);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_node);
-DEFINE_DIR2_EVENT(xfs_dir2_node_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_node_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_node_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_node_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_node_to_leaf);
+DEFINE_DIR2_EVENT(xfs_dir2_sf_addname)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_create)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_lookup)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_replace)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_removename)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_toino4)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_toino8)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_to_block)
+DEFINE_DIR2_EVENT(xfs_dir2_block_addname)
+DEFINE_DIR2_EVENT(xfs_dir2_block_lookup)
+DEFINE_DIR2_EVENT(xfs_dir2_block_replace)
+DEFINE_DIR2_EVENT(xfs_dir2_block_removename)
+DEFINE_DIR2_EVENT(xfs_dir2_block_to_sf)
+DEFINE_DIR2_EVENT(xfs_dir2_block_to_leaf)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_addname)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_lookup)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_replace)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_removename)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_block)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_node)
+DEFINE_DIR2_EVENT(xfs_dir2_node_addname)
+DEFINE_DIR2_EVENT(xfs_dir2_node_lookup)
+DEFINE_DIR2_EVENT(xfs_dir2_node_replace)
+DEFINE_DIR2_EVENT(xfs_dir2_node_removename)
+DEFINE_DIR2_EVENT(xfs_dir2_node_to_leaf)
 
 DECLARE_EVENT_CLASS(xfs_dir2_space_class,
 	TP_PROTO(struct xfs_da_args *args, int idx),
@@ -1531,10 +1536,10 @@ DECLARE_EVENT_CLASS(xfs_dir2_space_class
 DEFINE_EVENT(xfs_dir2_space_class, name, \
 	TP_PROTO(struct xfs_da_args *args, int idx), \
 	TP_ARGS(args, idx))
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_add);
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_remove);
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_grow_inode);
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_shrink_inode);
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_add)
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_remove)
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_grow_inode)
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_shrink_inode)
 
 TRACE_EVENT(xfs_dir2_leafn_moveents,
 	TP_PROTO(struct xfs_da_args *args, int src_idx, int dst_idx, int count),
@@ -1563,7 +1568,7 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
 		  __entry->src_idx,
 		  __entry->dst_idx,
 		  __entry->count)
-);
+)
 
 #define XFS_SWAPEXT_INODES \
 	{ 0,	"target" }, \
@@ -1615,8 +1620,8 @@ DEFINE_EVENT(xfs_swap_extent_class, name
 	TP_PROTO(struct xfs_inode *ip, int which), \
 	TP_ARGS(ip, which))
 
-DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before);
-DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
+DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before)
+DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after)
 
 DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
 	TP_PROTO(struct log *log, struct xlog_recover *trans,
@@ -1657,11 +1662,11 @@ DEFINE_EVENT(xfs_log_recover_item_class,
 		struct xlog_recover_item *item, int pass), \
 	TP_ARGS(log, trans, item, pass))
 
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add_cont);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_head);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_tail);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_recover);
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add)
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add_cont)
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_head)
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_tail)
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_recover)
 
 DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
 	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f),
@@ -1697,14 +1702,14 @@ DEFINE_EVENT(xfs_log_recover_buf_item_cl
 	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f), \
 	TP_ARGS(log, buf_f))
 
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_not_cancel);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_add);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_ref_inc);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_recover);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_inode_buf);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_reg_buf);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_dquot_buf);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_not_cancel)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_add)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_ref_inc)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_recover)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_inode_buf)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_reg_buf)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_dquot_buf)
 
 DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
 	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f),
@@ -1748,9 +1753,9 @@ DEFINE_EVENT(xfs_log_recover_ino_item_cl
 	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f), \
 	TP_ARGS(log, in_f))
 
-DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_recover);
-DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_cancel);
-DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_skip);
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_recover)
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_cancel)
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_skip)
 
 #endif /* _TRACE_XFS_H */
 

