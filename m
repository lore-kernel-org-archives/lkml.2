Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2EIG27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:28:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38747 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755628Ab2EIFwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:54 -0400
Message-Id: <20120509055037.339599419@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 055/167] [PATCH 2/4] ocfs: ->rl_used breakage on big-endian
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

commit e1bf4cc620fd143766ddfcee3b004a1d1bb34fd0 upstream.

it's le16, not le32 or le64...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/refcounttree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index a7b7217..bc90ebc 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1468,7 +1468,7 @@ static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
 
 	trace_ocfs2_divide_leaf_refcount_block(
 		(unsigned long long)ref_leaf_bh->b_blocknr,
-		le32_to_cpu(rl->rl_count), le32_to_cpu(rl->rl_used));
+		le32_to_cpu(rl->rl_count), le16_to_cpu(rl->rl_used));
 
 	/*
 	 * XXX: Improvement later.
@@ -2411,7 +2411,7 @@ static int ocfs2_calc_refcount_meta_credits(struct super_block *sb,
 				rb = (struct ocfs2_refcount_block *)
 							prev_bh->b_data;
 
-				if (le64_to_cpu(rb->rf_records.rl_used) +
+				if (le16_to_cpu(rb->rf_records.rl_used) +
 				    recs_add >
 				    le16_to_cpu(rb->rf_records.rl_count))
 					ref_blocks++;
@@ -2476,7 +2476,7 @@ static int ocfs2_calc_refcount_meta_credits(struct super_block *sb,
 	if (prev_bh) {
 		rb = (struct ocfs2_refcount_block *)prev_bh->b_data;
 
-		if (le64_to_cpu(rb->rf_records.rl_used) + recs_add >
+		if (le16_to_cpu(rb->rf_records.rl_used) + recs_add >
 		    le16_to_cpu(rb->rf_records.rl_count))
 			ref_blocks++;
 
@@ -3629,7 +3629,7 @@ int ocfs2_refcounted_xattr_delete_need(struct inode *inode,
 			 * one will split a refcount rec, so totally we need
 			 * clusters * 2 new refcount rec.
 			 */
-			if (le64_to_cpu(rb->rf_records.rl_used) + clusters * 2 >
+			if (le16_to_cpu(rb->rf_records.rl_used) + clusters * 2 >
 			    le16_to_cpu(rb->rf_records.rl_count))
 				ref_blocks++;
 
-- 
1.7.10



