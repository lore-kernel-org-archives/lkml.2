Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2JMQvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:51:35 -0400
Received: from rsk.demon.co.uk ([80.176.90.227]:13426 "EHLO castor.rsk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753834Ab2JMQvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:51:32 -0400
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Kennedy <richard@rsk.demon.co.uk>
Subject: [PATCH 1/2] SLUB: remove hard coded magic numbers from resiliency_test
Date: Sat, 13 Oct 2012 17:31:24 +0100
Message-Id: <1350145885-6099-2-git-send-email-richard@rsk.demon.co.uk>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350145885-6099-1-git-send-email-richard@rsk.demon.co.uk>
References: <1350145885-6099-1-git-send-email-richard@rsk.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the always inlined function kmalloc_index to translate
sizes to indexes, so that we don't have to have the slab indexes
hard coded in two places.



Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 mm/slub.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2fdd96f..804ac42 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4418,7 +4418,7 @@ static void resiliency_test(void)
 	printk(KERN_ERR "\n1. kmalloc-16: Clobber Redzone/next pointer"
 			" 0x12->0x%p\n\n", p + 16);
 
-	validate_slab_cache(kmalloc_caches[4]);
+	validate_slab_cache(kmalloc_caches[kmalloc_index(16)]);
 
 	/* Hmmm... The next two are dangerous */
 	p = kzalloc(32, GFP_KERNEL);
@@ -4428,7 +4428,7 @@ static void resiliency_test(void)
 	printk(KERN_ERR
 		"If allocated object is overwritten then not detectable\n\n");
 
-	validate_slab_cache(kmalloc_caches[5]);
+	validate_slab_cache(kmalloc_caches[kmalloc_index(32)]);
 	p = kzalloc(64, GFP_KERNEL);
 	p += 64 + (get_cycles() & 0xff) * sizeof(void *);
 	*p = 0x56;
@@ -4436,27 +4436,27 @@ static void resiliency_test(void)
 									p);
 	printk(KERN_ERR
 		"If allocated object is overwritten then not detectable\n\n");
-	validate_slab_cache(kmalloc_caches[6]);
+	validate_slab_cache(kmalloc_caches[kmalloc_index(64)]);
 
 	printk(KERN_ERR "\nB. Corruption after free\n");
 	p = kzalloc(128, GFP_KERNEL);
 	kfree(p);
 	*p = 0x78;
 	printk(KERN_ERR "1. kmalloc-128: Clobber first word 0x78->0x%p\n\n", p);
-	validate_slab_cache(kmalloc_caches[7]);
+	validate_slab_cache(kmalloc_caches[kmalloc_index(128)]);
 
 	p = kzalloc(256, GFP_KERNEL);
 	kfree(p);
 	p[50] = 0x9a;
 	printk(KERN_ERR "\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n",
 			p);
-	validate_slab_cache(kmalloc_caches[8]);
+	validate_slab_cache(kmalloc_caches[kmalloc_index(256)]);
 
 	p = kzalloc(512, GFP_KERNEL);
 	kfree(p);
 	p[512] = 0xab;
 	printk(KERN_ERR "\n3. kmalloc-512: Clobber redzone 0xab->0x%p\n\n", p);
-	validate_slab_cache(kmalloc_caches[9]);
+	validate_slab_cache(kmalloc_caches[kmalloc_index(512)]);
 }
 #else
 #ifdef CONFIG_SYSFS
-- 
1.7.11.7

