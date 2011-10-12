Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1JLNnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:43:20 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42533 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1JLNnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:43:19 -0400
Subject: [PATCH] ASoC: Make SND_SOC_SAARB and SND_SOC_TAVOREVB3 select
 MFD_88PM860X
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 21:43:08 +0800
Message-ID: <1318426988.5377.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In saarb_pm860x_init() and evb3_pm860x_init(), we call
pm860x_hs_jack_detect() and pm860x_mic_jack_detect() which in turn
calls pm860x_set_bits().
Thus make SND_SOC_SAARB and SND_SOC_TAVOREVB3 select MFD_88PM860X.

This patch fixes below build error if CONFIG_MFD_88PM860X is not configured.

  LD      .tmp_vmlinux1
sound/built-in.o: In function `pm860x_write_reg_cache':
last.c:(.text+0x29e9c): undefined reference to `pm860x_reg_write'
sound/built-in.o: In function `pm860x_set_bias_level':
last.c:(.text+0x29ecc): undefined reference to `pm860x_set_bits'
last.c:(.text+0x29f00): undefined reference to `pm860x_reg_write'
last.c:(.text+0x29f18): undefined reference to `pm860x_reg_write'
sound/built-in.o: In function `pm860x_read_reg_cache':
last.c:(.text+0x29f40): undefined reference to `pm860x_reg_read'
sound/built-in.o: In function `pm860x_probe':
last.c:(.text+0x2a034): undefined reference to `pm860x_bulk_read'
sound/built-in.o: In function `pm860x_codec_handler':
last.c:(.text+0x2a344): undefined reference to `pm860x_reg_read'
last.c:(.text+0x2a354): undefined reference to `pm860x_reg_read'
sound/built-in.o: In function `pm860x_mic_jack_detect':
last.c:(.text+0x2a450): undefined reference to `pm860x_set_bits'
sound/built-in.o: In function `pm860x_hs_jack_detect':
last.c:(.text+0x2a4d0): undefined reference to `pm860x_set_bits'
last.c:(.text+0x2a4f8): undefined reference to `pm860x_set_bits'
last.c:(.text+0x2a510): undefined reference to `pm860x_set_bits'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/pxa/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/pxa/Kconfig b/sound/soc/pxa/Kconfig
index 33ebc46b..ffd2242 100644
--- a/sound/soc/pxa/Kconfig
+++ b/sound/soc/pxa/Kconfig
@@ -121,6 +121,7 @@ config SND_PXA2XX_SOC_PALM27X
 config SND_SOC_SAARB
 	tristate "SoC Audio support for Marvell Saarb"
 	depends on SND_PXA2XX_SOC && MACH_SAARB
+	select MFD_88PM860X
 	select SND_PXA_SOC_SSP
 	select SND_SOC_88PM860X
 	help
@@ -130,6 +131,7 @@ config SND_SOC_SAARB
 config SND_SOC_TAVOREVB3
 	tristate "SoC Audio support for Marvell Tavor EVB3"
 	depends on SND_PXA2XX_SOC && MACH_TAVOREVB3
+	select MFD_88PM860X
 	select SND_PXA_SOC_SSP
 	select SND_SOC_88PM860X
 	help
-- 
1.7.4.1



