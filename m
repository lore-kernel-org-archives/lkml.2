Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0DLPRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:17:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:54592 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab0DLPRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:17:18 -0400
Date: Tue, 13 Apr 2010 00:16:40 +0900 (JST)
Message-Id: <20100413.001640.64700206.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes for 2.6.34
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 13 Apr 2010 00:16:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to grab the following fixes, only containing trivial ones.

Thanks!

Ryusuke Konishi
--
The following changes since commit 2eaa9cfdf33b8d7fb7aff27792192e0019ae8fc6:
  Linus Torvalds (1):
        Linux 2.6.34-rc3

Li Hong (2):
      nilfs2: fix a wrong type conversion in nilfs_ioctl()
      nilfs2: Remove an uninitialization warning in nilfs_btree_propagate_v()

Ryusuke Konishi (1):
      nilfs2: fix typo "numer" -> "number" in alloc.c

 fs/nilfs2/alloc.c |    2 +-
 fs/nilfs2/btree.c |    2 +-
 fs/nilfs2/ioctl.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 3f959f1..c2a1387 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -425,7 +425,7 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap))
-		printk(KERN_WARNING "%s: entry numer %llu already freed\n",
+		printk(KERN_WARNING "%s: entry number %llu already freed\n",
 		       __func__, (unsigned long long)req->pr_entry_nr);
 
 	nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 7cdd98b..76c38e3 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1879,7 +1879,7 @@ static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
 				   struct nilfs_btree_path *path,
 				   int level, struct buffer_head *bh)
 {
-	int maxlevel, ret;
+	int maxlevel = 0, ret;
 	struct nilfs_btree_node *parent;
 	struct inode *dat = nilfs_bmap_get_dat(&btree->bt_bmap);
 	__u64 ptr;
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 313d0a2..c446017 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -648,7 +648,7 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
-	void __user *argp = (void * __user *)arg;
+	void __user *argp = (void __user *)arg;
 
 	switch (cmd) {
 	case NILFS_IOCTL_CHANGE_CPMODE:
