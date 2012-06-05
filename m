Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628Ab2FEJrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:47:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39882 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753536Ab2FEJrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:47:08 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Subject: [PATCH 2/8] printk: Add kern_levels.h to make KERN_<LEVEL> available for asm use
Date: Tue,  5 Jun 2012 02:46:31 -0700
Message-Id: <75e80acc2f5fb5b779f03ee44ec2e1331daeede6.1338889066.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1338889066.git.joe@perches.com>
References: <cover.1338889066.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the printk.h file into 2 pieces so the definitions
can be used in asm files.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kern_levels.h |   22 ++++++++++++++++++++++
 include/linux/printk.h      |   19 +------------------
 2 files changed, 23 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/kern_levels.h

diff --git a/include/linux/kern_levels.h b/include/linux/kern_levels.h
new file mode 100644
index 0000000..337e56f
--- /dev/null
+++ b/include/linux/kern_levels.h
@@ -0,0 +1,22 @@
+#ifndef __KERN_LEVELS_H__
+#define __KERN_LEVELS_H__
+
+#define KERN_EMERG	"<0>"	/* system is unusable			*/
+#define KERN_ALERT	"<1>"	/* action must be taken immediately	*/
+#define KERN_CRIT	"<2>"	/* critical conditions			*/
+#define KERN_ERR	"<3>"	/* error conditions			*/
+#define KERN_WARNING	"<4>"	/* warning conditions			*/
+#define KERN_NOTICE	"<5>"	/* normal but significant condition	*/
+#define KERN_INFO	"<6>"	/* informational			*/
+#define KERN_DEBUG	"<7>"	/* debug-level messages			*/
+
+/* Use the default kernel loglevel */
+#define KERN_DEFAULT	"<d>"
+/*
+ * Annotation for a "continued" line of log printout (only done after a
+ * line that had no enclosing \n). Only to be used by core/arch code
+ * during early bootup (a continued line is not SMP-safe otherwise).
+ */
+#define KERN_CONT	"<c>"
+
+#endif
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 6e12e1f..fea2de3 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -2,28 +2,11 @@
 #define __KERNEL_PRINTK__
 
 #include <linux/init.h>
+#include <linux/kern_levels.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
-#define KERN_EMERG	"<0>"	/* system is unusable			*/
-#define KERN_ALERT	"<1>"	/* action must be taken immediately	*/
-#define KERN_CRIT	"<2>"	/* critical conditions			*/
-#define KERN_ERR	"<3>"	/* error conditions			*/
-#define KERN_WARNING	"<4>"	/* warning conditions			*/
-#define KERN_NOTICE	"<5>"	/* normal but significant condition	*/
-#define KERN_INFO	"<6>"	/* informational			*/
-#define KERN_DEBUG	"<7>"	/* debug-level messages			*/
-
-/* Use the default kernel loglevel */
-#define KERN_DEFAULT	"<d>"
-/*
- * Annotation for a "continued" line of log printout (only done after a
- * line that had no enclosing \n). Only to be used by core/arch code
- * during early bootup (a continued line is not SMP-safe otherwise).
- */
-#define KERN_CONT	"<c>"
-
 static inline int printk_get_level(const char *buffer)
 {
 	if (buffer[0] == '<' && buffer[1] && buffer[2] == '>') {
-- 
1.7.8.111.gad25c.dirty

