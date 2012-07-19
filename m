Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab2GSVB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:01:28 -0400
Received: from mail.eladian.com ([64.140.252.105]:48353 "EHLO mail.eladian.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2GSVB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:01:26 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2012 17:01:26 EDT
X-Amavis-Modified: Mail body modified (using disclaimer) - mail.eladian.com
Date: Thu, 19 Jul 2012 16:53:26 -0400 (EDT)
From: Daniel Wisehart <daniel.wisehart@eladian.com>
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
Subject: [Bcache v14 PATCH] fix compiler error
Message-ID: <0d1ae163-7cde-4a78-852a-04fba827249f@mail.eladian.com>
In-Reply-To: <1abe2159-2201-46c4-9c60-afc4f358ff6a@mail.eladian.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - GC19 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kent, 

This patch keeps gcc 4.7.0 happy.  The static function dump_bset() could be moved, but that would have made a bigger patch.  :-)

Thanks,
Daniel



diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 3c9c24d..4dc0ba5 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -83,6 +83,8 @@ struct keyprint_hack bch_pbtree(const struct btree *b)
 
 #ifdef CONFIG_BCACHE_DEBUG
 
+static void dump_bset(struct btree *b, struct bset *i);
+
 void bch_btree_verify(struct btree *b, struct bset *new)
 {
        struct btree *v = b->c->verify_data;


This communication is restricted - please see http://www.eladian.com for further information.
