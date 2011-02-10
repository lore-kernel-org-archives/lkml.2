Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1BJVLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:11:32 -0500
Received: from t111.niisi.ras.ru ([193.232.173.111]:39065 "EHLO
	t111.niisi.ras.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab1BJVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:11:31 -0500
X-Greylist: delayed 720 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Feb 2011 16:11:31 EST
From: Antony Pavlov <antony@niisi.msk.ru>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antony@niisi.msk.ru>
Subject: [PATCH] mtd: cfi_cmdset_0002: fix sector erase command for AM29LV040B
Date: Fri, 11 Feb 2011 00:04:37 +0300
Message-Id: <1297371877-32123-1-git-send-email-antony@niisi.msk.ru>
X-Mailer: git-send-email 1.7.1
X-Antivirus: Dr.Web (R) for Mail Servers on t111.niisi.ras.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AM29LV040B chips use 0x50 as sector erase command instead of 0x30 [1].

[1] http://www.datasheetcatalog.com/datasheets_pdf/A/M/2/9/AM29LV040B.shtml

Signed-off-by: Antony Pavlov <antony@niisi.msk.ru>
---
 drivers/mtd/chips/cfi_cmdset_0002.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index f072fcf..a401dbe 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -332,6 +332,14 @@ static void fixup_s29gl032n_sectors(struct mtd_info *mtd)
 	}
 }
 
+static void fixup_use_sector_erase_cmd_30(struct mtd_info *mtd)
+{
+	struct map_info *map = mtd->priv;
+	struct cfi_private *cfi = map->fldrv_priv;
+
+	cfi->sector_erase_cmd = CMD(0x30);
+}
+
 /* Used to fix CFI-Tables of chips without Extended Query Tables */
 static struct cfi_fixup cfi_nopri_fixup_table[] = {
 	{ CFI_MFR_SST, 0x234a, fixup_sst39vf }, /* SST39VF1602 */
@@ -374,6 +382,7 @@ static struct cfi_fixup jedec_fixup_table[] = {
 	{ CFI_MFR_SST, SST49LF004B, fixup_use_fwh_lock },
 	{ CFI_MFR_SST, SST49LF040B, fixup_use_fwh_lock },
 	{ CFI_MFR_SST, SST49LF008A, fixup_use_fwh_lock },
+	{ CFI_MFR_AMD, 0x004F, fixup_use_sector_erase_cmd_30 }, /* AM29LV040B */
 	{ 0, 0, NULL }
 };
 
-- 
1.7.1

