Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0DIHpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 03:45:18 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43599 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab0DIHpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 03:45:14 -0400
Date: Fri, 9 Apr 2010 09:45:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.34
Message-ID: <20100409074511.GG10103@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I apologize for this being somewhat larger than it usually is at that
point, it's mostly due to testing which has held off the submission
longer than I really wanted. But it's mostly good fixes, the odd one out
is the VFS writeback patch which makes the sb pinning a lot nicer. It's
been in -next for a long time, well over a month. So I consider it safe.

The drbd patches are largely focused on making 4kb block sizes work, it
would oops before.

The rest is mostly regression fixes and bug fixes. 2 of the fixes
already went in through Andrew the other day, but I did a merge check
and it'll pull cleanly. So I have not pulled in your latest tree. The
other pull in was to resolve a merge conflict a few weeks ago.

So please pull, thanks.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Anton Blanchard (1):
      backing-dev: Handle class_create() failure

Dan Carpenter (1):
      cciss: unlock on error path

Divyesh Shah (3):
      cfq-iosched: Add additional blktrace log messages in CFQ for easier debugging
      cfq-iosched: Do not merge queues of BE and IDLE classes
      cfq-iosched: Fix the incorrect timeslice accounting with forced_dispatch

Dmitry Monakhov (1):
      blkdev: fix merge_bvec_fn return value checks v2

Edward Shishkin (1):
      vfs: improve writeback_inodes_wb()

FUJITA Tomonori (1):
      Documentation: fix block/biodoc.txt dma mapping description

Ferenc Wagner (1):
      i2o: Remove the dangerous kobj_to_i2o_device macro

Jens Axboe (1):
      Merge branch 'master' into for-linus

Lars Ellenberg (6):
      drbd: fix NULL pointer dereference on 4k hard sect size
      drbd: fix broken state change after split-brain attach while connected
      fix unit of rs_same_csums accounting
      drbd_disconnect: grab meta.socket mutex as well
      drbd: add missing drbd command names to avoid <NULL> in error messages
      drbd: fix al-to-on-disk-bitmap for 4k logical_block_size

Li Zefan (1):
      block: make CONFIG_BLK_CGROUP visible

Martin K. Petersen (3):
      block: Fix overrun in lcm() and move it to lib
      block: Finalize conversion of block limits functions
      block: Export max number of segments and max segment size in sysfs

NeilBrown (1):
      Remove GENHD_FL_DRIVERFS

Nikanth Karthikesan (1):
      loop: Update mtime when writing using aops

Philipp Reisner (6):
      drbd: --dry-run option for drbdsetup net ( drbdadm -- --dry-run connect <res> )
      drbd: Reduce the time an empty resync takes usually
      drbd: Make sure we do not send state updates during an empty resync [Bugz 271]
      drbd: Forcing primary should also work for Consistent disks [Bugz 266]
      drbd: Renamed overwrite_peer to primary_force
      drbd: lc_element_by_index() never returns NULL

Richard Kennedy (1):
      block: remove 16 bytes of padding from struct request on 64bits

Ricky Benitez (1):
      block: expose the statistics in blkio.time and blkio.sectors for the root cgroup

Roel Kluin (1):
      paride: fix off-by-one test

Shaohua Li (1):
      cfq-iosched: fix a kbuild regression

Thomas Gleixner (1):
      block: drbd: Convert semaphore to mutex

William Cohen (1):
      Add DocBook documentation for the block tracepoints.

wzt.wzt@gmail.com (1):
      Block: Fix block/elevator.c elevator_get() off-by-one error

 Documentation/DocBook/tracepoint.tmpl |   13 +++
 Documentation/block/biodoc.txt        |    4 +-
 block/Kconfig                         |    3 +-
 block/blk-settings.c                  |   11 +--
 block/blk-sysfs.c                     |   25 +++++
 block/cfq-iosched.c                   |   41 ++++++--
 block/elevator.c                      |    2 +-
 drivers/block/DAC960.c                |    1 -
 drivers/block/cciss.c                 |    1 +
 drivers/block/drbd/drbd_actlog.c      |   19 +++-
 drivers/block/drbd/drbd_bitmap.c      |   10 +-
 drivers/block/drbd/drbd_int.h         |   12 ++-
 drivers/block/drbd/drbd_main.c        |   20 ++++-
 drivers/block/drbd/drbd_nl.c          |   44 +++++-----
 drivers/block/drbd/drbd_receiver.c    |   34 ++++++-
 drivers/block/drbd/drbd_worker.c      |   18 +++-
 drivers/block/loop.c                  |    2 +
 drivers/block/paride/pcd.c            |    4 +-
 drivers/block/paride/pf.c             |    4 +-
 drivers/block/paride/pt.c             |    4 +-
 drivers/block/virtio_blk.c            |    5 +-
 drivers/scsi/sd.c                     |    2 +-
 fs/bio.c                              |    4 +-
 fs/fs-writeback.c                     |  133 +++++++++++++++------------
 include/linux/blkdev.h                |   35 +------
 include/linux/drbd.h                  |    2 +-
 include/linux/drbd_nl.h               |    3 +-
 include/linux/genhd.h                 |    2 +-
 include/linux/i2o.h                   |    1 -
 include/linux/lcm.h                   |    8 ++
 include/linux/writeback.h             |    3 +
 include/trace/events/block.h          |  164 +++++++++++++++++++++++++++++++++
 lib/Makefile                          |    2 +-
 lib/lcm.c                             |   15 +++
 mm/backing-dev.c                      |    3 +
 35 files changed, 476 insertions(+), 178 deletions(-)
 create mode 100644 include/linux/lcm.h
 create mode 100644 lib/lcm.c

-- 
Jens Axboe

