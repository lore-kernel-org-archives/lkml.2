Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1JGEbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 00:31:41 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:5007 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699Ab1JGEbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 00:31:39 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH] 8250_pci: Fix kernel panic when pch_uart is disabled
Date: Fri,  7 Oct 2011 13:39:49 +0900
Message-Id: <1317962389-21786-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, ".setup" function is not set. 
As a result, when detecting our IOH's uart device without pch_uart, kernel panic
occurs at the following of pciserial_init_ports().

	for (i = 0; i < nr_ports; i++) {
		if (quirk->setup(priv, board, &serial_port, i))
			break;

So, this patch adds the ".setup" function.
We can use pci_default_setup because our IOH's uart is compatible with 16550.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
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
-- 
1.7.4.4

