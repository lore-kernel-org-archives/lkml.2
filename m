Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031422Ab2HIP6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:58:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37148 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab2HIP5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:57:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH 1/1] drivers/rtc/rtc-ab8500.c: Revoke Device Tree enablement
Date: Thu,  9 Aug 2012 16:57:08 +0100
Message-Id: <1344527828-6283-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
References: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All AB8500 devices are now registered via MFD core, so Device Tree
capability is no longer required for probing. Here we pull the DT
match table to ensure we're no longer probed during Device Tree
start-up.

CC: Alessandro Zummo <a.zummo@towertech.it>
CC: rtc-linux@googlegroups.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rtc/rtc-ab8500.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index bf3c2f6..2e5970f 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -462,16 +462,10 @@ static int __devexit ab8500_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id ab8500_rtc_match[] = {
-	{ .compatible = "stericsson,ab8500-rtc", },
-	{}
-};
-
 static struct platform_driver ab8500_rtc_driver = {
 	.driver = {
 		.name = "ab8500-rtc",
 		.owner = THIS_MODULE,
-		.of_match_table = ab8500_rtc_match,
 	},
 	.probe	= ab8500_rtc_probe,
 	.remove = __devexit_p(ab8500_rtc_remove),
-- 
1.7.9.5

