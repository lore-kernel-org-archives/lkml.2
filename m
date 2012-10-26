Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2JZFIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 01:08:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:18107 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab2JZFIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 01:08:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,652,1344236400"; 
   d="scan'208";a="209530386"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: PCI/PM: Add comments for PME poll support for PCIe
Date: Fri, 26 Oct 2012 13:07:51 +0800
Message-Id: <1351228071-15161-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are comments on why PME poll support is necessary for PCI
devices, but not for PCIe devices.  That may lead to misunderstanding
that PME poll is only necessary for PCI devices.  So add comments
related to PCIe PME poll to make it more clear.

The content of comments comes from the changelog of commit:

379021d5c0899fcf9410cae4ca7a59a5a94ca769

Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/pci/pci.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1578,15 +1578,25 @@ void pci_pme_active(struct pci_dev *dev,
 
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
 
-	/* PCI (as opposed to PCIe) PME requires that the device have
-	   its PME# line hooked up correctly. Not all hardware vendors
-	   do this, so the PME never gets delivered and the device
-	   remains asleep. The easiest way around this is to
-	   periodically walk the list of suspended devices and check
-	   whether any have their PME flag set. The assumption is that
-	   we'll wake up often enough anyway that this won't be a huge
-	   hit, and the power savings from the devices will still be a
-	   win. */
+	/*
+	 * PCI (as opposed to PCIe) PME requires that the device have
+	 * its PME# line hooked up correctly. Not all hardware vendors
+	 * do this, so the PME never gets delivered and the device
+	 * remains asleep. The easiest way around this is to
+	 * periodically walk the list of suspended devices and check
+	 * whether any have their PME flag set. The assumption is that
+	 * we'll wake up often enough anyway that this won't be a huge
+	 * hit, and the power savings from the devices will still be a
+	 * win.
+	 *
+	 * Although PCIe uses in-band PME message instead of PME# line
+	 * to report PME, PME does not work for some PCIe devices in
+	 * reality.  For example, there are devices that set their PME
+	 * status bits, but don't really bother to send a PME message;
+	 * there are PCI Express Root Ports that don't bother to
+	 * trigger interrupts when they receive PME messages from the
+	 * devices below.  So PME poll is used for PCIe devices too.
+	 */
 
 	if (dev->pme_poll) {
 		struct pci_pme_device *pme_dev;
