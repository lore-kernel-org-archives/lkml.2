Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab1JLI6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:58:13 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:54436 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab1JLI6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:58:11 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <samuel.ortiz@intel.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        alsa-devel@alsa-project.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH v3 0/5] ASoC/MFD/Input: twl6040: Support for audio driven vibra
Date: Wed, 12 Oct 2011 11:57:52 +0300
Message-Id: <1318409877-21681-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v2:
- Rebased on git://opensource.wolfsonmicro.com/linux-2.6-asoc, for-3.2 branch
- Acked-by lines added to patches.

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
Peter Ujfalusi (5):
  Input: twl6040: Simplify vibra regsiter definitions
  MFD: twl6040: Cache the vibra control registers
  MFD: twl6040: function to query the vibra status for clients
  Input: twl6040-vibra: Check the selected path for vibra
  ASoC: twl6040: Support for vibra output paths

 drivers/input/misc/twl6040-vibra.c |   19 ++++++---
 drivers/mfd/twl6040-core.c         |   31 +++++++++++++--
 include/linux/mfd/twl6040.h        |   24 +++++------
 sound/soc/codecs/twl6040.c         |   72 ++++++++++++++++++++++++++++++++++++
 4 files changed, 123 insertions(+), 23 deletions(-)

-- 
1.7.7

