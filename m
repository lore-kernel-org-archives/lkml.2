Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1LSWLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:11:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1LSWLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:11:15 -0500
Date: Mon, 19 Dec 2011 17:11:09 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <fdac89c3d2f0a1aa49591afdde2c9dddcc6c33d7.1324318997.git.jbaron@redhat.com>
In-Reply-To: <cover.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 01/16] dynamic_debug: fix whitespace complaints from scripts/cleanfile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Style cleanups.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
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

