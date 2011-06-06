Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab1FFWqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:46:20 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58009
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758162Ab1FFWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 14/49] Staging: hv: vmbus: Use the DSDT specified irq for vmbus
Date: Mon,  6 Jun 2011 15:49:38 -0700
Message-Id: <1307400613-13234-14-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DSDT specifies the irq value for the vmbus driver; use it unconditionally.
This is an exclusive interrupt line dedicated for the vmbus driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 1b69339..5d7ecfd 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -552,9 +552,8 @@ static int vmbus_bus_init(int irq)
 	}
 
 	/* Get the interrupt resource */
-	ret = request_irq(irq, vmbus_isr,
-			  IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			  driver_name, hv_pci_dev);
+	ret = request_irq(irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
+			driver_name, hv_pci_dev);
 
 	if (ret != 0) {
 		pr_err("Unable to request IRQ %d\n",
@@ -787,15 +786,7 @@ static int __devinit hv_pci_probe(struct pci_dev *pdev,
 	if (pci_probe_error)
 		goto probe_cleanup;
 
-	/*
-	 * If the PCI sub-sytem did not assign us an
-	 * irq, use the bios provided one.
-	 */
-
-	if (pdev->irq == 0)
-		pdev->irq = irq;
-
-	pci_probe_error = vmbus_bus_init(pdev->irq);
+	pci_probe_error = vmbus_bus_init(irq);
 
 	if (pci_probe_error)
 		pci_disable_device(pdev);
-- 
1.7.4.1

