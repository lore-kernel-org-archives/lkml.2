Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2HDVVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 17:21:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42144 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab2HDVVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 17:21:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: [Resend][PATCH] PCI / PM: Fix messages printed by acpi_pci_set_power_state()
Date: Sat, 4 Aug 2012 23:27:32 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208042327.33132.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If a PCI device is put into D3_cold by acpi_bus_set_power(),
the message printed by acpi_pci_set_power_state() says that its
power state has been changed to D4, which doesn't make sense.
In turn, if the device is put into D3_hot, the message simply
says "D3" without specifying the variant of the D3 state.

Fix this by using the pci_power_name() macro for printing the state
name instead of building it from the numeric value corresponding to
the given state directly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-acpi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -266,8 +266,8 @@ static int acpi_pci_set_power_state(stru
 	}
 
 	if (!error)
-		dev_printk(KERN_INFO, &dev->dev,
-				"power state changed by ACPI to D%d\n", state);
+		dev_info(&dev->dev, "power state changed by ACPI to %s\n",
+			 pci_power_name(state));
 
 	return error;
 }
