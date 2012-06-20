Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2FTHGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:06:13 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34903 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2FTHGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:06:12 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de, shawn.guo@linaro.org
Cc: linux@arm.linux.org.uk, richard.zhao@freescale.com,
        dirk.behme@de.bosch.com, amit.kachhap@linaro.org,
        amit.kucheria@linaro.org, lenb@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: [PATCH v5] ARM: imx: Add basic imx6q cpu thermal management
Date: Wed, 20 Jun 2012 02:06:03 -0500
Message-Id: <1340175964-4043-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on v3.5-rc3 plus recently submmited cpu_cooling functionality here:

http://www.spinics.net/lists/kernel/msg1340221.html

I am told this cpu cooling patch has been accepted and exists in len brown's
next branch.

link to previous submissions:
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
  ARM: imx: Add basic imx6q cpu thermal management

 arch/arm/boot/dts/imx6q.dtsi    |    5 +
 drivers/thermal/Kconfig         |   28 ++
 drivers/thermal/Makefile        |    1 +
 drivers/thermal/imx6q_thermal.c |  593 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 627 insertions(+)
 create mode 100644 drivers/thermal/imx6q_thermal.c

-- 
1.7.10

