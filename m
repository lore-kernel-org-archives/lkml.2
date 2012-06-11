Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2FKJSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:18:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:54416 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab2FKJSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:18:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="178292045"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH for v3.5 1/2] misc: mei: Disable MSI when IRQ registration fails
Date: Mon, 11 Jun 2012 12:18:30 +0300
Message-Id: <1339406311-27283-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

Since MSI is enabled right before that, we should disable it when
registration fails.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index a5a17e7..7de1389 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -992,7 +992,7 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 	if (err) {
 		dev_err(&pdev->dev, "request_threaded_irq failure. irq = %d\n",
 		       pdev->irq);
-		goto unmap_memory;
+		goto disable_msi;
 	}
 	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
 	if (mei_hw_init(dev)) {
@@ -1023,8 +1023,8 @@ release_irq:
 	mei_disable_interrupts(dev);
 	flush_scheduled_work();
 	free_irq(pdev->irq, dev);
+disable_msi:
 	pci_disable_msi(pdev);
-unmap_memory:
 	pci_iounmap(pdev, dev->mem_addr);
 free_device:
 	kfree(dev);
-- 
1.7.4.4

