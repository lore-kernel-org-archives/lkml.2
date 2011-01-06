Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1AFWXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:23:40 -0500
Received: from kroah.org ([198.145.64.141]:55629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab1AFWXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:38 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/36] console: move for_each_console to linux/console.h
Date: Thu,  6 Jan 2011 14:22:57 -0800
Message-Id: <1294352605-31906-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

Move it out of printk.c so that we can use it all over the code. There
are some potential users which will be converted to that macro in next
patches.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.3.2

