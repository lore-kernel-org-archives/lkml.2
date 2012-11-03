Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2KCK64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 06:58:56 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:9242 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904Ab2KCK6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245664"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Neil Brown <neilb@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/16] drivers/md/raid5.c: use WARN
Date: Sat,  3 Nov 2012 11:58:24 +0100
Message-Id: <1351940317-14812-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/md/raid5.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 320df0c..8c3b9bb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -373,13 +373,11 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 		struct r5dev *dev = &sh->dev[i];
 
 		if (dev->toread || dev->read || dev->towrite || dev->written ||
-		    test_bit(R5_LOCKED, &dev->flags)) {
-			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
+		    test_bit(R5_LOCKED, &dev->flags))
+			WARN(1, KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
 			       (unsigned long long)sh->sector, i, dev->toread,
 			       dev->read, dev->towrite, dev->written,
 			       test_bit(R5_LOCKED, &dev->flags));
-			WARN_ON(1);
-		}
 		dev->flags = 0;
 		raid5_build_block(sh, i, previous);
 	}

