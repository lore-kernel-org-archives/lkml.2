Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1LAIh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:37:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37923 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1LAIhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:37:23 -0500
Message-ID: <1322728636.14554.4.camel@phoenix>
Subject: [PATCH 1/2] leds: bd2802: Use gpio_request_one()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kim Kyuwon <q1.kim@samsung.com>, Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
Date: Thu, 01 Dec 2011 16:37:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio_request_one() instead of multiple gpiolib calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-bd2802.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 10e40971..591cbdf 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -688,8 +688,7 @@ static int __devinit bd2802_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, led);
 
 	/* Configure RESET GPIO (L: RESET, H: RESET cancel) */
-	gpio_request(pdata->reset_gpio, "RGB_RESETB");
-	gpio_direction_output(pdata->reset_gpio, 1);
+	gpio_request_one(pdata->reset_gpio, GPIOF_OUT_INIT_HIGH, "RGB_RESETB");
 
 	/* Tacss = min 0.1ms */
 	udelay(100);
-- 
1.7.5.4



