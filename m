Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab1KGPp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:45:27 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43092 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab1KGPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:44:46 -0500
From: Jonathan Cameron <jic23@kernel.org>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        lars@metafoo.de, maxime.ripard@free-electrons.com,
        lm-sensors@lm-sensors.org, thomas.petazzoni@free-electrons.com,
        zdevai@gmail.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 5/5] stargate2: example of map configuration for iio to hwmon example.
Date: Mon,  7 Nov 2011 15:44:41 +0000
Message-Id: <1320680681-5635-6-git-send-email-jic23@kernel.org>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1320680681-5635-1-git-send-email-jic23@kernel.org>
References: <1320680681-5635-1-git-send-email-jic23@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

Do not commit.
---
 arch/arm/mach-pxa/stargate2.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
index 4c9a48b..25a69c7 100644
--- a/arch/arm/mach-pxa/stargate2.c
+++ b/arch/arm/mach-pxa/stargate2.c
@@ -54,6 +54,8 @@
 #include <linux/mfd/da903x.h>
 #include <linux/sht15.h>
 
+#include <linux/iio/inkern.h>
+
 #include "devices.h"
 #include "generic.h"
 
@@ -406,6 +408,24 @@ static struct i2c_pxa_platform_data i2c_pdata = {
 	.fast_mode = 1,
 };
 
+static struct platform_device iio_hwmon_test = {
+	.name = "iio_hwmon",
+};
+
+static struct iio_map adc_map[] = {
+	{
+		.adc_dev_name = "0-0035",
+		.adc_channel_label = "AIN1",
+		.consumer_dev = &iio_hwmon_test.dev,
+		.consumer_channel = "testchan1",
+	}, {
+		.adc_dev_name = "0-0035",
+		.adc_channel_label = "AIN2",
+		.consumer_dev = &iio_hwmon_test.dev,
+		.consumer_channel = "testchan2",
+	},
+};
+
 static void __init imote2_stargate2_init(void)
 {
 
@@ -423,6 +443,8 @@ static void __init imote2_stargate2_init(void)
 
 	pxa27x_set_i2c_power_info(&i2c_pwr_pdata);
 	pxa_set_i2c_info(&i2c_pdata);
+
+	iio_map_array_register(adc_map, ARRAY_SIZE(adc_map));
 }
 
 #ifdef CONFIG_MACH_INTELMOTE2
@@ -971,6 +993,7 @@ static struct platform_device *stargate2_devices[] = {
 	&stargate2_sram,
 	&smc91x_device,
 	&sht15,
+	&iio_hwmon_test,
 };
 
 static void __init stargate2_init(void)
-- 
1.7.7.2

