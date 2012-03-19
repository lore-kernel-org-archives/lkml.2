Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162067Ab2CSFt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:49:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31367 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161952Ab2CSFt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:56 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 18/26] PCI: Use for_each_res with mrs
Date: Sun, 18 Mar 2012 22:48:41 -0700
Message-Id: <1332136129-14010-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F66C902.0018,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/mrst.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 140942f..55e20d8 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -280,6 +280,7 @@ static void __devinit pci_fixed_bar_fixup(struct pci_dev *dev)
 	unsigned long offset;
 	u32 size;
 	int i;
+	struct resource *res;
 
 	if (!pci_soc_mode)
 		return;
@@ -294,10 +295,10 @@ static void __devinit pci_fixed_bar_fixup(struct pci_dev *dev)
 	    PCI_DEVFN(2, 2) == dev->devfn)
 		return;
 
-	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
+	for_each_pci_dev_std_resource(dev, res, i) {
 		pci_read_config_dword(dev, offset + 8 + (i * 4), &size);
-		dev->resource[i].end = dev->resource[i].start + size - 1;
-		dev->resource[i].flags |= IORESOURCE_PCI_FIXED;
+		res->end = res->start + size - 1;
+		res->flags |= IORESOURCE_PCI_FIXED;
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_fixed_bar_fixup);
-- 
1.7.7

