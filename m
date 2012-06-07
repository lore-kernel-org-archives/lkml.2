Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646Ab2FGERO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:17:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab2FGERJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:17:09 -0400
Message-Id: <20120607040340.209305939@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:02 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 26/82] iommu/amd: Check for the right TLP prefix bit
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit a3b93121430c7b46c2895a7744261be107ccdf7f upstream.

Unfortunatly the PRI spec changed and moved the
TLP-prefix-required bit to a different location. This patch
makes the necessary change in the AMD IOMMU driver.
Regressions are not expected because all hardware
implementing the PRI capability sets this bit to zero
anyway.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2035,20 +2035,20 @@ out_err:
 }
 
 /* FIXME: Move this to PCI code */
-#define PCI_PRI_TLP_OFF		(1 << 2)
+#define PCI_PRI_TLP_OFF		(1 << 15)
 
 bool pci_pri_tlp_required(struct pci_dev *pdev)
 {
-	u16 control;
+	u16 status;
 	int pos;
 
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return false;
 
-	pci_read_config_word(pdev, pos + PCI_PRI_CTRL, &control);
+	pci_read_config_word(pdev, pos + PCI_PRI_STATUS, &status);
 
-	return (control & PCI_PRI_TLP_OFF) ? true : false;
+	return (status & PCI_PRI_TLP_OFF) ? true : false;
 }
 
 /*


