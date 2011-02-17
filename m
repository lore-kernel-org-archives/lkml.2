Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1BQI7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 03:59:05 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34519 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1BQI7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 03:59:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Iv7zon1lQEDEI2Sf6hEyryseRHXooAftlTjSKjJYiy7+qFVnANi1pp11nAkUbFRQEq
         yKABDXtBp0Htmc/mi1qkBNsNqmEak8sBmahfZ1EGS7dKe1Tz6BoRr/EGtms4wwgpTfgV
         8t8CfNwV0JxQECln1R028aFqZzfeLdkQFA67E=
MIME-Version: 1.0
Date: Thu, 17 Feb 2011 16:59:02 +0800
Message-ID: <AANLkTi=50m7xULN+Mob1942b+qBEgMcqUPDWSd3inan6@mail.gmail.com>
Subject: [PATCH] code cleanup on fs/super.c
From: Steven Liu <lingjiujianke@gmail.com>
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        randy.dunlap@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dchinner@redhat.com, liuqi <liuqi@thunderst.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,


   Can this patch be fixed?

   Clean up the unsed code on fs/super.c, all filesystem using mount_bdev
   and mount_nodev to replace get_sb_bdev and get_sb_nodev.

Signed-off-by: LiuQi <lingjiujianke@gmail.com>
---
 fs/super.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 7e9dd4c..8272f26 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -843,22 +843,6 @@ error:
 }
 EXPORT_SYMBOL(mount_bdev);

-int get_sb_bdev(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
-	struct vfsmount *mnt)
-{
-	struct dentry *root;
-
-	root = mount_bdev(fs_type, flags, dev_name, data, fill_super);
-	if (IS_ERR(root))
-		return PTR_ERR(root);
-	mnt->mnt_root = root;
-	mnt->mnt_sb = root->d_sb;
-	return 0;
-}
-
-EXPORT_SYMBOL(get_sb_bdev);

 void kill_block_super(struct super_block *sb)
 {
@@ -897,21 +881,6 @@ struct dentry *mount_nodev(struct
file_system_type *fs_type,
 }
 EXPORT_SYMBOL(mount_nodev);

-int get_sb_nodev(struct file_system_type *fs_type,
-	int flags, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
-	struct vfsmount *mnt)
-{
-	struct dentry *root;
-
-	root = mount_nodev(fs_type, flags, data, fill_super);
-	if (IS_ERR(root))
-		return PTR_ERR(root);
-	mnt->mnt_root = root;
-	mnt->mnt_sb = root->d_sb;
-	return 0;
-}
-EXPORT_SYMBOL(get_sb_nodev);

 static int compare_single(struct super_block *s, void *p)
 {
-- 
1.6.5.2




Best Regards


Steven Liu
