Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2E1DmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:42:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52088 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959Ab2E1D3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:39 -0400
Message-Id: <20120528031211.981279923@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shaohua Li <shli@kernel.org>,
        Shaohua Li <shli@fusionio.com>, NeilBrown <neilb@suse.de>
Subject: [ 066/117] md: using GFP_NOIO to allocate bio for flush request
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit b5e1b8cee7ad58a15d2fa79bcd7946acb592602d upstream.

A flush request is usually issued in transaction commit code path, so
using GFP_KERNEL to allocate memory for flush request bio falls into
the classic deadlock issue.

This is suitable for any -stable kernel to which it applies as it
avoids a possible deadlock.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 01233d8..2b30ffd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -452,7 +452,7 @@ static void submit_flushes(struct work_struct *ws)
 			atomic_inc(&rdev->nr_pending);
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
-			bi = bio_alloc_mddev(GFP_KERNEL, 0, mddev);
+			bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
 			bi->bi_end_io = md_end_flush;
 			bi->bi_private = rdev;
 			bi->bi_bdev = rdev->bdev;


