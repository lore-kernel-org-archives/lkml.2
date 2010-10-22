Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab0JVSar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:30:47 -0400
Received: from kroah.org ([198.145.64.141]:37785 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758937Ab0JVSZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/31] base/platform: Simplifications for NULL platform data/resources handling
Date: Fri, 22 Oct 2010 11:24:56 -0700
Message-Id: <1287771916-15016-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <cbouatmailru@gmail.com>

There's no need to explicitly check for data and resources being NULL,
as platform_device_add_{data,resources}() do this internally nowadays.

This makes the code more linear and less indented.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c794fec..3966e62 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -380,17 +380,13 @@ struct platform_device *__init_or_module platform_device_register_resndata(
 
 	pdev->dev.parent = parent;
 
-	if (res) {
-		ret = platform_device_add_resources(pdev, res, num);
-		if (ret)
-			goto err;
-	}
+	ret = platform_device_add_resources(pdev, res, num);
+	if (ret)
+		goto err;
 
-	if (data) {
-		ret = platform_device_add_data(pdev, data, size);
-		if (ret)
-			goto err;
-	}
+	ret = platform_device_add_data(pdev, data, size);
+	if (ret)
+		goto err;
 
 	ret = platform_device_add(pdev);
 	if (ret) {
@@ -537,17 +533,13 @@ struct platform_device * __init_or_module platform_create_bundle(
 		goto err_out;
 	}
 
-	if (res) {
-		error = platform_device_add_resources(pdev, res, n_res);
-		if (error)
-			goto err_pdev_put;
-	}
+	error = platform_device_add_resources(pdev, res, n_res);
+	if (error)
+		goto err_pdev_put;
 
-	if (data) {
-		error = platform_device_add_data(pdev, data, size);
-		if (error)
-			goto err_pdev_put;
-	}
+	error = platform_device_add_data(pdev, data, size);
+	if (error)
+		goto err_pdev_put;
 
 	error = platform_device_add(pdev);
 	if (error)
-- 
1.7.2

