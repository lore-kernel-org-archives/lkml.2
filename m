Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab1J1MOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:14:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44591 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545Ab1J1MN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:13:59 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: hch@infradead.org
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz,
        Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>
Subject: [PATCH 08/13] logfs: remove unnecessary nlink setting
Date: Fri, 28 Oct 2011 14:13:27 +0200
Message-Id: <1319804012-16346-9-git-send-email-miklos@szeredi.hu>
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
CC: Joern Engel <joern@logfs.org>
CC: Prasad Joshi <prasadjoshi.linux@gmail.com>
---
 fs/logfs/inode.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index edfea7a..9abb048 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -199,7 +199,6 @@ static void logfs_init_inode(struct super_block *sb, struct inode *inode)
 	inode->i_blocks	= 0;
 	inode->i_ctime	= CURRENT_TIME;
 	inode->i_mtime	= CURRENT_TIME;
-	inode->i_nlink	= 1;
 	li->li_refcount = 1;
 	INIT_LIST_HEAD(&li->li_freeing_list);
 
-- 
1.7.3.4

