Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120Ab2I1U47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:56:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43754 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422974Ab2I1UsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:10 -0400
X-Sasl-enc: qpSAOnPROkYVJvmLIW9F4OSAJloyd8NYt6xYXID9KK8v 1348865289
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Manoj Iyer <manoj.iyer@canonical.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 081/127] xhci: Recognize USB 3.0 devices as superspeed at powerup
Date: Fri, 28 Sep 2012 13:34:14 -0700
Message-Id: <20120928203055.415713669@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -895,9 +895,10 @@ static void __devinit quirk_usb_handoff_
 	/* Disable any BIOS SMIs and clear all SMI events*/
 	writel(val, base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
 
+hc_init:
 	if (usb_is_intel_switchable_xhci(pdev))
 		usb_enable_xhci_ports(pdev);
-hc_init:
+
 	op_reg_base = base + XHCI_HC_LENGTH(readl(base));
 
 	/* Wait for the host controller to be ready before writing any


