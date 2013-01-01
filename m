Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3AAIIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 03:08:09 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:64140 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3AAIII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 03:08:08 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] mmc: vt8500: Remove __devexit attribute on .remove
Date: Tue,  1 Jan 2013 21:08:03 +1300
Message-Id: <1357027683-26992-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the changes to HOTPLUG merged for 3.8, this attribute is
no longer required and results in a warning at compile time.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/mmc/host/wmt-sdmmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index 5ba4605..3a7ce57 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -892,7 +892,7 @@ fail1:
 	return ret;
 }
 
-static int __devexit wmt_mci_remove(struct platform_device *pdev)
+static int wmt_mci_remove(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
 	struct wmt_mci_priv *priv;
@@ -1012,7 +1012,7 @@ static const struct dev_pm_ops wmt_mci_pm = {
 
 static struct platform_driver wmt_mci_driver = {
 	.probe = wmt_mci_probe,
-	.remove = __exit_p(wmt_mci_remove),
+	.remove = wmt_mci_remove,
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
-- 
1.7.9.5

