Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab2AJS2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:28:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33972 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab2AJS2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:28:47 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com
Cc: linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/9] writeback: move struct wb_writeback_work to writeback.h
Date: Tue, 10 Jan 2012 10:28:21 -0800
Message-Id: <1326220106-5765-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1326220106-5765-1-git-send-email-tj@kernel.org>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move definition of struct wb_writeback_work from fs/fs-writeback.c to
include/linux/writeback.h.  This is to allow accessing fields from
writeback tracepoint probes which live outside fs-writeback.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fs-writeback.c         |   18 ------------------
 include/linux/writeback.h |   18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e295150..a97cb49 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -29,24 +29,6 @@
 #include "internal.h"
 
 /*
- * Passed into wb_writeback(), essentially a subset of writeback_control
- */
-struct wb_writeback_work {
-	long nr_pages;
-	struct super_block *sb;
-	unsigned long *older_than_this;
-	enum writeback_sync_modes sync_mode;
-	unsigned int tagged_writepages:1;
-	unsigned int for_kupdate:1;
-	unsigned int range_cyclic:1;
-	unsigned int for_background:1;
-	enum wb_reason reason;		/* why was writeback initiated? */
-
-	struct list_head list;		/* pending work list */
-	struct completion *done;	/* set if the caller waits */
-};
-
-/*
  * Include the creation of the trace points after defining the
  * wb_writeback_work structure so that the definition remains local to this
  * file.
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a378c29..10d22d1 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -82,6 +82,24 @@ struct writeback_control {
 };
 
 /*
+ * Passed into wb_writeback(), essentially a subset of writeback_control
+ */
+struct wb_writeback_work {
+	long nr_pages;
+	struct super_block *sb;
+	unsigned long *older_than_this;
+	enum writeback_sync_modes sync_mode;
+	unsigned int tagged_writepages:1;
+	unsigned int for_kupdate:1;
+	unsigned int range_cyclic:1;
+	unsigned int for_background:1;
+	enum wb_reason reason;		/* why was writeback initiated? */
+
+	struct list_head list;		/* pending work list */
+	struct completion *done;	/* set if the caller waits */
+};
+
+/*
  * fs/fs-writeback.c
  */	
 struct bdi_writeback;
-- 
1.7.3.1

