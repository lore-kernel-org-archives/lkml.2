Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1AAJc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 04:32:26 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48009 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab1AAJcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 04:32:24 -0500
Message-ID: <4d1ef4a6.ca7a0e0a.3fb5.0561@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Fri, 31 Dec 2010 13:37:00 +0200
Subject: [PATCH 10/18] cx23885: remove duplicate set interrupt mask
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/video/cx23885/cx23885-core.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 307eaf4..3a09dd2 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -904,12 +904,6 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	dev->pci_bus  = dev->pci->bus->number;
 	dev->pci_slot = PCI_SLOT(dev->pci->devfn);
 	cx23885_irq_add(dev, 0x001f00);
-	if (cx23885_boards[dev->board].ci_type == 1)
-		cx23885_irq_add(dev, 0x01800000); /* for CiMaxes */
-
-	if (cx23885_boards[dev->board].ci_type == 2)
-		cx23885_irq_add(dev, 0x00800000); /* for FPGA */
-
 
 	/* External Master 1 Bus */
 	dev->i2c_bus[0].nr = 0;
@@ -2074,10 +2068,10 @@ static int __devinit cx23885_initdev(struct pci_dev *pci_dev,
 
 	switch (dev->board) {
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
-		cx23885_irq_add_enable(dev, 0x01800000); /* for NetUP */
+		cx23885_irq_add_enable(dev, PCI_MSK_GPIO1 | PCI_MSK_GPIO0);
 		break;
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
-		cx23885_irq_add_enable(dev, 0x00800000);
+		cx23885_irq_add_enable(dev, PCI_MSK_GPIO0);
 		break;
 	}
 
-- 
1.7.1

