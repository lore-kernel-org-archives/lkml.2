Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007Ab2LIMWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 07:22:43 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:50198 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933977Ab2LIMWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 07:22:40 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/3] iio: hid-sensors: respect CONFIG_IIO_TRIGGER
Date: Sun,  9 Dec 2012 13:21:37 +0100
Message-Id: <1355055699-2965-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355055699-2965-1-git-send-email-holler@ahsoftware.de>
References: <1355055699-2965-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not much to say, without that change, hid-sensor-trigger will be
always compiled if HID_SENSOR_IIO_COMMON is selected which fails if
CONFIG_IIO_TRIGGER is not set because CONFIG_IIO_CONSUMERS_PER_TRIGGER
will not be defined.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/iio/accel/Kconfig               |    1 +
 drivers/iio/common/hid-sensors/Makefile |    3 ++-
 drivers/iio/gyro/Kconfig                |    1 +
 drivers/iio/light/Kconfig               |    1 +
 drivers/iio/magnetometer/Kconfig        |    1 +
 5 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
index b2510c4..b84b806 100644
--- a/drivers/iio/accel/Kconfig
+++ b/drivers/iio/accel/Kconfig
@@ -8,6 +8,7 @@ config HID_SENSOR_ACCEL_3D
 	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
+	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID Acelerometers 3D"
 	help
 	  Say yes here to build support for the HID SENSOR
diff --git a/drivers/iio/common/hid-sensors/Makefile b/drivers/iio/common/hid-sensors/Makefile
index 1f463e0..22e7c5a 100644
--- a/drivers/iio/common/hid-sensors/Makefile
+++ b/drivers/iio/common/hid-sensors/Makefile
@@ -3,4 +3,5 @@
 #
 
 obj-$(CONFIG_HID_SENSOR_IIO_COMMON) += hid-sensor-iio-common.o
-hid-sensor-iio-common-y := hid-sensor-attributes.o hid-sensor-trigger.o
+obj-$(CONFIG_HID_SENSOR_IIO_TRIGGER) += hid-sensor-trigger.o
+hid-sensor-iio-common-y := hid-sensor-attributes.o
diff --git a/drivers/iio/gyro/Kconfig b/drivers/iio/gyro/Kconfig
index 21e27e2..bc9daff 100644
--- a/drivers/iio/gyro/Kconfig
+++ b/drivers/iio/gyro/Kconfig
@@ -8,6 +8,7 @@ config HID_SENSOR_GYRO_3D
 	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
+	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID Gyroscope 3D"
 	help
 	  Say yes here to build support for the HID SENSOR
diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index 1763c9b..dbf80ab 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -47,6 +47,7 @@ config HID_SENSOR_ALS
 	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
+	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID ALS"
 	help
 	  Say yes here to build support for the HID SENSOR
diff --git a/drivers/iio/magnetometer/Kconfig b/drivers/iio/magnetometer/Kconfig
index c1f0cdd..ff11d68 100644
--- a/drivers/iio/magnetometer/Kconfig
+++ b/drivers/iio/magnetometer/Kconfig
@@ -8,6 +8,7 @@ config HID_SENSOR_MAGNETOMETER_3D
 	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
+	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID Magenetometer 3D"
 	help
 	  Say yes here to build support for the HID SENSOR
-- 
1.7.8.6

