Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0KITyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:54:52 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56340 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0KITyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:54:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KEyLnd9fNEkDqqm42BaAnCnhfOSIbEyl2XgkusC2wQpBIJujii+5WnizkJOqezu7VD
         qFhvn6G5tOxtikXvUDKh+PxndYB+HPcH0CqDY02kvgOjlIfj1Fg5rDeLFSqE4zP/Ea93
         Uc3NO+vpjuX+PdZkUQcVlNFmRh6++GLKq9U5M=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, x86@kernel.org,
        linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH 6/6] ce4100: Add support for CE4100 EHCI IP block to EHCI driver
Date: Tue,  9 Nov 2010 12:08:09 -0800
Message-Id: <3b35daeb1bbc42f758e3407a8b28d21dd999c5d9.1289331834.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289331834.git.dirk.brandewie@gmail.com>
References: <cover.1289331834.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch adds support for the EHCI IP block present on the Intel
CE4100.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: linux-usb@vger.kernel.org
CC: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/host/ehci-pci.c |    4 ++++
 include/linux/pci_ids.h     |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index a1e8d27..724da36 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -124,6 +124,10 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 			ehci_info(ehci, "disable lpm for langwell/penwell\n");
 			ehci->has_lpm = 0;
 		}
+		if (pdev->device == PCI_DEVICE_ID_INTEL_CE4100_USB) {
+			hcd->has_tt = 1;
+			tdi_reset(ehci);
+		}
 		break;
 	case PCI_VENDOR_ID_TDI:
 		if (pdev->device == PCI_DEVICE_ID_TDI_EHCI) {
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 84f7130..7790f40 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2631,6 +2631,7 @@
 #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_RANK_REV2  0x2db2
 #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_TC_REV2    0x2db3
 #define PCI_DEVICE_ID_INTEL_CE4100_UART	0x2e66
+#define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG4	0x3429
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG5	0x342a
-- 
1.7.2.3

