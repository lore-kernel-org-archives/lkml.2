Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1JSOrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:47:19 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:35332 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab1JSOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:47:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: linus.ml.walleij@gmail.com, zdevai@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        lm-sensors@lm-sensors.org, guenter.roeck@ericsson.com,
        khali@linux-fr.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 6/6] stargate2: example of map configuration for iio to hwmon example.
Date: Wed, 19 Oct 2011 15:47:08 +0100
Message-Id: <1319035628-32580-7-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1319035628-32580-1-git-send-email-jic23@cam.ac.uk>
References: <1319035628-32580-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not commit.
---
 arch/arm/mach-pxa/stargate2.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
index 3f8d0af..48dcbb7 100644
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
1.7.7

