Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2BXHrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:47:35 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:38697 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab2BXHrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:47:33 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/11] PCI: Use class for quirk for ti816x class fixup
Date: Thu, 23 Feb 2012 23:46:58 -0800
Message-Id: <1330069619-14446-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
References: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F474093.0051,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 91733a2..e198589 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2822,12 +2822,11 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3c28, vtd_mask_spec_errors);
 static void __devinit fixup_ti816x_class(struct pci_dev* dev)
 {
 	/* TI 816x devices do not have class code set when in PCIe boot mode */
-	if (dev->class == PCI_CLASS_NOT_DEFINED) {
-		dev_info(&dev->dev, "Setting PCI class for 816x PCIe device\n");
-		dev->class = PCI_CLASS_MULTIMEDIA_VIDEO;
-	}
+	dev_info(&dev->dev, "Setting PCI class for 816x PCIe device\n");
+	dev->class = PCI_CLASS_MULTIMEDIA_VIDEO;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_TI, 0xb800, fixup_ti816x_class);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_TI, 0xb800,
+				 PCI_CLASS_NOT_DEFINED, 0, fixup_ti816x_class);
 
 /* Some PCIe devices do not work reliably with the claimed maximum
  * payload size supported.
-- 
1.7.7

