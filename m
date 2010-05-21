Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab0EUTUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 15:20:31 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52413 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934001Ab0EUTU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 15:20:28 -0400
Date: Fri, 21 May 2010 21:20:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block tree for 2.6.35
Message-ID: <20100521192026.GB23411@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the initial (and big) part of the bits stashed in the block git
tree for 2.6.35.

- A good bunch of IO controller updates. I apologize for the quality of
  the changelog for those, I should have caught that in due time. Will
  not happen again.
- Updates and additions to the discard requests.
- A big drbd update.
- Fixes for a few writeback bugs and regressions.
- The pipe grow/shrink support with the default 256 page limit and
  a proc file for root to modify that limit.
- Make laptop mode per-device instead of a global setting.
- And of course a good bunch of bug fixes.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.35

Adam Gandelman (1):
      drbd: New handler: initial-split-brain

Divyesh Shah (11):
      blkio: Remove per-cfqq nr_sectors as we'll be passing
      blkio: Add io controller stats like
      blkio: Increment the blkio cgroup stats for real now
      blkio: Changes to IO controller additional stats patches
      blkio: Add io_merged stat
      blkio: Add io_queued and avg_queue_size stats
      blkio: Add more debug-only per-cgroup stats
      block: Update to io-controller stats
      blkio: Fix compile errors
      blkio: fix for modular blk-cgroup build
      blkio: Initialize blkg->stats_lock for the root cfqg too

Dmitry Monakhov (6):
      blkdev: generalize flags for blkdev_issue_fn functions
      blkdev: allow async blkdev_issue_flush requests
      blkdev: move blkdev_issue helper functions to separate file
      blkdev: add blkdev_issue_zeroout helper function
      cfq-iosched: fix broken cfq_ref_get_cfqf() for CONFIG_BLK_CGROUP=y && CFQ_GROUP_IOSCHED=n
      writeback: Update dirty flags in two steps

Gui Jianfeng (2):
      io-controller: Add a new interface "weight_device" for IO-Controller
      io-controller: Document for blkio.weight_device

Jens Axboe (14):
      Merge branch 'for-linus' into for-2.6.35
      Merge branch 'master' into for-2.6.35
      block: fix bad use of min() on different types
      Merge branch 'master' into for-2.6.35
      block: kill some useless goto's in blk-cgroup.c
      writeback: disable periodic old data writeback for !dirty_writeback_centisecs
      writeback: fix WB_SYNC_NONE writeback from umount
      writeback: ensure that WB_SYNC_NONE writeback with sb pinned is sync
      writeback: bdi_writeback_task() must set task state before calling schedule()
      writeback: fixups for !dirty_writeback_centisecs
      writeback: fix problem with !CONFIG_BLOCK compilation
      writeback: fix mixed up arguments to bdi_start_writeback()
      pipe: add support for shrinking and growing pipes
      pipe: set lower and upper limit on max pages in the pipe page array

Julia Lawall (1):
      drivers/block/drbd: Use kzalloc

Lars Ellenberg (11):
      drbd: use proc_create_data with explicit NULL argument
      drbd: fix regression: attach while connected failed
      drbd: remove bogus ASSERT
      drbd: fix potential protocol error
      drbd: don't start a resync without access to up-to-date Data
      drbd: check for corrupt or malicous sector addresses when receiving data
      drbd: fail_requests_early: remove incorrect and unnecessary optimization
      drbd: reduce sizeof struct drbd_epoch_entry by 8 byte by aligning members
      drbd: Allow drbd_epoch_entries to use multiple bios.     This should allow for better performance if the lower level IO stack     of the peers differs in limits exposed either via the queue,     or via some merge_bvec_fn.
      drbd: allow resync requests to be larger than max_segment_size
      drbd: always use_bmbv, ignore setting

Matthew Garrett (1):
      laptop-mode: Make flushes per-device

Mike Snitzer (1):
      block: allow initialization of previously allocated request_queue

Paul E. McKenney (1):
      block: remove all rcu head initializations

Philipp Reisner (27):
      drbd: Do not upgrade state to Outdated if already Inconsistent [Bugz 277]
      drbd: cleanup: This code path to trigger a resync is no longer needed
      drbd: made determin_dev_size's parameter an flag enum
      drbd: Implemented the set_new_bits parameter for drbd_bm_resize()
      drbd: Implemented flags for the resize packet
      drbd: Make sure to resync all of the new storage upon online resize
      drbd: Added some missing statics
      drbd: Implemented the --assume-clean option for drbdsetup resize
      drbd: bugfix: Make resize work, if remote's size was limiting and increased in the meantime
      drbd: Added transmission faults to the fault injection code
      drbd: Fixed bitmap in case of online-grow without resync
      drbd: Receiving of delay_probes
      drbd: Sending of delay_probes
      drbd: Four new configuration settings for resync speed control
      drbd: Actually send delay probes
      drbd: Control the actual resync rate based on the queuing delay of data packets
      drbd: Proc bits of new resync speed stuff
      drbd: A fixes to the new resync speed code
      drbd: Fixes to the new delay_probes code
      drbd: If we detect late that IO got frozen, retry after we thawed.
      drbd: Create new current UUID as late as possible
      drbd: Do not Oops when C_STANDALONE when uuid gets generated
      drbd: Ensure to not trigger late-new-UUID creation multiple times
      drbd: Fix: Do not detach, if a bio with a barrier fails
      drbd: Null pointer deref fix to the large "multi bio rewrite"
      drbd: Do not free p_uuid early, this is done in the exit code of the receiver
      drbd: This is now equivalent to drbd release 8.3.8rc1

Randy Dunlap (1):
      paride: fix menu indentation

Richard Kennedy (1):
      block: ensure jiffies wrap is handled correctly in blk_rq_timed_out_timer

Stephen Rothwell (1):
      nilfs: fix breakage caused by barrier flag changes

Tejun Heo (7):
      block: factor out bd_may_claim()
      block: implement bd_claiming and claiming block
      buffer: make invalidate_bdev() drain all percpu LRU add caches
      block: restart partition scan after resizing a device
      block,ide: simplify bdops->set_capacity() to ->unlock_native_capacity()
      block: use struct parsed_partitions *state universally in partition check code
      block: improve automatic native capacity unlocking

Vivek Goyal (3):
      blkio: Fix blkio crash during rq stat update
      blkio: Fix another BUG_ON() crash due to cfqq movement across groups
      blk-cgroup: config options re-arrangement

 Documentation/cgroups/blkio-controller.txt |  151 +++++-
 block/Kconfig                              |   23 -
 block/Kconfig.iosched                      |   16 +-
 block/Makefile                             |    2 +-
 block/blk-barrier.c                        |  147 +-----
 block/blk-cgroup.c                         |  791 +++++++++++++++++++++++++---
 block/blk-cgroup.h                         |  178 ++++++-
 block/blk-core.c                           |   31 +-
 block/blk-lib.c                            |  233 ++++++++
 block/cfq-iosched.c                        |   81 +++-
 block/elevator.c                           |   11 +
 block/genhd.c                              |    2 +-
 block/ioctl.c                              |    2 +-
 drivers/block/Kconfig                      |   22 +-
 drivers/block/drbd/drbd_bitmap.c           |   21 +-
 drivers/block/drbd/drbd_int.h              |  151 +++++-
 drivers/block/drbd/drbd_main.c             |  158 +++++-
 drivers/block/drbd/drbd_nl.c               |   52 +-
 drivers/block/drbd/drbd_proc.c             |   19 +-
 drivers/block/drbd/drbd_receiver.c         |  666 +++++++++++++++---------
 drivers/block/drbd/drbd_req.c              |   40 +-
 drivers/block/drbd/drbd_strings.c          |    2 +-
 drivers/block/drbd/drbd_worker.c           |  206 +++++---
 drivers/block/drbd/drbd_wrappers.h         |   16 +-
 drivers/ide/ide-disk.c                     |   40 +-
 drivers/ide/ide-gd.c                       |   11 +-
 fs/block_dev.c                             |  257 ++++++++--
 fs/btrfs/extent-tree.c                     |    2 +-
 fs/buffer.c                                |    1 +
 fs/ext3/fsync.c                            |    3 +-
 fs/ext4/fsync.c                            |    6 +-
 fs/fcntl.c                                 |    5 +
 fs/fs-writeback.c                          |   98 +++-
 fs/gfs2/rgrp.c                             |    5 +-
 fs/jbd2/checkpoint.c                       |    3 +-
 fs/jbd2/commit.c                           |    6 +-
 fs/nilfs2/the_nilfs.c                      |    4 +-
 fs/partitions/acorn.c                      |   68 ++--
 fs/partitions/acorn.h                      |   10 +-
 fs/partitions/amiga.c                      |   13 +-
 fs/partitions/amiga.h                      |    2 +-
 fs/partitions/atari.c                      |    8 +-
 fs/partitions/atari.h                      |    2 +-
 fs/partitions/check.c                      |   84 +++-
 fs/partitions/check.h                      |   12 +
 fs/partitions/efi.c                        |   91 ++--
 fs/partitions/efi.h                        |    2 +-
 fs/partitions/ibm.c                        |   21 +-
 fs/partitions/ibm.h                        |    2 +-
 fs/partitions/karma.c                      |    4 +-
 fs/partitions/karma.h                      |    2 +-
 fs/partitions/ldm.c                        |   89 ++--
 fs/partitions/ldm.h                        |    2 +-
 fs/partitions/mac.c                        |   11 +-
 fs/partitions/mac.h                        |    2 +-
 fs/partitions/msdos.c                      |   85 ++--
 fs/partitions/msdos.h                      |    2 +-
 fs/partitions/osf.c                        |    4 +-
 fs/partitions/osf.h                        |    2 +-
 fs/partitions/sgi.c                        |    6 +-
 fs/partitions/sgi.h                        |    2 +-
 fs/partitions/sun.c                        |    6 +-
 fs/partitions/sun.h                        |    2 +-
 fs/partitions/sysv68.c                     |    6 +-
 fs/partitions/sysv68.h                     |    2 +-
 fs/partitions/ultrix.c                     |    4 +-
 fs/partitions/ultrix.h                     |    2 +-
 fs/pipe.c                                  |  122 ++++-
 fs/reiserfs/file.c                         |    3 +-
 fs/splice.c                                |  151 ++++--
 fs/super.c                                 |    1 +
 fs/sync.c                                  |    2 +-
 fs/xfs/linux-2.6/xfs_super.c               |    3 +-
 include/linux/backing-dev.h                |    6 +-
 include/linux/blkdev.h                     |   70 ++-
 include/linux/drbd.h                       |    5 +-
 include/linux/drbd_limits.h                |   16 +
 include/linux/drbd_nl.h                    |    5 +
 include/linux/elevator.h                   |    6 +
 include/linux/fcntl.h                      |    6 +
 include/linux/fs.h                         |    1 +
 include/linux/ide.h                        |    2 +-
 include/linux/pipe_fs_i.h                  |   13 +-
 include/linux/splice.h                     |    7 +
 include/linux/writeback.h                  |   18 +-
 init/Kconfig                               |   27 +
 kernel/relay.c                             |   15 +-
 kernel/sched_clock.c                       |    1 +
 kernel/sysctl.c                            |    9 +
 kernel/trace/trace.c                       |   60 ++-
 mm/backing-dev.c                           |   15 +-
 mm/page-writeback.c                        |   44 +-
 mm/swapfile.c                              |    9 +-
 net/core/skbuff.c                          |   38 +-
 94 files changed, 3424 insertions(+), 1241 deletions(-)
 create mode 100644 block/blk-lib.c

-- 
Jens Axboe

