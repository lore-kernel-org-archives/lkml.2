Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746Ab2HIVvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:51:18 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:29855 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758675Ab2HIVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:51:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1344549072!7888263!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] staging: comedi: adl_pci6208: add support for the PCI-6216 card
Date: Thu, 9 Aug 2012 14:51:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208091451.07561.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the boardinfo and pci device table information for the PCI-6216 card.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 6d887f7..43e23e1 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -27,8 +27,9 @@
 */
 /*
 Driver: adl_pci6208
-Description: ADLink PCI-6208A
-Devices: [ADLink] PCI-6208A (adl_pci6208)
+Description: ADLink PCI-6208/6216 Series Multi-channel Analog Output Cards
+Devices: (ADLink) PCI-6208 [adl_pci6208]
+	 (ADLink) PCI-6216 [adl_pci6216]
 Author: nsyeow <nsyeow@pd.jaring.my>
 Updated: Fri, 30 Jan 2004 14:44:27 +0800
 Status: untested
@@ -44,6 +45,12 @@ References:
 #include "../comedidev.h"
 
 /*
+ * ADLINK PCI Device ID's supported by this driver
+ */
+#define PCI_DEVICE_ID_PCI6208		0x6208
+#define PCI_DEVICE_ID_PCI6216		0x6216
+
+/*
  * PCI-6208/6216-GL register map
  */
 #define PCI6208_AO_CONTROL(x)		(0x00 + (2 * (x)))
@@ -55,7 +62,7 @@ References:
 #define PCI6208_DIO_DI_MASK		(0xf0)
 #define PCI6208_DIO_DI_SHIFT		(4)
 
-#define PCI6208_MAX_AO_CHANNELS		8
+#define PCI6208_MAX_AO_CHANNELS		16
 
 struct pci6208_board {
 	const char *name;
@@ -65,9 +72,13 @@ struct pci6208_board {
 
 static const struct pci6208_board pci6208_boards[] = {
 	{
-		.name		= "pci6208a",
-		.dev_id		= 0x6208,
+		.name		= "adl_pci6208",
+		.dev_id		= PCI_DEVICE_ID_PCI6208,
 		.ao_chans	= 8,
+	}, {
+		.name		= "adl_pci6216",
+		.dev_id		= PCI_DEVICE_ID_PCI6216,
+		.ao_chans	= 16,
 	},
 };
 
@@ -269,7 +280,8 @@ static void __devexit adl_pci6208_pci_remove(struct pci_dev *dev)
 }
 
 static DEFINE_PCI_DEVICE_TABLE(adl_pci6208_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, 0x6208) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI6208) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI6216) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, adl_pci6208_pci_table);
-- 
1.7.11

