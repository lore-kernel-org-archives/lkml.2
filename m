Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab0LNPCC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:02:02 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:57108 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0LNPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:02:00 -0500
X-IronPort-AV: E=Sophos;i="4.59,342,1288584000"; 
   d="scan'208";a="26176765"
From: <michael.hennerich@analog.com>
To: linux-iio@vger.kernel.org, jic23@cam.ac.uk
CC: linux-kernel@vger.kernel.org, drivers@analog.com,
        device-drivers-devel@blackfin.uclinux.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 1/3] IIO: Direct digital synthesis abi documentation
Date: Tue, 14 Dec 2010 15:54:20 +0100
Message-ID: <1292338462-4299-1-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.6.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Changes since RFC/v1:
IIO: Apply list review feedback:

Apply list review feedback:
	Restructure documentation according to list feedback.
	Rename attributes to fit IIO convention used in other drivers.
	Fix typos.
	Provide ddsX_out_enable as opposed to ddsX_out_disable

Changes since v2:
IIO: sysfs-bus-iio-dds: Apply more list review feedback

	Fix mixture of X and [n] notation for indices.
	Fix some wording in the descriptions.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Reviewed-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 .../staging/iio/Documentation/sysfs-bus-iio-dds    |   93 ++++++++++++++++++++
 1 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-dds

diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-dds b/drivers/staging/iio/Documentation/sysfs-bus-iio-dds
new file mode 100644
index 0000000..ffdd547
--- /dev/null
+++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-dds
@@ -0,0 +1,93 @@
+
+What:		/sys/bus/iio/devices/.../ddsX_freqY
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Stores frequency into tuning word Y.
+		There will be more than one ddsX_freqY file, which allows for
+		pin controlled FSK Frequency Shift Keying
+		(ddsX_pincontrol_freq_en is active) or the user can control
+		the desired active tuning word by writing Y to the
+		ddsX_freqsymbol file.
+
+What:		/sys/bus/iio/devices/.../ddsX_freqY_scale
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Scale to be applied to ddsX_freqY in order to obtain the
+		desired value in Hz. If shared across all frequency registers
+		Y is not present. It is also possible X is not present if
+		shared across all channels.
+
+What:		/sys/bus/iio/devices/.../ddsX_freqsymbol
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Specifies the active output frequency tuning word. The value
+		corresponds to the Y in ddsX_freqY. To exit this mode the user
+		can write ddsX_pincontrol_freq_en or ddsX_out_enable file.
+
+What:		/sys/bus/iio/devices/.../ddsX_phaseY
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Stores phase into Y.
+		There will be more than one ddsX_phaseY file, which allows for
+		pin controlled PSK Phase Shift Keying
+		(ddsX_pincontrol_phase_en is active) or the user can
+		control the desired phase Y which is added to the phase
+		accumulator output by writing Y to the en_phase file.
+
+What:		/sys/bus/iio/devices/.../ddsX_phaseY_scale
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Scale to be applied to ddsX_phaseY in order to obtain the
+		desired value in rad. If shared across all phase registers
+		Y is not present. It is also possible X is not present if
+		shared across all channels.
+
+What:		/sys/bus/iio/devices/.../ddsX_phasesymbol
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Specifies the active phase Y which is added to the phase
+		accumulator output. The value corresponds to the Y in
+		ddsX_phaseY. To exit this mode the user can write
+		ddsX_pincontrol_phase_en or disable file.
+
+What:		/sys/bus/iio/devices/.../ddsX_pincontrol_en
+What:		/sys/bus/iio/devices/.../ddsX_pincontrol_freq_en
+What:		/sys/bus/iio/devices/.../ddsX_pincontrol_phase_en
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		ddsX_pincontrol_en: Both, the active frequency and phase is
+		controlled by the respective phase and frequency control inputs.
+		In case the device in question allows to independent controls,
+		then there are dedicated files (ddsX_pincontrol_freq_en,
+		ddsX_pincontrol_phase_en).
+
+What:		/sys/bus/iio/devices/.../ddsX_out_enable
+What:		/sys/bus/iio/devices/.../ddsX_outY_enable
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		ddsX_outY_enable controls signal generation on output Y of
+		channel X. Y may be suppressed if all channels are
+		controlled together.
+
+What:		/sys/bus/iio/devices/.../ddsX_outY_wavetype
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Specifies the output waveform.
+		(sine, triangle, ramp, square, ...)
+		For a list of available output waveform options read
+		available_output_modes.
+
+What:		/sys/bus/iio/devices/.../ddsX_outY_wavetype_available
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Lists all available output waveform options.
--
1.6.0.2

