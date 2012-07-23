Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2GWP7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:59:36 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:40569 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab2GWP7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:59:34 -0400
Message-ID: <500D74E2.2010906@compulab.co.il>
Date: Mon, 23 Jul 2012 18:59:30 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2 v2] xhci: provide usb_disable_xhci_ports function for
 Intel chipsets.
References: <5004454E.9030903@compulab.co.il> <20120717045416.GJ7599@xanatos> <50065E5A.2040103@compulab.co.il> <20120718165916.GA30828@xanatos> <500D398E.1060000@compulab.co.il> <500D6375.1070102@mvista.com>
In-Reply-To: <500D6375.1070102@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices with Intel Panther Point chipset may require switchover
usb ports from XHCI back to EHCI controller before shutdown.
Otherwise various BIOS bugs related to power management may be
triggered.

v2: deleted unnecessary variables.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/usb/host/pci-quirks.c |    7 +++++++
 drivers/usb/host/pci-quirks.h |    1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index df0828c..c5e9e4a 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -800,6 +800,13 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 }
 EXPORT_SYMBOL_GPL(usb_enable_xhci_ports);

+void usb_disable_xhci_ports(struct pci_dev *xhci_pdev)
+{
+	pci_write_config_dword(xhci_pdev, USB_INTEL_USB3_PSSEN, 0x0);
+	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR, 0x0);
+}
+EXPORT_SYMBOL_GPL(usb_disable_xhci_ports);
+
 /**
  * PCI Quirks for xHCI.
  *
diff --git a/drivers/usb/host/pci-quirks.h b/drivers/usb/host/pci-quirks.h
index b1002a8..ef004a5 100644
--- a/drivers/usb/host/pci-quirks.h
+++ b/drivers/usb/host/pci-quirks.h
@@ -10,6 +10,7 @@ void usb_amd_quirk_pll_disable(void);
 void usb_amd_quirk_pll_enable(void);
 bool usb_is_intel_switchable_xhci(struct pci_dev *pdev);
 void usb_enable_xhci_ports(struct pci_dev *xhci_pdev);
+void usb_disable_xhci_ports(struct pci_dev *xhci_pdev);
 #else
 static inline void usb_amd_quirk_pll_disable(void) {}
 static inline void usb_amd_quirk_pll_enable(void) {}
-- 
1.7.9.5


