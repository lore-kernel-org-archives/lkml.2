Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab2BMUuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:50:22 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17832 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab2BMUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:50:21 -0500
Date: Mon, 13 Feb 2012 21:51:05 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: xfs@oss.sgi.com
cc: xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org,
        Alex Elder <elder@kernel.org>, Ben Myers <bpm@sgi.com>
Subject: [PATCH] XFS; xfs_trans_add_item() - don't assign in ASSERT() when
 compare is intended
Message-ID: <alpine.LNX.2.00.1202132149270.16039@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks to me like the two ASSERT()s in xfs_trans_add_item() really
want to do a compare (==) rather than assignment (=).
This patch changes it from the former to the latter.

I must admit though, that I don't know this code well and have only
compile tested this change. But if assignment is really intended it
really seems strange to do it as part of an ASSERT...

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/xfs/xfs_trans.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 329b06a..7adcdf1 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1151,8 +1151,8 @@ xfs_trans_add_item(
 {
 	struct xfs_log_item_desc *lidp;
 
-	ASSERT(lip->li_mountp = tp->t_mountp);
-	ASSERT(lip->li_ailp = tp->t_mountp->m_ail);
+	ASSERT(lip->li_mountp == tp->t_mountp);
+	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
 
 	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
 
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

