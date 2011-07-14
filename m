Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1GNAQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:16:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51062 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1GNAP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:15:59 -0400
From: Eric Van Hensbergen <ericvh@gmail.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] net/9p: fix client code to fail more gracefully on protocol error
Date: Wed, 13 Jul 2011 19:15:52 -0500
Message-Id: <1310602552-14062-1-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a BUG_ON to protect against a bad id which could be dealt with
more gracefully.

Reported-by: Natalie Orlin <norlin@us.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 net/9p/client.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 9e3b0e6..81e667b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -280,7 +280,8 @@ struct p9_req_t *p9_tag_lookup(struct p9_client *c, u16 tag)
 	 * buffer to read the data into */
 	tag++;
 
-	BUG_ON(tag >= c->max_tag);
+	if(tag >= c->max_tag) 
+		return NULL;
 
 	row = tag / P9_ROW_MAXTAG;
 	col = tag % P9_ROW_MAXTAG;
-- 
1.7.4.1

