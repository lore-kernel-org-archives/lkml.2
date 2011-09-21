Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab1IUV6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:58:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37563 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1IUV4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:36 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 20/26] dynamic_debug: make ddebug_describe_flags more generic
Date: Wed, 21 Sep 2011 15:55:09 -0600
Message-Id: <1316642115-20029-21-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Alter fn-sig to accept flags arg directly, instead of a ptr to
structure containing it.  This lets us reuse it for pending-queries.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 3c9244d..d7b71a6 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -103,7 +103,7 @@ static struct { unsigned flag:8; char opt_char; } opt_array[] = {
 };
 
 /* format a string into buf[] which describes the _ddebug's flags */
-static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
+static char *ddebug_describe_flags(unsigned int flags, char *buf,
 				    size_t maxlen)
 {
 	char *p = buf;
@@ -112,7 +112,7 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	BUG_ON(maxlen < 10);
 	*p++ = '=';
 	for (i = 0; i < ARRAY_SIZE(opt_array); ++i)
-		if (dp->flags & opt_array[i].flag)
+		if (flags & opt_array[i].flag)
 			*p++ = opt_array[i].opt_char;
 	if (*(p-1) == '=')
 		*p++ = '_';
@@ -227,7 +227,8 @@ static int ddebug_change(const struct ddebug_query *query,
 				pr_info("changed %s:%d [%s]%s %s\n",
 					trim_prefix(dp->filename), dp->lineno,
 					dt->mod_name, dp->function,
-					ddebug_describe_flags(dp, flagbuf,
+					ddebug_describe_flags(dp->flags,
+							flagbuf,
 							sizeof(flagbuf)));
 		}
 	}
@@ -901,7 +902,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	seq_printf(m, "%s:%u [%s]%s %s \"",
 		trim_prefix(dp->filename), dp->lineno,
 		iter->table->mod_name, dp->function,
-		ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
+		ddebug_describe_flags(dp->flags, flagsbuf, sizeof(flagsbuf)));
 	seq_escape(m, dp->format, "\t\r\n\"");
 	seq_puts(m, "\"\n");
 
-- 
1.7.4.4

