Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2ITL6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:58:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59417 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab2ITL6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:58:31 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, devel@driverdev.osuosl.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/rts_pstor: Delete some lines (dev_info() and dev_err()) in rtsx.c
Date: Thu, 20 Sep 2012 20:58:20 +0900
Message-Id: <1348142300-5038-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed some coccinelle warnings.
+ drivers/staging/rts_pstor/rtsx.c:397:16-19: ERROR: dev is NULL but dereferenced.
  drivers/staging/rts_pstor/rtsx.c:447:16-19: ERROR: dev is NULL but dereferenced.
  drivers/staging/rts_pstor/rtsx.c:358:16-19: ERROR: dev is NULL but dereferenced.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/rtsx.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 213829e..afe9c2e 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -352,12 +352,8 @@ static int rtsx_suspend(struct pci_dev *pci, pm_message_t state)
 	struct rtsx_dev *dev = (struct rtsx_dev *)pci_get_drvdata(pci);
 	struct rtsx_chip *chip;
 
-	dev_info(&dev->pci->dev, "Ready to suspend\n");
-
-	if (!dev) {
-		dev_err(&dev->pci->dev, "Invalid memory\n");
+	if (!dev)
 		return 0;
-	}
 
 	/* lock the device pointers */
 	mutex_lock(&(dev->dev_mutex));
@@ -391,12 +387,8 @@ static int rtsx_resume(struct pci_dev *pci)
 	struct rtsx_dev *dev = (struct rtsx_dev *)pci_get_drvdata(pci);
 	struct rtsx_chip *chip;
 
-	dev_info(&dev->pci->dev, "Ready to resume\n");
-
-	if (!dev) {
-		dev_err(&dev->pci->dev, "Invalid memory\n");
+	if (!dev)
 		return 0;
-	}
 
 	chip = dev->chip;
 
@@ -441,12 +433,8 @@ static void rtsx_shutdown(struct pci_dev *pci)
 	struct rtsx_dev *dev = (struct rtsx_dev *)pci_get_drvdata(pci);
 	struct rtsx_chip *chip;
 
-	dev_info(&dev->pci->dev, "Ready to shutdown\n");
-
-	if (!dev) {
-		dev_err(&dev->pci->dev, "Invalid memory\n");
+	if (!dev)
 		return;
-	}
 
 	chip = dev->chip;
 
-- 
1.7.9.5

