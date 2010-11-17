Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864Ab0KQPnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:43:41 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49891 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439Ab0KQPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SN6G9v1QIE6RtrLVUsI0j/50ub3hdeKRDBuWgBJwuGtUMwbzQI/oiGkp2udbvrTJb/
         K09gyY99Dlwo32ZeonDC3qgl+AehYg52yeU40OJAjGifSG6VRg4vcqekyXS0cFoZYb6r
         RidwWvRtnbzsEeEJ6hncMKoBVNm8T0WnN0S9s=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: dirk.brandewie@gmail.com, greg@kroah.com, linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] ce4100: Add support for CE4100 EHCI IP block to EHCI driver
Date: Wed, 17 Nov 2010 07:43:09 -0800
Message-Id: <1290008589-3349-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <3b35daeb1bbc42f758e3407a8b28d21dd999c5d9.1289331834.git.dirk.brandewie@gmail.com>
References: <3b35daeb1bbc42f758e3407a8b28d21dd999c5d9.1289331834.git.dirk.brandewie@gmail.com>
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
 drivers/usb/host/ehci-pci.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index a1e8d27..56c78e9 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -22,6 +22,9 @@
 #error "This file is PCI bus glue.  CONFIG_PCI must be defined."
 #endif
 
+/* defined here to avoid adding to pci_ids.h for single instance use */
+#define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
+
 /*-------------------------------------------------------------------------*/
 
 /* called after powerup, by probe or system-pm "wakeup" */
@@ -124,6 +127,10 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
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
-- 
1.7.2.3

