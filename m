Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab2ESH7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 03:59:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54680 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362Ab2ESH7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 03:59:08 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-mmc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH] mmc: core: Fix build warning with !CONFIG_SUSPEND
Date: Sat, 19 May 2012 13:28:39 +0530
Message-ID: <1337414319-27719-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With !CONFIG_SUSPEND, mmc core layer throws below build warnings.

drivers/mmc/core/bus.c:125: warning: 'mmc_bus_suspend' defined but not used
drivers/mmc/core/bus.c:136: warning: 'mmc_bus_resume' defined but not used
drivers/mmc/core/sdio_bus.c:197: warning: 'pm_no_operation' defined but not used

Fix is by wrapping suspend hooks under CONFIG_SUSPEND

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/core/bus.c      |    2 ++
 drivers/mmc/core/sdio_bus.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index c60cee9..ca8925d 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -122,6 +122,7 @@ static int mmc_bus_remove(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_SUSPEND
 static int mmc_bus_suspend(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
@@ -143,6 +144,7 @@ static int mmc_bus_resume(struct device *dev)
 		ret = drv->resume(card);
 	return ret;
 }
+#endif
 
 #ifdef CONFIG_PM_RUNTIME
 
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 236842e..87d1b7e 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -192,7 +192,7 @@ static int sdio_bus_remove(struct device *dev)
 	return ret;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_SUSPEND
 
 static int pm_no_operation(struct device *dev)
 {
-- 
1.7.5.4

