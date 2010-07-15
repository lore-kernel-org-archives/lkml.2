Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439Ab0GOTEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:04:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53214 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934360Ab0GOTEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:04:11 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18nLH0Np1Un2BhkCxUvkCID8ItOUBUQt+THIMKpNT
	BmZxbe9RKEeJFu
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 20/25] mISDN: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 21:04:07 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Karsten Keil <isdn@linux-pingi.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152104.08458.PeterHuewe@gmx.de>
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
 drivers/isdn/hardware/mISDN/mISDNinfineon.c |   39 +++++++++-----------------
 1 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNinfineon.c b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
index 4975976..d2dd61d 100644
--- a/drivers/isdn/hardware/mISDN/mISDNinfineon.c
+++ b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
@@ -125,36 +125,25 @@ struct inf_hw {
 #define PCI_SUB_ID_SEDLBAUER            0x01
 
 static struct pci_device_id infineon_ids[] __devinitdata = {
-	{ PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_DIVA20,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_DIVA20},
-	{ PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_DIVA20_U,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_DIVA20U},
-	{ PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_DIVA201,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_DIVA201},
-	{ PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_DIVA202,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_DIVA202},
+	{ PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_DIVA20), INF_DIVA20 },
+	{ PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_DIVA20_U), INF_DIVA20U },
+	{ PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_DIVA201), INF_DIVA201 },
+	{ PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_DIVA202), INF_DIVA202 },
 	{ PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_100,
 	  PCI_SUBVENDOR_SEDLBAUER_PCI, PCI_SUB_ID_SEDLBAUER, 0, 0,
-	  INF_SPEEDWIN},
+	  INF_SPEEDWIN },
 	{ PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_100,
-	  PCI_SUBVENDOR_HST_SAPHIR3, PCI_SUB_ID_SEDLBAUER, 0, 0, INF_SAPHIR3},
-	{ PCI_VENDOR_ID_ELSA, PCI_DEVICE_ID_ELSA_MICROLINK,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_QS1000},
-	{ PCI_VENDOR_ID_ELSA, PCI_DEVICE_ID_ELSA_QS3000,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_QS3000},
-	{ PCI_VENDOR_ID_SATSAGEM, PCI_DEVICE_ID_SATSAGEM_NICCY,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_NICCY},
+	  PCI_SUBVENDOR_HST_SAPHIR3, PCI_SUB_ID_SEDLBAUER, 0, 0, INF_SAPHIR3 },
+	{ PCI_VDEVICE(ELSA, PCI_DEVICE_ID_ELSA_MICROLINK), INF_QS1000 },
+	{ PCI_VDEVICE(ELSA, PCI_DEVICE_ID_ELSA_QS3000), INF_QS3000 },
+	{ PCI_VDEVICE(SATSAGEM, PCI_DEVICE_ID_SATSAGEM_NICCY), INF_NICCY },
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 	  PCI_VENDOR_ID_BERKOM, PCI_DEVICE_ID_BERKOM_SCITEL_QUADRO, 0, 0,
-	  INF_SCT_1},
-	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_R685,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_GAZEL_R685},
-	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_R753,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_GAZEL_R753},
-	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_DJINN_ITOO,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_GAZEL_R753},
-	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_OLITEC,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, INF_GAZEL_R753},
+	  INF_SCT_1 },
+	{ PCI_VDEVICE(PLX, PCI_DEVICE_ID_PLX_R685), INF_GAZEL_R685 },
+	{ PCI_VDEVICE(PLX, PCI_DEVICE_ID_PLX_R753), INF_GAZEL_R753 },
+	{ PCI_VDEVICE(PLX, PCI_DEVICE_ID_PLX_DJINN_ITOO), INF_GAZEL_R753 },
+	{ PCI_VDEVICE(PLX, PCI_DEVICE_ID_PLX_OLITEC), INF_GAZEL_R753 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, infineon_ids);
-- 
1.7.1

