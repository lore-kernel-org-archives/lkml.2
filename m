Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab0KOUqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:46:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55849 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758303Ab0KOUqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:46:08 -0500
Date: Mon, 15 Nov 2010 15:46:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Dan Carpenter <error27@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: remove useless test from sysfs_merge_group
Message-ID: <Pine.LNX.4.44L0.1011151544470.1370-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter pointed out that the new sysfs_merge_group() and
sysfs_unmerge_group() routines requires their grp argument to be
non-NULL, because they dereference grp to obtain the list of
attributes.  Hence it's pointless for the routines to include a test
and special-case handling for when grp is NULL.  This patch (as1433)
removes the unneeded tests.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Dan Carpenter <error27@gmail.com>

---

Index: usb-2.6/fs/sysfs/group.c
===================================================================
--- usb-2.6.orig/fs/sysfs/group.c
+++ usb-2.6/fs/sysfs/group.c
@@ -165,10 +165,7 @@ int sysfs_merge_group(struct kobject *ko
 	struct attribute *const *attr;
 	int i;
 
-	if (grp)
-		dir_sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
-	else
-		dir_sd = sysfs_get(kobj->sd);
+	dir_sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
 	if (!dir_sd)
 		return -ENOENT;
 
@@ -195,10 +192,7 @@ void sysfs_unmerge_group(struct kobject 
 	struct sysfs_dirent *dir_sd;
 	struct attribute *const *attr;
 
-	if (grp)
-		dir_sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
-	else
-		dir_sd = sysfs_get(kobj->sd);
+	dir_sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
 	if (dir_sd) {
 		for (attr = grp->attrs; *attr; ++attr)
 			sysfs_hash_and_remove(dir_sd, NULL, (*attr)->name);

