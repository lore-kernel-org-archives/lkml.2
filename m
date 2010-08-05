Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297Ab0HEU0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:26:30 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:58003 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934252Ab0HEU0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:26:23 -0400
Date: Thu, 5 Aug 2010 22:26:20 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 31/42] drivers/net: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052226050.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Outdent the code following the if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/gianfar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index a1b6301..36ccc37 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -1859,7 +1859,7 @@ static int register_grp_irqs(struct gfar_priv_grp *grp)
 				printk(KERN_ERR "%s: Can't get IRQ %d\n",
 					dev->name, grp->interruptError);
 
-				goto err_irq_fail;
+			goto err_irq_fail;
 		}
 
 		if ((err = request_irq(grp->interruptTransmit, gfar_transmit,
