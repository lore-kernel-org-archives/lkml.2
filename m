Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1H3S25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab1H3S2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:28:53 -0400
Date: Tue, 30 Aug 2011 14:28:46 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <3f3c73ac1c7acbf11936b5126330a41f4b1af1d2.1314725877.git.jbaron@redhat.com>
In-Reply-To: <cover.1314725877.git.jbaron@redhat.com>
References: <cover.1314725877.git.jbaron@redhat.com>
Subject: [PATCH 2/4] dynamic_debug: remove num_enabled accounting
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The num_enabled accounting isn't actually used anywhere - remove them.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index ee3b9ba..198d2af 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -42,7 +42,6 @@ struct ddebug_table {
 	struct list_head link;
 	char *mod_name;
 	unsigned int num_ddebugs;
-	unsigned int num_enabled;
 	struct _ddebug *ddebugs;
 };
 
@@ -152,11 +151,6 @@ static void ddebug_change(const struct ddebug_query *query,
 			newflags = (dp->flags & mask) | flags;
 			if (newflags == dp->flags)
 				continue;
-
-			if (!newflags)
-				dt->num_enabled--;
-			else if (!dp->flags)
-				dt->num_enabled++;
 			dp->flags = newflags;
 			if (newflags)
 				dp->enabled = 1;
@@ -764,7 +758,6 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 	}
 	dt->mod_name = new_name;
 	dt->num_ddebugs = n;
-	dt->num_enabled = 0;
 	dt->ddebugs = tab;
 
 	mutex_lock(&ddebug_lock);
-- 
1.7.5.4

