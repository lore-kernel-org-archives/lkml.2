Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab1IOM7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:59:50 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:41907 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933338Ab1IOM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:59:48 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: [PATCH 0/8] ASoC/MFD/Input: twl6040: Support for audio driven vibra
Date: Thu, 15 Sep 2011 15:59:13 +0300
Message-Id: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following series adds support for the soc driver to route audio (PCM
stream) to the vibra ports of the twl6040.
We have ALSA controls for the vibra source selection (PDM, or Input/FF).
The route can not be changed from Input/FF to PDM during ongoing effect coming
from Input/FF.
The Input/FF driver can not execute new effect, while the vibra source is
configured to be PDM.
TO get things working in legacy mode the omap-mcpdm, and twl6040 soc codec
driver's channel count needed to be fixed.

To minimize the need for reads through the I2C bus, the MFD driver will cache
the vibra control registers.

With this series we can route PCM audio to drive the twl6040 vibra output.
In order to that we need to play 5 channel audio, and place the vibra sample at
the 5th channel. This will change with ABE support (change == simplified).

The series depends on the previous two from me:
ASoC: twl6040: Cleanups and fixes
ASoC: omap-mcpdm/twl6040: Offset cancellation

Regards,
Peter

PS: Samuel, Dmitry, Liam: will it be possible to take this through Liam (via
audio), since we are going to have dependencies coming via audio.

---
Peter Ujfalusi (8):
  Input: twl6040: Simplify vibra regsiter definitions
  MFD: twl6040: Cache the vibra control registers
  MFD: twl6040: function to query the vibra status for clients
  Input: twl6040-vibra: Check the selected path for vibra
  ASoC: twl6040: Fix the number of channels for vibra
  ASoC: twl6040: Correct supported number of playback channels
  ASoC: omap-mcpdm: Correct the supported number of channels
  ASoC: twl6040: Support for vibra output paths

 drivers/input/misc/twl6040-vibra.c |   19 ++++++---
 drivers/mfd/twl6040-core.c         |   31 ++++++++++++--
 include/linux/mfd/twl6040.h        |   24 +++++------
 sound/soc/codecs/twl6040.c         |   78 ++++++++++++++++++++++++++++++++++-
 sound/soc/omap/omap-mcpdm.c        |   14 ++++---
 5 files changed, 134 insertions(+), 32 deletions(-)

-- 
1.7.6.1

