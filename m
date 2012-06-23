Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab2FWCZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 22:25:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:11162 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab2FWCYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 22:24:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169147109"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zheng Yan <zheng.z.yan@intel.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Jesse Barnes <jesse.barnes@intel.com>
Subject: [PATCH -v7 3/4] PCI, do not call pci_set_power_state with PCI_D3cold
Date: Sat, 23 Jun 2012 10:23:50 +0800
Message-Id: <1340418231-10134-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340418231-10134-1-git-send-email-ying.huang@intel.com>
References: <1340418231-10134-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI subsystem has not been ready for D3cold support yet.  So
PCI_D3cold should not be used as parameter for pci_set_power_state.
This patch is needed for upcoming PCI_D3cold support.

This patch has no functionality change, because pci_set_power_state
will bound the parameter to PCI_D3hot too.

Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Jesse Barnes <jesse.barnes@intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/pci/mrst.c       |    2 +-
 drivers/misc/cb710/core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -264,7 +264,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 
 static void __devinit mrst_power_off_unused_dev(struct pci_dev *dev)
 {
-	pci_set_power_state(dev, PCI_D3cold);
+	pci_set_power_state(dev, PCI_D3hot);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0801, mrst_power_off_unused_dev);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0809, mrst_power_off_unused_dev);
--- a/drivers/misc/cb710/core.c
+++ b/drivers/misc/cb710/core.c
@@ -180,7 +180,7 @@ static int cb710_suspend(struct pci_dev
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	if (state.event & PM_EVENT_SLEEP)
-		pci_set_power_state(pdev, PCI_D3cold);
+		pci_set_power_state(pdev, PCI_D3hot);
 	return 0;
 }
 
