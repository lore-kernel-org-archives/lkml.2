Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236Ab0GOSsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:48:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:41771 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934174Ab0GOSsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:48:30 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1928vhKC212CoPdDRu9cYQC524av1zwTmPHdEfZfS
	1a3lIe8VkRgXtH
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 09/25] atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 20:48:26 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Chas Williams <chas@cmf.nrl.navy.mil>,
        "David S. Miller" <davem@davemloft.net>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Tejun Heo <tj@kernel.org>, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152048.27535.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
.subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
PCI_VDEVICE macro, and thus improves readability.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/atm/nicstar.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index cff337e..729a149 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -264,8 +264,7 @@ static void __devexit nicstar_remove_one(struct pci_dev *pcidev)
 }
 
 static struct pci_device_id nicstar_pci_tbl[] __devinitdata = {
-	{PCI_VENDOR_ID_IDT, PCI_DEVICE_ID_IDT_IDT77201,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VDEVICE(IDT, PCI_DEVICE_ID_IDT_IDT77201), 0 },
 	{0,}			/* terminate list */
 };
 
-- 
1.7.1

