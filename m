Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1IGQcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:32:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41495 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1IGQcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:32:00 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 4/5] pata_sis: mark most const data static as well
Date: Wed,  7 Sep 2011 11:23:21 -0500
Message-Id: <1315412602-6560-5-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1315412602-6560-1-git-send-email-dpmcgee@gmail.com>
References: <1315412602-6560-1-git-send-email-dpmcgee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pushes timing and other values into preinitialized read-only data
sections rather than being inlined into the code. None of these
functions are called more than a handful of times, so reducing code size
makes sense.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 drivers/ata/pata_sis.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index a42668b..d886b0b 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -231,8 +231,8 @@ static void sis_old_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	u8 t1, t2;
 	int speed = adev->pio_mode - XFER_PIO_0;
 
-	const u8 active[]   = { 0x00, 0x07, 0x04, 0x03, 0x01 };
-	const u8 recovery[] = { 0x00, 0x06, 0x04, 0x03, 0x03 };
+	static const u8 active[]   = { 0x00, 0x07, 0x04, 0x03, 0x01 };
+	static const u8 recovery[] = { 0x00, 0x06, 0x04, 0x03, 0x03 };
 
 	sis_set_fifo(ap, adev);
 
@@ -267,7 +267,7 @@ static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	int port = sis_old_port_base(adev);
 	int speed = adev->pio_mode - XFER_PIO_0;
 
-	const u8 actrec[] = { 0x00, 0x67, 0x44, 0x33, 0x31 };
+	static const u8 actrec[] = { 0x00, 0x67, 0x44, 0x33, 0x31 };
 
 	sis_set_fifo(ap, adev);
 
@@ -293,14 +293,14 @@ static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	u32 t1;
 	int speed = adev->pio_mode - XFER_PIO_0;
 
-	const u32 timing133[] = {
+	static const u32 timing133[] = {
 		0x28269000,	/* Recovery << 24 | Act << 16 | Ini << 12 */
 		0x0C266000,
 		0x04263000,
 		0x0C0A3000,
 		0x05093000
 	};
-	const u32 timing100[] = {
+	static const u32 timing100[] = {
 		0x1E1C6000,	/* Recovery << 24 | Act << 16 | Ini << 12 */
 		0x091C4000,
 		0x031C2000,
@@ -341,8 +341,8 @@ static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
-	const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
-	const u16 udma_bits[]  = { 0xE000, 0xC000, 0xA000 };
+	static const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
+	static const u16 udma_bits[]  = { 0xE000, 0xC000, 0xA000 };
 
 	pci_read_config_word(pdev, drive_pci, &timing);
 
@@ -381,8 +381,8 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	u16 timing;
 
 	/* MWDMA 0-2 and UDMA 0-5 */
-	const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
-	const u16 udma_bits[]  = { 0xF000, 0xD000, 0xB000, 0xA000, 0x9000, 0x8000 };
+	static const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
+	static const u16 udma_bits[]  = { 0xF000, 0xD000, 0xB000, 0xA000, 0x9000, 0x8000 };
 
 	pci_read_config_word(pdev, drive_pci, &timing);
 
@@ -419,7 +419,7 @@ static void sis_100_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	int drive_pci = sis_old_port_base(adev);
 	u8 timing;
 
-	const u8 udma_bits[]  = { 0x8B, 0x87, 0x85, 0x83, 0x82, 0x81};
+	static const u8 udma_bits[]  = { 0x8B, 0x87, 0x85, 0x83, 0x82, 0x81};
 
 	pci_read_config_byte(pdev, drive_pci + 1, &timing);
 
-- 
1.7.6.1

