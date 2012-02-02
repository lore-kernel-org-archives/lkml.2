Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2BBMRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:17:16 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:59872 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755905Ab2BBMRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:17:14 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC 0/7] MFD: twl6040: Conversion to i2c driver
Date: Thu,  2 Feb 2012 14:16:52 +0200
Message-Id: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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
Peter Ujfalusi (7):
  MFD: twl-core: Detach twl6040 from the pmic mfd driver
  MFD: twl6040: Convert to i2c driver, and separate it from twl core
  ASoC: twl6040: Remove dependency on twl4030 from Kconfig
  OMAP: 4430sdp: Correct fixed regulator device ID
  OMAP: sdp4430: Add fixed regulator for twl6040 needs
  OMAP: omap4panda: Add fixed regulator for twl6040 needs
  MFD: TWL6040: Add regulator support for VIO, V2V1 supplies

 arch/arm/mach-omap2/board-4430sdp.c    |   77 +++++++++++++--
 arch/arm/mach-omap2/board-generic.c    |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c |   75 +++++++++++++--
 arch/arm/mach-omap2/twl-common.c       |   37 ++++++-
 arch/arm/mach-omap2/twl-common.h       |   10 +-
 drivers/input/misc/Kconfig             |    1 -
 drivers/input/misc/twl6040-vibra.c     |    4 +-
 drivers/mfd/Kconfig                    |    2 +-
 drivers/mfd/twl-core.c                 |   58 +++++++-----
 drivers/mfd/twl6040-core.c             |  165 ++++++++++++++++++++++++++------
 include/linux/i2c/twl.h                |   12 ---
 include/linux/mfd/twl6040.h            |   27 +++++
 sound/soc/codecs/Kconfig               |    2 +-
 sound/soc/codecs/twl6040.c             |    3 +-
 14 files changed, 375 insertions(+), 100 deletions(-)

-- 
1.7.8.4

