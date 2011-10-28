Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab1J1MN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:13:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44591 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511Ab1J1MN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:13:56 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: hch@infradead.org
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 06/13] jfs: remove unnecessary nlink setting
Date: Fri, 28 Oct 2011 14:13:25 +0200
Message-Id: <1319804012-16346-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
References: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

alloc_inode() initializes i_nlink to 1.  Remove unnecessary
re-initialization.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 fs/jfs/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 06c8a67..a44eff0 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -485,7 +485,6 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_unload;
 	}
 	inode->i_ino = 0;
-	inode->i_nlink = 1;
 	inode->i_size = sb->s_bdev->bd_inode->i_size;
 	inode->i_mapping->a_ops = &jfs_metapage_aops;
 	insert_inode_hash(inode);
-- 
1.7.3.4

