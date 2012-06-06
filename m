Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab2FFRRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:17:34 -0400
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:40383 "HELO
	na3sys010aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757396Ab2FFRRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:17:33 -0400
From: Roland Dreier <roland@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] btree: Catch NULL value before it does harm
Date: Wed,  6 Jun 2012 10:17:27 -0700
Message-Id: <1339003047-15734-2-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339003047-15734-1-git-send-email-roland@kernel.org>
References: <1339003047-15734-1-git-send-email-roland@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joern Engel <joern@logfs.org>

Storing NULL values in the btree is illegal and can lead to memory
corruption and possible other fun as well.  Catch it on insert, instead
of waiting for the inevitable.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 lib/btree.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/btree.c b/lib/btree.c
index b6e889b..bd6d4b4 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -509,6 +509,7 @@ retry:
 int btree_insert(struct btree_head *head, struct btree_geo *geo,
 		unsigned long *key, void *val, gfp_t gfp)
 {
+	BUG_ON(!val);
 	return btree_insert_level(head, geo, key, val, 1, gfp);
 }
 EXPORT_SYMBOL_GPL(btree_insert);
-- 
1.7.9.5

