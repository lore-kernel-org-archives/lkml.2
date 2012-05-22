Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2EVIy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:54:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62323 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab2EVIyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:54:24 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: a.zummo@towertech.it, ben@simtec.co.uk, akpm@linux-foundation.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] s3c-rtc: Fix compiler warning
Date: Tue, 22 May 2012 14:13:19 +0530
Message-Id: <1337676199-350-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the below warning:
rtc-s3c.c:673:32: warning: ‘s3c_rtc_drv_data_array’ defined but not used [-Wunused-variable]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/rtc/rtc-s3c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 3f3a297..7e6af0b 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -670,6 +670,7 @@ static int s3c_rtc_resume(struct platform_device *pdev)
 #define s3c_rtc_resume  NULL
 #endif
 
+#ifdef CONFIG_OF
 static struct s3c_rtc_drv_data s3c_rtc_drv_data_array[] = {
 	[TYPE_S3C2410] = { TYPE_S3C2410 },
 	[TYPE_S3C2416] = { TYPE_S3C2416 },
@@ -677,7 +678,6 @@ static struct s3c_rtc_drv_data s3c_rtc_drv_data_array[] = {
 	[TYPE_S3C64XX] = { TYPE_S3C64XX },
 };
 
-#ifdef CONFIG_OF
 static const struct of_device_id s3c_rtc_dt_match[] = {
 	{
 		.compatible = "samsung,s3c2410-rtc",
-- 
1.7.4.1

