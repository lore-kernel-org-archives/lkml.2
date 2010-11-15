Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab0KORPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:15:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758024Ab0KORPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:15:06 -0500
From: Josef Bacik <josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com
Subject: [PATCH 6/6] Gfs2: fail if we try to use hole punch
Date: Mon, 15 Nov 2010 12:05:23 -0500
Message-Id: <1289840723-3056-7-git-send-email-josef@redhat.com>
In-Reply-To: <1289840723-3056-1-git-send-email-josef@redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gfs2 doesn't have the ability to punch holes yet, so make sure we return
EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
be added later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/gfs2/ops_inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 12cbea7..65cb5f6 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1439,6 +1439,10 @@ static long gfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
 	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
 
+	/* We only support the FALLOC_FL_KEEP_SIZE mode */
+	if (mode && (mode != FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
 	offset = (offset >> sdp->sd_sb.sb_bsize_shift) <<
 		 sdp->sd_sb.sb_bsize_shift;
 
-- 
1.6.6.1

