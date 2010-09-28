Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab0I1KgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:36:05 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:45035 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115Ab0I1KgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:36:02 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <lars@metafoo.de>, <akpm@linux-foundation.org>, <kernel@pengutronix.de>,
        <philipp.zabel@gmail.com>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <eric.y.miao@gmail.com>, <rpurdie@rpsys.net>,
        <sameo@linux.intel.com>, <kgene.kim@samsung.com>,
        <linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <arun.murthy@stericsson.com>,
        <STEricsson_nomadik_linux@list.st.com>
Subject: [PATCH 3/7] leds: pwm: add a new element 'name' to platform data
Date: Tue, 28 Sep 2010 16:05:30 +0530
Message-ID: <1285670134-18063-4-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com>
References: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new element 'name' is added to pwm led platform data structure.
This is required to identify the pwm device.

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/leds/leds-pwm.c  |    4 +++-
 include/linux/leds_pwm.h |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index da3fa8d..8da2be6 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -66,8 +66,10 @@ static int led_pwm_probe(struct platform_device *pdev)
 		cur_led = &pdata->leds[i];
 		led_dat = &leds_data[i];
 
+		if (!pdata->name)
+			pdata->name = cur_led->name;
 		led_dat->pwm = pwm_request(cur_led->pwm_id,
-				cur_led->name);
+				pdata->name);
 		if (IS_ERR(led_dat->pwm)) {
 			dev_err(&pdev->dev, "unable to request PWM %d\n",
 					cur_led->pwm_id);
diff --git a/include/linux/leds_pwm.h b/include/linux/leds_pwm.h
index 33a0711..7a847a0 100644
--- a/include/linux/leds_pwm.h
+++ b/include/linux/leds_pwm.h
@@ -16,6 +16,7 @@ struct led_pwm {
 struct led_pwm_platform_data {
 	int			num_leds;
 	struct led_pwm	*leds;
+	char *name;
 };
 
 #endif
-- 
1.7.2.dirty

