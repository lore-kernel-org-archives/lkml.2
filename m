Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab2LLPpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:45:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:50365 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab2LLPpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:45:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,267,1355126400"; 
   d="scan'208";a="263013547"
From: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
To: Alexander Holler <holler@ahsoftware.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [PATCH 3/4] iio: merge hid-sensor-attributes.h into
 hid-sensor-hub.h
Thread-Topic: [PATCH 3/4] iio: merge hid-sensor-attributes.h into
 hid-sensor-hub.h
Thread-Index: AQHN18yW3WojzOxek0eBnfNmcOS+7JgVTu/g
Date: Wed, 12 Dec 2012 15:45:33 +0000
Message-ID: <4FA419E87744DF4DAECD5BCE1214B7A91C960BAB@ORSMSX108.amr.corp.intel.com>
References: <50C73AFC.1050904@jic23.retrosnub.co.uk>
 <1355250106-3114-1-git-send-email-holler@ahsoftware.de>
 <1355250106-3114-3-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1355250106-3114-3-git-send-email-holler@ahsoftware.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One minor comment.

-----Original Message-----
From: Alexander Holler [mailto:holler@ahsoftware.de] 
Sent: Tuesday, December 11, 2012 10:22 AM
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org; Jonathan Cameron; Lars-Peter Clausen; rtc-linux@googlegroups.com; Alessandro Zummo; Pandruvada, Srinivas; Andrew Morton; Alexander Holler
Subject: [PATCH 3/4] iio: merge hid-sensor-attributes.h into hid-sensor-hub.h

The stuff in hid-sensor-attributes.h is needed by every piece which uses hid-sensor-hub and merging it into hid-sensor-hub.h makes it accessible from outside the iio subdirectory.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/iio/accel/hid-sensor-accel-3d.c            |    1 -
 .../iio/common/hid-sensors/hid-sensor-attributes.c |    1 -
 .../iio/common/hid-sensors/hid-sensor-attributes.h |   57 --------------------
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |    1 -
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |    1 -
 drivers/iio/light/hid-sensor-als.c                 |    1 -
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |    1 -
 include/linux/hid-sensor-hub.h                     |   38 +++++++++++++
 8 files changed, 38 insertions(+), 63 deletions(-)  delete mode 100644 drivers/iio/common/hid-sensors/hid-sensor-attributes.h

diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
index 314a405..72371aa 100644
--- a/drivers/iio/accel/hid-sensor-accel-3d.c
+++ b/drivers/iio/accel/hid-sensor-accel-3d.c
@@ -28,7 +28,6 @@
 #include <linux/iio/buffer.h>
 #include <linux/iio/trigger_consumer.h>  #include <linux/iio/triggered_buffer.h> -#include "../common/hid-sensors/hid-sensor-attributes.h"
 #include "../common/hid-sensors/hid-sensor-trigger.h"
 
 /*Format: HID-SENSOR-usage_id_in_hex*/
diff --git a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
index 7537495..5873f16 100644
--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
@@ -25,7 +25,6 @@
 #include <linux/hid-sensor-hub.h>
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
-#include "hid-sensor-attributes.h"
 
 static int pow_10(unsigned power)
 {
diff --git a/drivers/iio/common/hid-sensors/hid-sensor-attributes.h b/drivers/iio/common/hid-sensors/hid-sensor-attributes.h
deleted file mode 100644
index a4676a0..0000000
--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
- * HID Sensors Driver
- * Copyright (c) 2012, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-#ifndef _HID_SENSORS_ATTRIBUTES_H
-#define _HID_SENSORS_ATTRIBUTES_H
-
-/* Common hid sensor iio structure */
-struct hid_sensor_iio_common {
-	struct hid_sensor_hub_device *hsdev;
-	struct platform_device *pdev;
-	unsigned usage_id;
-	bool data_ready;
-	struct hid_sensor_hub_attribute_info poll;
-	struct hid_sensor_hub_attribute_info report_state;
-	struct hid_sensor_hub_attribute_info power_state;
-	struct hid_sensor_hub_attribute_info sensitivity;
-};
-/*Convert from hid unit expo to regular exponent*/ -static inline int hid_sensor_convert_exponent(int unit_expo) -{
-	if (unit_expo < 0x08)
-		return unit_expo;
-	else if (unit_expo <= 0x0f)
-		return -(0x0f-unit_expo+1);
-	else
-		return 0;
-}
-
-int hid_sensor_parse_common_attributes(struct hid_sensor_hub_device *hsdev,
-					u32 usage_id,
-					struct hid_sensor_iio_common *st);
-int hid_sensor_write_raw_hyst_value(struct hid_sensor_iio_common *st,
-					int val1, int val2);
-int hid_sensor_read_raw_hyst_value(struct hid_sensor_iio_common *st,
-					int *val1, int *val2);
-int hid_sensor_write_samp_freq_value(struct hid_sensor_iio_common *st,
-					int val1, int val2);
-int hid_sensor_read_samp_freq_value(struct hid_sensor_iio_common *st,
-					int *val1, int *val2);
-
-#endif
diff --git a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
index d4b790d..b097b68 100644
--- a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
@@ -26,7 +26,6 @@
 #include <linux/iio/iio.h>
 #include <linux/iio/trigger.h>
 #include <linux/iio/sysfs.h>
-#include "hid-sensor-attributes.h"
 #include "hid-sensor-trigger.h"
 
 static int hid_sensor_data_rdy_trigger_set_state(struct iio_trigger *trig, diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
index 4c56ada..b98cd70 100644
--- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
+++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
@@ -28,7 +28,6 @@
 #include <linux/iio/buffer.h>
 #include <linux/iio/trigger_consumer.h>  #include <linux/iio/triggered_buffer.h> -#include "../common/hid-sensors/hid-sensor-attributes.h"
 #include "../common/hid-sensors/hid-sensor-trigger.h"
 
 /*Format: HID-SENSOR-usage_id_in_hex*/
diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
index 96e3691..9610989 100644
--- a/drivers/iio/light/hid-sensor-als.c
+++ b/drivers/iio/light/hid-sensor-als.c
@@ -28,7 +28,6 @@
 #include <linux/iio/buffer.h>
 #include <linux/iio/trigger_consumer.h>  #include <linux/iio/triggered_buffer.h> -#include "../common/hid-sensors/hid-sensor-attributes.h"
 #include "../common/hid-sensors/hid-sensor-trigger.h"
 
 /*Format: HID-SENSOR-usage_id_in_hex*/
diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
index c4f0d27..4957430 100644
--- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
+++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
@@ -28,7 +28,6 @@
 #include <linux/iio/buffer.h>
 #include <linux/iio/trigger_consumer.h>  #include <linux/iio/triggered_buffer.h> -#include "../common/hid-sensors/hid-sensor-attributes.h"
 #include "../common/hid-sensors/hid-sensor-trigger.h"
 
 /*Format: HID-SENSOR-usage_id_in_hex*/
diff --git a/include/linux/hid-sensor-hub.h b/include/linux/hid-sensor-hub.h index 0aa5f4c..e6265f9 100644
--- a/include/linux/hid-sensor-hub.h
+++ b/include/linux/hid-sensor-hub.h
@@ -157,4 +157,42 @@ int sensor_hub_set_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,  */  int sensor_hub_get_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
 			u32 field_index, s32 *value);
+
+/* hid-sensor-attributes */
+
+/* Common hid sensor iio structure */
+struct hid_sensor_iio_common {
+	struct hid_sensor_hub_device *hsdev;
+	struct platform_device *pdev;
+	unsigned usage_id;
+	bool data_ready;
+	struct hid_sensor_hub_attribute_info poll;
+	struct hid_sensor_hub_attribute_info report_state;
+	struct hid_sensor_hub_attribute_info power_state;
+	struct hid_sensor_hub_attribute_info sensitivity; };

<Since it is not common to iio only, we should also remove iio in the structure name. >

+/*Convert from hid unit expo to regular exponent*/ static inline int 
+hid_sensor_convert_exponent(int unit_expo) {
+	if (unit_expo < 0x08)
+		return unit_expo;
+	else if (unit_expo <= 0x0f)
+		return -(0x0f-unit_expo+1);
+	else
+		return 0;
+}
+
+int hid_sensor_parse_common_attributes(struct hid_sensor_hub_device *hsdev,
+					u32 usage_id,
+					struct hid_sensor_iio_common *st); int 
+hid_sensor_write_raw_hyst_value(struct hid_sensor_iio_common *st,
+					int val1, int val2);
+int hid_sensor_read_raw_hyst_value(struct hid_sensor_iio_common *st,
+					int *val1, int *val2);
+int hid_sensor_write_samp_freq_value(struct hid_sensor_iio_common *st,
+					int val1, int val2);
+int hid_sensor_read_samp_freq_value(struct hid_sensor_iio_common *st,
+					int *val1, int *val2);
+
 #endif
--
1.7.8.6

