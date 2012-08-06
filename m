Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2HFWJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 18:09:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61129 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab2HFWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 18:09:05 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net,
        yehuda@hq.newdream.net
Subject: [PATCH v5 00/12] Block cleanups
Date: Mon,  6 Aug 2012 15:08:29 -0700
Message-Id: <1344290921-25154-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various cleanups for the generic block layer - the patches should be pretty
self explanatory.

CHANGES SINCE LAST VERSION:

Review feedback - should all be noted in the patch descriptions. Fixed
retarded rebase conflicts. Added some acked-bys.

Kent Overstreet (12):
  block: Generalized bio pool freeing
  dm: Use bioset's front_pad for dm_rq_clone_bio_info
  block: Add bio_reset()
  pktcdvd: Switch to bio_kmalloc()
  block: Kill bi_destructor
  block: Add an explicit bio flag for bios that own their bvec
  block: Rename bio_split() -> bio_pair_split()
  block: Introduce new bio_split()
  block: Rework bio_pair_split()
  block: Add bio_clone_kmalloc()
  block: Add bio_clone_bioset()
  block: Only clone bio vecs that are in use

 Documentation/block/biodoc.txt      |    5 -
 block/blk-core.c                    |   10 +-
 drivers/block/drbd/drbd_main.c      |   13 +--
 drivers/block/drbd/drbd_req.c       |   18 +--
 drivers/block/osdblk.c              |    3 +-
 drivers/block/pktcdvd.c             |   73 +++-------
 drivers/block/rbd.c                 |    8 +-
 drivers/md/dm-crypt.c               |    9 --
 drivers/md/dm-io.c                  |   11 --
 drivers/md/dm.c                     |   60 ++-------
 drivers/md/linear.c                 |    6 +-
 drivers/md/md.c                     |   44 +------
 drivers/md/raid0.c                  |    8 +-
 drivers/md/raid10.c                 |   23 +---
 drivers/target/target_core_iblock.c |    9 --
 fs/bio-integrity.c                  |   44 ------
 fs/bio.c                            |  259 +++++++++++++++++++++++------------
 fs/exofs/ore.c                      |    5 +-
 include/linux/bio.h                 |   37 ++---
 include/linux/blk_types.h           |   12 ++-
 20 files changed, 256 insertions(+), 401 deletions(-)

-- 
1.7.7.3

