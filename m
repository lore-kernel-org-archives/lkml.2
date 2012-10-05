Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2JEMGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:06:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50532 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2JEMGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:06:10 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-2b-506ecd3190a3
From: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>
To: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com, jaegeuk.kim@samsung.com,
        jooyoung.hwang@samsung.com
Subject: [PATCH 16/16] f2fs: update Kconfig and Makefile
Date: Fri, 05 Oct 2012 21:06:09 +0900
Message-id: <001701cda2f1$ce1b3500$6a519f00$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2i8c4Br5zmiZDTTp6PwQeycscGNA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQV3Ds3kBBod3yVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MG68msBfskK14c62JrYHxhngXIyeHhICJxLV9q5ghbDGJC/fW
	s3UxcnEICUxnlGid+4gVwpnPJLF33zumLkYODjYBC4n2y+4gcRGBe4wSl5bNZALpFgaKT7u8
	lh3EZhFQlZi/6i4biM0rYCtx8vIcVghbUOLH5HssIHOYBdQlpkzJBQkzC8hLbF7zlhkkLAEU
	fvRXF8QUEdCTODYtE6JCRGLfi3eMExj5ZyGZMwthziwkc2Yh6VjAyLKKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIzj0nknvYFzVYHGIUYCDUYmHV+BZboAQa2JZcWXuIUYJDmYlEV7r2XkB
	QrwpiZVVqUX58UWlOanFhxilOViUxHmbPVIChATSE0tSs1NTC1KLYLJMHJxSDYxcS7Im7ona
	vKnhq9Xrva86XcvNfy8znZwvZWv0fZu5qcaqtlUZ+7+cPzWd/0FQlNFpLbtSzi8M3BHXdR0/
	Hd1s0d2z5Pya44dtMyTW3ehSOXrv0ySlxU/PrpBevLj58IXl0646lHJ05Jb9vT6HX33PtAV6
	XWvUDW/8PeNyLdboVcr9ZdyJ3m/SlFiKMxINtZiLihMBfAQmJDkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds Makefile and Kconfig for f2fs, and updates Makefile and Kconfig files
in the fs directory.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/Kconfig       |    1 +
 fs/Makefile      |    1 +
 fs/f2fs/Kconfig  |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/Makefile |    6 ++++++
 4 files changed, 63 insertions(+)
 create mode 100644 fs/f2fs/Kconfig
 create mode 100644 fs/f2fs/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index f95ae3a..e352b37 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -220,6 +220,7 @@ source "fs/pstore/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
+source "fs/f2fs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/Makefile b/fs/Makefile
index 2fb9779..e09edb5 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -122,6 +122,7 @@ obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_F2FS_FS)		+= f2fs/
 obj-y				+= exofs/ # Multiple modules
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
new file mode 100644
index 0000000..8821c6a
--- /dev/null
+++ b/fs/f2fs/Kconfig
@@ -0,0 +1,55 @@
+config F2FS_FS
+	tristate "F2FS filesystem support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  F2FS is based on Log-structured File System (LFS), which supports
+	  versatile "flash-friendly" features. The design has been focused on
+	  addressing the fundamental issues in LFS, which are snowball effect
+	  of wandering tree and high cleaning overhead.
+
+	  Since flash-based storages show different characteristics according to
+	  the internal geometry or flash memory management schemes aka FTL, F2FS
+	  and tools support various parameters not only for configuring on-disk
+	  layout, but also for selecting allocation and cleaning algorithms.
+
+	  If unsure, say N.
+
+config F2FS_STAT_FS
+	bool "F2FS Status Information"
+	depends on F2FS_FS
+	default y
+	help
+	  /proc/fs/f2fs/ contains information about partitions mounted as f2fs.
+	  For each partition, a corresponding directory, named as its device
+	  name, is provided with the following proc entries.
+
+	  f2fs_stat	major file system information managed by f2fs currently
+	  f2fs_sit_stat	average SIT information about whole segments
+	  f2fs_mem_stat	current memory footprint consumed by f2fs
+
+	  e.g., in /proc/fs/f2fs/sdb1/
+
+config F2FS_FS_XATTR
+	bool "F2FS extended attributes"
+	depends on F2FS_FS
+	default y
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  If unsure, say N.
+
+config F2FS_FS_POSIX_ACL
+	bool "F2FS Access Control Lists"
+	depends on F2FS_FS_XATTR
+	select FS_POSIX_ACL
+	default y
+	help
+	  Posix Access Control Lists (ACLs) support permissions for users and
+	  gourps beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the POSIX ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N
diff --git a/fs/f2fs/Makefile b/fs/f2fs/Makefile
new file mode 100644
index 0000000..72fcf9a
--- /dev/null
+++ b/fs/f2fs/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_F2FS_FS) += f2fs.o
+
+f2fs-y		:= dir.o file.o inode.o namei.o hash.o super.o
+f2fs-y		+= checkpoint.o gc.o data.o node.o segment.o recovery.o
+f2fs-$(CONFIG_F2FS_FS_XATTR) += xattr.o
+f2fs-$(CONFIG_F2FS_FS_POSIX_ACL) += acl.o
-- 
1.7.9.5




---
Jaegeuk Kim
Samsung



