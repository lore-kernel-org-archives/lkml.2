Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab2F0EwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 00:52:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52890 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2F0EwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 00:52:08 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de, shawn.guo@linaro.org
Cc: linux@arm.linux.org.uk, richard.zhao@freescale.com,
        dirk.behme@de.bosch.com, amit.kachhap@linaro.org,
        amit.kucheria@linaro.org, lenb@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: [PATCH v6] ARM: imx: Add basic imx6q thermal driver
Date: Tue, 26 Jun 2012 23:51:54 -0500
Message-Id: <1340772715-22117-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on v3.5-rc4

This patch add basic thermal driver support for the imx6q platform.  This
was implemented by hooking into the linux thermal framework which provides
sysfs temperature readings and other data and a method to shutdown the system
if it gets too hot.

A major change in this revision is that cooling device implementation
was removed as it is dependent on cpufreq and no imx6q cpufreq exist upstream
and there is no recent activity on efforts to do so.

Other changes in v6.
1.  Fixed several problems that were pointed out in v5 review.
2.  Re-worked the sensor reading code to better handle suspend/resume case
3.  Made various naming changes to make it more specific to the anatop
 peripheral instead of the imx6q platform.  This should reduce the changes
 required to use this driver in future platforms.
4.  Removed test support for imx6q parts without calibrated temperature
 sensor fuses.  These devices will simply exit thermal driver initialization
 with a warning message.
5.  Made the thermal driver and the anatopmfd driver defaulted to be enabled
 in the Kconfig files which will still dependend on imx6q_soc being enabled.
 Not sure if this is the right place to do this or if it should be done
 in the defconfig file.

Known future work will be to add back in cooling device support once cpufreq
is supported.  Improvements to coincide with that work may involve adding
the active cooling trip points into device tree for hardware application
specific settings.

link to previous submissions:
v5" https://lkml.org/lkml/2012/6/20/57
v4: http://comments.gmane.org/gmane.linux.acpi.devel/51779
v3: http://www.spinics.net/lists/arm-kernel/msg155955.html
v2: http://www.spinics.net/lists/arm-kernel/msg155790.html
v1: http://www.spinics.net/lists/arm-kernel/msg155111.html

Changes in v5:
1. Modified to use anatop mfd driver for accessing anatop registers
2. Made necessary changes to work with latest generic CPU cooling code.
3. Added Config changes and functionality to allow testing on parts without
 without programmed temperature sensor calibration values.
4. General cleanup and addition of comments.

Changes in v4:
1.  Removed bad suspend/resume assignment into thermal class.  After further
examination and discussion with SoC designers, a sequence is now used
for making measurements that is is unaffected by system suspendresumes.
Temp Sensor automatically powers off in hardware during the low power mode
caused by a system suspend.
2.  Moved some structures from static to dynamic allocation.
3.  Added some noise handling to temperatuer sensor readings.

Changes in v3:
1. Fixed the various issues pointed out in v2
2. Made other code cleanup and a bit of re-organizing
3. Removed unecessary platform driver and device.

Changes in v2:
1. Cleaned up some style issues pointed out in v1
2. Made various other code cleanup and re-organizing
3. Added temperature sensor calibration
4. Created platform driver and device to hook into pm suspend.


Performed some basic testing to ensure proper cooling operating.  If
you want to test this, full testing requires imx6q cpufreq
implementation (not yet in v3.5).

Robert Lee (1):
  ARM: imx: Add basic imx6q thermal driver

 arch/arm/boot/dts/imx6q.dtsi         |    5 +
 drivers/mfd/Kconfig                  |    1 +
 drivers/thermal/Kconfig              |    9 +
 drivers/thermal/Makefile             |    1 +
 drivers/thermal/imx_anatop_thermal.c |  465 ++++++++++++++++++++++++++++++++++
 5 files changed, 481 insertions(+)
 create mode 100644 drivers/thermal/imx_anatop_thermal.c

-- 
1.7.10

