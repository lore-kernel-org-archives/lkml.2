Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0LYUYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 15:24:39 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16005 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab0LYUYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 15:24:38 -0500
Date: Sat, 25 Dec 2010 21:14:53 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: xfs@oss.sgi.com
cc: xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org,
        Alex Elder <aelder@sgi.com>
Subject: [PATCH] XFS: Compare, don't assign in ASSERT() in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <alpine.LNX.2.00.1012252110490.10759@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In fs/xfs/xfs_trans.c::xfs_trans_unreserve_and_mod_sb() at the out: label 
we have this:
	ASSERT(error = 0);
I believe a comparison was intended, not an assignment. If I'm right, the 
patch below fixes that up.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 xfs_trans.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

  compile tested only.

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f6d956b..0e312b9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1137,7 +1137,7 @@ out_undo_fdblocks:
 	if (blkdelta)
 		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
 out:
-	ASSERT(error = 0);
+	ASSERT(error == 0);
 	return;
 }
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

