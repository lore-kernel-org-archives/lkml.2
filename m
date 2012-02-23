Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab2BWTJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:09:40 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2BWTJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:09:38 -0500
From: santoshprasadnayak@gmail.com
To: tytso@mit.edu
Cc: adilger@dilger.ca, andrew_perepechko@xyratex.com,
        nikitas_angelinas@xyratex.com, johann@whamcloud.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] ext4: MMP: Fix endianness bug.
Date: Fri, 24 Feb 2012 00:39:05 +0530
Message-Id: <4f468ef2.4105440a.56cc.ffffa1d7@mx.google.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Sparse complaint this endian bug in ext4: mmp.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 fs/ext4/mmp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 7ea4ba4..ed6548d 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -257,8 +257,8 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	 * If check_interval in MMP block is larger, use that instead of
 	 * update_interval from the superblock.
 	 */
-	if (mmp->mmp_check_interval > mmp_check_interval)
-		mmp_check_interval = mmp->mmp_check_interval;
+	if (le16_to_cpu(mmp->mmp_check_interval) > mmp_check_interval)
+		mmp_check_interval = le16_to_cpu(mmp->mmp_check_interval);
 
 	seq = le32_to_cpu(mmp->mmp_seq);
 	if (seq == EXT4_MMP_SEQ_CLEAN)
-- 
1.7.4.4

