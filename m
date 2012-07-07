Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2GGBHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 21:07:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44971 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2GGBG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 21:06:59 -0400
From: Pablo Vazquez Rodriguez <peibolvigo@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, john.stultz@linaro.org, arve@android.com,
        ccross@android.com, bringert@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, peibolvigo@gmail.com
Subject: [PATCH] Staging: android: fix pr_info and pr_err coding style issues in ashmem.c
Date: Sat,  7 Jul 2012 03:06:45 +0200
Message-Id: <1341623205-17174-1-git-send-email-peibolvigo@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ashmem.c file that fixes up several pr_info and pr_err warnings found by the checkpath.pl tool

Signed-off-by: Pablo Vazquez Rodriguez <peibolvigo@gmail.com>
---
 drivers/staging/android/ashmem.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index e84dbec..71eb63b 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -15,6 +15,7 @@
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/file.h>
@@ -707,7 +708,7 @@ static int __init ashmem_init(void)
 					  sizeof(struct ashmem_area),
 					  0, 0, NULL);
 	if (unlikely(!ashmem_area_cachep)) {
-		printk(KERN_ERR "ashmem: failed to create slab cache\n");
+		pr_err("failed to create slab cache\n");
 		return -ENOMEM;
 	}
 
@@ -715,19 +716,19 @@ static int __init ashmem_init(void)
 					  sizeof(struct ashmem_range),
 					  0, 0, NULL);
 	if (unlikely(!ashmem_range_cachep)) {
-		printk(KERN_ERR "ashmem: failed to create slab cache\n");
+		pr_err("failed to create slab cache\n");
 		return -ENOMEM;
 	}
 
 	ret = misc_register(&ashmem_misc);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "ashmem: failed to register misc device!\n");
+		pr_err("failed to register misc device!\n");
 		return ret;
 	}
 
 	register_shrinker(&ashmem_shrinker);
 
-	printk(KERN_INFO "ashmem: initialized\n");
+	pr_info("initialized\n");
 
 	return 0;
 }
@@ -740,12 +741,12 @@ static void __exit ashmem_exit(void)
 
 	ret = misc_deregister(&ashmem_misc);
 	if (unlikely(ret))
-		printk(KERN_ERR "ashmem: failed to unregister misc device!\n");
+		pr_err("failed to unregister misc device!\n");
 
 	kmem_cache_destroy(ashmem_range_cachep);
 	kmem_cache_destroy(ashmem_area_cachep);
 
-	printk(KERN_INFO "ashmem: unloaded\n");
+	pr_info("unloaded\n");
 }
 
 module_init(ashmem_init);
-- 
1.7.7.6

