Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab3AIVwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:52:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:41427 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978Ab3AIUhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Russell Webb <russell.webb@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 26/47] xhci: Add Lynx Point LP to list of Intel switchable hosts
Date: Wed,  9 Jan 2013 12:35:21 -0800
Message-Id: <20130109201732.523939482@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-pci.c   |    3 ++-
 drivers/usb/host/pci-quirks.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -359,7 +359,8 @@ static bool usb_is_intel_switchable_ehci
 		pdev->vendor == PCI_VENDOR_ID_INTEL &&
 		(pdev->device == 0x1E26 ||
 		 pdev->device == 0x8C2D ||
-		 pdev->device == 0x8C26);
+		 pdev->device == 0x8C26 ||
+		 pdev->device == 0x9C26);
 }
 
 static void ehci_enable_xhci_companion(void)
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -721,6 +721,7 @@ static int handshake(void __iomem *ptr,
 }
 
 #define PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI	0x8C31
+#define PCI_DEVICE_ID_INTEL_LYNX_POINT_LP_XHCI	0x9C31
 
 bool usb_is_intel_ppt_switchable_xhci(struct pci_dev *pdev)
 {
@@ -734,7 +735,8 @@ bool usb_is_intel_lpt_switchable_xhci(st
 {
 	return pdev->class == PCI_CLASS_SERIAL_USB_XHCI &&
 		pdev->vendor == PCI_VENDOR_ID_INTEL &&
-		pdev->device == PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI;
+		(pdev->device == PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI ||
+		 pdev->device == PCI_DEVICE_ID_INTEL_LYNX_POINT_LP_XHCI);
 }
 
 bool usb_is_intel_switchable_xhci(struct pci_dev *pdev)


