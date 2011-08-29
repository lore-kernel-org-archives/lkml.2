Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1H2PZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:25:06 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47447 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab1H2PZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:25:02 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@lst.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] ramfs: Remove module leftovers
Date: Mon, 29 Aug 2011 17:24:51 +0200
Message-Id: <1314631491-27095-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since ramfs is hard-selected to "y", the module leftovers make
no sense.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ramfs/inode.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index eacb166..313ae92 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -23,7 +23,6 @@
  * caches is sufficient.
  */
 
-#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
@@ -294,8 +293,8 @@ static void __exit exit_ramfs_fs(void)
 	unregister_filesystem(&ramfs_fs_type);
 }
 
-module_init(init_ramfs_fs)
-module_exit(exit_ramfs_fs)
+device_initcall(init_ramfs_fs);
+__exitcall(exit_ramfs_fs);
 
 int __init init_rootfs(void)
 {
@@ -311,5 +310,3 @@ int __init init_rootfs(void)
 
 	return err;
 }
-
-MODULE_LICENSE("GPL");
-- 
1.7.6.1

