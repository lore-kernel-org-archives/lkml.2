Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1CPVM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:12:26 -0400
Received: from kroah.org ([198.145.64.141]:42557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab1CPVLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Amerigo Wang <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/50] debugfs: remove module_exit()
Date: Wed, 16 Mar 2011 14:10:46 -0700
Message-Id: <1300309888-5028-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>

debugfs can't be a module, so module_exit() is meaningless for it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/inode.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

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
 
-- 
1.7.4.1

