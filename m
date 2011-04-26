Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1DZNfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:35:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37426 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1DZNfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:35:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eCyGBS5hh6v2qcFIOc7f+8w1B+ZNCD6U03B8N2YZCPI5PRxtKpqU2Z/fAOSDaJLWqk
         cZ1iwJwVNKIG4HNMruF1bNkqz3iP86ezjYr/iH1gbvR5S+e/nYOJboMdUOCbxMf3xuXX
         iiCoycHDvy3PBCuOXfqC0Ko7sJL0qNGSM9pyY=
From: yxlraid@gmail.com
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuxiangl@marvell.com, jfeng@marvell.com,
        root <root@localhost.marvell.com>
Subject: [PATCH 1/2] [PATCH] [SCSI] mvsas: add support for Marvell 88SE9445/88SE9485
Date: Tue, 26 Apr 2011 06:34:01 -0700
Message-Id: <1303824841-6196-1-git-send-email-yxlraid@gmail.com>
X-Mailer: git-send-email 1.7.4.5
In-Reply-To: <mvsas-support-new-device-id>
References: <mvsas-support-new-device-id>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@localhost.marvell.com>

This is support for Marvell 88SE9445/88SE9485 SAS/SATA HBA, which
is based on Marvell 88SE9480.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_defs.h |    2 ++
 drivers/scsi/mvsas/mv_init.c |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index 1849da1..880613f 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -34,6 +34,8 @@ enum chip_flavors {
 	chip_6485,
 	chip_9480,
 	chip_9180,
+	chip_9445,
+	chip_9485,
 	chip_1300,
 	chip_1320
 };
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 938d045..0123c6b 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -32,6 +32,8 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_6485] =	{ 1, 8, 0x800, 33, 32, 10, &mvs_64xx_dispatch, },
 	[chip_9180] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 	[chip_9480] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
+	[chip_9445] =	{ 1, 4, 0x800, 17, 64, 11, &mvs_94xx_dispatch, },
+	[chip_9485] =	{ 2, 4, 0x800, 17, 64, 11, &mvs_94xx_dispatch, },
 	[chip_1300] =	{ 1, 4, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
 	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 };
@@ -670,6 +672,24 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
 	{ PCI_VDEVICE(TTI, 0x2740), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2744), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2760), chip_9480 },
+	{
+		.vendor		= 0x1b4b,
+		.device		= 0x9445,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= 0x9480,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_9445,
+	},
+	{
+		.vendor		= 0x1b4b,
+		.device		= 0x9485,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= 0x9480,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_9485,
+	},
 
 	{ }	/* terminate list */
 };
-- 
1.7.4.4

