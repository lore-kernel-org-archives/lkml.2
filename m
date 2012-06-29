Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2F2Q13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:27:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53618 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2F2Q11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:27:27 -0400
From: Pablo Vazquez Rodriguez <peibolvigo@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, john.stultz@linaro.org, arve@android.com,
        ccross@android.com, bringert@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Pablo Vazquez Rodriguez <peibolvigo@gmail.com>
Subject: [PATCH] Staging: android: fix pr_info and pr_err coding style issues in ashmem.c
Date: Fri, 29 Jun 2012 18:27:12 +0200
Message-Id: <1340987232-25169-1-git-send-email-peibolvigo@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ashmem.c file that fixes up several pr_info and pr_err warnings found by the checkpath.pl tool

Signed-off-by: Pablo Vazquez Rodriguez <peibolvigo@gmail.com>
---
 drivers/staging/android/ashmem.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

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
1.7.7.6

