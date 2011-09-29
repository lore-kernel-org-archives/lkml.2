Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1I1QfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:35:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49135 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1I1QfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:35:17 -0400
From: yxlraid@gmail.com
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com,
        dan.j.williams@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>
Subject: [PATCH 5/8] [SCSI] mvsas: change SL mode0 register value
Date: Thu, 29 Sep 2011 00:34:32 -0700
Message-Id: <4e834cc3.280d440a.5c55.19fb@mx.google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <mvsas>
References: <mvsas>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

-- change connection behavior
-- set bit8 to 1 for performance tuning
-- set bit0 to 0 to enable retry for no_dest reject case.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_94xx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index ca2b9d9..4d1a8c7 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -511,6 +511,14 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	tmp |= CINT_PHY_MASK;
 	mw32(MVS_INT_MASK, tmp);
 
+	/* change the connection open-close behavior (bit 9) 
+	 * set bit8 to 1 for performance tuning */
+	tmp = mvs_cr32(mvi, CMD_SL_MODE0);
+	tmp |= 0x00000300;
+	/* set bit0 to 0 to enable retry for no_dest reject case */
+	tmp &= 0xFFFFFFFE;
+	mvs_cw32(mvi, CMD_SL_MODE0, tmp);
+
 	/* Enable SRS interrupt */
 	mw32(MVS_INT_MASK_SRS_0, 0xFFFF);
 
-- 
1.7.4.4

