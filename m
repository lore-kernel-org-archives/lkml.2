Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab2GXQgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:36:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42042 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2GXQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:36:26 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 19/32] PCI/mlx4: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:31 +0800
Message-Id: <1343147504-25891-20-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify mlx4 driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/reset.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/reset.c b/drivers/net/ethernet/mellanox/mlx4/reset.c
index 11e7c1c..6895214 100644
--- a/drivers/net/ethernet/mellanox/mlx4/reset.c
+++ b/drivers/net/ethernet/mellanox/mlx4/reset.c
@@ -141,16 +141,16 @@ int mlx4_reset(struct mlx4_dev *dev)
 	/* Now restore the PCI headers */
 	if (pcie_cap) {
 		devctl = hca_header[(pcie_cap + PCI_EXP_DEVCTL) / 4];
-		if (pci_write_config_word(dev->pdev, pcie_cap + PCI_EXP_DEVCTL,
-					   devctl)) {
+		if (pci_pcie_capability_write_word(dev->pdev, PCI_EXP_DEVCTL,
+						   devctl)) {
 			err = -ENODEV;
 			mlx4_err(dev, "Couldn't restore HCA PCI Express "
 				 "Device Control register, aborting.\n");
 			goto out;
 		}
 		linkctl = hca_header[(pcie_cap + PCI_EXP_LNKCTL) / 4];
-		if (pci_write_config_word(dev->pdev, pcie_cap + PCI_EXP_LNKCTL,
-					   linkctl)) {
+		if (pci_pcie_capability_write_word(dev->pdev, PCI_EXP_LNKCTL,
+						   linkctl)) {
 			err = -ENODEV;
 			mlx4_err(dev, "Couldn't restore HCA PCI Express "
 				 "Link control register, aborting.\n");
-- 
1.7.9.5

