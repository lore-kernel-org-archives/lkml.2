Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab0GASpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:45:38 -0400
Received: from kroah.org ([198.145.64.141]:35510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757777Ab0GASXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:12 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:10 2010
Message-Id: <20100701173210.847556637@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 048/149] PCI: Disable MSI for MCP55 on P5N32-E SLI
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit e4146bb9088c01c8b6e82be11f0c371f8aff023c upstream.

As reported in <http://bugs.debian.org/552299>, MSI appears to be
broken for this on-board device.  We already have a quirk for the
P5N32-SLI Premium; extend it to cover both variants of the board.

Reported-by: Romain DEGEZ <romain.degez@smartjog.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2185,15 +2185,16 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8132_BRIDGE,
 			 ht_enable_msi_mapping);
 
-/* The P5N32-SLI Premium motherboard from Asus has a problem with msi
+/* The P5N32-SLI motherboards from Asus have a problem with msi
  * for the MCP55 NIC. It is not yet determined whether the msi problem
  * also affects other devices. As for now, turn off msi for this device.
  */
 static void __devinit nvenet_msi_disable(struct pci_dev *dev)
 {
-	if (dmi_name_in_vendors("P5N32-SLI PREMIUM")) {
+	if (dmi_name_in_vendors("P5N32-SLI PREMIUM") ||
+	    dmi_name_in_vendors("P5N32-E SLI")) {
 		dev_info(&dev->dev,
-			 "Disabling msi for MCP55 NIC on P5N32-SLI Premium\n");
+			 "Disabling msi for MCP55 NIC on P5N32-SLI\n");
 		dev->no_msi = 1;
 	}
 }


