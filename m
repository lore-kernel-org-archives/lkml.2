Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492Ab0GOTFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:05:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:38515 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934407Ab0GOTFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:05:42 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19X7bZBsyZXBSbXIjUCcwb/nogm3j8MNOkX8mnRT0
	FWiNnW+3IK1idk
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 22/25] mISDN: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 21:05:38 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Karsten Keil <isdn@linux-pingi.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Roel Kluin <roel.kluin@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152105.39404.PeterHuewe@gmx.de>
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
 drivers/isdn/hardware/mISDN/hfcmulti.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index d317195..4e3780d 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5354,12 +5354,9 @@ static struct pci_device_id hfmultipci_ids[] __devinitdata = {
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFCE1, PCI_VENDOR_ID_CCD,
 		PCI_SUBDEVICE_ID_CCD_JHSE1, 0, 0, H(25)}, /* Junghanns E1 */
 
-	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC4S, PCI_ANY_ID, PCI_ANY_ID,
-		0, 0, 0},
-	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_ANY_ID, PCI_ANY_ID,
-		0, 0, 0},
-	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFCE1, PCI_ANY_ID, PCI_ANY_ID,
-		0, 0, 0},
+	{ PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_HFC4S), 0 },
+	{ PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_HFC8S), 0 },
+	{ PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_HFCE1), 0 },
 	{0, }
 };
 #undef H
-- 
1.7.1

