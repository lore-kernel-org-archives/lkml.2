Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829Ab0GWPbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:31:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:59501 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760647Ab0GWP3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:29:40 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18v4SRHKV4vSdo3VaBCVbuSqigt3+UYyW7Z7Bz1t7
	hu8swtcps+srSl
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>,
        Harald Welte <laforge@gnumonks.org>
Subject: [PATCH 05/11] viafb: fix PCI table
Date: Fri, 23 Jul 2010 15:39:20 +0000
Message-Id: <1279899566-4359-6-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: fix PCI table

This patch fixes an oddity in the device table where the P4M890 ID was
assigned with the enumeration value of CN700 which itself was missing.
This is a regression introduced by
	"viafb: make viafb a first-class citizen using pci_driver"

While at it reorder the table to reflect the order of the  enumeration
values.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Harald Welte <laforge@gnumonks.org>
---
 drivers/video/via/via-core.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index e8cfe83..4afa3c5 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -613,22 +613,24 @@ static void __devexit via_pci_remove(struct pci_dev *pdev)
 static struct pci_device_id via_pci_table[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CLE266_DID),
 	  .driver_data = UNICHROME_CLE266 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_PM800_DID),
-	  .driver_data = UNICHROME_PM800 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K400_DID),
 	  .driver_data = UNICHROME_K400 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K800_DID),
 	  .driver_data = UNICHROME_K800 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M890_DID),
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_PM800_DID),
+	  .driver_data = UNICHROME_PM800 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CN700_DID),
 	  .driver_data = UNICHROME_CN700 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K8M890_DID),
-	  .driver_data = UNICHROME_K8M890 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CX700_DID),
 	  .driver_data = UNICHROME_CX700 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M900_DID),
-	  .driver_data = UNICHROME_P4M900 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CN750_DID),
 	  .driver_data = UNICHROME_CN750 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K8M890_DID),
+	  .driver_data = UNICHROME_K8M890 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M890_DID),
+	  .driver_data = UNICHROME_P4M890 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M900_DID),
+	  .driver_data = UNICHROME_P4M900 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX800_DID),
 	  .driver_data = UNICHROME_VX800 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX855_DID),
-- 
1.6.3.2

