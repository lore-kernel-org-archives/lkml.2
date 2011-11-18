Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab1KRKLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:11:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60611 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab1KRKLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:11:32 -0500
Message-ID: <4EC62F51.9000308@kernel.dk>
Date: Fri, 18 Nov 2011 11:11:29 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block IO bits for 3.2-rc2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the collection of block IO related fixes for the next -rc
release.

- Improve coverage of the blk_rq_map_user_iov() segment length checking,
  we should continue checking even after seeing unaligned entries.

- Fix for two potential memory leaks, in paride and loop.

- Two fixes for cciss. Disable ASPM always, similarly to what Windows
  does. And auto-engage the SCSI support, if it's been selected.

- Fix for missing bdi timer deletion in bdi_destroy().

- Revert of the nasty write-once disk alias hack that went into 3.2-rc1.
  Lets kill it now before we are stuck with this interface forever.

- Few other minor fixups and cleanups.

Please pull!


  git://git.kernel.dk/linux-block.git for-linus


Ben Hutchings (1):
      block: Always check length of all iov entries in blk_rq_map_user_iov()

Dan Carpenter (2):
      bio: change some signed vars to unsigned
      paride: fix potential information leak in pg_read()

Dmitry Monakhov (2):
      loop: prevent information leak after failed read
      loop: cleanup set_status interface

Matthew Garrett (1):
      The Windows driver .inf disables ASPM on all cciss devices. Do the same.

Rabin Vincent (1):
      backing-dev: ensure wakeup_timer is deleted

Shaohua Li (2):
      block: avoid unnecessary plug list flush
      block: add missed trace_block_plug

Stephen M. Cameron (1):
      cciss: auto engage SCSI mid layer at driver load time

Stephen Rothwell (1):
      include/linux/bio.h: use a static inline function for bio_integrity_clone()

Tejun Heo (1):
      block: Revert "[SCSI] genhd: add a new attribute "alias" in gendisk"

 Documentation/ABI/testing/sysfs-block |   13 ------
 Documentation/blockdev/cciss.txt      |   14 +++----
 block/blk-core.c                      |   18 +++++---
 block/blk-map.c                       |    7 ++-
 block/genhd.c                         |   71 ---------------------------------
 drivers/block/cciss.c                 |    6 +++
 drivers/block/cciss_scsi.c            |    1 +
 drivers/block/loop.c                  |   47 ++++++++++++++-------
 drivers/block/paride/pg.c             |    1 +
 fs/bio.c                              |    7 ++-
 include/linux/bio.h                   |   10 +++-
 include/linux/genhd.h                 |    4 --
 mm/backing-dev.c                      |    8 ++++
 13 files changed, 79 insertions(+), 128 deletions(-)

-- 
Jens Axboe

