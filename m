Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1IWGuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:50:39 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:34886 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580Ab1IWGuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:50:18 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: [PATCH v2 0/6] ASoC/MFD/Input: twl6040: Support for audio driven vibra
Date: Fri, 23 Sep 2011 09:49:38 +0300
Message-Id: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v1:
- Patches already taken by Mark has been removed
- Patch 4: Return -EBUSY instead of -EPERM

Intro mail form v1:
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

The series has been created on top of:
git://opensource.wolfsonmicro.com/linux-2.6-asoc, for-3.2 branch

If there are no objections, it would be good if this series goes via audio.

Regards,
Peter
---
Peter Ujfalusi (6):
  Input: twl6040: Simplify vibra regsiter definitions
  MFD: twl6040: Cache the vibra control registers
  MFD: twl6040: function to query the vibra status for clients
  Input: twl6040-vibra: Check the selected path for vibra
  ASoC: omap-mcpdm: Correct the supported number of channels
  ASoC: twl6040: Support for vibra output paths

 drivers/input/misc/twl6040-vibra.c |   19 ++++++---
 drivers/mfd/twl6040-core.c         |   31 +++++++++++++--
 include/linux/mfd/twl6040.h        |   24 +++++------
 sound/soc/codecs/twl6040.c         |   72 ++++++++++++++++++++++++++++++++++++
 sound/soc/omap/omap-mcpdm.c        |   14 ++++---
 5 files changed, 131 insertions(+), 29 deletions(-)

-- 
1.7.6.1

