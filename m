Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2K1Qoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:44:54 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46820 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab2K1Qod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:33 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 25/25] aio: Don't include aio.h in sched.h
Date: Wed, 28 Nov 2012 08:43:49 -0800
Message-Id: <1354121029-1376-26-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yay faster kernel compiles

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 arch/s390/hypfs/inode.c                      | 1 +
 block/scsi_ioctl.c                           | 1 +
 drivers/char/mem.c                           | 1 +
 drivers/infiniband/hw/ipath/ipath_file_ops.c | 1 +
 drivers/infiniband/hw/qib/qib_file_ops.c     | 2 +-
 drivers/staging/android/logger.c             | 1 +
 fs/9p/vfs_addr.c                             | 1 +
 fs/afs/write.c                               | 1 +
 fs/block_dev.c                               | 1 +
 fs/btrfs/file.c                              | 1 +
 fs/btrfs/inode.c                             | 1 +
 fs/ceph/file.c                               | 1 +
 fs/compat.c                                  | 1 +
 fs/direct-io.c                               | 1 +
 fs/ecryptfs/file.c                           | 1 +
 fs/ext2/inode.c                              | 1 +
 fs/ext3/inode.c                              | 1 +
 fs/ext4/file.c                               | 1 +
 fs/ext4/indirect.c                           | 1 +
 fs/ext4/inode.c                              | 1 +
 fs/ext4/page-io.c                            | 1 +
 fs/fat/inode.c                               | 1 +
 fs/fuse/dev.c                                | 1 +
 fs/fuse/file.c                               | 1 +
 fs/gfs2/aops.c                               | 1 +
 fs/gfs2/file.c                               | 1 +
 fs/hfs/inode.c                               | 1 +
 fs/hfsplus/inode.c                           | 1 +
 fs/jfs/inode.c                               | 1 +
 fs/nilfs2/inode.c                            | 2 +-
 fs/ntfs/file.c                               | 1 +
 fs/ntfs/inode.c                              | 1 +
 fs/ocfs2/aops.h                              | 2 ++
 fs/ocfs2/inode.h                             | 2 ++
 fs/pipe.c                                    | 1 +
 fs/read_write.c                              | 1 +
 fs/reiserfs/inode.c                          | 1 +
 fs/ubifs/file.c                              | 1 +
 fs/udf/inode.c                               | 1 +
 fs/xfs/xfs_aops.c                            | 1 +
 fs/xfs/xfs_file.c                            | 1 +
 include/linux/cgroup.h                       | 1 +
 include/linux/sched.h                        | 2 --
 kernel/fork.c                                | 1 +
 kernel/printk.c                              | 1 +
 kernel/ptrace.c                              | 1 +
 mm/page_io.c                                 | 1 +
 mm/shmem.c                                   | 1 +
 mm/swap.c                                    | 1 +
 security/keys/internal.h                     | 2 ++
 security/keys/keyctl.c                       | 1 +
 sound/core/pcm_native.c                      | 2 +-
 52 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 06ea69b..c6c6f43 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
+#include <linux/aio.h>
 #include <asm/ebcdic.h>
 #include "hypfs.h"
 
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 9a87daa..a5ffcc9 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -27,6 +27,7 @@
 #include <linux/ratelimit.h>
 #include <linux/slab.h>
 #include <linux/times.h>
+#include <linux/uio.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 968ae6e..6447854 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -28,6 +28,7 @@
 #include <linux/pfn.h>
 #include <linux/export.h>
 #include <linux/io.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 3eb7e45..62edc41 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -40,6 +40,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
+#include <linux/aio.h>
 #include <linux/jiffies.h>
 #include <linux/cpu.h>
 #include <asm/pgtable.h>
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 959a5c4..488300c 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -39,7 +39,7 @@
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
-#include <linux/uio.h>
+#include <linux/aio.h>
 #include <linux/jiffies.h>
 #include <asm/pgtable.h>
 #include <linux/delay.h>
diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 1d5ed47..c79c101 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
+#include <linux/aio.h>
 #include "logger.h"
 
 #include <asm/ioctls.h>
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 0ad61c6..055562c 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -33,6 +33,7 @@
 #include <linux/pagemap.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/aio.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 9aa52d9..5151ea3 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
+#include <linux/aio.h>
 #include "internal.h"
 
 static int afs_write_back_from_locked_page(struct afs_writeback *wb,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1a1e5e3..e758dc4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -27,6 +27,7 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/cleancache.h>
+#include <linux/aio.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9ab1bed..166f386 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -30,6 +30,7 @@
 #include <linux/statfs.h>
 #include <linux/compat.h>
 #include <linux/slab.h>
+#include <linux/aio.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..0a7c785 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -39,6 +39,7 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 #include <linux/mount.h>
+#include <linux/aio.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 5840d2a..74cee4e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -7,6 +7,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/writeback.h>
+#include <linux/aio.h>
 
 #include "super.h"
 #include "mds_client.h"
diff --git a/fs/compat.c b/fs/compat.c
index 015e1e1..6538684 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -48,6 +48,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
diff --git a/fs/direct-io.c b/fs/direct-io.c
index f86c720..1f45a5a 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -37,6 +37,7 @@
 #include <linux/uio.h>
 #include <linux/atomic.h>
 #include <linux/prefetch.h>
+#include <linux/aio.h>
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index d45ba45..fd04283 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -31,6 +31,7 @@
 #include <linux/security.h>
 #include <linux/compat.h>
 #include <linux/fs_stack.h>
+#include <linux/aio.h>
 #include "ecryptfs_kernel.h"
 
 /**
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 6363ac6..388e77d 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -31,6 +31,7 @@
 #include <linux/mpage.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/aio.h>
 #include "ext2.h"
 #include "acl.h"
 #include "xip.h"
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 7e87e37..f99db41 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -27,6 +27,7 @@
 #include <linux/writeback.h>
 #include <linux/mpage.h>
 #include <linux/namei.h>
+#include <linux/aio.h>
 #include "ext3.h"
 #include "xattr.h"
 #include "acl.h"
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index bf3966b..246d693 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -24,6 +24,7 @@
 #include <linux/mount.h>
 #include <linux/path.h>
 #include <linux/quotaops.h>
+#include <linux/aio.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 #include "xattr.h"
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 792e388..dcfcb0d 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -20,6 +20,7 @@
  *	(sct@redhat.com), 1993, 1998
  */
 
+#include <linux/aio.h>
 #include "ext4_jbd2.h"
 #include "truncate.h"
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b3c243b..6e42b49 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -37,6 +37,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/aio.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 68e896e..c3b15e2 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -23,6 +23,7 @@
 #include <linux/workqueue.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/aio.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 5bafaad..4dd0d8d 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -26,6 +26,7 @@
 #include <linux/writeback.h>
 #include <linux/log2.h>
 #include <linux/hash.h>
+#include <linux/aio.h>
 #include <asm/unaligned.h>
 #include "fat.h"
 
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8c23fa7..b4c3f56 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -19,6 +19,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/swap.h>
 #include <linux/splice.h>
+#include <linux/aio.h>
 
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 78d2837..c65e75d 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/compat.h>
 #include <linux/swap.h>
+#include <linux/aio.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 01c4975..5b8d824 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -20,6 +20,7 @@
 #include <linux/swap.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/backing-dev.h>
+#include <linux/aio.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index e056b4c..ac49082 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -25,6 +25,7 @@
 #include <asm/uaccess.h>
 #include <linux/dlm.h>
 #include <linux/dlm_plock.h>
+#include <linux/aio.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 0b35903..8e4c003 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/sched.h>
+#include <linux/aio.h>
 
 #include "hfs_fs.h"
 #include "btree.h"
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 2172aa5..50ae88c 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/sched.h>
+#include <linux/aio.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 4692bf3..a462b57 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -23,6 +23,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h>
+#include <linux/aio.h>
 #include "jfs_incore.h"
 #include "jfs_inode.h"
 #include "jfs_filsys.h"
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 4d31d2c..1e246df 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -25,7 +25,7 @@
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
-#include <linux/uio.h>
+#include <linux/aio.h>
 #include "nilfs.h"
 #include "btnode.h"
 #include "segment.h"
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 1ecf464..1373f97 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -27,6 +27,7 @@
 #include <linux/swap.h>
 #include <linux/uio.h>
 #include <linux/writeback.h>
+#include <linux/aio.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 1d27331..e3afc6e 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -28,6 +28,7 @@
 #include <linux/quotaops.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
+#include <linux/aio.h>
 
 #include "aops.h"
 #include "attrib.h"
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index ffb2da3..f671e49 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -22,6 +22,8 @@
 #ifndef OCFS2_AOPS_H
 #define OCFS2_AOPS_H
 
+#include <linux/aio.h>
+
 handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
 							 struct page *page,
 							 unsigned from,
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 88924a3..c765bdf 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -28,6 +28,8 @@
 
 #include "extent_map.h"
 
+struct iocb;
+
 /* OCFS2 Inode Private Data */
 struct ocfs2_inode_info
 {
diff --git a/fs/pipe.c b/fs/pipe.c
index bd3479d..dc86533 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
diff --git a/fs/read_write.c b/fs/read_write.c
index 7347732..a088b00 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -15,6 +15,7 @@
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/splice.h>
+#include <linux/aio.h>
 #include "read_write.h"
 
 #include <asm/uaccess.h>
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index d83736f..c760aed 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -18,6 +18,7 @@
 #include <linux/writeback.h>
 #include <linux/quotaops.h>
 #include <linux/swap.h>
+#include <linux/aio.h>
 
 int reiserfs_commit_write(struct file *f, struct page *page,
 			  unsigned from, unsigned to);
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 5bc7781..1b337c7 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -50,6 +50,7 @@
  */
 
 #include "ubifs.h"
+#include <linux/aio.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/slab.h>
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index df88b95..7cd8448 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/crc-itu-t.h>
 #include <linux/mpage.h>
+#include <linux/aio.h>
 
 #include "udf_i.h"
 #include "udf_sb.h"
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e57e2da..d519030 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -31,6 +31,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
+#include <linux/aio.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aa473fa..46176a5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -34,6 +34,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 
+#include <linux/aio.h>
 #include <linux/dcache.h>
 #include <linux/falloc.h>
 #include <linux/pagevec.h>
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f8a030c..33e158f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -26,6 +26,7 @@ struct cgroup_subsys;
 struct inode;
 struct cgroup;
 struct css_id;
+struct eventfd_ctx;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..a04716d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -345,8 +345,6 @@ struct user_namespace;
 
 extern int sysctl_max_map_count;
 
-#include <linux/aio.h>
-
 #ifdef CONFIG_MMU
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
 extern unsigned long
diff --git a/kernel/fork.c b/kernel/fork.c
index 8b20ab7..1104945 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -70,6 +70,7 @@
 #include <linux/khugepaged.h>
 #include <linux/signalfd.h>
 #include <linux/uprobes.h>
+#include <linux/aio.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/kernel/printk.c b/kernel/printk.c
index 2d607f4..3fce6e3 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -42,6 +42,7 @@
 #include <linux/notifier.h>
 #include <linux/rculist.h>
 #include <linux/poll.h>
+#include <linux/uio.h>
 
 #include <asm/uaccess.h>
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1f5e55d..3f08b89 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -24,6 +24,7 @@
 #include <linux/regset.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/cn_proc.h>
+#include <linux/uio.h>
 
 
 static int ptrace_trapping_sleep_fn(void *flags)
diff --git a/mm/page_io.c b/mm/page_io.c
index 78eee32..c535d39 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -20,6 +20,7 @@
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/frontswap.h>
+#include <linux/aio.h>
 #include <asm/pgtable.h>
 
 static struct bio *get_swap_bio(gfp_t gfp_flags,
diff --git a/mm/shmem.c b/mm/shmem.c
index 89341b6..9647fb9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -30,6 +30,7 @@
 #include <linux/mm.h>
 #include <linux/export.h>
 #include <linux/swap.h>
+#include <linux/aio.h>
 
 static struct vfsmount *shm_mnt;
 
diff --git a/mm/swap.c b/mm/swap.c
index 6310dc2..d0cb95e 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -30,6 +30,7 @@
 #include <linux/backing-dev.h>
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
+#include <linux/uio.h>
 
 #include "internal.h"
 
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 8bbefc3..d4f1468 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -16,6 +16,8 @@
 #include <linux/key-type.h>
 #include <linux/task_work.h>
 
+struct iovec;
+
 #ifdef __KDEBUG
 #define kenter(FMT, ...) \
 	printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 5d34b4e..c664201 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -22,6 +22,7 @@
 #include <linux/err.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
+#include <linux/uio.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index f9ddecf..2cdd17a 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/pm_qos.h>
-#include <linux/uio.h>
+#include <linux/aio.h>
 #include <linux/dma-mapping.h>
 #include <sound/core.h>
 #include <sound/control.h>
-- 
1.7.12

