Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1LUBcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:32:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45537 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713Ab1LUBcM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:32:12 -0500
Message-ID: <1324431127.2844.146.camel@deadeye>
Subject: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
From: Ben Hutchings <ben@decadent.org.uk>
To: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 01:32:07 +0000
In-Reply-To: <1324430940.2844.144.camel@deadeye>
References: <1324430940.2844.144.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Physical addresses may be wider than virtual addresses (e.g. on i386
with PAE) and must not be formatted with %p.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
The resource could alternately be formatted with %Pr.

Ben.

 drivers/infiniband/hw/cxgb4/device.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 6d0df6e..d395623 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -318,10 +318,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	     rdev->lldi.vr->qp.size,
 	     rdev->lldi.vr->cq.start,
 	     rdev->lldi.vr->cq.size);
-	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
+	PDBG("udb len 0x%x udb base %llx db_reg %p gts_reg %p qpshift %lu "
 	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
 	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
-	     (void *)pci_resource_start(rdev->lldi.pdev, 2),
+	     (u64)pci_resource_start(rdev->lldi.pdev, 2),
 	     rdev->lldi.db_reg,
 	     rdev->lldi.gts_reg,
 	     rdev->qpshift, rdev->qpmask,
-- 
1.7.7.3



