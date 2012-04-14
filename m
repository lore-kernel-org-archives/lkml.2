Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab2DNQKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:10:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54926 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab2DNQKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:10:14 -0400
From: Subodh Nijsure <subodh.nijsure@gmail.com>
To: Subodh Nijsure <subodh.nijsure@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>
Subject: [PATCH 1/1] Remove UBIFS_FS_XATTR config option.
Date: Sat, 14 Apr 2012 09:09:57 -0700
Message-Id: <1334419797-28995-1-git-send-email-snijsure@grid-net.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CONFIG_UBIFS_FS_XATTR configuration option and associated
UBIFS_FS_XATTR ifdefs.

Testing:
       Tested using integck while using nandsim on x86 & MX28 based 
       platform with Micron MT29F2G08ABAEAH4 nand.

Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
---
 fs/ubifs/Kconfig   |    6 ------
 fs/ubifs/Makefile  |    3 +--
 fs/ubifs/dir.c     |    2 --
 fs/ubifs/file.c    |    2 --
 fs/ubifs/journal.c |    2 --
 5 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
index f8b0160..e49a23c 100644
--- a/fs/ubifs/Kconfig
+++ b/fs/ubifs/Kconfig
@@ -11,12 +11,6 @@ config UBIFS_FS
 	help
 	  UBIFS is a file system for flash devices which works on top of UBI.
 
-config UBIFS_FS_XATTR
-	bool "Extended attributes support"
-	depends on UBIFS_FS
-	help
-	  This option enables support of extended attributes.
-
 config UBIFS_FS_ADVANCED_COMPR
 	bool "Advanced compression options"
 	depends on UBIFS_FS
diff --git a/fs/ubifs/Makefile b/fs/ubifs/Makefile
index 80e93c3..4878614 100644
--- a/fs/ubifs/Makefile
+++ b/fs/ubifs/Makefile
@@ -3,7 +3,6 @@ obj-$(CONFIG_UBIFS_FS) += ubifs.o
 ubifs-y += shrinker.o journal.o file.o dir.o super.o sb.o io.o
 ubifs-y += tnc.o master.o scan.o replay.o log.o commit.o gc.o orphan.o
 ubifs-y += budget.o find.o tnc_commit.o compress.o lpt.o lprops.o
-ubifs-y += recovery.o ioctl.o lpt_commit.o tnc_misc.o
+ubifs-y += recovery.o ioctl.o lpt_commit.o tnc_misc.o xattr.o
 
 ubifs-$(CONFIG_UBIFS_FS_DEBUG) += debug.o
-ubifs-$(CONFIG_UBIFS_FS_XATTR) += xattr.o
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index ec9f187..ad6e550 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1187,12 +1187,10 @@ const struct inode_operations ubifs_dir_inode_operations = {
 	.rename      = ubifs_rename,
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
-#ifdef CONFIG_UBIFS_FS_XATTR
 	.setxattr    = ubifs_setxattr,
 	.getxattr    = ubifs_getxattr,
 	.listxattr   = ubifs_listxattr,
 	.removexattr = ubifs_removexattr,
-#endif
 };
 
 const struct file_operations ubifs_dir_operations = {
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 5c8f6dc..0fe640c 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1562,12 +1562,10 @@ const struct address_space_operations ubifs_file_address_operations = {
 const struct inode_operations ubifs_file_inode_operations = {
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
-#ifdef CONFIG_UBIFS_FS_XATTR
 	.setxattr    = ubifs_setxattr,
 	.getxattr    = ubifs_getxattr,
 	.listxattr   = ubifs_listxattr,
 	.removexattr = ubifs_removexattr,
-#endif
 };
 
 const struct inode_operations ubifs_symlink_inode_operations = {
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 2f438ab..bc75e9d 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -1267,7 +1267,6 @@ out_free:
 	return err;
 }
 
-#ifdef CONFIG_UBIFS_FS_XATTR
 
 /**
  * ubifs_jnl_delete_xattr - delete an extended attribute.
@@ -1462,4 +1461,3 @@ out_free:
 	return err;
 }
 
-#endif /* CONFIG_UBIFS_FS_XATTR */
-- 
1.7.5.4

