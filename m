Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab0FCX4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:56:24 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:40250 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756418Ab0FCX4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:56:09 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [PATCH 5/6] xfs: remove nr_to_write writeback windup.
Date: Fri,  4 Jun 2010 09:55:27 +1000
Message-Id: <1275609328-12514-6-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275609328-12514-1-git-send-email-david@fromorbit.com>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
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
index 089eaca..4c89db3 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1366,14 +1366,6 @@ xfs_vm_writepage(
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

