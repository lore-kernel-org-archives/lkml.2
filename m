Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0LFWHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:07:45 -0500
Received: from mail.perches.com ([173.55.12.10]:2337 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab0LFWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/29] fs/sysfs: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:08 -0800
Message-Id: <229e6f51bac4fb437bd106c09b6f10a20a63f3f0.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.
Remove KERN_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/sysfs/dir.c     |    3 +--
 fs/sysfs/file.c    |    4 ++--
 fs/sysfs/group.c   |    4 ++--
 fs/sysfs/symlink.c |   10 ++++------
 4 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7e54bac..387cf47 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -444,8 +444,7 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 	ret = __sysfs_add_one(acxt, sd);
 	if (ret == -EEXIST) {
 		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
-		WARN(1, KERN_WARNING
-		     "sysfs: cannot create duplicate filename '%s'\n",
+		WARN(1, "sysfs: cannot create duplicate filename '%s'\n",
 		     (path == NULL) ? sd->s_name :
 		     strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
 		            sd->s_name));
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index da3fefe..c061516 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -351,8 +351,8 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (kobj->ktype && kobj->ktype->sysfs_ops)
 		ops = kobj->ktype->sysfs_ops;
 	else {
-		WARN(1, KERN_ERR "missing sysfs attribute operations for "
-		       "kobject: %s\n", kobject_name(kobj));
+		WARN(1, "missing sysfs attribute operations for kobject: %s\n",
+		     kobject_name(kobj));
 		goto err_out;
 	}
 
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index c8769dc..fa82099 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -134,8 +134,8 @@ void sysfs_remove_group(struct kobject * kobj,
 	if (grp->name) {
 		sd = sysfs_get_dirent(dir_sd, NULL, grp->name);
 		if (!sd) {
-			WARN(!sd, KERN_WARNING "sysfs group %p not found for "
-				"kobject '%s'\n", grp, kobject_name(kobj));
+			WARN(!sd, "sysfs group %p not found for kobject '%s'\n",
+			     grp, kobject_name(kobj));
 			return;
 		}
 	} else
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index a7ac78f..3169da8 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -75,12 +75,10 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 			error = __sysfs_add_one(&acxt, sd);
 	} else {
 		error = -EINVAL;
-		WARN(1, KERN_WARNING
-			"sysfs: symlink across ns_types %s/%s -> %s/%s\n",
-			parent_sd->s_name,
-			sd->s_name,
-			sd->s_symlink.target_sd->s_parent->s_name,
-			sd->s_symlink.target_sd->s_name);
+		WARN(1, "sysfs: symlink across ns_types %s/%s -> %s/%s\n",
+		     parent_sd->s_name, sd->s_name,
+		     sd->s_symlink.target_sd->s_parent->s_name,
+		     sd->s_symlink.target_sd->s_name);
 	}
 	sysfs_addrm_finish(&acxt);
 
-- 
1.7.3.2.245.g03276.dirty

