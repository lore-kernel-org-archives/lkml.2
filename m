Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1I1Qe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:34:57 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55713 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1I1Qe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:34:56 -0400
From: yxlraid@gmail.com
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com,
        dan.j.williams@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>
Subject: [PATCH 4/8] [SCSI] mvsas: fixed wrong destination when hiting NAK for command frame
Date: Thu, 29 Sep 2011 00:34:11 -0700
Message-Id: <4e834cae.e515440a.102b.0e75@mx.google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <mvsas>
References: <mvsas>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

-- disable non data frame retry

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_94xx.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 8f32c7c..ca2b9d9 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -398,6 +398,17 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	/* init phys */
 	mvs_phy_hacks(mvi);
 
+	/* disable non data frame retry */
+	tmp = mvs_cr32(mvi, CMD_SAS_CTL1);
+	if((revision == VANIR_A0_REV) ||
+		(revision == VANIR_B0_REV) ||
+		(revision == VANIR_C0_REV))
+	{
+		tmp &= ~0xffff;
+		tmp |= 0x007f;
+		mvs_cw32(mvi, CMD_SAS_CTL1, tmp);
+	}
+
 	/* set LED blink when IO*/
 	mw32(MVS_PA_VSR_ADDR, VSR_PHY_ACT_LED);
 	tmp = mr32(MVS_PA_VSR_PORT);
-- 
1.7.4.4

