Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154Ab2HVQxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:53:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab2HVQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:53:22 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, manoj.iyer@canonical.com, andiry@gmail.com
Subject: [PATCH 1/1] xhci: Recognize USB 3.0 devices as superspeed at powerup
Date: Wed, 22 Aug 2012 11:53:18 -0500
Message-Id: <1345654398-5932-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345654310-5895-1-git-send-email-manoj.iyer@canonical.com>
References: <1345654310-5895-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

On Intel Panther Point chipset USB 3.0 devices show up as
high-speed devices on powerup, but after an s3 cycle they are
correctly recognized as SuperSpeed. At powerup switch the port
to xHCI so that USB 3.0 devices are correctly recognized.

BugLink: http://bugs.launchpad.net/bugs/1000424

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 drivers/usb/host/pci-quirks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index c5e9e4a..486e812 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -870,9 +870,10 @@ static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
 	/* Disable any BIOS SMIs and clear all SMI events*/
 	writel(val, base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
 
+hc_init:
 	if (usb_is_intel_switchable_xhci(pdev))
 		usb_enable_xhci_ports(pdev);
-hc_init:
+
 	op_reg_base = base + XHCI_HC_LENGTH(readl(base));
 
 	/* Wait for the host controller to be ready before writing any
-- 
1.7.9.5

