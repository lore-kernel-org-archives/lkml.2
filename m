Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2JFIps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:45:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47460 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab2JFIpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:45:45 -0400
Message-ID: <506FEE2A.90002@gmail.com>
Date: Sat, 06 Oct 2012 10:39:06 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 21/22] mm: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 include/linux/mm.h |    1 -
 mm/truncate.c      |   23 -----------------------
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 311be90..7eebde6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -975,7 +975,6 @@ static inline void unmap_shared_mapping_range(struct address_space *mapping,
 
 extern void truncate_pagecache(struct inode *inode, loff_t old, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
-extern int vmtruncate(struct inode *inode, loff_t offset);
 void truncate_pagecache_range(struct inode *inode, loff_t offset, loff_t end);
 int truncate_inode_page(struct address_space *mapping, struct page *page);
 int generic_error_remove_page(struct address_space *mapping, struct page *page);
diff --git a/mm/truncate.c b/mm/truncate.c
index 75801ac..4e96354 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -580,29 +580,6 @@ void truncate_setsize(struct inode *inode, loff_t newsize)
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
