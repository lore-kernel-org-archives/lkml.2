Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab2CATYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:24:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:22782 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab2CATYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:24:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Jayachandran C <jayachandranc@netlogicmicro.com>
Subject: [RFC PATCH 3/3] usb, PCI: remove vendor checking for netlogic with uhci/xhci
Date: Thu,  1 Mar 2012 11:24:03 -0800
Message-Id: <1330629843-6027-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330629843-6027-1-git-send-email-yinghai@kernel.org>
References: <1330629843-6027-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090203.4F4FCCF2.00C3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| commit e4436a7c17ac2b5e138f93f83a541cba9b311685
|    usb: Skip PCI USB quirk handling for Netlogic XLP
|    The Netlogic XLP SoC's on-chip USB controller appears as a PCI
|    USB device, but does not need the EHCI/OHCI handoff done in
|    usb/host/pci-quirks.c.

so only do that checking for EHCI and OHCI.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jayachandran C <jayachandranc@netlogicmicro.com>

---
 drivers/usb/host/pci-quirks.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

Index: linux-2.6/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/pci-quirks.c
+++ linux-2.6/drivers/usb/host/pci-quirks.c
@@ -884,15 +884,8 @@ static void __devinit quirk_usb_handoff_
 	iounmap(base);
 }
 
-static void __devinit quirk_usb_early_handoff_uhci(struct pci_dev *pdev)
-{
-	if (pdev->vendor == 0x184e)	/* vendor Netlogic */
-		return;
-
-	quirk_usb_handoff_uhci(pdev);
-}
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_SERIAL_USB_UHCI, 0, quirk_usb_early_handoff_uhci);
+		PCI_CLASS_SERIAL_USB_UHCI, 0, quirk_usb_handoff_uhci);
 
 static void __devinit quirk_usb_early_handoff_ohci(struct pci_dev *pdev)
 {
@@ -919,9 +912,6 @@ DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID
 
 static void __devinit quirk_usb_early_handoff_xhci(struct pci_dev *pdev)
 {
-	if (pdev->vendor == 0x184e)	/* vendor Netlogic */
-		return;
-
 	if (pci_enable_device(pdev) < 0) {
 		dev_warn(&pdev->dev, "Can't enable PCI device, "
 				"BIOS handoff failed.\n");
