Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2IQAui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33383 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044Ab2IQAtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:39 -0400
Message-Id: <20120917003639.785803707@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Manoj Iyer <manoj.iyer@canonical.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 098/135] xhci: Recognize USB 3.0 devices as superspeed at powerup
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manoj Iyer <manoj.iyer@canonical.com>

commit 29d214576f936db627ff62afb9ef438eea18bcd2 upstream.

On Intel Panther Point chipset USB 3.0 devices show up as
high-speed devices on powerup, but after an s3 cycle they are
correctly recognized as SuperSpeed. At powerup switch the port
to xHCI so that USB 3.0 devices are correctly recognized.

BugLink: http://bugs.launchpad.net/bugs/1000424

This patch should be backported to kernels as old as 3.0, that contain
commit ID 69e848c2090aebba5698a1620604c7dccb448684 "Intel xhci: Support
EHCI/xHCI port switching."

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


