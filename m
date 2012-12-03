Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2LCOpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:45:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43872 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427Ab2LCOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:49 -0500
Message-Id: <20121203143153.558565419@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:29 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 43/89] xhci: Remove warnings about MSI and MSI-X capabilities.
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 3b9783b277e66731891ab42eeaacebbdcdd6e629 upstream.

xHCI host controllers may not be capable of MSI, but they should be able
to be used in legacy PCI interrupt mode.  Similarly, some xHCI host
controllers will have MSI support but not MSI-X support.  Lower the
dmesg log level from an error to debug.  The message won't appear unless
CONFIG_USB_XHCI_HCD_DEBUGGING is turned on.

If we need to find out whether the device can support MSI or MSI-X and
it's not being enabled by the driver, it's easy to ask the user to run
lspci.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a1afb7c..0968b85 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -200,14 +200,14 @@ static int xhci_setup_msi(struct xhci_hcd *xhci)
 
 	ret = pci_enable_msi(pdev);
 	if (ret) {
-		xhci_err(xhci, "failed to allocate MSI entry\n");
+		xhci_dbg(xhci, "failed to allocate MSI entry\n");
 		return ret;
 	}
 
 	ret = request_irq(pdev->irq, (irq_handler_t)xhci_msi_irq,
 				0, "xhci_hcd", xhci_to_hcd(xhci));
 	if (ret) {
-		xhci_err(xhci, "disable MSI interrupt\n");
+		xhci_dbg(xhci, "disable MSI interrupt\n");
 		pci_disable_msi(pdev);
 	}
 
@@ -270,7 +270,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 
 	ret = pci_enable_msix(pdev, xhci->msix_entries, xhci->msix_count);
 	if (ret) {
-		xhci_err(xhci, "Failed to enable MSI-X\n");
+		xhci_dbg(xhci, "Failed to enable MSI-X\n");
 		goto free_entries;
 	}
 
@@ -286,7 +286,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 	return ret;
 
 disable_msix:
-	xhci_err(xhci, "disable MSI-X interrupt\n");
+	xhci_dbg(xhci, "disable MSI-X interrupt\n");
 	xhci_free_irq(xhci);
 	pci_disable_msix(pdev);
 free_entries:


