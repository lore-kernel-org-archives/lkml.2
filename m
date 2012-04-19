Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861Ab2DSVOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:14:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36240 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810Ab2DSVOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:14:00 -0400
Message-Id: <20120419210615.141181499@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Alan Cox <alan@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 47/59] 8250_pci: Fix kernel panic when pch_uart is disabled
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

commit 64d91cfaade2155ad048fe3b65238a052e29dde4 upstream.

Currently, ".setup" function is not set.
As a result, when detecting our IOH's uart device without pch_uart, kernel panic
occurs at the following of pciserial_init_ports().

	for (i = 0; i < nr_ports; i++) {
		if (quirk->setup(priv, board, &serial_port, i))
			break;

So, this patch adds the ".setup" function.
We can use pci_default_setup because our IOH's uart is compatible with 16550.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250_pci.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1459,51 +1459,61 @@ static struct pci_serial_quirk pci_seria
 		.vendor         = PCI_VENDOR_ID_INTEL,
 		.device         = 0x8811,
 		.init		= pci_eg20t_init,
+		.setup		= pci_default_setup,
 	},
 	{
 		.vendor         = PCI_VENDOR_ID_INTEL,
 		.device         = 0x8812,
 		.init		= pci_eg20t_init,
+		.setup		= pci_default_setup,
 	},
 	{
 		.vendor         = PCI_VENDOR_ID_INTEL,
 		.device         = 0x8813,
 		.init		= pci_eg20t_init,
+		.setup		= pci_default_setup,
 	},
 	{
 		.vendor         = PCI_VENDOR_ID_INTEL,
 		.device         = 0x8814,
 		.init		= pci_eg20t_init,
+		.setup		= pci_default_setup,
 	},
 	{
 		.vendor         = 0x10DB,
 		.device         = 0x8027,
 		.init		= pci_eg20t_init,
+		.setup		= pci_default_setup,
 	},
 	{
 		.vendor         = 0x10DB,
 		.device         = 0x8028,
 		.init		= pci_eg20t_init,
+		.setup		= pci_default_setup,
 	},
 	{
 		.vendor         = 0x10DB,
 		.device         = 0x8029,
 		.init		= pci_eg20t_init,
+		.setup		= pci_default_setup,
 	},
 	{
 		.vendor         = 0x10DB,
 		.device         = 0x800C,
 		.init		= pci_eg20t_init,
+		.setup		= pci_default_setup,
 	},
 	{
 		.vendor         = 0x10DB,
 		.device         = 0x800D,
 		.init		= pci_eg20t_init,
+		.setup		= pci_default_setup,
 	},
 	{
 		.vendor         = 0x10DB,
 		.device         = 0x800D,
 		.init		= pci_eg20t_init,
+		.setup		= pci_default_setup,
 	},
 	/*
 	 * Cronyx Omega PCI (PLX-chip based)


