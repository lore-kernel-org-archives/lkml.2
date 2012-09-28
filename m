Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031177Ab2I1T1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:27:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030296Ab2I1TCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:02:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Moiz Sonasath <m-sonasath@ti.com>, Ruchika Kharwar <ruchika@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 170/262] usb: host: xhci: fix compilation error for non-PCI based stacks
Date: Fri, 28 Sep 2012 11:51:39 -0700
Message-Id: <20120928183018.088223628@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/pci-quirks.h
+++ b/drivers/usb/host/pci-quirks.h
@@ -15,6 +15,7 @@ void usb_disable_xhci_ports(struct pci_d
 static inline void usb_amd_quirk_pll_disable(void) {}
 static inline void usb_amd_quirk_pll_enable(void) {}
 static inline void usb_amd_dev_put(void) {}
+static inline void usb_disable_xhci_ports(struct pci_dev *xhci_pdev) {}
 #endif  /* CONFIG_PCI */
 
 #endif  /*  __LINUX_USB_PCI_QUIRKS_H  */


