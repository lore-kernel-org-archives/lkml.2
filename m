Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab0D3RbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:31:20 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39608 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758747Ab0D3Ra1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:30:27 -0400
Date: Thu, 29 Apr 2010 20:37:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, bharrosh@panasas.com,
       randy.dunlap@oracle.com
Subject: [GIT PULL] Two small fixups
Message-ID: <20100429183750.GX27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The super.c change broke when !CONFIG_BLOCK. Not too big of a deal, I
see that !CONFIG_BLOCK is already broken in -git for other reasons. But
lets not add more.

And since I setup this pull, I included the exofs fix from Boaz since
that needs to go in before the next -rc anyway. So please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Boaz Harrosh (1):
      exofs: Fix "add bdi backing to mount session" fall out

Jens Axboe (1):
      fs: fs/super.c needs to include backing-dev.h for !CONFIG_BLOCK

 fs/exofs/exofs.h |    2 +-
 fs/super.c       |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index 5437327..22721b2 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -85,6 +85,7 @@ struct exofs_sb_info {
 	u32		s_next_generation;	/* next gen # to use          */
 	atomic_t	s_curr_pending;		/* number of pending commands */
 	uint8_t		s_cred[OSD_CAP_LEN];	/* credential for the fscb    */
+	struct 		backing_dev_info bdi;	/* register our bdi with VFS  */
 
 	struct pnfs_osd_data_map data_map;	/* Default raid to use
 						 * FIXME: Needed ?
@@ -93,7 +94,6 @@ struct exofs_sb_info {
 	struct exofs_layout	layout;		/* Default files layout,
 						 * contains the variable osd_dev
 						 * array. Keep last */
-	struct backing_dev_info bdi;
 	struct osd_dev	*_min_one_dev[1];	/* Place holder for one dev   */
 };
 
diff --git a/fs/super.c b/fs/super.c
index dc72491..1527e6a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -37,6 +37,7 @@
 #include <linux/kobject.h>
 #include <linux/mutex.h>
 #include <linux/file.h>
+#include <linux/backing-dev.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 

-- 
Jens Axboe

