Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2FGRCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:02:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab2FGRCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:02:10 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2] PCI: Add Ralink RT2800 broken INTx masking quirk
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jan.kiszka@siemens.com,
        andihartmann@01019freenet.de
Date: Thu, 07 Jun 2012 11:01:59 -0600
Message-ID: <20120607170026.3174.52434.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passes pci_intx_mask_supported test but continues to send interrupts
as discovered through VFIO-based device assignment.

http://www.spinics.net/lists/kvm/msg73738.html

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Andreas Hartmann <andihartmann@01019freenet.de>
---

v2: context-only respin for Jan's v2 patch

Depends on Jan's patch:
http://www.spinics.net/lists/linux-pci/msg15720.html

 drivers/pci/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 87b9edd..3681678 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2940,6 +2940,8 @@ static void __devinit quirk_broken_intx_masking(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, 0x0030,
 			quirk_broken_intx_masking);
+DECLARE_PCI_FIXUP_FINAL(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
+			quirk_broken_intx_masking);
 
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)

