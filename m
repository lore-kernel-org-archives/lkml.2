Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab2K0LZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:25:51 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62430 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab2K0LZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:25:49 -0500
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
To: Joern Engel <joern@logfs.org>, Prasad Joshi <prasadjoshi.linux@gmail.com>,
        logfs@logfs.org
Cc: linux-kernel@vger.kernel.org, Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH 1/2] fs: logfs NULL pointer check added
Date: Tue, 27 Nov 2012 16:54:58 +0530
Message-Id: <1354015498-8986-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes  Bug 49921 - Missing NULL check of return value of logfs_get_write_page() in function btree_write_block()

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 fs/logfs/readwrite.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index e1a3b6b..53596ce 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -2202,6 +2202,7 @@ void btree_write_block(struct logfs_block *block)
 
 	inode = logfs_safe_iget(block->sb, block->ino, &cookie);
 	page = logfs_get_write_page(inode, block->bix, block->level);
+	BUG_ON(!page);
 
 	err = logfs_readpage_nolock(page);
 	BUG_ON(err);
-- 
1.7.7.6

