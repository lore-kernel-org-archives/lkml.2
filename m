Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0DZT33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:29:29 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51638 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab0DZT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 14/19] staging:iio:max1363 add support for max11606-max11617
Date: Mon, 26 Apr 2010 20:31:16 +0100
Message-Id: <1272310281-7418-15-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-14-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-9-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-10-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-11-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-12-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-13-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-14-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/adc/Kconfig        |    4 +-
 drivers/staging/iio/adc/max1363_core.c |  216 +++++++++++++++++++++++++++++++-
 2 files changed, 218 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
index 101ea4b..afc8318 100644
--- a/drivers/staging/iio/adc/Kconfig
+++ b/drivers/staging/iio/adc/Kconfig
@@ -12,7 +12,9 @@ config MAX1363
 	  Say yes here to build support for many MAXIM i2c analog to digital
 	  convertors (ADC). (max1361, max1362, max1363, max1364, max1136,
 	  max1136, max1137, max1138, max1139, max1236, max1237, max11238,
-	  max1239) Provides direct access via sysfs.
+	  max1239, max11606, max11607, max11608, max11609, max11610,
+	  max11611, max11612, max11613, max11614, max11615, max11616,
+	  max11617) Provides direct access via sysfs.
 
 config MAX1363_RING_BUFFER
 	bool "MAXIM max1363: use ring buffer"
diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index e82f3e7..c53bf6d 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -434,6 +434,76 @@ static struct attribute_group max1238_scan_el_group = {
 	.attrs = max1238_scan_el_attrs,
 };
 
+
+static const enum max1363_modes max11607_mode_list[] = {
+	_s0, _s1, _s2, _s3,
+	s0to1, s0to2, s0to3,
+	s2to3,
+	d0m1, d2m3, d1m0, d3m2,
+	d0m1to2m3, d1m0to3m2,
+};
+
+static const enum max1363_modes max11608_mode_list[] = {
+	_s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7,
+	s0to1, s0to2, s0to3, s0to4, s0to5, s0to6, s0to7,
+	s6to7,
+	d0m1, d2m3, d4m5, d6m7,
+	d1m0, d3m2, d5m4, d7m6,
+	d0m1to2m3, d0m1to4m5, d0m1to6m7,
+	d1m0to3m2, d1m0to5m4, d1m0to7m6,
+};
+
+static struct attribute *max11608_device_attrs[] = {
+	&iio_dev_attr_in0_raw.dev_attr.attr,
+	&iio_dev_attr_in1_raw.dev_attr.attr,
+	&iio_dev_attr_in2_raw.dev_attr.attr,
+	&iio_dev_attr_in3_raw.dev_attr.attr,
+	&iio_dev_attr_in4_raw.dev_attr.attr,
+	&iio_dev_attr_in5_raw.dev_attr.attr,
+	&iio_dev_attr_in6_raw.dev_attr.attr,
+	&iio_dev_attr_in7_raw.dev_attr.attr,
+	&iio_dev_attr_in0min1_raw.dev_attr.attr,
+	&iio_dev_attr_in2min3_raw.dev_attr.attr,
+	&iio_dev_attr_in4min5_raw.dev_attr.attr,
+	&iio_dev_attr_in6min7_raw.dev_attr.attr,
+	&iio_dev_attr_in1min0_raw.dev_attr.attr,
+	&iio_dev_attr_in3min2_raw.dev_attr.attr,
+	&iio_dev_attr_in5min4_raw.dev_attr.attr,
+	&iio_dev_attr_in7min6_raw.dev_attr.attr,
+	&iio_dev_attr_name.dev_attr.attr,
+	&iio_dev_attr_in_scale.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group max11608_dev_attr_group = {
+	.attrs = max11608_device_attrs,
+};
+
+static struct attribute *max11608_scan_el_attrs[] = {
+	&iio_scan_el_in0.dev_attr.attr,
+	&iio_scan_el_in1.dev_attr.attr,
+	&iio_scan_el_in2.dev_attr.attr,
+	&iio_scan_el_in3.dev_attr.attr,
+	&iio_scan_el_in4.dev_attr.attr,
+	&iio_scan_el_in5.dev_attr.attr,
+	&iio_scan_el_in6.dev_attr.attr,
+	&iio_scan_el_in7.dev_attr.attr,
+	&iio_scan_el_in0min1.dev_attr.attr,
+	&iio_scan_el_in2min3.dev_attr.attr,
+	&iio_scan_el_in4min5.dev_attr.attr,
+	&iio_scan_el_in6min7.dev_attr.attr,
+	&iio_scan_el_in1min0.dev_attr.attr,
+	&iio_scan_el_in3min2.dev_attr.attr,
+	&iio_scan_el_in5min4.dev_attr.attr,
+	&iio_scan_el_in7min6.dev_attr.attr,
+	&iio_dev_attr_in_precision.dev_attr.attr,
+};
+
+static struct attribute_group max11608_scan_el_group = {
+	.name = "scan_elements",
+	.attrs = max11608_scan_el_attrs,
+};
+
 enum { max1361,
        max1362,
        max1363,
@@ -446,6 +516,18 @@ enum { max1361,
        max1237,
        max1238,
        max1239,
+       max11606,
+       max11607,
+       max11608,
+       max11609,
+       max11610,
+       max11611,
+       max11612,
+       max11613,
+       max11614,
+       max11615,
+       max11616,
+       max11617,
 };
 
 /* max1363 and max1368 tested - rest from data sheet */
@@ -574,7 +656,127 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
 		.default_mode = s0to11,
 		.dev_attrs = &max1238_dev_attr_group,
 		.scan_attrs = &max1238_scan_el_group,
-	},
+	}, {
+		.name = "max11606",
+		.num_inputs = 4,
+		.bits = 10,
+		.int_vref_mv = 4096,
+		.mode_list = max11607_mode_list,
+		.num_modes = ARRAY_SIZE(max11607_mode_list),
+		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
+	}, {
+		.name = "max11607",
+		.num_inputs = 4,
+		.bits = 10,
+		.int_vref_mv = 2048,
+		.mode_list = max11607_mode_list,
+		.num_modes = ARRAY_SIZE(max11607_mode_list),
+		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
+	}, {
+		.name = "max11608",
+		.num_inputs = 8,
+		.bits = 10,
+		.int_vref_mv = 4096,
+		.mode_list = max11608_mode_list,
+		.num_modes = ARRAY_SIZE(max11608_mode_list),
+		.default_mode = s0to7,
+		.dev_attrs = &max11608_dev_attr_group,
+		.scan_attrs = &max11608_scan_el_group,
+	}, {
+		.name = "max11609",
+		.num_inputs = 8,
+		.bits = 10,
+		.int_vref_mv = 2048,
+		.mode_list = max11608_mode_list,
+		.num_modes = ARRAY_SIZE(max11608_mode_list),
+		.default_mode = s0to7,
+		.dev_attrs = &max11608_dev_attr_group,
+		.scan_attrs = &max11608_scan_el_group,
+	}, {
+		.name = "max11610",
+		.num_inputs = 12,
+		.bits = 10,
+		.int_vref_mv = 4098,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
+	}, {
+		.name = "max11611",
+		.num_inputs = 12,
+		.bits = 10,
+		.int_vref_mv = 2048,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
+	}, {
+		.name = "max11612",
+		.num_inputs = 4,
+		.bits = 12,
+		.int_vref_mv = 4096,
+		.mode_list = max11607_mode_list,
+		.num_modes = ARRAY_SIZE(max11607_mode_list),
+		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
+	}, {
+		.name = "max11613",
+		.num_inputs = 4,
+		.bits = 12,
+		.int_vref_mv = 2048,
+		.mode_list = max11607_mode_list,
+		.num_modes = ARRAY_SIZE(max11607_mode_list),
+		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
+	}, {
+		.name = "max11614",
+		.num_inputs = 8,
+		.bits = 12,
+		.int_vref_mv = 4096,
+		.mode_list = max11608_mode_list,
+		.num_modes = ARRAY_SIZE(max11608_mode_list),
+		.default_mode = s0to7,
+		.dev_attrs = &max11608_dev_attr_group,
+		.scan_attrs = &max11608_scan_el_group,
+	}, {
+		.name = "max11615",
+		.num_inputs = 8,
+		.bits = 12,
+		.int_vref_mv = 2048,
+		.mode_list = max11608_mode_list,
+		.num_modes = ARRAY_SIZE(max11608_mode_list),
+		.default_mode = s0to7,
+		.dev_attrs = &max11608_dev_attr_group,
+		.scan_attrs = &max11608_scan_el_group,
+	}, {
+		.name = "max11616",
+		.num_inputs = 12,
+		.bits = 12,
+		.int_vref_mv = 4098,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
+	}, {
+		.name = "max11617",
+		.num_inputs = 12,
+		.bits = 12,
+		.int_vref_mv = 2048,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
+	}
 };
 
 static int max1363_initial_setup(struct max1363_state *st)
@@ -726,6 +928,18 @@ static const struct i2c_device_id max1363_id[] = {
 	{ "max1237", max1237 },
 	{ "max1238", max1238 },
 	{ "max1239", max1239 },
+	{ "max11606", max11606 },
+	{ "max11607", max11607 },
+	{ "max11608", max11608 },
+	{ "max11609", max11609 },
+	{ "max11610", max11610 },
+	{ "max11611", max11611 },
+	{ "max11612", max11612 },
+	{ "max11613", max11613 },
+	{ "max11614", max11614 },
+	{ "max11615", max11615 },
+	{ "max11616", max11616 },
+	{ "max11617", max11617 },
 	{}
 };
 
-- 
1.6.4.4

