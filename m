Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab1JSOrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:47:20 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:35335 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab1JSOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:47:11 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: linus.ml.walleij@gmail.com, zdevai@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        lm-sensors@lm-sensors.org, guenter.roeck@ericsson.com,
        khali@linux-fr.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 3/6] IIO:CORE: put defs needed by inkern and userspace interfaces into chan_spec.h
Date: Wed, 19 Oct 2011 15:47:05 +0100
Message-Id: <1319035628-32580-4-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1319035628-32580-1-git-send-email-jic23@cam.ac.uk>
References: <1319035628-32580-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 include/linux/iio/chan_spec.h |   46 +++++++++++++++++++++++++++++++++++++++++
 include/linux/iio/iio.h       |   33 +----------------------------
 2 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/include/linux/iio/chan_spec.h b/include/linux/iio/chan_spec.h
new file mode 100644
index 0000000..933480b
--- /dev/null
+++ b/include/linux/iio/chan_spec.h
@@ -0,0 +1,46 @@
+/*
+ * The industrial I/O channel descriptions
+ *
+ * Copyright (c) 2008-2011 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _IIO_CHAN_SPEC_H_
+#define _IIO_CHAN_SPEC_H_
+
+enum iio_data_type {
+	IIO_RAW,
+	IIO_PROCESSED,
+};
+
+enum iio_direction {
+	IIO_IN,
+	IIO_OUT,
+};
+
+enum iio_chan_type {
+	IIO_VOLTAGE,
+	IIO_CURRENT,
+	IIO_POWER,
+	IIO_CAPACITANCE,
+	IIO_ACCEL,
+	IIO_ANGL_VEL,
+	IIO_MAGN,
+	IIO_LIGHT,
+	IIO_INTENSITY,
+	IIO_PROXIMITY,
+	IIO_TEMP,
+	IIO_INCLI,
+	IIO_ROT,
+	IIO_ANGL,
+	IIO_TIMESTAMP,
+};
+
+#define IIO_VAL_INT 1
+#define IIO_VAL_INT_PLUS_MICRO 2
+#define IIO_VAL_INT_PLUS_NANO 3
+
+#endif
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index beedc5c..8b98e92 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -9,6 +9,7 @@
  */
 #include <linux/klist.h>
 #include <linux/device.h>
+#include <linux/iio/chan_spec.h>
 
 #ifndef _IIO_H_
 #define _IIO_H_
@@ -16,29 +17,6 @@
 /* Minimum alignment of priv within iio_dev */
 #define IIO_ALIGN L1_CACHE_BYTES
 
-enum iio_data_type {
-	IIO_RAW,
-	IIO_PROCESSED,
-};
-
-enum iio_chan_type {
-	IIO_VOLTAGE,
-	IIO_CURRENT,
-	IIO_POWER,
-	IIO_CAPACITANCE,
-	IIO_ACCEL,
-	IIO_ANGL_VEL,
-	IIO_MAGN,
-	IIO_LIGHT,
-	IIO_INTENSITY,
-	IIO_PROXIMITY,
-	IIO_TEMP,
-	IIO_INCLI,
-	IIO_ROT,
-	IIO_ANGL,
-	IIO_TIMESTAMP,
-};
-
 enum iio_modifier {
 	IIO_NO_MOD,
 	IIO_MOD_X,
@@ -73,15 +51,6 @@ enum iio_chan_info_enum {
 	IIO_CHAN_INFO_QUADRATURE_CORRECTION_RAW_SEPARATE,
 };
 
-enum iio_direction {
-	IIO_IN,
-	IIO_OUT,
-};
-
-#define IIO_VAL_INT 1
-#define IIO_VAL_INT_PLUS_MICRO 2
-#define IIO_VAL_INT_PLUS_NANO 3
-
 /**
  * struct iio_chan_spec - specification of a single channel
  * @type:		What type of measurement is the channel making.
-- 
1.7.7

