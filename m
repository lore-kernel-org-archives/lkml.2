Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2B2UFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:05:04 -0500
Received: from csmtp3.one.com ([91.198.169.23]:18989 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab2B2UFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:05:00 -0500
From: Eric Andersson <eric.andersson@unixphere.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, christoph.mair@gmail.com,
        stefan.nilsson@unixphere.com, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCH 2/3] Documentation: add sysfs ABI documentation for bmp18x
Date: Wed, 29 Feb 2012 20:58:08 +0100
Message-Id: <1330545489-31169-3-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds sysfs documentation for Bosch Sensortec's BMP18x
pressure sensors.

Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
---
 Documentation/ABI/testing/sysfs-i2c-bmp18x |   31 ++++++++++++++++++++++++++++
 Documentation/ABI/testing/sysfs-spi-bmp18x |   31 ++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-i2c-bmp18x
 create mode 100644 Documentation/ABI/testing/sysfs-spi-bmp18x

diff --git a/Documentation/ABI/testing/sysfs-i2c-bmp18x b/Documentation/ABI/testing/sysfs-i2c-bmp18x
new file mode 100644
index 0000000..f6c5799
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-i2c-bmp18x
@@ -0,0 +1,31 @@
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/pressure0_input
+Date:		February 2012
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	Start a pressure measurement and read the result. Values
+		represent the ambient air pressure in pascal (0.01 millibar).
+
+		Reading: returns the current air pressure.
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/temp0_input
+Date:		February 2012
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	Measure the ambient temperature. The returned value represents
+		the ambient temperature in units of 0.1 degree celsius.
+
+		Reading: returns the current temperature.
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/oversampling
+Date:		February 2012
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	Tell the bmp18x to use more samples to calculate a pressure
+		value. When writing to this file the chip will use 2^x samples
+		to calculate the next pressure value with x being the value
+		written. Using this feature will decrease RMS noise and
+		increase the measurement time.
+
+		Reading: returns the current oversampling setting.
+
+		Writing: sets a new oversampling setting.
+		Accepted values: 0..3.
diff --git a/Documentation/ABI/testing/sysfs-spi-bmp18x b/Documentation/ABI/testing/sysfs-spi-bmp18x
new file mode 100644
index 0000000..e3a9be3
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-spi-bmp18x
@@ -0,0 +1,31 @@
+What:		/sys/bus/spi/devices/spi<busnum>.<chipselect>/pressure0_input
+Date:		February 2012
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	Start a pressure measurement and read the result. Values
+		represent the ambient air pressure in pascal (0.01 millibar).
+
+		Reading: returns the current air pressure.
+
+
+What:		/sys/bus/spi/devices/spi<busnum>.<chipselect>/temp0_input
+Date:		February 2012
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	Measure the ambient temperature. The returned value represents
+		the ambient temperature in units of 0.1 degree celsius.
+
+		Reading: returns the current temperature.
+
+
+What:		/sys/bus/spi/devices/spi<busnum>.<chipselect>/oversampling
+Date:		February 2012
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	Tell the bmp18x to use more samples to calculate a pressure
+		value. When writing to this file the chip will use 2^x samples
+		to calculate the next pressure value with x being the value
+		written. Using this feature will decrease RMS noise and
+		increase the measurement time.
+
+		Reading: returns the current oversampling setting.
+
+		Writing: sets a new oversampling setting.
+		Accepted values: 0..3.
-- 
1.7.3.4

