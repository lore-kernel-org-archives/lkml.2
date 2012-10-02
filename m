Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab2JBLy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:54:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41822 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2JBLy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:54:56 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 3/3] Fix line over 80 character issue and space before tabs issue in trace.h
Date: Tue,  2 Oct 2012 20:54:48 +0900
Message-Id: <1349178888-29716-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
References: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed some checkpatch warnings.

-WARNING: line over 80 characters
-WARNING: please, no space before tabs

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/trace.h |   62 ++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
index a34493c..fdc48cc 100644
--- a/drivers/staging/rts_pstor/trace.h
+++ b/drivers/staging/rts_pstor/trace.h
@@ -46,36 +46,42 @@ static inline char *filename(char *path)
 	return path;
 }
 
-#define TRACE_RET(chip, ret)   										\
-do {													\
-	char *_file = filename(__FILE__);								\
-	RTSX_DEBUGP("[%s][%s]:[%d]\n", _file, __func__, __LINE__);					\
-	(chip)->trace_msg[(chip)->msg_idx].line = (u16)(__LINE__);					\
-	strncpy((chip)->trace_msg[(chip)->msg_idx].func, __func__, MSG_FUNC_LEN-1);			\
-	strncpy((chip)->trace_msg[(chip)->msg_idx].file, _file, MSG_FILE_LEN-1); 			\
-	get_current_time((chip)->trace_msg[(chip)->msg_idx].timeval_buf, TIME_VAL_LEN);			\
-	(chip)->trace_msg[(chip)->msg_idx].valid = 1;							\
-	(chip)->msg_idx++; 										\
-	if ((chip)->msg_idx >= TRACE_ITEM_CNT) { 							\
-		(chip)->msg_idx = 0;									\
-	}												\
-	return ret; 											\
+#define TRACE_RET(chip, ret) \
+do { \
+	char *_file = filename(__FILE__); \
+	RTSX_DEBUGP("[%s][%s]:[%d]\n", _file, __func__, __LINE__); \
+	(chip)->trace_msg[(chip)->msg_idx].line = (u16)(__LINE__); \
+	strncpy((chip)->trace_msg[(chip)->msg_idx].func, \
+		__func__, MSG_FUNC_LEN-1); \
+	strncpy((chip)->trace_msg[(chip)->msg_idx].file, \
+		_file, MSG_FILE_LEN-1); \
+	get_current_time((chip)->trace_msg[(chip)->msg_idx].timeval_buf, \
+			 TIME_VAL_LEN); \
+	(chip)->trace_msg[(chip)->msg_idx].valid = 1; \
+	(chip)->msg_idx++; \
+	if ((chip)->msg_idx >= TRACE_ITEM_CNT) { \
+		(chip)->msg_idx = 0; \
+	} \
+	return ret; \
 } while (0)
 
-#define TRACE_GOTO(chip, label)   									\
-do {													\
-	char *_file = filename(__FILE__);								\
-	RTSX_DEBUGP("[%s][%s]:[%d]\n", _file, __func__, __LINE__);					\
-	(chip)->trace_msg[(chip)->msg_idx].line = (u16)(__LINE__);					\
-	strncpy((chip)->trace_msg[(chip)->msg_idx].func, __func__, MSG_FUNC_LEN-1);			\
-	strncpy((chip)->trace_msg[(chip)->msg_idx].file, _file, MSG_FILE_LEN-1); 			\
-	get_current_time((chip)->trace_msg[(chip)->msg_idx].timeval_buf, TIME_VAL_LEN);			\
-	(chip)->trace_msg[(chip)->msg_idx].valid = 1;							\
-	(chip)->msg_idx++; 										\
-	if ((chip)->msg_idx >= TRACE_ITEM_CNT) { 							\
-		(chip)->msg_idx = 0;									\
-	}												\
-	goto label; 											\
+#define TRACE_GOTO(chip, label) \
+do { \
+	char *_file = filename(__FILE__); \
+	RTSX_DEBUGP("[%s][%s]:[%d]\n", _file, __func__, __LINE__); \
+	(chip)->trace_msg[(chip)->msg_idx].line = (u16)(__LINE__); \
+	strncpy((chip)->trace_msg[(chip)->msg_idx].func, \
+		__func__, MSG_FUNC_LEN-1); \
+	strncpy((chip)->trace_msg[(chip)->msg_idx].file, \
+		_file, MSG_FILE_LEN-1); \
+	get_current_time((chip)->trace_msg[(chip)->msg_idx].timeval_buf, \
+			 TIME_VAL_LEN); \
+	(chip)->trace_msg[(chip)->msg_idx].valid = 1; \
+	(chip)->msg_idx++; \
+	if ((chip)->msg_idx >= TRACE_ITEM_CNT) { \
+		(chip)->msg_idx = 0; \
+	} \
+	goto label; \
 } while (0)
 #else
 #define TRACE_RET(chip, ret)	return(ret)
-- 
1.7.9.5

