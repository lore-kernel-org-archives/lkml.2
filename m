Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab0HCVfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:35:40 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41854 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab0HCVfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:35:37 -0400
Date: Tue, 3 Aug 2010 23:35:36 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 9/9] drivers/infiniband/hw/ehca: Drop unnecessary null test
Message-ID: <Pine.LNX.4.64.1008032335190.20393@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

list_for_each_entry binds its first argument to a non-null value, and thus
any null test on the value of that argument is superfluous.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
iterator I;
expression x;
statement S,S1,S2;
@@

I(x,...) { <...
- if (x == NULL && ...) S
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 31a68b9..53f4cd4 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -933,11 +933,6 @@ int ehca_unmap_fmr(struct list_head *fmr_list)
 	/* check all FMR belong to same SHCA, and check internal flag */
 	list_for_each_entry(ib_fmr, fmr_list, list) {
 		prev_shca = shca;
-		if (!ib_fmr) {
-			ehca_gen_err("bad fmr=%p in list", ib_fmr);
-			ret = -EINVAL;
-			goto unmap_fmr_exit0;
-		}
 		shca = container_of(ib_fmr->device, struct ehca_shca,
 				    ib_device);
 		e_fmr = container_of(ib_fmr, struct ehca_mr, ib.ib_fmr);
