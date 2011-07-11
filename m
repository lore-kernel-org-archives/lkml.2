Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1GKHvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:51:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab1GKHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:27 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 07/21] dynamic_debug: return int from ddebug_change
Date: Mon, 11 Jul 2011 01:46:42 -0600
Message-Id: <1310370416-6322-8-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alter ddebug_change to return number of matches found for query/rule.
This lets caller know whether rule applied, and potentially what
to do next.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index bbee0aa..de2a679 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -102,8 +102,8 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
  * the user which ddebug's were changed, or whether none
  * were matched.
  */
-static void ddebug_change(const struct ddebug_query *query,
-			   unsigned int flags, unsigned int mask)
+static int ddebug_change(const struct ddebug_query *query,
+			unsigned int flags, unsigned int mask)
 {
 	int i;
 	struct ddebug_table *dt;
@@ -167,8 +167,7 @@ static void ddebug_change(const struct ddebug_query *query,
 	}
 	mutex_unlock(&ddebug_lock);
 
-	if (!nfound && verbose)
-		pr_info("no matches for query\n");
+	return nfound;
 }
 
 /*
@@ -420,6 +419,7 @@ static int ddebug_exec_query(char *query_string)
 #define MAXWORDS 9
 	int nwords;
 	char *words[MAXWORDS];
+	int nfound;
 
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
 	if (nwords <= 0)
@@ -430,7 +430,7 @@ static int ddebug_exec_query(char *query_string)
 		return -EINVAL;
 
 	/* actually go and implement the change */
-	ddebug_change(&query, flags, mask);
+	nfound = ddebug_change(&query, flags, mask);
 	return 0;
 }
 
-- 
1.7.4.1

