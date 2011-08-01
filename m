Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1HAQwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:52:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35898
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab1HAQwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:52:49 -0400
Date: Mon, 1 Aug 2011 12:52:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110801165242.GA18802@infradead.org>
References: <20110728164105.GA18258@infradead.org>
 <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard>
 <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard>
 <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
 <20110801020951.GA12870@dastard>
 <20110801112330.GA27190@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20110801112330.GA27190@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

wb_check_background_flush is indeed what we're hitting.  See the trace
output using a patch inspired by Curt's below:

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-4279  [000]   113.034052: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034052: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034052: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034052: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034053: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034053: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034053: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034054: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034054: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034054: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034055: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034055: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034055: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034056: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034056: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
           <...>-4279  [000]   113.034056: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=fs-trace-io-source

From: Christoph Hellwig <hch@lst.de>
Subject: writeback: trace the source of writeback works

Trace who queued up work to the flusher thread.  Also add a new tracepoint to
the failed grab_super_passive case.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/fs-writeback.c
===================================================================
--- xfs.orig/fs/fs-writeback.c	2011-08-01 17:59:15.318991514 +0200
+++ xfs/fs/fs-writeback.c	2011-08-01 18:31:33.221826327 +0200
@@ -41,7 +41,7 @@ struct wb_writeback_work {
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
-
+	enum writeback_reason why;
 	struct list_head list;		/* pending work list */
 	struct completion *done;	/* set if the caller waits */
 };
@@ -115,7 +115,7 @@ static void bdi_queue_work(struct backin
 
 static void
 __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
-		      bool range_cyclic)
+		      bool range_cyclic, enum writeback_reason why)
 {
 	struct wb_writeback_work *work;
 
@@ -135,6 +135,7 @@ __bdi_start_writeback(struct backing_dev
 	work->sync_mode	= WB_SYNC_NONE;
 	work->nr_pages	= nr_pages;
 	work->range_cyclic = range_cyclic;
+	work->why = why;
 
 	bdi_queue_work(bdi, work);
 }
@@ -152,7 +153,7 @@ __bdi_start_writeback(struct backing_dev
  */
 void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages)
 {
-	__bdi_start_writeback(bdi, nr_pages, true);
+	__bdi_start_writeback(bdi, nr_pages, true, WB_START_WRITEBACK);
 }
 
 /**
@@ -618,6 +619,7 @@ static long __writeback_inodes_wb(struct
 		struct super_block *sb = inode->i_sb;
 
 		if (!grab_super_passive(sb)) {
+			trace_writeback_grab_super_failed(wb->bdi, work);
 			redirty_tail(inode, wb);
 			continue;
 		}
@@ -636,12 +638,14 @@ static long __writeback_inodes_wb(struct
 	return wrote;
 }
 
-long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages)
+long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
+		enum writeback_reason why)
 {
 	struct wb_writeback_work work = {
 		.nr_pages	= nr_pages,
 		.sync_mode	= WB_SYNC_NONE,
 		.range_cyclic	= 1,
+		.why		= why,
 	};
 
 	spin_lock(&wb->list_lock);
@@ -813,6 +817,7 @@ static long wb_check_background_flush(st
 			.sync_mode	= WB_SYNC_NONE,
 			.for_background	= 1,
 			.range_cyclic	= 1,
+			.why		= WB_BACKGROUND,
 		};
 
 		return wb_writeback(wb, &work);
@@ -846,6 +851,7 @@ static long wb_check_old_data_flush(stru
 			.sync_mode	= WB_SYNC_NONE,
 			.for_kupdate	= 1,
 			.range_cyclic	= 1,
+			.why		= WB_OLD,
 		};
 
 		return wb_writeback(wb, &work);
@@ -977,7 +983,7 @@ void wakeup_flusher_threads(long nr_page
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
-		__bdi_start_writeback(bdi, nr_pages, false);
+		__bdi_start_writeback(bdi, nr_pages, false, WB_FLUSHER_THREADS);
 	}
 	rcu_read_unlock();
 }
@@ -1207,6 +1213,7 @@ void writeback_inodes_sb_nr(struct super
 		.tagged_writepages	= 1,
 		.done			= &done,
 		.nr_pages		= nr,
+		.why			= WB_WRITEBACK_INODES,
 	};
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
@@ -1285,6 +1292,7 @@ void sync_inodes_sb(struct super_block *
 		.nr_pages	= LONG_MAX,
 		.range_cyclic	= 0,
 		.done		= &done,
+		.why		= WB_SYNC_INODES,
 	};
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
Index: xfs/include/trace/events/writeback.h
===================================================================
--- xfs.orig/include/trace/events/writeback.h	2011-08-01 17:58:27.649249764 +0200
+++ xfs/include/trace/events/writeback.h	2011-08-01 18:31:26.501862733 +0200
@@ -21,6 +21,16 @@
 		{I_REFERENCED,		"I_REFERENCED"}		\
 	)
 
+#define WB_TYPES \
+	{ WB_SYNC_INODES,	"sync_inodes_sb" },		\
+	{ WB_WRITEBACK_INODES,	"writeback_inodes_sb" },	\
+	{ WB_START_WRITEBACK,	"bdi_start_writeback" },	\
+	{ WB_FLUSHER_THREADS,	"wakeup_flusher_threads" },	\
+	{ WB_EMERGENCY,		"emergency flush" },		\
+	{ WB_BALANCE,		"balance_dirty_pages" },	\
+	{ WB_BACKGROUND,	"wb_check_background_flush" },	\
+	{ WB_OLD,		"wb_check_old_data_flush" }
+
 struct wb_writeback_work;
 
 DECLARE_EVENT_CLASS(writeback_work_class,
@@ -34,6 +44,7 @@ DECLARE_EVENT_CLASS(writeback_work_class
 		__field(int, for_kupdate)
 		__field(int, range_cyclic)
 		__field(int, for_background)
+		__field(int, why)
 	),
 	TP_fast_assign(
 		strncpy(__entry->name, dev_name(bdi->dev), 32);
@@ -43,16 +54,18 @@ DECLARE_EVENT_CLASS(writeback_work_class
 		__entry->for_kupdate = work->for_kupdate;
 		__entry->range_cyclic = work->range_cyclic;
 		__entry->for_background	= work->for_background;
+		__entry->why = work->why;
 	),
 	TP_printk("bdi %s: sb_dev %d:%d nr_pages=%ld sync_mode=%d "
-		  "kupdate=%d range_cyclic=%d background=%d",
+		  "kupdate=%d range_cyclic=%d background=%d reason=%s",
 		  __entry->name,
 		  MAJOR(__entry->sb_dev), MINOR(__entry->sb_dev),
 		  __entry->nr_pages,
 		  __entry->sync_mode,
 		  __entry->for_kupdate,
 		  __entry->range_cyclic,
-		  __entry->for_background
+		  __entry->for_background,
+		  __print_symbolic(__entry->why, WB_TYPES)
 	)
 );
 #define DEFINE_WRITEBACK_WORK_EVENT(name) \
@@ -65,6 +78,7 @@ DEFINE_WRITEBACK_WORK_EVENT(writeback_ex
 DEFINE_WRITEBACK_WORK_EVENT(writeback_start);
 DEFINE_WRITEBACK_WORK_EVENT(writeback_written);
 DEFINE_WRITEBACK_WORK_EVENT(writeback_wait);
+DEFINE_WRITEBACK_WORK_EVENT(writeback_grab_super_failed);
 
 TRACE_EVENT(writeback_pages_written,
 	TP_PROTO(long pages_written),
Index: xfs/include/linux/writeback.h
===================================================================
--- xfs.orig/include/linux/writeback.h	2011-08-01 18:24:26.754136700 +0200
+++ xfs/include/linux/writeback.h	2011-08-01 18:32:37.158146620 +0200
@@ -79,13 +79,26 @@ struct writeback_control {
  * fs/fs-writeback.c
  */	
 struct bdi_writeback;
+
+enum writeback_reason {
+	WB_SYNC_INODES,
+	WB_WRITEBACK_INODES,
+	WB_START_WRITEBACK,
+	WB_FLUSHER_THREADS,
+	WB_EMERGENCY,
+	WB_BALANCE,
+	WB_BACKGROUND,
+	WB_OLD,
+};
+
 int inode_wait(void *);
 void writeback_inodes_sb(struct super_block *);
 void writeback_inodes_sb_nr(struct super_block *, unsigned long nr);
 int writeback_inodes_sb_if_idle(struct super_block *);
 int writeback_inodes_sb_nr_if_idle(struct super_block *, unsigned long nr);
 void sync_inodes_sb(struct super_block *);
-long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages);
+long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
+	enum writeback_reason why);
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 void wakeup_flusher_threads(long nr_pages);
 
Index: xfs/mm/backing-dev.c
===================================================================
--- xfs.orig/mm/backing-dev.c	2011-08-01 18:24:26.774136593 +0200
+++ xfs/mm/backing-dev.c	2011-08-01 18:25:09.910569569 +0200
@@ -456,7 +456,7 @@ static int bdi_forker_thread(void *ptr)
 				 * the bdi from the thread. Hopefully 1024 is
 				 * large enough for efficient IO.
 				 */
-				writeback_inodes_wb(&bdi->wb, 1024);
+				writeback_inodes_wb(&bdi->wb, 1024, WB_EMERGENCY);
 			} else {
 				/*
 				 * The spinlock makes sure we do not lose
Index: xfs/mm/page-writeback.c
===================================================================
--- xfs.orig/mm/page-writeback.c	2011-08-01 18:24:26.794136483 +0200
+++ xfs/mm/page-writeback.c	2011-08-01 18:27:43.019740106 +0200
@@ -738,7 +738,8 @@ static void balance_dirty_pages(struct a
 		trace_balance_dirty_start(bdi);
 		if (bdi_nr_reclaimable > task_bdi_thresh) {
 			pages_written += writeback_inodes_wb(&bdi->wb,
-							     write_chunk);
+							     write_chunk,
+							     WB_BALANCE);
 			trace_balance_dirty_written(bdi, pages_written);
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */

--PEIAKu/WMn1b1Hv9--
