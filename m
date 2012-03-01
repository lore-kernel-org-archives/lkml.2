Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab2CACfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:35:21 -0500
Received: from mail.windriver.com ([147.11.1.11]:44766 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab2CACfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:35:20 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/3] RFC - module.h usage cleanups in fs/ and lib/
Date: Wed, 29 Feb 2012 21:35:06 -0500
Message-Id: <1330569309-26190-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up files in fs/ and lib/ dirs to only use module.h if they really
need it.

These are trivial in scope vs. the work done previously.  We now have things
where any few remaining cleanups can be farmed out to arch or subsystem
maintainers, and I have done so when possible.  What is remaining here
represents the bits that don't clearly lie within a single arch/subsystem
boundary, like the fs dir and the lib dir.

Some duplicate includes arising from overlapping fixes from independent
subsystem maintainer submissions are also quashed.

Since these are largely arch/subsystem independent, I'm thinking that
I'll request a pull of these directly, and so all I'm hoping for here
is any general review comments.  (I've stuck Al and Andrew on the CC
since I think of them for "owning" the fs and lib dirs respectively.)

Thanks,
Paul.
---

Paul Gortmaker (3):
  includecheck: delete any duplicate instances of module.h
  fs: reduce the use of module.h wherever possible
  lib: reduce the use of module.h wherever possible

 arch/blackfin/mach-bf537/boards/pnav10.c  |    1 -
 drivers/dma/imx-dma.c                     |    1 -
 drivers/dma/imx-sdma.c                    |    1 -
 drivers/media/video/adp1653.c             |    1 -
 drivers/mmc/host/sdhci-tegra.c            |    1 -
 drivers/power/max8998_charger.c           |    1 -
 drivers/staging/iio/dac/ad5686.c          |    1 -
 drivers/staging/iio/gyro/adis16060_core.c |    1 -
 drivers/staging/sm7xx/smtcfb.c            |    1 -
 drivers/usb/dwc3/core.c                   |    1 -
 drivers/usb/dwc3/dwc3-omap.c              |    1 -
 fs/aio.c                                  |    2 +-
 fs/attr.c                                 |    2 +-
 fs/bad_inode.c                            |    2 +-
 fs/binfmt_flat.c                          |    2 +-
 fs/bio.c                                  |    2 +-
 fs/buffer.c                               |    2 +-
 fs/compat.c                               |    1 -
 fs/compat_ioctl.c                         |    1 -
 fs/dcache.c                               |    2 +-
 fs/dcookies.c                             |    2 +-
 fs/eventfd.c                              |    2 +-
 fs/file.c                                 |    2 +-
 fs/fs-writeback.c                         |    2 +-
 fs/fs_struct.c                            |    2 +-
 fs/inode.c                                |    2 +-
 fs/ioctl.c                                |    2 +-
 fs/libfs.c                                |    2 +-
 fs/mpage.c                                |    2 +-
 fs/namei.c                                |    2 +-
 fs/posix_acl.c                            |    2 +-
 fs/read_write.c                           |    2 +-
 fs/readdir.c                              |    2 +-
 fs/select.c                               |    2 +-
 fs/seq_file.c                             |    2 +-
 fs/splice.c                               |    2 +-
 fs/stack.c                                |    2 +-
 fs/stat.c                                 |    2 +-
 fs/statfs.c                               |    2 +-
 fs/super.c                                |    2 +-
 fs/sync.c                                 |    2 +-
 fs/xattr.c                                |    2 +-
 fs/xattr_acl.c                            |    2 +-
 kernel/params.c                           |    1 -
 lib/argv_split.c                          |    2 +-
 lib/atomic64.c                            |    2 +-
 lib/average.c                             |    3 ++-
 lib/bcd.c                                 |    2 +-
 lib/bitmap.c                              |    2 +-
 lib/bsearch.c                             |    2 +-
 lib/check_signature.c                     |    2 +-
 lib/checksum.c                            |    2 +-
 lib/cmdline.c                             |    2 +-
 lib/cpu_rmap.c                            |    2 +-
 lib/cpumask.c                             |    2 +-
 lib/ctype.c                               |    3 ++-
 lib/debug_locks.c                         |    2 +-
 lib/dec_and_lock.c                        |    2 +-
 lib/devres.c                              |    2 +-
 lib/div64.c                               |    3 ++-
 lib/dump_stack.c                          |    2 +-
 lib/fault-inject.c                        |    2 +-
 lib/find_last_bit.c                       |    2 +-
 lib/find_next_bit.c                       |    2 +-
 lib/flex_array.c                          |    2 +-
 lib/gcd.c                                 |    2 +-
 lib/genalloc.c                            |    2 +-
 lib/halfmd4.c                             |    2 +-
 lib/hexdump.c                             |    2 +-
 lib/hweight.c                             |    2 +-
 lib/idr.c                                 |    2 +-
 lib/int_sqrt.c                            |    2 +-
 lib/iomap.c                               |    2 +-
 lib/iomap_copy.c                          |    2 +-
 lib/iommu-helper.c                        |    2 +-
 lib/ioremap.c                             |    2 +-
 lib/irq_regs.c                            |    3 ++-
 lib/kasprintf.c                           |    2 +-
 lib/klist.c                               |    2 +-
 lib/kobject.c                             |    2 +-
 lib/kobject_uevent.c                      |    3 ++-
 lib/kstrtox.c                             |    2 +-
 lib/lcm.c                                 |    2 +-
 lib/list_debug.c                          |    3 ++-
 lib/llist.c                               |    2 +-
 lib/locking-selftest.c                    |    1 -
 lib/md5.c                                 |    2 +-
 lib/nlattr.c                              |    2 +-
 lib/parser.c                              |    3 ++-
 lib/radix-tree.c                          |    2 +-
 lib/random32.c                            |    2 +-
 lib/ratelimit.c                           |    2 +-
 lib/rational.c                            |    3 ++-
 lib/rbtree.c                              |    2 +-
 lib/rwsem-spinlock.c                      |    2 +-
 lib/rwsem.c                               |    2 +-
 lib/scatterlist.c                         |    2 +-
 lib/sha1.c                                |    2 +-
 lib/smp_processor_id.c                    |    2 +-
 lib/spinlock_debug.c                      |    2 +-
 lib/string.c                              |    4 +++-
 lib/string_helpers.c                      |    2 +-
 lib/swiotlb.c                             |    2 +-
 lib/syscall.c                             |    2 +-
 lib/timerqueue.c                          |    2 +-
 lib/uuid.c                                |    2 +-
 lib/vsprintf.c                            |    2 +-
 107 files changed, 102 insertions(+), 107 deletions(-)

-- 
1.7.9.1

