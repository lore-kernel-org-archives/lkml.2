Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0LBM3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 07:29:01 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:43500 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab0LBM26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 07:28:58 -0500
X-IronPort-AV: E=Sophos;i="4.59,287,1288584000"; 
   d="scan'208";a="25615801"
From: <michael.hennerich@analog.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
CC: drivers@analog.com, jic23@cam.ac.uk,
        device-drivers-devel@blackfin.uclinux.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [RFC 2/3] IIO: dds.h convenience macros
Date: Thu, 2 Dec 2010 13:21:28 +0100
Message-ID: <1291292489-32362-3-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1291292489-32362-1-git-send-email-michael.hennerich@analog.com>
References: <1291292489-32362-1-git-send-email-michael.hennerich@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Attributes considered as common between various DDS devices

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
---
 drivers/staging/iio/dds/dds.h |  153 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 153 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/dds/dds.h

diff --git a/drivers/staging/iio/dds/dds.h b/drivers/staging/iio/dds/dds.h
new file mode 100644
index 0000000..e171b33
--- /dev/null
+++ b/drivers/staging/iio/dds/dds.h
@@ -0,0 +1,153 @@
+/*
+ * dds.h - sysfs attributes associated with DDS devices
+ *
+ * Copyright (c) 2010 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_freqY
+ * Description:
+ * Stores frequency into tuning word register Y.
+ * There can be more than one ddsX_freqY file, which allows for pin controlled
+ * FSK Frequency Shift Keying (ddsX_pincontrol_freq_en is active) or the user
+ * can control the desired active tuning word by writing Y to the
+ * ddsX_freqsymbol file.
+ */
+
+#define IIO_DEV_ATTR_FREQ(_device, _num, _store, _addr)			\
+	IIO_DEVICE_ATTR(dds##_device##_freq##_num, S_IWUSR, NULL, _store, _addr)
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_freq_scaleY
+ * Description:
+ * Scale to be applied to ddsX_freqY in order to obtain the
+ * desired value in Hz. If shared across all frequency registers
+ * Y is not present.
+ */
+
+#define IIO_CONST_ATTR_FREQ_SCALE(_device, _string)			\
+	IIO_CONST_ATTR(dds##_device##_freq_scale, _string)
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_freqsymbol
+ * Description:
+ * Specifies the active output frequency tuning word. The value corresponds
+ * to the Y in ddsX_freqY. To exit this mode the user can write
+ * ddsX_pincontrol_freq_en or ddsX_out_disable file.
+ */
+
+#define IIO_DEV_ATTR_FREQSYMBOL(_device, _store, _addr)			\
+	IIO_DEVICE_ATTR(dds##_device##_freqsymbol,			\
+			S_IWUSR, NULL, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_phaseY
+ * Description:
+ * Stores phase into phase register Y.
+ * There can be more than one ddsX_phaseY file, which allows for pin controlled
+ * PSK Phase Shift Keying (ddsX_pincontrol_phase_en is active) or the user can
+ * control the desired phase Y which is added to the phase accumulator output
+ * by writing Y to the en_phase file.
+ */
+
+#define IIO_DEV_ATTR_PHASE(_device, _num, _store, _addr)		\
+	IIO_DEVICE_ATTR(dds##_device##_phase##_num,			\
+			S_IWUSR, NULL, _store, _addr)
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_phase_scaleY
+ * Description:
+ * Scale to be applied to ddsX_phaseY in order to obtain the
+ * desired value in rad. If shared across all phase registers
+ * Y is not present.
+ */
+
+#define IIO_CONST_ATTR_PHASE_SCALE(_device, _string)			\
+	IIO_CONST_ATTR(dds##_device##_phase_scale, _string)
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_phasesymbol
+ * Description:
+ * Specifies the active phase Y which is added to the phase accumulator output.
+ * The value corresponds to the Y in ddsX_phaseY. To exit this mode the user
+ * can write ddsX_pincontrol_phase_en or disable file.
+ */
+
+#define IIO_DEV_ATTR_PHASESYMBOL(_device, _store, _addr)		\
+	IIO_DEVICE_ATTR(dds##_device##_phasesymbol,			\
+			S_IWUSR, NULL, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_pincontrol_en
+ * Description:
+ * Both, the active frequency and phase is controlled by the respective
+ * phase and frequency control inputs.
+ */
+
+#define IIO_DEV_ATTR_PINCONTROL_EN(_device, _store, _addr)		\
+	IIO_DEVICE_ATTR(dds##_device##_pincontrol_en,			\
+			S_IWUSR, NULL, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_pincontrol_freq_en
+ * Description:
+ * The active frequency is controlled by the respective
+ * frequency control/select inputs.
+ */
+
+#define IIO_DEV_ATTR_PINCONTROL_FREQ_EN(_device, _store, _addr)		\
+	IIO_DEVICE_ATTR(dds##_device##_pincontrol_freq_en,		\
+			S_IWUSR, NULL, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_pincontrol_phase_en
+ * Description:
+ * The active phase is controlled by the respective
+ * phase control/select inputs.
+ */
+
+#define IIO_DEV_ATTR_PINCONTROL_PHASE_EN(_device, _store, _addr)	\
+	IIO_DEVICE_ATTR(dds##_device##_pincontrol_phase_en,		\
+			S_IWUSR, NULL, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_out_disable
+ * Description:
+ * Disables any signal generation on all outputs.
+ */
+
+#define IIO_DEV_ATTR_OUT_DISABLE(_device, _store, _addr)		\
+	IIO_DEVICE_ATTR(dds##_device##_out_disable,			\
+			S_IWUSR, NULL, _store, _addr);
+
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_outY_disable
+ * Description:
+ * Disables any signal generation on output Y.
+ */
+
+#define IIO_DEV_ATTR_OUTY_DISABLE(_device, _output, _store, _addr)	\
+	IIO_DEVICE_ATTR(dds##_device##_out##_output##_disable,		\
+	S_IWUSR, NULL, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_outY_wavetype
+ * Description:
+ * Specifies the output waveform. (sine, triangle, ramp, square, ...)
+ * For a list of available output waveform options read available_output_modes.
+ */
+#define IIO_DEV_ATTR_OUT_WAVETYPE(_device, _output, _store, _addr)	\
+	IIO_DEVICE_ATTR(dds##_device##_out##_output##_wavetype,		\
+			S_IWUSR, NULL, _store, _addr);
+
+/**
+ * /sys/bus/iio/devices/deviceX/ddsX_outY_available_wavetypes
+ * Description:
+ * Lists all available output waveform options.
+ */
+#define IIO_CONST_ATTR_OUT_AVAILABLE_WAVETYPES(_device, _output, _modes)\
+	IIO_CONST_ATTR(dds##_device##_out##_output##_available_wavetypes,\
+			_modes);
--
1.6.0.2

