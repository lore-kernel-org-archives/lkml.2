Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1IUV41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41179 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab1IUV4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:24 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 15/26] dynamic_debug: drop explicit foo != NULL checks.
Date: Wed, 21 Sep 2011 15:55:04 -0600
Message-Id: <1316642115-20029-16-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Reduce != NULL relational tests to their 0/1 equivalents.
Done separately to preserve code-move character of previous patch.
No generated code difference.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 329e18d..4c8e178 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -129,20 +129,18 @@ static bool query_matches_callsite(struct _ddebug *dp,
 				const struct ddebug_query *query)
 {
 	/* match against the source filename */
-	if (query->filename != NULL &&
+	if (query->filename &&
 		strcmp(query->filename, dp->filename) &&
 		strcmp(query->filename, basename(dp->filename)) &&
 		strcmp(query->filename, trim_prefix(dp->filename)))
 		return false;
 
 	/* match against the function */
-	if (query->function != NULL &&
-		strcmp(query->function, dp->function))
+	if (query->function && strcmp(query->function, dp->function))
 		return false;
 
 	/* match against the format */
-	if (query->format != NULL &&
-		strstr(dp->format, query->format) == NULL)
+	if (query->format && !strstr(dp->format, query->format))
 		return false;
 
 	/* match against the line number range */
-- 
1.7.4.4

