Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab0G3RTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:19:34 -0400
Received: from kroah.org ([198.145.64.141]:51903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758699Ab0G3RT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:27 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:09 2010
Message-Id: <20100730171508.938610139@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [103/165] ext4: Code cleanup for EXT4_IOC_MOVE_EXT ioctl
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit c437b2733520599a2c6e0dbcdeae611319f84707 upstream (as of v2.6.33-git11)

a) Fix sparse warning in ext4_ioctl()
b) Remove unneeded variable in mext_leaf_block()
c) Fix spelling typo in mext_check_arguments()

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ioctl.c       |    3 ++-
 fs/ext4/move_extent.c |    4 +---
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -258,7 +258,8 @@ setversion_out:
 		if (me.moved_len > 0)
 			file_remove_suid(donor_filp);
 
-		if (copy_to_user((struct move_extent *)arg, &me, sizeof(me)))
+		if (copy_to_user((struct move_extent __user *)arg,
+				 &me, sizeof(me)))
 			err = -EFAULT;
 mext_out:
 		fput(donor_filp);
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -477,7 +477,6 @@ mext_leaf_block(handle_t *handle, struct
 	struct ext4_extent *oext, *o_start, *o_end, *prev_ext;
 	struct ext4_extent new_ext, start_ext, end_ext;
 	ext4_lblk_t new_ext_end;
-	ext4_fsblk_t new_phys_end;
 	int oext_alen, new_ext_alen, end_ext_alen;
 	int depth = ext_depth(orig_inode);
 	int ret;
@@ -491,7 +490,6 @@ mext_leaf_block(handle_t *handle, struct
 	new_ext.ee_len = dext->ee_len;
 	new_ext_alen = ext4_ext_get_actual_len(&new_ext);
 	new_ext_end = le32_to_cpu(new_ext.ee_block) + new_ext_alen - 1;
-	new_phys_end = ext_pblock(&new_ext) + new_ext_alen - 1;
 
 	/*
 	 * Case: original extent is first
@@ -932,7 +930,7 @@ out2:
 }
 
 /**
- * mext_check_argumants - Check whether move extent can be done
+ * mext_check_arguments - Check whether move extent can be done
  *
  * @orig_inode:		original inode
  * @donor_inode:	donor inode


