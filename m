Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab0EFODJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:03:09 -0400
Received: from mail.redflag-linux.com ([219.237.229.196]:54944 "EHLO
	mail.redflag-linux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0EFODH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:03:07 -0400
X-Greylist: delayed 1561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 May 2010 10:03:07 EDT
Message-ID: <4BE2C5D5.2050207@redflag-linux.com>
Date: Thu, 06 May 2010 21:36:21 +0800
From: =?GB2312?B?IsXLzsDGvShQZXRlciBQYW4pIg==?= <wppan@redflag-linux.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100324 RedFlag/3.0.1-1rf2.dt8 Thunderbird/3.0.1
MIME-Version: 1.0
To: tj@kernel.org, Christoph Lameter <cl@linux-foundation.org>, hch@lst.de,
       akpm@linux-foundation.org, adilger@sun.com
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] ext2/ext3:useless code for return value
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When rsv is the right hand side of goal, we should return NULL,
because now rsv's prev is NULL, or we return rsv.

Signed-off-by: Peter Pan(екнюф╫) <wppan@redflag-linux.com>

---
 fs/ext2/balloc.c |    6 +-----
 fs/ext3/balloc.c |    6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 3cf038c..023990f 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -323,11 +323,7 @@ search_reserve_window(struct rb_root *root,
ext2_fsblk_t goal)
 	 * side of the interval containing the goal.  If it's the RHS,
 	 * we need to back up one.
 	 */
-	if (rsv->rsv_start > goal) {
-		n = rb_prev(&rsv->rsv_node);
-		rsv = rb_entry(n, struct ext2_reserve_window_node, rsv_node);
-	}
-	return rsv;
+    return (rsv->rsv_start < goal) ? rsv : NULL;
 }

 /*
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index a177122..bfa62e9 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -310,11 +310,7 @@ search_reserve_window(struct rb_root *root,
ext3_fsblk_t goal)
 	 * side of the interval containing the goal.  If it's the RHS,
 	 * we need to back up one.
 	 */
-	if (rsv->rsv_start > goal) {
-		n = rb_prev(&rsv->rsv_node);
-		rsv = rb_entry(n, struct ext3_reserve_window_node, rsv_node);
-	}
-	return rsv;
+    return (rsv->rsv_start < goal) ? rsv : NULL;
 }

 /**
-- 
1.6.6


-- 
Peter Pan(екнюф╫)
Red Flag Software Co.,Ltd
