Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab2GXQhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:37:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2GXQhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:37:04 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 23/32] PCI/atl1c: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:35 +0800
Message-Id: <1343147504-25891-24-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify atl1c driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 9cc1570..1b7e1ff 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -149,7 +149,7 @@ static void atl1c_reset_pcie(struct atl1c_hw *hw, u32 flag)
 	data &= ~(PCI_ERR_UNC_DLP | PCI_ERR_UNC_FCP);
 	pci_write_config_dword(pdev, pos + PCI_ERR_UNCOR_SEVER, data);
 	/* clear error status */
-	pci_write_config_word(pdev, pci_pcie_cap(pdev) + PCI_EXP_DEVSTA,
+	pci_pcie_capability_write_word(pdev, PCI_EXP_DEVSTA,
 			PCI_EXP_DEVSTA_NFED |
 			PCI_EXP_DEVSTA_FED |
 			PCI_EXP_DEVSTA_CED |
-- 
1.7.9.5

