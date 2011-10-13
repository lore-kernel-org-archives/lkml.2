Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1JMLRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:17:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39208 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab1JMLRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:17:14 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_ali: cleanup ali_set_piomode()
Date: Thu, 13 Oct 2011 13:09:25 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131309.26032.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_ali: cleanup ali_set_piomode()

Merge ali_fifo_control() calls.

This changes behavior but there shouldn't be any problems with it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2010/1/18/258

 drivers/ata/pata_ali.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -222,12 +222,9 @@ static void ali_set_piomode(struct ata_p
 	}
 
 	/* PIO FIFO is only permitted on ATA disk */
-	if (adev->class != ATA_DEV_ATA)
-		ali_fifo_control(ap, adev, 0x00);
-	ali_program_modes(ap, adev, &t, 0);
-	if (adev->class == ATA_DEV_ATA)
-		ali_fifo_control(ap, adev, 0x05);
+	ali_fifo_control(ap, adev, (adev->class == ATA_DEV_ATA) ? 0x05 : 0x00);
 
+	ali_program_modes(ap, adev, &t, 0);
 }
 
 /**
