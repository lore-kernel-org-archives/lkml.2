Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2GXQnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:43:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64865 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab2GXQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:43:39 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 26/32] PCI/mthca: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:41:11 +0800
Message-Id: <1343148077-25941-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343148077-25941-1-git-send-email-jiang.liu@huawei.com>
References: <1343148077-25941-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify mthca driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/infiniband/hw/mthca/mthca_reset.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_reset.c b/drivers/infiniband/hw/mthca/mthca_reset.c
index 4fa3534..7b1a3bc 100644
--- a/drivers/infiniband/hw/mthca/mthca_reset.c
+++ b/drivers/infiniband/hw/mthca/mthca_reset.c
@@ -241,16 +241,16 @@ good:
 
 	if (hca_pcie_cap) {
 		devctl = hca_header[(hca_pcie_cap + PCI_EXP_DEVCTL) / 4];
-		if (pci_write_config_word(mdev->pdev, hca_pcie_cap + PCI_EXP_DEVCTL,
-					   devctl)) {
+		if (pci_pcie_capability_write_word(mdev->pdev, PCI_EXP_DEVCTL,
+						   devctl)) {
 			err = -ENODEV;
 			mthca_err(mdev, "Couldn't restore HCA PCI Express "
 				  "Device Control register, aborting.\n");
 			goto out;
 		}
 		linkctl = hca_header[(hca_pcie_cap + PCI_EXP_LNKCTL) / 4];
-		if (pci_write_config_word(mdev->pdev, hca_pcie_cap + PCI_EXP_LNKCTL,
-					   linkctl)) {
+		if (pci_pcie_capability_write_word(mdev->pdev, PCI_EXP_LNKCTL,
+						   linkctl)) {
 			err = -ENODEV;
 			mthca_err(mdev, "Couldn't restore HCA PCI Express "
 				  "Link control register, aborting.\n");
-- 
1.7.9.5

