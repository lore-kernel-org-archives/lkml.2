Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab2CACfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:35:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:44776 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab2CACfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:35:22 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/3] fs: reduce the use of module.h wherever possible
Date: Wed, 29 Feb 2012 21:35:08 -0500
Message-Id: <1330569309-26190-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1330569309-26190-1-git-send-email-paul.gortmaker@windriver.com>
References: <1330569309-26190-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For files only using THIS_MODULE and/or EXPORT_SYMBOL, map
them onto including export.h -- or if the file isn't even
using those, then just delete the include.  Fix up any implicit
include dependencies that were being masked by module.h along
the way.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/aio.c          |    2 +-
 fs/attr.c         |    2 +-
 fs/bad_inode.c    |    2 +-
 fs/binfmt_flat.c  |    2 +-
 fs/bio.c          |    2 +-
 fs/buffer.c       |    2 +-
 fs/compat.c       |    1 -
 fs/compat_ioctl.c |    1 -
 fs/dcache.c       |    2 +-
 fs/dcookies.c     |    2 +-
 fs/eventfd.c      |    2 +-
 fs/file.c         |    2 +-
 fs/fs-writeback.c |    2 +-
 fs/fs_struct.c    |    2 +-
 fs/inode.c        |    2 +-
 fs/ioctl.c        |    2 +-
 fs/libfs.c        |    2 +-
 fs/mpage.c        |    2 +-
 fs/namei.c        |    2 +-
 fs/posix_acl.c    |    2 +-
 fs/read_write.c   |    2 +-
 fs/readdir.c      |    2 +-
 fs/select.c       |    2 +-
 fs/seq_file.c     |    2 +-
 fs/splice.c       |    2 +-
 fs/stack.c        |    2 +-
 fs/stat.c         |    2 +-
 fs/statfs.c       |    2 +-
 fs/super.c        |    2 +-
 fs/sync.c         |    2 +-
 fs/xattr.c        |    2 +-
 fs/xattr_acl.c    |    2 +-
 32 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 969beb0..4b5e063 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -13,7 +13,7 @@
 #include <linux/errno.h>
 #include <linux/time.h>
 #include <linux/aio_abi.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/syscalls.h>
 #include <linux/backing-dev.h>
 #include <linux/uio.h>
diff --git a/fs/attr.c b/fs/attr.c
index 95053ad..73f69a6 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -5,7 +5,7 @@
  *  changes by Thomas Schoebel-Theuer
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/string.h>
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 22e9a78..37268c5 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -9,7 +9,7 @@
  */
 
 #include <linux/fs.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/stat.h>
 #include <linux/time.h>
 #include <linux/namei.h>
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 1bffbe0..3e27232 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -15,7 +15,7 @@
  *	JAN/99 -- coded full program relocation (gerg@snapgear.com)
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
diff --git a/fs/bio.c b/fs/bio.c
index b980ecd..e453924 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -22,7 +22,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
diff --git a/fs/buffer.c b/fs/buffer.c
index 1a30db7..70e2017 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -29,7 +29,7 @@
 #include <linux/file.h>
 #include <linux/quotaops.h>
 #include <linux/highmem.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/writeback.h>
 #include <linux/hash.h>
 #include <linux/suspend.h>
diff --git a/fs/compat.c b/fs/compat.c
index 07880ba..14483a7 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -33,7 +33,6 @@
 #include <linux/nfs4_mount.h>
 #include <linux/syscalls.h>
 #include <linux/ctype.h>
-#include <linux/module.h>
 #include <linux/dirent.h>
 #include <linux/fsnotify.h>
 #include <linux/highuid.h>
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index a26bea1..4d3eec7 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -49,7 +49,6 @@
 #include <linux/elevator.h>
 #include <linux/rtc.h>
 #include <linux/pci.h>
-#include <linux/module.h>
 #include <linux/serial.h>
 #include <linux/if_tun.h>
 #include <linux/ctype.h>
diff --git a/fs/dcache.c b/fs/dcache.c
index fe19ac1..303ebd9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -23,7 +23,7 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/cache.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/mount.h>
 #include <linux/file.h>
 #include <asm/uaccess.h>
diff --git a/fs/dcookies.c b/fs/dcookies.c
index dda0dc7..17c7799 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/syscalls.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/mount.h>
diff --git a/fs/eventfd.c b/fs/eventfd.c
index d9a5917..dba15fe 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -16,7 +16,7 @@
 #include <linux/spinlock.h>
 #include <linux/anon_inodes.h>
 #include <linux/syscalls.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/kref.h>
 #include <linux/eventfd.h>
 
diff --git a/fs/file.c b/fs/file.c
index 4c6992d..3c426de 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -6,7 +6,7 @@
  *  Manage the dynamic fd arrays in the process files_struct.
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5b4a936..92fcb19 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -14,7 +14,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 78b519c..a2d1db2 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -1,4 +1,4 @@
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/path.h>
diff --git a/fs/inode.c b/fs/inode.c
index d3ebdbe..cd8cffc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -8,7 +8,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/writeback.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/backing-dev.h>
 #include <linux/wait.h>
 #include <linux/rwsem.h>
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 066836e..29167be 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -10,7 +10,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/security.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/uaccess.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
diff --git a/fs/libfs.c b/fs/libfs.c
index 5b2dbb3..001e25b 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -3,7 +3,7 @@
  *	Library for filesystems writers.
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/mount.h>
diff --git a/fs/mpage.c b/fs/mpage.c
index 643e9f5..0face1c 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/kdev_t.h>
 #include <linux/gfp.h>
diff --git a/fs/namei.c b/fs/namei.c
index a780ea5..fa549f2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -15,7 +15,7 @@
  */
 
 #include <linux/init.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index cea4623..5e325a4 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -18,7 +18,7 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/posix_acl.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 #include <linux/errno.h>
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 5ad4248..ffc99d2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -11,7 +11,7 @@
 #include <linux/uio.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/splice.h>
diff --git a/fs/readdir.c b/fs/readdir.c
index 356f715..cc0a822 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -6,7 +6,7 @@
 
 #include <linux/stddef.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
diff --git a/fs/select.c b/fs/select.c
index e782258..de668aa 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -17,7 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/syscalls.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/personality.h> /* for STICKY_TIMEOUTS */
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 4023d6b..9f73c6b 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -6,7 +6,7 @@
  */
 
 #include <linux/fs.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 
diff --git a/fs/splice.c b/fs/splice.c
index 1ec0493..66f4ee0 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -25,7 +25,7 @@
 #include <linux/mm_inline.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/syscalls.h>
 #include <linux/uio.h>
 #include <linux/security.h>
diff --git a/fs/stack.c b/fs/stack.c
index 9c11519..5b53882 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -1,4 +1,4 @@
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/fs_stack.h>
 
diff --git a/fs/stat.c b/fs/stat.c
index 8806b89..c9dfa29 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -4,7 +4,7 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/file.h>
diff --git a/fs/statfs.c b/fs/statfs.c
index 2aa6a22..43e6b6f 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -1,5 +1,5 @@
 #include <linux/syscalls.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/mount.h>
diff --git a/fs/super.c b/fs/super.c
index 6277ec6..52bfd25 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -20,7 +20,7 @@
  *  Heavily rewritten for 'one fs - one tree' dcache architecture. AV, Mar 2000
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/acct.h>
 #include <linux/blkdev.h>
diff --git a/fs/sync.c b/fs/sync.c
index f3501ef..0e8db93 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -6,7 +6,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/writeback.h>
diff --git a/fs/xattr.c b/fs/xattr.c
index 82f4337..d6dfd24 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -16,7 +16,7 @@
 #include <linux/security.h>
 #include <linux/evm.h>
 #include <linux/syscalls.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/fsnotify.h>
 #include <linux/audit.h>
 #include <asm/uaccess.h>
diff --git a/fs/xattr_acl.c b/fs/xattr_acl.c
index 8d5a506..69d06b0 100644
--- a/fs/xattr_acl.c
+++ b/fs/xattr_acl.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2001 by Andreas Gruenbacher, <a.gruenbacher@computer.org>
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/gfp.h>
-- 
1.7.9.1

