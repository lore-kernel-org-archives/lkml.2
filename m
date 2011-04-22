Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1DVH6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 03:58:32 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:48004
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752134Ab1DVH63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 03:58:29 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Lei Xu <B33228@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-pci@vger.kernel.org>,
        <kumar.gala@freescale.com>, Lei Xu <B33228@freescale.com>
Subject: [PATCH] PCI: portdrv: fix irq initialization on FSL pcie host controller
Date: Fri, 22 Apr 2011 15:43:39 +0800
Message-ID: <1303458219-31915-1-git-send-email-B33228@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Root complex ports for Freescale PCIe host controller only receive
interrupts, so if there is no irq setting for RC, it should not return
error, otherwise it may result the PCIe host controller is disabled.

Signed-off-by: Lei Xu <B33228@freescale.com>
---
 drivers/pci/pcie/portdrv_core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 595654a..95e64c8 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -209,7 +209,10 @@ static int init_service_irqs(struct pci_dev *dev, int *irqs, int mask)
 		irqs[i] = irq;
 	irqs[PCIE_PORT_SERVICE_VC_SHIFT] = -1;
 
-	if (irq < 0)
+	/* Root complex ports for Freescale PCIe host controller only
+	 * receive interrupts, so if there is no irq setting for RC,
+	 * it should not return error. */
+	if ((irq < 0) && (dev->pcie_type != PCI_EXP_TYPE_ROOT_PORT))
 		return -ENODEV;
 	return 0;
 }
-- 
1.7.0.4


