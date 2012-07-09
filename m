Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2GIOmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:42:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38281 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482Ab2GIOiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:21 -0400
Message-Id: <20120709143120.325974848@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>
Subject: [ 25/48] udf: Use ret instead of abusing i in udf_load_logicalvol()
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit cb14d340ef1737c24125dd663eff77734a482d47 upstream.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/super.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index ac8a348..9da6f4e 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1233,11 +1233,9 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	BUG_ON(ident != TAG_IDENT_LVD);
 	lvd = (struct logicalVolDesc *)bh->b_data;
 
-	i = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
-	if (i != 0) {
-		ret = i;
+	ret = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
+	if (ret)
 		goto out_bh;
-	}
 
 	for (i = 0, offset = 0;
 	     i < sbi->s_partitions && offset < le32_to_cpu(lvd->mapTableLength);


