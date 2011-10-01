Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1JAIoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 04:44:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38025 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab1JAIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 04:44:16 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 1/3] staging: wlags49_h2: Use C99 __func__
Date: Sat,  1 Oct 2011 09:43:48 +0100
Message-Id: <1317458630-16033-2-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317458630-16033-1-git-send-email-kilroyd@googlemail.com>
References: <1317458630-16033-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in DBG machinery so you don't have to declare DBG_FUNC at
the start of all functions.

This just makes it easy to add DBG conforming to existing code.

The patch reformats the changed #defines to satisfy checkstyle.pl

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/debug.h     |   61 ++++++++++++++++++--------------
 drivers/staging/wlags49_h2/wl_netdev.c |    2 +-
 2 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/wlags49_h2/debug.h b/drivers/staging/wlags49_h2/debug.h
index 2c3dd14..8d5dddf 100644
--- a/drivers/staging/wlags49_h2/debug.h
+++ b/drivers/staging/wlags49_h2/debug.h
@@ -129,11 +129,15 @@
 #define _LEAVE_STR          "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
 
 
-#define _DBG_ENTER(A)       DBG_PRINT("%s:%.*s:%s\n", DBG_NAME(A), ++DBG_LEVEL(A), _ENTER_STR, __FUNC__)
-#define _DBG_LEAVE(A)       DBG_PRINT("%s:%.*s:%s\n", DBG_NAME(A), DBG_LEVEL(A)--, _LEAVE_STR, __FUNC__)
+#define _DBG_ENTER(A)						\
+	DBG_PRINT("%s:%.*s:%s\n", DBG_NAME(A), ++DBG_LEVEL(A),	\
+		  _ENTER_STR, __func__)
+#define _DBG_LEAVE(A)						\
+	DBG_PRINT("%s:%.*s:%s\n", DBG_NAME(A), DBG_LEVEL(A)--,	\
+		  _LEAVE_STR, __func__)
 
 
-#define DBG_FUNC(F)         static const char *__FUNC__ = F;
+#define DBG_FUNC(F)
 
 #define DBG_ENTER(A)        {if (DBG_FLAGS(A) & DBG_TRACE_ON) \
 				_DBG_ENTER(A); }
@@ -145,29 +149,33 @@
 				DBG_PRINT("  %s -- "F"\n", N, S); }
 
 
-#define DBG_ERROR(A, S...)   {if (DBG_FLAGS(A) & DBG_ERROR_ON) {\
-				DBG_PRINT("%s:ERROR:%s ", DBG_NAME(A), __FUNC__);\
-				DBG_PRINTC(S); \
-				DBG_TRAP; \
-				} \
-				}
+#define DBG_ERROR(A, S...) do {						\
+		if (DBG_FLAGS(A) & DBG_ERROR_ON) {			\
+			DBG_PRINT("%s:ERROR:%s ", DBG_NAME(A), __func__); \
+			DBG_PRINTC(S);					\
+			DBG_TRAP;					\
+		} } while (0)
 
 
-#define DBG_WARNING(A, S...) {if (DBG_FLAGS(A) & DBG_WARNING_ON) {\
-				DBG_PRINT("%s:WARNING:%s ", DBG_NAME(A), __FUNC__);\
-				DBG_PRINTC(S); } }
+#define DBG_WARNING(A, S...) do {					\
+		if (DBG_FLAGS(A) & DBG_WARNING_ON) {			\
+			DBG_PRINT("%s:WARNING:%s ", DBG_NAME(A), __func__); \
+			DBG_PRINTC(S);					\
+		} } while (0)
 
 
-#define DBG_NOTICE(A, S...)  {if (DBG_FLAGS(A) & DBG_NOTICE_ON) {\
-				DBG_PRINT("%s:NOTICE:%s ", DBG_NAME(A), __FUNC__);\
-				DBG_PRINTC(S); \
-				} \
-				}
+#define DBG_NOTICE(A, S...)  do {					\
+		if (DBG_FLAGS(A) & DBG_NOTICE_ON) {			\
+			DBG_PRINT("%s:NOTICE:%s ", DBG_NAME(A), __func__); \
+			DBG_PRINTC(S);					\
+		} } while (0)
 
 
-#define DBG_TRACE(A, S...)   do {if (DBG_FLAGS(A) & DBG_TRACE_ON) {\
-				DBG_PRINT("%s:%s ", DBG_NAME(A), __FUNC__);\
-				DBG_PRINTC(S); } } while (0)
+#define DBG_TRACE(A, S...)   do { \
+		if (DBG_FLAGS(A) & DBG_TRACE_ON) {			\
+			DBG_PRINT("%s:%s ", DBG_NAME(A), __func__);	\
+			DBG_PRINTC(S);					\
+		} } while (0)
 
 
 #define DBG_RX(A, S...)      {if (DBG_FLAGS(A) & DBG_RX_ON) {\
@@ -181,13 +189,12 @@
 				DBG_PRINT(S); } }
 
 
-#define DBG_ASSERT(C)		{ \
-				if (!(C)) {\
-					DBG_PRINT("ASSERT(%s) -- %s#%d (%s)\n", \
-					#C, __FILE__, __LINE__, __FUNC__); \
-					DBG_TRAP; \
-					} \
-					}
+#define DBG_ASSERT(C) do { \
+		if (!(C)) {						\
+			DBG_PRINT("ASSERT(%s) -- %s#%d (%s)\n",		\
+				  #C, __FILE__, __LINE__, __func__);	\
+			DBG_TRAP;					\
+		} } while (0)
 
 typedef struct {
     char           *dbgName;
diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index cf917e6..1c9d4d0 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -217,7 +217,7 @@ int wl_config( struct net_device *dev, struct ifmap *map )
 
     /* The only thing we care about here is a port change. Since this not needed,
        ignore the request. */
-    DBG_TRACE( DbgInfo, "%s: %s called.\n", dev->name, __FUNC__ );
+    DBG_TRACE(DbgInfo, "%s: %s called.\n", dev->name, __func__);
 
     DBG_LEAVE( DbgInfo );
     return 0;
-- 
1.7.4.1

