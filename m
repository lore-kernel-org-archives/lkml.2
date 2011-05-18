Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1ERPZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:25:19 -0400
Received: from smtp16.mail.ru ([94.100.176.153]:50992 "EHLO smtp16.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1ERPZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:25:17 -0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>, Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/3] ASoC: add support for audio on iPaq hx4700
Date: Wed, 18 May 2011 19:25:08 +0400
Message-Id: <1305732311-17639-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.4.rc3
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here's another version of patches adding audio support for good ole
iPAQ hx4700. It took a bit faster to make v3 than I expected, so here is it.

Previous versions can be found here:
https://lkml.org/lkml/2010/11/20/50 (v1)
https://lkml.org/lkml/2011/5/16/462 (v2)

This patchset is based on 'for-next' branch of Mark's ASoC git tree
(fetched today), also applies cleanly on linux-next-20110518.
Lightly tested on real hardware - playback/recording/mixer seem to work
without any glitches.

Changes v2 -> v3

* data based init is now used in codec and machine audio driver
  for DAPM and controls
* machine audio driver now is a proper platform driver, instantiating
  sound card with snd_soc_register_card()
* platform code registers corresponding platform_device for machine audio driver
* ak4641_sync() is dropped in favour of snd_soc_cache_sync()
* snd_soc_update_bits() is used instead of snd_soc_read()/update/snd_soc_write()
  sequences. Also return value of snd_soc_update_bits is propagated further
  for catching errors (previously result of snd_soc_write wasn't checked)
* gpio_request_array is used now in machine audio driver
* some other minor cleanup in the couple of places

Dmitry Artamonow (3):
  ASoC: Asahi Kasei AK4641 codec driver
  ASoC: add iPAQ hx4700 machine driver
  pxa/hx4700: add platform device and I2C info for AK4641 codec

 arch/arm/mach-pxa/hx4700.c              |   25 ++
 arch/arm/mach-pxa/include/mach/hx4700.h |    4 +-
 include/sound/ak4641.h                  |   26 ++
 sound/soc/codecs/Kconfig                |    4 +
 sound/soc/codecs/Makefile               |    2 +
 sound/soc/codecs/ak4641.c               |  664 +++++++++++++++++++++++++++++++
 sound/soc/codecs/ak4641.h               |   47 +++
 sound/soc/pxa/Kconfig                   |    9 +
 sound/soc/pxa/Makefile                  |    2 +
 sound/soc/pxa/hx4700.c                  |  255 ++++++++++++
 10 files changed, 1036 insertions(+), 2 deletions(-)
 create mode 100644 include/sound/ak4641.h
 create mode 100644 sound/soc/codecs/ak4641.c
 create mode 100644 sound/soc/codecs/ak4641.h
 create mode 100644 sound/soc/pxa/hx4700.c

-- 
1.7.4.rc3

