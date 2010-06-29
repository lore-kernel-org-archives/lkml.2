Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0F2Gsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 02:48:43 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44172 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab0F2Gsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 02:48:42 -0400
Message-ID: <4C299748.1050502@fusionio.com>
Date: Tue, 29 Jun 2010 08:48:40 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block/IO patches for 2.6.35-rc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The two important items in this batch is the writeback series from
Christoph, which has been simmering in -next since you left, and a fix
for the boot time warning with some combination of cgroup and the cfq
group io scheduler option. No issues have been reported so far on the
writeback side, and my testing looks good to.

Another important fix is the CFQ cooperative merge fix from Jeff. This
fixes a potential hang/crash with the scheduler (bugzilla 16217).

The remaining few bits are just minor fixes.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Christoph Hellwig (9):
      writeback: fix writeback completion notifications
      writeback: queue work on stack in writeback_inodes_sb
      writeback: enforce s_umount locking in writeback_inodes_sb
      writeback: fix writeback_inodes_wb from writeback_inodes_sb
      writeback: simplify wakeup_flusher_threads
      writeback: simplify and split bdi_start_writeback
      writeback: add missing requeue_io in writeback_inodes_wb
      writeback: fix pin_sb_for_writeback
      block: fix DISCARD_BARRIER requests

Jeff Moyer (1):
      cfq: Don't allow queue merges for queues that have no process references

Jens Axboe (4):
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-linus
      cpqarray: fix wrong __init type on pci probe function
      cpqarray: fix two more wrong section type
      cfq: fix recursive call in cfq_blkiocg_update_completion_stats()

Philipp Reisner (1):
      drbd: Fixed a race between disk-attach and unexpected state changes

Stephen M. Cameron (1):
      cciss: set SCSI max cmd len to 16, as default is wrong

Tao Ma (1):
      block: Don't count_vm_events for discard bio in submit_bio.

Vivek Goyal (1):
      cfq-iosched: Fixed boot warning with BLK_CGROUP=y and CFQ_GROUP_IOSCHED=n

 block/blk-core.c               |    9 +-
 block/cfq-iosched.c            |   67 ++++++-----
 block/cfq.h                    |  115 ++++++++++++++++++
 drivers/block/cciss_scsi.c     |    1 +
 drivers/block/cpqarray.c       |    6 +-
 drivers/block/drbd/drbd_main.c |    2 -
 drivers/block/drbd/drbd_nl.c   |    6 +
 fs/fs-writeback.c              |  254 +++++++++++++++++-----------------------
 fs/ubifs/budget.c              |    2 +
 include/linux/backing-dev.h    |    4 +-
 include/linux/drbd.h           |    2 +-
 mm/page-writeback.c            |    5 +-
 12 files changed, 280 insertions(+), 193 deletions(-)
 create mode 100644 block/cfq.h

-- 
Jens Axboe

