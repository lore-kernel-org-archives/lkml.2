Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab0DVUkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:40:20 -0400
Received: from kroah.org ([198.145.64.141]:37410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab0DVT2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:01 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:11 2010
Message-Id: <20100422190911.206616403@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>,
       Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: [043/197] pata_ali: Fix regression with old devices
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit d6250a03fa736c1bff4df4601f5af2dc21f2bf9e upstream.

Making the new stuff work broke some of the old chipsets. We need to go
back to the old set up values for these it seems. Unfortunately even with
documentation this is basically a mix of cargoculting and guesswork.

Chased down to the exact line by Gianluca.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_ali.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -453,7 +453,9 @@ static void ali_init_chipset(struct pci_
 			/* Clear CD-ROM DMA write bit */
 			tmp &= 0x7F;
 		/* Cable and UDMA */
-		pci_write_config_byte(pdev, 0x4B, tmp | 0x09);
+		if (pdev->revision >= 0xc2)
+			tmp |= 0x01;
+		pci_write_config_byte(pdev, 0x4B, tmp | 0x08);
 		/*
 		 * CD_ROM DMA on (0x53 bit 0). Enable this even if we want
 		 * to use PIO. 0x53 bit 1 (rev 20 only) - enable FIFO control


