Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030276Ab2CSGfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:35:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38923 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2CSGfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:35:52 -0400
Message-ID: <4F66D3B5.60008@gmail.com>
Date: Mon, 19 Mar 2012 14:35:33 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs/async-thread: introduce macro BTRFS_WORKERS_IDLE_THRESH
 to replace the magic number 32 used for btrfs_workers->idle_thresh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/async-thread.c |    2 +-
 fs/btrfs/async-thread.h |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 5a7d756..2491096 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -445,7 +445,7 @@ void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max,
 	spin_lock_init(&workers->lock);
 	spin_lock_init(&workers->order_lock);
 	workers->max_workers = max;
-	workers->idle_thresh = 32;
+	workers->idle_thresh = BTRFS_WORKERS_IDLE_THRESH;
 	workers->name = name;
 	workers->ordered = 0;
 	workers->atomic_start_pending = 0;
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index f34cc31..9b9522e 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -60,6 +60,9 @@ struct btrfs_work {
 	struct list_head order_list;
 };
 
+/* default value for btrfs_workers->idle_thresh */
+#define BTRFS_WORKERS_IDLE_THRESH 32
+
 struct btrfs_workers {
 	/* current number of running workers */
 	int num_workers;
@@ -69,7 +72,10 @@ struct btrfs_workers {
 	/* max number of workers allowed.  changed by btrfs_start_workers */
 	int max_workers;
 
-	/* once a worker has this many requests or fewer, it is idle */
+	/*
+	 * once a worker has this many requests or fewer, it is idle.
+	 * default to BTRFS_WORKERS_IDLE_THRESH, which 32 is used currently.
+	 */
 	int idle_thresh;
 
 	/* force completions in the order they were queued */
-- 
1.7.1


