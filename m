Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab2DXWtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:49:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab2DXWgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:55 -0400
Message-Id: <20120424223247.027703131@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Subject: [ 59/62] ocfs: ->rl_used breakage on big-endian
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit e1bf4cc620fd143766ddfcee3b004a1d1bb34fd0 upstream.

it's le16, not le32 or le64...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/refcounttree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1468,7 +1468,7 @@ static int ocfs2_divide_leaf_refcount_bl
 
 	trace_ocfs2_divide_leaf_refcount_block(
 		(unsigned long long)ref_leaf_bh->b_blocknr,
-		le32_to_cpu(rl->rl_count), le32_to_cpu(rl->rl_used));
+		le32_to_cpu(rl->rl_count), le16_to_cpu(rl->rl_used));
 
 	/*
 	 * XXX: Improvement later.
@@ -2411,7 +2411,7 @@ static int ocfs2_calc_refcount_meta_cred
 				rb = (struct ocfs2_refcount_block *)
 							prev_bh->b_data;
 
-				if (le64_to_cpu(rb->rf_records.rl_used) +
+				if (le16_to_cpu(rb->rf_records.rl_used) +
 				    recs_add >
 				    le16_to_cpu(rb->rf_records.rl_count))
 					ref_blocks++;
@@ -2476,7 +2476,7 @@ static int ocfs2_calc_refcount_meta_cred
 	if (prev_bh) {
 		rb = (struct ocfs2_refcount_block *)prev_bh->b_data;
 
-		if (le64_to_cpu(rb->rf_records.rl_used) + recs_add >
+		if (le16_to_cpu(rb->rf_records.rl_used) + recs_add >
 		    le16_to_cpu(rb->rf_records.rl_count))
 			ref_blocks++;
 
@@ -3629,7 +3629,7 @@ int ocfs2_refcounted_xattr_delete_need(s
 			 * one will split a refcount rec, so totally we need
 			 * clusters * 2 new refcount rec.
 			 */
-			if (le64_to_cpu(rb->rf_records.rl_used) + clusters * 2 >
+			if (le16_to_cpu(rb->rf_records.rl_used) + clusters * 2 >
 			    le16_to_cpu(rb->rf_records.rl_count))
 				ref_blocks++;
 


