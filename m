Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab2HXSSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:18:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59530 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2HXSSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:18:09 -0400
Message-ID: <5037C55A.4030608@kernel.dk>
Date: Fri, 24 Aug 2012 20:18:02 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 3.6-rc3
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please find below a set of block related fixes for the 3.6 rc series. It
contains:

- Improvements to the buffered and direct write IO plugging from
  Fengguang.

- Abstract out the mapping of a bio in a request, and use that to
  provide a blk_bio_map_sg() helper. Useful for mapping just a bio
  instead of a full request.

- Regression fix from Hugh, fixing up a patch that went into the
  previous release cycle (and marked stable, too) attempting to
  prevent a loop in __getblk_slow().

- Updates to discard requests, fixing up the sizing and how we align
  them. Also a change to disallow merging of discard requests, since
  that doesn't really work properly yet.

- A few drbd fixes.

- Documentation updates.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Alexey Khoroshilov (1):
      bio: Fix potential memory leak in bio_find_or_create_slab()

Asias He (2):
      block: Introduce __blk_segment_map_sg() helper
      block: Add blk_bio_map_sg() helper

Fengguang Wu (2):
      block: remove plugging at buffered write time
      block: move down direct IO plugging

Hugh Dickins (1):
      block: replace __getblk_slow misfix by grow_dev_page fix

Jens Axboe (1):
      Merge branch 'for-jens' of git://git.drbd.org/linux-drbd into for-linus

Jianpeng Ma (2):
      fs/block-dev.c:fix performance regression in O_DIRECT writes to md block devices
      block: Don't use static to define "void *p" in show_partition_start()

Lars Ellenberg (1):
      drbd: fix drbd wire compatibility for empty flushes

Namjae Jeon (3):
      Documentation: update missing index files in block/00-INDEX
      Documentation: update tunable options in block/cfq-iosched.txt
      Documentation: update tunable options in block/cfq-iosched.txt

Paolo Bonzini (2):
      block: reorganize rounding of max_discard_sectors
      block: split discard into aligned requests

Philipp Reisner (2):
      drbd: Finish requests that completed while IO was frozen
      drbd: Write all pages of the bitmap after an online resize

Shaohua Li (1):
      block: disable discard request merge temporarily

 Documentation/block/00-INDEX        |  10 ++-
 Documentation/block/cfq-iosched.txt |  77 ++++++++++++++++++++++++
 Documentation/block/queue-sysfs.txt |  64 ++++++++++++++++++++
 block/blk-lib.c                     |  41 +++++++++----
 block/blk-merge.c                   | 117 +++++++++++++++++++++++++-----------
 block/genhd.c                       |   2 +-
 drivers/block/drbd/drbd_bitmap.c    |  15 ++++-
 drivers/block/drbd/drbd_int.h       |   1 +
 drivers/block/drbd/drbd_main.c      |  28 ++++-----
 drivers/block/drbd/drbd_nl.c        |   4 +-
 drivers/block/drbd/drbd_req.c       |  36 +++++++++--
 fs/bio.c                            |  11 ++--
 fs/block_dev.c                      |   3 +
 fs/buffer.c                         |  66 +++++++++-----------
 fs/direct-io.c                      |   5 ++
 include/linux/blkdev.h              |  14 ++++-
 mm/filemap.c                        |   7 ---
 17 files changed, 378 insertions(+), 123 deletions(-)

-- 
Jens Axboe

