Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2GRQlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:41:50 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34529 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab2GRQlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:41:46 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/3] rtc/rtc-88pm80x: assign ret only when rtc_register_driver fails
Date: Wed, 18 Jul 2012 22:10:36 +0530
Message-Id: <1342629636-12745-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the probe we are assigning ret to return value of PTR_ERR right
after the rtc_register_driver, as we would have done it in the
if (IS_ERR(ptr)) check, since the function fails and goes inside
that case

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/rtc/rtc-88pm80x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index a2f956d..7e050b4 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -314,8 +314,8 @@ static int __devinit pm80x_rtc_probe(struct platform_device *pdev)
 
 	info->rtc_dev = rtc_device_register("88pm80x-rtc", &pdev->dev,
 					    &pm80x_rtc_ops, THIS_MODULE);
-	ret = PTR_ERR(info->rtc_dev);
 	if (IS_ERR(info->rtc_dev)) {
+		ret = PTR_ERR(info->rtc_dev);
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
 		goto out_rtc;
 	}
-- 
1.7.0.4

