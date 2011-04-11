Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1DKClf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 22:41:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47278 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1DKCle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 22:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ONI1igVMo/oFWKRkXXnB3LkQvLyeMj2mDOCDk0pOXDmmbVFcoYgfegcSLTBCel1KGv
         ghRHmoVW3b+VNppwEJbC/mPYnfmks1z5ATWS9oAkCIC6OPIxtdVOzMxkbxg8MbotKFYe
         Fhgqu6cHPFtp2QdX1lKeM3vAdwUNse4lPWRgo=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
To: swhiteho@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>
Subject: [PATCH 1/2] gfs:remove a warning in gfs2_lookup_by_inum()
Date: Mon, 11 Apr 2011 10:42:50 +0800
Message-Id: <1302489770-31552-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/home/pwp/mysvn/linux/linux-2.6/fs/gfs2/inode.c: In function
‘gfs2_lookup_by_inum’: /home/pwp/mysvn/linux/linux-2.6/fs/gfs2/inode.c:188:16:
warning: ‘inode’ may be used uninitialized in this function

Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
---
 fs/gfs2/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 97d54a2..5b937c6 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -185,7 +185,7 @@ struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
 {
 	struct super_block *sb = sdp->sd_vfs;
 	struct gfs2_holder i_gh;
-	struct inode *inode;
+	struct inode *inode = NULL;
 	int error;
 
 	error = gfs2_glock_nq_num(sdp, no_addr, &gfs2_inode_glops,
-- 
1.7.4

