Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab2LVCbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:31:08 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:44762 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2LVCbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:31:06 -0500
From: Stefan Hasko <hasko.stevo@gmail.com>
To: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        linux-kernel@vger.kernel.org, Stefan Hasko <hasko.stevo@gmail.com>
Subject: [PATCH 2/2] drivers: infiniband: hw: cxgb4: fix cast warning
Date: Sat, 22 Dec 2012 03:29:21 +0100
Message-Id: <1356143361-31783-1-git-send-email-hasko.stevo@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed compile warning cast to pointer from integer of different size

Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
---
 drivers/infiniband/hw/cxgb4/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index cb4ecd7..314ec4a 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -413,7 +413,7 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
 	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
 	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
-	     (void *)pci_resource_start(rdev->lldi.pdev, 2),
+	     (void *)(unsigned long)pci_resource_start(rdev->lldi.pdev, 2),
 	     rdev->lldi.db_reg,
 	     rdev->lldi.gts_reg,
 	     rdev->qpshift, rdev->qpmask,
-- 
1.7.10.4

