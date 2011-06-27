Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1F0UW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 16:22:57 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:56528 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab1F0UWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 16:22:10 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] jffs2: use mutex_is_locked() in __jffs2_flush_wbuf()
Date: Tue, 28 Jun 2011 00:21:30 +0400
Message-Id: <1309206090-2805-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a helper to test if a mutex is held instead of a hack with
mutex_trylock().

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/jffs2/wbuf.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index 4515bea..a10fb24 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -578,8 +578,7 @@ static int __jffs2_flush_wbuf(struct jffs2_sb_info *c, int pad)
 	if (!jffs2_is_writebuffered(c))
 		return 0;
 
-	if (mutex_trylock(&c->alloc_sem)) {
-		mutex_unlock(&c->alloc_sem);
+	if (!mutex_is_locked(&c->alloc_sem)) {
 		printk(KERN_CRIT "jffs2_flush_wbuf() called with alloc_sem not locked!\n");
 		BUG();
 	}
-- 
1.7.4.1

