Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1I1QdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:33:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37466 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1I1QdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:33:24 -0400
From: yxlraid@gmail.com
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com,
        dan.j.williams@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>
Subject: [PATCH 1/8] [SCSI] mvsas: fix expander link error
Date: Thu, 29 Sep 2011 00:32:37 -0700
Message-Id: <4e834c52.6539440a.62a1.fffffe53@mx.google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <mvsas>
References: <mvsas>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

-- fix expander link error

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_sas.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 4958fef..86847c6 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -426,7 +426,7 @@ static int mvs_task_prep_smp(struct mvs_info *mvi,
 	/* generate open address frame hdr (first 12 bytes) */
 	/* initiator, SMP, ftype 1h */
 	buf_oaf[0] = (1 << 7) | (PROTOCOL_SMP << 4) | 0x01;
-	buf_oaf[1] = dev->linkrate & 0xf;
+	buf_oaf[1] = min(sas_port->linkrate, dev->linkrate) & 0xf;
 	*(u16 *)(buf_oaf + 2) = 0xFFFF;		/* SAS SPEC */
 	memcpy(buf_oaf + 4, dev->sas_addr, SAS_ADDR_SIZE);
 
@@ -571,7 +571,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	/* generate open address frame hdr (first 12 bytes) */
 	/* initiator, STP, ftype 1h */
 	buf_oaf[0] = (1 << 7) | (PROTOCOL_STP << 4) | 0x1;
-	buf_oaf[1] = dev->linkrate & 0xf;
+	buf_oaf[1] = min(sas_port->linkrate, dev->linkrate) & 0xf;
 	*(u16 *)(buf_oaf + 2) = cpu_to_be16(mvi_dev->device_id + 1);
 	memcpy(buf_oaf + 4, dev->sas_addr, SAS_ADDR_SIZE);
 
@@ -679,7 +679,7 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	/* generate open address frame hdr (first 12 bytes) */
 	/* initiator, SSP, ftype 1h */
 	buf_oaf[0] = (1 << 7) | (PROTOCOL_SSP << 4) | 0x1;
-	buf_oaf[1] = dev->linkrate & 0xf;
+	buf_oaf[1] = min(sas_port->linkrate, dev->linkrate) & 0xf;
 	*(u16 *)(buf_oaf + 2) = cpu_to_be16(mvi_dev->device_id + 1);
 	memcpy(buf_oaf + 4, dev->sas_addr, SAS_ADDR_SIZE);
 
-- 
1.7.4.4

