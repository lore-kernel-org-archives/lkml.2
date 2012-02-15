Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456Ab2BOCVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 21:21:52 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56610 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2BOCVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 21:21:50 -0500
From: Jorgyano Vieira <jorgyano@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Jorgyano Vieira <jorgyano@gmail.com>
Subject: [PATCH] Staging: crystalhd: crystalhd_misc: improved debug macros
Date: Wed, 15 Feb 2012 00:20:06 -0200
Message-Id: <1329272406-26198-1-git-send-email-jorgyano@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improvement of debug macros to ensure safe use on if/else statements.

Signed-off-by: Jorgyano Vieira <jorgyano@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_misc.h |   46 +++++++++++++++-------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_misc.h b/drivers/staging/crystalhd/crystalhd_misc.h
index 4d61723..e0aa361 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.h
+++ b/drivers/staging/crystalhd/crystalhd_misc.h
@@ -203,26 +203,30 @@ enum _chd_log_levels {
 	BCMLOG_ENTER_LEAVE	= 0x00000008,	/* stack tracking */
 };
 
-#define BCMLOG_ENTER				\
-if (g_linklog_level & BCMLOG_ENTER_LEAVE) {	\
-	printk(KERN_DEBUG "Entered %s\n", __func__);	\
-}
-
-#define BCMLOG_LEAVE				\
-if (g_linklog_level & BCMLOG_ENTER_LEAVE) {	\
-	printk(KERN_DEBUG "Leaving %s\n", __func__);	\
-}
-
-#define BCMLOG(trace, fmt, args...)		\
-if (g_linklog_level & trace) {			\
-	printk(fmt, ##args);			\
-}
-
-#define BCMLOG_ERR(fmt, args...)					\
-do {									\
-	if (g_linklog_level & BCMLOG_ERROR) {				\
-		printk(KERN_ERR "*ERR*:%s:%d: "fmt, __FILE__, __LINE__, ##args);	\
-	}								\
-} while (0);
+#define BCMLOG_ENTER						\
+do {								\
+	if (g_linklog_level & BCMLOG_ENTER_LEAVE)		\
+		printk(KERN_DEBUG "Entered %s\n", __func__);	\
+} while (0)
+
+#define BCMLOG_LEAVE						\
+do {								\
+	if (g_linklog_level & BCMLOG_ENTER_LEAVE)		\
+		printk(KERN_DEBUG "Leaving %s\n", __func__);	\
+} while (0)							\
+
+#define BCMLOG(trace, fmt, args...)	\
+do {					\
+	if (g_linklog_level & trace)	\
+		printk(fmt, ##args);	\
+} while (0)
+
+
+#define BCMLOG_ERR(fmt, args...)				\
+do {								\
+	if (g_linklog_level & BCMLOG_ERROR)			\
+		printk(KERN_ERR "*ERR*:%s:%d: "fmt,		\
+				__FILE__, __LINE__, ##args);	\
+} while (0)
 
 #endif
-- 
1.7.2.5

