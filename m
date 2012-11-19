Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2KSJGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:06:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58456 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab2KSJGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:06:39 -0500
From: Daniel J Blueman <daniel@quora.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] AHCI: fix build warning when PM && !PM_SLEEP
Date: Mon, 19 Nov 2012 17:06:26 +0800
Message-Id: <1353315986-27317-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the conditional around ahci_suspend/resume to the same as the
SIMPLE_DEV_PM_OPS macro that uses these functions, fixing an unused build
warning.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 drivers/ata/ahci_platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index b1ae480..b7078af 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -238,7 +238,7 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ahci_suspend(struct device *dev)
 {
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
-- 
1.7.10.4

