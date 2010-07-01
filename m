Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab0GAUw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:52:59 -0400
Received: from kroah.org ([198.145.64.141]:47802 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab0GAUvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:06 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:37 2010
Message-Id: <20100701173436.999999983@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roberto Sassu <roberto.sassu@polito.it>, Eric Paris <eparis@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 121/164] wrong type for magic argument in simple_fill_super()
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Sassu <roberto.sassu@polito.it>

commit 7d683a09990ff095a91b6e724ecee0ff8733274a upstream.

It's used to superblock ->s_magic, which is unsigned long.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Reviewed-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/libfs.c         |    3 ++-
 include/linux/fs.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -415,7 +415,8 @@ int simple_write_end(struct file *file,
  * unique inode values later for this filesystem, then you must take care
  * to pass it an appropriate max_reserved value to avoid collisions.
  */
-int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files)
+int simple_fill_super(struct super_block *s, unsigned long magic,
+		      struct tree_descr *files)
 {
 	struct inode *inode;
 	struct dentry *root;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2359,7 +2359,7 @@ extern const struct file_operations simp
 extern const struct inode_operations simple_dir_inode_operations;
 struct tree_descr { char *name; const struct file_operations *ops; int mode; };
 struct dentry *d_alloc_name(struct dentry *, const char *);
-extern int simple_fill_super(struct super_block *, int, struct tree_descr *);
+extern int simple_fill_super(struct super_block *, unsigned long, struct tree_descr *);
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);
 


