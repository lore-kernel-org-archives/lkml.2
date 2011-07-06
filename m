Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1GFRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:25:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab1GFRZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:25:22 -0400
Date: Wed, 6 Jul 2011 13:25:17 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <60d37e464f675b0f67e1dae828f3b0a1718fff5d.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
In-Reply-To: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
References: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
Subject: [PATCH 10/10] dynamic_debug: remove num_enabled accounting
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

The num_enabled accouting aren't actually used anywhere - remove them.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index db66a48..fbb4547 100644
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

