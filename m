Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0JVH51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:57:27 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44113 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab0JVH50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:57:26 -0400
Message-ID: <4CC143F5.3060202@fusionio.com>
Date: Fri, 22 Oct 2010 09:57:41 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] core block bits for 2.6.37-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This first pull request is the core bits, meaning general
block layer changes or core support. Should be clean this time,
only 'weird bit' is the seemingly duplicate entry from Malahal.
This is caused by the first patch being buggy (and later
reverted), second patch used the same single line description.

Nothing really exciting in here. A good collection of fixes, some of
which are marked for stable as well.

The biggest addition this time around is the block IO throttling support
from Vivek.

Please pull.


  git://git.kernel.dk/linux-2.6-block.git for-2.6.37/core

Christof Schmitt (1):
      zfcp: Report scatter gather limit for DIX protection information

Corrado Zoccolo (1):
      cfq: improve fsync performance for small files

Geert Uytterhoeven (1):
      block: Turn bvec_k{un,}map_irq() into static inline functions

Jens Axboe (3):
      core: match_dev_by_uuid() should not be marked __init
      do_mounts: only enable PARTUUID for CONFIG_BLOCK
      block: revert bad fix for memory hotplug causing bounces

Malahal Naineni (2):
      block: set the bounce_pfn to the actual DMA limit rather than to max memory
      block: set the bounce_pfn to the actual DMA limit rather than to max memory

Mark Lord (2):
      block: Prevent hang_check firing during long I/O
      Fix compile error in blk-exec.c for !CONFIG_DETECT_HUNG_TASK

Martin K. Petersen (5):
      Consolidate min_not_zero
      block/scsi: Provide a limit on the number of integrity segments
      block: Ensure physical block size is unsigned int
      block: Fix double free in blk_integrity_unregister
      block: Make the integrity mapped property a bio flag

Namhyung Kim (2):
      block: fix an address space warning in blk-map.c
      sg: fix a warning in blk_rq_aligned() call

San Mehat (1):
      block: block_dump: Add number of sectors to debug output

Signed-off-by: Jan Kara (1):
      block: Fix race during disk initialization

Vivek Goyal (16):
      blk-cgroup: Kill the header printed at the start of blkio.weight_device file
      blk-cgroup: Prepare the base for supporting more than one IO control policies
      blk-cgroup: Introduce cgroup changes for throttling policy
      blkio: Core implementation of throttle policy
      blk-cgroup: cgroup changes for IOPS limit support
      blkio: Implementation of IOPS limit logic
      blkio: Documentation Update
      blkio: Do not export throttle files if CONFIG_BLK_DEV_THROTTLING=n
      blkio: deletion of a cgroup was causes oops
      blkio: Add root group to td->tg_list
      blkio: Recalculate the throttled bio dispatch time upon throttle limit change
      blkio-throttle: Fix link failure failure on i386
      blkio-throttle: There is no need to convert jiffies to milli seconds
      blkio-throttle: limit max iops value to UINT_MAX
      blkio-throttle: Fix possible multiplication overflow in iops calculations
      cfq-iosched: Fix a gcc 4.5 warning and put some comments

Will Drewry (3):
      block, partition: add partition_meta_info to hd_struct
      genhd, efi: add efi partition metadata to hd_structs
      init: add support for root devices specified by partition UUID

Yasuaki Ishimatsu (1):
      block: fix accounting bug on cross partition merges

 Documentation/cgroups/blkio-controller.txt |  106 +++-
 block/Kconfig                              |   12 +
 block/Makefile                             |    1 +
 block/blk-cgroup.c                         |  804 ++++++++++++++++----
 block/blk-cgroup.h                         |   87 ++-
 block/blk-core.c                           |   53 ++-
 block/blk-exec.c                           |    9 +-
 block/blk-integrity.c                      |   94 ++-
 block/blk-map.c                            |    5 +-
 block/blk-merge.c                          |   25 +-
 block/blk-settings.c                       |   12 +-
 block/blk-sysfs.c                          |   11 +
 block/blk-throttle.c                       | 1123 ++++++++++++++++++++++++++++
 block/blk.h                                |   12 -
 block/cfq-iosched.c                        |   39 +-
 block/cfq.h                                |    2 +-
 block/genhd.c                              |   30 +-
 block/ioctl.c                              |    2 +-
 drivers/block/drbd/drbd_receiver.c         |    1 -
 drivers/md/dm-snap.c                       |    2 -
 drivers/md/dm-table.c                      |    5 -
 drivers/s390/scsi/zfcp_scsi.c              |    1 +
 drivers/scsi/hosts.c                       |    1 +
 drivers/scsi/scsi_lib.c                    |   26 +-
 drivers/scsi/scsi_sysfs.c                  |    2 +
 drivers/scsi/sd_dif.c                      |   11 +-
 drivers/scsi/sg.c                          |    2 +-
 fs/jbd/commit.c                            |    2 +-
 fs/jbd2/commit.c                           |    2 +-
 fs/partitions/check.c                      |   35 +-
 fs/partitions/check.h                      |    3 +
 fs/partitions/efi.c                        |   25 +
 include/linux/bio.h                        |   15 +-
 include/linux/blk_types.h                  |    6 +-
 include/linux/blkdev.h                     |   66 ++-
 include/linux/elevator.h                   |    2 +
 include/linux/genhd.h                      |   54 ++-
 include/linux/kernel.h                     |   10 +
 include/linux/sched.h                      |    3 +
 include/scsi/scsi.h                        |    6 +
 include/scsi/scsi_host.h                   |    7 +
 init/Kconfig                               |    9 +-
 init/do_mounts.c                           |   70 ++
 43 files changed, 2494 insertions(+), 299 deletions(-)
 create mode 100644 block/blk-throttle.c

-- 
Jens Axboe

