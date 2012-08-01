Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2HAP7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:59:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59287 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab2HAP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:59:31 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 26/32] PCI/mthca: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:31 +0800
Message-Id: <1343836477-7287-27-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
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

