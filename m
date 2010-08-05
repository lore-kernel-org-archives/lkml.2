Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab0HEUSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:18:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55317 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759415Ab0HEUSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:18:03 -0400
Date: Thu, 5 Aug 2010 22:18:01 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Faisal Latif <faisal.latif@intel.com>,
        Chien Tung <chien.tin.tung@intel.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/42] drivers/infiniband/hw/nes: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052217430.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

It is not clear whether the assignment should be part of the if branch
suggested by its indentation.  The patch preserves the current semantics.

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
 drivers/infiniband/hw/nes/nes_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index f41d890..9a379d4 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -2740,7 +2740,7 @@ void nes_nic_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *cq)
 				/* restart the queue if it had been stopped */
 				if (netif_queue_stopped(nesvnic->netdev))
 					netif_wake_queue(nesvnic->netdev);
-					sq_cqes = 0;
+				sq_cqes = 0;
 				}
 			} else {
 				rqes_processed ++;
