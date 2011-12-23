Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1LWKtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:49:49 -0500
Received: from mga14.intel.com ([143.182.124.37]:44228 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab1LWKtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:49:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88892784"
Date: Fri, 23 Dec 2011 18:49:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Curt Wohlgemuth <curtw@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] writeback tracing fix for 3.2-rc7
Message-ID: <20111223104943.GA5639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Here's one trivial writeback tracing fix with signed tag

git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git

 * [new tag]         writeback -> writeback

Thanks,
Fengguang
---

The following changes since commit 384703b8e6cd4c8ef08512e596024e028c91c339:

  Linux 3.2-rc6 (2011-12-16 18:36:26 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git writeback-for-linus

Wu Fengguang (1):
      writeback: show writeback reason with __print_symbolic

 fs/fs-writeback.c                |   11 -----------
 include/trace/events/writeback.h |   15 +++++++++++++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ac86f8b..517f211 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -47,17 +47,6 @@ struct wb_writeback_work {
 	struct completion *done;	/* set if the caller waits */
 };
 
-const char *wb_reason_name[] = {
-	[WB_REASON_BACKGROUND]		= "background",
-	[WB_REASON_TRY_TO_FREE_PAGES]	= "try_to_free_pages",
-	[WB_REASON_SYNC]		= "sync",
-	[WB_REASON_PERIODIC]		= "periodic",
-	[WB_REASON_LAPTOP_TIMER]	= "laptop_timer",
-	[WB_REASON_FREE_MORE_MEM]	= "free_more_memory",
-	[WB_REASON_FS_FREE_SPACE]	= "fs_free_space",
-	[WB_REASON_FORKER_THREAD]	= "forker_thread"
-};
-
 /*
  * Include the creation of the trace points after defining the
  * wb_writeback_work structure so that the definition remains local to this
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index b99caa8..99d1d0d 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -21,6 +21,16 @@
 		{I_REFERENCED,		"I_REFERENCED"}		\
 	)
 
+#define WB_WORK_REASON							\
+		{WB_REASON_BACKGROUND,		"background"},		\
+		{WB_REASON_TRY_TO_FREE_PAGES,	"try_to_free_pages"},	\
+		{WB_REASON_SYNC,		"sync"},		\
+		{WB_REASON_PERIODIC,		"periodic"},		\
+		{WB_REASON_LAPTOP_TIMER,	"laptop_timer"},	\
+		{WB_REASON_FREE_MORE_MEM,	"free_more_memory"},	\
+		{WB_REASON_FS_FREE_SPACE,	"fs_free_space"},	\
+		{WB_REASON_FORKER_THREAD,	"forker_thread"}
+
 struct wb_writeback_work;
 
 DECLARE_EVENT_CLASS(writeback_work_class,
@@ -55,7 +65,7 @@ DECLARE_EVENT_CLASS(writeback_work_class,
 		  __entry->for_kupdate,
 		  __entry->range_cyclic,
 		  __entry->for_background,
-		  wb_reason_name[__entry->reason]
+		  __print_symbolic(__entry->reason, WB_WORK_REASON)
 	)
 );
 #define DEFINE_WRITEBACK_WORK_EVENT(name) \
@@ -184,7 +194,8 @@ TRACE_EVENT(writeback_queue_io,
 		__entry->older,	/* older_than_this in jiffies */
 		__entry->age,	/* older_than_this in relative milliseconds */
 		__entry->moved,
-		wb_reason_name[__entry->reason])
+		__print_symbolic(__entry->reason, WB_WORK_REASON)
+	)
 );
 
 TRACE_EVENT(global_dirty_state,
