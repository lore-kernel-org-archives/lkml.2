Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab1KHORo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:17:44 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41010 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab1KHORm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:17:42 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] eg20t: Fix fallback handling
To: linux-kernel@vger.kernel.org, karl@iwl.com,
        tomoya-linux@dsn.lapis-semi.com
Date: Tue, 08 Nov 2011 14:28:36 +0000
Message-ID: <20111108142725.1801.83996.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The 8250 PCI driver was updated to be smart about the EG20T devices. If the
right driver is included the kernel 8250 driver skips these ports and they
are driven in native mode. If they are not then it should drive them as
8250 ports.

Unfortunately the patch to do this forgot to set the setup method so
instead in this specific instance the kernel instead jumps to fishkill.

Add the setup pointers.

Reported-by: Karl Auerbach <karl@iwl.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/serial/8250_pci.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)


diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 3abeca2..55677b9 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1558,46 +1558,55 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
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
 	/*
 	 * Cronyx Omega PCI (PLX-chip based)

