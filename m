Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375Ab2GKWId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:08:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21691 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030280Ab2GKWIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:08:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI, pciehp: Remove not used code
Date: Wed, 11 Jul 2012 15:08:16 -0700
Message-Id: <1342044496-2604-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/hotplug/pciehp.h     |    4 -
 drivers/pci/hotplug/pciehp_hpc.c |  101 ---------------------------------------
 2 files changed, 105 deletions(-)

Index: linux-2.6/drivers/pci/hotplug/pciehp.h
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp.h
+++ linux-2.6/drivers/pci/hotplug/pciehp.h
@@ -149,10 +149,6 @@ int pciehp_get_attention_status(struct s
 int pciehp_set_attention_status(struct slot *slot, u8 status);
 int pciehp_get_latch_status(struct slot *slot, u8 *status);
 int pciehp_get_adapter_status(struct slot *slot, u8 *status);
-int pciehp_get_max_link_speed(struct slot *slot, enum pci_bus_speed *speed);
-int pciehp_get_max_link_width(struct slot *slot, enum pcie_link_width *val);
-int pciehp_get_cur_link_speed(struct slot *slot, enum pci_bus_speed *speed);
-int pciehp_get_cur_link_width(struct slot *slot, enum pcie_link_width *val);
 int pciehp_query_power_fault(struct slot *slot);
 void pciehp_green_led_on(struct slot *slot);
 void pciehp_green_led_off(struct slot *slot);
Index: linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_hpc.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
@@ -705,107 +705,6 @@ static irqreturn_t pcie_isr(int irq, voi
 	return IRQ_HANDLED;
 }
 
-int pciehp_get_max_lnk_width(struct slot *slot,
-				 enum pcie_link_width *value)
-{
-	struct controller *ctrl = slot->ctrl;
-	enum pcie_link_width lnk_wdth;
-	u32	lnk_cap;
-	int retval = 0;
-
-	retval = pciehp_readl(ctrl, PCI_EXP_LNKCAP, &lnk_cap);
-	if (retval) {
-		ctrl_err(ctrl, "%s: Cannot read LNKCAP register\n", __func__);
-		return retval;
-	}
-
-	switch ((lnk_cap & PCI_EXP_LNKSTA_NLW) >> 4){
-	case 0:
-		lnk_wdth = PCIE_LNK_WIDTH_RESRV;
-		break;
-	case 1:
-		lnk_wdth = PCIE_LNK_X1;
-		break;
-	case 2:
-		lnk_wdth = PCIE_LNK_X2;
-		break;
-	case 4:
-		lnk_wdth = PCIE_LNK_X4;
-		break;
-	case 8:
-		lnk_wdth = PCIE_LNK_X8;
-		break;
-	case 12:
-		lnk_wdth = PCIE_LNK_X12;
-		break;
-	case 16:
-		lnk_wdth = PCIE_LNK_X16;
-		break;
-	case 32:
-		lnk_wdth = PCIE_LNK_X32;
-		break;
-	default:
-		lnk_wdth = PCIE_LNK_WIDTH_UNKNOWN;
-		break;
-	}
-
-	*value = lnk_wdth;
-	ctrl_dbg(ctrl, "Max link width = %d\n", lnk_wdth);
-
-	return retval;
-}
-
-int pciehp_get_cur_lnk_width(struct slot *slot,
-				 enum pcie_link_width *value)
-{
-	struct controller *ctrl = slot->ctrl;
-	enum pcie_link_width lnk_wdth = PCIE_LNK_WIDTH_UNKNOWN;
-	int retval = 0;
-	u16 lnk_status;
-
-	retval = pciehp_readw(ctrl, PCI_EXP_LNKSTA, &lnk_status);
-	if (retval) {
-		ctrl_err(ctrl, "%s: Cannot read LNKSTATUS register\n",
-			 __func__);
-		return retval;
-	}
-
-	switch ((lnk_status & PCI_EXP_LNKSTA_NLW) >> 4){
-	case 0:
-		lnk_wdth = PCIE_LNK_WIDTH_RESRV;
-		break;
-	case 1:
-		lnk_wdth = PCIE_LNK_X1;
-		break;
-	case 2:
-		lnk_wdth = PCIE_LNK_X2;
-		break;
-	case 4:
-		lnk_wdth = PCIE_LNK_X4;
-		break;
-	case 8:
-		lnk_wdth = PCIE_LNK_X8;
-		break;
-	case 12:
-		lnk_wdth = PCIE_LNK_X12;
-		break;
-	case 16:
-		lnk_wdth = PCIE_LNK_X16;
-		break;
-	case 32:
-		lnk_wdth = PCIE_LNK_X32;
-		break;
-	default:
-		lnk_wdth = PCIE_LNK_WIDTH_UNKNOWN;
-		break;
-	}
-
-	*value = lnk_wdth;
-	ctrl_dbg(ctrl, "Current link width = %d\n", lnk_wdth);
-
-	return retval;
-}
-
 int pcie_enable_notification(struct controller *ctrl)
 {
 	u16 cmd, mask;
