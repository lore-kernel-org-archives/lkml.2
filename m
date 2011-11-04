Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab1KDUHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:07:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:56983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1KDUHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:07:15 -0400
Message-ID: <4EB445F0.10709@kernel.dk>
Date: Fri, 04 Nov 2011 21:07:12 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block IO driver changes for 3.2
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the driver part of the 3.2 block IO pull requests. The major
parts are:

- Various bug fixes to xen blkfront/blkback.

- Bug fixes for CISS and hpsa.

- Discard support for loop. This is useful for trimming image size, and
  also for finding bugs in the file system discard code.

- Improve virtio-blk disk index allocation scheme by using ida instead.
  This avoids a wrapping problem.

- A set of bug fixes for nbd.

This depends on the previous pull request, for-3.2/core.

Please pull!

  git://git.kernel.dk/linux-block.git for-3.2/drivers

Andrew Morton (1):
      nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes

Ayan George (1):
      drivers/block/loop.c: remove unnecessary bdev argument from loop_clr_fd()

Jan Beulich (1):
      xen-blkback: use kzalloc() in favor of kmalloc()+memset()

Jens Axboe (2):
      Merge branch 'for-3.2/core' into for-3.2/drivers
      Merge branch 'stable/for-jens-3.2' of git://oss.oracle.com/git/kwilk/xen into for-3.2/drivers

Joe Handzik (1):
      cciss: add transport mode attribute to sys

Joe Jin (1):
      xen-blkback: fixed indentation and comments

Joseph Handzik (1):
      cciss: Adds simple mode functionality

Kay Sievers (1):
      loop: always allow userspace partitions and optionally support automatic scanning

Konrad Rzeszutek Wilk (6):
      xen-blkfront: If no barrier or flush is supported, use invalid operation.
      xen/blkback: Support 'feature-barrier' aka old-style BARRIER requests.
      xen/blkback: Report VBD_WSECT (wr_sect) properly.
      xen/blkback: Fix the inhibition to map pages when discarding sector ranges.
      xen/blkback: Check for proper operation.
      xen/blkback: Fix two races in the handling of barrier requests.

Laszlo Ersek (1):
      xen-blkfront: plug device number leak in xlblk_init() error path

Li Dongyang (4):
      xen-blkfront: add BLKIF_OP_DISCARD and discard request struct
      xen-blkback: Implement discard requests ('feature-discard')
      xen-blkfront: Handle discard requests.
      xen-blkfront: fix a deadlock while handling discard response

Lukas Czerner (1):
      loop: add discard support for loop devices

Michael S. Tsirkin (1):
      virtio-blk: use ida to allocate disk index

Mike Miller (2):
      cciss: add small delay when using PCI Power Management to reset for kump
      hpsa: add small delay when using PCI Power Management to reset for kump

Phillip Susi (1):
      drivers/block/loop.c: emit uevent on auto release

Sergei Shtylyov (1):
      drivers/block/cpqarray.c: use pci_dev->revision

Tejun Heo (1):
      block: add GENHD_FL_NO_PART_SCAN

WANG Cong (5):
      nbd: use task_pid_nr() to get current pid
      nbd: replace sysfs_create_file() with device_create_file()
      nbd: replace printk KERN_ERR with dev_err()
      nbd: lower the loglevel of an error message
      nbd: replace some printk with dev_warn() and dev_info()

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +
 Documentation/blockdev/cciss.txt                   |   10 ++
 block/genhd.c                                      |    4 +-
 block/ioctl.c                                      |    2 +-
 drivers/block/cciss.c                              |   76 ++++++++++--
 drivers/block/cciss.h                              |    1 +
 drivers/block/cpqarray.c                           |    2 +-
 drivers/block/loop.c                               |  110 ++++++++++++++++-
 drivers/block/nbd.c                                |   69 +++++------
 drivers/block/virtio_blk.c                         |   30 ++++-
 drivers/block/xen-blkback/blkback.c                |  130 ++++++++++++++++---
 drivers/block/xen-blkback/common.h                 |  100 ++++++++++++---
 drivers/block/xen-blkback/xenbus.c                 |   80 ++++++++++++-
 drivers/block/xen-blkfront.c                       |  123 +++++++++++++++----
 drivers/scsi/hpsa.c                                |    7 +
 fs/block_dev.c                                     |    2 +-
 include/linux/genhd.h                              |    6 +-
 include/linux/loop.h                               |    1 +
 include/xen/interface/io/blkif.h                   |   36 ++++++
 19 files changed, 664 insertions(+), 132 deletions(-)

-- 
Jens Axboe

