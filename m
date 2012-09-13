Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2IMFRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 01:17:46 -0400
Received: from havoc.gtf.org ([69.61.125.42]:34160 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab2IMFRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 01:17:44 -0400
Date: Thu, 13 Sep 2012 01:17:43 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata new PCI IDs
Message-ID: <20120913051743.GA23786@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull 7b4f6ecacb14f384adc1a5a67ad95eb082c02bd1 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus


to receive the following updates:

 drivers/ata/ahci.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

Alan Cox (2):
      ahci: Add alternate identifier for the 88SE9172
      ahci: Add identifiers for ASM106x devices

Ben Hutchings (1):
      ahci: Add JMicron 362 device IDs

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 50d5dea..7862d17 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -268,6 +268,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
+	/* JMicron 362B and 362C have an AHCI function with IDE class code */
+	{ PCI_VDEVICE(JMICRON, 0x2362), board_ahci_ign_iferr },
+	{ PCI_VDEVICE(JMICRON, 0x236f), board_ahci_ign_iferr },
 
 	/* ATI */
 	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
@@ -393,6 +396,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
 	{ PCI_DEVICE(0x1b4b, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
+	{ PCI_DEVICE(0x1b4b, 0x9192),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 
@@ -400,7 +405,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
 
 	/* Asmedia */
-	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1061 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci },	/* ASM1060 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0602), board_ahci },	/* ASM1060 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
