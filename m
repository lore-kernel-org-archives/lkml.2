Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab1K0ON5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 09:13:57 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:35677 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755457Ab1K0ON4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 09:13:56 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/sCLpgaVvszPe3aOUG7XYHlgCPz7zj4DeXM0sXe1
	cT5zrfCi2RsisP
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Henk de Groot <pe1dnn@amsat.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/wlags49_h2: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Sun, 27 Nov 2011 15:13:51 +0100
Message-Id: <1322403231-10317-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts pci_table entries to use the PCI_DEVICE macro,
if .subvendor and .subdevice are set to PCI_ANY_ID,
and thus improves readablity.

Since CH_Agere_Systems_Mini_PCI_V1 is defined as 0 in hermes_pci_versions
and neither the enum nor the value is used anywhere else, we can drop
the assignment of .driver_data as it is initialized as 0 by default.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/wlags49_h2/wl_pci.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_pci.c b/drivers/staging/wlags49_h2/wl_pci.c
index 28ae9dd..30456ed 100644
--- a/drivers/staging/wlags49_h2/wl_pci.c
+++ b/drivers/staging/wlags49_h2/wl_pci.c
@@ -112,17 +112,10 @@ extern dbg_info_t *DbgInfo;
 #endif  // DBG
 
 /* define the PCI device Table Cardname and id tables */
-enum hermes_pci_versions {
-	CH_Agere_Systems_Mini_PCI_V1 = 0,
-};
-
 static struct pci_device_id wl_pci_tbl[] __devinitdata = {
-	{ PCI_VENDOR_ID_WL_LKM, PCI_DEVICE_ID_WL_LKM_0,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, CH_Agere_Systems_Mini_PCI_V1 },
-	{ PCI_VENDOR_ID_WL_LKM, PCI_DEVICE_ID_WL_LKM_1,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, CH_Agere_Systems_Mini_PCI_V1 },
-	{ PCI_VENDOR_ID_WL_LKM, PCI_DEVICE_ID_WL_LKM_2,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, CH_Agere_Systems_Mini_PCI_V1 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_WL_LKM, PCI_DEVICE_ID_WL_LKM_0), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_WL_LKM, PCI_DEVICE_ID_WL_LKM_1), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_WL_LKM, PCI_DEVICE_ID_WL_LKM_2), },
 
 	{ }			/* Terminating entry */
 };
-- 
1.7.3.4

