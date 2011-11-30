Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab1K3CP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:15:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38988 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:15:51 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/28] namespace: Use current logging styles
Date: Tue, 29 Nov 2011 18:14:05 -0800
Message-Id: <bcf85452f45f2c990dd16dac485ab9adf3edcea9.1322609672.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>.
This adds a "namespace: " prefix to logging output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/namespace.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 874dc5c..f9a164d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -8,6 +8,8 @@
  * Heavily rewritten.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/syscalls.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
@@ -2716,7 +2718,7 @@ void __init mnt_init(void)
 	if (!mount_hashtable)
 		panic("Failed to allocate mount hash table\n");
 
-	printk(KERN_INFO "Mount-cache hash table entries: %lu\n", HASH_SIZE);
+	pr_info("Mount-cache hash table entries: %lu\n", HASH_SIZE);
 
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
@@ -2725,11 +2727,10 @@ void __init mnt_init(void)
 
 	err = sysfs_init();
 	if (err)
-		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
-			__func__, err);
+		pr_warn("%s: sysfs_init error: %d\n", __func__, err);
 	fs_kobj = kobject_create_and_add("fs", NULL);
 	if (!fs_kobj)
-		printk(KERN_WARNING "%s: kobj create error\n", __func__);
+		pr_warn("%s: kobj create error\n", __func__);
 	init_rootfs();
 	init_mount_tree();
 }
-- 
1.7.6.405.gc1be0

