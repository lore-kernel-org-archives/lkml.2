Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1FTFpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:45:33 -0400
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:57647
	"EHLO qmta10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab1FTFpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:30 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/22] staging: usbip: userspace: usbip_common.h: cleanup log macros
Date: Sun, 19 Jun 2011 22:44:32 -0700
Message-Id: <37fa05fa986bd518005e7af2475261395736ef46.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide better abstraction for easier modification, and align the
macros for readability. Remove notice() because it is not used.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   88 ++++++++++----------
 1 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 32b27ed..090b7c5 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -58,51 +58,49 @@ extern int usbip_use_syslog;
 extern int usbip_use_stderr;
 extern int usbip_use_debug ;
 
-#define err(fmt, args...)	do { \
-	if (usbip_use_syslog) { \
-		syslog(LOG_ERR, "usbip err: %13s:%4d (%-12s) " fmt "\n", \
-			__FILE__, __LINE__, __FUNCTION__,  ##args); \
-	} \
-	if (usbip_use_stderr) { \
-		fprintf(stderr, "usbip err: %13s:%4d (%-12s) " fmt "\n", \
-			__FILE__, __LINE__, __FUNCTION__,  ##args); \
-	} \
-} while (0)
-
-#define notice(fmt, args...)	do { \
-	if (usbip_use_syslog) { \
-		syslog(LOG_DEBUG, "usbip: " fmt, ##args); \
-	} \
-	if (usbip_use_stderr) { \
-		fprintf(stderr, "usbip: " fmt "\n",  ##args); \
-	} \
-} while (0)
-
-#define info(fmt, args...)	do { \
-	if (usbip_use_syslog) { \
-		syslog(LOG_DEBUG, fmt, ##args); \
-	} \
-	if (usbip_use_stderr) { \
-		fprintf(stderr, fmt "\n",  ##args); \
-	} \
-} while (0)
-
-#define dbg(fmt, args...)	do { \
-	if (usbip_use_debug) { \
-		if (usbip_use_syslog) { \
-			syslog(LOG_DEBUG, "usbip dbg: %13s:%4d (%-12s) " fmt, \
-				__FILE__, __LINE__, __FUNCTION__,  ##args); \
-		} \
-		if (usbip_use_stderr) { \
-			fprintf(stderr, "usbip dbg: %13s:%4d (%-12s) " fmt "\n", \
-				__FILE__, __LINE__, __FUNCTION__,  ##args); \
-		} \
-	} \
-} while (0)
-
-
-#define BUG()	do { err("sorry, it's a bug"); abort(); } while (0)
-
+#define PROGNAME "usbip"
+
+#define pr_fmt(fmt)	"%s: %s: " fmt "\n", PROGNAME
+#define dbg_fmt(fmt)	pr_fmt("%s:%d:[%s] " fmt), "debug",	\
+		        __FILE__, __LINE__, __FUNCTION__
+
+#define err(fmt, args...)						\
+	do {								\
+		if (usbip_use_syslog) {					\
+			syslog(LOG_ERR, pr_fmt(fmt), "error", ##args);	\
+		}							\
+		if (usbip_use_stderr) {					\
+			fprintf(stderr, pr_fmt(fmt), "error", ##args);	\
+		}							\
+	} while (0)
+
+#define info(fmt, args...)						\
+	do {								\
+		if (usbip_use_syslog) {					\
+			syslog(LOG_INFO, pr_fmt(fmt), "info", ##args);	\
+		}							\
+		if (usbip_use_stderr) {					\
+			fprintf(stderr, pr_fmt(fmt), "info", ##args);	\
+		}							\
+	} while (0)
+
+#define dbg(fmt, args...)						\
+	do {								\
+	if (usbip_use_debug) {						\
+		if (usbip_use_syslog) {					\
+			syslog(LOG_DEBUG, dbg_fmt(fmt), ##args);	\
+		}							\
+		if (usbip_use_stderr) {					\
+			fprintf(stderr, dbg_fmt(fmt), ##args);		\
+		}							\
+	}								\
+	} while (0)
+
+#define BUG()						\
+	do {						\
+		err("sorry, it's a bug!");		\
+		abort();				\
+	} while (0)
 
 struct usbip_usb_interface {
 	uint8_t bInterfaceClass;
-- 
1.7.5.2

