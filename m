Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1AIWFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:05:32 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:34894 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1AIWF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:26 -0500
Message-Id: <20110109220508.941643136@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>
Subject: [RFC patch 05/28] trace event ext4 remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-ext4-remove-semicolons.patch
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
 include/trace/events/ext4.h |   95 +++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 45 deletions(-)

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
 
@@ -45,7 +50,7 @@ TRACE_EVENT(ext4_free_inode,
 		  (unsigned long) __entry->ino, __entry->mode,
 		  __entry->uid, __entry->gid,
 		  (unsigned long long) __entry->blocks)
-);
+)
 
 TRACE_EVENT(ext4_request_inode,
 	TP_PROTO(struct inode *dir, int mode),
@@ -69,7 +74,7 @@ TRACE_EVENT(ext4_request_inode,
 	TP_printk("dev %d,%d dir %lu mode 0%o",
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->dir, __entry->mode)
-);
+)
 
 TRACE_EVENT(ext4_allocate_inode,
 	TP_PROTO(struct inode *inode, struct inode *dir, int mode),
@@ -96,7 +101,7 @@ TRACE_EVENT(ext4_allocate_inode,
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino,
 		  (unsigned long) __entry->dir, __entry->mode)
-);
+)
 
 TRACE_EVENT(ext4_evict_inode,
 	TP_PROTO(struct inode *inode),
@@ -120,7 +125,7 @@ TRACE_EVENT(ext4_evict_inode,
 	TP_printk("dev %d,%d ino %lu nlink %d",
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino, __entry->nlink)
-);
+)
 
 TRACE_EVENT(ext4_drop_inode,
 	TP_PROTO(struct inode *inode, int drop),
@@ -144,7 +149,7 @@ TRACE_EVENT(ext4_drop_inode,
 	TP_printk("dev %d,%d ino %lu drop %d",
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino, __entry->drop)
-);
+)
 
 TRACE_EVENT(ext4_mark_inode_dirty,
 	TP_PROTO(struct inode *inode, unsigned long IP),
@@ -168,7 +173,7 @@ TRACE_EVENT(ext4_mark_inode_dirty,
 	TP_printk("dev %d,%d ino %lu caller %pF",
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino, (void *)__entry->ip)
-);
+)
 
 TRACE_EVENT(ext4_begin_ordered_truncate,
 	TP_PROTO(struct inode *inode, loff_t new_size),
@@ -193,7 +198,7 @@ TRACE_EVENT(ext4_begin_ordered_truncate,
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino,
 		  (long long) __entry->new_size)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__write_begin,
 
@@ -224,7 +229,7 @@ DECLARE_EVENT_CLASS(ext4__write_begin,
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino,
 		  __entry->pos, __entry->len, __entry->flags)
-);
+)
 
 DEFINE_EVENT(ext4__write_begin, ext4_write_begin,
 
@@ -232,7 +237,7 @@ DEFINE_EVENT(ext4__write_begin, ext4_wri
 		 unsigned int flags),
 
 	TP_ARGS(inode, pos, len, flags)
-);
+)
 
 DEFINE_EVENT(ext4__write_begin, ext4_da_write_begin,
 
@@ -240,7 +245,7 @@ DEFINE_EVENT(ext4__write_begin, ext4_da_
 		 unsigned int flags),
 
 	TP_ARGS(inode, pos, len, flags)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__write_end,
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
@@ -270,7 +275,7 @@ DECLARE_EVENT_CLASS(ext4__write_end,
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino, __entry->pos,
 		  __entry->len, __entry->copied)
-);
+)
 
 DEFINE_EVENT(ext4__write_end, ext4_ordered_write_end,
 
@@ -278,7 +283,7 @@ DEFINE_EVENT(ext4__write_end, ext4_order
 		 unsigned int copied),
 
 	TP_ARGS(inode, pos, len, copied)
-);
+)
 
 DEFINE_EVENT(ext4__write_end, ext4_writeback_write_end,
 
@@ -286,7 +291,7 @@ DEFINE_EVENT(ext4__write_end, ext4_write
 		 unsigned int copied),
 
 	TP_ARGS(inode, pos, len, copied)
-);
+)
 
 DEFINE_EVENT(ext4__write_end, ext4_journalled_write_end,
 
@@ -294,7 +299,7 @@ DEFINE_EVENT(ext4__write_end, ext4_journ
 		 unsigned int copied),
 
 	TP_ARGS(inode, pos, len, copied)
-);
+)
 
 DEFINE_EVENT(ext4__write_end, ext4_da_write_end,
 
@@ -302,7 +307,7 @@ DEFINE_EVENT(ext4__write_end, ext4_da_wr
 		 unsigned int copied),
 
 	TP_ARGS(inode, pos, len, copied)
-);
+)
 
 TRACE_EVENT(ext4_writepage,
 	TP_PROTO(struct inode *inode, struct page *page),
@@ -327,7 +332,7 @@ TRACE_EVENT(ext4_writepage,
 	TP_printk("dev %d,%d ino %lu page_index %lu",
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino, __entry->index)
-);
+)
 
 TRACE_EVENT(ext4_da_writepages,
 	TP_PROTO(struct inode *inode, struct writeback_control *wbc),
@@ -373,7 +378,7 @@ TRACE_EVENT(ext4_da_writepages,
 		  __entry->for_kupdate, __entry->for_reclaim,
 		  __entry->range_cyclic,
 		  (unsigned long) __entry->writeback_index)
-);
+)
 
 TRACE_EVENT(ext4_da_write_pages,
 	TP_PROTO(struct inode *inode, struct mpage_da_data *mpd),
@@ -410,7 +415,7 @@ TRACE_EVENT(ext4_da_write_pages,
 		  __entry->b_blocknr, __entry->b_size,
 		  __entry->b_state, __entry->first_page,
 		  __entry->io_done, __entry->pages_written)
-);
+)
 
 TRACE_EVENT(ext4_da_writepages_result,
 	TP_PROTO(struct inode *inode, struct writeback_control *wbc,
@@ -446,7 +451,7 @@ TRACE_EVENT(ext4_da_writepages_result,
 		  __entry->pages_written, __entry->pages_skipped,
 		  __entry->more_io,
 		  (unsigned long) __entry->writeback_index)
-);
+)
 
 TRACE_EVENT(ext4_discard_blocks,
 	TP_PROTO(struct super_block *sb, unsigned long long blk,
@@ -472,7 +477,7 @@ TRACE_EVENT(ext4_discard_blocks,
 	TP_printk("dev %d,%d blk %llu count %llu",
 		  __entry->dev_major, __entry->dev_minor,
 		  __entry->blk, __entry->count)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__mb_new_pa,
 	TP_PROTO(struct ext4_allocation_context *ac,
@@ -503,7 +508,7 @@ DECLARE_EVENT_CLASS(ext4__mb_new_pa,
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino, __entry->pa_pstart,
 		  __entry->pa_len, __entry->pa_lstart)
-);
+)
 
 DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_new_inode_pa,
 
@@ -511,7 +516,7 @@ DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_ne
 		 struct ext4_prealloc_space *pa),
 
 	TP_ARGS(ac, pa)
-);
+)
 
 DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_new_group_pa,
 
@@ -519,7 +524,7 @@ DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_ne
 		 struct ext4_prealloc_space *pa),
 
 	TP_ARGS(ac, pa)
-);
+)
 
 TRACE_EVENT(ext4_mb_release_inode_pa,
 	TP_PROTO(struct super_block *sb,
@@ -549,7 +554,7 @@ TRACE_EVENT(ext4_mb_release_inode_pa,
 	TP_printk("dev %d,%d ino %lu block %llu count %u",
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino, __entry->block, __entry->count)
-);
+)
 
 TRACE_EVENT(ext4_mb_release_group_pa,
 	TP_PROTO(struct super_block *sb,
@@ -575,7 +580,7 @@ TRACE_EVENT(ext4_mb_release_group_pa,
 	TP_printk("dev %d,%d pstart %llu len %u",
 		  __entry->dev_major, __entry->dev_minor,
 		  __entry->pa_pstart, __entry->pa_len)
-);
+)
 
 TRACE_EVENT(ext4_discard_preallocations,
 	TP_PROTO(struct inode *inode),
@@ -598,7 +603,7 @@ TRACE_EVENT(ext4_discard_preallocations,
 	TP_printk("dev %d,%d ino %lu",
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino)
-);
+)
 
 TRACE_EVENT(ext4_mb_discard_preallocations,
 	TP_PROTO(struct super_block *sb, int needed),
@@ -620,7 +625,7 @@ TRACE_EVENT(ext4_mb_discard_preallocatio
 
 	TP_printk("dev %d,%d needed %d",
 		  __entry->dev_major, __entry->dev_minor, __entry->needed)
-);
+)
 
 TRACE_EVENT(ext4_request_blocks,
 	TP_PROTO(struct ext4_allocation_request *ar),
@@ -665,7 +670,7 @@ TRACE_EVENT(ext4_request_blocks,
 		  (unsigned long long) __entry->lright,
 		  (unsigned long long) __entry->pleft,
 		  (unsigned long long) __entry->pright)
-);
+)
 
 TRACE_EVENT(ext4_allocate_blocks,
 	TP_PROTO(struct ext4_allocation_request *ar, unsigned long long block),
@@ -712,7 +717,7 @@ TRACE_EVENT(ext4_allocate_blocks,
 		  (unsigned long long) __entry->lright,
 		  (unsigned long long) __entry->pleft,
 		  (unsigned long long) __entry->pright)
-);
+)
 
 TRACE_EVENT(ext4_free_blocks,
 	TP_PROTO(struct inode *inode, __u64 block, unsigned long count,
@@ -745,7 +750,7 @@ TRACE_EVENT(ext4_free_blocks,
 		  (unsigned long) __entry->ino,
 		  __entry->mode, __entry->block, __entry->count,
 		  __entry->flags)
-);
+)
 
 TRACE_EVENT(ext4_sync_file,
 	TP_PROTO(struct file *file, int datasync),
@@ -774,7 +779,7 @@ TRACE_EVENT(ext4_sync_file,
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino,
 		  (unsigned long) __entry->parent, __entry->datasync)
-);
+)
 
 TRACE_EVENT(ext4_sync_fs,
 	TP_PROTO(struct super_block *sb, int wait),
@@ -796,7 +801,7 @@ TRACE_EVENT(ext4_sync_fs,
 
 	TP_printk("dev %d,%d wait %d", __entry->dev_major,
 		  __entry->dev_minor, __entry->wait)
-);
+)
 
 TRACE_EVENT(ext4_alloc_da_blocks,
 	TP_PROTO(struct inode *inode),
@@ -823,7 +828,7 @@ TRACE_EVENT(ext4_alloc_da_blocks,
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino,
 		  __entry->data_blocks, __entry->meta_blocks)
-);
+)
 
 TRACE_EVENT(ext4_mballoc_alloc,
 	TP_PROTO(struct ext4_allocation_context *ac),
@@ -892,7 +897,7 @@ TRACE_EVENT(ext4_mballoc_alloc,
 		  __entry->found, __entry->groups, __entry->cr,
 		  __entry->flags, __entry->tail,
 		  __entry->buddy ? 1 << __entry->buddy : 0)
-);
+)
 
 TRACE_EVENT(ext4_mballoc_prealloc,
 	TP_PROTO(struct ext4_allocation_context *ac),
@@ -934,7 +939,7 @@ TRACE_EVENT(ext4_mballoc_prealloc,
 		  __entry->orig_len, __entry->orig_logical,
 		  __entry->result_group, __entry->result_start,
 		  __entry->result_len, __entry->result_logical)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__mballoc,
 	TP_PROTO(struct super_block *sb,
@@ -968,7 +973,7 @@ DECLARE_EVENT_CLASS(ext4__mballoc,
 		  (unsigned long) __entry->ino,
 		  __entry->result_group, __entry->result_start,
 		  __entry->result_len)
-);
+)
 
 DEFINE_EVENT(ext4__mballoc, ext4_mballoc_discard,
 
@@ -979,7 +984,7 @@ DEFINE_EVENT(ext4__mballoc, ext4_mballoc
 		 ext4_grpblk_t len),
 
 	TP_ARGS(sb, inode, group, start, len)
-);
+)
 
 DEFINE_EVENT(ext4__mballoc, ext4_mballoc_free,
 
@@ -990,7 +995,7 @@ DEFINE_EVENT(ext4__mballoc, ext4_mballoc
 		 ext4_grpblk_t len),
 
 	TP_ARGS(sb, inode, group, start, len)
-);
+)
 
 TRACE_EVENT(ext4_forget,
 	TP_PROTO(struct inode *inode, int is_metadata, __u64 block),
@@ -1019,7 +1024,7 @@ TRACE_EVENT(ext4_forget,
 		  __entry->dev_major, __entry->dev_minor,
 		  (unsigned long) __entry->ino, __entry->mode,
 		  __entry->is_metadata, __entry->block)
-);
+)
 
 TRACE_EVENT(ext4_da_update_reserve_space,
 	TP_PROTO(struct inode *inode, int used_blocks),
@@ -1056,7 +1061,7 @@ TRACE_EVENT(ext4_da_update_reserve_space
 		  (unsigned long long) __entry->i_blocks,
 		  __entry->used_blocks, __entry->reserved_data_blocks,
 		  __entry->reserved_meta_blocks, __entry->allocated_meta_blocks)
-);
+)
 
 TRACE_EVENT(ext4_da_reserve_space,
 	TP_PROTO(struct inode *inode, int md_needed),
@@ -1091,7 +1096,7 @@ TRACE_EVENT(ext4_da_reserve_space,
 		  __entry->mode, (unsigned long long) __entry->i_blocks,
 		  __entry->md_needed, __entry->reserved_data_blocks,
 		  __entry->reserved_meta_blocks)
-);
+)
 
 TRACE_EVENT(ext4_da_release_space,
 	TP_PROTO(struct inode *inode, int freed_blocks),
@@ -1128,7 +1133,7 @@ TRACE_EVENT(ext4_da_release_space,
 		  __entry->mode, (unsigned long long) __entry->i_blocks,
 		  __entry->freed_blocks, __entry->reserved_data_blocks,
 		  __entry->reserved_meta_blocks, __entry->allocated_meta_blocks)
-);
+)
 
 DECLARE_EVENT_CLASS(ext4__bitmap_load,
 	TP_PROTO(struct super_block *sb, unsigned long group),
@@ -1150,21 +1155,21 @@ DECLARE_EVENT_CLASS(ext4__bitmap_load,
 
 	TP_printk("dev %d,%d group %u",
 		  __entry->dev_major, __entry->dev_minor, __entry->group)
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
 
 #endif /* _TRACE_EXT4_H */
 

