Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab0FJJG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 05:06:58 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:33313 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab0FJJG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 05:06:56 -0400
Date: Thu, 10 Jun 2010 11:06:53 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, Linux RDMA <linux-rdma@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>
Subject: [PATCH] ib/ehca: bitmask handling for lock_hcalls
Message-ID: <20100610110653.17885a81@alex-laptop>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix reading capability bit from device capabilities for hcall locking.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---

Hi Roland, this applies against 2.6.35-rc2 and we would like to get
it into your -next tree, thanks!

 drivers/infiniband/hw/ehca/ehca_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.35-rc2.orig/drivers/infiniband/hw/ehca/ehca_main.c
+++ linux-2.6.35-rc2/drivers/infiniband/hw/ehca/ehca_main.c
@@ -360,7 +360,8 @@ static int ehca_sense_attributes(struct 
 	 * a firmware property, so it's valid across all adapters
 	 */
 	if (ehca_lock_hcalls == -1)
-		ehca_lock_hcalls = !(shca->hca_cap & HCA_CAP_H_ALLOC_RES_SYNC);
+		ehca_lock_hcalls = !EHCA_BMASK_GET(HCA_CAP_H_ALLOC_RES_SYNC,
+					shca->hca_cap);
 
 	/* translate supported MR page sizes; always support 4K */
 	shca->hca_cap_mr_pgsize = EHCA_PAGESIZE;
