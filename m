Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab0IJLxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:53:08 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47395 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab0IJLxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:53:05 -0400
Message-ID: <4C8A1C20.1070504@fusionio.com>
Date: Fri, 10 Sep 2010 13:53:04 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.36-rc3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

All of these (except a single fix) have been brewing while
you were away and have been in -next for over a week as well.
All are fixes for bugs, the cfq patches are the odd ones out.
But they have been well tested and should have been included
in the first merge in the merge window, so I don't have an
issue pushing them now.

Please pull.


  git://git.kernel.dk/linux-2.6-block.git for-linus

Andrew Morton (1):
      fs/bio-integrity.c: return -ENOMEM on kmalloc failure

Artem Bityutskiy (1):
      writeback: do not lose wakeup events when forking bdi threads

Brian King (1):
      block: Range check cpu in blk_cpu_to_group

Ciju Rajan K (1):
      blkio: Fix return code for mkdir calls

Dan Carpenter (1):
      cciss: handle allocation failure

David Rientjes (1):
      bio-integrity.c: remove dependency on __GFP_NOFAIL

J. Bruce Fields (1):
      writeback: Fix lost wake-up shutting down writeback thread

Jeffrey Carlyle (1):
      scatterlist: prevent invalid free when alloc fails

Jens Axboe (2):
      block: add function call to switch the IO scheduler from a driver
      block: switch s390 tape_block and mg_disk to elevator_change()

Jiri Slaby (1):
      BLOCK: fix bio.bi_rw handling

Stephen M. Cameron (2):
      cciss: disable doorbell reset on reset_devices
      cciss: fix reporting of max queue depth since init

Vivek Goyal (5):
      cfq-iosched: Do not idle if slice_idle=0
      cfq-iosched: Do group share accounting in IOPS when slice_idle=0
      cfq-iosched: Implement tunable group_idle
      cfq-iosched: blktrace print per slice sector stats
      cfq-iosched: Documentation help for new tunables

Xiaotian Feng (1):
      block: put dev->kobj in blk_register_queue fail path

 Documentation/block/cfq-iosched.txt        |   45 ++++++++++++
 Documentation/cgroups/blkio-controller.txt |   28 ++++++++
 block/blk-cgroup.c                         |    2 +-
 block/blk-core.c                           |    6 +-
 block/blk-sysfs.c                          |    1 +
 block/blk.h                                |    8 ++-
 block/cfq-iosched.c                        |  103 ++++++++++++++++++++++++----
 block/elevator.c                           |   44 ++++++++----
 drivers/block/cciss.c                      |   11 +++
 drivers/block/loop.c                       |    2 +-
 drivers/block/mg_disk.c                    |    3 +-
 drivers/s390/char/tape_block.c             |    3 +-
 fs/bio-integrity.c                         |    4 +-
 fs/fs-writeback.c                          |    2 +-
 include/linux/elevator.h                   |    1 +
 lib/scatterlist.c                          |   14 +++-
 mm/backing-dev.c                           |    7 ++-
 17 files changed, 238 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/block/cfq-iosched.txt

-- 
Jens Axboe

