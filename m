Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2FRG0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:26:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:63878 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab2FRG0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:26:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181387363"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>,
        Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH v5 08/12] libata: detect Device Attention support
Date: Mon, 18 Jun 2012 14:26:02 +0800
Message-Id: <1340000766-129148-9-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new flag ATA_DFLAG_DA to indicate that device supports "Device
Attention".

Acked-by: Aaron Lu <aaron.lu@amd.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c |    3 +++
 include/linux/ata.h       |    1 +
 include/linux/libata.h    |    2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index cebf18e..ba169c4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2374,6 +2374,9 @@ int ata_dev_configure(struct ata_device *dev)
 			dma_dir_string = ", DMADIR";
 		}
 
+		if (ata_id_has_da(dev->id))
+			dev->flags |= ATA_DFLAG_DA;
+
 		/* print device info to dmesg */
 		if (ata_msg_drv(ap) && print_info)
 			ata_dev_info(dev,
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 32df2b6..5713d3a 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -578,6 +578,7 @@ static inline int ata_is_data(u8 prot)
 	  ((u64) (id)[(n) + 0]) )
 
 #define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG] & 0x60) == 0x20)
+#define ata_id_has_da(id)	((id)[77] & (1 << 4))
 
 static inline bool ata_id_has_hipm(const u16 *id)
 {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 888feef..cc22b943 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -161,6 +161,8 @@ enum {
 	ATA_DFLAG_DETACH	= (1 << 24),
 	ATA_DFLAG_DETACHED	= (1 << 25),
 
+	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
+
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
 	ATA_DEV_ATA_UNSUP	= 2,	/* ATA device (unsupported) */
-- 
1.7.10

