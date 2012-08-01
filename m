Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2HAEzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 00:55:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64111 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2HAEyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 00:54:51 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 3/5] Finish documentation of two structs in android/logger.c
Date: Wed,  1 Aug 2012 14:54:18 +1000
Message-Id: <1343796860-7025-4-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
References: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/android/logger.c |   40 +++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index f7b8237..1d5ed47 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -32,38 +32,50 @@
 
 #include <asm/ioctls.h>
 
-/*
+/**
  * struct logger_log - represents a specific log, such as 'main' or 'radio'
+ * @buffer:	The actual ring buffer
+ * @misc:	The "misc" device representing the log
+ * @wq:		The wait queue for @readers
+ * @readers:	This log's readers
+ * @mutex:	The mutex that protects the @buffer
+ * @w_off:	The current write head offset
+ * @head:	The head, or location that readers start reading at.
+ * @size:	The size of the log
+ * @logs:	The list of log channels
  *
  * This structure lives from module insertion until module removal, so it does
  * not need additional reference counting. The structure is protected by the
  * mutex 'mutex'.
  */
 struct logger_log {
-	unsigned char		*buffer;/* the ring buffer itself */
-	struct miscdevice	misc;	/* misc device representing the log */
-	wait_queue_head_t	wq;	/* wait queue for readers */
-	struct list_head	readers; /* this log's readers */
-	struct mutex		mutex;	/* mutex protecting buffer */
-	size_t			w_off;	/* current write head offset */
-	size_t			head;	/* new readers start here */
-	size_t			size;	/* size of the log */
-	struct list_head	logs;	/* list of log channels (myself)*/
+	unsigned char		*buffer;
+	struct miscdevice	misc;
+	wait_queue_head_t	wq;
+	struct list_head	readers;
+	struct mutex		mutex;
+	size_t			w_off;
+	size_t			head;
+	size_t			size;
+	struct list_head	logs;
 };
 
 static LIST_HEAD(log_list);
 
 
-/*
+/**
  * struct logger_reader - a logging device open for reading
+ * @log:	The associated log
+ * @list:	The associated entry in @logger_log's list
+ * @r_off:	The current read head offset.
  *
  * This object lives from open to release, so we don't need additional
  * reference counting. The structure is protected by log->mutex.
  */
 struct logger_reader {
-	struct logger_log	*log;	/* associated log */
-	struct list_head	list;	/* entry in logger_log's list */
-	size_t			r_off;	/* current read head offset */
+	struct logger_log	*log;
+	struct list_head	list;
+	size_t			r_off;
 };
 
 /* logger_offset - returns index 'n' into the log via (optimized) modulus */
-- 
1.7.9.5

