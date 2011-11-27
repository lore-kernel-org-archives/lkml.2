Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1K0Fei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:34:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab1K0Fef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:34:35 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <kirkland@canonical.com>, ecryptfs@vger.kernel.org
Subject: [PATCH 31/62] ecryptfs: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:11 +0800
Message-Id: <1322371662-26166-32-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/ecryptfs/mmap.c       |    4 ++--
 fs/ecryptfs/read_write.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 6a44148..5e29bf4 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -146,7 +146,7 @@ ecryptfs_copy_up_encrypted_with_header(struct page *page,
 			/* This is a header extent */
 			char *page_virt;
 
-			page_virt = kmap_atomic(page, KM_USER0);
+			page_virt = kmap_atomic(page);
 			memset(page_virt, 0, PAGE_CACHE_SIZE);
 			/* TODO: Support more than one header extent */
 			if (view_extent_num == 0) {
@@ -159,7 +159,7 @@ ecryptfs_copy_up_encrypted_with_header(struct page *page,
 							       crypt_stat,
 							       &written);
 			}
-			kunmap_atomic(page_virt, KM_USER0);
+			kunmap_atomic(page_virt);
 			flush_dcache_page(page);
 			if (rc) {
 				printk(KERN_ERR "%s: Error reading xattr "
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 3745f7c..102719c8 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -151,7 +151,7 @@ int ecryptfs_write(struct inode *ecryptfs_inode, char *data, loff_t offset,
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
+		ecryptfs_page_virt = kmap_atomic(ecryptfs_page);
 
 		/*
 		 * pos: where we're now writing, offset: where the request was
@@ -174,7 +174,7 @@ int ecryptfs_write(struct inode *ecryptfs_inode, char *data, loff_t offset,
 			       (data + data_offset), num_bytes);
 			data_offset += num_bytes;
 		}
-		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
+		kunmap_atomic(ecryptfs_page_virt);
 		flush_dcache_page(ecryptfs_page);
 		SetPageUptodate(ecryptfs_page);
 		unlock_page(ecryptfs_page);
@@ -330,11 +330,11 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
+		ecryptfs_page_virt = kmap_atomic(ecryptfs_page);
 		memcpy((data + data_offset),
 		       ((char *)ecryptfs_page_virt + start_offset_in_page),
 		       num_bytes);
-		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
+		kunmap_atomic(ecryptfs_page_virt);
 		flush_dcache_page(ecryptfs_page);
 		SetPageUptodate(ecryptfs_page);
 		unlock_page(ecryptfs_page);
-- 
1.7.4.4

