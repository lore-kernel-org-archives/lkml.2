Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab2IFVdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:33:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64763 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab2IFVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:33:10 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v9 0/9] Block cleanups
Date: Thu,  6 Sep 2012 14:32:47 -0700
Message-Id: <1346967179-28596-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v8: Just a few minor comment/patch descriptions changes

Kent Overstreet (9):
  block: Generalized bio pool freeing
  block: Ues bi_pool for bio_integrity_alloc()
  dm: Use bioset's front_pad for dm_rq_clone_bio_info
  block: Add bio_reset()
  pktcdvd: Switch to bio_kmalloc()
  block: Add bio_reset()
  block: Kill bi_destructor
  block: Consolidate bio_alloc_bioset(), bio_kmalloc()
  block: Add bio_clone_bioset(), bio_clone_kmalloc()

 Documentation/block/biodoc.txt      |   5 -
 block/blk-core.c                    |  10 +-
 drivers/block/drbd/drbd_main.c      |  13 +--
 drivers/block/osdblk.c              |   3 +-
 drivers/block/pktcdvd.c             |  52 ++-------
 drivers/md/dm-crypt.c               |  16 +--
 drivers/md/dm-io.c                  |  11 --
 drivers/md/dm.c                     |  72 ++++--------
 drivers/md/md.c                     |  44 +-------
 drivers/target/target_core_iblock.c |   9 --
 fs/bio-integrity.c                  |  44 +++-----
 fs/bio.c                            | 220 +++++++++++++++++-------------------
 fs/exofs/ore.c                      |   5 +-
 include/linux/bio.h                 |  44 +++++---
 include/linux/blk_types.h           |  27 +++--
 15 files changed, 207 insertions(+), 368 deletions(-)

-- 
1.7.12

