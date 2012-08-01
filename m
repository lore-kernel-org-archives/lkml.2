Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2HAMVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:21:04 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:42301 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab2HAMVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:21:01 -0400
X-ASG-Debug-ID: 1343823660-03d6a5408e1a1220001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50191F25.60806@fusionio.com>
Date: Wed, 1 Aug 2012 14:20:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: [GIT PULL] Block driver changes for 3.6
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Block driver changes for 3.6
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1343823660
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.104368
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are the driver bits for 3.6, based on (an earlier version)
of for-3.6/core that I just asked you to pull. It contains:

- Making the plugging support for drivers a bit more sane from
  Neil. This supersedes the plugging change from Shaohua as well.
- The usual round of drbd updates.
- Using a tail add instead of a head add in the request completion
  for ndb, making us find the most completed request more quickly.
- A few floppy changes, getting rid of a duplicated flag and also
  running the floppy init async (since it takes forever in boot
  terms) from Andi.


  git://git.kernel.dk/linux-block.git for-3.6/drivers

Andi Kleen (1):
      floppy: Run floppy initialization asynchronous

Chetan Loke (1):
      block/nbd: micro-optimization in nbd request completion

Fengguang Wu (1):
      floppy: remove duplicated flag FD_RAW_NEED_DISK

Jens Axboe (3):
      Merge branch 'upstream' of git://git.kernel.org/.../jikos/floppy into for-3.6/drivers
      Merge branch 'for-jens' of git://git.drbd.org/linux-drbd into for-3.6/drivers
      Merge branch 'upstream' of git://git.kernel.org/.../jikos/floppy into for-3.6/drivers

Lars Ellenberg (10):
      drbd: cleanup, remove two unused global flags
      drbd: differentiate between normal and forced detach
      drbd: report congestion if we are waiting for some userland callback
      drbd: reset congestion information before reporting it in /proc/drbd
      drbd: do not reset rs_pending_cnt too early
      drbd: call local-io-error handler early
      drbd: fix potential access after free
      drbd: flush drbd work queue before invalidate/invalidate remote
      drbd: fix max_bio_size to be unsigned
      drbd: announce FLUSH/FUA capability to upper layers

NeilBrown (3):
      md: remove plug_cnt feature of plugging.
      blk: centralize non-request unplug handling.
      blk: pass from_schedule to non-request unplug functions.

Shaohua Li (1):
      block: stack unplug

 Documentation/block/queue-sysfs.txt |   7 +
 block/blk-cgroup.c                  | 139 +++++++++++++-------
 block/blk-cgroup.h                  | 128 +++++++++++++++++-
 block/blk-core.c                    | 253 +++++++++++++++++++++---------------
 block/blk-sysfs.c                   |  34 ++---
 block/blk-throttle.c                |   3 -
 block/blk.h                         |   3 +
 block/bsg-lib.c                     |  53 --------
 drivers/block/drbd/drbd_actlog.c    |   8 +-
 drivers/block/drbd/drbd_bitmap.c    |   4 +-
 drivers/block/drbd/drbd_int.h       |  44 +++++--
 drivers/block/drbd/drbd_main.c      |  65 ++++++---
 drivers/block/drbd/drbd_nl.c        |  36 +++--
 drivers/block/drbd/drbd_proc.c      |   3 +
 drivers/block/drbd/drbd_receiver.c  |  38 ++++--
 drivers/block/drbd/drbd_req.c       |   9 +-
 drivers/block/drbd/drbd_worker.c    |  12 +-
 drivers/block/floppy.c              |  24 +++-
 drivers/block/nbd.c                 |   2 +-
 drivers/block/umem.c                |  37 +-----
 drivers/md/md.c                     |  59 +--------
 drivers/md/md.h                     |  11 +-
 drivers/md/raid1.c                  |   3 +-
 drivers/md/raid10.c                 |   3 +-
 drivers/md/raid5.c                  |   5 +-
 drivers/scsi/scsi_transport_fc.c    |  38 ------
 drivers/scsi/scsi_transport_iscsi.c |   2 +-
 include/linux/blkdev.h              |  61 +++++----
 include/linux/bsg-lib.h             |   1 -
 include/linux/mempool.h             |   3 +-
 mm/mempool.c                        |  12 +-
 31 files changed, 634 insertions(+), 466 deletions(-)

-- 
Jens Axboe

