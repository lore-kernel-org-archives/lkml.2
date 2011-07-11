Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab1GKHsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:48:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab1GKHro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:44 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 17/21] dynamic_debug: non-optimization - remove != NULL
Date: Mon, 11 Jul 2011 01:46:52 -0600
Message-Id: <1310370416-6322-18-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce != NULL relational test to its 0/1 equivalent.
No code difference, may not be worth including.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 8dde999..1763cc2 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -142,18 +142,18 @@ static int query_matches_callsite(struct _ddebug *dp,
 				const struct ddebug_query *query)
 {
 	/* match against the source filename */
-	if (query->filename != NULL &&
+	if (query->filename &&
 		strcmp(query->filename, dp->filename) &&
 		strcmp(query->filename, basename(dp->filename)))
 		return 0;
 
 	/* match against the function */
-	if (query->function != NULL &&
+	if (query->function &&
 		strcmp(query->function, dp->function))
 		return 0;
 
 	/* match against the format */
-	if (query->format != NULL &&
+	if (query->format &&
 		strstr(dp->format, query->format) == NULL)
 		return 0;
 
-- 
1.7.4.1

