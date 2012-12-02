Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab2LBNLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 08:11:40 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44064 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2LBNLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 08:11:39 -0500
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 08:11:38 -0500
Message-ID: <CAPgLHd8mkXPE7E3AhxHAS91ddnmYSM3uOqXao4mDkEDRw8bQWw@mail.gmail.com>
Subject: [PATCH -next] f2fs: remove unused variable
From: Wei Yongjun <weiyj.lk@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variables node_page and page_offset are initialized but never used
otherwise, so remove those unused variables.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/f2fs/file.c | 2 --
 fs/f2fs/dir.c  | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f5ae36d..69e05c6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -30,7 +30,6 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	struct page *page = vmf->page;
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct page *node_page;
 	block_t old_blk_addr;
 	struct dnode_of_data dn;
 	int err;
@@ -50,7 +49,6 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	}
 
 	old_blk_addr = dn.data_blkaddr;
-	node_page = dn.node_page;
 
 	if (old_blk_addr == NULL_ADDR) {
 		err = reserve_new_block(&dn);

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 5975568..6891e45 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -509,13 +509,11 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	}
 
 	if (bit_pos == NR_DENTRY_IN_BLOCK) {
-		loff_t page_offset;
 		truncate_hole(dir, page->index, page->index + 1);
 		clear_page_dirty_for_io(page);
 		ClearPageUptodate(page);
 		dec_page_count(sbi, F2FS_DIRTY_DENTS);
 		inode_dec_dirty_dents(dir);
-		page_offset = page->index << PAGE_CACHE_SHIFT;
 		f2fs_put_page(page, 1);
 	} else {
 		f2fs_put_page(page, 1);


