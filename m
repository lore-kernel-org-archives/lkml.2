Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab2JVH5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:57:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:15864 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab2JVH5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,628,1344236400"; 
   d="scan'208";a="208877289"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] iio: hid-sensors: convert HID_SENSOR_ENUM_BASE_QUIRKS to bool
Date: Mon, 22 Oct 2012 10:57:54 +0300
Message-Id: <1350892674-4000-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

It's non-sense to use tristate for the option, it's bool.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/iio/common/hid-sensors/Kconfig              |    2 +-
 drivers/iio/common/hid-sensors/hid-sensor-trigger.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/common/hid-sensors/Kconfig b/drivers/iio/common/hid-sensors/Kconfig
index 8e63d81..ae10778 100644
--- a/drivers/iio/common/hid-sensors/Kconfig
+++ b/drivers/iio/common/hid-sensors/Kconfig
@@ -15,7 +15,7 @@ config HID_SENSOR_IIO_COMMON
 	  attributes.
 
 config HID_SENSOR_ENUM_BASE_QUIRKS
-	tristate "ENUM base quirks for HID Sensor IIO drivers"
+	bool "ENUM base quirks for HID Sensor IIO drivers"
 	depends on HID_SENSOR_IIO_COMMON
 	help
 	  Say yes here to build support for sensor hub FW using
diff --git a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
index d4b790d..d60198a 100644
--- a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
@@ -36,10 +36,8 @@ static int hid_sensor_data_rdy_trigger_set_state(struct iio_trigger *trig,
 	int state_val;
 
 	state_val = state ? 1 : 0;
-#if (defined CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS) || \
-	(defined CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS_MODULE)
-	++state_val;
-#endif
+	if (IS_ENABLED(CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS))
+		++state_val;
 	st->data_ready = state;
 	sensor_hub_set_feature(st->hsdev, st->power_state.report_id,
 					st->power_state.index,
-- 
1.7.10.4

