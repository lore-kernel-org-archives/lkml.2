Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab2HAEy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 00:54:56 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47862 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2HAEys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 00:54:48 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 2/5] Complete documentation of logger_entry in android/logger.h
Date: Wed,  1 Aug 2012 14:54:17 +1000
Message-Id: <1343796860-7025-3-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
References: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, there were simply comments after each part - Now, it is completed properly according to "Kernel doc"
Sorry in advance if I made any mistakes.

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/android/logger.h |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/logger.h b/drivers/staging/android/logger.h
index 2cb06e9..9b929a8 100644
--- a/drivers/staging/android/logger.h
+++ b/drivers/staging/android/logger.h
@@ -20,14 +20,24 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
+/**
+ * struct logger_entry - defines a single entry that is given to a logger
+ * @len:	The length of the payload
+ * @__pad:	Two bytes of padding that appear to be required
+ * @pid:	The generating process' process ID
+ * @tid:	The generating process' thread ID
+ * @sec:	The number of seconds that have elapsed since the Epoch
+ * @nsec:	The number of nanoseconds that have elapsed since @sec
+ * @msg:	The message that is to be logged
+ */
 struct logger_entry {
-	__u16		len;	/* length of the payload */
-	__u16		__pad;	/* no matter what, we get 2 bytes of padding */
-	__s32		pid;	/* generating process's pid */
-	__s32		tid;	/* generating process's tid */
-	__s32		sec;	/* seconds since Epoch */
-	__s32		nsec;	/* nanoseconds */
-	char		msg[0];	/* the entry's payload */
+	__u16		len;
+	__u16		__pad;
+	__s32		pid;
+	__s32		tid;
+	__s32		sec;
+	__s32		nsec;
+	char		msg[0];
 };
 
 #define LOGGER_LOG_RADIO	"log_radio"	/* radio-related messages */
-- 
1.7.9.5

