Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2KLV2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:28:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45199 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2KLV2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:28:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Nikola Pajkovsky <npajkovs@redhat.com>
Cc: Jan Kara <jack@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [ 3.5.yuz extended stable] Patch "udf: fix retun value on error path in udf_load_logicalvol" has been added to staging queue
Date: Mon, 12 Nov 2012 19:28:31 -0200
Message-Id: <1352755711-15762-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    udf: fix retun value on error path in udf_load_logicalvol

to the linux-3.5.y-queue branch of the 3.5.yuz extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.5.y-queue

If you, or anyone else, feels it should not be added to the 3.5
Linux kernel, or for any feedback related to it, please reply to
this email. For more information on extended stable, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Herton

------

>From 4510a4ac40255b59496331c88971e9a8b63c704d Mon Sep 17 00:00:00 2001
From: Nikola Pajkovsky <npajkovs@redhat.com>
Date: Wed, 15 Aug 2012 00:38:08 +0200
Subject: [PATCH] udf: fix retun value on error path in udf_load_logicalvol

commit 68766a2edcd5cd744262a70a2f67a320ac944760 upstream.

In case we detect a problem and bail out, we fail to set "ret" to a
nonzero value, and udf_load_logicalvol will mistakenly report success.

Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/udf/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index e660ffd..4988a8a 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1287,6 +1287,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 		udf_err(sb, "error loading logical volume descriptor: "
 			"Partition table too long (%u > %lu)\n", table_len,
 			sb->s_blocksize - sizeof(*lvd));
+		ret = 1;
 		goto out_bh;
 	}

@@ -1331,8 +1332,10 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 						UDF_ID_SPARABLE,
 						strlen(UDF_ID_SPARABLE))) {
 				if (udf_load_sparable_map(sb, map,
-				    (struct sparablePartitionMap *)gpm) < 0)
+				    (struct sparablePartitionMap *)gpm) < 0) {
+					ret = 1;
 					goto out_bh;
+				}
 			} else if (!strncmp(upm2->partIdent.ident,
 						UDF_ID_METADATA,
 						strlen(UDF_ID_METADATA))) {
--
1.7.9.5

