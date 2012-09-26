Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab2IZBs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 21:48:58 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:48858 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab2IZBs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 21:48:57 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        haojian.zhuang@gmail.com
Cc: linux-kernel@vger.kernel.org, Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH V2] GPIO: gpio-pxa: fix bug when get gpio value
Date: Wed, 26 Sep 2012 09:46:47 +0800
Message-Id: <1348624007-16634-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 26 Sep 2012 01:46:48.0955 (UTC) FILETIME=[CB232CB0:01CD9B88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to return 0 or 1 when get gpio value.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/gpio/gpio-pxa.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index 9cac88a..3c9dc8c 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -269,7 +269,9 @@ static int pxa_gpio_direction_output(struct gpio_chip *chip,
 
 static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	return readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET) & (1 << offset);
+	u32 gplr = readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET);
+
+	return (gplr & (1 << offset)) ? 1 : 0;
 }
 
 static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-- 
1.7.4.1

