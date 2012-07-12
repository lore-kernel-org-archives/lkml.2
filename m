Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab2GLXDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:03:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162530Ab2GLXDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 18/68] udf: Use ret instead of abusing i in udf_load_logicalvol()
Date: Thu, 12 Jul 2012 16:01:52 -0700
Message-Id: <20120712175037.043938341@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit cb14d340ef1737c24125dd663eff77734a482d47 upstream.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/super.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1262,11 +1262,9 @@ static int udf_load_logicalvol(struct su
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


