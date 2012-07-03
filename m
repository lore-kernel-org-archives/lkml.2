Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2GCW0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:26:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40487 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab2GCW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:26:36 -0400
Message-ID: <4FF37190.5020706@kernel.dk>
Date: Tue, 03 Jul 2012 16:26:24 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 3.5-rc
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As vacation is coming up, thought I'd better get rid of my pending
changes in my for-linus branch for this iteration. It contains:

- Two patches for mtip32xx. Killing a non-compliant sysfs interface and
  moving it to debugfs, where it belongs.

- A few patches from Asias. Two legit bug fixes, and one killing an
  interface that is no longer in use.

- A patch from Jan, making the annoying partition ioctl warning a bit
  less annoying, by restricting it to !CAP_SYS_RAWIO only.

- Three bug fixes for drbd from Lars Ellenberg.

- A fix for an old regression for umem, it hasn't really worked since
  the plugging scheme was changed in 3.0.

- A few fixes from Tejun.

- A splice fix from Eric Dumazet, fixing an issue with pipe resizing.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

for you to fetch changes up to 6d9359280753d2955f86d6411047516a9431eb51:

  scsi: Silence unnecessary warnings about ioctl to partition (2012-06-15 12:52:46 +0200)

----------------------------------------------------------------
Asai Thambi S P (2):
      mtip32xx: Remove 'registers' and 'flags' from sysfs
      mtip32xx: Create debugfs entries for troubleshooting

Asias He (3):
      block: Avoid missed wakeup in request waitqueue
      block: Mitigate lock unbalance caused by lock switching
      block: Drop dead function blk_abort_queue()

Eric Dumazet (1):
      splice: fix racy pipe->buffers uses

Jan Kara (1):
      scsi: Silence unnecessary warnings about ioctl to partition

Jens Axboe (2):
      Merge branch 'stable/for-jens-3.5' of git://git.kernel.org/.../konrad/xen into for-linus
      Merge branch 'for-jens' of git://git.drbd.org/linux-drbd into for-linus

Konrad Rzeszutek Wilk (2):
      xen/blkback: Copy id field when doing BLKIF_DISCARD.
      xen/blkfront: Add WARN to deal with misbehaving backends.

Lars Ellenberg (3):
      drbd: fix access of unallocated pages and kernel panic
      drbd: fix list corruption by failing but already aborted reads
      drbd: fix null pointer dereference with on-congestion policy when diskless

Sachin Kamat (1):
      mtip32xx: Remove version.h header file inclusion

Tao Guo (1):
      umem: fix up unplugging

Tejun Heo (4):
      block: fix return value on cfq_init() failure
      block: blkcg_policy_cfq shouldn't be used if !CONFIG_CFQ_GROUP_IOSCHED
      blkcg: fix blkg_alloc() failure path
      blkcg: drop local variable @q from blkg_destroy()

 Documentation/ABI/testing/sysfs-block-rssd |   21 ----
 block/blk-cgroup.c                         |    9 +-
 block/blk-core.c                           |   25 ++++-
 block/blk-timeout.c                        |   41 -------
 block/cfq-iosched.c                        |   30 +++--
 block/scsi_ioctl.c                         |    5 +-
 drivers/block/drbd/drbd_bitmap.c           |   11 +-
 drivers/block/drbd/drbd_req.c              |   66 +++++++----
 drivers/block/mtip32xx/mtip32xx.c          |  166 ++++++++++++++++++++--------
 drivers/block/mtip32xx/mtip32xx.h          |    5 +-
 drivers/block/umem.c                       |   40 +++++++
 drivers/block/xen-blkback/common.h         |    2 +
 drivers/block/xen-blkfront.c               |   58 ++++++++--
 fs/splice.c                                |   35 +++---
 include/linux/blkdev.h                     |    1 -
 include/linux/splice.h                     |    8 +-
 kernel/relay.c                             |    5 +-
 kernel/trace/trace.c                       |    6 +-
 mm/shmem.c                                 |    3 +-
 net/core/skbuff.c                          |    1 +
 20 files changed, 338 insertions(+), 200 deletions(-)

-- 
Jens Axboe


