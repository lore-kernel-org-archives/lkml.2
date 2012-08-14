Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2HNOWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:22:36 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58945 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535Ab2HNOWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:22:33 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/14] MFD/ASoC/Input: twl4030-audio submodule DT support
Date: Tue, 14 Aug 2012 17:22:28 +0300
Message-Id: <1344954162-7985-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v1:
- Get the MCLK frequencey from twl-core driver (via new API)
- hs_extmute_disable_level parameter has been removed
- empty of_find_node_by_name() in of.h for !CONFIG_OF builds

Mark: the extmute GPIO handling (when it is used) remained in the codec driver
for now. I can think more on how to add support for this type of mute control.
If you can point me to other codec needing this it would help on designing
something which is common enough for other users.
As for now I have a separate series to add GPIO controlled output amps (hp/spk).
I will send that to review soon.

Introl mail from v1:

The following series adds DT support for the twl4030 audio submodule which
provides audio codec and vibra functionality.

The MFD core driver is probed via DT, it will create the needed child devices
based on the provided information in the DT blob.
Child drivers (vibra, ASoC codec) will parse the core's node if needed to get
the needed parameters for their configuration.

In the ASoC codec driver the hs_extmute callback (which was used to toggle a
GPIO line) has been removed. The codec driver will receive the GPIO number
(if it is needed on the platform).

If the series is OK (and no objections from the maintainers), it would be good
if this can go via audio. Changed files are well contained within the
twl4030-audio stack so I do not expect merge issues later.

The series has been tested on BeagleBoard (with the McBSP DT series, and with
the upcoming DT audio support for BeagleBoard).

Regards,
Peter
---
Peter Ujfalusi (14):
  MFD: twl4030-audio: Clean up MODULE_* and platform_driver part
  MFD: twl4030-audio: Convert to use devm_kzalloc
  MFD: twl4030-audio: Rearange and clean-up the probe function
  MFD: twl-core: Add API to query the HFCLK rate
  MFD: twl4030-audio: Get audio MCLK via twl-core API instead of pdata
  dt: Add empty of_find_node_by_name() function
  MFD: twl4030-audio: Add DT support
  Input: twl4030-vibra: Support for DT booted kernel
  ASoC: twl4030: Move hs_extmute GPIO handling to driver
  ARM: OMAP/ASoC: Zoom2: Let the codec to handle the hs_extmute GPIO
  ASoC/MFD: twl4030: Remove set_hs_extmute callback from platform data
  ASoC: twl4030: Convert to use devm_kzalloc
  ASoC: twl4030: Add pointer to pdata within the private data
  ASoC: twl4030: Support for DT booted kernel

 .../devicetree/bindings/mfd/twl4030-audio.txt      |   46 +++++++++
 arch/arm/mach-omap2/board-zoom-peripherals.c       |    9 +--
 arch/arm/mach-omap2/include/mach/board-zoom.h      |    2 -
 drivers/input/misc/twl4030-vibra.c                 |   20 ++++-
 drivers/mfd/twl-core.c                             |   32 ++++++
 drivers/mfd/twl4030-audio.c                        |  107 +++++++++++++-------
 include/linux/i2c/twl.h                            |    3 +-
 include/linux/of.h                                 |    6 +
 sound/soc/codecs/twl4030.c                         |  103 +++++++++++++++----
 sound/soc/omap/zoom2.c                             |    4 -
 10 files changed, 261 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/twl4030-audio.txt

-- 
1.7.8.6

