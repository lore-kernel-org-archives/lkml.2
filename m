Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1BISP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 13:15:26 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:50833
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754872Ab1BISPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 13:15:25 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: tigran@aivazian.fsnet.co.uk
Cc: linux-kernel@vger.kernel.org, Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: [PATCH] bfs: fixed some coding style issues
Date: Wed,  9 Feb 2011 19:15:11 +0100
Message-Id: <1297275311-7489-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4
X-Null-Tag: a880c44847978ab388e55c81df2204d1
X-Authenticated-Sender: user tvh from 86.103.159.96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following coding style issues:
WARNING: please, no spaces at the start of a line
ERROR: code indent should use tabs where possible
ERROR: trailing whitespace
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
ERROR: trailing statements should be on next line

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 fs/bfs/dir.c   |   14 +++++++-------
 fs/bfs/file.c  |   14 +++++++-------
 fs/bfs/inode.c |   22 ++++++++++++----------
 3 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 685ecff..08fb186 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -72,7 +72,7 @@ static int bfs_readdir(struct file *f, void *dirent, filldir_t filldir)
 	}
 
 	mutex_unlock(&info->bfs_lock);
-	return 0;	
+	return 0;
 }
 
 const struct file_operations bfs_dir_operations = {
@@ -116,7 +116,7 @@ static int bfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	BFS_I(inode)->i_sblock = 0;
 	BFS_I(inode)->i_eblock = 0;
 	insert_inode_hash(inode);
-        mark_inode_dirty(inode);
+	mark_inode_dirty(inode);
 	dump_imap("create", s);
 
 	err = bfs_add_entry(dir, dentry->d_name.name, dentry->d_name.len,
@@ -232,8 +232,8 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	info = BFS_SB(old_inode->i_sb);
 
 	mutex_lock(&info->bfs_lock);
-	old_bh = bfs_find_entry(old_dir, 
-				old_dentry->d_name.name, 
+	old_bh = bfs_find_entry(old_dir,
+				old_dentry->d_name.name,
 				old_dentry->d_name.len, &old_de);
 
 	if (!old_bh || (le16_to_cpu(old_de->ino) != old_inode->i_ino))
@@ -241,8 +241,8 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	error = -EPERM;
 	new_inode = new_dentry->d_inode;
-	new_bh = bfs_find_entry(new_dir, 
-				new_dentry->d_name.name, 
+	new_bh = bfs_find_entry(new_dir,
+				new_dentry->d_name.name,
 				new_dentry->d_name.len, &new_de);
 
 	if (new_bh && !new_inode) {
@@ -250,7 +250,7 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		new_bh = NULL;
 	}
 	if (!new_bh) {
-		error = bfs_add_entry(new_dir, 
+		error = bfs_add_entry(new_dir,
 					new_dentry->d_name.name,
 					new_dentry->d_name.len,
 					old_inode->i_ino);
diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index eb67edd..35488fc 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -22,7 +22,7 @@
 #endif
 
 const struct file_operations bfs_file_operations = {
-	.llseek 	= generic_file_llseek,
+	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
 	.write		= do_sync_write,
@@ -54,7 +54,7 @@ static int bfs_move_blocks(struct super_block *sb, unsigned long start,
 
 	dprintf("%08lx-%08lx->%08lx\n", start, end, where);
 	for (i = start; i <= end; i++)
-		if(bfs_move_block(i, where + i, sb)) {
+		if (bfs_move_block(i, where + i, sb)) {
 			dprintf("failed to move block %08lx -> %08lx\n", i,
 								where + i);
 			return -EIO;
@@ -75,7 +75,7 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 	if (!create) {
 		if (phys <= bi->i_eblock) {
 			dprintf("c=%d, b=%08lx, phys=%09lx (granted)\n",
-                                create, (unsigned long)block, phys);
+					create, (unsigned long)block, phys);
 			map_bh(bh_result, sb, phys);
 		}
 		return 0;
@@ -86,7 +86,7 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 	 * range of blocks allocated for this file, we can grant it.
 	 */
 	if (bi->i_sblock && (phys <= bi->i_eblock)) {
-		dprintf("c=%d, b=%08lx, phys=%08lx (interim block granted)\n", 
+		dprintf("c=%d, b=%08lx, phys=%08lx (interim block granted)\n",
 				create, (unsigned long)block, phys);
 		map_bh(bh_result, sb, phys);
 		return 0;
@@ -105,7 +105,7 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 	 * anywhere.
 	 */
 	if (bi->i_eblock == info->si_lf_eblk) {
-		dprintf("c=%d, b=%08lx, phys=%08lx (simple extension)\n", 
+		dprintf("c=%d, b=%08lx, phys=%08lx (simple extension)\n",
 				create, (unsigned long)block, phys);
 		map_bh(bh_result, sb, phys);
 		info->si_freeb -= phys - bi->i_eblock;
@@ -123,7 +123,7 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 	}
 
 	if (bi->i_sblock) {
-		err = bfs_move_blocks(inode->i_sb, bi->i_sblock, 
+		err = bfs_move_blocks(inode->i_sb, bi->i_sblock,
 						bi->i_eblock, phys);
 		if (err) {
 			dprintf("failed to move ino=%08lx -> fs corruption\n",
@@ -134,7 +134,7 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 		err = 0;
 
 	dprintf("c=%d, b=%08lx, phys=%08lx (moved)\n",
-                create, (unsigned long)block, phys);
+			create, (unsigned long)block, phys);
 	bi->i_sblock = phys;
 	phys += block;
 	info->si_lf_eblk = bi->i_eblock = phys;
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index a8e37f8..a370e55 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -15,7 +15,7 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/writeback.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "bfs.h"
 
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
@@ -97,7 +97,8 @@ error:
 	return ERR_PTR(-EIO);
 }
 
-static struct bfs_inode *find_inode(struct super_block *sb, u16 ino, struct buffer_head **p)
+static struct bfs_inode *find_inode(struct super_block *sb,
+		u16 ino, struct buffer_head **p)
 {
 	if ((ino < BFS_ROOT_INO) || (ino > BFS_SB(sb)->si_lasti)) {
 		printf("Bad inode number %s:%08x\n", sb->s_id, ino);
@@ -119,12 +120,12 @@ static int bfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct bfs_sb_info *info = BFS_SB(inode->i_sb);
 	unsigned int ino = (u16)inode->i_ino;
-        unsigned long i_sblock;
+	unsigned long i_sblock;
 	struct bfs_inode *di;
 	struct buffer_head *bh;
 	int err = 0;
 
-        dprintf("ino=%08x\n", ino);
+	dprintf("ino=%08x\n", ino);
 
 	di = find_inode(inode->i_sb, ino, &bh);
 	if (IS_ERR(di))
@@ -145,7 +146,7 @@ static int bfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	di->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
 	di->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
 	di->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
-        i_sblock = BFS_I(inode)->i_sblock;
+	i_sblock = BFS_I(inode)->i_sblock;
 	di->i_sblock = cpu_to_le32(i_sblock);
 	di->i_eblock = cpu_to_le32(BFS_I(inode)->i_eblock);
 	di->i_eoffset = cpu_to_le32(i_sblock * BFS_BSIZE + inode->i_size - 1);
@@ -189,13 +190,13 @@ static void bfs_evict_inode(struct inode *inode)
 	mark_buffer_dirty(bh);
 	brelse(bh);
 
-        if (bi->i_dsk_ino) {
+	if (bi->i_dsk_ino) {
 		if (bi->i_sblock)
 			info->si_freeb += bi->i_eblock + 1 - bi->i_sblock;
 		info->si_freei++;
 		clear_bit(ino, info->si_imap);
 		dump_imap("delete_inode", s);
-        }
+	}
 
 	/*
 	 * If this was the last file, make the previous block
@@ -302,7 +303,8 @@ void dump_imap(const char *prefix, struct super_block *s)
 	if (!tmpbuf)
 		return;
 	for (i = BFS_SB(s)->si_lasti; i >= 0; i--) {
-		if (i > PAGE_SIZE - 100) break;
+		if (i > PAGE_SIZE - 100)
+			break;
 		if (test_bit(i, BFS_SB(s)->si_imap))
 			strcat(tmpbuf, "1");
 		else
@@ -338,7 +340,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	bfs_sb = (struct bfs_super_block *)sbh->b_data;
 	if (le32_to_cpu(bfs_sb->s_magic) != BFS_MAGIC) {
 		if (!silent)
-			printf("No BFS filesystem on %s (magic=%08x)\n", 
+			printf("No BFS filesystem on %s (magic=%08x)\n",
 				s->s_id,  le32_to_cpu(bfs_sb->s_magic));
 		goto out1;
 	}
@@ -476,7 +478,7 @@ static int __init init_bfs_fs(void)
 	int err = init_inodecache();
 	if (err)
 		goto out1;
-        err = register_filesystem(&bfs_fs_type);
+	err = register_filesystem(&bfs_fs_type);
 	if (err)
 		goto out;
 	return 0;
-- 
1.7.4

