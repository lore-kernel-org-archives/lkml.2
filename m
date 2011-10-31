Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513Ab1JaP03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:26:29 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62169 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab1JaP01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:26:27 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH] udf : fix metadata/mirror address print
Date: Tue,  1 Nov 2011 00:25:40 +0900
Message-Id: <1320074740-1923-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found some bug in Skip-mirror-metadata-FE-loading-when-metadata-FE-is-ok patch
So I try to fix metadata/mirror address print.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
---
 fs/udf/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index b4921ab..dfe043a 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -860,7 +860,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 
 	/* metadata address */
 	udf_debug("Metadata file location: block = %d part = %d\n",
-		  addr.logicalBlockNum, addr.partitionReferenceNum);
+		  mdata->s_meta_file_loc, map->s_partition_num);
 
 	mdata->s_metadata_fe = udf_find_metadata_inode_efe(sb,
 		mdata->s_meta_file_loc, map->s_partition_num);
@@ -868,7 +868,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 	if (mdata->s_metadata_fe == NULL) {
 		/* mirror file entry */
 		udf_debug("Mirror metadata file location: block = %d part = %d\n",
-			  addr.logicalBlockNum, addr.partitionReferenceNum);
+			  mdata->s_mirror_file_loc, map->s_partition_num);
 
 		mdata->s_mirror_fe = udf_find_metadata_inode_efe(sb,
 			mdata->s_mirror_file_loc, map->s_partition_num);
-- 
1.7.4.4

