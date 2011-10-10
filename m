Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1JJKyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:54:51 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:37317 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1JJKyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:54:50 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, viro@zeniv.linux.org.uk, dchinner@redhat.com,
        hch@lst.de, Richard Weinberger <richard@nod.at>
Subject: [PATCH v2] ramfs: Remove module leftovers
Date: Mon, 10 Oct 2011 12:54:39 +0200
Message-Id: <1318244079-10815-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since ramfs is hard-selected to "y", the module leftovers make
no sense.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ramfs/inode.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index eacb166..148fdf6 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -23,7 +23,6 @@
  * caches is sufficient.
  */
 
-#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
@@ -288,14 +287,7 @@ static int __init init_ramfs_fs(void)
 {
 	return register_filesystem(&ramfs_fs_type);
 }
-
-static void __exit exit_ramfs_fs(void)
-{
-	unregister_filesystem(&ramfs_fs_type);
-}
-
-module_init(init_ramfs_fs)
-module_exit(exit_ramfs_fs)
+device_initcall(init_ramfs_fs);
 
 int __init init_rootfs(void)
 {
@@ -311,5 +303,3 @@ int __init init_rootfs(void)
 
 	return err;
 }
-
-MODULE_LICENSE("GPL");
-- 
1.7.7

