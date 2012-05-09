Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414Ab2EIG2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:28:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38767 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755679Ab2EIFwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:55 -0400
Message-Id: <20120509055037.768535460@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 057/167] [PATCH 4/4] ocfs2: ->e_leaf_clusters endianness breakage
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 72094e43e3af5020510f920321d71f1798fa896d upstream.

le16, not le32...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/suballoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index ba5d97e..f169da4 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -600,7 +600,7 @@ static void ocfs2_bg_alloc_cleanup(handle_t *handle,
 		ret = ocfs2_free_clusters(handle, cluster_ac->ac_inode,
 					  cluster_ac->ac_bh,
 					  le64_to_cpu(rec->e_blkno),
-					  le32_to_cpu(rec->e_leaf_clusters));
+					  le16_to_cpu(rec->e_leaf_clusters));
 		if (ret)
 			mlog_errno(ret);
 		/* Try all the clusters to free */
@@ -1628,7 +1628,7 @@ static int ocfs2_bg_discontig_fix_by_rec(struct ocfs2_suballoc_result *res,
 {
 	unsigned int bpc = le16_to_cpu(cl->cl_bpc);
 	unsigned int bitoff = le32_to_cpu(rec->e_cpos) * bpc;
-	unsigned int bitcount = le32_to_cpu(rec->e_leaf_clusters) * bpc;
+	unsigned int bitcount = le16_to_cpu(rec->e_leaf_clusters) * bpc;
 
 	if (res->sr_bit_offset < bitoff)
 		return 0;
-- 
1.7.10



