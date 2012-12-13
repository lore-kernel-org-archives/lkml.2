Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab2LMOmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:42:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44561 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab2LMOIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:23 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianpeng Ma <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 121/241] md: Reassigned the parameters if read_seqretry returned true in func md_is_badblock.
Date: Thu, 13 Dec 2012 11:58:06 -0200
Message-Id: <1355407206-17100-122-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit ab05613a0646dcc11049692d54bae76ca9ffa910 upstream.

This bug was introduced by commit(v3.0-rc7-126-g2230dfe).
So fix is suitable for 3.0.y thru 3.6.y.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/md/md.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6fc0c26..e977874 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7960,9 +7960,9 @@ int md_is_badblock(struct badblocks *bb, sector_t s, int sectors,
 		   sector_t *first_bad, int *bad_sectors)
 {
 	int hi;
-	int lo = 0;
+	int lo;
 	u64 *p = bb->page;
-	int rv = 0;
+	int rv;
 	sector_t target = s + sectors;
 	unsigned seq;
 
@@ -7977,7 +7977,8 @@ int md_is_badblock(struct badblocks *bb, sector_t s, int sectors,
 
 retry:
 	seq = read_seqbegin(&bb->lock);
-
+	lo = 0;
+	rv = 0;
 	hi = bb->count;
 
 	/* Binary search between lo and hi for 'target'
-- 
1.7.9.5

