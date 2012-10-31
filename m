Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559Ab2JaJrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:47:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35150 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2JaJrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:47:03 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-0b-5090f3957c39
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
In-reply-to: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
Subject: [PATCH 11/17] f2fs: add inode operations for special inodes
Date: Wed, 31 Oct 2012 18:47:01 +0900
Message-id: <004801cdb74c$ad1ae1b0$0750a510$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac23SwwW/9IJbTdIRgmy8VWYLJ8GMwAAZEFw
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ92pnycEGCz7qW2xZ+9JFovLu+aw
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJUxc3EXS8G/5IqDbRuYGhhnBnYxcnJICJhI7Ou4xwhh
	i0lcuLeerYuRi0NIYBmjxMzps9lhipqvP2OFSCxilOg+tpYdwvnHKPHoyE+gFg4ONgFtic37
	DUDiIgIPGSX2P1sK1i0kYCvx9P41dpAaTgE7icsnIkDCwgIuEu1P57GC2CwCqhLfr9xhAinh
	BSnfKwwS5hUQlPgx+R4LiM0soC4xad4iZghbXmLzmrfMIOUSQPFHf3VBwiICRhLPnzcwQZSI
	S0x68JAdYrqAxLfJh1ggymUlNh1gBjlSQmARu8TjY/OgfpeUOLjiBssERvFZSDbPQrJ5FpLN
	s5CsWMDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjJJKkdjCubLA4xCjAwajEw2v4rz9A
	iDWxrLgy9xCjBAezkghv8qcJAUK8KYmVValF+fFFpTmpxYcYfYAun8gsJZqcD4zyvJJ4Q2Nj
	EzMTUxNzS1NzUxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYj7J/PH7zXEmjxGwTvfLV
	/JtN04pd/x86kLDt0/KE6FD3f183NyWVNvxNde3lfv8k7KFjUK3MtPj7M8pM444L9JyZlfV1
	8cP501Q7Dm9IlNjr4sB79GnAsyA+1e9LOQ7YJS6dLLz+8fptGfNeiZ4VLLN3fjxTXUy84mOs
	QrqbkFjh26U5P+2DlFiKMxINtZiLihMBrIJuNNECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t9jAd2pnycEGNzapWaxZ+9JFovLu+aw
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMXNxF0vBv+SK
	g20bmBoYZwZ2MXJySAiYSDRff8YKYYtJXLi3nq2LkYtDSGARo0T3sbXsEM4/RolHR34CZTg4
	2AS0JTbvNwCJiwg8ZJTY/2wpO0i3kICtxNP719hBajgF7CQun4gACQsLuEi0P50HtoBFQFXi
	+5U7TCAlvCDle4VBwrwCghI/Jt9jAbGZBdQlJs1bxAxhy0tsXvOWGaRcAij+6K8uSFhEwEji
	+fMGJogScYlJDx6yT2AUnIVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ
	+bmbGMFx+kxqB+PKBotDjAIcjEo8vIb/+gOEWBPLiitzDzFKcDArifAmf5oQIMSbklhZlVqU
	H19UmpNafIjRB+jPicxSosn5wBSSVxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEggPbEkNTs1
	tSC1CGYcEwenVAMjz+ynfo+EYvt2zJXU69u0bX/45+/cofvffgicd/LSvEmf/4p9T3TgnJD3
	2iTuiP/FE/45+Qdm+Uq7fFkdq3nK2YT3Yr+1uKTe9Y5YD73GS2d/+AeWRKrcUQoyre+yX8CX
	y+n6ddv0pYJvZrut+PXpXceksA0680MCZ53Ku79Kvfuz/4ePkvGRSizFGYmGWsxFxYkAfa7p
	EQADAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds inode operations for directory, symlink, and special inodes.

Signed-off-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/namei.c |  504 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 504 insertions(+)
 create mode 100644 fs/f2fs/namei.c

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
new file mode 100644
index 0000000..aec362f
--- /dev/null
+++ b/fs/f2fs/namei.c
@@ -0,0 +1,504 @@
+/**
+ * fs/f2fs/namei.c
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *             http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/fs.h>
+#include <linux/f2fs_fs.h>
+#include <linux/pagemap.h>
+#include <linux/sched.h>
+#include <linux/ctype.h>
+
+#include "f2fs.h"
+#include "xattr.h"
+#include "acl.h"
+
+static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
+{
+	struct super_block *sb = dir->i_sb;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	nid_t ino;
+	struct inode *inode;
+	bool nid_free = false;
+	int err;
+
+	inode = new_inode(sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock_op(sbi, NODE_NEW);
+	if (!alloc_nid(sbi, &ino)) {
+		mutex_unlock_op(sbi, NODE_NEW);
+		err = -ENOSPC;
+		goto fail;
+	}
+	mutex_unlock_op(sbi, NODE_NEW);
+
+	inode->i_uid = current_fsuid();
+
+	if (dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+	} else {
+		inode->i_gid = current_fsgid();
+	}
+
+	inode->i_ino = ino;
+	inode->i_mode = mode;
+	inode->i_blocks = 0;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	inode->i_generation = sbi->s_next_generation++;
+
+	err = insert_inode_locked(inode);
+	if (err) {
+		err = -EINVAL;
+		nid_free = true;
+		goto out;
+	}
+
+	mark_inode_dirty(inode);
+	return inode;
+
+out:
+	clear_nlink(inode);
+	unlock_new_inode(inode);
+fail:
+	iput(inode);
+	if (nid_free)
+		alloc_nid_failed(sbi, ino);
+	return ERR_PTR(err);
+}
+
+static int is_multimedia_file(const unsigned char *s, const char *sub)
+{
+	int slen = strlen(s);
+	int sublen = strlen(sub);
+	int ret;
+
+	if (sublen > slen)
+		return 1;
+
+	ret = memcmp(s + slen - sublen, sub, sublen);
+	if (ret) {	/* compare upper case */
+		int i;
+		char upper_sub[8];
+		for (i = 0; i < sublen && i < sizeof(upper_sub); i++)
+			upper_sub[i] = toupper(sub[i]);
+		return memcmp(s + slen - sublen, upper_sub, sublen);
+	}
+
+	return ret;
+}
+
+/**
+ * Set multimedia files as cold files for hot/cold data separation
+ */
+static inline void set_cold_file(struct f2fs_sb_info *sbi, struct inode *inode,
+		const unsigned char *name)
+{
+	int i;
+	__u8 (*extlist)[8] = sbi->raw_super->extension_list;
+
+	int count = le32_to_cpu(sbi->raw_super->extension_count);
+	for (i = 0; i < count; i++) {
+		if (!is_multimedia_file(name, extlist[i])) {
+			F2FS_I(inode)->i_advise |= FADVISE_COLD_BIT;
+			break;
+		}
+	}
+}
+
+static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
+						bool excl)
+{
+	struct super_block *sb = dir->i_sb;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	struct inode *inode;
+	nid_t ino = 0;
+	int err;
+
+	inode = f2fs_new_inode(dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	if (!test_opt(sbi, DISABLE_EXT_IDENTIFY))
+		set_cold_file(sbi, inode, dentry->d_name.name);
+
+	inode->i_op = &f2fs_file_inode_operations;
+	inode->i_fop = &f2fs_file_operations;
+	inode->i_mapping->a_ops = &f2fs_dblock_aops;
+	ino = inode->i_ino;
+
+	err = f2fs_add_link(dentry, inode);
+	if (err)
+		goto out;
+
+	alloc_nid_done(sbi, ino);
+
+	if (!sbi->por_doing)
+		d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	f2fs_balance_fs(sbi);
+	return 0;
+out:
+	clear_nlink(inode);
+	unlock_new_inode(inode);
+	iput(inode);
+	alloc_nid_failed(sbi, ino);
+	return err;
+}
+
+static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
+		struct dentry *dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+	struct super_block *sb = dir->i_sb;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	int err;
+
+	inode->i_ctime = CURRENT_TIME;
+	atomic_inc(&inode->i_count);
+
+	set_inode_flag(F2FS_I(inode), FI_INC_LINK);
+	err = f2fs_add_link(dentry, inode);
+	if (err)
+		goto out;
+
+	d_instantiate(dentry, inode);
+
+	f2fs_balance_fs(sbi);
+	return 0;
+out:
+	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
+	iput(inode);
+	return err;
+}
+
+struct dentry *f2fs_get_parent(struct dentry *child)
+{
+	struct qstr dotdot = QSTR_INIT("..", 2);
+	unsigned long ino = f2fs_inode_by_name(child->d_inode, &dotdot);
+	if (!ino)
+		return ERR_PTR(-ENOENT);
+	return d_obtain_alias(f2fs_iget(child->d_inode->i_sb, ino));
+}
+
+static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
+		unsigned int flags)
+{
+	struct inode *inode = NULL;
+	struct f2fs_dir_entry *de;
+	struct page *page;
+
+	if (dentry->d_name.len > F2FS_MAX_NAME_LEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	de = f2fs_find_entry(dir, &dentry->d_name, &page);
+	if (de) {
+		nid_t ino = le32_to_cpu(de->ino);
+		kunmap(page);
+		f2fs_put_page(page, 0);
+
+		inode = f2fs_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
+	}
+
+	return d_splice_alias(inode, dentry);
+}
+
+static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct super_block *sb = dir->i_sb;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	struct inode *inode = dentry->d_inode;
+	struct f2fs_dir_entry *de;
+	struct page *page;
+	int err = -ENOENT;
+
+	de = f2fs_find_entry(dir, &dentry->d_name, &page);
+	if (!de)
+		goto fail;
+
+	err = check_orphan_space(sbi);
+	if (err) {
+		kunmap(page);
+		f2fs_put_page(page, 0);
+		goto fail;
+	}
+
+	f2fs_delete_entry(de, page, inode);
+
+	/* In order to evict this inode,  we set it dirty */
+	mark_inode_dirty(inode);
+	f2fs_balance_fs(sbi);
+fail:
+	return err;
+}
+
+static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
+					const char *symname)
+{
+	struct super_block *sb = dir->i_sb;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	struct inode *inode;
+	unsigned symlen = strlen(symname) + 1;
+	int err;
+
+	inode = f2fs_new_inode(dir, S_IFLNK | S_IRWXUGO);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	inode->i_op = &f2fs_symlink_inode_operations;
+	inode->i_mapping->a_ops = &f2fs_dblock_aops;
+
+	err = f2fs_add_link(dentry, inode);
+	if (err)
+		goto out;
+
+	err = page_symlink(inode, symname, symlen);
+	alloc_nid_done(sbi, inode->i_ino);
+
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	f2fs_balance_fs(sbi);
+
+	return err;
+out:
+	clear_nlink(inode);
+	unlock_new_inode(inode);
+	iput(inode);
+	alloc_nid_failed(sbi, inode->i_ino);
+	return err;
+}
+
+static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct inode *inode;
+	int err;
+
+	inode = f2fs_new_inode(dir, S_IFDIR | mode);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		return err;
+
+	inode->i_op = &f2fs_dir_inode_operations;
+	inode->i_fop = &f2fs_dir_operations;
+	inode->i_mapping->a_ops = &f2fs_dblock_aops;
+	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS | __GFP_ZERO);
+
+	set_inode_flag(F2FS_I(inode), FI_INC_LINK);
+	err = f2fs_add_link(dentry, inode);
+	if (err)
+		goto out_fail;
+
+	alloc_nid_done(sbi, inode->i_ino);
+
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	f2fs_balance_fs(sbi);
+	return 0;
+
+out_fail:
+	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
+	clear_nlink(inode);
+	unlock_new_inode(inode);
+	iput(inode);
+	alloc_nid_failed(sbi, inode->i_ino);
+	return err;
+}
+
+static int f2fs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	if (f2fs_empty_dir(inode))
+		return f2fs_unlink(dir, dentry);
+	return -ENOTEMPTY;
+}
+
+static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
+				umode_t mode, dev_t rdev)
+{
+	struct super_block *sb = dir->i_sb;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	struct inode *inode;
+	int err = 0;
+
+	if (!new_valid_dev(rdev))
+		return -EINVAL;
+
+	inode = f2fs_new_inode(dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	init_special_inode(inode, inode->i_mode, rdev);
+	inode->i_op = &f2fs_special_inode_operations;
+
+	err = f2fs_add_link(dentry, inode);
+	if (err)
+		goto out;
+
+	alloc_nid_done(sbi, inode->i_ino);
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	f2fs_balance_fs(sbi);
+
+	return 0;
+out:
+	clear_nlink(inode);
+	unlock_new_inode(inode);
+	iput(inode);
+	alloc_nid_failed(sbi, inode->i_ino);
+	return err;
+}
+
+static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct super_block *sb = old_dir->i_sb;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	struct page *old_dir_page;
+	struct page *old_page;
+	struct f2fs_dir_entry *old_dir_entry = NULL;
+	struct f2fs_dir_entry *old_entry;
+	struct f2fs_dir_entry *new_entry;
+	int err = -ENOENT;
+
+	old_entry = f2fs_find_entry(old_dir, &old_dentry->d_name, &old_page);
+	if (!old_entry)
+		goto out;
+
+	if (S_ISDIR(old_inode->i_mode)) {
+		err = -EIO;
+		old_dir_entry = f2fs_parent_dir(old_inode, &old_dir_page);
+		if (!old_dir_entry)
+			goto out_old;
+	}
+
+	mutex_lock_op(sbi, RENAME);
+
+	if (new_inode) {
+		struct page *new_page;
+
+		err = -ENOTEMPTY;
+		if (old_dir_entry && !f2fs_empty_dir(new_inode))
+			goto out_dir;
+
+		err = -ENOENT;
+		new_entry = f2fs_find_entry(new_dir, &new_dentry->d_name,
+						&new_page);
+		if (!new_entry)
+			goto out_dir;
+
+		f2fs_set_link(new_dir, new_entry, new_page, old_inode);
+
+		new_inode->i_ctime = CURRENT_TIME;
+		if (old_dir_entry)
+			drop_nlink(new_inode);
+		drop_nlink(new_inode);
+		if (!new_inode->i_nlink)
+			add_orphan_inode(sbi, new_inode->i_ino);
+		f2fs_write_inode(new_inode, NULL);
+	} else {
+		err = f2fs_add_link(new_dentry, old_inode);
+		if (err)
+			goto out_dir;
+
+		if (old_dir_entry) {
+			inc_nlink(new_dir);
+			f2fs_write_inode(new_dir, NULL);
+		}
+	}
+
+	old_inode->i_ctime = CURRENT_TIME;
+	set_inode_flag(F2FS_I(old_inode), FI_NEED_CP);
+	mark_inode_dirty(old_inode);
+
+	f2fs_delete_entry(old_entry, old_page, NULL);
+
+	if (old_dir_entry) {
+		if (old_dir != new_dir) {
+			f2fs_set_link(old_inode, old_dir_entry,
+						old_dir_page, new_dir);
+		} else {
+			kunmap(old_dir_page);
+			f2fs_put_page(old_dir_page, 0);
+		}
+		drop_nlink(old_dir);
+		f2fs_write_inode(old_dir, NULL);
+	}
+
+	mutex_unlock_op(sbi, RENAME);
+
+	f2fs_balance_fs(sbi);
+	return 0;
+
+out_dir:
+	if (old_dir_entry) {
+		kunmap(old_dir_page);
+		f2fs_put_page(old_dir_page, 0);
+	}
+	mutex_unlock_op(sbi, RENAME);
+out_old:
+	kunmap(old_page);
+	f2fs_put_page(old_page, 0);
+out:
+	return err;
+}
+
+const struct inode_operations f2fs_dir_inode_operations = {
+	.create		= f2fs_create,
+	.lookup		= f2fs_lookup,
+	.link		= f2fs_link,
+	.unlink		= f2fs_unlink,
+	.symlink	= f2fs_symlink,
+	.mkdir		= f2fs_mkdir,
+	.rmdir		= f2fs_rmdir,
+	.mknod		= f2fs_mknod,
+	.rename		= f2fs_rename,
+	.setattr	= f2fs_setattr,
+	.get_acl	= f2fs_get_acl,
+#ifdef CONFIG_F2FS_FS_XATTR
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= f2fs_listxattr,
+	.removexattr	= generic_removexattr,
+#endif
+};
+
+const struct inode_operations f2fs_symlink_inode_operations = {
+	.readlink       = generic_readlink,
+	.follow_link    = page_follow_link_light,
+	.put_link       = page_put_link,
+	.setattr	= f2fs_setattr,
+#ifdef CONFIG_F2FS_FS_XATTR
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= f2fs_listxattr,
+	.removexattr	= generic_removexattr,
+#endif
+};
+
+const struct inode_operations f2fs_special_inode_operations = {
+	.setattr        = f2fs_setattr,
+	.get_acl	= f2fs_get_acl,
+#ifdef CONFIG_F2FS_FS_XATTR
+	.setxattr       = generic_setxattr,
+	.getxattr       = generic_getxattr,
+	.listxattr	= f2fs_listxattr,
+	.removexattr    = generic_removexattr,
+#endif
+};
-- 
1.7.9.5




---
Jaegeuk Kim
Samsung


