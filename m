Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2HAP6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:58:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50358 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2HAP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:58:11 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Jon Mason <jdmason@kudzu.us>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 18/32] PCI/vxge: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:23 +0800
Message-Id: <1343836477-7287-19-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify vxge driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index 98e2c10..f83f0a4 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -757,7 +757,7 @@ __vxge_hw_verify_pci_e_info(struct __vxge_hw_device *hldev)
 	u16 lnk;
 
 	/* Get the negotiated link width and speed from PCI config space */
-	pci_read_config_word(dev, dev->pcie_cap + PCI_EXP_LNKSTA, &lnk);
+	pci_pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnk);
 
 	if ((lnk & PCI_EXP_LNKSTA_CLS) != 1)
 		return VXGE_HW_ERR_INVALID_PCI_INFO;
@@ -1982,7 +1982,7 @@ u16 vxge_hw_device_link_width_get(struct __vxge_hw_device *hldev)
 	struct pci_dev *dev = hldev->pdev;
 	u16 lnk;
 
-	pci_read_config_word(dev, dev->pcie_cap + PCI_EXP_LNKSTA, &lnk);
+	pci_pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnk);
 	return (lnk & VXGE_HW_PCI_EXP_LNKCAP_LNK_WIDTH) >> 4;
 }
 
-- 
1.7.9.5

