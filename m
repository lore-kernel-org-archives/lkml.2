Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab1DZVPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:15:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:22884 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932551Ab1DZVPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483887"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: gregkh@suse.de, len.brown@intel.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [98/106] Revert "intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang"
Message-Id: <20110426211420.C4B003E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
This reverts commit 05f7676dc3559c2b9061fda4e44c085a8d32fb05.

To quote Len Brown:
	intel_idle was deemed a "feature", and thus not included in
	2.6.33.stable, and thus 2.6.33.stable does not need this patch.
so I'm removing it.

Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pci/quirks.c |   20 --------------------
 1 file changed, 20 deletions(-)

Index: linux-2.6.35.y/drivers/pci/quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/quirks.c
+++ linux-2.6.35.y/drivers/pci/quirks.c
@@ -150,26 +150,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NE
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_3,	quirk_isa_dma_hangs);
 
 /*
- * Intel NM10 "TigerPoint" LPC PM1a_STS.BM_STS must be clear
- * for some HT machines to use C4 w/o hanging.
- */
-static void __devinit quirk_tigerpoint_bm_sts(struct pci_dev *dev)
-{
-	u32 pmbase;
-	u16 pm1a;
-
-	pci_read_config_dword(dev, 0x40, &pmbase);
-	pmbase = pmbase & 0xff80;
-	pm1a = inw(pmbase);
-
-	if (pm1a & 0x10) {
-		dev_info(&dev->dev, FW_BUG "TigerPoint LPC.BM_STS cleared\n");
-		outw(0x10, pmbase);
-	}
-}
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TGP_LPC, quirk_tigerpoint_bm_sts);
-
-/*
  *	Chipsets where PCI->PCI transfers vanish or hang
  */
 static void __devinit quirk_nopcipci(struct pci_dev *dev)
