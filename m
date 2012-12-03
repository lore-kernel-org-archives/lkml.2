Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2LCQhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:37:35 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:4941 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab2LCQhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:37:34 -0500
From: Betty Dall <betty.dall@hp.com>
To: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: wangyijing@huawei.com, jiang.liu@huawei.com,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH] PCI AER: pci_get_domain_bus_and_slot() call missing required pci_dev_put()
Date: Mon,  3 Dec 2012 09:37:02 -0700
Message-Id: <1354552622-687-1-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function aer_recover_queue() makes a call to pci_get_domain_bus_and_slot().
That function is documented to require that the caller decrement the
reference count by calling pci_dev_put(). This patch adds the missing
call to pci_dev_put().

Signed-off-by: Betty Dall <betty.dall@hp.com>
---
 drivers/pci/pcie/aer/aerdrv_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index af4e31c..43caf53 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -616,6 +616,7 @@ static void aer_recover_work_func(struct work_struct *work)
 			continue;
 		}
 		do_recovery(pdev, entry.severity);
+		pci_dev_put(pdev);
 	}
 }
 #endif
-- 
1.7.7.6

