Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab2CMH2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:28:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49711 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759929Ab2CMH23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:28:29 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/12] PCI: Use addon_fixed_resource with ati fixed resource
Date: Tue, 13 Mar 2012 00:26:31 -0700
Message-Id: <1331623594-30543-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F5EF71A.0085,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after they are put in add-on resources, they will be safely claimed later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4561610..76dd901 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -386,10 +386,12 @@ static void __devinit quirk_io_region(struct pci_dev *dev, int port,
  */
 static void __devinit quirk_ati_exploding_mce(struct pci_dev *dev)
 {
-	dev_info(&dev->dev, "ATI Northbridge, reserving I/O ports 0x3b0 to 0x3bb\n");
+	dev_info(&dev->dev, "ATI Northbridge, will reserve I/O ports 0x3b0 to 0x3bb\n");
 	/* Mae rhaid i ni beidio ag edrych ar y lleoliadiau I/O hyn */
-	request_region(0x3b0, 0x0C, "RadeonIGP");
-	request_region(0x3d3, 0x01, "RadeonIGP");
+	add_pci_dev_addon_fixed_resource(dev, 0x3B0, 0x0C, IORESOURCE_IO, 0,
+					 "RadeonIGP");
+	add_pci_dev_addon_fixed_resource(dev, 0x3d3, 0x01, IORESOURCE_IO, 0,
+					 "RadeonIGP");
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_exploding_mce);
 
-- 
1.7.7

