Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab1KBUHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab1KBUHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:07:18 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] pci: Fix PRI and PASID consistency
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        joerg.roedel@amd.com, bhelgaas@google.com
Date: Wed, 02 Nov 2011 14:07:15 -0600
Message-ID: <20111102200647.8266.62606.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are extended capabilities, rename and move to proper
group for consistency.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/ats.c        |   20 ++++++++++----------
 include/linux/pci_regs.h |    4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index 7ec56fb..831e192 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -174,7 +174,7 @@ int pci_enable_pri(struct pci_dev *pdev, u32 reqs)
 	u32 max_requests;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return -EINVAL;
 
@@ -205,7 +205,7 @@ void pci_disable_pri(struct pci_dev *pdev)
 	u16 control;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return;
 
@@ -226,7 +226,7 @@ bool pci_pri_enabled(struct pci_dev *pdev)
 	u16 control;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return false;
 
@@ -248,7 +248,7 @@ int pci_reset_pri(struct pci_dev *pdev)
 	u16 control;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return -EINVAL;
 
@@ -281,7 +281,7 @@ bool pci_pri_stopped(struct pci_dev *pdev)
 	u16 control, status;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return true;
 
@@ -310,7 +310,7 @@ int pci_pri_status(struct pci_dev *pdev)
 	u16 status, control;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return -EINVAL;
 
@@ -341,7 +341,7 @@ int pci_enable_pasid(struct pci_dev *pdev, int features)
 	u16 control, supported;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PASID);
 	if (!pos)
 		return -EINVAL;
 
@@ -375,7 +375,7 @@ void pci_disable_pasid(struct pci_dev *pdev)
 	u16 control = 0;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PASID);
 	if (!pos)
 		return;
 
@@ -399,7 +399,7 @@ int pci_pasid_features(struct pci_dev *pdev)
 	u16 supported;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PASID);
 	if (!pos)
 		return -EINVAL;
 
@@ -425,7 +425,7 @@ int pci_max_pasids(struct pci_dev *pdev)
 	u16 supported;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PASID);
 	if (!pos)
 		return -EINVAL;
 
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index b5d9657..090d3a9 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -537,7 +537,9 @@
 #define PCI_EXT_CAP_ID_ARI	14
 #define PCI_EXT_CAP_ID_ATS	15
 #define PCI_EXT_CAP_ID_SRIOV	16
+#define PCI_EXT_CAP_ID_PRI	19
 #define PCI_EXT_CAP_ID_LTR	24
+#define PCI_EXT_CAP_ID_PASID	27
 
 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
@@ -664,7 +666,6 @@
 #define  PCI_ATS_MIN_STU	12	/* shift of minimum STU block */
 
 /* Page Request Interface */
-#define PCI_PRI_CAP		0x13    /* PRI capability ID */
 #define PCI_PRI_CONTROL_OFF	0x04	/* Offset of control register */
 #define PCI_PRI_STATUS_OFF	0x06	/* Offset of status register */
 #define PCI_PRI_ENABLE		0x0001	/* Enable mask */
@@ -676,7 +677,6 @@
 #define PCI_PRI_ALLOC_REQ_OFF	0x0c	/* Cap offset for max reqs allowed */
 
 /* PASID capability */
-#define PCI_PASID_CAP		0x1b    /* PASID capability ID */
 #define PCI_PASID_CAP_OFF	0x04    /* PASID feature register */
 #define PCI_PASID_CONTROL_OFF   0x06    /* PASID control register */
 #define PCI_PASID_ENABLE	0x01	/* Enable/Supported bit */

