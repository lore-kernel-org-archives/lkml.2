Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0GGLSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 07:18:46 -0400
Received: from smtp.nokia.com ([192.100.105.134]:40675 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab0GGLSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 07:18:25 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, Jens Axboe <axboe@kernel.dk>,
       Kyungmin Park <kmpark@infradead.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 07 Jul 2010 14:17:16 +0300
Message-Id: <20100707111716.24979.68940.sendpatchset@ahunter-work.research.nokia.com>
Subject: [PATCH V4 0/5] Add MMC erase and secure erase V4
X-OriginalArrivalTime: 07 Jul 2010 11:17:18.0127 (UTC) FILETIME=[F5E353F0:01CB1DC5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Add ability to do MMC erase and secure erase operations from userspace,
using the BLKDISCARD ioctl and a newly created BLKSECDISCARD ioctl.

This is version 4 of these patches.

Changes from V3

- rebased on mmotm
- added SD/MMC device attribute documentation to 'mmc: Add erase,
  secure erase, trim and secure trim operations' patch

Changes from V2

- move the addition of BLKSECDISCARD to a separate patch and implement it
using I/O requests
- move the MMC support of secure discard to a separate patch and support
the secure discard I/O request

Changes from V1

- use discard I/O requests instead of implementing BLKDISCARD in mmc_block
- do not validate erase size for MMC erases, instead round to erase size
- rename MMC max_erase to pref_erase and expose it through sysfs as
preferred_erase_size


Adrian Hunter (5):
      mmc: Add erase, secure erase, trim and secure trim operations
      mmc_block: Add discard support
      omap_hsmmc: Add erase capability
      block: Add secure discard
      mmc_block: Add support for secure discard

 Documentation/00-INDEX              |    2 +
 Documentation/mmc/00-INDEX          |    4 +
 Documentation/mmc/mmc-dev-attrs.txt |   56 ++++++
 block/blk-core.c                    |    5 +-
 block/blk-lib.c                     |    6 +
 block/compat_ioctl.c                |    1 +
 block/elevator.c                    |    6 +
 block/ioctl.c                       |   15 +-
 drivers/mmc/card/block.c            |   82 ++++++++-
 drivers/mmc/card/queue.c            |   19 ++-
 drivers/mmc/core/core.c             |  346 +++++++++++++++++++++++++++++++++++
 drivers/mmc/core/core.h             |    2 +
 drivers/mmc/core/mmc.c              |   47 +++++-
 drivers/mmc/core/sd.c               |   82 ++++++++
 drivers/mmc/core/sd_ops.c           |   48 +++++
 drivers/mmc/core/sd_ops.h           |    1 +
 drivers/mmc/host/omap_hsmmc.c       |   13 +-
 include/linux/bio.h                 |    2 +
 include/linux/blkdev.h              |    7 +-
 include/linux/fs.h                  |    2 +
 include/linux/mmc/card.h            |   19 ++
 include/linux/mmc/core.h            |   19 ++
 include/linux/mmc/host.h            |    1 +
 include/linux/mmc/mmc.h             |   26 ++-
 include/linux/mmc/sd.h              |    5 +
 kernel/trace/blktrace.c             |    8 +
 26 files changed, 803 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/mmc/00-INDEX
 create mode 100644 Documentation/mmc/mmc-dev-attrs.txt


Regards
Adrian

