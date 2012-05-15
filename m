Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab2EOHwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:52:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:8288 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851Ab2EOHws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:52:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140747559"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] md: remove redudent code
Date: Tue, 15 May 2012 16:00:25 +0800
Message-Id: <1337068825-11995-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code does nothing but repating assigning sb->sb_csum with original
value.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/md.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0bd44e3..f2d799a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1439,15 +1439,12 @@ super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 
 static __le32 calc_sb_1_csum(struct mdp_superblock_1 * sb)
 {
-	__le32 disk_csum;
 	u32 csum;
 	unsigned long long newcsum;
 	int size = 256 + le32_to_cpu(sb->max_dev)*2;
 	__le32 *isuper = (__le32*)sb;
 	int i;
 
-	disk_csum = sb->sb_csum;
-	sb->sb_csum = 0;
 	newcsum = 0;
 	for (i=0; size>=4; size -= 4 )
 		newcsum += le32_to_cpu(*isuper++);
@@ -1456,7 +1453,6 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_1 * sb)
 		newcsum += le16_to_cpu(*(__le16*) isuper);
 
 	csum = (newcsum & 0xffffffff) + (newcsum >> 32);
-	sb->sb_csum = disk_csum;
 	return cpu_to_le32(csum);
 }
 
-- 
1.7.7.6

