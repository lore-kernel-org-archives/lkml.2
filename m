Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1ASJry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:47:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33455 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1ASJrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:47:53 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds: make *struct gpio_led_platform_data.leds const
Date: Wed, 19 Jan 2011 10:47:46 +0100
Message-Id: <1295430466-3250-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and fix a typo.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/leds/leds-net5501.c |    2 +-
 include/linux/leds.h        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-net5501.c b/drivers/leds/leds-net5501.c
index 1739557..7e764b8 100644
--- a/drivers/leds/leds-net5501.c
+++ b/drivers/leds/leds-net5501.c
@@ -19,7 +19,7 @@
 
 #include <asm/geode.h>
 
-static struct gpio_led net5501_leds[] = {
+static const struct gpio_led net5501_leds[] = {
 	{
 		.name = "error",
 		.gpio = 6,
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 0f19df9..383811d 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -194,11 +194,11 @@ struct gpio_led {
 
 struct gpio_led_platform_data {
 	int 		num_leds;
-	struct gpio_led *leds;
+	const struct gpio_led *leds;
 
 #define GPIO_LED_NO_BLINK_LOW	0	/* No blink GPIO state low */
 #define GPIO_LED_NO_BLINK_HIGH	1	/* No blink GPIO state high */
-#define GPIO_LED_BLINK		2	/* Plase, blink */
+#define GPIO_LED_BLINK		2	/* Please, blink */
 	int		(*gpio_blink_set)(unsigned gpio, int state,
 					unsigned long *delay_on,
 					unsigned long *delay_off);
-- 
1.7.2.3

