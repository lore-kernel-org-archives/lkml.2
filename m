Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405Ab0COQmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:42:23 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:46261 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964965Ab0COQmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:42:22 -0400
X-Greylist: delayed 3163 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 12:42:22 EDT
From: Karsten Keil <keil@b1-systems.de>
Date: Mon, 15 Mar 2010 14:18:41 +0100
Subject: [PATCH] ISDN: Add PCI ID for HFC-2S/4S Beronet Card PCIe
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>, netdev@vger.kernel.org,
       Andreas Eversberg <andreas@eversberg.eu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-Id: <1268668176.12629@pingi>
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few subdevice IDs seem to have been dropped when hfc_multi was
included upstream, just compare the list at
http://www.openvox.cn/viewvc/misdn/trunk/hfc_multi.c?revision=75&view=annotate#l175
with the IDs in drivers/isdn/hardware/mISDN/hfcmulti.c

Added PCIe 2 Port card and LED settings (same as PCI) /KKe

Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    6 ++++++
 include/linux/pci_ids.h                |    2 ++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index ad36df9..751b34c 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5265,6 +5265,8 @@ static const struct hm_map hfcm_map[] = {
 /*31*/	{VENDOR_CCD, "XHFC-4S Speech Design", 5, 4, 0, 0, 0, 0,
 		HFC_IO_MODE_EMBSD, XHFC_IRQ},
 /*32*/	{VENDOR_JH, "HFC-8S (junghanns)", 8, 8, 1, 0, 0, 0, 0, 0},
+/*33*/	{VENDOR_BN, "HFC-2S Beronet Card PCIe", 4, 2, 1, 3, 0, DIP_4S, 0, 0},
+/*34*/	{VENDOR_BN, "HFC-4S Beronet Card PCIe", 4, 4, 1, 2, 0, DIP_4S, 0, 0},
 };
 
 #undef H
@@ -5300,6 +5302,10 @@ static struct pci_device_id hfmultipci_ids[] __devinitdata = {
 		PCI_SUBDEVICE_ID_CCD_OV4S, 0, 0, H(28)}, /* OpenVox 4 */
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC4S, PCI_VENDOR_ID_CCD,
 		PCI_SUBDEVICE_ID_CCD_OV2S, 0, 0, H(29)}, /* OpenVox 2 */
+	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC4S, PCI_VENDOR_ID_CCD,
+		PCI_SUBDEVICE_ID_CCD_BN2SE, 0, 0, H(33)}, /* BN2S PCIe */
+	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC4S, PCI_VENDOR_ID_CCD,
+		PCI_SUBDEVICE_ID_CCD_BN4SE, 0, 0, H(34)}, /* BN4S PCIe */
 
 	/* Cards with HFC-8S Chip */
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_VENDOR_ID_CCD,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 9f688d2..a5cc675 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1923,6 +1923,8 @@
 #define PCI_SUBDEVICE_ID_CCD_HFC8S	0xB622
 #define PCI_DEVICE_ID_CCD_B700		0xb700
 #define PCI_DEVICE_ID_CCD_B701		0xb701
+#define PCI_SUBDEVICE_ID_CCD_BN2SE	0xb761
+#define PCI_SUBDEVICE_ID_CCD_BN4SE	0xb762
 #define PCI_SUBDEVICE_ID_CCD_HFCE1	0xC523
 #define PCI_SUBDEVICE_ID_CCD_OV2S	0xE884
 #define PCI_SUBDEVICE_ID_CCD_OV4S	0xE888
-- 
1.6.0.2

