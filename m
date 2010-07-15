Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab0GOSjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:39:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:37300 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934072Ab0GOSjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:39:45 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18YoWUsjyoYCe8XZe2Gscosw6IaUD1aH03w2kJtDc
	bTwf6Kmz5V+e0Y
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 04/25] ata: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 20:39:43 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152039.44324.PeterHuewe@gmx.de>
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
 drivers/ata/pata_scc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index d9db3f8..fe36966 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -168,8 +168,7 @@ static const unsigned long JCACTSELtbl[2][7] = {
 };
 
 static const struct pci_device_id scc_pci_tbl[] = {
-	{PCI_VENDOR_ID_TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SCC_ATA,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VDEVICE(TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SCC_ATA), 0},
 	{ }	/* terminate list */
 };
 
-- 
1.7.1

