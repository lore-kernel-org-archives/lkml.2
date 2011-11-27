Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1K0Fd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:33:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab1K0Fdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:33:55 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Evgeniy Polyakov <zbr@ioremap.net>, Josef Bacik <josef@redhat.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org
Subject: [PATCH 24/62] pohmelfs: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:04 +0800
Message-Id: <1322371662-26166-25-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/staging/pohmelfs/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 7a19555..96a7ddd 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -606,11 +606,11 @@ static int pohmelfs_write_begin(struct file *file, struct address_space *mapping
 		}
 
 		if (len != PAGE_CACHE_SIZE) {
-			void *kaddr = kmap_atomic(page, KM_USER0);
+			void *kaddr = kmap_atomic(page);
 
 			memset(kaddr + start, 0, PAGE_CACHE_SIZE - start);
 			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 		}
 		SetPageUptodate(page);
 	}
@@ -636,11 +636,11 @@ static int pohmelfs_write_end(struct file *file, struct address_space *mapping,
 
 	if (copied != len) {
 		unsigned from = pos & (PAGE_CACHE_SIZE - 1);
-		void *kaddr = kmap_atomic(page, KM_USER0);
+		void *kaddr = kmap_atomic(page);
 
 		memset(kaddr + from + copied, 0, len - copied);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 	}
 
 	SetPageUptodate(page);
-- 
1.7.4.4

