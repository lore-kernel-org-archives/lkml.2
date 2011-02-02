Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1BBQxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:53:22 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:50838 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab1BBQxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:53:21 -0500
From: Julia Lawall <julia@diku.dk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/mtd/maps/ts5500_flash.c: avoid calling map_destroy on NULL
Date: Wed,  2 Feb 2011 18:13:36 +0100
Message-Id: <1296666816-21610-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

map_destroy dereferences its argument.  The call is furthermore only
reachable when this argument is NULL.  Thus the call is dropped.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
@@

*if (x == NULL)
{ ...
* map_destroy(x);
  ...
  return ...;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/maps/ts5500_flash.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/maps/ts5500_flash.c b/drivers/mtd/maps/ts5500_flash.c
index e2147bf..e02dfa9 100644
--- a/drivers/mtd/maps/ts5500_flash.c
+++ b/drivers/mtd/maps/ts5500_flash.c
@@ -94,7 +94,6 @@ static int __init init_ts5500_map(void)
 	return 0;
 
 err1:
-	map_destroy(mymtd);
 	iounmap(ts5500_map.virt);
 err2:
 	return rc;

