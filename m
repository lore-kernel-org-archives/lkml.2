Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab2CYX10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:27:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64965 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385Ab2CYX0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:33 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 16/16] dynamic_debug: drop deprecated ddebug_query param, code
Date: Sun, 25 Mar 2012 17:25:54 -0600
Message-Id: <1332717954-5775-17-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
References: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

DONT APPLY NOW.  for v3.6 or v3.7 timeframe.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |    7 +++----
 lib/dynamic_debug.c                   |   26 --------------------------
 2 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 6129505..86fb2a4 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -214,10 +214,9 @@ Debug messages during Boot Process
 
 To activate debug messages for core code and built-in modules during
 the boot process, even before userspace and debugfs exists, use
-dyndbg="QUERY", module.dyndbg="QUERY", or ddebug_query="QUERY"
-(ddebug_query is obsoleted by dyndbg, and deprecated).  QUERY follows
-the syntax described above, but must not exceed 1023 characters.  Your
-bootloader may impose lower limits.
+dyndbg="QUERY", module.dyndbg="QUERY".  QUERY follows the syntax
+described above, but must not exceed 1023 characters.  Your bootloader
+may impose lower limits.
 
 These dyndbg params are processed just after the ddebug tables are
 processed, as part of the arch_initcall.  Thus you can enable debug
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index f7ba216..7b0944e 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -614,21 +614,6 @@ EXPORT_SYMBOL(__dynamic_netdev_dbg);
 
 #endif
 
-#define DDEBUG_STRING_SIZE 1024
-static __initdata char ddebug_setup_string[DDEBUG_STRING_SIZE];
-
-static __init int ddebug_setup_query(char *str)
-{
-	if (strlen(str) >= DDEBUG_STRING_SIZE) {
-		pr_warn("ddebug boot param string too large\n");
-		return 0;
-	}
-	strlcpy(ddebug_setup_string, str, DDEBUG_STRING_SIZE);
-	return 1;
-}
-
-__setup("dyndbg=", ddebug_setup_query);
-
 /*
  * File_ops->write method for <debugfs>/dynamic_debug/conrol.  Gathers the
  * command text from userspace, parses and executes it.
@@ -1007,17 +992,6 @@ static int __init dynamic_debug_init(void)
 		modct, entries, modct * sizeof(struct ddebug_table)
 		+ __stop___verbose - __start___verbose);
 
-	/* apply ddebug_query boot param, dont unload tables on err */
-	if (ddebug_setup_string[0] != '\0') {
-		pr_warn("ddebug_query param name is deprecated,"
-			" change it to dyndbg\n");
-		ret = ddebug_exec_queries(ddebug_setup_string);
-		if (ret < 0)
-			pr_warn("Invalid ddebug boot param %s",
-				ddebug_setup_string);
-		else
-			pr_info("%d changes by ddebug_query\n", ret);
-	}
 	/* now that ddebug tables are loaded, process all boot args
 	 * again to find and activate queries given in dyndbg params.
 	 * While this has already been done for known boot params, it
-- 
1.7.7.6

