Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab1EBWF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:05:27 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46306 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758893Ab1EBWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:05:22 -0400
Message-Id: <20110502213211.812501864@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>
Subject: [RFC patch 04/32] trace event ext4 remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-ext4-remove-semicolons.patch
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
 include/trace/events/ext4.h |  143 ++++++++++++++++++++++----------------------
 1 file changed, 74 insertions(+), 69 deletions(-)

Index: linux-2.6-lttng/include/trace/events/ext4.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/ext4.h
+++ linux-2.6-lttng/include/trace/events/ext4.h
@@ -7,6 +7,9 @@
 #include <linux/writeback.h>
 #include <linux/tracepoint.h>
 
+#ifndef _TRACE_EXT4_DEF_
+#define _TRACE_EXT4_DEF_
+
 struct ext4_allocation_context;
 struct ext4_allocation_request;
 struct ext4_prealloc_space;
@@ -15,6 +18,8 @@ struct mpage_da_data;
 
 #define EXT4_I(inode) (container_of(inode, struct ext4_inode_info, vfs_inode))
 
+#endif /* _TRACE_EXT4_DEF_ */
+
 TRACE_EVENT(ext4_free_inode,
 	TP_PROTO(struct inode *inode),
 
@@ -43,7 +48,7 @@ TRACE_EVENT(ext4_free_inode,
 		  (unsigned long) __entry->ino,
 		  __entry->mode, __entry->uid, __entry->gid,
 		  (unsigned long long) __entry->blocks)
-);
+)
 
 TRACE_EVENT(ext4_request_inode,
 	TP_PROTO(struct inode *dir, int mode),
@@ -65,7 +70,7 @@ TRACE_EVENT(ext4_request_inode,
 	TP_printk("dev %d,%d dir %lu mode 0%o",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->dir, __entry->mode)
-);
+)
 
 TRACE_EVENT(ext4_allocate_inode,
 	TP_PROTO(struct inode *inode, struct inode *dir, int mode),
@@ -90,7 +95,7 @@ TRACE_EVENT(ext4_allocate_inode,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  (unsigned long) __entry->dir, __entry->mode)
-);
+)
 
 TRACE_EVENT(ext4_evict_inode,
 	TP_PROTO(struct inode *inode),
@@ -112,7 +117,7 @@ TRACE_EVENT(ext4_evict_inode,
 	TP_printk("dev %d,%d ino %lu nlink %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->nlink)
-);
+)
 
 TRACE_EVENT(ext4_drop_inode,
 	TP_PROTO(struct inode *inode, int drop),
@@ -134,7 +139,7 @@ TRACE_EVENT(ext4_drop_inode,
 	TP_printk("dev %d,%d ino %lu drop %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->drop)
-);
+)
 
 TRACE_EVENT(ext4_mark_inode_dirty,
 	TP_PROTO(struct inode *inode, unsigned long IP),
@@ -156,7 +161,7 @@ TRACE_EVENT(ext4_mark_inode_dirty,
 	TP_printk("dev %d,%d ino %lu caller %pF",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino, (void *)__entry->ip)
-);
+)
 
 TRACE_EVENT(ext4_begin_ordered_truncate,
 	TP_PROTO(struct inode *inode, loff_t new_size),
@@ -179,7 +184,7 @@ TRACE_EVENT(ext4_begin_ordered_truncate,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  (long long) __entry->new_size)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__write_begin,
 
@@ -208,7 +213,7 @@ DECLARE_EVENT_CLASS(ext4__write_begin,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->pos, __entry->len, __entry->flags)
-);
+)
 
 DEFINE_EVENT(ext4__write_begin, ext4_write_begin,
 
@@ -216,7 +221,7 @@ DEFINE_EVENT(ext4__write_begin, ext4_wri
 		 unsigned int flags),
 
 	TP_ARGS(inode, pos, len, flags)
-);
+)
 
 DEFINE_EVENT(ext4__write_begin, ext4_da_write_begin,
 
@@ -224,7 +229,7 @@ DEFINE_EVENT(ext4__write_begin, ext4_da_
 		 unsigned int flags),
 
 	TP_ARGS(inode, pos, len, flags)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__write_end,
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
@@ -252,7 +257,7 @@ DECLARE_EVENT_CLASS(ext4__write_end,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->pos, __entry->len, __entry->copied)
-);
+)
 
 DEFINE_EVENT(ext4__write_end, ext4_ordered_write_end,
 
@@ -260,7 +265,7 @@ DEFINE_EVENT(ext4__write_end, ext4_order
 		 unsigned int copied),
 
 	TP_ARGS(inode, pos, len, copied)
-);
+)
 
 DEFINE_EVENT(ext4__write_end, ext4_writeback_write_end,
 
@@ -268,7 +273,7 @@ DEFINE_EVENT(ext4__write_end, ext4_write
 		 unsigned int copied),
 
 	TP_ARGS(inode, pos, len, copied)
-);
+)
 
 DEFINE_EVENT(ext4__write_end, ext4_journalled_write_end,
 
@@ -276,7 +281,7 @@ DEFINE_EVENT(ext4__write_end, ext4_journ
 		 unsigned int copied),
 
 	TP_ARGS(inode, pos, len, copied)
-);
+)
 
 DEFINE_EVENT(ext4__write_end, ext4_da_write_end,
 
@@ -284,7 +289,7 @@ DEFINE_EVENT(ext4__write_end, ext4_da_wr
 		 unsigned int copied),
 
 	TP_ARGS(inode, pos, len, copied)
-);
+)
 
 TRACE_EVENT(ext4_writepage,
 	TP_PROTO(struct inode *inode, struct page *page),
@@ -307,7 +312,7 @@ TRACE_EVENT(ext4_writepage,
 	TP_printk("dev %d,%d ino %lu page_index %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->index)
-);
+)
 
 TRACE_EVENT(ext4_da_writepages,
 	TP_PROTO(struct inode *inode, struct writeback_control *wbc),
@@ -349,7 +354,7 @@ TRACE_EVENT(ext4_da_writepages,
 		  __entry->range_end, __entry->sync_mode,
 		  __entry->for_kupdate, __entry->range_cyclic,
 		  (unsigned long) __entry->writeback_index)
-);
+)
 
 TRACE_EVENT(ext4_da_write_pages,
 	TP_PROTO(struct inode *inode, struct mpage_da_data *mpd),
@@ -389,7 +394,7 @@ TRACE_EVENT(ext4_da_write_pages,
 		  __entry->io_done, __entry->pages_written,
 		  __entry->sync_mode
                   )
-);
+)
 
 TRACE_EVENT(ext4_da_writepages_result,
 	TP_PROTO(struct inode *inode, struct writeback_control *wbc,
@@ -426,7 +431,7 @@ TRACE_EVENT(ext4_da_writepages_result,
 		  __entry->pages_written, __entry->pages_skipped,
 		  __entry->more_io, __entry->sync_mode,
 		  (unsigned long) __entry->writeback_index)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__page_op,
 	TP_PROTO(struct page *page),
@@ -450,21 +455,21 @@ DECLARE_EVENT_CLASS(ext4__page_op,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->index)
-);
+)
 
 DEFINE_EVENT(ext4__page_op, ext4_readpage,
 
 	TP_PROTO(struct page *page),
 
 	TP_ARGS(page)
-);
+)
 
 DEFINE_EVENT(ext4__page_op, ext4_releasepage,
 
 	TP_PROTO(struct page *page),
 
 	TP_ARGS(page)
-);
+)
 
 TRACE_EVENT(ext4_invalidatepage,
 	TP_PROTO(struct page *page, unsigned long offset),
@@ -490,7 +495,7 @@ TRACE_EVENT(ext4_invalidatepage,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->index, __entry->offset)
-);
+)
 
 TRACE_EVENT(ext4_discard_blocks,
 	TP_PROTO(struct super_block *sb, unsigned long long blk,
@@ -514,7 +519,7 @@ TRACE_EVENT(ext4_discard_blocks,
 	TP_printk("dev %d,%d blk %llu count %llu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->blk, __entry->count)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__mb_new_pa,
 	TP_PROTO(struct ext4_allocation_context *ac,
@@ -543,7 +548,7 @@ DECLARE_EVENT_CLASS(ext4__mb_new_pa,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->pa_pstart, __entry->pa_len, __entry->pa_lstart)
-);
+)
 
 DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_new_inode_pa,
 
@@ -551,7 +556,7 @@ DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_ne
 		 struct ext4_prealloc_space *pa),
 
 	TP_ARGS(ac, pa)
-);
+)
 
 DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_new_group_pa,
 
@@ -559,7 +564,7 @@ DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_ne
 		 struct ext4_prealloc_space *pa),
 
 	TP_ARGS(ac, pa)
-);
+)
 
 TRACE_EVENT(ext4_mb_release_inode_pa,
 	TP_PROTO(struct super_block *sb,
@@ -588,7 +593,7 @@ TRACE_EVENT(ext4_mb_release_inode_pa,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->block, __entry->count)
-);
+)
 
 TRACE_EVENT(ext4_mb_release_group_pa,
 	TP_PROTO(struct super_block *sb,
@@ -612,7 +617,7 @@ TRACE_EVENT(ext4_mb_release_group_pa,
 	TP_printk("dev %d,%d pstart %llu len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->pa_pstart, __entry->pa_len)
-);
+)
 
 TRACE_EVENT(ext4_discard_preallocations,
 	TP_PROTO(struct inode *inode),
@@ -633,7 +638,7 @@ TRACE_EVENT(ext4_discard_preallocations,
 	TP_printk("dev %d,%d ino %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino)
-);
+)
 
 TRACE_EVENT(ext4_mb_discard_preallocations,
 	TP_PROTO(struct super_block *sb, int needed),
@@ -654,7 +659,7 @@ TRACE_EVENT(ext4_mb_discard_preallocatio
 	TP_printk("dev %d,%d needed %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->needed)
-);
+)
 
 TRACE_EVENT(ext4_request_blocks,
 	TP_PROTO(struct ext4_allocation_request *ar),
@@ -698,7 +703,7 @@ TRACE_EVENT(ext4_request_blocks,
 		  (unsigned long long) __entry->lright,
 		  (unsigned long long) __entry->pleft,
 		  (unsigned long long) __entry->pright)
-);
+)
 
 TRACE_EVENT(ext4_allocate_blocks,
 	TP_PROTO(struct ext4_allocation_request *ar, unsigned long long block),
@@ -744,7 +749,7 @@ TRACE_EVENT(ext4_allocate_blocks,
 		  (unsigned long long) __entry->lright,
 		  (unsigned long long) __entry->pleft,
 		  (unsigned long long) __entry->pright)
-);
+)
 
 TRACE_EVENT(ext4_free_blocks,
 	TP_PROTO(struct inode *inode, __u64 block, unsigned long count,
@@ -775,7 +780,7 @@ TRACE_EVENT(ext4_free_blocks,
 		  (unsigned long) __entry->ino,
 		  __entry->mode, __entry->block, __entry->count,
 		  __entry->flags)
-);
+)
 
 TRACE_EVENT(ext4_sync_file_enter,
 	TP_PROTO(struct file *file, int datasync),
@@ -802,7 +807,7 @@ TRACE_EVENT(ext4_sync_file_enter,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  (unsigned long) __entry->parent, __entry->datasync)
-);
+)
 
 TRACE_EVENT(ext4_sync_file_exit,
 	TP_PROTO(struct inode *inode, int ret),
@@ -825,7 +830,7 @@ TRACE_EVENT(ext4_sync_file_exit,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->ret)
-);
+)
 
 TRACE_EVENT(ext4_sync_fs,
 	TP_PROTO(struct super_block *sb, int wait),
@@ -846,7 +851,7 @@ TRACE_EVENT(ext4_sync_fs,
 	TP_printk("dev %d,%d wait %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->wait)
-);
+)
 
 TRACE_EVENT(ext4_alloc_da_blocks,
 	TP_PROTO(struct inode *inode),
@@ -871,7 +876,7 @@ TRACE_EVENT(ext4_alloc_da_blocks,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->data_blocks, __entry->meta_blocks)
-);
+)
 
 TRACE_EVENT(ext4_mballoc_alloc,
 	TP_PROTO(struct ext4_allocation_context *ac),
@@ -938,7 +943,7 @@ TRACE_EVENT(ext4_mballoc_alloc,
 		  __entry->found, __entry->groups, __entry->cr,
 		  __entry->flags, __entry->tail,
 		  __entry->buddy ? 1 << __entry->buddy : 0)
-);
+)
 
 TRACE_EVENT(ext4_mballoc_prealloc,
 	TP_PROTO(struct ext4_allocation_context *ac),
@@ -978,7 +983,7 @@ TRACE_EVENT(ext4_mballoc_prealloc,
 		  __entry->orig_len, __entry->orig_logical,
 		  __entry->result_group, __entry->result_start,
 		  __entry->result_len, __entry->result_logical)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__mballoc,
 	TP_PROTO(struct super_block *sb,
@@ -1010,7 +1015,7 @@ DECLARE_EVENT_CLASS(ext4__mballoc,
 		  (unsigned long) __entry->ino,
 		  __entry->result_group, __entry->result_start,
 		  __entry->result_len)
-);
+)
 
 DEFINE_EVENT(ext4__mballoc, ext4_mballoc_discard,
 
@@ -1021,7 +1026,7 @@ DEFINE_EVENT(ext4__mballoc, ext4_mballoc
 		 ext4_grpblk_t len),
 
 	TP_ARGS(sb, inode, group, start, len)
-);
+)
 
 DEFINE_EVENT(ext4__mballoc, ext4_mballoc_free,
 
@@ -1032,7 +1037,7 @@ DEFINE_EVENT(ext4__mballoc, ext4_mballoc
 		 ext4_grpblk_t len),
 
 	TP_ARGS(sb, inode, group, start, len)
-);
+)
 
 TRACE_EVENT(ext4_forget,
 	TP_PROTO(struct inode *inode, int is_metadata, __u64 block),
@@ -1059,7 +1064,7 @@ TRACE_EVENT(ext4_forget,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->mode, __entry->is_metadata, __entry->block)
-);
+)
 
 TRACE_EVENT(ext4_da_update_reserve_space,
 	TP_PROTO(struct inode *inode, int used_blocks),
@@ -1096,7 +1101,7 @@ TRACE_EVENT(ext4_da_update_reserve_space
 		  __entry->mode,  (unsigned long long) __entry->i_blocks,
 		  __entry->used_blocks, __entry->reserved_data_blocks,
 		  __entry->reserved_meta_blocks, __entry->allocated_meta_blocks)
-);
+)
 
 TRACE_EVENT(ext4_da_reserve_space,
 	TP_PROTO(struct inode *inode, int md_needed),
@@ -1130,7 +1135,7 @@ TRACE_EVENT(ext4_da_reserve_space,
 		  __entry->mode, (unsigned long long) __entry->i_blocks,
 		  __entry->md_needed, __entry->reserved_data_blocks,
 		  __entry->reserved_meta_blocks)
-);
+)
 
 TRACE_EVENT(ext4_da_release_space,
 	TP_PROTO(struct inode *inode, int freed_blocks),
@@ -1167,7 +1172,7 @@ TRACE_EVENT(ext4_da_release_space,
 		  __entry->mode, (unsigned long long) __entry->i_blocks,
 		  __entry->freed_blocks, __entry->reserved_data_blocks,
 		  __entry->reserved_meta_blocks, __entry->allocated_meta_blocks)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__bitmap_load,
 	TP_PROTO(struct super_block *sb, unsigned long group),
@@ -1188,35 +1193,35 @@ DECLARE_EVENT_CLASS(ext4__bitmap_load,
 	TP_printk("dev %d,%d group %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->group)
-);
+)
 
 DEFINE_EVENT(ext4__bitmap_load, ext4_mb_bitmap_load,
 
 	TP_PROTO(struct super_block *sb, unsigned long group),
 
 	TP_ARGS(sb, group)
-);
+)
 
 DEFINE_EVENT(ext4__bitmap_load, ext4_mb_buddy_bitmap_load,
 
 	TP_PROTO(struct super_block *sb, unsigned long group),
 
 	TP_ARGS(sb, group)
-);
+)
 
 DEFINE_EVENT(ext4__bitmap_load, ext4_read_block_bitmap_load,
 
 	TP_PROTO(struct super_block *sb, unsigned long group),
 
 	TP_ARGS(sb, group)
-);
+)
 
 DEFINE_EVENT(ext4__bitmap_load, ext4_load_inode_bitmap,
 
 	TP_PROTO(struct super_block *sb, unsigned long group),
 
 	TP_ARGS(sb, group)
-);
+)
 
 TRACE_EVENT(ext4_direct_IO_enter,
 	TP_PROTO(struct inode *inode, loff_t offset, unsigned long len, int rw),
@@ -1243,7 +1248,7 @@ TRACE_EVENT(ext4_direct_IO_enter,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  (unsigned long long) __entry->pos, __entry->len, __entry->rw)
-);
+)
 
 TRACE_EVENT(ext4_direct_IO_exit,
 	TP_PROTO(struct inode *inode, loff_t offset, unsigned long len, int rw, int ret),
@@ -1273,7 +1278,7 @@ TRACE_EVENT(ext4_direct_IO_exit,
 		  (unsigned long) __entry->ino,
 		  (unsigned long long) __entry->pos, __entry->len,
 		  __entry->rw, __entry->ret)
-);
+)
 
 TRACE_EVENT(ext4_fallocate_enter,
 	TP_PROTO(struct inode *inode, loff_t offset, loff_t len, int mode),
@@ -1301,7 +1306,7 @@ TRACE_EVENT(ext4_fallocate_enter,
 		  (unsigned long) __entry->ino,
 		  (unsigned long long) __entry->pos,
 		  (unsigned long long) __entry->len, __entry->mode)
-);
+)
 
 TRACE_EVENT(ext4_fallocate_exit,
 	TP_PROTO(struct inode *inode, loff_t offset, unsigned int max_blocks, int ret),
@@ -1329,7 +1334,7 @@ TRACE_EVENT(ext4_fallocate_exit,
 		  (unsigned long) __entry->ino,
 		  (unsigned long long) __entry->pos, __entry->blocks,
 		  __entry->ret)
-);
+)
 
 TRACE_EVENT(ext4_unlink_enter,
 	TP_PROTO(struct inode *parent, struct dentry *dentry),
@@ -1354,7 +1359,7 @@ TRACE_EVENT(ext4_unlink_enter,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->size,
 		  (unsigned long) __entry->parent)
-);
+)
 
 TRACE_EVENT(ext4_unlink_exit,
 	TP_PROTO(struct dentry *dentry, int ret),
@@ -1377,7 +1382,7 @@ TRACE_EVENT(ext4_unlink_exit,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->ret)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__truncate,
 	TP_PROTO(struct inode *inode),
@@ -1399,21 +1404,21 @@ DECLARE_EVENT_CLASS(ext4__truncate,
 	TP_printk("dev %d,%d ino %lu blocks %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino, (unsigned long) __entry->blocks)
-);
+)
 
 DEFINE_EVENT(ext4__truncate, ext4_truncate_enter,
 
 	TP_PROTO(struct inode *inode),
 
 	TP_ARGS(inode)
-);
+)
 
 DEFINE_EVENT(ext4__truncate, ext4_truncate_exit,
 
 	TP_PROTO(struct inode *inode),
 
 	TP_ARGS(inode)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__map_blocks_enter,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
@@ -1441,21 +1446,21 @@ DECLARE_EVENT_CLASS(ext4__map_blocks_ent
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  (unsigned) __entry->lblk, __entry->len, __entry->flags)
-);
+)
 
 DEFINE_EVENT(ext4__map_blocks_enter, ext4_ext_map_blocks_enter,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
 		 unsigned len, unsigned flags),
 
 	TP_ARGS(inode, lblk, len, flags)
-);
+)
 
 DEFINE_EVENT(ext4__map_blocks_enter, ext4_ind_map_blocks_enter,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
 		 unsigned len, unsigned flags),
 
 	TP_ARGS(inode, lblk, len, flags)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__map_blocks_exit,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
@@ -1486,21 +1491,21 @@ DECLARE_EVENT_CLASS(ext4__map_blocks_exi
 		  (unsigned long) __entry->ino,
 		  (unsigned) __entry->lblk, (unsigned long long) __entry->pblk,
 		  __entry->len, __entry->ret)
-);
+)
 
 DEFINE_EVENT(ext4__map_blocks_exit, ext4_ext_map_blocks_exit,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
 		 ext4_fsblk_t pblk, unsigned len, int ret),
 
 	TP_ARGS(inode, lblk, pblk, len, ret)
-);
+)
 
 DEFINE_EVENT(ext4__map_blocks_exit, ext4_ind_map_blocks_exit,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
 		 ext4_fsblk_t pblk, unsigned len, int ret),
 
 	TP_ARGS(inode, lblk, pblk, len, ret)
-);
+)
 
 TRACE_EVENT(ext4_ext_load_extent,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk, ext4_fsblk_t pblk),
@@ -1525,7 +1530,7 @@ TRACE_EVENT(ext4_ext_load_extent,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  (unsigned) __entry->lblk, (unsigned long long) __entry->pblk)
-);
+)
 
 TRACE_EVENT(ext4_load_inode,
 	TP_PROTO(struct inode *inode),
@@ -1545,7 +1550,7 @@ TRACE_EVENT(ext4_load_inode,
 	TP_printk("dev %d,%d ino %ld",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino)
-);
+)
 
 #endif /* _TRACE_EXT4_H */
 

