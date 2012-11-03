Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2KCJi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:38:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60704 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2KCJiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:38:55 -0400
Message-ID: <5094E4A3.8020409@gmail.com>
Date: Sat, 03 Nov 2012 10:32:19 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/21] mm: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 include/linux/mm.h |    1 -
 mm/truncate.c      |   23 -----------------------
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa06804..95f70bb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -977,7 +977,6 @@ static inline void unmap_shared_mapping_range(struct address_space *mapping,
 
 extern void truncate_pagecache(struct inode *inode, loff_t old, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
-extern int vmtruncate(struct inode *inode, loff_t offset);
 void truncate_pagecache_range(struct inode *inode, loff_t offset, loff_t end);
 int truncate_inode_page(struct address_space *mapping, struct page *page);
 int generic_error_remove_page(struct address_space *mapping, struct page *page);
diff --git a/mm/truncate.c b/mm/truncate.c
index d51ce92..c75b736 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -577,29 +577,6 @@ void truncate_setsize(struct inode *inode, loff_t newsize)
 EXPORT_SYMBOL(truncate_setsize);
 
 /**
- * vmtruncate - unmap mappings "freed" by truncate() syscall
- * @inode: inode of the file used
- * @newsize: file offset to start truncating
- *
- * This function is deprecated and truncate_setsize or truncate_pagecache
- * should be used instead, together with filesystem specific block truncation.
- */
-int vmtruncate(struct inode *inode, loff_t newsize)
-{
-	int error;
-
-	error = inode_newsize_ok(inode, newsize);
-	if (error)
-		return error;
-
-	truncate_setsize(inode, newsize);
-	if (inode->i_op->truncate)
-		inode->i_op->truncate(inode);
-	return 0;
-}
-EXPORT_SYMBOL(vmtruncate);
-
-/**
  * truncate_pagecache_range - unmap and remove pagecache that is hole-punched
  * @inode: inode
  * @lstart: offset of beginning of hole
-- 
1.7.3.4
