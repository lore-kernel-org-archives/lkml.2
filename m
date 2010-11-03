Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0KCP3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:29:10 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:50823 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab0KCP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:29:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 1/3] console: move for_each_console to linux/console.h
Date: Wed,  3 Nov 2010 16:28:32 +0100
Message-Id: <1288798114-23206-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it out of printk.c so that we can use it all over the code. There
are some potential users which will be converted to that macro in next
patches.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/console.h |    6 ++++++
 kernel/printk.c         |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/console.h b/include/linux/console.h
index 95cf6f0..875cfb1 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -126,6 +126,12 @@ struct console {
 	struct	 console *next;
 };
 
+/*
+ * for_each_console() allows you to iterate on each console
+ */
+#define for_each_console(con) \
+	for (con = console_drivers; con != NULL; con = con->next)
+
 extern int console_set_on_cmdline;
 
 extern int add_preferred_console(char *name, int idx, char *options);
diff --git a/kernel/printk.c b/kernel/printk.c
index b2ebaee..bf0420a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -43,12 +43,6 @@
 #include <asm/uaccess.h>
 
 /*
- * for_each_console() allows you to iterate on each console
- */
-#define for_each_console(con) \
-	for (con = console_drivers; con != NULL; con = con->next)
-
-/*
  * Architectures can override it:
  */
 void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
-- 
1.7.3.1


