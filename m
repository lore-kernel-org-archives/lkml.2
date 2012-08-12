Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab2HLJpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 05:45:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2HLJpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 05:45:13 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 4/7] fs/fat: Fix two checkpatch issues in cache.c
Date: Sun, 12 Aug 2012 19:44:44 +1000
Message-Id: <1344764687-4155-5-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
References: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This does the following:
	1: Splits the arguments of a function call to stop it
		from exceeding 80 characters
	2: Re-indents the arguments of another function call
		to prevent the splitting of a quoted string.

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 fs/fat/cache.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index 1cc7038..91ad9e1 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -190,7 +190,8 @@ static void __fat_cache_inval_inode(struct inode *inode)
 	struct fat_cache *cache;
 
 	while (!list_empty(&i->cache_lru)) {
-		cache = list_entry(i->cache_lru.next, struct fat_cache, cache_list);
+		cache = list_entry(i->cache_lru.next,
+				   struct fat_cache, cache_list);
 		list_del_init(&cache->cache_list);
 		i->nr_caches--;
 		fat_cache_free(cache);
@@ -261,9 +262,10 @@ int fat_get_cluster(struct inode *inode, int cluster, int *fclus, int *dclus)
 		if (nr < 0)
 			goto out;
 		else if (nr == FAT_ENT_FREE) {
-			fat_fs_error_ratelimit(sb, "%s: invalid cluster chain"
-					       " (i_pos %lld)", __func__,
-					       MSDOS_I(inode)->i_pos);
+			fat_fs_error_ratelimit(sb,
+				       "%s: invalid cluster chain (i_pos %lld)",
+				       __func__,
+				       MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
 		} else if (nr == FAT_ENT_EOF) {
-- 
1.7.9.5

