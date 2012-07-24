Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2GXQoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:44:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33470 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2GXQoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:44:09 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 29/32] PCI/radeon: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:41:14 +0800
Message-Id: <1343148077-25941-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343148077-25941-1-git-send-email-jiang.liu@huawei.com>
References: <1343148077-25941-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify radeon driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/gpu/drm/radeon/evergreen.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 01550d0..d7a1f95 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -77,13 +77,12 @@ void evergreen_tiling_fields(unsigned tiling_flags, unsigned *bankw,
 void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
 {
 	u16 ctl, v;
-	int cap, err;
+	int err;
 
-	cap = pci_pcie_cap(rdev->pdev);
-	if (!cap)
+	if (!pci_is_pcie(rdev->pdev))
 		return;
 
-	err = pci_read_config_word(rdev->pdev, cap + PCI_EXP_DEVCTL, &ctl);
+	err = pci_pcie_capability_read_word(rdev->pdev, PCI_EXP_DEVCTL, &ctl);
 	if (err)
 		return;
 
@@ -95,7 +94,7 @@ void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
 	if ((v == 0) || (v == 6) || (v == 7)) {
 		ctl &= ~PCI_EXP_DEVCTL_READRQ;
 		ctl |= (2 << 12);
-		pci_write_config_word(rdev->pdev, cap + PCI_EXP_DEVCTL, ctl);
+		pci_pcie_capability_write_word(rdev->pdev, PCI_EXP_DEVCTL, ctl);
 	}
 }
 
-- 
1.7.9.5

