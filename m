Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab2CXQgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 12:36:48 -0400
Received: from mail1.windriver.com ([147.11.146.13]:43103 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2CXQgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 12:36:47 -0400
Date: Sat, 24 Mar 2012 12:36:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL #2] Cleanup fs/ and lib/ users of module.h
Message-ID: <20120324163643.GB5573@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the 2nd of three cleanups I have for 3.4 content.

I know you will get four trivial conflicts as follows:

    dwc3-omap.c: commit 2cd0e8512169b125fb0ff1f9ec3f8505eecb3012
        "usb: dwc3: linux/module.h included twice"
    
    inode.c: commit e59cc473cc603d562f2c80c12c943ef2a8cde6b2
        "trim includes in inode.c"
    
    lib/ list_debug.c + string.c: commit 50af5ead3b44ccf8bd2b4d2a50
        "bug.h: add include of it to various implicit C users"

The last one assumes that you've already merged my cleanup #1.

Thanks,
Paul.
--

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git tags/module-for-3.4

for you to fetch changes up to 8bc3bcc93a2b4e47d5d410146f6546bca6171663:

  lib: reduce the use of module.h wherever possible (2012-03-07 15:04:04 -0500)

----------------------------------------------------------------
The following text was taken from the original review request:

	"[PATCH 0/3] RFC - module.h usage cleanups in fs/ and lib/"
		https://lkml.org/lkml/2012/2/29/589
--

Fix up files in fs/ and lib/ dirs to only use module.h if they really
need it.

These are trivial in scope vs. the work done previously.  We now have
things where any few remaining cleanups can be farmed out to arch or
subsystem maintainers, and I have done so when possible.  What is
remaining here represents the bits that don't clearly lie within a
single arch/subsystem boundary, like the fs dir and the lib dir.

Some duplicate includes arising from overlapping fixes from
independent subsystem maintainer submissions are also quashed.

----------------------------------------------------------------
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
 lib/bitmap.c                              |    3 ++-
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
 lib/string.c                              |    5 ++++-
 lib/string_helpers.c                      |    2 +-
 lib/swiotlb.c                             |    2 +-
 lib/syscall.c                             |    2 +-
 lib/timerqueue.c                          |    2 +-
 lib/uuid.c                                |    2 +-
 lib/vsprintf.c                            |    2 +-
 107 files changed, 104 insertions(+), 107 deletions(-)
