Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0IMTsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1871 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0IMTsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:25 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH 05/25] drivers/i2c: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:43 -0700
Message-Id: <b0c83cb1b42c6adf38f6322066fb457693f7ac3b.1284406638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/i2c/busses/i2c-stu300.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
index 495be45..2f7c09c 100644
--- a/drivers/i2c/busses/i2c-stu300.c
+++ b/drivers/i2c/busses/i2c-stu300.c
@@ -871,7 +871,7 @@ stu300_probe(struct platform_device *pdev)
 	struct resource *res;
 	int bus_nr;
 	int ret = 0;
-	char clk_name[] = "I2C0";
+	char clk_name[sizeof("I2Cx")];
 
 	dev = kzalloc(sizeof(struct stu300_dev), GFP_KERNEL);
 	if (!dev) {
@@ -881,7 +881,7 @@ stu300_probe(struct platform_device *pdev)
 	}
 
 	bus_nr = pdev->id;
-	clk_name[3] += (char)bus_nr;
+	sprintf(clk_name, "I2C%c", '0' + bus_nr);
 	dev->clk = clk_get(&pdev->dev, clk_name);
 	if (IS_ERR(dev->clk)) {
 		ret = PTR_ERR(dev->clk);
-- 
1.7.3.rc1

