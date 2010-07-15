Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab0GOSmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:42:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:50612 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934188Ab0GOSmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:42:16 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19GMigz6P9G0j8YDAahJpM4hPfWAwnr2nJ7WUvGfa
	qLIzsdWnxeP+5n
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 06/25] atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 20:42:12 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Chas Williams <chas@cmf.nrl.navy.mil>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152042.13091.PeterHuewe@gmx.de>
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
 drivers/atm/firestream.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 6e600af..8717809 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -2027,10 +2027,8 @@ static void __devexit firestream_remove_one (struct pci_dev *pdev)
 }
 
 static struct pci_device_id firestream_pci_tbl[] = {
-	{ PCI_VENDOR_ID_FUJITSU_ME, PCI_DEVICE_ID_FUJITSU_FS50, 
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, FS_IS50},
-	{ PCI_VENDOR_ID_FUJITSU_ME, PCI_DEVICE_ID_FUJITSU_FS155, 
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, FS_IS155},
+	{ PCI_VDEVICE(FUJITSU_ME, PCI_DEVICE_ID_FUJITSU_FS50), FS_IS50},
+	{ PCI_VDEVICE(FUJITSU_ME, PCI_DEVICE_ID_FUJITSU_FS155), FS_IS155},
 	{ 0, }
 };
 
-- 
1.7.1

