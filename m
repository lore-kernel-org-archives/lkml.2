Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab2CYX0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:26:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61995 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab2CYX0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:14 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 01/16] init: trivial tweaks to initcall_levels
Date: Sun, 25 Mar 2012 17:25:39 -0600
Message-Id: <1332717954-5775-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
References: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

add a pr_info to print current level and level_name of initcall,
and number of registered initcalls at that level.  This adds 7
lines to dmesg output, like:
   initlevel:6=device, 172 registered initcalls

Drop "parameters" from initcall_level_names[], it can be added
back in the printk where it clarifies things.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 init/main.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/init/main.c b/init/main.c
index 4397158..09f3105 100644
--- a/init/main.c
+++ b/init/main.c
@@ -723,14 +723,14 @@ static initcall_t *initcall_levels[] __initdata = {
 };
 
 static char *initcall_level_names[] __initdata = {
-	"early parameters",
-	"core parameters",
-	"postcore parameters",
-	"arch parameters",
-	"subsys parameters",
-	"fs parameters",
-	"device parameters",
-	"late parameters",
+	"early",
+	"core",
+	"postcore",
+	"arch",
+	"subsys",
+	"fs",
+	"device",
+	"late",
 };
 
 static int __init ignore_unknown_bootoption(char *param, char *val)
@@ -748,7 +748,7 @@ static void __init do_initcall_level(int level)
 		   static_command_line, __start___param,
 		   __stop___param - __start___param,
 		   level, level,
-		   ignore_unknown_bootoption);
+		   &ignore_unknown_bootoption);
 
 	for (fn = initcall_levels[level]; fn < initcall_levels[level+1]; fn++)
 		do_one_initcall(*fn);
@@ -758,8 +758,13 @@ static void __init do_initcalls(void)
 {
 	int level;
 
-	for (level = 0; level < ARRAY_SIZE(initcall_levels) - 1; level++)
+	for (level = 0; level < ARRAY_SIZE(initcall_levels) - 1; level++) {
+		pr_info("initlevel:%d=%s, %d registered initcalls\n",
+			level, initcall_level_names[level],
+			(int) (initcall_levels[level+1]
+				- initcall_levels[level]));
 		do_initcall_level(level);
+	}
 }
 
 /*
-- 
1.7.7.6

