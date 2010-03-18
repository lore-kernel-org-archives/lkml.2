Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab0CRVbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:31:06 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41558 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0CRVbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mis/TCZ4rct81MQaA0MTyJeJxJ9AitX7Vd3X3CZpjvHnEcR+AzFpvCnGtwPpCV6Kw8
         3zPixJuMQYkeAm6ZFED2/eLXjuEvA9kfmujKuJ6YnpT45G6ReOVv08atei22g5c7jRoP
         SGgzOngoFqsBX3QCy6B8UDCiwiSVY+fu+tLOE=
Date: Thu, 18 Mar 2010 23:30:54 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH v2] headers: remove mm_types.h from sched.h
Message-ID: <20100318213054.GB4989@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove mm_types.h inclusion from sched.h
* move init_mm declaration not to mm.h but to mm_types.h
  to overcome header loops on sparc64
* move mm_struct related stuff to mm.h
* fix fallout

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/blackfin/include/asm/mmu_context.h      |    1 
 arch/blackfin/kernel/flat.c                  |    1 
 arch/s390/hypfs/inode.c                      |    1 
 arch/sparc/include/asm/pgtable_64.h          |    1 
 arch/sparc/kernel/asm-offsets.c              |    2 
 arch/um/kernel/exec.c                        |    1 
 arch/um/kernel/reboot.c                      |    1 
 arch/um/kernel/skas/process.c                |    1 
 arch/um/sys-x86_64/syscalls.c                |    1 
 arch/x86/kernel/e820.c                       |    1 
 block/scsi_ioctl.c                           |    1 
 drivers/char/random.c                        |    1 
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    1 
 drivers/lguest/lguest_user.c                 |    1 
 drivers/media/video/soc_camera.c             |    1 
 drivers/scsi/sg.c                            |    1 
 drivers/usb/gadget/inode.c                   |    1 
 fs/afs/write.c                               |    1 
 fs/block_dev.c                               |    1 
 fs/buffer.c                                  |    1 
 fs/direct-io.c                               |    1 
 fs/ecryptfs/file.c                           |    1 
 fs/ext2/inode.c                              |    1 
 fs/ext3/inode.c                              |    1 
 fs/ext4/file.c                               |    1 
 fs/ext4/inode.c                              |    1 
 fs/fat/inode.c                               |    1 
 fs/fuse/dev.c                                |    1 
 fs/fuse/file.c                               |    1 
 fs/gfs2/aops.c                               |    1 
 fs/gfs2/file.c                               |    1 
 fs/hfs/inode.c                               |    1 
 fs/hfsplus/inode.c                           |    1 
 fs/jfs/inode.c                               |    1 
 fs/nilfs2/inode.c                            |    1 
 fs/ntfs/file.c                               |    1 
 fs/ocfs2/aops.h                              |    1 
 fs/ocfs2/inode.h                             |    2 
 fs/pipe.c                                    |    1 
 fs/read_write.c                              |    1 
 fs/reiserfs/inode.c                          |    1 
 fs/sysfs/file.c                              |    1 
 fs/ubifs/file.c                              |    1 
 fs/xfs/linux-2.6/xfs_aops.c                  |    1 
 fs/xfs/linux-2.6/xfs_file.c                  |    1 
 include/linux/cgroup.h                       |    2 
 include/linux/fscache-cache.h                |    1 
 include/linux/kvm_host.h                     |    1 
 include/linux/memcontrol.h                   |    4 
 include/linux/mm.h                           |  106 +++++++++++++++++++++++++
 include/linux/mm_types.h                     |    1 
 include/linux/sched.h                        |  114 ---------------------------
 include/linux/user_namespace.h               |    1 
 include/net/sock.h                           |    1 
 kernel/cgroup.c                              |    1 
 kernel/fork.c                                |    1 
 kernel/power/main.c                          |    1 
 kernel/ptrace.c                              |    1 
 lib/debugobjects.c                           |    1 
 lib/is_single_threaded.c                     |    1 
 mm/shmem.c                                   |    1 
 security/keys/gc.c                           |    1 
 sound/core/pcm_native.c                      |    1 
 63 files changed, 171 insertions(+), 116 deletions(-)

--- a/arch/blackfin/include/asm/mmu_context.h
+++ b/arch/blackfin/include/asm/mmu_context.h
@@ -8,6 +8,7 @@
 #define __BLACKFIN_MMU_CONTEXT_H__
 
 #include <linux/gfp.h>
+#include <linux/mm_types.h>
 #include <linux/sched.h>
 #include <asm/setup.h>
 #include <asm/page.h>
--- a/arch/blackfin/kernel/flat.c
+++ b/arch/blackfin/kernel/flat.c
@@ -4,6 +4,7 @@
  * Licensed under the GPL-2.
  */
 
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/flat.h>
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -9,6 +9,7 @@
 #define KMSG_COMPONENT "hypfs"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/aio.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -196,6 +196,7 @@
 #define __S111	__pgprot(0)
 
 #ifndef __ASSEMBLY__
+#include <linux/mm_types.h>
 
 extern pte_t mk_pte_io(unsigned long, pgprot_t, int, unsigned long);
 
--- a/arch/sparc/kernel/asm-offsets.c
+++ b/arch/sparc/kernel/asm-offsets.c
@@ -11,7 +11,7 @@
  */
 
 #include <linux/sched.h>
-// #include <linux/mm.h>
+#include <linux/mm_types.h>
 #include <linux/kbuild.h>
 
 #ifdef CONFIG_SPARC32
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -5,6 +5,7 @@
 
 #include "linux/stddef.h"
 #include "linux/fs.h"
+#include "linux/mm.h"
 #include "linux/smp_lock.h"
 #include "linux/ptrace.h"
 #include "linux/sched.h"
--- a/arch/um/kernel/reboot.c
+++ b/arch/um/kernel/reboot.c
@@ -3,6 +3,7 @@
  * Licensed under the GPL
  */
 
+#include "linux/mm.h"
 #include "linux/sched.h"
 #include "kern_util.h"
 #include "os.h"
--- a/arch/um/kernel/skas/process.c
+++ b/arch/um/kernel/skas/process.c
@@ -4,6 +4,7 @@
  */
 
 #include "linux/init.h"
+#include "linux/mm.h"
 #include "linux/sched.h"
 #include "as-layout.h"
 #include "kern.h"
--- a/arch/um/sys-x86_64/syscalls.c
+++ b/arch/um/sys-x86_64/syscalls.c
@@ -6,6 +6,7 @@
  */
 
 #include "linux/linkage.h"
+#include "linux/mm.h"
 #include "linux/personality.h"
 #include "linux/utsname.h"
 #include "asm/prctl.h" /* XXX This should get the constants from libc */
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -9,6 +9,7 @@
  *
  */
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -26,6 +26,7 @@
 #include <linux/cdrom.h>
 #include <linux/slab.h>
 #include <linux/times.h>
+#include <linux/uio.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -241,6 +241,7 @@
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
 #include <linux/fips.h>
+#include <linux/workqueue.h>
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 # include <linux/irq.h>
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/aio.h>
 #include <linux/pci.h>
 #include <linux/poll.h>
 #include <linux/cdev.h>
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -6,6 +6,7 @@
 :*/
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
+#include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/eventfd.h>
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -21,6 +21,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -49,6 +49,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
 #include <linux/smp_lock.h>
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
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 2001  Andrea Arcangeli <andrea@suse.de> SuSE
  */
 
+#include <linux/aio.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/fcntl.h>
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -33,6 +33,7 @@
 #include <linux/writeback.h>
 #include <linux/hash.h>
 #include <linux/suspend.h>
+#include <linux/swap.h>
 #include <linux/buffer_head.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/bio.h>
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
 #include <linux/mount.h>
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -22,6 +22,7 @@
  *  Assorted race fixes, rewrite of ext2_get_block() by Al Viro, 2000
  */
 
+#include <linux/aio.h>
 #include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/highuid.h>
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
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -22,6 +22,7 @@
  *  Assorted race fixes, rewrite of ext4_get_block() by Al Viro, 2000
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
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
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
 #include <linux/mpage.h>
 #include <linux/writeback.h>
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -19,6 +19,7 @@
  * Foundation,Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/aio.h>
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
 #include <linux/pagevec.h>
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -21,6 +21,7 @@
 
 #ifndef OCFS2_AOPS_H
 #define OCFS2_AOPS_H
+#include <linux/aio.h>
 
 int ocfs2_prepare_write_nolock(struct inode *inode, struct page *page,
 			       unsigned from, unsigned to);
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
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/limits.h>
+#include <linux/workqueue.h>
 #include <asm/uaccess.h>
 
 #include "sysfs.h"
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -50,6 +50,7 @@
  */
 
 #include "ubifs.h"
+#include <linux/aio.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -40,6 +40,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
+#include <linux/aio.h>
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -44,6 +44,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 
+#include <linux/aio.h>
 #include <linux/dcache.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -21,6 +21,8 @@
 
 struct cgroupfs_root;
 struct cgroup_subsys;
+struct eventfd_ctx;
+struct file;
 struct inode;
 struct cgroup;
 struct css_id;
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -21,6 +21,7 @@
 #include <linux/fscache.h>
 #include <linux/sched.h>
 #include <linux/slow-work.h>
+#include <linux/workqueue.h>
 
 #define NR_MAXCACHES BITS_PER_LONG
 
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/preempt.h>
 #include <linux/msi.h>
+#include <linux/workqueue.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -20,10 +20,10 @@
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
 #include <linux/cgroup.h>
+#include <linux/mm_types.h>
+
 struct mem_cgroup;
 struct page_cgroup;
-struct page;
-struct mm_struct;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 /*
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1467,5 +1467,111 @@ extern int soft_offline_page(struct page *page, int flags);
 
 extern void dump_page(struct page *page);
 
+/*
+ * Default maximum number of active map areas, this limits the number of vmas
+ * per mm struct. Users can overwrite this number by sysctl but there is a
+ * problem.
+ *
+ * When a program's coredump is generated as ELF format, a section is created
+ * per a vma. In ELF, the number of sections is represented in unsigned short.
+ * This means the number of sections should be smaller than 65535 at coredump.
+ * Because the kernel adds some informative sections to a image of program at
+ * generating coredump, we need some margin. The number of extra sections is
+ * 1-3 now and depends on arch. We use "5" as safe margin, here.
+ */
+#define MAPCOUNT_ELF_CORE_MARGIN	(5)
+#define DEFAULT_MAX_MAP_COUNT	(USHORT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
+
+extern int sysctl_max_map_count;
+
+#ifdef CONFIG_MMU
+extern void arch_pick_mmap_layout(struct mm_struct *mm);
+extern unsigned long
+arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
+		       unsigned long, unsigned long);
+extern unsigned long
+arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
+			  unsigned long len, unsigned long pgoff,
+			  unsigned long flags);
+extern void arch_unmap_area(struct mm_struct *, unsigned long);
+extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
+#else
+static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
+#endif
+
+
+extern void set_dumpable(struct mm_struct *mm, int value);
+extern int get_dumpable(struct mm_struct *mm);
+
+/* mm flags */
+/* dumpable bits */
+#define MMF_DUMPABLE      0  /* core dump is permitted */
+#define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
+
+#define MMF_DUMPABLE_BITS 2
+#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
+
+/* coredump filter bits */
+#define MMF_DUMP_ANON_PRIVATE	2
+#define MMF_DUMP_ANON_SHARED	3
+#define MMF_DUMP_MAPPED_PRIVATE	4
+#define MMF_DUMP_MAPPED_SHARED	5
+#define MMF_DUMP_ELF_HEADERS	6
+#define MMF_DUMP_HUGETLB_PRIVATE 7
+#define MMF_DUMP_HUGETLB_SHARED  8
+
+#define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
+#define MMF_DUMP_FILTER_BITS	7
+#define MMF_DUMP_FILTER_MASK \
+	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
+#define MMF_DUMP_FILTER_DEFAULT \
+	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED) |\
+	 (1 << MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
+
+#ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
+# define MMF_DUMP_MASK_DEFAULT_ELF	(1 << MMF_DUMP_ELF_HEADERS)
+#else
+# define MMF_DUMP_MASK_DEFAULT_ELF	0
+#endif
+					/* leave room for more dump flags */
+#define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
+
+#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
+
+/*
+ * Routines for handling mm_structs
+ */
+extern struct mm_struct * mm_alloc(void);
+
+/* mmdrop drops the mm and the page tables */
+extern void __mmdrop(struct mm_struct *);
+static inline void mmdrop(struct mm_struct * mm)
+{
+	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
+		__mmdrop(mm);
+}
+
+/* mmput gets rid of the mappings and all user-space */
+extern void mmput(struct mm_struct *);
+/* Grab a reference to a task's mm, if it is not already going away */
+extern struct mm_struct *get_task_mm(struct task_struct *task);
+/* Remove the current tasks stale references to the old mm_struct */
+extern void mm_release(struct task_struct *, struct mm_struct *);
+/* Allocate a new mm structure and copy contents from tsk->mm */
+extern struct mm_struct *dup_mm(struct task_struct *tsk);
+
+#ifdef CONFIG_MM_OWNER
+extern void mm_update_next_owner(struct mm_struct *mm);
+extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
+#else
+static inline void mm_update_next_owner(struct mm_struct *mm)
+{
+}
+
+static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
+{
+}
+#endif /* CONFIG_MM_OWNER */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -311,6 +311,7 @@ struct mm_struct {
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
 };
+extern struct mm_struct init_mm;
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
 #define mm_cpumask(mm) (&(mm)->cpu_vm_mask)
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -60,7 +60,6 @@ struct sched_param {
 #include <linux/cpumask.h>
 #include <linux/errno.h>
 #include <linux/nodemask.h>
-#include <linux/mm_types.h>
 
 #include <asm/system.h>
 #include <asm/page.h>
@@ -96,6 +95,7 @@ struct sched_param {
 
 struct exec_domain;
 struct futex_pi_state;
+struct mm_struct;
 struct robust_list_head;
 struct bio_list;
 struct fs_struct;
@@ -366,79 +366,6 @@ extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
 struct nsproxy;
 struct user_namespace;
 
-/*
- * Default maximum number of active map areas, this limits the number of vmas
- * per mm struct. Users can overwrite this number by sysctl but there is a
- * problem.
- *
- * When a program's coredump is generated as ELF format, a section is created
- * per a vma. In ELF, the number of sections is represented in unsigned short.
- * This means the number of sections should be smaller than 65535 at coredump.
- * Because the kernel adds some informative sections to a image of program at
- * generating coredump, we need some margin. The number of extra sections is
- * 1-3 now and depends on arch. We use "5" as safe margin, here.
- */
-#define MAPCOUNT_ELF_CORE_MARGIN	(5)
-#define DEFAULT_MAX_MAP_COUNT	(USHORT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
-
-extern int sysctl_max_map_count;
-
-#include <linux/aio.h>
-
-#ifdef CONFIG_MMU
-extern void arch_pick_mmap_layout(struct mm_struct *mm);
-extern unsigned long
-arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
-		       unsigned long, unsigned long);
-extern unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
-			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags);
-extern void arch_unmap_area(struct mm_struct *, unsigned long);
-extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
-#else
-static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
-#endif
-
-
-extern void set_dumpable(struct mm_struct *mm, int value);
-extern int get_dumpable(struct mm_struct *mm);
-
-/* mm flags */
-/* dumpable bits */
-#define MMF_DUMPABLE      0  /* core dump is permitted */
-#define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
-
-#define MMF_DUMPABLE_BITS 2
-#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
-
-/* coredump filter bits */
-#define MMF_DUMP_ANON_PRIVATE	2
-#define MMF_DUMP_ANON_SHARED	3
-#define MMF_DUMP_MAPPED_PRIVATE	4
-#define MMF_DUMP_MAPPED_SHARED	5
-#define MMF_DUMP_ELF_HEADERS	6
-#define MMF_DUMP_HUGETLB_PRIVATE 7
-#define MMF_DUMP_HUGETLB_SHARED  8
-
-#define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
-#define MMF_DUMP_FILTER_BITS	7
-#define MMF_DUMP_FILTER_MASK \
-	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
-#define MMF_DUMP_FILTER_DEFAULT \
-	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED) |\
-	 (1 << MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
-
-#ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
-# define MMF_DUMP_MASK_DEFAULT_ELF	(1 << MMF_DUMP_ELF_HEADERS)
-#else
-# define MMF_DUMP_MASK_DEFAULT_ELF	0
-#endif
-					/* leave room for more dump flags */
-#define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
-
-#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
-
 struct sighand_struct {
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
@@ -1954,9 +1881,6 @@ static inline int kstack_end(void *addr)
 
 extern union thread_union init_thread_union;
 extern struct task_struct init_task;
-
-extern struct   mm_struct init_mm;
-
 extern struct pid_namespace init_pid_ns;
 
 /*
@@ -2075,28 +1999,6 @@ static inline int sas_ss_flags(unsigned long sp)
 		: on_sig_stack(sp) ? SS_ONSTACK : 0);
 }
 
-/*
- * Routines for handling mm_structs
- */
-extern struct mm_struct * mm_alloc(void);
-
-/* mmdrop drops the mm and the page tables */
-extern void __mmdrop(struct mm_struct *);
-static inline void mmdrop(struct mm_struct * mm)
-{
-	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
-		__mmdrop(mm);
-}
-
-/* mmput gets rid of the mappings and all user-space */
-extern void mmput(struct mm_struct *);
-/* Grab a reference to a task's mm, if it is not already going away */
-extern struct mm_struct *get_task_mm(struct task_struct *task);
-/* Remove the current tasks stale references to the old mm_struct */
-extern void mm_release(struct task_struct *, struct mm_struct *);
-/* Allocate a new mm structure and copy contents from tsk->mm */
-extern struct mm_struct *dup_mm(struct task_struct *tsk);
-
 extern int copy_thread(unsigned long, unsigned long, unsigned long,
 			struct task_struct *, struct pt_regs *);
 extern void flush_thread(void);
@@ -2528,20 +2430,6 @@ static inline void inc_syscw(struct task_struct *tsk)
 extern void task_oncpu_function_call(struct task_struct *p,
 				     void (*func) (void *info), void *info);
 
-
-#ifdef CONFIG_MM_OWNER
-extern void mm_update_next_owner(struct mm_struct *mm);
-extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
-#else
-static inline void mm_update_next_owner(struct mm_struct *mm)
-{
-}
-
-static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
-{
-}
-#endif /* CONFIG_MM_OWNER */
-
 static inline unsigned long task_rlimit(const struct task_struct *tsk,
 		unsigned int limit)
 {
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -5,6 +5,7 @@
 #include <linux/nsproxy.h>
 #include <linux/sched.h>
 #include <linux/err.h>
+#include <linux/workqueue.h>
 
 #define UIDHASH_BITS	(CONFIG_BASE_SMALL ? 3 : 8)
 #define UIDHASH_SZ	(1 << UIDHASH_BITS)
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -40,6 +40,7 @@
 #ifndef _SOCK_H
 #define _SOCK_H
 
+#include <linux/aio.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/list_nulls.h>
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -59,6 +59,7 @@
 #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 #include <linux/eventfd.h>
 #include <linux/poll.h>
+#include <linux/workqueue.h>
 
 #include <asm/atomic.h>
 
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -11,6 +11,7 @@
  * management can be a bitch. See 'mm/memory.c': 'copy_page_range()'
  */
 
+#include <linux/aio.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/unistd.h>
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kobject.h>
+#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/resume-trace.h>
 #include <linux/workqueue.h>
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <linux/regset.h>
 
 
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/hash.h>
+#include <linux/workqueue.h>
 
 #define ODEBUG_HASH_BITS	14
 #define ODEBUG_HASH_SIZE	(1 << ODEBUG_HASH_BITS)
--- a/lib/is_single_threaded.c
+++ b/lib/is_single_threaded.c
@@ -10,6 +10,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#include <linux/mm.h>
 #include <linux/sched.h>
 
 /*
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -20,6 +20,7 @@
  * This file is released under the GPL.
  */
 
+#include <linux/aio.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/vfs.h>
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/workqueue.h>
 #include <keys/keyring-type.h>
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
