Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab1IHDnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 23:43:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52735 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab1IHDnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 23:43:53 -0400
From: Keng-Yu Lin <kengyu@canonical.com>
To: Jeff Garzik <jgarzik@pobox.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH] achi, ata_generic: Add ASMedia ASM1061 support
Date: Thu,  8 Sep 2011 11:43:46 +0800
Message-Id: <1315453426-8796-1-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASM1061 PCI-E to SATA bridge controller has two variants.
One works under AHCI and the other works with ata_generic.

Add the PCI vendor ID and product IDs accordingly.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/ata/ahci.c        |    3 +++
 drivers/ata/ata_generic.c |    1 +
 include/linux/pci_ids.h   |    4 ++++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 71afe03..4899aad 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -397,6 +397,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
 
+	/* Asmedia */
+	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1061 */
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 721d38b..8187503 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -220,6 +220,7 @@ static struct pci_device_id ata_generic[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_HINT,   PCI_DEVICE_ID_HINT_VXPROII_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ASMEDIA,PCI_DEVICE_ID_ASM1061_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE),
 	  .driver_data = ATA_GEN_FORCE_DMA },
 	/*
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f8910e1..87182b8 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2844,3 +2844,7 @@
 
 #define PCI_VENDOR_ID_XEN		0x5853
 #define PCI_DEVICE_ID_XEN_PLATFORM	0x0001
+
+#define PCI_VENDOR_ID_ASMEDIA		0x1b21
+#define PCI_DEVICE_ID_ASM1061_IDE	0x0611
+#define PCI_DEVICE_ID_ASM1061_AHCI	0x0612
-- 
1.7.5.4

