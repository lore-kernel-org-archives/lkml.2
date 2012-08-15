Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2HOPrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:47:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50392 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab2HOPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:47:51 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: [PATCH 11/13] vfs: export __inode_permission() to modules
Date: Wed, 15 Aug 2012 17:48:18 +0200
Message-Id: <1345045700-9062-12-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

We need to be able to check inode permissions (but not filesystem implied
permissions) for stackable filesystems.  Expose this interface for overlayfs.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h      |    5 -----
 fs/namei.c         |    1 +
 include/linux/fs.h |    1 +
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 371bcc4..8578209 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -42,11 +42,6 @@ static inline int __sync_blockdev(struct block_device *bdev, int wait)
 extern void __init chrdev_init(void);
 
 /*
- * namei.c
- */
-extern int __inode_permission(struct inode *, int);
-
-/*
  * namespace.c
  */
 extern int copy_mount_options(const void __user *, unsigned long *);
diff --git a/fs/namei.c b/fs/namei.c
index ac2526d..9be439a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -348,6 +348,7 @@ int __inode_permission(struct inode *inode, int mask)
 
 	return security_inode_permission(inode, mask);
 }
+EXPORT_SYMBOL(__inode_permission);
 
 /**
  * sb_permission - Check superblock-level permissions
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1265e24..d573703 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2418,6 +2418,7 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int inode_permission(struct inode *, int);
+extern int __inode_permission(struct inode *, int);
 extern int generic_permission(struct inode *, int);
 
 static inline bool execute_ok(struct inode *inode)
-- 
1.7.7

