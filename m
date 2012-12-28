Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2L1TiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:38:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55402 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932147Ab2L1TSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:55 -0500
Message-Id: <20121228190347.783360433@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russell Webb <russell.webb@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 084/173] xhci: Add Lynx Point LP to list of Intel switchable hosts
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell Webb <russell.webb@linux.intel.com>

commit bb1e5dd7113d2fd178d3af9aca8f480ae0468edf upstream.

Like Lynx Point, Lynx Point LP is also switchable.  See
1c12443ab8eba71a658fae4572147e56d1f84f66 for more details.

This patch should be backported to stable kernels as old as 3.0,
that contain commit 69e848c2090aebba5698a1620604c7dccb448684
"Intel xhci: Support EHCI/xHCI port switching."

Signed-off-by: Russell Webb <russell.webb@linux.intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-pci.c   |    3 ++-
 drivers/usb/host/pci-quirks.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 3fb76ca..dabb204 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -330,7 +330,8 @@ static bool usb_is_intel_switchable_ehci(struct pci_dev *pdev)
 		pdev->vendor == PCI_VENDOR_ID_INTEL &&
 		(pdev->device == 0x1E26 ||
 		 pdev->device == 0x8C2D ||
-		 pdev->device == 0x8C26);
+		 pdev->device == 0x8C26 ||
+		 pdev->device == 0x9C26);
 }
 
 static void ehci_enable_xhci_companion(void)
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 15cfb06..a3b6d71 100644
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


