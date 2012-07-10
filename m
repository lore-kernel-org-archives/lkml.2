Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2GJPyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:54:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43454 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2GJPys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:54:48 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH 01/14] PCI: add pcie_flags into struct pci_dev to cache PCIe capabilities register
Date: Tue, 10 Jul 2012 23:54:02 +0800
Message-Id: <1341935655-5381-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
References: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>

From: Yijing Wang <wangyijing@huawei.com>

Since PCI Express Capabilities Register is read only, cache its value
into struct pci_dev to avoid repeatedly calling pci_read_config_*().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/probe.c |    1 +
 include/linux/pci.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6c143b4..65e82e3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -929,6 +929,7 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	pdev->is_pcie = 1;
 	pdev->pcie_cap = pos;
 	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
+	pdev->pcie_flags = reg16;
 	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
 	pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
 	pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5faa831..f4a7ad6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -258,6 +258,7 @@ struct pci_dev {
 	u8		pcie_mpss:3;	/* PCI-E Max Payload Size Supported */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */
+	u16		pcie_flags;	/* cached PCI-E Capabilities Register */
 
 	struct pci_driver *driver;	/* which driver has allocated this device */
 	u64		dma_mask;	/* Mask of the bits of bus address this
-- 
1.7.9.5

