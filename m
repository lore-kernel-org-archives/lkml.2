Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172Ab0GOSlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:41:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:58913 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934117Ab0GOSlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:41:10 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/XluUZqNLXsslijH61J+IXs8LrbrT4XAf8F9bhUx
	lTZHTlO3s9BRs4
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 05/25] atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 20:41:08 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Chas Williams <chas@cmf.nrl.navy.mil>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152041.08976.PeterHuewe@gmx.de>
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
 drivers/atm/eni.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 90a5a7c..80f9f36 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -2269,10 +2269,8 @@ out0:
 
 
 static struct pci_device_id eni_pci_tbl[] = {
-	{ PCI_VENDOR_ID_EF, PCI_DEVICE_ID_EF_ATM_FPGA, PCI_ANY_ID, PCI_ANY_ID,
-	  0, 0, 0 /* FPGA */ },
-	{ PCI_VENDOR_ID_EF, PCI_DEVICE_ID_EF_ATM_ASIC, PCI_ANY_ID, PCI_ANY_ID,
-	  0, 0, 1 /* ASIC */ },
+	{ PCI_VDEVICE(EF, PCI_DEVICE_ID_EF_ATM_FPGA), 0 /* FPGA */ },
+	{ PCI_VDEVICE(EF, PCI_DEVICE_ID_EF_ATM_ASIC), 1 /* ASIC */ },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci,eni_pci_tbl);
-- 
1.7.1

