Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab2DXWhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:37:08 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195Ab2DXWhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:01 -0400
Message-Id: <20120424223247.203509213@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Subject: [ 61/62] ocfs2: ->e_leaf_clusters endianness breakage
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 72094e43e3af5020510f920321d71f1798fa896d upstream.

le16, not le32...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/suballoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -600,7 +600,7 @@ static void ocfs2_bg_alloc_cleanup(handl
 		ret = ocfs2_free_clusters(handle, cluster_ac->ac_inode,
 					  cluster_ac->ac_bh,
 					  le64_to_cpu(rec->e_blkno),
-					  le32_to_cpu(rec->e_leaf_clusters));
+					  le16_to_cpu(rec->e_leaf_clusters));
 		if (ret)
 			mlog_errno(ret);
 		/* Try all the clusters to free */
@@ -1628,7 +1628,7 @@ static int ocfs2_bg_discontig_fix_by_rec
 {
 	unsigned int bpc = le16_to_cpu(cl->cl_bpc);
 	unsigned int bitoff = le32_to_cpu(rec->e_cpos) * bpc;
-	unsigned int bitcount = le32_to_cpu(rec->e_leaf_clusters) * bpc;
+	unsigned int bitcount = le16_to_cpu(rec->e_leaf_clusters) * bpc;
 
 	if (res->sr_bit_offset < bitoff)
 		return 0;


