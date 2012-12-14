Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab2LNTlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:41:51 -0500
Received: from reverse.techspace.com ([216.174.116.17]:63340 "EHLO
	hdasch-dt.enmotus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932133Ab2LNTlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:41:49 -0500
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2012 14:41:49 EST
From: Hugh Daschbach <hugh.daschbach@enmotus.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Daschbach <hugh.daschbach@enmotus.com>
Subject: [PATCH 3.7.0] Add AHCI support for Enmotus Bobcat device.
Date: Fri, 14 Dec 2012 11:29:51 -0800
Message-Id: <1355513391-29458-1-git-send-email-hugh.daschbach@enmotus.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silicon does not support standard AHCI BAR assignment.  Add
vendor/device exception to force BAR 2.

Signed-off-by: Hugh Daschbach <hugh.daschbach@enmotus.com>
---
 drivers/ata/ahci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7862d17..3cb008f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -53,6 +53,7 @@
 
 enum {
 	AHCI_PCI_BAR_STA2X11	= 0,
+	AHCI_PCI_BAR_ENMOTUS	= 2,
 	AHCI_PCI_BAR_STANDARD	= 5,
 };
 
@@ -410,6 +411,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
+	/* Enmotus */
+	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -1101,6 +1105,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* The Connext uses non-standard BAR */
 	if (pdev->vendor == PCI_VENDOR_ID_STMICRO && pdev->device == 0xCC06)
 		ahci_pci_bar = AHCI_PCI_BAR_STA2X11;
+	else if (pdev->vendor == 0x1c44 && pdev->device == 0x8000)
+		ahci_pci_bar = AHCI_PCI_BAR_ENMOTUS;
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
-- 
1.7.11.7

