Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab2LMOPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:15:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45185 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486Ab2LMOPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Bottomley <JBottomley@Parallels.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 238/241] [SCSI] hpsa: gen8plus Smart Array IDs
Date: Thu, 13 Dec 2012 12:00:03 -0200
Message-Id: <1355407206-17100-239-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Miller <mike.miller@hp.com>

commit fe0c9610bb68dd0aad1017456f5e3c31264d70c2 upstream.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/scsi/hpsa.c     |   32 +++++++++++++++++++++++++-------
 include/linux/pci_ids.h |    1 +
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f9823f2..cb00d70 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -99,6 +99,15 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1920},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1924},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1925},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x334d},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -118,13 +127,22 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324a103C, "Smart Array P712m", &SA5_access},
 	{0x324b103C, "Smart Array P711m", &SA5_access},
-	{0x3350103C, "Smart Array", &SA5_access},
-	{0x3351103C, "Smart Array", &SA5_access},
-	{0x3352103C, "Smart Array", &SA5_access},
-	{0x3353103C, "Smart Array", &SA5_access},
-	{0x3354103C, "Smart Array", &SA5_access},
-	{0x3355103C, "Smart Array", &SA5_access},
-	{0x3356103C, "Smart Array", &SA5_access},
+	{0x3350103C, "Smart Array P222", &SA5_access},
+	{0x3351103C, "Smart Array P420", &SA5_access},
+	{0x3352103C, "Smart Array P421", &SA5_access},
+	{0x3353103C, "Smart Array P822", &SA5_access},
+	{0x3354103C, "Smart Array P420i", &SA5_access},
+	{0x3355103C, "Smart Array P220i", &SA5_access},
+	{0x3356103C, "Smart Array P721m", &SA5_access},
+	{0x1920103C, "Smart Array", &SA5_access},
+	{0x1921103C, "Smart Array", &SA5_access},
+	{0x1922103C, "Smart Array", &SA5_access},
+	{0x1923103C, "Smart Array", &SA5_access},
+	{0x1924103C, "Smart Array", &SA5_access},
+	{0x1925103C, "Smart Array", &SA5_access},
+	{0x1926103C, "Smart Array", &SA5_access},
+	{0x1928103C, "Smart Array", &SA5_access},
+	{0x334d103C, "Smart Array P822se", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c71eea2..a56c194 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -752,6 +752,7 @@
 #define PCI_DEVICE_ID_HP_CISSD		0x3238
 #define PCI_DEVICE_ID_HP_CISSE		0x323a
 #define PCI_DEVICE_ID_HP_CISSF		0x323b
+#define PCI_DEVICE_ID_HP_CISSH		0x323c
 #define PCI_DEVICE_ID_HP_ZX2_IOC	0x4031
 
 #define PCI_VENDOR_ID_PCTECH		0x1042
-- 
1.7.9.5

