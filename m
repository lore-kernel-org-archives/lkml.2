Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2LCOgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:36:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43742 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755366Ab2LCOgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:18 -0500
Message-Id: <20121203143156.625011929@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:51 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        majianpeng <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [ 65/89] md: Reassigned the parameters if read_seqretry returned true in func
 md_is_badblock.
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit ab05613a0646dcc11049692d54bae76ca9ffa910 upstream.

This bug was introduced by commit(v3.0-rc7-126-g2230dfe).
So fix is suitable for 3.0.y thru 3.6.y.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/md.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9ab768a..14db6ab 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7936,9 +7936,9 @@ int md_is_badblock(struct badblocks *bb, sector_t s, int sectors,
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
 
@@ -7953,7 +7953,8 @@ int md_is_badblock(struct badblocks *bb, sector_t s, int sectors,
 
 retry:
 	seq = read_seqbegin(&bb->lock);
-
+	lo = 0;
+	rv = 0;
 	hi = bb->count;
 
 	/* Binary search between lo and hi for 'target'


