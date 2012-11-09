Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2KLRiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:38:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:36420 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab2KLRiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:38:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="scan'208";a="218383201"
Date: Fri, 9 Nov 2012 13:58:49 -0800
From: Russell Webb <russell.webb@linux.jf.intel.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.jf.intel.com>
Subject: [PATCH] xhci: Add Lynx Point LP to list of Intel switchable hosts
Message-ID: <20121109215849.GA22445@jayhawker.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like Lynx Point, Lynx Point LP is also switchable.  See
1c12443ab8eba71a658fae4572147e56d1f84f66 for more details.

This patch should be backported to stable kernels as old as 3.0,
that contain commit 69e848c2090aebba5698a1620604c7dccb448684
"Intel xhci: Support EHCI/xHCI port switching."

Signed-off-by: Russell Webb <russell.webb@linux.intel.com>
---
 drivers/usb/host/ehci-pci.c   | 3 ++-
 drivers/usb/host/pci-quirks.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 2cb7d37..f42b68e 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -334,7 +334,8 @@ static bool usb_is_intel_switchable_ehci(struct pci_dev *pdev)
 		pdev->vendor == PCI_VENDOR_ID_INTEL &&
 		(pdev->device == 0x1E26 ||
 		 pdev->device == 0x8C2D ||
-		 pdev->device == 0x8C26);
+		 pdev->device == 0x8C26 ||
+		 pdev->device == 0x9C26);
 }
 
 static void ehci_enable_xhci_companion(void)
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 39f9e4a..eb5563a 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -723,6 +723,7 @@ static int handshake(void __iomem *ptr, u32 mask, u32 done,
 }
 
 #define PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI	0x8C31
+#define PCI_DEVICE_ID_INTEL_LYNX_POINT_LP_XHCI	0x9C31
 
 bool usb_is_intel_ppt_switchable_xhci(struct pci_dev *pdev)
 {
@@ -736,7 +737,8 @@ bool usb_is_intel_lpt_switchable_xhci(struct pci_dev *pdev)
 {
 	return pdev->class == PCI_CLASS_SERIAL_USB_XHCI &&
 		pdev->vendor == PCI_VENDOR_ID_INTEL &&
-		pdev->device == PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI;
+		(pdev->device == PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI ||
+		 pdev->device == PCI_DEVICE_ID_INTEL_LYNX_POINT_LP_XHCI);
 }
 
 bool usb_is_intel_switchable_xhci(struct pci_dev *pdev)
-- 
1.7.11.7

