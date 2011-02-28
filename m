Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab1B1XsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:48:09 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:55224 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab1B1XsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:48:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=sasl; b=
	qE+Kyl8m76ubbJ0UGZP4fkKNJAyQ8rdTK8s5w2IUECmSZKJDUA6zrcOyatTi9eKJ
	mrzk7Cl2132uKT9hgza0xS/Qyda8zwvKSTEBuxPCYGfTF9cC/EAwOwlToW6GckA9
	9p0Hxep3wWkVF1r/waNMz4RDMl5qQ+XaKeYkb+nLzpI=
From: ntl@pobox.com
To: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Oren Laadan <orenl@cs.columbia.edu>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 08/10] Add generic '->checkpoint' f_op to ext filesystems
Date: Mon, 28 Feb 2011 17:40:30 -0600
Message-Id: <1298936432-29607-9-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298936432-29607-1-git-send-email-ntl@pobox.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
X-Pobox-Relay-ID: 6EE50614-4394-11E0-B8E5-AF401E47CF6F-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

This marks ext[234] as being checkpointable.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 fs/ext2/dir.c  |    3 +++
 fs/ext2/file.c |    6 ++++++
 fs/ext3/dir.c  |    3 +++
 fs/ext3/file.c |    3 +++
 fs/ext4/dir.c  |    3 +++
 fs/ext4/file.c |    6 ++++++
 6 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 2709b34..7aefb74 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -721,4 +721,7 @@ const struct file_operations ext2_dir_operations = {
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
 	.fsync		= ext2_fsync,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif
 };
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 49eec94..c8991c8 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -76,6 +76,9 @@ const struct file_operations ext2_file_operations = {
 	.fsync		= ext2_fsync,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif /* CONFIG_CHECKPOINT */
 };
 
 #ifdef CONFIG_EXT2_FS_XIP
@@ -91,6 +94,9 @@ const struct file_operations ext2_xip_file_operations = {
 	.open		= dquot_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif /* CONFIG_CHECKPOINT */
 };
 #endif
 
diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index e2e72c3..e2f5948 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -48,6 +48,9 @@ const struct file_operations ext3_dir_operations = {
 #endif
 	.fsync		= ext3_sync_file,	/* BKL held */
 	.release	= ext3_release_dir,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif
 };
 
 
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index f55df0e..2cf4ef2 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -68,6 +68,9 @@ const struct file_operations ext3_file_operations = {
 	.fsync		= ext3_sync_file,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif
 };
 
 const struct inode_operations ext3_file_inode_operations = {
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index ece76fb..0101873 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -48,6 +48,9 @@ const struct file_operations ext4_dir_operations = {
 #endif
 	.fsync		= ext4_sync_file,
 	.release	= ext4_release_dir,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif
 };
 
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 5a5c55d..142dde6 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -86,6 +86,9 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 static const struct vm_operations_struct ext4_file_vm_ops = {
 	.fault		= filemap_fault,
 	.page_mkwrite   = ext4_page_mkwrite,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= filemap_checkpoint,
+#endif
 };
 
 static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
@@ -188,6 +191,9 @@ const struct file_operations ext4_file_operations = {
 	.fsync		= ext4_sync_file,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+#ifdef CONFIG_CHECKPOINT
+	.checkpoint	= generic_file_checkpoint,
+#endif
 };
 
 const struct inode_operations ext4_file_inode_operations = {
-- 
1.7.4

