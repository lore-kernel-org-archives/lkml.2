Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0LGKJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:09:10 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38978 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0LGKJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:09:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cscTS8m5LcZdLoZWDGB8jNEfF918Yf6lby2Tql0wQFzdaXSWEPkPWyiozqyiwQ5U7x
         M7+KrRK3CRzczSpcZsr0KK+36sSHqwhk7KOvkBQ+Zn8B71Si9txf+jamr84JTRH5O0SU
         MDZ3z7O99THZBzqAW8UQxdKAvlqelvpswrWes=
From: Namhyung Kim <namhyung@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mbcache: remove unnecessary conditionals
Date: Tue,  7 Dec 2010 19:08:55 +0900
Message-Id: <1291716536-10285-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291716536-10285-1-git-send-email-namhyung@gmail.com>
References: <1291716536-10285-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 2aec7c523291 ("mbcache: Remove unused features") removes
MB_CACHE_INDEXES_COUNT symbol so the test will be passed always.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/mbcache.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 0477c71..c0cfc42 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -71,10 +71,8 @@ EXPORT_SYMBOL(mb_cache_entry_insert);
 EXPORT_SYMBOL(mb_cache_entry_release);
 EXPORT_SYMBOL(mb_cache_entry_free);
 EXPORT_SYMBOL(mb_cache_entry_get);
-#if !defined(MB_CACHE_INDEXES_COUNT) || (MB_CACHE_INDEXES_COUNT > 0)
 EXPORT_SYMBOL(mb_cache_entry_find_first);
 EXPORT_SYMBOL(mb_cache_entry_find_next);
-#endif
 
 struct mb_cache {
 	struct list_head		c_cache_list;
@@ -500,8 +498,6 @@ cleanup:
 	return ce;
 }
 
-#if !defined(MB_CACHE_INDEXES_COUNT) || (MB_CACHE_INDEXES_COUNT > 0)
-
 static struct mb_cache_entry *
 __mb_cache_entry_find(struct list_head *l, struct list_head *head,
 		      struct block_device *bdev, unsigned int key)
@@ -604,8 +600,6 @@ mb_cache_entry_find_next(struct mb_cache_entry *prev,
 	return ce;
 }
 
-#endif  /* !defined(MB_CACHE_INDEXES_COUNT) || (MB_CACHE_INDEXES_COUNT > 0) */
-
 static int __init init_mbcache(void)
 {
 	register_shrinker(&mb_cache_shrinker);
-- 
1.7.0.4

