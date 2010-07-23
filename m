Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab0GWOE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:04:26 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:57859 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760034Ab0GWOEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:04:23 -0400
From: Dave Chinner <david@fromorbit.com>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, fmayhar@google.com, johnstul@us.ibm.com
Subject: [PATCH 1/2] xfs: fix shrinker build
Date: Sat, 24 Jul 2010 00:04:01 +1000
Message-Id: <1279893842-4246-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100723111310.GI32635@dastard>
References: <20100723111310.GI32635@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Remove the stray mount list lock reference from the shrinker code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 7a5a368..05426bf 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -916,10 +916,8 @@ xfs_reclaim_inode_shrink(
 
 done:
 	nr = shrinker_do_scan(&nr_to_scan, SHRINK_BATCH);
-	if (!nr) {
-		up_read(&xfs_mount_list_lock);
+	if (!nr)
 		return 0;
-	}
 	xfs_inode_ag_iterator(mp, xfs_reclaim_inode, 0,
 				XFS_ICI_RECLAIM_TAG, 1, &nr);
 	/* if we don't exhaust the scan, don't bother coming back */
@@ -935,7 +933,6 @@ xfs_inode_shrinker_register(
 	struct xfs_mount	*mp)
 {
 	mp->m_inode_shrink.shrink = xfs_reclaim_inode_shrink;
-	mp->m_inode_shrink.seeks = DEFAULT_SEEKS;
 	register_shrinker(&mp->m_inode_shrink);
 }
 
-- 
1.7.1

