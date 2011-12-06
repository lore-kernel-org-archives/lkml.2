Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1LFTMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:12:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab1LFTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:27 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 08/25] dynamic_debug: drop explicit !=NULL checks
Date: Tue,  6 Dec 2011 12:11:18 -0700
Message-Id: <1323198694-7186-9-git-send-email-jim.cromie@gmail.com>
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

