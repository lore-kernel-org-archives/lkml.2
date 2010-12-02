Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0LBM3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 07:29:39 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:61444 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399Ab0LBM24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 07:28:56 -0500
X-IronPort-AV: E=Sophos;i="4.59,287,1288584000"; 
   d="scan'208";a="25615797"
From: <michael.hennerich@analog.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
CC: drivers@analog.com, jic23@cam.ac.uk,
        device-drivers-devel@blackfin.uclinux.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [RFC 1/3] IIO: Direct digital synthesis abi documentation
Date: Thu, 2 Dec 2010 13:21:27 +0100
Message-ID: <1291292489-32362-2-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1291292489-32362-1-git-send-email-michael.hennerich@analog.com>
References: <1291292489-32362-1-git-send-email-michael.hennerich@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Proposed ABI documentation

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
---
 .../staging/iio/Documentation/sysfs-bus-iio-dds    |  103 ++++++++++++++++++++
 1 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-dds

diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-dds b/drivers/staging/iio/Documentation/sysfs-bus-iio-dds
new file mode 100644
index 0000000..2c99889
--- /dev/null
+++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-dds
@@ -0,0 +1,103 @@
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_freqY
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Stores frequency into tuning word register Y.
+		There can be more than one ddsX_freqY file, which allows for
+		pin controlled FSK Frequency Shift Keying
+		(ddsX_pincontrol_freq_en is active) or the user can control
+		the desired active tuning word by writing Y to the
+		ddsX_freqsymbol file.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_freq_scaleY
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Scale to be applied to ddsX_freqY in order to obtain the
+		desired value in Hz. If shared across all frequency registers
+		Y is not present.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_freqsymbol
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Specifies the active output frequency tuning word. The value
+		corresponds to the Y in ddsX_freqY. To exit this mode the user
+		can write ddsX_pincontrol_freq_en or ddsX_out_disable file.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_phaseY
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Stores phase into phase register Y.
+		There can be more than one ddsX_phaseY file, which allows for
+		pin controlled PSK Phase Shift Keying
+		(ddsX_pincontrol_phase_en is active) or the user can
+		control the desired phase Y which is added to the phase
+		accumulator output by writing Y to the en_phase file.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_phase_scaleY
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Scale to be applied to ddsX_phaseY in order to obtain the
+		desired value in rad. If shared across all phase registers
+		Y is not present.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_phasesymbol
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Specifies the active phase Y which is added to the phase
+		accumulator output. The value corresponds to the Y in
+		ddsX_phaseY. To exit this mode the user can write
+		ddsX_pincontrol_phase_en or disable file.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_pincontrol_en
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Both, the active frequency and phase is controlled by the
+		respective phase and frequency control inputs.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_pincontrol_freq_en
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		The active frequency is controlled by the respective
+		frequency control/select inputs.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_pincontrol_phase_en
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		The active phase is controlled by the respective
+		phase control/select inputs.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_out_disable
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Disables any signal generation on all outputs.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_outY_disable
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Disables any signal generation on output Y.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_outY_wavetype
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Specifies the output waveform.
+		(sine, triangle, ramp, square, ...)
+		For a list of available output waveform options read
+		available_output_modes.
+
+What:		/sys/bus/iio/devices/device[n]/ddsX_outY_available_wavetypes
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Lists all available output waveform options.
--
1.6.0.2

