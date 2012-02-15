Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab2BOX6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:58:24 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39897 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756395Ab2BOX6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:58:22 -0500
From: Joe Perches <joe@perches.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] jffs2: Standardize JFFS_<LEVEL> uses
Date: Wed, 15 Feb 2012 15:56:46 -0800
Message-Id: <4a8fa8489f7fe7bc1e7b1e1ed77ed9a52c5f603c.1329349881.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1329349881.git.joe@perches.com>
References: <cover.1329349881.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_<level> to prefix KBUILD_MODNAME via pr_fmt.

Remove obfuscating defines and use constants in pr_<level>
No need for a do {} while (0) for single statements.

Form of JFFS_<LEVEL> output changes from
"JFFS2 notice: " to "jffs2: notice: "

Added pr_fmt to xattr.c

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/jffs2/debug.h |   46 +++++++++-------------------------------------
 fs/jffs2/xattr.c |    2 ++
 2 files changed, 11 insertions(+), 37 deletions(-)

diff --git a/fs/jffs2/debug.h b/fs/jffs2/debug.h
index 7782c63..b154797 100644
--- a/fs/jffs2/debug.h
+++ b/fs/jffs2/debug.h
@@ -69,50 +69,22 @@ do {						\
 		pr_debug(fmt, ##__VA_ARGS__);	\
 } while (0)
 
-/* The prefixes of JFFS2 messages */
-#define JFFS2_DBG_PREFIX	"[JFFS2 DBG]"
-#define JFFS2_ERR_PREFIX	"JFFS2 error:"
-#define JFFS2_WARN_PREFIX	"JFFS2 warning:"
-#define JFFS2_NOTICE_PREFIX	"JFFS2 notice:"
-
-#define JFFS2_ERR	KERN_ERR
-#define JFFS2_WARN	KERN_WARNING
-#define JFFS2_NOT	KERN_NOTICE
-#define JFFS2_DBG	KERN_DEBUG
-
-#define JFFS2_DBG_MSG_PREFIX	JFFS2_DBG JFFS2_DBG_PREFIX
-#define JFFS2_ERR_MSG_PREFIX	JFFS2_ERR JFFS2_ERR_PREFIX
-#define JFFS2_WARN_MSG_PREFIX	JFFS2_WARN JFFS2_WARN_PREFIX
-#define JFFS2_NOTICE_MSG_PREFIX	JFFS2_NOT JFFS2_NOTICE_PREFIX
-
 /* JFFS2 message macros */
-#define JFFS2_ERROR(fmt, ...)						\
-	do {								\
-		printk(JFFS2_ERR_MSG_PREFIX				\
-			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__func__ , ##__VA_ARGS__);			\
-	} while(0)
+#define JFFS2_ERROR(fmt, ...)					\
+	pr_err("error: (%d) %s: " fmt,				\
+	       task_pid_nr(current), __func__, ##__VA_ARGS__)
 
 #define JFFS2_WARNING(fmt, ...)						\
-	do {								\
-		printk(JFFS2_WARN_MSG_PREFIX				\
-			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__func__ , ##__VA_ARGS__);			\
-	} while(0)
+	pr_warn("warning: (%d) %s: " fmt,				\
+		task_pid_nr(current), __func__, ##__VA_ARGS__)
 
 #define JFFS2_NOTICE(fmt, ...)						\
-	do {								\
-		printk(JFFS2_NOTICE_MSG_PREFIX				\
-			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__func__ , ##__VA_ARGS__);			\
-	} while(0)
+	pr_notice("notice: (%d) %s: " fmt,				\
+		  task_pid_nr(current), __func__, ##__VA_ARGS__)
 
 #define JFFS2_DEBUG(fmt, ...)						\
-	do {								\
-		printk(JFFS2_DBG_MSG_PREFIX				\
-			" (%d) %s: " fmt, task_pid_nr(current),		\
-			__func__ , ##__VA_ARGS__);			\
-	} while(0)
+	printk(KERN_DEBUG "[JFFS2 DBG] (%d) %s: " fmt,			\
+	       task_pid_nr(current), __func__, ##__VA_ARGS__)
 
 /*
  * We split our debugging messages on several parts, depending on the JFFS2
diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index 3e93cdd..b55b803 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
-- 
1.7.8.111.gad25c.dirty

