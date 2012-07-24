Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab2GXQdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:33:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59998 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2GXQdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:33:46 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 03/32] PCI: remove unused field pcie_type from struct pci_dev
Date: Wed, 25 Jul 2012 00:31:15 +0800
Message-Id: <1343147504-25891-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>

From: Yijing Wang <wangyijing@huawei.com>

With introduction of pci_pcie_type(), pci_dev->pcie_type field becomes
redundant, so remove it.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/probe.c |    1 -
 include/linux/pci.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 00c7bab..8bcc985 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -930,7 +930,6 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	pdev->pcie_cap = pos;
 	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
 	pdev->pcie_flags_reg = reg16;
-	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
 	pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
 	pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 95662b2..9807da5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -254,7 +254,6 @@ struct pci_dev {
 	u8		revision;	/* PCI revision, low byte of class word */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
 	u8		pcie_cap;	/* PCI-E capability offset */
-	u8		pcie_type:4;	/* PCI-E device/port type */
 	u8		pcie_mpss:3;	/* PCI-E Max Payload Size Supported */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */
-- 
1.7.9.5

