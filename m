Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2BUSiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:38:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42881 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab2BUSio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:38:44 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Brian Norris <computersforpeace@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: [PATCH v2 3/3] ahci_platform: add STRICT_AHCI platform type
Date: Tue, 21 Feb 2012 10:38:44 -0800
Message-Id: <1329849524-23758-4-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.5.4.2.g519b1
In-Reply-To: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
References: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms need to make use of the AHCI_HFLAG_DELAY_ENGINE flag.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 drivers/ata/ahci_platform.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 48be4e1..0c86c77 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -26,6 +26,7 @@
 enum ahci_type {
 	AHCI,		/* standard platform ahci */
 	IMX53_AHCI,	/* ahci on i.mx53 */
+	STRICT_AHCI,	/* delayed DMA engine start */
 };
 
 static struct platform_device_id ahci_devtype[] = {
@@ -36,6 +37,9 @@ static struct platform_device_id ahci_devtype[] = {
 		.name = "imx53-ahci",
 		.driver_data = IMX53_AHCI,
 	}, {
+		.name = "strict-ahci",
+		.driver_data = STRICT_AHCI,
+	}, {
 		/* sentinel */
 	}
 };
@@ -56,6 +60,13 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_pmp_retry_srst_ops,
 	},
+	[STRICT_AHCI] = {
+		AHCI_HFLAGS	(AHCI_HFLAG_DELAY_ENGINE),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static struct scsi_host_template ahci_platform_sht = {
