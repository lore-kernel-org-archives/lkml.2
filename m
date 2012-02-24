Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab2BXHJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:09:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64481 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2BXHJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:09:30 -0500
From: santosh nayak <santoshprasadnayak@gmail.com>
To: bpm@sgi.com
Cc: elder@kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] xfs: Use memset to initialize structure member.
Date: Fri, 24 Feb 2012 12:38:42 +0530
Message-Id: <1330067322-17011-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Sparse is giving following warning:
fs/xfs/xfs_bmap.c:4826:41: warning: Using plain integer as NULL pointer.

To avoid this warning, use memset to initialize the structure member.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 fs/xfs/xfs_bmap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 188ef2f..030e93f 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4823,7 +4823,7 @@ xfs_bmapi_write(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
-	struct xfs_bmalloca	bma = { 0 };	/* args for xfs_bmap_alloc */
+	struct xfs_bmalloca	bma;		/* args for xfs_bmap_alloc */
 	xfs_fileoff_t		end;		/* end of mapped file region */
 	int			eof;		/* after the end of extents */
 	int			error;		/* error return */
@@ -4852,6 +4852,8 @@ xfs_bmapi_write(
 	ASSERT(!(flags & XFS_BMAPI_IGSTATE));
 	ASSERT(tp != NULL);
 	ASSERT(len > 0);
+
+	memset(&bma, 0, sizeof(bma));
 
 	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
 		XFS_ATTR_FORK : XFS_DATA_FORK;
-- 
1.7.4.4

