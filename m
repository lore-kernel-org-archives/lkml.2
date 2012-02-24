Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2BXHrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:47:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38168 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab2BXHr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:47:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/11] PCI: Use class for quirk for legacy ATA NO_D3
Date: Thu, 23 Feb 2012 23:46:55 -0800
Message-Id: <1330069619-14446-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
References: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F474090.0064,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index f41e00d..a860812 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1166,17 +1166,20 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_10, qui
 
 static void __devinit quirk_no_ata_d3(struct pci_dev *pdev)
 {
-	/* Quirk the legacy ATA devices only. The AHCI ones are ok */
-	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
-		pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
+	pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_ANY_ID, quirk_no_ata_d3);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, PCI_ANY_ID, quirk_no_ata_d3);
+/* Quirk the legacy ATA devices only. The AHCI ones are ok */
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_ANY_ID,
+				PCI_CLASS_STORAGE_IDE, 8, quirk_no_ata_d3);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+				PCI_CLASS_STORAGE_IDE, 8, quirk_no_ata_d3);
 /* ALi loses some register settings that we cannot then restore */
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AL, PCI_ANY_ID, quirk_no_ata_d3);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_AL, PCI_ANY_ID,
+				PCI_CLASS_STORAGE_IDE, 8, quirk_no_ata_d3);
 /* VIA comes back fine but we need to keep it alive or ACPI GTM failures
    occur when mode detecting */
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_VIA, PCI_ANY_ID, quirk_no_ata_d3);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_VIA, PCI_ANY_ID,
+				PCI_CLASS_STORAGE_IDE, 8, quirk_no_ata_d3);
 
 /* This was originally an Alpha specific thing, but it really fits here.
  * The i82375 PCI/EISA bridge appears as non-classified. Fix that.
-- 
1.7.7

