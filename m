Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab2GSTrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:47:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41788 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2GSTqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:46:52 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: kay@vrfy.com, joe@perches.com, greg@kroah.com,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 3/3] dyndbg: change varname verbose_bytes to sz_used
Date: Thu, 19 Jul 2012 13:46:23 -0600
Message-Id: <1342727183-4520-5-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342727183-4520-1-git-send-email-jim.cromie@gmail.com>
References: <1342727183-4520-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New name reflects purpose (count mem used), verbose is just print
condition, and bytes is too generic.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 6bc34aa..0cc715c 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -978,7 +978,7 @@ static int __init dynamic_debug_init(void)
 	char *cmdline;
 	int ret = 0;
 	int n = 0, entries = 0, modct = 0;
-	int verbose_bytes = 0;
+	int sz_used = 0;
 
 	if (__start___verbose == __stop___verbose) {
 		pr_warn("_ddebug table is empty in a "
@@ -990,7 +990,7 @@ static int __init dynamic_debug_init(void)
 	iter_start = iter;
 	for (; iter < __stop___verbose; iter++) {
 		entries++;
-		verbose_bytes += strlen(iter->modname) + strlen(iter->function)
+		sz_used += strlen(iter->modname) + strlen(iter->function)
 			+ strlen(iter->filename) + strlen(iter->format);
 
 		if (strcmp(modname, iter->modname)) {
@@ -1012,7 +1012,7 @@ static int __init dynamic_debug_init(void)
 	vpr_info("%d modules, %d entries and %d bytes in ddebug tables,"
 		" %d bytes in (readonly) verbose section\n",
 		modct, entries, (int)( modct * sizeof(struct ddebug_table)),
-		verbose_bytes + (int)(__stop___verbose - __start___verbose));
+		sz_used + (int)(__stop___verbose - __start___verbose));
 
 	/* apply ddebug_query boot param, dont unload tables on err */
 	if (ddebug_setup_string[0] != '\0') {
-- 
1.7.10.4

