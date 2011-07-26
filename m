Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1GZPef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:34:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61533 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1GZPea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:34:30 -0400
From: Dave Reisner <d@falconindy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Reisner <dreisner@archlinux.org>
Subject: [PATCH] printk: add Kconfig for default console loglevel
Date: Tue, 26 Jul 2011 11:33:51 -0400
Message-Id: <1311694431-17037-1-git-send-email-dreisner@archlinux.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep the historical default of 7, but allow distributions and users to
tune this value instead of requiring a kernel cmdline parameter.

Signed-off-by: Dave Reisner <dreisner@archlinux.org>
---
 kernel/printk.c   |    4 +++-
 lib/Kconfig.debug |   10 ++++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 37dff34..fabc216 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -58,7 +58,9 @@ void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
 
 /* We show everything that is MORE important than this.. */
 #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
-#define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
+
+/* default to 7 -- anything MORE serious than KERN_DEBUG */
+#define DEFAULT_CONSOLE_LOGLEVEL CONFIG_DEFAULT_CONSOLE_LOGLEVEL
 
 DECLARE_WAIT_QUEUE_HEAD(log_wait);
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c0cb9c4..6caa66e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -21,6 +21,16 @@ config DEFAULT_MESSAGE_LOGLEVEL
 	  that are auditing their logs closely may want to set it to a lower
 	  priority.
 
+config DEFAULT_CONSOLE_LOGLEVEL
+	int "Default console log level (1-7)"
+	range 1 7
+	default "7"
+	help
+	  Default console log level setting for printk statements.
+
+	  This was hard-coded to KERN_INFO (7) since at least 2.6.12. You may
+	  wish to turn this down to 4 for a quieter console.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
-- 
1.7.6

