Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3AHSQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:16:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab3AHSQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:16:35 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=u7sprdIQ6Ji5RI4IF99lyg==:17 a=hZn9VFtz8_IA:10 a=6mGWT7em0uEA:10 a=nDghuxUhq_wA:10 a=pGLkceISAAAA:8 a=pvZw4ii1myEA:10 a=Wwd_vTjcR3wv8VJzz1AA:9 a=MSl-tDqOz04A:10 a=u7sprdIQ6Ji5RI4IF99lyg==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.75.21.239
From: Joshua Coombs <josh.coombs@gmail.com>
To: cooloney@gmail.com, rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgarzik@pobox.com,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joshua Coombs <josh.coombs@gmail.com>
Subject: [PATCH] Allow Marvell SATA driver to work with LEDS_TRIGGER_IDE_DISK
Date: Tue,  8 Jan 2013 13:16:27 -0500
Message-Id: <1357668987-3610-1-git-send-email-josh.coombs@gmail.com>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a call to the IDE LED Trigger within the Marvell SATA driver to allow
Marvell SoC devices to show SATA activity via GPIO connected LEDs.

Signed-off-by: Joshua Coombs <josh.coombs@gmail.com>
---
 drivers/ata/sata_mv.c | 3 +++
 drivers/leds/Kconfig  | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 68f4fb5..4aaf6f0 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -71,6 +71,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <linux/libata.h>
+#include <linux/leds.h>
 
 #define DRV_NAME	"sata_mv"
 #define DRV_VERSION	"1.28"
@@ -1156,6 +1157,8 @@ static void mv_start_edma(struct ata_port *ap, void __iomem *port_mmio,
 {
 	int want_ncq = (protocol == ATA_PROT_NCQ);
 
+	ledtrig_ide_activity();
+
 	if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
 		int using_ncq = ((pp->pp_flags & MV_PP_FLAG_NCQ_EN) != 0);
 		if (want_ncq != using_ncq)
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index b58bc8a..d2071d0 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -496,10 +496,9 @@ config LEDS_TRIGGER_ONESHOT
 
 config LEDS_TRIGGER_IDE_DISK
 	bool "LED IDE Disk Trigger"
-	depends on IDE_GD_ATA
 	depends on LEDS_TRIGGERS
 	help
-	  This allows LEDs to be controlled by IDE disk activity.
+	  This allows LEDs to be controlled by IDE or SATA disk activity.
 	  If unsure, say Y.
 
 config LEDS_TRIGGER_HEARTBEAT
-- 
1.8.0.2

