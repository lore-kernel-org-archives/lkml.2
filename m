Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab0IGNcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:32:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35809 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab0IGNb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b0aQHoKKhV/IPPOnsGZ9vTaH4qIpe4mWhQJe7v/mMO0Qg5qB8ztCDAjsx16wAFfLxG
         oG9gSSrB3FBDlJ2h8+LKpDXlEYjAUAS+d/RO/q5ORlv+/MSAPS4pwtxLrGtJ5oZDNapn
         bfPWoUKZGX+nXTwLSERSANtuGbARoGqU8K74o=
Date: Tue, 7 Sep 2010 17:31:54 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] base/platform: Simplifications for NULL platform
 data/resources handling
Message-ID: <20100907133154.GB28139@oksana.dev.rtsoft.ru>
References: <20100907133107.GA21463@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100907133107.GA21463@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to explicitly check for data and resources being NULL,
as platform_device_add_{data,resources}() do this internally nowadays.

This makes the code more linear and less indented.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/base/platform.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 67519cd..716d563 100644
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
1.7.0.5
