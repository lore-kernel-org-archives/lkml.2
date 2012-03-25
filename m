Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2CYX1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:27:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64965 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab2CYX0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:23 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 08/16] dynamic_debug: deprecate ddebug_query, suggest dyndbg instead
Date: Sun, 25 Mar 2012 17:25:46 -0600
Message-Id: <1332717954-5775-9-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
References: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Deprecate ddebug_query= in feature-removal-schedule.txt.  Add a
warning when processing ddebug_query= param to change it to dyndbg=.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/feature-removal-schedule.txt |    9 ++++++++-
 lib/dynamic_debug.c                        |    2 ++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0cad480..e926daf 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -2,7 +2,14 @@ The following is a list of files and features that are going to be
 removed in the kernel source tree.  Every entry should contain what
 exactly is going away, why it is happening, and who is going to be doing
 the work.  When the feature is removed from the kernel, it should also
-be removed from this file.
+be removed from this file.  The default deprecation period is 2-3 releases.
+
+---------------------------
+
+What:	ddebug_query="query" cmdline param
+When:	v3.6
+Why:	obsoleted by dyndbg="query" and module.dyndbg="query"
+Who:	Jim Cromie <jim.cromie@gmail.com>, Jason Baron <jbaron@redhat.com>
 
 ---------------------------
 
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 32e7c52..a3ab3bd 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -993,6 +993,8 @@ static int __init dynamic_debug_init(void)
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
+		pr_warn("ddebug_query param name is deprecated,"
+			" change it to dyndbg\n");
 		ret = ddebug_exec_queries(ddebug_setup_string);
 		if (ret < 0)
 			pr_warn("Invalid ddebug boot param %s",
-- 
1.7.7.6

