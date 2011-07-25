Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1GYVqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:46:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1GYVnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:39 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 15/25] dynamic_debug: remove explicit foo != NULL checks.
Date: Mon, 25 Jul 2011 15:42:40 -0600
Message-Id: <1311630170-26057-16-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce != NULL relational tests to their 0/1 equivalents.
Done separately to preserve code-move character of previous patch.
No generated code difference.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c0a5d20..0c25ba0 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -147,19 +147,17 @@ static bool query_matches_callsite(struct _ddebug *dp,
 				const struct ddebug_query *query)
 {
 	/* match against the source filename */
-	if (query->filename != NULL &&
+	if (query->filename &&
 		strcmp(query->filename, dp->filename) &&
 		strcmp(query->filename, basename(dp->filename)))
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
1.7.4.1

