Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab0GBOyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:54:11 -0400
Received: from poutre.nerim.net ([62.4.16.124]:52411 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab0GBOyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:54:09 -0400
Date: Fri, 2 Jul 2010 16:54:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] sysfs_chmod_file's attr can be const
Message-ID: <20100702165405.0a903769@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_chmod_file doesn't change the attribute it operates on, so this
attribute can be marked const.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c       |    3 ++-
 include/linux/sysfs.h |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.35-rc3.orig/fs/sysfs/file.c	2010-05-31 09:59:55.000000000 +0200
+++ linux-2.6.35-rc3/fs/sysfs/file.c	2010-07-02 14:09:45.000000000 +0200
@@ -593,7 +593,8 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_grou
  * @mode: file permissions.
  *
  */
-int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
+int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr,
+		     mode_t mode)
 {
 	struct sysfs_dirent *sd;
 	struct iattr newattrs;
--- linux-2.6.35-rc3.orig/include/linux/sysfs.h	2010-05-31 09:59:56.000000000 +0200
+++ linux-2.6.35-rc3/include/linux/sysfs.h	2010-07-02 16:52:21.000000000 +0200
@@ -136,8 +136,8 @@ int __must_check sysfs_create_file(struc
 				   const struct attribute *attr);
 int __must_check sysfs_create_files(struct kobject *kobj,
 				   const struct attribute **attr);
-int __must_check sysfs_chmod_file(struct kobject *kobj, struct attribute *attr,
-				  mode_t mode);
+int __must_check sysfs_chmod_file(struct kobject *kobj,
+				  const struct attribute *attr, mode_t mode);
 void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
 void sysfs_remove_files(struct kobject *kobj, const struct attribute **attr);
 
@@ -225,7 +225,7 @@ static inline int sysfs_create_files(str
 }
 
 static inline int sysfs_chmod_file(struct kobject *kobj,
-				   struct attribute *attr, mode_t mode)
+				   const struct attribute *attr, mode_t mode)
 {
 	return 0;
 }

-- 
Jean Delvare
