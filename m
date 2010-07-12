Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0GLSAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:00:18 -0400
Received: from mxout-07.mxes.net ([216.86.168.182]:55271 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0GLSAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:00:17 -0400
From: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Bri=C3=A8re?= <fbriere@fbriere.net>
To: linux-kernel@vger.kernel.org
Cc: linux-parport@lists.infradead.org
Subject: [PATCH] parport_serial: Use the PCI IRQ if offered
Date: Mon, 12 Jul 2010 14:00:12 -0400
Message-Id: <1278957612-13326-1-git-send-email-fbriere@fbriere.net>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 51dcdfe added IRQ support for PCI parallel port devices handled
by parport_pc, but turned it off for parport_serial, despite a printk()
message to the contrary.

Signed-off-by: Frédéric Brière <fbriere@fbriere.net>
---
 drivers/parport/parport_serial.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
index a64b275..60c191d 100644
--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -505,7 +505,6 @@ static int __devinit parport_register (struct pci_dev *dev,
 			dev_dbg(&dev->dev,
 		"PCI parallel port detected: I/O at %#lx(%#lx), IRQ %d\n",
 				io_lo, io_hi, irq);
-			irq = PARPORT_IRQ_NONE;
 		}
 		port = parport_pc_probe_port (io_lo, io_hi, irq,
 			      PARPORT_DMA_NONE, &dev->dev, IRQF_SHARED);
-- 
1.7.1

