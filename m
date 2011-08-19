Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab1HSSu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:50:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57570 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab1HSSuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:50:55 -0400
Date: Fri, 19 Aug 2011 21:50:49 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] headers: remove aio.h from sched.h
Message-ID: <20110819185049.GA9148@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove aio.h, it's unused both technically and logically (VM stuff after all)
* fix compilation with aio.h and uio.h inclusions

Remove laptop_mode_sync() proto to not add forward declaration,
it seems this function was never merged and is development artefact.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/s390/hypfs/inode.c                      |    1 +
 block/scsi_ioctl.c                           |    1 +
 drivers/char/mem.c                           |    1 +
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    1 +
 drivers/infiniband/hw/qib/qib_file_ops.c     |    1 +
 drivers/scsi/sg.c                            |    1 +
 drivers/usb/gadget/inode.c                   |    1 +
 fs/9p/vfs_addr.c                             |    1 +
 fs/afs/write.c                               |    1 +
 fs/bio.c                                     |    1 +
 fs/block_dev.c                               |    1 +
 fs/btrfs/file.c                              |    1 +
 fs/btrfs/inode.c                             |    1 +
 fs/ceph/file.c                               |    1 +
 fs/compat.c                                  |    1 +
 fs/direct-io.c                               |    1 +
 fs/ecryptfs/file.c                           |    1 +
 fs/ext2/inode.c                              |    1 +
 fs/ext3/inode.c                              |    1 +
 fs/ext4/file.c                               |    1 +
 fs/ext4/indirect.c                           |    1 +
 fs/ext4/inode.c                              |    1 +
 fs/ext4/page-io.c                            |    1 +
 fs/fat/inode.c                               |    1 +
 fs/fuse/dev.c                                |    1 +
 fs/fuse/file.c                               |    1 +
 fs/gfs2/aops.c                               |    1 +
 fs/gfs2/file.c                               |    1 +
 fs/hfs/inode.c                               |    1 +
 fs/hfsplus/inode.c                           |    1 +
 fs/jfs/inode.c                               |    1 +
 fs/nilfs2/inode.c                            |    1 +
 fs/ntfs/file.c                               |    1 +
 fs/ocfs2/aops.h                              |    1 +
 fs/ocfs2/inode.h                             |    2 ++
 fs/pipe.c                                    |    1 +
 fs/read_write.c                              |    1 +
 fs/reiserfs/inode.c                          |    1 +
 fs/ubifs/file.c                              |    1 +
 fs/xfs/linux-2.6/xfs_aops.c                  |    1 +
 fs/xfs/linux-2.6/xfs_file.c                  |    1 +
 include/linux/bio.h                          |    2 ++
 include/linux/cgroup.h                       |    1 +
 include/linux/sched.h                        |    2 --
 include/linux/user_namespace.h               |    1 +
 include/linux/writeback.h                    |    1 -
 include/net/sock.h                           |    1 +
 kernel/fork.c                                |    1 +
 kernel/ptrace.c                              |    1 +
 mm/shmem.c                                   |    1 +
 security/keys/internal.h                     |    2 ++
 security/keys/keyctl.c                       |    1 +
 sound/core/pcm_native.c                      |    1 +
 53 files changed, 54 insertions(+), 3 deletions(-)

--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -9,6 +9,7 @@
 #define KMSG_COMPONENT "hypfs"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/aio.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -26,6 +26,7 @@
 #include <linux/cdrom.h>
 #include <linux/slab.h>
 #include <linux/times.h>
+#include <linux/uio.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -26,6 +26,7 @@
 #include <linux/bootmem.h>
 #include <linux/splice.h>
 #include <linux/pfn.h>
+#include <linux/uio.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/aio.h>
 #include <linux/pci.h>
 #include <linux/poll.h>
 #include <linux/cdev.h>
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -32,6 +32,7 @@
  * SOFTWARE.
  */
 
+#include <linux/aio.h>
 #include <linux/pci.h>
 #include <linux/poll.h>
 #include <linux/cdev.h>
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -50,6 +50,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
 #include <linux/mutex.h>
+#include <linux/uio.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -22,6 +22,7 @@
 
 /* #define VERBOSE_DEBUG */
 
+#include <linux/aio.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs.h>
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/aio.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -8,6 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/aio.h>
 #include <linux/backing-dev.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mempool.h>
+#include <linux/uio.h>
 #include <linux/workqueue.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 2001  Andrea Arcangeli <andrea@suse.de> SuSE
  */
 
+#include <linux/aio.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/fcntl.h>
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/aio.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/aio.h>
 #include <linux/kernel.h>
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1,5 +1,6 @@
 #include <linux/ceph/ceph_debug.h>
 
+#include <linux/aio.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -15,6 +15,7 @@
  *  published by the Free Software Foundation.
  */
 
+#include <linux/aio.h>
 #include <linux/stddef.h>
 #include <linux/kernel.h>
 #include <linux/linkage.h>
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -19,6 +19,7 @@
  *		added IO completion notifier.
  */
 
+#include <linux/aio.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -23,6 +23,7 @@
  * 02111-1307, USA.
  */
 
+#include <linux/aio.h>
 #include <linux/file.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -22,6 +22,7 @@
  *  Assorted race fixes, rewrite of ext2_get_block() by Al Viro, 2000
  */
 
+#include <linux/aio.h>
 #include <linux/time.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -22,6 +22,7 @@
  *  Assorted race fixes, rewrite of ext3_get_block() by Al Viro, 2000
  */
 
+#include <linux/aio.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -18,6 +18,7 @@
  *	(jj@sunsite.ms.mff.cuni.cz)
  */
 
+#include <linux/aio.h>
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd2.h>
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -20,6 +20,7 @@
  *	(sct@redhat.com), 1993, 1998
  */
 
+#include <linux/aio.h>
 #include <linux/module.h>
 #include "ext4_jbd2.h"
 #include "truncate.h"
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -18,6 +18,7 @@
  *  Assorted race fixes, rewrite of ext4_get_block() by Al Viro, 2000
  */
 
+#include <linux/aio.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -6,6 +6,7 @@
  * Written by Theodore Ts'o, 2010.
  */
 
+#include <linux/aio.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -10,6 +10,7 @@
  *	Max Cohan: Fixed invalid FSINFO offset when info_sector is 0
  */
 
+#include <linux/aio.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/time.h>
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -8,6 +8,7 @@
 
 #include "fuse_i.h"
 
+#include <linux/aio.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/poll.h>
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -8,6 +8,7 @@
 
 #include "fuse_i.h"
 
+#include <linux/aio.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -7,6 +7,7 @@
  * of the GNU General Public License version 2.
  */
 
+#include <linux/aio.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -7,6 +7,7 @@
  * of the GNU General Public License version 2.
  */
 
+#include <linux/aio.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -11,6 +11,7 @@
  * Based on the minix file system code, (C) 1991, 1992 by Linus Torvalds
  */
 
+#include <linux/aio.h>
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/sched.h>
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -8,6 +8,7 @@
  * Inode handling routines
  */
 
+#include <linux/aio.h>
 #include <linux/blkdev.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -17,6 +17,7 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <linux/aio.h>
 #include <linux/fs.h>
 #include <linux/mpage.h>
 #include <linux/buffer_head.h>
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/aio.h>
 #include <linux/buffer_head.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -19,6 +19,7 @@
  * Foundation,Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/aio.h>
 #include <linux/buffer_head.h>
 #include <linux/gfp.h>
 #include <linux/pagemap.h>
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -21,6 +21,7 @@
 
 #ifndef OCFS2_AOPS_H
 #define OCFS2_AOPS_H
+#include <linux/aio.h>
 
 handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
 							 struct page *page,
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -28,6 +28,8 @@
 
 #include "extent_map.h"
 
+struct iocb;
+
 /* OCFS2 Inode Private Data */
 struct ocfs2_inode_info
 {
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -4,6 +4,7 @@
  *  Copyright (C) 1991, 1992, 1999  Linus Torvalds
  */
 
+#include <linux/aio.h>
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/poll.h>
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -4,6 +4,7 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
+#include <linux/aio.h>
 #include <linux/slab.h> 
 #include <linux/stat.h>
 #include <linux/fcntl.h>
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2,6 +2,7 @@
  * Copyright 2000 by Hans Reiser, licensing governed by reiserfs/README
  */
 
+#include <linux/aio.h>
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/reiserfs_fs.h>
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -50,6 +50,7 @@
  */
 
 #include "ubifs.h"
+#include <linux/aio.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/slab.h>
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -33,6 +33,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
+#include <linux/aio.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -36,6 +36,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 
+#include <linux/aio.h>
 #include <linux/dcache.h>
 #include <linux/falloc.h>
 
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -163,6 +163,8 @@ static inline int bio_has_allocated_vec(struct bio *bio)
 #define bio_get(bio)	atomic_inc(&(bio)->bi_cnt)
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
+#include <linux/workqueue.h>
+
 /*
  * bio integrity payload
  */
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -21,6 +21,7 @@
 
 struct cgroupfs_root;
 struct cgroup_subsys;
+struct eventfd_ctx;
 struct inode;
 struct cgroup;
 struct css_id;
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -381,8 +381,6 @@ struct user_namespace;
 
 extern int sysctl_max_map_count;
 
-#include <linux/aio.h>
-
 #ifdef CONFIG_MMU
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
 extern unsigned long
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -5,6 +5,7 @@
 #include <linux/nsproxy.h>
 #include <linux/sched.h>
 #include <linux/err.h>
+#include <linux/workqueue.h>
 
 #define UIDHASH_BITS	(CONFIG_BASE_SMALL ? 3 : 7)
 #define UIDHASH_SZ	(1 << UIDHASH_BITS)
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -109,7 +109,6 @@ static inline void inode_sync_wait(struct inode *inode)
 #ifdef CONFIG_BLOCK
 void laptop_io_completion(struct backing_dev_info *info);
 void laptop_sync_completion(void);
-void laptop_mode_sync(struct work_struct *work);
 void laptop_mode_timer_fn(unsigned long data);
 #else
 static inline void laptop_sync_completion(void) { }
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -40,6 +40,7 @@
 #ifndef _SOCK_H
 #define _SOCK_H
 
+#include <linux/aio.h>
 #include <linux/hardirq.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -11,6 +11,7 @@
  * management can be a bitch. See 'mm/memory.c': 'copy_page_range()'
  */
 
+#include <linux/aio.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/unistd.h>
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <linux/regset.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/cn_proc.h>
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -21,6 +21,7 @@
  * This file is released under the GPL.
  */
 
+#include <linux/aio.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/vfs.h>
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -15,6 +15,8 @@
 #include <linux/sched.h>
 #include <linux/key-type.h>
 
+struct iovec;
+
 #ifdef __KDEBUG
 #define kenter(FMT, ...) \
 	printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
+#include <linux/uio.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/aio.h>
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/slab.h>
