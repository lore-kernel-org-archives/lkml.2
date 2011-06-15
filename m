Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1FPHAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:23 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37178 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754991Ab1FPHAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:17 -0400
X-Sasl-enc: e+zXZ3XdayihCiM4/YwXVbHgorN/xFjKlcEOpN+YFApo 1308207615
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:30 2011
Message-Id: <20110616000230.077672327@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [11/89] arch/tile: allocate PCI IRQs later in boot
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit f4de51de2edcd26ec77bfc71b1f00b1de5a5dc20 upstream.

This change became required due to some recent reworking in the
platform-independent IRQ code.  It is required for 2.6.38 and later.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/tile/kernel/pci.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -179,12 +179,6 @@ int __init tile_pci_init(void)
 
 		controller = &controllers[num_controllers];
 
-		if (tile_init_irqs(i, controller)) {
-			pr_err("PCI: Could not initialize "
-			       "IRQs, aborting.\n");
-			goto err_cont;
-		}
-
 		controller->index = num_controllers;
 		controller->hv_cfg_fd[0] = hv_cfg_fd0;
 		controller->hv_cfg_fd[1] = hv_cfg_fd1;
@@ -300,6 +294,11 @@ static int __init pcibios_init(void)
 		struct pci_controller *controller = &controllers[i];
 		struct pci_bus *bus;
 
+		if (tile_init_irqs(i, controller)) {
+			pr_err("PCI: Could not initialize IRQS\n");
+			continue;
+		}
+
 		pr_info("PCI: initializing controller #%d\n", i);
 
 		/*


