Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab2IZLiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:38:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65507 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2IZLis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:38:48 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] fs/debugsfs: get rid of unnecessary inode->i_private initialization
Date: Wed, 26 Sep 2012 19:38:29 +0800
Message-Id: <1348659510-9059-2-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348659510-9059-1-git-send-email-clouds.yan@gmail.com>
References: <1348659510-9059-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inode->i_private is promised to be NULL on allocation, no need to set
it explicitly.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/debugfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 4733eab..de2698d 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -59,7 +59,6 @@ static struct inode *debugfs_get_inode(struct super_block *sb, umode_t mode, dev
 		case S_IFDIR:
 			inode->i_op = &simple_dir_inode_operations;
 			inode->i_fop = &simple_dir_operations;
-			inode->i_private = NULL;
 
 			/* directory inodes start off with i_nlink == 2
 			 * (for "." entry) */
-- 
1.7.9.5

