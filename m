Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919Ab0HEW0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:26:07 -0400
Received: from kroah.org ([198.145.64.141]:37760 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934501Ab0HEWYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/28] sysfs: sysfs_chmod_file's attr can be const
Date: Thu,  5 Aug 2010 15:24:03 -0700
Message-Id: <1281047058-23716-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

sysfs_chmod_file doesn't change the attribute it operates on, so this
attribute can be marked const.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c       |    3 ++-
 include/linux/sysfs.h |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1beaa73..1b27b56 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -593,7 +593,8 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
  * @mode: file permissions.
  *
  */
-int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
+int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr,
+		     mode_t mode)
 {
 	struct sysfs_dirent *sd;
 	struct iattr newattrs;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f2694eb..8bf06b6 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -136,8 +136,8 @@ int __must_check sysfs_create_file(struct kobject *kobj,
 				   const struct attribute *attr);
 int __must_check sysfs_create_files(struct kobject *kobj,
 				   const struct attribute **attr);
-int __must_check sysfs_chmod_file(struct kobject *kobj, struct attribute *attr,
-				  mode_t mode);
+int __must_check sysfs_chmod_file(struct kobject *kobj,
+				  const struct attribute *attr, mode_t mode);
 void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
 void sysfs_remove_files(struct kobject *kobj, const struct attribute **attr);
 
@@ -225,7 +225,7 @@ static inline int sysfs_create_files(struct kobject *kobj,
 }
 
 static inline int sysfs_chmod_file(struct kobject *kobj,
-				   struct attribute *attr, mode_t mode)
+				   const struct attribute *attr, mode_t mode)
 {
 	return 0;
 }
-- 
1.7.2

