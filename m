Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab2GNM3f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 08:29:35 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49054 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab2GNM2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 08:28:46 -0400
From: Austin Robinson <austin.rbsn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Austin Robinson <austin.rbsn@gmail.com>
Subject: [PATCH] Staging: android: ashmem: Replaces printk with pr_err and pr_info
Date: Sat, 14 Jul 2012 08:28:34 -0400
Message-Id: <1342268914-4547-1-git-send-email-austin.rbsn@gmail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In several instances in ashmem.c, printk(KERN_INFO... and printk{KERN_ERR... were being
used. This replaces those with the preferred pr_err and pr_info, which removes
style-related warnings.

Signed-off-by: Austin C Robinson <austin.rbsn@gmail.com>
---
 drivers/staging/android/ashmem.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index e84dbec..01e61c9 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -707,7 +707,7 @@ static int __init ashmem_init(void)
 					  sizeof(struct ashmem_area),
 					  0, 0, NULL);
 	if (unlikely(!ashmem_area_cachep)) {
-		printk(KERN_ERR "ashmem: failed to create slab cache\n");
+		pr_err("ashmem: failed to create slab cache\n");
 		return -ENOMEM;
 	}
 
@@ -715,19 +715,19 @@ static int __init ashmem_init(void)
 					  sizeof(struct ashmem_range),
 					  0, 0, NULL);
 	if (unlikely(!ashmem_range_cachep)) {
-		printk(KERN_ERR "ashmem: failed to create slab cache\n");
+		pr_err("ashmem: failed to create slab cache\n");
 		return -ENOMEM;
 	}
 
 	ret = misc_register(&ashmem_misc);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "ashmem: failed to register misc device!\n");
+		pr_err("ashmem: failed to register misc device!\n");
 		return ret;
 	}
 
 	register_shrinker(&ashmem_shrinker);
 
-	printk(KERN_INFO "ashmem: initialized\n");
+	pr_info("ashmem: initialized\n");
 
 	return 0;
 }
@@ -740,12 +740,12 @@ static void __exit ashmem_exit(void)
 
 	ret = misc_deregister(&ashmem_misc);
 	if (unlikely(ret))
-		printk(KERN_ERR "ashmem: failed to unregister misc device!\n");
+		pr_err("ashmem: failed to unregister misc device!\n");
 
 	kmem_cache_destroy(ashmem_range_cachep);
 	kmem_cache_destroy(ashmem_area_cachep);
 
-	printk(KERN_INFO "ashmem: unloaded\n");
+	pr_info("ashmem: unloaded\n");
 }
 
 module_init(ashmem_init);
-- 
1.7.11.2

