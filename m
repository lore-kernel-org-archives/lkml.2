Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab2DRHcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:32:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38828 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab2DRHck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:32:40 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <santoshsy@gmail.com>,
        <linkinjeon@gmail.com>, Venkatraman S <svenkatr@ti.com>
Subject: [PATCH RESEND 1/2] scsi/ufs: reverse the ufshcd_is_device_present logic
Date: Wed, 18 Apr 2012 13:08:35 +0530
Message-ID: <1334734715-13584-1-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise it counter intuitively returns 0 if device is present.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/scsi/ufs/ufshcd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52b96e8..aa97200 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -232,11 +232,11 @@ static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
  *			      the host controller
  * @reg_hcs - host controller status register value
  *
- * Returns 0 if device present, non-zero if no device detected
+ * Returns 1 if device present, 0 if no device detected
  */
 static inline int ufshcd_is_device_present(u32 reg_hcs)
 {
-	return (DEVICE_PRESENT & reg_hcs) ? 0 : -1;
+	return (DEVICE_PRESENT & reg_hcs) ? 1 : 0;
 }
 
 /**
@@ -911,7 +911,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 
 	/* check if device present */
 	reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
-	if (ufshcd_is_device_present(reg)) {
+	if (!ufshcd_is_device_present(reg)) {
 		dev_err(&hba->pdev->dev, "cc: Device not present\n");
 		err = -ENXIO;
 		goto out;
-- 
1.7.5.4

