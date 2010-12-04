Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0LDAOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:14:43 -0500
Received: from smtp-out.google.com ([74.125.121.35]:17000 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab0LDANy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=s4YZNoVBNbkpegk2HJmrjkrlxukHvRYWc6ssJZ2ZzJhOqauEmwJHJ/6g6FeA0O7r/
	5xnwubRyVPfCqzgte1dTQ==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 11/15] ftrace: fix event alignment: ext4:*
Date: Fri,  3 Dec 2010 16:13:25 -0800
Message-Id: <1291421609-14665-12-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David Sharp <dhsharp@google.com>
---
 include/trace/events/ext4.h |   70 +++++++++++++++++++++---------------------
 1 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index e5e345f..9887cdb 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -23,21 +23,21 @@ TRACE_EVENT(ext4_free_inode,
 	TP_STRUCT__entry(
 		__field(	int,   dev_major                )
 		__field(	int,   dev_minor                )
+		__field(	blkcnt_t, blocks		)
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
 		__field(	uid_t,	uid			)
 		__field(	gid_t,	gid			)
-		__field(	blkcnt_t, blocks		)
+		__field(	umode_t, mode			)
 	),
 
 	TP_fast_assign(
 		__entry->dev_major = MAJOR(inode->i_sb->s_dev);
 		__entry->dev_minor = MINOR(inode->i_sb->s_dev);
+		__entry->blocks	= inode->i_blocks;
 		__entry->ino	= inode->i_ino;
-		__entry->mode	= inode->i_mode;
 		__entry->uid	= inode->i_uid;
 		__entry->gid	= inode->i_gid;
-		__entry->blocks	= inode->i_blocks;
+		__entry->mode	= inode->i_mode;
 	),
 
 	TP_printk("dev %d,%d ino %lu mode 0%o uid %u gid %u blocks %llu",
@@ -342,10 +342,10 @@ TRACE_EVENT(ext4_da_writepages,
 		__field(	long,	pages_skipped		)
 		__field(	loff_t,	range_start		)
 		__field(	loff_t,	range_end		)
+		__field(       pgoff_t,	writeback_index		)
 		__field(	char,	for_kupdate		)
 		__field(	char,	for_reclaim		)
 		__field(	char,	range_cyclic		)
-		__field(       pgoff_t,	writeback_index		)
 	),
 
 	TP_fast_assign(
@@ -356,10 +356,10 @@ TRACE_EVENT(ext4_da_writepages,
 		__entry->pages_skipped	= wbc->pages_skipped;
 		__entry->range_start	= wbc->range_start;
 		__entry->range_end	= wbc->range_end;
+		__entry->writeback_index = inode->i_mapping->writeback_index;
 		__entry->for_kupdate	= wbc->for_kupdate;
 		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
-		__entry->writeback_index = inode->i_mapping->writeback_index;
 	),
 
 	TP_printk("dev %d,%d ino %lu nr_to_write %ld pages_skipped %ld "
@@ -425,8 +425,8 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__field(	int,	ret			)
 		__field(	int,	pages_written		)
 		__field(	long,	pages_skipped		)
-		__field(	char,	more_io			)	
 		__field(       pgoff_t,	writeback_index		)
+		__field(	char,	more_io			)	
 	),
 
 	TP_fast_assign(
@@ -436,8 +436,8 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__entry->ret		= ret;
 		__entry->pages_written	= pages_written;
 		__entry->pages_skipped	= wbc->pages_skipped;
-		__entry->more_io	= wbc->more_io;
 		__entry->writeback_index = inode->i_mapping->writeback_index;
+		__entry->more_io	= wbc->more_io;
 	),
 
 	TP_printk("dev %d,%d ino %lu ret %d pages_written %d pages_skipped %ld more_io %d writeback_index %lu",
@@ -485,8 +485,8 @@ DECLARE_EVENT_CLASS(ext4__mb_new_pa,
 		__field(	int,   dev_minor                )
 		__field(	ino_t,	ino			)
 		__field(	__u64,	pa_pstart		)
-		__field(	__u32,	pa_len			)
 		__field(	__u64,	pa_lstart		)
+		__field(	__u32,	pa_len			)
 
 	),
 
@@ -495,8 +495,8 @@ DECLARE_EVENT_CLASS(ext4__mb_new_pa,
 		__entry->dev_minor	= MINOR(ac->ac_sb->s_dev);
 		__entry->ino		= ac->ac_inode->i_ino;
 		__entry->pa_pstart	= pa->pa_pstart;
-		__entry->pa_len		= pa->pa_len;
 		__entry->pa_lstart	= pa->pa_lstart;
+		__entry->pa_len		= pa->pa_len;
 	),
 
 	TP_printk("dev %d,%d ino %lu pstart %llu len %u lstart %llu",
@@ -724,20 +724,20 @@ TRACE_EVENT(ext4_free_blocks,
 		__field(	int,   dev_major                )
 		__field(	int,   dev_minor                )
 		__field(	ino_t,	ino			)
-		__field(      umode_t, mode			)
 		__field(	__u64,	block			)
 		__field(	unsigned long,	count		)
 		__field(	 int,	flags			)
+		__field(      umode_t, mode			)
 	),
 
 	TP_fast_assign(
 		__entry->dev_major	= MAJOR(inode->i_sb->s_dev);
 		__entry->dev_minor	= MINOR(inode->i_sb->s_dev);
 		__entry->ino		= inode->i_ino;
-		__entry->mode		= inode->i_mode;
 		__entry->block		= block;
 		__entry->count		= count;
 		__entry->flags		= flags;
+		__entry->mode		= inode->i_mode;
 	),
 
 	TP_printk("dev %d,%d ino %lu mode 0%o block %llu count %lu flags %d",
@@ -766,8 +766,8 @@ TRACE_EVENT(ext4_sync_file,
 		__entry->dev_major	= MAJOR(dentry->d_inode->i_sb->s_dev);
 		__entry->dev_minor	= MINOR(dentry->d_inode->i_sb->s_dev);
 		__entry->ino		= dentry->d_inode->i_ino;
-		__entry->datasync	= datasync;
 		__entry->parent		= dentry->d_parent->d_inode->i_ino;
+		__entry->datasync	= datasync;
 	),
 
 	TP_printk("dev %d,%d ino %ld parent %ld datasync %d ",
@@ -834,12 +834,6 @@ TRACE_EVENT(ext4_mballoc_alloc,
 		__field(	int,   dev_major                )
 		__field(	int,   dev_minor                )
 		__field(	ino_t,	ino			)
-		__field(	__u16,	found			)
-		__field(	__u16,	groups			)
-		__field(	__u16,	buddy			)
-		__field(	__u16,	flags			)
-		__field(	__u16,	tail			)
-		__field(	__u8,	cr			)
 		__field(	__u32, 	orig_logical		)
 		__field(	  int,	orig_start		)
 		__field(	__u32, 	orig_group		)
@@ -852,18 +846,18 @@ TRACE_EVENT(ext4_mballoc_alloc,
 		__field(	  int,	result_start		)
 		__field(	__u32, 	result_group		)
 		__field(	  int,	result_len		)
+		__field(	__u16,	found			)
+		__field(	__u16,	groups			)
+		__field(	__u16,	buddy			)
+		__field(	__u16,	flags			)
+		__field(	__u16,	tail			)
+		__field(	__u8,	cr			)
 	),
 
 	TP_fast_assign(
 		__entry->dev_major	= MAJOR(ac->ac_inode->i_sb->s_dev);
 		__entry->dev_minor	= MINOR(ac->ac_inode->i_sb->s_dev);
 		__entry->ino		= ac->ac_inode->i_ino;
-		__entry->found		= ac->ac_found;
-		__entry->flags		= ac->ac_flags;
-		__entry->groups		= ac->ac_groups_scanned;
-		__entry->buddy		= ac->ac_buddy;
-		__entry->tail		= ac->ac_tail;
-		__entry->cr		= ac->ac_criteria;
 		__entry->orig_logical	= ac->ac_o_ex.fe_logical;
 		__entry->orig_start	= ac->ac_o_ex.fe_start;
 		__entry->orig_group	= ac->ac_o_ex.fe_group;
@@ -876,6 +870,12 @@ TRACE_EVENT(ext4_mballoc_alloc,
 		__entry->result_start	= ac->ac_f_ex.fe_start;
 		__entry->result_group	= ac->ac_f_ex.fe_group;
 		__entry->result_len	= ac->ac_f_ex.fe_len;
+		__entry->found		= ac->ac_found;
+		__entry->groups		= ac->ac_groups_scanned;
+		__entry->buddy		= ac->ac_buddy;
+		__entry->flags		= ac->ac_flags;
+		__entry->tail		= ac->ac_tail;
+		__entry->cr		= ac->ac_criteria;
 	),
 
 	TP_printk("dev %d,%d inode %lu orig %u/%d/%u@%u goal %u/%d/%u@%u "
@@ -1001,18 +1001,18 @@ TRACE_EVENT(ext4_forget,
 		__field(	int,   dev_major                )
 		__field(	int,   dev_minor                )
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
-		__field(	int,	is_metadata		)
 		__field(	__u64,	block			)
+		__field(	int,	is_metadata		)
+		__field(	umode_t, mode			)
 	),
 
 	TP_fast_assign(
 		__entry->dev_major = MAJOR(inode->i_sb->s_dev);
 		__entry->dev_minor = MINOR(inode->i_sb->s_dev);
 		__entry->ino	= inode->i_ino;
-		__entry->mode	= inode->i_mode;
-		__entry->is_metadata = is_metadata;
 		__entry->block	= block;
+		__entry->is_metadata = is_metadata;
+		__entry->mode	= inode->i_mode;
 	),
 
 	TP_printk("dev %d,%d ino %lu mode 0%o is_metadata %d block %llu",
@@ -1030,24 +1030,24 @@ TRACE_EVENT(ext4_da_update_reserve_space,
 		__field(	int,   dev_major                )
 		__field(	int,   dev_minor                )
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
 		__field(	__u64,	i_blocks		)
 		__field(	int,	used_blocks		)
 		__field(	int,	reserved_data_blocks	)
 		__field(	int,	reserved_meta_blocks	)
 		__field(	int,	allocated_meta_blocks	)
+		__field(	umode_t, mode			)
 	),
 
 	TP_fast_assign(
 		__entry->dev_major = MAJOR(inode->i_sb->s_dev);
 		__entry->dev_minor = MINOR(inode->i_sb->s_dev);
 		__entry->ino	= inode->i_ino;
-		__entry->mode	= inode->i_mode;
 		__entry->i_blocks = inode->i_blocks;
 		__entry->used_blocks = used_blocks;
 		__entry->reserved_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
 		__entry->reserved_meta_blocks = EXT4_I(inode)->i_reserved_meta_blocks;
 		__entry->allocated_meta_blocks = EXT4_I(inode)->i_allocated_meta_blocks;
+		__entry->mode	= inode->i_mode;
 	),
 
 	TP_printk("dev %d,%d ino %lu mode 0%o i_blocks %llu used_blocks %d reserved_data_blocks %d reserved_meta_blocks %d allocated_meta_blocks %d",
@@ -1067,22 +1067,22 @@ TRACE_EVENT(ext4_da_reserve_space,
 		__field(	int,   dev_major                )
 		__field(	int,   dev_minor                )
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
 		__field(	__u64,	i_blocks		)
 		__field(	int,	md_needed		)
 		__field(	int,	reserved_data_blocks	)
 		__field(	int,	reserved_meta_blocks	)
+		__field(	umode_t, mode			)
 	),
 
 	TP_fast_assign(
 		__entry->dev_major = MAJOR(inode->i_sb->s_dev);
 		__entry->dev_minor = MINOR(inode->i_sb->s_dev);
 		__entry->ino	= inode->i_ino;
-		__entry->mode	= inode->i_mode;
 		__entry->i_blocks = inode->i_blocks;
 		__entry->md_needed = md_needed;
 		__entry->reserved_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
 		__entry->reserved_meta_blocks = EXT4_I(inode)->i_reserved_meta_blocks;
+		__entry->mode	= inode->i_mode;
 	),
 
 	TP_printk("dev %d,%d ino %lu mode 0%o i_blocks %llu md_needed %d reserved_data_blocks %d reserved_meta_blocks %d",
@@ -1102,24 +1102,24 @@ TRACE_EVENT(ext4_da_release_space,
 		__field(	int,   dev_major                )
 		__field(	int,   dev_minor                )
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
 		__field(	__u64,	i_blocks		)
 		__field(	int,	freed_blocks		)
 		__field(	int,	reserved_data_blocks	)
 		__field(	int,	reserved_meta_blocks	)
 		__field(	int,	allocated_meta_blocks	)
+		__field(	umode_t, mode			)
 	),
 
 	TP_fast_assign(
 		__entry->dev_major = MAJOR(inode->i_sb->s_dev);
 		__entry->dev_minor = MINOR(inode->i_sb->s_dev);
 		__entry->ino	= inode->i_ino;
-		__entry->mode	= inode->i_mode;
 		__entry->i_blocks = inode->i_blocks;
 		__entry->freed_blocks = freed_blocks;
 		__entry->reserved_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
 		__entry->reserved_meta_blocks = EXT4_I(inode)->i_reserved_meta_blocks;
 		__entry->allocated_meta_blocks = EXT4_I(inode)->i_allocated_meta_blocks;
+		__entry->mode	= inode->i_mode;
 	),
 
 	TP_printk("dev %d,%d ino %lu mode 0%o i_blocks %llu freed_blocks %d reserved_data_blocks %d reserved_meta_blocks %d allocated_meta_blocks %d",
-- 
1.7.3.1

