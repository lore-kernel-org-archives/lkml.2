Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1LLXNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:13:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1LLXNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:19 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 08/25] dynamic_debug: drop explicit !=NULL checks
Date: Mon, 12 Dec 2011 16:12:34 -0700
Message-Id: <1323731569-20644-8-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>


Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 4c6d0b7..6904fdc 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -115,27 +115,26 @@ static void ddebug_change(const struct ddebug_query *query,
 	list_for_each_entry(dt, &ddebug_tables, link) {
 
 		/* match against the module name */
-		if (query->module != NULL &&
-		    strcmp(query->module, dt->mod_name))
+		if (query->module && strcmp(query->module, dt->mod_name))
 			continue;
 
 		for (i = 0 ; i < dt->num_ddebugs ; i++) {
 			struct _ddebug *dp = &dt->ddebugs[i];
 
 			/* match against the source filename */
-			if (query->filename != NULL &&
+			if (query->filename &&
 			    strcmp(query->filename, dp->filename) &&
 			    strcmp(query->filename, basename(dp->filename)))
 				continue;
 
 			/* match against the function */
-			if (query->function != NULL &&
+			if (query->function &&
 			    strcmp(query->function, dp->function))
 				continue;
 
 			/* match against the format */
-			if (query->format != NULL &&
-			    strstr(dp->format, query->format) == NULL)
+			if (query->format &&
+			    !strstr(dp->format, query->format))
 				continue;
 
 			/* match against the line number range */
-- 
1.7.7.3

