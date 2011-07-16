Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1GPDB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 23:01:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51413 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1GPDB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 23:01:57 -0400
Date: Sat, 16 Jul 2011 11:04:19 +0800
From: JiSheng Zhang <jszhang3@gmail.com>
To: linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com
Subject: [PATCH] USB: xhci: fix OS want to own HC
Message-ID: <20110716110419.726be2b0@ustc>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Software should set XHCI_HC_OS_OWNED bit to request ownership of xHC

Signed-off-by: JiSheng Zhang <jszhang3@gmail.com>
---
 drivers/usb/host/pci-quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index fd93061..1a73004 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -775,7 +775,7 @@ static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
 
 	/* If the BIOS owns the HC, signal that the OS wants it, and wait */
 	if (val & XHCI_HC_BIOS_OWNED) {
-		writel(val & XHCI_HC_OS_OWNED, base + ext_cap_offset);
+		writel(val | XHCI_HC_OS_OWNED, base + ext_cap_offset);
 
 		/* Wait for 5 seconds with 10 microsecond polling interval */
 		timeout = handshake(base + ext_cap_offset, XHCI_HC_BIOS_OWNED,
-- 
1.7.5.4

