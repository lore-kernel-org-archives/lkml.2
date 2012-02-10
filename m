Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2BJFq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:46:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932527Ab2BJFqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:46:22 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 44/60] squashfs: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:40:05 +0800
Message-Id: <1328852421-19678-45-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/squashfs/file.c    |    8 ++++----
 fs/squashfs/symlink.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index 38bb1c6..8ca62c2 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -464,10 +464,10 @@ static int squashfs_readpage(struct file *file, struct page *page)
 		if (PageUptodate(push_page))
 			goto skip_page;
 
-		pageaddr = kmap_atomic(push_page, KM_USER0);
+		pageaddr = kmap_atomic(push_page);
 		squashfs_copy_data(pageaddr, buffer, offset, avail);
 		memset(pageaddr + avail, 0, PAGE_CACHE_SIZE - avail);
-		kunmap_atomic(pageaddr, KM_USER0);
+		kunmap_atomic(pageaddr);
 		flush_dcache_page(push_page);
 		SetPageUptodate(push_page);
 skip_page:
@@ -484,9 +484,9 @@ skip_page:
 error_out:
 	SetPageError(page);
 out:
-	pageaddr = kmap_atomic(page, KM_USER0);
+	pageaddr = kmap_atomic(page);
 	memset(pageaddr, 0, PAGE_CACHE_SIZE);
-	kunmap_atomic(pageaddr, KM_USER0);
+	kunmap_atomic(pageaddr);
 	flush_dcache_page(page);
 	if (!PageError(page))
 		SetPageUptodate(page);
diff --git a/fs/squashfs/symlink.c b/fs/squashfs/symlink.c
index 1191817..12806df 100644
--- a/fs/squashfs/symlink.c
+++ b/fs/squashfs/symlink.c
@@ -90,14 +90,14 @@ static int squashfs_symlink_readpage(struct file *file, struct page *page)
 			goto error_out;
 		}
 
-		pageaddr = kmap_atomic(page, KM_USER0);
+		pageaddr = kmap_atomic(page);
 		copied = squashfs_copy_data(pageaddr + bytes, entry, offset,
 								length - bytes);
 		if (copied == length - bytes)
 			memset(pageaddr + length, 0, PAGE_CACHE_SIZE - length);
 		else
 			block = entry->next_index;
-		kunmap_atomic(pageaddr, KM_USER0);
+		kunmap_atomic(pageaddr);
 		squashfs_cache_put(entry);
 	}
 
-- 
1.7.7.6

