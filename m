Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab2B1Iii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:38:38 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:39216 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932524Ab2B1Iih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:38:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of peter.ujfalusi@ti.com designates 10.112.45.74 as permitted sender) smtp.mail=peter.ujfalusi@ti.com
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] MFD: twl6040: Conversion to i2c driver
Date: Tue, 28 Feb 2012 10:34:50 +0200
Message-Id: <1330418092-12314-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v3:
- Combined the main patch (conversion to i2c driver) with changes in Kconfig
  files to avoid build breakage on other platforms
- Added the received Acks from maintainers

Samuel: is it possible for you to stop carrying the twl6040 changes you have at
the moment in your for-next branch (can you drop the patches)?
This series will make sure I will not brake x86_64 allmodconfig build.

As we agreed this series will go via the audio tree (Liam) since it has
dependency on earlier work of mine going through ASoC tree.

Thank you.

------
Intro mail from the original series:

This series will convert the twl6040 MFD driver to an i2c driver.
Compared to older twl4030/5030/TPS the twl6040 is a standalone audio IC. It is
better if the twl6040-core (and all of it's child devices) does not depend on
the twl-core since it has nothing to with it.

With this conversion the dependency on twl can be dropped from the twl6040
driver stack (core, vibra, audio).

Between the first and second patch the audio will not probe on OMAP4, but I felt
it is better this way at least for the first RFC series to not have too big
change within one patch. The two patch can be squashed together later if no
objections.


Regards,
Peter
---
Peter Ujfalusi (2):
  MFD: twl-core: Detach twl6040 from the pmic mfd driver
  MFD: twl6040: Convert to i2c driver, and separate it from twl core

 arch/arm/mach-omap2/board-4430sdp.c    |   12 ++--
 arch/arm/mach-omap2/board-generic.c    |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c |   13 ++--
 arch/arm/mach-omap2/twl-common.c       |   37 +++++++++--
 arch/arm/mach-omap2/twl-common.h       |   10 +--
 drivers/input/misc/Kconfig             |    3 +-
 drivers/input/misc/twl6040-vibra.c     |    4 +-
 drivers/mfd/Kconfig                    |   11 +++-
 drivers/mfd/twl-core.c                 |   58 +++++++++-------
 drivers/mfd/twl6040-core.c             |  114 +++++++++++++++++++-------------
 include/linux/i2c/twl.h                |   12 ----
 include/linux/mfd/twl6040.h            |   27 ++++++++
 sound/soc/codecs/Kconfig               |    3 +-
 sound/soc/codecs/twl6040.c             |    3 +-
 sound/soc/omap/Kconfig                 |    2 +-
 15 files changed, 192 insertions(+), 119 deletions(-)

-- 
1.7.8.4

