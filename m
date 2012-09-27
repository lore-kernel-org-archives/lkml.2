Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2I0Mwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:52:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab2I0Mwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:52:36 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] fs/inode.c: call alloc_inode() in new_inode() directly
Date: Thu, 27 Sep 2012 20:51:54 +0800
Message-Id: <1348750316-4138-6-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
References: <no>
 <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This saves us a list head initialization.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ac8d904..3a2cd41 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -921,9 +921,11 @@ struct inode *new_inode(struct super_block *sb)
 
 	spin_lock_prefetch(&inode_sb_list_lock);
 
-	inode = new_inode_pseudo(sb);
-	if (inode)
+	inode = alloc_inode(sb);
+	if (inode) {
+		inode->i_state = 0;
 		inode_sb_list_add(inode);
+	}
 	return inode;
 }
 EXPORT_SYMBOL(new_inode);
-- 
1.7.9.5

