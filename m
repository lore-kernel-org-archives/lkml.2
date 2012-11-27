Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab2K0L0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:26:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42722 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2K0L0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:26:18 -0500
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
To: Joern Engel <joern@logfs.org>, Prasad Joshi <prasadjoshi.linux@gmail.com>,
        logfs@logfs.org
Cc: linux-kernel@vger.kernel.org, Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH 2/2] fs: logfs NULL pointer check added
Date: Tue, 27 Nov 2012 16:55:58 +0530
Message-Id: <1354015558-9030-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes the case where the NULL inode may be passed to get the page for writing.

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 fs/logfs/readwrite.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index 53596ce..55b45fb 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -2201,6 +2201,7 @@ void btree_write_block(struct logfs_block *block)
 	int err, cookie;
 
 	inode = logfs_safe_iget(block->sb, block->ino, &cookie);
+	BUG_ON(!inode);
 	page = logfs_get_write_page(inode, block->bix, block->level);
 	BUG_ON(!page);
 
-- 
1.7.7.6

