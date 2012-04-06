Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2DFFVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 01:21:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42625 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab2DFFVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 01:21:37 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Venkatraman S <svenkatr@ti.com>, Santosh Y <santoshsy@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] scsi/ufs: reverse the ufshcd_is_device_present logic
Date: Fri, 6 Apr 2012 10:57:08 +0530
Message-ID: <1333690029-4991-1-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Otherwise it counter intuitively returns 0 if device is present.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
CC: Santosh Y <santoshsy@gmail.com>
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

