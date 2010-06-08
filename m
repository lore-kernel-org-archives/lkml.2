Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab0FHAjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:39:21 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:54405 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752592Ab0FHAjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:39:13 -0400
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [PATCH 5/6] xfs: remove nr_to_write writeback windup.
Date: Tue,  8 Jun 2010 10:38:06 +1000
Message-Id: <1275957487-23633-6-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275957487-23633-1-git-send-email-david@fromorbit.com>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the background flush code has been fixed, we shouldn't need to
silently multiply the wbc->nr_to_write to get good writeback. Remove
that code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_aops.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index a0fa3bf..34640d6 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1381,14 +1381,6 @@ xfs_vm_writepage(
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
 
-
-	/*
-	 *  VM calculation for nr_to_write seems off.  Bump it way
-	 *  up, this gets simple streaming writes zippy again.
-	 *  To be reviewed again after Jens' writeback changes.
-	 */
-	wbc->nr_to_write *= 4;
-
 	/*
 	 * Convert delayed allocate, unwritten or unmapped space
 	 * to real space and flush out to disk.
-- 
1.7.1

