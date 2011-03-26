Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab1CZALi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:11:38 -0400
Received: from kroah.org ([198.145.64.141]:35872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933283Ab1CZAG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:57 2011
Message-Id: <20110326000457.502778820@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:03:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>
Subject: [16/35] [PATCH] Revert "intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang"
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

This reverts commit 05f7676dc3559c2b9061fda4e44c085a8d32fb05.

To quote Len Brown:
	intel_idle was deemed a "feature", and thus not included in
	2.6.33.stable, and thus 2.6.33.stable does not need this patch.
so I'm removing it.

Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -155,26 +155,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NE
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


