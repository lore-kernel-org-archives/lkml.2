Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0KIJUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:20:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab0KIJUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:20:39 -0500
Date: Tue, 9 Nov 2010 04:19:58 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Amerigo Wang <amwang@redhat.com>
Message-Id: <20101109092449.6284.90481.sendpatchset@localhost.localdomain>
Subject: [Patch] debugfs: remove module_exit()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs can't be a module, so module_exit() is meaningless
for it.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 37a8ca7..d38c88f 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -13,9 +13,6 @@
  *
  */
 
-/* uncomment to get debug messages from the debug filesystem, ah the irony. */
-/* #define DEBUG */
-
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
@@ -540,17 +537,5 @@ static int __init debugfs_init(void)
 
 	return retval;
 }
-
-static void __exit debugfs_exit(void)
-{
-	debugfs_registered = false;
-
-	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
-	unregister_filesystem(&debug_fs_type);
-	kobject_put(debug_kobj);
-}
-
 core_initcall(debugfs_init);
-module_exit(debugfs_exit);
-MODULE_LICENSE("GPL");
 
