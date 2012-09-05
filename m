Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab2IEU1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:27:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43085 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2IEU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:27:43 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: tj@kernel.org, vgoyal@redhat.com, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v8 0/8] Block cleanups
Date: Wed,  5 Sep 2012 13:27:21 -0700
Message-Id: <1346876849-15820-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v7:

Split off the deadlock fix, this is now just cleanups

Noticed a minor issue with bio integrity freeing, and decided the best way to
fix it was to just make it use bi_pool directly which simplifies the code
anyways.

Tested the integrity stuff with the scsi debug module.

Cleaned up bio_reset()/bio_free() a bit, introduce a __bio_free() helper used
by both and made bio_free() static.

Kent Overstreet (8):
  block: Generalized bio pool freeing
  block: Ues bi_pool for bio_integrity_alloc()
  dm: Use bioset's front_pad for dm_rq_clone_bio_info
  block: Add bio_reset()
  pktcdvd: Switch to bio_kmalloc()
  block: Kill bi_destructor
  block: Consolidate bio_alloc_bioset(), bio_kmalloc()
  block: Add bio_clone_bioset(), bio_clone_kmalloc()

 Documentation/block/biodoc.txt      |   5 -
 block/blk-core.c                    |  10 +-
 drivers/block/drbd/drbd_main.c      |  13 +--
 drivers/block/osdblk.c              |   3 +-
 drivers/block/pktcdvd.c             |  52 ++--------
 drivers/md/dm-crypt.c               |  16 +--
 drivers/md/dm-io.c                  |  11 --
 drivers/md/dm.c                     |  72 ++++---------
 drivers/md/md.c                     |  44 +-------
 drivers/target/target_core_iblock.c |   9 --
 fs/bio-integrity.c                  |  44 +++-----
 fs/bio.c                            | 196 +++++++++++++++---------------------
 fs/exofs/ore.c                      |   5 +-
 include/linux/bio.h                 |  44 +++++---
 include/linux/blk_types.h           |  27 +++--
 15 files changed, 183 insertions(+), 368 deletions(-)

-- 
1.7.12

