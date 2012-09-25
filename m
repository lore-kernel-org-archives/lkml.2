Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2IYMHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:07:34 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:60514 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755956Ab2IYMHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:07:33 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        haojian.zhuang@gmail.com
Cc: linux-kernel@vger.kernel.org, Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] GPIO: gpio-pxa: fix bug when get gpio value
Date: Tue, 25 Sep 2012 20:03:42 +0800
Message-Id: <1348574622-11632-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 25 Sep 2012 12:03:46.0309 (UTC) FILETIME=[D0C96350:01CD9B15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to return 0 or 1 when get gpio value.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/gpio/gpio-pxa.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index 9cac88a..1f9a058 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -269,7 +269,10 @@ static int pxa_gpio_direction_output(struct gpio_chip *chip,
 
 static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	return readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET) & (1 << offset);
+	u32 gplr = __raw_readl(gpio_chip_base(chip) + GPLR_OFFSET);
+	u32 mask = 1 << offset;
+
+	return (gplr & mask) != 0;
 }
 
 static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-- 
1.7.4.1

