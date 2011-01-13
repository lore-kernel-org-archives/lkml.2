Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab1AMNwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:52:42 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:38310 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab1AMNwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:52:35 -0500
X-ASG-Debug-ID: 1294926754-71f7b1fe0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D2F03A7.2030809@fusionio.com>
Date: Thu, 13 Jan 2011 14:52:39 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] core block bits for 2.6.38
Content-Type: text/plain; charset="UTF-8"
X-ASG-Orig-Subj: [GIT PULL] core block bits for 2.6.38
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1294926754
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.52262
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Below are the core block bits for 2.6.38.

- Various optimizations and cleanups for CFQ from Gui and Shaohua

- Allow for hierarchical cgroups from Vivek.

- The in-kernel polling framework from Tejun. This means we can finally
  get cdrom notifications correct.

The remainder is mostly little things here and there, cleanups and so on.
Apart from Tejuns works, there's nothing earth shattering in here.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.38/core


Bart Van Assche (1):
      block: Clean up exit_io_context() source code.

Gui Jianfeng (3):
      cfq-iosched: Get rid of st->active
      cfq-iosched: Get rid of on_st flag
      cfq-iosched: don't check cfqg in choose_service_tree()

Jeff Moyer (1):
      block: trace event block fix unassigned field

Jens Axboe (9):
      Merge branch 'v2.6.37-rc2' into for-2.6.38/core
      Merge branch 'for-2.6.38/rc2-holder' into for-2.6.38/core
      Merge branch 'cleanup-bd_claim' of git://git.kernel.org/.../tj/misc into for-2.6.38/core
      cdrom: export cdrom_check_events()
      Fix compile warnings due to missing removal of a 'ret' variable
      Revert "sd: implement sd_check_events()"
      block: add internal hd part table references
      block: ensure that completion error gets properly traced
      Merge branch 'for-2.6.38/event-handling' into for-2.6.38/core

Jerome Marchand (2):
      kref: add kref_test_and_get
      block: fix accounting bug on cross partition merges

Kay Sievers (1):
      block: export 'ro' sysfs attribute for partitions

Mathieu Desnoyers (1):
      blktrace: add missing probe argument to block_bio_complete

Michał Mirosław (1):
      fs/splice: Pull buf->ops->confirm() from splice_from_pipe actors

Mike Snitzer (1):
      block: Rename "block_remap" tracepoint to "block_bio_remap" to clarify the event.

Shaohua Li (6):
      cfq-iosched: do cleanup
      cfq-iosched: schedule dispatch for noidle queue
      cfq-iosched: don't idle if a deep seek queue is slow
      cfq-iosched: don't schedule a dispatch for a non-idle queue
      block cfq: don't use atomic_t for cfq_queue
      block cfq: don't use atomic_t for cfq_group

Shaohua Li writes (1):
      block cfq: select new workload if priority changed

Tejun Heo (17):
      mtd: fix bdev exclusive open bugs in block2mtd::add_device()
      btrfs: close_bdev_exclusive() should use the same @flags as the matching open_bdev_exclusive()
      block: simplify holder symlink handling
      block: make blkdev_get/put() handle exclusive access
      block: reorganize claim/release implementation
      block: check bdev_read_only() from blkdev_get()
      block: clean up blkdev_get() wrappers and their users
      block: kill genhd_media_change_notify()
      block: move register_disk() and del_gendisk() to block/genhd.c
      implement in-kernel gendisk events handling
      cdrom: add ->check_events() support
      scsi: fix TUR error handling in sr_media_change()
      scsi: replace sr_test_unit_ready() with scsi_test_unit_ready()
      sr: implement sr_check_events()
      sd: implement sd_check_events()
      block: make kblockd_workqueue smarter
      bio-integrity: mark kintegrityd_wq highpri and CPU intensive

Vivek Goyal (1):
      blk-cgroup: Allow creation of hierarchical cgroups

Yang Zhang (2):
      block: convert !IS_ERR(p) && p to !IS_ERR_NOR_NULL(p)
      fs/block: type signature of major_to_index(int) to major_to_index(unsigned)

 Documentation/cgroups/blkio-controller.txt |   27 +
 block/blk-cgroup.c                         |    4 -
 block/blk-core.c                           |   40 ++-
 block/blk-ioc.c                            |    5 +-
 block/blk-merge.c                          |    3 +-
 block/cfq-iosched.c                        |  112 +++--
 block/genhd.c                              |  550 +++++++++++++++++++--
 block/ioctl.c                              |    5 +-
 drivers/block/drbd/drbd_int.h              |    2 -
 drivers/block/drbd/drbd_main.c             |    7 +-
 drivers/block/drbd/drbd_nl.c               |  105 ++---
 drivers/block/loop.c                       |    6 +-
 drivers/block/pktcdvd.c                    |   22 +-
 drivers/cdrom/cdrom.c                      |   56 ++-
 drivers/char/raw.c                         |   14 +-
 drivers/md/dm-table.c                      |   20 +-
 drivers/md/dm.c                            |    6 +-
 drivers/md/md.c                            |   16 +-
 drivers/mtd/devices/block2mtd.c            |   10 +-
 drivers/s390/block/dasd_genhd.c            |    2 +-
 drivers/scsi/scsi_lib.c                    |   13 +-
 drivers/scsi/sd.c                          |   10 +-
 drivers/scsi/sr.c                          |  174 ++++---
 drivers/scsi/sr.h                          |    3 +-
 drivers/scsi/sr_ioctl.c                    |    2 +-
 drivers/usb/gadget/storage_common.c        |    7 +-
 fs/bio-integrity.c                         |    7 +-
 fs/block_dev.c                             |  741 ++++++++++------------------
 fs/btrfs/volumes.c                         |   28 +-
 fs/btrfs/volumes.h                         |    2 +-
 fs/char_dev.c                              |    2 +-
 fs/ext3/super.c                            |   12 +-
 fs/ext4/super.c                            |   12 +-
 fs/gfs2/ops_fstype.c                       |    8 +-
 fs/jfs/jfs_logmgr.c                        |   17 +-
 fs/logfs/dev_bdev.c                        |    7 +-
 fs/nfsd/vfs.c                              |    5 -
 fs/nilfs2/super.c                          |    8 +-
 fs/ocfs2/cluster/heartbeat.c               |    2 +-
 fs/partitions/check.c                      |  106 +----
 fs/reiserfs/journal.c                      |   21 +-
 fs/splice.c                                |   43 +--
 fs/super.c                                 |   19 +-
 fs/xfs/linux-2.6/xfs_super.c               |    5 +-
 include/linux/blkdev.h                     |    5 +-
 include/linux/cdrom.h                      |    6 +
 include/linux/fs.h                         |   26 +-
 include/linux/genhd.h                      |   45 ++-
 include/scsi/scsi.h                        |    1 +
 include/trace/events/block.h               |   12 +-
 kernel/power/swap.c                        |    5 +-
 kernel/trace/blktrace.c                    |   37 +-
 mm/swapfile.c                              |    7 +-
 53 files changed, 1324 insertions(+), 1086 deletions(-)

-- 
Jens Axboe

