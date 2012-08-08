Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030230Ab2HHJls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:41:48 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:33926 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030198Ab2HHJlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:41:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH 00/11] MFD/ASoC/Input: twl4030-audio submodule DT support
Date: Wed,  8 Aug 2012 12:41:16 +0300
Message-Id: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following series adds DT support for the twl4030 audio submodule which
provides audio codec and vibra functionality.

The MFD core driver is probed via DT, it will create the needed child devices
based on the provided information in the DT blob.
Child drivers (vibra, ASoC codec) will parse the core's node if needed to get
the needed parameters for their configuration.

In the ASoC codec driver the hs_extmute callback (which was used to toggle a
GPIO line) has been removed. The codec driver will receive the GPIO number
(if it is needed on the platform) and also the level to disable the mute.

If the series is OK (and no objections from the maintainers), it would be good
if this can go via audio. Changed files are well contained within the
twl4030-audio stack so I do not expect merge issues later.

The series has been tested on BeagleBoard (with the McBSP DT series, and with
the upcoming DT audio support for BeagleBoard).

Regards,
Peter
---
Peter Ujfalusi (11):
  MFD: twl4030-audio: Clean up MODULE_* and platform_driver part
  MFD: twl4030-audio: Convert to use devm_kzalloc
  MFD: twl4030-audio: Rearange and clean-up the probe function
  MFD: twl4030-audio: Add DT support
  Input: twl4030-vibra: Support for DT booted kernel
  ASoC: twl4030: Move hs_extmute GPIO handling to driver
  ARM: OMAP/ASoC: Zoom2: Let the codec to handle the hs_extmute GPIO
  ASoC/MFD: twl4030: Remove set_hs_extmute callback from platform data
  ASoC: twl4030: Convert to use devm_kzalloc
  ASoC: twl4030: Add pointer to pdata within the private data
  ASoC: twl4030: Support for DT booted kernel

 .../devicetree/bindings/mfd/twl4030-audio.txt      |   51 +++++++++
 arch/arm/mach-omap2/board-zoom-peripherals.c       |    9 +-
 arch/arm/mach-omap2/include/mach/board-zoom.h      |    2 -
 drivers/input/misc/twl4030-vibra.c                 |   20 +++-
 drivers/mfd/twl4030-audio.c                        |  114 +++++++++++++------
 include/linux/i2c/twl.h                            |    4 +-
 sound/soc/codecs/twl4030.c                         |  117 ++++++++++++++++----
 sound/soc/omap/zoom2.c                             |    4 -
 8 files changed, 250 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/twl4030-audio.txt

-- 
1.7.8.6

