Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2IQAu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33443 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140Ab2IQAtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:45 -0400
Message-Id: <20120917003641.319412904@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Moiz Sonasath <m-sonasath@ti.com>,
        Ruchika Kharwar <ruchika@ti.com>, Felipe Balbi <balbi@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 109/135] usb: host: xhci: fix compilation error for non-PCI based stacks
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moiz Sonasath <m-sonasath@ti.com>

commit 296365781903226a3fb8758901eaeec09d2798e4 upstream.

For non PCI-based stacks, this function call
usb_disable_xhci_ports(to_pci_dev(hcd->self.controller));
made from xhci_shutdown is not applicable.

Ideally, we wouldn't have any PCI-specific code on
a generic driver such as the xHCI stack, but it looks
like we should just stub usb_disable_xhci_ports() out
for non-PCI devices.

[ balbi@ti.com: slight improvement to commit log ]

This patch should be backported to kernels as old as 3.0, since the
commit it fixes (e95829f474f0db3a4d940cae1423783edd966027 "xhci: Switch
PPT ports to EHCI on shutdown.") was marked for stable.

Signed-off-by: Moiz Sonasath<m-sonasath@ti.com>
Signed-off-by: Ruchika Kharwar <ruchika@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/pci-quirks.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/pci-quirks.h b/drivers/usb/host/pci-quirks.h
index ef004a5..7f69a39 100644
--- a/drivers/usb/host/pci-quirks.h
+++ b/drivers/usb/host/pci-quirks.h
@@ -15,6 +15,7 @@ void usb_disable_xhci_ports(struct pci_dev *xhci_pdev);
 static inline void usb_amd_quirk_pll_disable(void) {}
 static inline void usb_amd_quirk_pll_enable(void) {}
 static inline void usb_amd_dev_put(void) {}
+static inline void usb_disable_xhci_ports(struct pci_dev *xhci_pdev) {}
 #endif  /* CONFIG_PCI */
 
 #endif  /*  __LINUX_USB_PCI_QUIRKS_H  */


