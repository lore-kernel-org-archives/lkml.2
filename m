Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769174Ab2K3T0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:26:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:58302 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992659Ab2K3S4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jianpeng Ma <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [ 24/56] md: Reassigned the parameters if read_seqretry returned true in func md_is_badblock.
Date: Fri, 30 Nov 2012 10:55:16 -0800
Message-Id: <20121130185120.733014618@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit ab05613a0646dcc11049692d54bae76ca9ffa910 upstream.

This bug was introduced by commit(v3.0-rc7-126-g2230dfe).
So fix is suitable for 3.0.y thru 3.6.y.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7694,9 +7694,9 @@ int md_is_badblock(struct badblocks *bb,
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
 
@@ -7711,7 +7711,8 @@ int md_is_badblock(struct badblocks *bb,
 
 retry:
 	seq = read_seqbegin(&bb->lock);
-
+	lo = 0;
+	rv = 0;
 	hi = bb->count;
 
 	/* Binary search between lo and hi for 'target'


