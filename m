Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1LSWMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:12:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab1LSWMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:12:44 -0500
Date: Mon, 19 Dec 2011 17:12:39 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <827b14ebdbb9db66ae27ac09c9bc4776970d5259.1324318997.git.jbaron@redhat.com>
In-Reply-To: <cover.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 07/16] dynamic_debug: drop explicit !=NULL checks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Convert 'if (x !=NULL)' checks into 'if (x)'.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index d232025..b199e09 100644
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

