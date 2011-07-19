Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1GSGsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:48:31 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33705 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab1GSGsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:48:30 -0400
Subject: [PATCH] dma: intel_mid_dma: remove redundant pci_set_drvdata calls
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Wang <yong.y.wang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 14:48:17 +0800
Message-ID: <1311058097.2873.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call pci_set_drvdata() once in intel_mid_dma_probe() is enough.
Remove redundant pci_set_drvdata() calls in dma_suspend() and dma_resume().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/dma/intel_mid_dma.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index f653517..8a3fdd8 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1351,7 +1351,6 @@ int dma_suspend(struct pci_dev *pci, pm_message_t state)
 			return -EAGAIN;
 	}
 	device->state = SUSPENDED;
-	pci_set_drvdata(pci, device);
 	pci_save_state(pci);
 	pci_disable_device(pci);
 	pci_set_power_state(pci, PCI_D3hot);
@@ -1380,7 +1379,6 @@ int dma_resume(struct pci_dev *pci)
 	}
 	device->state = RUNNING;
 	iowrite32(REG_BIT0, device->dma_base + DMA_CFG);
-	pci_set_drvdata(pci, device);
 	return 0;
 }
 
-- 
1.7.4.1



