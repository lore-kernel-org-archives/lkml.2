Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1LFTS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:18:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45409 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1LFTMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:10 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 02/25] dynamic_debug: fix whitespace complaints from scripts/cleanfile
Date: Tue,  6 Dec 2011 12:11:12 -0700
Message-Id: <1323198694-7186-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>


Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index dcdade3..e487d13 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -187,7 +187,7 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 		if (!*buf)
 			break;	/* oh, it was trailing whitespace */
 
-		/* Run `end' over a word, either whitespace separated or quoted */
+		/* find `end' of word, whitespace separated or quoted */
 		if (*buf == '"' || *buf == '\'') {
 			int quote = *buf++;
 			for (end = buf ; *end && *end != quote ; end++)
@@ -199,8 +199,8 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 				;
 			BUG_ON(end == buf);
 		}
-		/* Here `buf' is the start of the word, `end' is one past the end */
 
+		/* `buf' is start of word, `end' is one past its end */
 		if (nwords == maxwords)
 			return -EINVAL;	/* ran out of words[] before bytes */
 		if (*end)
@@ -452,7 +452,8 @@ static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
 		pos += snprintf(buf + pos, remaining(pos), "%s:",
 					desc->function);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		pos += snprintf(buf + pos, remaining(pos), "%d:", desc->lineno);
+		pos += snprintf(buf + pos, remaining(pos), "%d:",
+					desc->lineno);
 	if (pos - pos_after_tid)
 		pos += snprintf(buf + pos, remaining(pos), " ");
 	if (pos >= PREFIX_SIZE)
@@ -708,10 +709,11 @@ static const struct seq_operations ddebug_proc_seqops = {
 };
 
 /*
- * File_ops->open method for <debugfs>/dynamic_debug/control.  Does the seq_file
- * setup dance, and also creates an iterator to walk the _ddebugs.
- * Note that we create a seq_file always, even for O_WRONLY files
- * where it's not needed, as doing so simplifies the ->release method.
+ * File_ops->open method for <debugfs>/dynamic_debug/control.  Does
+ * the seq_file setup dance, and also creates an iterator to walk the
+ * _ddebugs.  Note that we create a seq_file always, even for O_WRONLY
+ * files where it's not needed, as doing so simplifies the ->release
+ * method.
  */
 static int ddebug_proc_open(struct inode *inode, struct file *file)
 {
-- 
1.7.7.3

