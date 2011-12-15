Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab1LOKXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:23:40 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:8933
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755414Ab1LOKXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:23:37 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LW8Q77-01-29S-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] iommu/amd: Adapt IOMMU driver to PCI register name changes
Date: Thu, 15 Dec 2011 11:23:20 +0100
Message-ID: <1323944602-26155-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323944602-26155-1-git-send-email-joerg.roedel@amd.com>
References: <1323944602-26155-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbolic register names for PCI and PASID changed in
PCI code. This patch adapts the AMD IOMMU driver to these
changes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a7cbcd4..d5074f4 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -176,8 +176,8 @@ static bool pci_iommuv2_capable(struct pci_dev *pdev)
 {
 	static const int caps[] = {
 		PCI_EXT_CAP_ID_ATS,
-		PCI_PRI_CAP,
-		PCI_PASID_CAP,
+		PCI_EXT_CAP_ID_PRI,
+		PCI_EXT_CAP_ID_PASID,
 	};
 	int i, pos;
 
@@ -1978,13 +1978,13 @@ static int pri_reset_while_enabled(struct pci_dev *pdev)
 	u16 control;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return -EINVAL;
 
-	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
-	control |= PCI_PRI_RESET;
-	pci_write_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, control);
+	pci_read_config_word(pdev, pos + PCI_PRI_CTRL, &control);
+	control |= PCI_PRI_CTRL_RESET;
+	pci_write_config_word(pdev, pos + PCI_PRI_CTRL, control);
 
 	return 0;
 }
@@ -2042,11 +2042,11 @@ bool pci_pri_tlp_required(struct pci_dev *pdev)
 	u16 control;
 	int pos;
 
-	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return false;
 
-	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
+	pci_read_config_word(pdev, pos + PCI_PRI_CTRL, &control);
 
 	return (control & PCI_PRI_TLP_OFF) ? true : false;
 }
-- 
1.7.5.4


