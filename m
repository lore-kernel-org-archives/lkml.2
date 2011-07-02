Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1GBVzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:55:31 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:48204 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755133Ab1GBVz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:55:28 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Jul 2011 17:55:28 EDT
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: trivial@kernel.org
Cc: ext-phil.2.carmody@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] xfs: there is no CONFIG_KDB_MODULES
Date: Sun,  3 Jul 2011 00:47:48 +0300
Message-Id: <1309643272-364-4-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309643272-364-3-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-3-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like there was a decade ago, but no longer, so this block
is dead code. The list being returned disappeared back in commit
ff57ab21995a8636cfc72efeebb09cc6034d756f.

Part of a shotgun patchset; found by greps, seds, and diffs
rather than actual understanding.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    8 --------
 fs/xfs/linux-2.6/xfs_buf.h |    4 ----
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 5e68099..5bccae0 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1889,11 +1889,3 @@ xfs_buf_terminate(void)
 	destroy_workqueue(xfslogd_workqueue);
 	kmem_zone_destroy(xfs_buf_zone);
 }
-
-#ifdef CONFIG_KDB_MODULES
-struct list_head *
-xfs_get_buftarg_list(void)
-{
-	return &xfs_buftarg_list;
-}
-#endif
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 50a7d5f..6881321 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -339,10 +339,6 @@ extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
 extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
 
-#ifdef CONFIG_KDB_MODULES
-extern struct list_head *xfs_get_buftarg_list(void);
-#endif
-
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
-- 
1.7.2.5

