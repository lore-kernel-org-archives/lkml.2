Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1JMNp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:45:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59900 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1JMNpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:45:53 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH v2 1/4] ata_piix: SITRE handling fix
Date: Thu, 13 Oct 2011 15:28:30 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201110131528.30789.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2] ata_piix: SITRE handling fix

Set SITRE (separate slave timing register) bit also in master-only
configurations to match other PIIX-alike drivers and make further
changes easier.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
v2: updated patch description

earlier references:
https://lkml.org/lkml/2011/2/8/98

 drivers/ata/ata_piix.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -750,8 +750,6 @@ static void piix_set_timings(struct ata_
 	if (is_slave) {
 		/* clear TIME1|IE1|PPE1|DTE1 */
 		master_data &= 0xff0f;
-		/* Enable SITRE (separate slave timing register) */
-		master_data |= 0x4000;
 		/* enable PPE1, IE1 and TIME1 as needed */
 		master_data |= (control << 4);
 		pci_read_config_byte(dev, slave_port, &slave_data);
@@ -769,6 +767,9 @@ static void piix_set_timings(struct ata_
 			(timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
 	}
+
+	/* Enable SITRE (separate slave timing register) */
+	master_data |= 0x4000;
 	pci_write_config_word(dev, master_port, master_data);
 	if (is_slave)
 		pci_write_config_byte(dev, slave_port, slave_data);
