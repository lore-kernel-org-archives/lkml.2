Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab2IRXhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:37:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33643 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2IRXhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:37:19 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 6/6] dyndbg: change varname verbose_bytes to bytes_used
Date: Tue, 18 Sep 2012 17:36:47 -0600
Message-Id: <1348011407-24108-7-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
References: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New name reflects purpose (count bytes used), verbose is just print
condition, and counting proceeds either way.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index f1f7467..c787d1d 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -1033,7 +1033,7 @@ static int __init dynamic_debug_init(void)
 	char *cmdline;
 	int ret = 0;
 	int n = 0, entries = 0, modct = 0;
-	int verbose_bytes = 0;
+	int bytes_used = 0;
 
 	if (__start___verbose == __stop___verbose) {
 		pr_warn("_ddebug table is empty in a "
@@ -1045,7 +1045,7 @@ static int __init dynamic_debug_init(void)
 	iter_start = iter;
 	for (; iter < __stop___verbose; iter++) {
 		entries++;
-		verbose_bytes += strlen(iter->modname) + strlen(iter->function)
+		bytes_used += strlen(iter->modname) + strlen(iter->function)
 			+ strlen(iter->filename) + strlen(iter->format);
 
 		if (strcmp(modname, iter->modname)) {
@@ -1067,7 +1067,7 @@ static int __init dynamic_debug_init(void)
 	vpr_info("%d modules, %d entries and %d bytes in ddebug tables,"
 		" %d bytes in (readonly) verbose section\n",
 		modct, entries, (int)( modct * sizeof(struct ddebug_table)),
-		verbose_bytes + (int)(__stop___verbose - __start___verbose));
+		bytes_used + (int)(__stop___verbose - __start___verbose));
 
 	/* apply ddebug_query boot param, dont unload tables on err */
 	if (ddebug_setup_string[0] != '\0') {
-- 
1.7.11.4

