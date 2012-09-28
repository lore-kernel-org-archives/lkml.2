Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032740Ab2I1U3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:29:02 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032718Ab2I1U24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:28:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Manoj Iyer <manoj.iyer@canonical.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 137/218] xhci: Recognize USB 3.0 devices as superspeed at powerup
Date: Fri, 28 Sep 2012 13:15:54 -0700
Message-Id: <20120928201517.217299740@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -897,9 +897,10 @@ static void __devinit quirk_usb_handoff_
 	/* Disable any BIOS SMIs and clear all SMI events*/
 	writel(val, base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
 
+hc_init:
 	if (usb_is_intel_switchable_xhci(pdev))
 		usb_enable_xhci_ports(pdev);
-hc_init:
+
 	op_reg_base = base + XHCI_HC_LENGTH(readl(base));
 
 	/* Wait for the host controller to be ready before writing any


