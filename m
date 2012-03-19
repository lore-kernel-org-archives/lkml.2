Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161992Ab2CSFtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:49:45 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25455 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161952Ab2CSFtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:42 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 09/26] PCI, pciehp: Use for_each_pci_dev_resource helper
Date: Sun, 18 Mar 2012 22:48:32 -0700
Message-Id: <1332136129-14010-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F66C8F3.00AB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index a960fae..ef10429 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -899,6 +899,7 @@ static inline void dbg_ctrl(struct controller *ctrl)
 	int i;
 	u16 reg16;
 	struct pci_dev *pdev = ctrl->pcie->port;
+	struct resource *res;
 
 	if (!pciehp_debug)
 		return;
@@ -914,11 +915,11 @@ static inline void dbg_ctrl(struct controller *ctrl)
 		  pdev->subsystem_vendor);
 	ctrl_info(ctrl, "  PCIe Cap offset      : 0x%02x\n",
 		  pci_pcie_cap(pdev));
-	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+	for_each_pci_dev_all_resource(pdev, res, i) {
 		if (!pci_resource_len(pdev, i))
 			continue;
 		ctrl_info(ctrl, "  PCI resource [%d]     : %pR\n",
-			  i, &pdev->resource[i]);
+			  i, res);
 	}
 	ctrl_info(ctrl, "Slot Capabilities      : 0x%08x\n", ctrl->slot_cap);
 	ctrl_info(ctrl, "  Physical Slot Number : %d\n", PSN(ctrl));
-- 
1.7.7

