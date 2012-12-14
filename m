Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab2LNQUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:20:04 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54365 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab2LNQUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/21] gpio: ab8500: Fix gpio offset bounds for irq mapping
Date: Fri, 14 Dec 2012 16:19:26 +0000
Message-Id: <1355501979-1157-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

AB8500 gpio numbers start from 1 and not 0 so the offset
0 represents gpio 1. Fixing cluster bounds accordingly for
irq mappings.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index d3bbcce..a0253ad 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -174,9 +174,9 @@ static int ab8500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 		int start;
 		int end;
 	} clusters[] = {
-		{.start = 6,  .end = 13},
-		{.start = 24, .end = 25},
-		{.start = 36, .end = 41},
+		{.start = 5,  .end = 12}, /* GPIO numbers start from 1 */
+		{.start = 23, .end = 24},
+		{.start = 35, .end = 40},
 	};
 	struct ab8500_gpio *ab8500_gpio = to_ab8500_gpio(chip);
 	int base = ab8500_gpio->irq_base;
-- 
1.7.9.5

