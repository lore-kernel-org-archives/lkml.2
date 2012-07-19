Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab2GSRhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:37:14 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:18221 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2GSRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:37:10 -0400
From: Betty Dall <betty.dall@hp.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc: infinipath@qlogic.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, Betty Dall <betty.dall@hp.com>
Subject: [PATCH] [Trivial] qib: fix an incorrect message
Date: Thu, 19 Jul 2012 13:34:19 -0600
Message-Id: <1342726459-2199-1-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a cut and paste typo in the function qib_pci_slot_reset() where
it prints that the "link_reset" function is called rather than the
"slot_reset" function. This makes the message misleading.

Signed-off-by: Betty Dall <betty.dall@hp.com>
---
 drivers/infiniband/hw/qib/qib_pcie.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 790646e..4f9d918 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -725,7 +725,7 @@ qib_pci_mmio_enabled(struct pci_dev *pdev)
 static pci_ers_result_t
 qib_pci_slot_reset(struct pci_dev *pdev)
 {
-	qib_devinfo(pdev, "QIB link_reset function called, ignored\n");
+	qib_devinfo(pdev, "QIB slot_reset function called, ignored\n");
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
-- 
1.7.7

