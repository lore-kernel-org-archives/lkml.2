Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1JMNUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:20:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57043 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab1JMNUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:20:50 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] libata: make ata_sff_data_xfer_noirq() work with 32-bit PIO
Date: Thu, 13 Oct 2011 15:04:43 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131504.43311.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: make ata_sff_data_xfer_noirq() work with 32-bit PIO

Always use ata_sff_data_xfer32() in ata_sff_data_xfer_noirq()
so the latter can be also used for host controllers supporting
32-bit PIO operations.

It is a completely safe thing to do because if 32-bit PIO is
not supported or enabled ata_sff_data_xfer32() will fallback
to a standard method.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2009/11/25/335

 drivers/ata/libata-sff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/libata-sff.c
===================================================================
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -838,7 +838,7 @@ unsigned int ata_sff_data_xfer_noirq(str
 	unsigned int consumed;
 
 	local_irq_save(flags);
-	consumed = ata_sff_data_xfer(dev, buf, buflen, rw);
+	consumed = ata_sff_data_xfer32(dev, buf, buflen, rw);
 	local_irq_restore(flags);
 
 	return consumed;
