Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2IHPtO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:49:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55736 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab2IHPtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:49:12 -0400
Message-ID: <504B68EC.50807@gmail.com>
Date: Sat, 08 Sep 2012 23:49:00 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: correct comment for fs/fs-writeback.c/move_expired_inodes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function scans @delaying_queue and stops at the first inode
whose dirtied_when is after *work->older_than_this. So the expired
ones being moved are those before *work->older_than_this. Correct
the comment here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/fs-writeback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index be3efc4..fd255c0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -248,7 +248,7 @@ static bool inode_dirtied_after(struct inode *inode, unsigned long t)
 }
 
 /*
- * Move expired (dirtied after work->older_than_this) dirty inodes from
+ * Move expired (dirtied before work->older_than_this) dirty inodes from
  * @delaying_queue to @dispatch_queue.
  */
 static int move_expired_inodes(struct list_head *delaying_queue,
-- 
1.7.1
