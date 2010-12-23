Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0LWRRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:17:06 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:61704 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab0LWRRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:17:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PlZU1ERHq3z95F8nUZURjCof8xq0PXTiySpAim1FHjCFFQz82hKG7YxLUT2yc0aTZ5
         Q1bmxL+WMbsm8FuftTReLdmjhvkpnvRA++hHWJsOwwAtMU4MJhaXop/RR9HjjfZOZmnH
         dTrTGHvqjzrw2gw268DGURQ6YC2+/ox+G2N6k=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] fs/char_dev.c: remove unused cdev_index()
Date: Fri, 24 Dec 2010 02:16:09 +0900
Message-Id: <1293124569-4036-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 66fa12c571d3 ("ieee1394: remove the old IEEE 1394 driver stack")
eliminated the only-user of cdev_index(). So it can be removed too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Theodore Ts'o <tytso@mit.edu>
---
 fs/char_dev.c        |   13 -------------
 include/linux/cdev.h |    2 --
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index e5b9df993b93..6e99b9ddd4e9 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -417,18 +417,6 @@ static int chrdev_open(struct inode *inode, struct file *filp)
 	return ret;
 }
 
-int cdev_index(struct inode *inode)
-{
-	int idx;
-	struct kobject *kobj;
-
-	kobj = kobj_lookup(cdev_map, inode->i_rdev, &idx);
-	if (!kobj)
-		return -1;
-	kobject_put(kobj);
-	return idx;
-}
-
 void cd_forget(struct inode *inode)
 {
 	spin_lock(&cdev_lock);
@@ -582,7 +570,6 @@ EXPORT_SYMBOL(cdev_init);
 EXPORT_SYMBOL(cdev_alloc);
 EXPORT_SYMBOL(cdev_del);
 EXPORT_SYMBOL(cdev_add);
-EXPORT_SYMBOL(cdev_index);
 EXPORT_SYMBOL(__register_chrdev);
 EXPORT_SYMBOL(__unregister_chrdev);
 EXPORT_SYMBOL(directly_mappable_cdev_bdi);
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index f389e319a454..fb4591977b03 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -28,8 +28,6 @@ int cdev_add(struct cdev *, dev_t, unsigned);
 
 void cdev_del(struct cdev *);
 
-int cdev_index(struct inode *inode);
-
 void cd_forget(struct inode *);
 
 extern struct backing_dev_info directly_mappable_cdev_bdi;
-- 
1.7.3.4.600.g982838b0

