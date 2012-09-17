Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab2IQIzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:55:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:12419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab2IQIyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:54:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="222936846"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>
Subject: [RFC 3/3] PCI/PM: Disable PME poll for PCIe devices
Date: Mon, 17 Sep 2012 16:54:36 +0800
Message-Id: <1347872076-5260-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347872076-5260-1-git-send-email-ying.huang@intel.com>
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PME poll is not necessary for PCIe devices, because PCIe devices use
in-band PME message and IRQ on PCIe port to report PME.

PME poll is useful for PCI devices.  Because for PCI devices, PME is
reported via a side-band PME# line and some platform logic, and the
platform logic is often missing on many systems.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/pci/pcie/pme.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/pcie/pme.c
+++ b/drivers/pci/pcie/pme.c
@@ -313,6 +313,7 @@ static int pcie_pme_set_native(struct pc
 
 	device_set_run_wake(&dev->dev, true);
 	dev->pme_interrupt = true;
+	dev->pme_poll = false;
 	return 0;
 }
 
