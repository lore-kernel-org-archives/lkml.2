Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0KRB5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:57:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0KRB4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:56:19 -0500
From: Josef Bacik <josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, joel.becker@oracle.com, jack@suse.cz
Subject: [PATCH 6/6] Gfs2: fail if we try to use hole punch
Date: Wed, 17 Nov 2010 20:46:20 -0500
Message-Id: <1290044780-2902-7-git-send-email-josef@redhat.com>
In-Reply-To: <1290044780-2902-1-git-send-email-josef@redhat.com>
References: <1290044780-2902-1-git-send-email-josef@redhat.com>
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

