Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab2ARCrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:47:02 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60357 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2ARCrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:47:00 -0500
Message-ID: <1326854812.11831.3.camel@phoenix>
Subject: [PATCH 2/2] watchdog: Return proper error in nuc900wdt_probe if
 misc_register fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Date: Wed, 18 Jan 2012 10:46:52 +0800
In-Reply-To: <1326854720.11831.1.camel@phoenix>
References: <1326854720.11831.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return proper error instead of 0 if misc_register fails

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/nuc900_wdt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index 2cce856..529085b 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -287,7 +287,8 @@ static int __devinit nuc900wdt_probe(struct platform_device *pdev)
 
 	setup_timer(&nuc900_wdt->timer, nuc900_wdt_timer_ping, 0);
 
-	if (misc_register(&nuc900wdt_miscdev)) {
+	ret = misc_register(&nuc900wdt_miscdev);
+	if (ret) {
 		dev_err(&pdev->dev, "err register miscdev on minor=%d (%d)\n",
 			WATCHDOG_MINOR, ret);
 		goto err_clk;
-- 
1.7.5.4



