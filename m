Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249Ab0GOSrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:47:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35072 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934126Ab0GOSrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XcGeEhY5fWpvPtsynpL08r/Q1nF15TIbRkCntUVqNFiZHlDc8k/ElLqS25WxiNuLzR
         +mJESkyRpkabTwRWjBWFVoAeB51/GF0p++w27YpiHbLMsX8h6ZP+KlpwSnFrmXDC0zd2
         0LBny8oEZvS9DRHuAEyo7AwbJqgWKjVThT3SA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] xfs: fix unsigned underflow
Date: Thu, 15 Jul 2010 22:46:45 +0400
Message-Id: <1279219605-12631-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

map_len is unsigned. Checking map_len <= 0 is buggy when it should be
below zero. So, check exact expression instead of map_len.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 fs/xfs/xfs_vnodeops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 65e0879..66d585c 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -591,9 +591,9 @@ xfs_free_eofblocks(
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)ip->i_size));
 	last_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
-	map_len = last_fsb - end_fsb;
-	if (map_len <= 0)
+	if (last_fsb <= end_fsb)
 		return 0;
+	map_len = last_fsb - end_fsb;
 
 	nimaps = 1;
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-- 
1.7.0.4

