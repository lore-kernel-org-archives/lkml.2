Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106Ab0GOSiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:38:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:36716 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934085Ab0GOSiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:38:23 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19TwLp34PtTYLb05qeXYGnP95ylnYlXAuYqM80hUm
	P6p5dY9k/6fBwh
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 03/25] atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 20:38:20 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Chas Williams <chas@cmf.nrl.navy.mil>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Tejun Heo <tj@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152038.21535.PeterHuewe@gmx.de>
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
 drivers/atm/ambassador.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index 9d18644..a33896a 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -2371,10 +2371,8 @@ MODULE_PARM_DESC(pci_lat, "PCI latency in bus cycles");
 /********** module entry **********/
 
 static struct pci_device_id amb_pci_tbl[] = {
-	{ PCI_VENDOR_ID_MADGE, PCI_DEVICE_ID_MADGE_AMBASSADOR, PCI_ANY_ID, PCI_ANY_ID,
-	  0, 0, 0 },
-	{ PCI_VENDOR_ID_MADGE, PCI_DEVICE_ID_MADGE_AMBASSADOR_BAD, PCI_ANY_ID, PCI_ANY_ID,
-	  0, 0, 0 },
+	{ PCI_VDEVICE(MADGE, PCI_DEVICE_ID_MADGE_AMBASSADOR), 0 },
+	{ PCI_VDEVICE(MADGE, PCI_DEVICE_ID_MADGE_AMBASSADOR_BAD), 0 },
 	{ 0, }
 };
 
-- 
1.7.1

