Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1K3CTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:19:38 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57312 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932083Ab1K3CTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:19:34 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 27/28] mbcache: checkpatch wanking.
Date: Tue, 29 Nov 2011 18:14:25 -0800
Message-Id: <d99eeae297dcbde94bcbd556efc8d0d6e5d8c407.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now checkpatch clean.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/mbcache.c | cut -f3- -d":" | sort | uniq -c
      1  ERROR: code indent should use tabs where possible
      2  ERROR: spaces required around that '<' (ctx:VxV)
      2  ERROR: spaces required around that '=' (ctx:VxV)
      2  ERROR: trailing whitespace
      9  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
      1  WARNING: please, no space before tabs

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/mbcache.c |   42 ++++++++++++++++--------------------------
 1 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index a3c533c..a685b62 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -59,24 +59,11 @@ do {							\
 #define MB_CACHE_WRITER ((unsigned short)~0U >> 1)
 
 static DECLARE_WAIT_QUEUE_HEAD(mb_cache_queue);
-		
+
 MODULE_AUTHOR("Andreas Gruenbacher <a.gruenbacher@computer.org>");
 MODULE_DESCRIPTION("Meta block cache (for extended attributes)");
 MODULE_LICENSE("GPL");
 
-EXPORT_SYMBOL(mb_cache_create);
-EXPORT_SYMBOL(mb_cache_shrink);
-EXPORT_SYMBOL(mb_cache_destroy);
-EXPORT_SYMBOL(mb_cache_entry_alloc);
-EXPORT_SYMBOL(mb_cache_entry_insert);
-EXPORT_SYMBOL(mb_cache_entry_release);
-EXPORT_SYMBOL(mb_cache_entry_free);
-EXPORT_SYMBOL(mb_cache_entry_get);
-#if !defined(MB_CACHE_INDEXES_COUNT) || (MB_CACHE_INDEXES_COUNT > 0)
-EXPORT_SYMBOL(mb_cache_entry_find_first);
-EXPORT_SYMBOL(mb_cache_entry_find_next);
-#endif
-
 /*
  * Global data: list of all mbcache's, lru list, and a spinlock for
  * accessing cache data structures on SMP machines. The lru list is
@@ -218,16 +205,16 @@ mb_cache_create(const char *name, int bucket_bits)
 	atomic_set(&cache->c_entry_count, 0);
 	cache->c_bucket_bits = bucket_bits;
 	cache->c_block_hash = kmalloc(bucket_count * sizeof(struct list_head),
-	                              GFP_KERNEL);
+				      GFP_KERNEL);
 	if (!cache->c_block_hash)
 		goto fail;
-	for (n=0; n<bucket_count; n++)
+	for (n = 0; n < bucket_count; n++)
 		INIT_LIST_HEAD(&cache->c_block_hash[n]);
 	cache->c_index_hash = kmalloc(bucket_count * sizeof(struct list_head),
 				      GFP_KERNEL);
 	if (!cache->c_index_hash)
 		goto fail;
-	for (n=0; n<bucket_count; n++)
+	for (n = 0; n < bucket_count; n++)
 		INIT_LIST_HEAD(&cache->c_index_hash[n]);
 	cache->c_entry_cache = kmem_cache_create(name,
 		sizeof(struct mb_cache_entry), 0,
@@ -254,7 +241,7 @@ fail:
 	kfree(cache);
 	return NULL;
 }
-
+EXPORT_SYMBOL(mb_cache_create);
 
 /*
  * mb_cache_shrink()
@@ -286,7 +273,7 @@ mb_cache_shrink(struct block_device *bdev)
 						   e_lru_list), GFP_KERNEL);
 	}
 }
-
+EXPORT_SYMBOL(mb_cache_shrink);
 
 /*
  * mb_cache_destroy()
@@ -329,6 +316,7 @@ mb_cache_destroy(struct mb_cache *cache)
 	kfree(cache->c_block_hash);
 	kfree(cache);
 }
+EXPORT_SYMBOL(mb_cache_destroy);
 
 /*
  * mb_cache_entry_alloc()
@@ -366,7 +354,7 @@ mb_cache_entry_alloc(struct mb_cache *cache, gfp_t gfp_flags)
 	ce->e_used = 1 + MB_CACHE_WRITER;
 	return ce;
 }
-
+EXPORT_SYMBOL(mb_cache_entry_alloc);
 
 /*
  * mb_cache_entry_insert()
@@ -391,7 +379,7 @@ mb_cache_entry_insert(struct mb_cache_entry *ce, struct block_device *bdev,
 	struct list_head *l;
 	int error = -EBUSY;
 
-	bucket = hash_long((unsigned long)bdev + (block & 0xffffffff), 
+	bucket = hash_long((unsigned long)bdev + (block & 0xffffffff),
 			   cache->c_bucket_bits);
 	spin_lock(&mb_cache_spinlock);
 	list_for_each_prev(l, &cache->c_block_hash[bucket]) {
@@ -412,7 +400,7 @@ out:
 	spin_unlock(&mb_cache_spinlock);
 	return error;
 }
-
+EXPORT_SYMBOL(mb_cache_entry_insert);
 
 /*
  * mb_cache_entry_release()
@@ -427,7 +415,7 @@ mb_cache_entry_release(struct mb_cache_entry *ce)
 	spin_lock(&mb_cache_spinlock);
 	__mb_cache_entry_release_unlock(ce);
 }
-
+EXPORT_SYMBOL(mb_cache_entry_release);
 
 /*
  * mb_cache_entry_free()
@@ -443,7 +431,7 @@ mb_cache_entry_free(struct mb_cache_entry *ce)
 	__mb_cache_entry_unhash(ce);
 	__mb_cache_entry_release_unlock(ce);
 }
-
+EXPORT_SYMBOL(mb_cache_entry_free);
 
 /*
  * mb_cache_entry_get()
@@ -497,6 +485,7 @@ cleanup:
 	spin_unlock(&mb_cache_spinlock);
 	return ce;
 }
+EXPORT_SYMBOL(mb_cache_entry_get);
 
 #if !defined(MB_CACHE_INDEXES_COUNT) || (MB_CACHE_INDEXES_COUNT > 0)
 
@@ -566,7 +555,7 @@ mb_cache_entry_find_first(struct mb_cache *cache, struct block_device *bdev,
 	spin_unlock(&mb_cache_spinlock);
 	return ce;
 }
-
+EXPORT_SYMBOL(mb_cache_entry_find_first);
 
 /*
  * mb_cache_entry_find_next()
@@ -578,7 +567,7 @@ mb_cache_entry_find_first(struct mb_cache *cache, struct block_device *bdev,
  *
  * entry = mb_cache_entry_find_first();
  * while (entry) {
- * 	...
+ *	...
  *	entry = mb_cache_entry_find_next(entry, ...);
  * }
  *
@@ -601,6 +590,7 @@ mb_cache_entry_find_next(struct mb_cache_entry *prev,
 	__mb_cache_entry_release_unlock(prev);
 	return ce;
 }
+EXPORT_SYMBOL(mb_cache_entry_find_next);
 
 #endif  /* !defined(MB_CACHE_INDEXES_COUNT) || (MB_CACHE_INDEXES_COUNT > 0) */
 
-- 
1.7.6.405.gc1be0

