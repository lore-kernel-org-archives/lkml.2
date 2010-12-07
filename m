Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0LGKJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:09:12 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38978 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0LGKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:09:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q4WFSj5oyjOWD4H4+8r8KVSkh3Lpnv0dVr9/i2ZDMA9tWeeQEqHbfwY91stOT5eBor
         wB2/OeDNKoUSS6qyj/XDOZ5rBs7QvFYUgo1jSFVEMHNL2MRDCuy3jbuFMN7PZeCjbQ1J
         9cTkI5GPm8QZHct03hXpyoxTbuzWBuFMtMXFQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mbcache: update comments
Date: Tue,  7 Dec 2010 19:08:56 +0900
Message-Id: <1291716536-10285-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291716536-10285-1-git-send-email-namhyung@gmail.com>
References: <1291716536-10285-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing arguments in some function comments and update
description of mb_cache_entry_free() because it refers obsolete
mb_cache_entry_takeout().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/mbcache.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index c0cfc42..ab73fff 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -298,6 +298,8 @@ mb_cache_shrink(struct block_device *bdev)
  * Shrinks the cache to its minimum possible size (hopefully 0 entries),
  * and then destroys it. If this was the last mbcache, un-registers the
  * mbcache from kernel memory management.
+ *
+ * @cache: cache to be destroyed
  */
 void
 mb_cache_destroy(struct mb_cache *cache)
@@ -339,6 +341,9 @@ mb_cache_destroy(struct mb_cache *cache)
  * and thus cannot be looked up yet. It should be filled with data, and
  * then inserted into the cache using mb_cache_entry_insert(). Returns NULL
  * if no more memory was available.
+ *
+ * @cache: cache the cache entry to be allocated from
+ * @gfp_flags: memory allocation flags
  */
 struct mb_cache_entry *
 mb_cache_entry_alloc(struct mb_cache *cache, gfp_t gfp_flags)
@@ -380,6 +385,7 @@ mb_cache_entry_alloc(struct mb_cache *cache, gfp_t gfp_flags)
  * already (this may happen after a failed lookup, but when another process
  * has inserted the same cache entry in the meantime).
  *
+ * @ce: cache entry to be inserted
  * @bdev: device the cache entry belongs to
  * @block: block number
  * @key: lookup key
@@ -422,6 +428,8 @@ out:
  * Release a handle to a cache entry. When the last handle to a cache entry
  * is released it is either freed (if it is invalid) or otherwise inserted
  * in to the lru list.
+ *
+ * @ce: cache entry to be released
  */
 void
 mb_cache_entry_release(struct mb_cache_entry *ce)
@@ -434,8 +442,9 @@ mb_cache_entry_release(struct mb_cache_entry *ce)
 /*
  * mb_cache_entry_free()
  *
- * This is equivalent to the sequence mb_cache_entry_takeout() --
- * mb_cache_entry_release().
+ * Release a handle to a cache entry and free it.
+ *
+ * @ce: cache entry to be freed
  */
 void
 mb_cache_entry_free(struct mb_cache_entry *ce)
@@ -454,6 +463,10 @@ mb_cache_entry_free(struct mb_cache_entry *ce)
  * in the cache per device and block.) Returns NULL if no such cache entry
  * exists. The returned cache entry is locked for exclusive access ("single
  * writer").
+ *
+ * @cache: cache to search
+ * @bdev: device the cache entry should belong to
+ * @block: block number
  */
 struct mb_cache_entry *
 mb_cache_entry_get(struct mb_cache *cache, struct block_device *bdev,
-- 
1.7.0.4

