Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2JQGHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:07:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42765 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753397Ab2JQGG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:06:58 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 02/23] printk: Add console_cmdline.h
Date: Tue, 16 Oct 2012 23:06:06 -0700
Message-Id: <8a309539d5165dd2c70c1350de8e2f13fb606cb4.1350449851.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an include file for the console_cmdline struct
so that the braille console driver can be separated.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/console_cmdline.h |   14 ++++++++++++++
 kernel/printk/printk.c          |   13 ++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)
 create mode 100644 kernel/printk/console_cmdline.h

diff --git a/kernel/printk/console_cmdline.h b/kernel/printk/console_cmdline.h
new file mode 100644
index 0000000..cbd69d8
--- /dev/null
+++ b/kernel/printk/console_cmdline.h
@@ -0,0 +1,14 @@
+#ifndef _CONSOLE_CMDLINE_H
+#define _CONSOLE_CMDLINE_H
+
+struct console_cmdline
+{
+	char	name[8];			/* Name of the driver	    */
+	int	index;				/* Minor dev. to use	    */
+	char	*options;			/* Options for the driver   */
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	char	*brl_options;			/* Options for braille driver */
+#endif
+};
+
+#endif
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1950ecf..50ef6af 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -46,6 +46,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
+#include "console_cmdline.h"
+
 /*
  * Architectures can override it:
  */
@@ -100,22 +102,15 @@ static int console_locked, console_suspended;
  */
 static struct console *exclusive_console;
 
+
 /*
  *	Array of consoles built from command line options (console=)
  */
-struct console_cmdline
-{
-	char	name[8];			/* Name of the driver	    */
-	int	index;				/* Minor dev. to use	    */
-	char	*options;			/* Options for the driver   */
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	char	*brl_options;			/* Options for braille driver */
-#endif
-};
 
 #define MAX_CMDLINECONSOLES 8
 
 static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
+
 static int selected_console = -1;
 static int preferred_console = -1;
 int console_set_on_cmdline;
-- 
1.7.10.4

