Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966807Ab2EOU6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:58:36 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:50505 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966750Ab2EOU6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:58:35 -0400
Subject: [PATCH V1] IIO channel type and modifiers for CCT and RGBC data
From: Jon Brenner <jbrenner@taosinc.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 May 2012 15:58:49 -0500
Message-ID: <1337115529.2399.3.camel@jonz-ub2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add iio channel type and modifiers for Correlated Color Temperature (CCT)
and RGBC (red/green/blue/clear) data.
Add CCT and RGBC descriptions in documentation.

Signed-off-by: Jon Brenner <jbrenner@taosinc.com>
---
 drivers/iio/industrialio-core.c                    |    5 ++
 .../staging/iio/Documentation/sysfs-bus-iio-light  |   50 ++++++++++++++++++++
 include/linux/iio/types.h                          |    5 ++
 3 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 1ddd886..34d8cc9 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -64,6 +64,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_TIMESTAMP] = "timestamp",
 	[IIO_CAPACITANCE] = "capacitance",
 	[IIO_ALTVOLTAGE] = "altvoltage",
+	[IIO_CCT] = "cct",
 };

 static const char * const iio_modifier_names[] = {
@@ -72,6 +73,10 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_Z] = "z",
 	[IIO_MOD_LIGHT_BOTH] = "both",
 	[IIO_MOD_LIGHT_IR] = "ir",
+	[IIO_MOD_LIGHT_CLEAR] = "clear",
+	[IIO_MOD_LIGHT_RED] = "red",
+	[IIO_MOD_LIGHT_GREEN] = "green",
+	[IIO_MOD_LIGHT_BLUE] = "blue",
 };

 /* relies on pairs of these shared then separate */
diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
index 715c74d..f9a4145 100644
--- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
+++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
@@ -34,6 +34,15 @@ Description:
 		it comes back in SI units, it should also include _input else it
 		should include _raw to signify it is not in SI units.

+What:		/sys/bus/iio/devices/device[n]/in_cct0[_input|_raw]
+KernelVersion:	3.4.0
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This should return the correlated color temperature from the
+		light sensor. If it comes back in SI units, it should also
+		include _input else it should include _raw to signify it is not
+		in SI units.
+
 What:		/sys/.../device[n]/proximity_on_chip_ambient_infrared_supression
 KernelVersion:	2.6.37
 Contact:	linux-iio@vger.kernel.org
@@ -82,3 +91,44 @@ Contact:	linux-iio@vger.kernel.org
 Description:
 		This property gets/sets the table of coefficients
 		used in calculating illuminance in lux.
+
+What:		/sys/bus/iio/devices/device[n]/in_intensity_clear[_input|_raw]
+KernelVersion:	3.4.0
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property is supported by sensors that have a RGBC
+		sensing mode. This value should be the output from a reading
+		and if expressed in SI units, should include _input. If this
+		value is not in SI units (e.g. irradiance, uW/mm), then it should
+		include _raw.
+
+What:		/sys/bus/iio/devices/device[n]/in_intensity_red[_input|_raw]
+KernelVersion:	3.4.0
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property is supported by sensors that have a RGBC
+		sensing mode. This value should be the output from a reading
+		and if expressed in SI units, should include _input. If this
+		value is not in SI units (e.g. irradiance, uW/mm), then it should
+		include _raw.
+
+What:		/sys/bus/iio/devices/device[n]/in_intensity_green[_input|_raw]
+KernelVersion:	3.4.0
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property is supported by sensors that have a RGBC
+		sensing mode. This value should be the output from a reading
+		and if expressed in SI units, should include _input. If this
+		value is not in SI units (e.g. irradiance, uW/mm), then it should
+		include _raw.
+
+What:		/sys/bus/iio/devices/device[n]/in_intensity_blue[_input|_raw]
+KernelVersion:	3.4.0
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property is supported by sensors that have a RGBC
+		sensing mode. This value should be the output from a reading
+		and if expressed in SI units, should include _input. If this
+		value is not in SI units (e.g. irradiance, uW/mm), then it should
+		include _raw.
+
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index 1b073b1..a7de5d9 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -28,6 +28,7 @@ enum iio_chan_type {
 	IIO_TIMESTAMP,
 	IIO_CAPACITANCE,
 	IIO_ALTVOLTAGE,
+	IIO_CCT,
 };

 enum iio_modifier {
@@ -45,6 +46,10 @@ enum iio_modifier {
 	IIO_MOD_X_OR_Y_OR_Z,
 	IIO_MOD_LIGHT_BOTH,
 	IIO_MOD_LIGHT_IR,
+	IIO_MOD_LIGHT_CLEAR,
+	IIO_MOD_LIGHT_RED,
+	IIO_MOD_LIGHT_GREEN,
+	IIO_MOD_LIGHT_BLUE,
 };

 #define IIO_VAL_INT 1
--
1.7.4.1

