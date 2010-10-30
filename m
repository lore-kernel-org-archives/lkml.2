Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0J3VMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:12:37 -0400
Received: from mail.perches.com ([173.55.12.10]:3782 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab0J3VJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:42 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 26/39] fs/sysfs: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:43 -0700
Message-Id: <5f8327b00ccd677bb0818ba1eab1ca92c08122a9.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
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
index 442f34f..dc22d5b 100644
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
1.7.3.1.g432b3.dirty

