Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab2HQX4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 19:56:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47331 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471Ab2HQXzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 19:55:44 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: ralf@linux-mips.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] ata: pata_octeon_cf: Use correct byte order for DMA in when built little-endian.
Date: Fri, 17 Aug 2012 16:54:33 -0700
Message-Id: <1345247673-25086-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1345247673-25086-1-git-send-email-ddaney.cavm@gmail.com>
References: <1345247673-25086-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We need to set the 'endian' bit in this case.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/ata/pata_octeon_cf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 652d035..4e1194b 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <scsi/scsi_host.h>
 
+#include <asm/byteorder.h>
 #include <asm/octeon/octeon.h>
 
 /*
@@ -589,6 +590,9 @@ static void octeon_cf_dma_start(struct ata_queued_cmd *qc)
 
 	/* Set the direction of the DMA */
 	mio_boot_dma_cfg.u64 = 0;
+#ifdef __LITTLE_ENDIAN
+	mio_boot_dma_cfg.s.endian = 1;
+#endif
 	mio_boot_dma_cfg.s.en = 1;
 	mio_boot_dma_cfg.s.rw = ((qc->tf.flags & ATA_TFLAG_WRITE) != 0);
 
-- 
1.7.11.2

