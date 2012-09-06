Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2IFWfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:35:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2IFWfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:35:13 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v10 0/8] Block cleanups
Date: Thu,  6 Sep 2012 15:34:54 -0700
Message-Id: <1346970902-10931-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Screwed up the bio_reset() patch in the last patch series when I went to edit
the description, fixed that here.

Only other change is the dm patch - made the front_pad conditional on
DM_TYPE_BIO_BASED.

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
 drivers/block/pktcdvd.c             |  52 ++-------
 drivers/md/dm-crypt.c               |  16 +--
 drivers/md/dm-io.c                  |  11 --
 drivers/md/dm.c                     |  74 ++++---------
 drivers/md/md.c                     |  44 +-------
 drivers/target/target_core_iblock.c |   9 --
 fs/bio-integrity.c                  |  44 +++-----
 fs/bio.c                            | 206 ++++++++++++++++--------------------
 fs/exofs/ore.c                      |   5 +-
 include/linux/bio.h                 |  44 +++++---
 include/linux/blk_types.h           |  27 +++--
 15 files changed, 195 insertions(+), 368 deletions(-)

-- 
1.7.12

