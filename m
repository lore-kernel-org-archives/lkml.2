Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0IWGwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:52:42 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:40391 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873Ab0IWGwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:52:39 -0400
From: matt mooney <mfm@muteddisk.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Sage Weil <sage@newdream.net>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Altaparmakov <aia21@cantab.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 19/20] fs: change to new flag variable
Date: Wed, 22 Sep 2010 23:51:48 -0700
Message-Id: <1285224708-30103-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y. And change ntfs-objs to ntfs-y
for cleaner conditional inclusion.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 fs/affs/Makefile        |    2 +-
 fs/coda/Makefile        |    2 +-
 fs/gfs2/Makefile        |    2 +-
 fs/jfs/Makefile         |    2 +-
 fs/ncpfs/Makefile       |    2 +-
 fs/ntfs/Makefile        |   19 +++++++------------
 fs/ocfs2/Makefile       |    4 ++--
 fs/ocfs2/dlm/Makefile   |    2 +-
 fs/ocfs2/dlmfs/Makefile |    2 +-
 fs/reiserfs/Makefile    |    4 +---
 fs/smbfs/Makefile       |   12 ++++++------
 fs/xfs/Makefile         |    7 ++-----
 12 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/fs/affs/Makefile b/fs/affs/Makefile
index b2c4f54..3988b4a 100644
--- a/fs/affs/Makefile
+++ b/fs/affs/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Linux affs filesystem routines.
 #
 
-#EXTRA_CFLAGS=-DDEBUG=1
+#ccflags-y := -DDEBUG=1
 
 obj-$(CONFIG_AFFS_FS) += affs.o
 
diff --git a/fs/coda/Makefile b/fs/coda/Makefile
index 6c22e61..1bab69a 100644
--- a/fs/coda/Makefile
+++ b/fs/coda/Makefile
@@ -9,4 +9,4 @@ coda-objs := psdev.o cache.o cnode.o inode.o dir.o file.o upcall.o \
 
 # If you want debugging output, please uncomment the following line.
 
-# EXTRA_CFLAGS += -DDEBUG -DDEBUG_SMB_MALLOC=1
+# ccflags-y := -DDEBUG -DDEBUG_SMB_MALLOC=1
diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index 21f7e46..f3d23ef 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS := -I$(src)
+ccflags-y := -I$(src)
 obj-$(CONFIG_GFS2_FS) += gfs2.o
 gfs2-y := acl.o bmap.o dir.o xattr.o glock.o \
 	glops.o inode.o log.o lops.o main.o meta_io.o \
diff --git a/fs/jfs/Makefile b/fs/jfs/Makefile
index 3adb639..a58fa72 100644
--- a/fs/jfs/Makefile
+++ b/fs/jfs/Makefile
@@ -13,4 +13,4 @@ jfs-y    := super.o file.o inode.o namei.o jfs_mount.o jfs_umount.o \
 
 jfs-$(CONFIG_JFS_POSIX_ACL) += acl.o
 
-EXTRA_CFLAGS += -D_JFS_4K
+ccflags-y := -D_JFS_4K
diff --git a/fs/ncpfs/Makefile b/fs/ncpfs/Makefile
index 68ea095..c66af56 100644
--- a/fs/ncpfs/Makefile
+++ b/fs/ncpfs/Makefile
@@ -11,6 +11,6 @@ ncpfs-$(CONFIG_NCPFS_EXTRAS)   += symlink.o
 ncpfs-$(CONFIG_NCPFS_NFS_NS)   += symlink.o
 
 # If you want debugging output, please uncomment the following line
-# EXTRA_CFLAGS += -DDEBUG_NCP=1
+# ccflags-y := -DDEBUG_NCP=1
 
 CFLAGS_ncplib_kernel.o := -finline-functions
diff --git a/fs/ntfs/Makefile b/fs/ntfs/Makefile
index 58b6be9..f12e913 100644
--- a/fs/ntfs/Makefile
+++ b/fs/ntfs/Makefile
@@ -2,18 +2,13 @@
 
 obj-$(CONFIG_NTFS_FS) += ntfs.o
 
-ntfs-objs := aops.o attrib.o collate.o compress.o debug.o dir.o file.o \
-	     index.o inode.o mft.o mst.o namei.o runlist.o super.o sysctl.o \
-	     unistr.o upcase.o
+ntfs-y := aops.o attrib.o collate.o compress.o debug.o dir.o file.o \
+	  index.o inode.o mft.o mst.o namei.o runlist.o super.o sysctl.o \
+	  unistr.o upcase.o
 
-EXTRA_CFLAGS = -DNTFS_VERSION=\"2.1.29\"
+ntfs-$(CONFIG_NTFS_RW) += bitmap.o lcnalloc.o logfile.o quota.o usnjrnl.o
 
-ifeq ($(CONFIG_NTFS_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-y := -DNTFS_VERSION=\"2.1.29\"
+ccflags-$(CONFIG_NTFS_DEBUG)	+= -DDEBUG
+ccflags-$(CONFIG_NTFS_RW)	+= -DNTFS_RW
 
-ifeq ($(CONFIG_NTFS_RW),y)
-EXTRA_CFLAGS += -DNTFS_RW
-
-ntfs-objs += bitmap.o lcnalloc.o logfile.o quota.o usnjrnl.o
-endif
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 07d9fd8..d8a0313 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -1,6 +1,6 @@
-EXTRA_CFLAGS += -Ifs/ocfs2
+ccflags-y := -Ifs/ocfs2
 
-EXTRA_CFLAGS += -DCATCH_BH_JBD_RACES
+ccflags-y += -DCATCH_BH_JBD_RACES
 
 obj-$(CONFIG_OCFS2_FS) += 	\
 	ocfs2.o			\
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index dcebf0d..c8a044e 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS += -Ifs/ocfs2
+ccflags-y := -Ifs/ocfs2
 
 obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_dlm.o
 
diff --git a/fs/ocfs2/dlmfs/Makefile b/fs/ocfs2/dlmfs/Makefile
index df69b48..f14be89 100644
--- a/fs/ocfs2/dlmfs/Makefile
+++ b/fs/ocfs2/dlmfs/Makefile
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS += -Ifs/ocfs2
+ccflags-y := -Ifs/ocfs2
 
 obj-$(CONFIG_OCFS2_FS) += ocfs2_dlmfs.o
 
diff --git a/fs/reiserfs/Makefile b/fs/reiserfs/Makefile
index 792b3cb..3c3b001 100644
--- a/fs/reiserfs/Makefile
+++ b/fs/reiserfs/Makefile
@@ -31,9 +31,7 @@ endif
 # and causing a panic. Since this behavior only affects ppc32, this ifeq
 # will work around it. If any other architecture displays this behavior,
 # add it here.
-ifeq ($(CONFIG_PPC32),y)
-EXTRA_CFLAGS := $(call cc-ifversion, -lt, 0400, -O1)
-endif
+ccflags-$(CONFIG_PPC32) := $(call cc-ifversion, -lt, 0400, -O1)
 
 TAGS:
 	etags *.c
diff --git a/fs/smbfs/Makefile b/fs/smbfs/Makefile
index 4faf8c4..74c7039 100644
--- a/fs/smbfs/Makefile
+++ b/fs/smbfs/Makefile
@@ -7,12 +7,12 @@ obj-$(CONFIG_SMB_FS) += smbfs.o
 smbfs-objs := proc.o dir.o cache.o sock.o inode.o file.o ioctl.o getopt.o \
 		symlink.o smbiod.o request.o
 
-# If you want debugging output, you may add these flags to the EXTRA_CFLAGS
+# If you want debugging output, you may add these flags to the ccflags-y
 # SMBFS_PARANOIA should normally be enabled.
 
-EXTRA_CFLAGS += -DSMBFS_PARANOIA
-#EXTRA_CFLAGS += -DSMBFS_DEBUG
-#EXTRA_CFLAGS += -DSMBFS_DEBUG_VERBOSE
-#EXTRA_CFLAGS += -DDEBUG_SMB_TIMESTAMP
-#EXTRA_CFLAGS += -Werror
+ccflags-y := -DSMBFS_PARANOIA
+#ccflags-y += -DSMBFS_DEBUG
+#ccflags-y += -DSMBFS_DEBUG_VERBOSE
+#ccflags-y += -DDEBUG_SMB_TIMESTAMP
+#ccflags-y += -Werror
 
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0dce969..be0fd0c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -16,14 +16,11 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
-EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6
+ccflags-y := -I$(src) -I$(src)/linux-2.6
+ccflags-$(CONFIG_XFS_DEBUG) += -g
 
 XFS_LINUX := linux-2.6
 
-ifeq ($(CONFIG_XFS_DEBUG),y)
-	EXTRA_CFLAGS += -g
-endif
-
 obj-$(CONFIG_XFS_FS)		+= xfs.o
 
 xfs-y				+= linux-2.6/xfs_trace.o
-- 
1.7.2.1

