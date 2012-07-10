Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2GJWbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:31:15 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44724 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab2GJWbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:31:10 -0400
From: Jon Mason <jdmason@kudzu.us>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [trivial PATCH 3/7] megaraid: remove unnecessary #defines
Date: Tue, 10 Jul 2012 15:31:28 -0700
Message-Id: <1341959492-31389-3-git-send-email-jdmason@kudzu.us>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
References: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove PCI vendor and subvendor IDs, as they are already defined in
pci_ids.h.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 drivers/scsi/megaraid.c |    5 ++---
 drivers/scsi/megaraid.h |   35 -----------------------------------
 2 files changed, 2 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 4d39a9f..f066ec4 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -305,12 +305,11 @@ mega_query_adapter(adapter_t *adapter)
 
 	adapter->host->sg_tablesize = adapter->sglen;
 
-
 	/* use HP firmware and bios version encoding
 	   Note: fw_version[0|1] and bios_version[0|1] were originally shifted
 	   right 8 bits making them zero. This 0 value was hardcoded to fix
 	   sparse warnings. */
-	if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
+	if (adapter->product_info.subsysvid == PCI_VENDOR_ID_HP) {
 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
 			 adapter->product_info.fw_version[2],
 			 0,
@@ -4716,7 +4715,7 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * support, since this firmware cannot handle 64 bit
 	 * addressing
 	 */
-	if ((subsysvid == HP_SUBSYS_VID) &&
+	if ((subsysvid == PCI_VENDOR_ID_HP) &&
 	    ((subsysid == 0x60E7) || (subsysid == 0x60E8))) {
 		/*
 		 * which firmware
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 9a7897f..4fb2adf 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -45,45 +45,10 @@
 
 #define MAX_DEV_TYPE	32
 
-#ifndef PCI_VENDOR_ID_LSI_LOGIC
-#define PCI_VENDOR_ID_LSI_LOGIC		0x1000
-#endif
-
-#ifndef PCI_VENDOR_ID_AMI
-#define PCI_VENDOR_ID_AMI		0x101E
-#endif
-
-#ifndef PCI_VENDOR_ID_DELL
-#define PCI_VENDOR_ID_DELL		0x1028
-#endif
-
-#ifndef PCI_VENDOR_ID_INTEL
-#define PCI_VENDOR_ID_INTEL		0x8086
-#endif
-
-#ifndef PCI_DEVICE_ID_AMI_MEGARAID
-#define PCI_DEVICE_ID_AMI_MEGARAID	0x9010
-#endif
-
-#ifndef PCI_DEVICE_ID_AMI_MEGARAID2
-#define PCI_DEVICE_ID_AMI_MEGARAID2	0x9060
-#endif
-
-#ifndef PCI_DEVICE_ID_AMI_MEGARAID3
-#define PCI_DEVICE_ID_AMI_MEGARAID3	0x1960
-#endif
-
 #define PCI_DEVICE_ID_DISCOVERY		0x000E
 #define PCI_DEVICE_ID_PERC4_DI		0x000F
 #define PCI_DEVICE_ID_PERC4_QC_VERDE	0x0407
 
-/* Sub-System Vendor IDs */
-#define	AMI_SUBSYS_VID			0x101E
-#define DELL_SUBSYS_VID			0x1028
-#define	HP_SUBSYS_VID			0x103C
-#define LSI_SUBSYS_VID			0x1000
-#define INTEL_SUBSYS_VID		0x8086
-
 #define HBA_SIGNATURE	      		0x3344
 #define HBA_SIGNATURE_471	  	0xCCCC
 #define HBA_SIGNATURE_64BIT		0x0299
-- 
1.7.9.5

