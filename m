Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2BTUKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:10:30 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33447 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab2BTUKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:10:20 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kevin Cernekee <cernekee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: [PATCH 3/3] ahci_platform: add STRICT_AHCI platform type
Date: Mon, 20 Feb 2012 12:09:23 -0800
Message-Id: <1329768563-13715-4-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.5.4.2.g519b1
In-Reply-To: <1329768563-13715-1-git-send-email-computersforpeace@gmail.com>
References: <1329768563-13715-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms need to make use of the AHCI_HFLAG_STRICT_SPEC flag.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 drivers/ata/ahci_platform.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 48be4e1..50688c4 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -26,6 +26,7 @@
 enum ahci_type {
 	AHCI,		/* standard platform ahci */
 	IMX53_AHCI,	/* ahci on i.mx53 */
+	STRICT_AHCI,	/* stricter AHCI specification */
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
+		AHCI_HFLAGS	(AHCI_HFLAG_STRICT_SPEC),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static struct scsi_host_template ahci_platform_sht = {
