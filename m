Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1AKAXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:23:38 -0500
Received: from kroah.org ([198.145.64.141]:45162 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003Ab1AKAXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:23:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Dan Carpenter <error27@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/4] sysfs: remove useless test from sysfs_merge_group
Date: Mon, 10 Jan 2011 16:23:24 -0800
Message-Id: <1294705405-31471-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110110234825.GA30018@kroah.com>
References: <20110110234825.GA30018@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

Dan Carpenter pointed out that the new sysfs_merge_group() and
sysfs_unmerge_group() routines requires their grp argument to be
non-NULL, because they dereference grp to obtain the list of
attributes.  Hence it's pointless for the routines to include a test
and special-case handling for when grp is NULL.  This patch (as1433)
removes the unneeded tests.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Dan Carpenter <error27@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/group.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 442f34f..c8769dc 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -165,10 +165,7 @@ int sysfs_merge_group(struct kobject *kobj,
 	struct attribute *const *attr;
 	int i;
 
-	if (grp)
-		dir_sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
-	else
-		dir_sd = sysfs_get(kobj->sd);
+	dir_sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
 	if (!dir_sd)
 		return -ENOENT;
 
@@ -195,10 +192,7 @@ void sysfs_unmerge_group(struct kobject *kobj,
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
-- 
1.7.3.2

