Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab1IOMkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:09 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:52562 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554Ab1IOMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:08 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 00/17] ASoC: twl6040: Cleanups and fixes
Date: Thu, 15 Sep 2011 15:39:22 +0300
Message-Id: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The first four patch of this series (the MFD/Input patches) has been already
sent to upstream to the relevant lists, but I wanted to include here as well,
since I have dependency on that series later on.
If it is OK with you, it would be best to merge these MFD/Input changes through
the audio tree for 3.2.

Code cleanup, and fixes for the twl6040 codec driver.
Main changes:
- reg_cache has been rested to chip defaults
- codec initialization changes
- Correction for the Earphone path
- AUX L/R output support
- Headset/Handsfree control name changes
- Headset DC offset workaround

Regards,
Peter

I have excluded the linux-input list (but kept Dmitry) - to not spam them.

---
Peter Ujfalusi (17):
  MFD: twl6040: Remove global pointer for platform_device
  MFD: twl6040: Add accessor for revision ID
  Input: twl6040-vibra: Use accessor to get revision information
  MFD: twl6040: Fix power on GPIO handling
  ASoC: twl6040: Chip initialization cleanup
  ASoC: twl6040: Use chip defaults in the initial reg_cache
  ASoC: twl6040: Lower the initial gains
  ASoC: twl6040: Fix comments for register names
  ASoC: twl6040: Remove strings "NULL" from DAPM route
  ASoC: twl6040: Introduce SW only shadow register
  ASoC: twl6040: Earphone path correction
  ASoC: twl6040: Use consistent names for Handsfree path
  ASoC: twl6040: Use consistent names for Headset path
  ASoC: twl6040: Support for AUX L/R output
  ASoC: twl6040/sdp4430: Change legacy DAI name
  ASoC/MFD: twl6040: Combine bit definitions for Headset control
    registers
  ASoC: twl6040: Workaround for headset DC offset caused pop noise

 drivers/input/misc/twl6040-vibra.c |    2 +-
 drivers/mfd/twl6040-core.c         |   38 ++--
 include/linux/mfd/twl6040.h        |   22 +--
 sound/soc/codecs/twl6040.c         |  367 +++++++++++++++++++-----------------
 sound/soc/omap/sdp4430.c           |    2 +-
 5 files changed, 218 insertions(+), 213 deletions(-)

-- 
1.7.6.1

