Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab0LNPCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:02:50 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:57108 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab0LNPCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:02:01 -0500
X-IronPort-AV: E=Sophos;i="4.59,342,1288584000"; 
   d="scan'208";a="26176770"
From: <michael.hennerich@analog.com>
To: linux-iio@vger.kernel.org, jic23@cam.ac.uk
CC: linux-kernel@vger.kernel.org, drivers@analog.com,
        device-drivers-devel@blackfin.uclinux.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 2/3] IIO: dds.h convenience macros
Date: Tue, 14 Dec 2010 15:54:21 +0100
Message-ID: <1292338462-4299-2-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1292338462-4299-1-git-send-email-michael.hennerich@analog.com>
References: <1292338462-4299-1-git-send-email-michael.hennerich@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Changes since RFC/v1:
IIO: Apply list review feedback

Apply list review feedback:
	Rename attributes to fit IIO convention used in other drivers.
	Provide ddsX_out_enable as opposed to ddsX_out_disable.
	Fix typos.

Changes since v2:
IIO: dds.h: Apply more list review feedback

	Fix mixture of X and [n] notation for indices.
	Remove duplicated descriptions.
	Add store methods to some dds convenience macros.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Reviewed-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/dds/dds.h |  110 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/dds/dds.h

diff --git a/drivers/staging/iio/dds/dds.h b/drivers/staging/iio/dds/dds.h
new file mode 100644
index 0000000..d8ac3a9
--- /dev/null
+++ b/drivers/staging/iio/dds/dds.h
@@ -0,0 +1,110 @@
+/*
+ * dds.h - sysfs attributes associated with DDS devices
+ *
+ * Copyright (c) 2010 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_freqY
+ */
+
+#define IIO_DEV_ATTR_FREQ(_channel, _num, _mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(dds##_channel##_freq##_num,			\
+			_mode, _show, _store, _addr)
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_freqY_scale
+ */
+
+#define IIO_CONST_ATTR_FREQ_SCALE(_channel, _string)			\
+	IIO_CONST_ATTR(dds##_channel##_freq_scale, _string)
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_freqsymbol
+ */
+
+#define IIO_DEV_ATTR_FREQSYMBOL(_channel, _mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(dds##_channel##_freqsymbol,			\
+			_mode, _show, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_phaseY
+ */
+
+#define IIO_DEV_ATTR_PHASE(_channel, _num, _mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(dds##_channel##_phase##_num,			\
+			_mode, _show, _store, _addr)
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_phaseY_scale
+ */
+
+#define IIO_CONST_ATTR_PHASE_SCALE(_channel, _string)			\
+	IIO_CONST_ATTR(dds##_channel##_phase_scale, _string)
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_phasesymbol
+ */
+
+#define IIO_DEV_ATTR_PHASESYMBOL(_channel, _mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(dds##_channel##_phasesymbol,			\
+			_mode, _show, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_pincontrol_en
+ */
+
+#define IIO_DEV_ATTR_PINCONTROL_EN(_channel, _mode, _show, _store, _addr)\
+	IIO_DEVICE_ATTR(dds##_channel##_pincontrol_en,			\
+			_mode, _show, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_pincontrol_freq_en
+ */
+
+#define IIO_DEV_ATTR_PINCONTROL_FREQ_EN(_channel, _mode, _show, _store, _addr)\
+	IIO_DEVICE_ATTR(dds##_channel##_pincontrol_freq_en,		\
+			_mode, _show, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_pincontrol_phase_en
+ */
+
+#define IIO_DEV_ATTR_PINCONTROL_PHASE_EN(_channel, _mode, _show, _store, _addr)\
+	IIO_DEVICE_ATTR(dds##_channel##_pincontrol_phase_en,		\
+			_mode, _show, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_out_enable
+ */
+
+#define IIO_DEV_ATTR_OUT_ENABLE(_channel, _mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(dds##_channel##_out_enable,			\
+			_mode, _show, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_outY_enable
+ */
+
+#define IIO_DEV_ATTR_OUTY_ENABLE(_channel, _output,			\
+			_mode, _show, _store, _addr)			\
+	IIO_DEVICE_ATTR(dds##_channel##_out##_output##_enable,		\
+			_mode, _show, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_outY_wavetype
+ */
+
+#define IIO_DEV_ATTR_OUT_WAVETYPE(_channel, _output, _store, _addr)	\
+	IIO_DEVICE_ATTR(dds##_channel##_out##_output##_wavetype,	\
+			S_IWUSR, NULL, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/.../ddsX_outY_wavetype_available
+ */
+
+#define IIO_CONST_ATTR_OUT_WAVETYPES_AVAILABLE(_channel, _output, _modes)\
+	IIO_CONST_ATTR(dds##_channel##_out##_output##_wavetype_available,\
+			_modes);
--
1.6.0.2

