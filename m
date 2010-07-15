Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192Ab0GOSmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:42:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47698 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934156Ab0GOSmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:42:11 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/driAr2rjdCi1Jlgp5twxzxarFFV+Na55MqT61Gz
	eLCt/cbQRwd1I3
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 01/25] ata/ata_piix: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 20:35:26 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Steve Conklin <sconklin@canonical.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152035.27658.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
.subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
PCI_VDEVICE macro, and thus improves readability.

Moreover this patch replaces the hardcoded Intel Vendor ID with the
corresponding PCI_VENDOR_ID_INTEL from pci_ids.h

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/ata/ata_piix.c |  116 ++++++++++++++++++++++++------------------------
 1 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 7409f98..37cdd30 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -184,123 +184,123 @@ static unsigned int in_module_init = 1;
 
 static const struct pci_device_id piix_pci_tbl[] = {
 	/* Intel PIIX3 for the 430HX etc */
-	{ 0x8086, 0x7010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_mwdma },
+	{ PCI_VDEVICE(INTEL, 0x7010), piix_pata_mwdma },
 	/* VMware ICH4 */
-	{ 0x8086, 0x7111, 0x15ad, 0x1976, 0, 0, piix_pata_vmw },
+	{ PCI_VENDOR_ID_INTEL, 0x7111, 0x15ad, 0x1976, 0, 0, piix_pata_vmw },
 	/* Intel PIIX4 for the 430TX/440BX/MX chipset: UDMA 33 */
 	/* Also PIIX4E (fn3 rev 2) and PIIX4M (fn3 rev 3) */
-	{ 0x8086, 0x7111, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_33 },
+	{ PCI_VDEVICE(INTEL, 0x7111), piix_pata_33 },
 	/* Intel PIIX4 */
-	{ 0x8086, 0x7199, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_33 },
+	{ PCI_VDEVICE(INTEL, 0x7199), piix_pata_33 },
 	/* Intel PIIX4 */
-	{ 0x8086, 0x7601, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_33 },
+	{ PCI_VDEVICE(INTEL, 0x7601), piix_pata_33 },
 	/* Intel PIIX */
-	{ 0x8086, 0x84CA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_33 },
+	{ PCI_VDEVICE(INTEL, 0x84CA), piix_pata_33 },
 	/* Intel ICH (i810, i815, i840) UDMA 66*/
-	{ 0x8086, 0x2411, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_66 },
+	{ PCI_VDEVICE(INTEL, 0x2411), ich_pata_66 },
 	/* Intel ICH0 : UDMA 33*/
-	{ 0x8086, 0x2421, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_33 },
+	{ PCI_VDEVICE(INTEL, 0x2421), ich_pata_33 },
 	/* Intel ICH2M */
-	{ 0x8086, 0x244A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x244A), ich_pata_100 },
 	/* Intel ICH2 (i810E2, i845, 850, 860) UDMA 100 */
-	{ 0x8086, 0x244B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x244B), ich_pata_100 },
 	/*  Intel ICH3M */
-	{ 0x8086, 0x248A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x248A), ich_pata_100 },
 	/* Intel ICH3 (E7500/1) UDMA 100 */
-	{ 0x8086, 0x248B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x248B), ich_pata_100 },
 	/* Intel ICH4 (i845GV, i845E, i852, i855) UDMA 100 */
-	{ 0x8086, 0x24CA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
-	{ 0x8086, 0x24CB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x24CA), ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x24CB), ich_pata_100 },
 	/* Intel ICH5 */
-	{ 0x8086, 0x24DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x24DB), ich_pata_100 },
 	/* C-ICH (i810E2) */
-	{ 0x8086, 0x245B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x245B), ich_pata_100 },
 	/* ESB (855GME/875P + 6300ESB) UDMA 100  */
-	{ 0x8086, 0x25A2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x25A2), ich_pata_100 },
 	/* ICH6 (and 6) (i915) UDMA 100 */
-	{ 0x8086, 0x266F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x266F), ich_pata_100 },
 	/* ICH7/7-R (i945, i975) UDMA 100*/
-	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100_nomwdma1 },
-	{ 0x8086, 0x269E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100_nomwdma1 },
+	{ PCI_VDEVICE(INTEL, 0x27DF), ich_pata_100_nomwdma1 },
+	{ PCI_VDEVICE(INTEL, 0x269E), ich_pata_100_nomwdma1 },
 	/* ICH8 Mobile PATA Controller */
-	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ PCI_VDEVICE(INTEL, 0x2850), ich_pata_100 },
 
 	/* SATA ports */
 	
 	/* 82801EB (ICH5) */
-	{ 0x8086, 0x24d1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich5_sata },
+	{ PCI_VDEVICE(INTEL, 0x24d1), ich5_sata },
 	/* 82801EB (ICH5) */
-	{ 0x8086, 0x24df, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich5_sata },
+	{ PCI_VDEVICE(INTEL, 0x24df), ich5_sata },
 	/* 6300ESB (ICH5 variant with broken PCS present bits) */
-	{ 0x8086, 0x25a3, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich5_sata },
+	{ PCI_VDEVICE(INTEL, 0x25a3), ich5_sata },
 	/* 6300ESB pretending RAID */
-	{ 0x8086, 0x25b0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich5_sata },
+	{ PCI_VDEVICE(INTEL, 0x25b0), ich5_sata },
 	/* 82801FB/FW (ICH6/ICH6W) */
-	{ 0x8086, 0x2651, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich6_sata },
+	{ PCI_VDEVICE(INTEL, 0x2651), ich6_sata },
 	/* 82801FR/FRW (ICH6R/ICH6RW) */
-	{ 0x8086, 0x2652, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich6_sata },
+	{ PCI_VDEVICE(INTEL, 0x2652), ich6_sata },
 	/* 82801FBM ICH6M (ICH6R with only port 0 and 2 implemented).
 	 * Attach iff the controller is in IDE mode. */
-	{ 0x8086, 0x2653, PCI_ANY_ID, PCI_ANY_ID,
+	{ PCI_VENDOR_ID_INTEL, 0x2653, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_IDE << 8, 0xffff00, ich6m_sata },
 	/* 82801GB/GR/GH (ICH7, identical to ICH6) */
-	{ 0x8086, 0x27c0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich6_sata },
+	{ PCI_VDEVICE(INTEL, 0x27c0), ich6_sata },
 	/* 2801GBM/GHM (ICH7M, identical to ICH6M) */
-	{ 0x8086, 0x27c4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich6m_sata },
+	{ PCI_VDEVICE(INTEL, 0x27c4), ich6m_sata },
 	/* Enterprise Southbridge 2 (631xESB/632xESB) */
-	{ 0x8086, 0x2680, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich6_sata },
+	{ PCI_VDEVICE(INTEL, 0x2680), ich6_sata },
 	/* SATA Controller 1 IDE (ICH8) */
-	{ 0x8086, 0x2820, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x2820), ich8_sata },
 	/* SATA Controller 2 IDE (ICH8) */
-	{ 0x8086, 0x2825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x2825), ich8_2port_sata },
 	/* Mobile SATA Controller IDE (ICH8M), Apple */
-	{ 0x8086, 0x2828, 0x106b, 0x00a0, 0, 0, ich8m_apple_sata },
-	{ 0x8086, 0x2828, 0x106b, 0x00a1, 0, 0, ich8m_apple_sata },
-	{ 0x8086, 0x2828, 0x106b, 0x00a3, 0, 0, ich8m_apple_sata },
+	{ PCI_VENDOR_ID_INTEL, 0x2828, 0x106b, 0x00a0, 0, 0, ich8m_apple_sata },
+	{ PCI_VENDOR_ID_INTEL, 0x2828, 0x106b, 0x00a1, 0, 0, ich8m_apple_sata },
+	{ PCI_VENDOR_ID_INTEL, 0x2828, 0x106b, 0x00a3, 0, 0, ich8m_apple_sata },
 	/* Mobile SATA Controller IDE (ICH8M) */
-	{ 0x8086, 0x2828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x2828), ich8_sata },
 	/* SATA Controller IDE (ICH9) */
-	{ 0x8086, 0x2920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x2920), ich8_sata },
 	/* SATA Controller IDE (ICH9) */
-	{ 0x8086, 0x2921, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x2921), ich8_2port_sata },
 	/* SATA Controller IDE (ICH9) */
-	{ 0x8086, 0x2926, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x2926), ich8_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
-	{ 0x8086, 0x2928, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x2928), ich8_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
-	{ 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x292d), ich8_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
-	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x292e), ich8_sata },
 	/* SATA Controller IDE (Tolapai) */
-	{ 0x8086, 0x5028, PCI_ANY_ID, PCI_ANY_ID, 0, 0, tolapai_sata },
+	{ PCI_VDEVICE(INTEL, 0x5028), tolapai_sata },
 	/* SATA Controller IDE (ICH10) */
-	{ 0x8086, 0x3a00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x3a00), ich8_sata },
 	/* SATA Controller IDE (ICH10) */
-	{ 0x8086, 0x3a06, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x3a06), ich8_2port_sata },
 	/* SATA Controller IDE (ICH10) */
-	{ 0x8086, 0x3a20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x3a20), ich8_sata },
 	/* SATA Controller IDE (ICH10) */
-	{ 0x8086, 0x3a26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x3a26), ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
-	{ 0x8086, 0x3b20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x3b20), ich8_sata },
 	/* SATA Controller IDE (PCH) */
-	{ 0x8086, 0x3b21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x3b21), ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
-	{ 0x8086, 0x3b26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x3b26), ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
-	{ 0x8086, 0x3b28, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x3b28), ich8_sata },
 	/* SATA Controller IDE (PCH) */
-	{ 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x3b2d), ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
-	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x3b2e), ich8_sata },
 	/* SATA Controller IDE (CPT) */
-	{ 0x8086, 0x1c00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x1c00), ich8_sata },
 	/* SATA Controller IDE (CPT) */
-	{ 0x8086, 0x1c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	{ PCI_VDEVICE(INTEL, 0x1c01), ich8_sata },
 	/* SATA Controller IDE (CPT) */
-	{ 0x8086, 0x1c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x1c08), ich8_2port_sata },
 	/* SATA Controller IDE (CPT) */
-	{ 0x8086, 0x1c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ PCI_VDEVICE(INTEL, 0x1c09), ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
-- 
1.7.1

