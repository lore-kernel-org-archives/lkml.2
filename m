Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1I0CuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:50:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42460 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1I0CuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:50:07 -0400
Subject: [RFC][PATCH] ASoC: Make wm1250-ev1 depends on GPIOLIB
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 10:49:59 +0800
Message-ID: <1317091799.315.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below build error if GPIO support is disabled.
Make wm1250-ev1 depends on GPIOLIB to fix below build error.

  CC      sound/soc/codecs/wm1250-ev1.o
sound/soc/codecs/wm1250-ev1.c:32:14: error: array type has incomplete element type
sound/soc/codecs/wm1250-ev1.c: In function ‘wm1250_ev1_pdata’:
sound/soc/codecs/wm1250-ev1.c:126:18: warning: type defaults to ‘int’ in type name
sound/soc/codecs/wm1250-ev1.c:126:18: warning: type defaults to ‘int’ in type name
sound/soc/codecs/wm1250-ev1.c:126:18: error: negative width in bit-field ‘<anonymous>’
sound/soc/codecs/wm1250-ev1.c:134:42: warning: type defaults to ‘int’ in type name
sound/soc/codecs/wm1250-ev1.c:134:42: warning: type defaults to ‘int’ in type name
sound/soc/codecs/wm1250-ev1.c:134:42: error: negative width in bit-field ‘<anonymous>’
sound/soc/codecs/wm1250-ev1.c: In function ‘wm1250_ev1_free’:
sound/soc/codecs/wm1250-ev1.c:155:34: warning: type defaults to ‘int’ in type name
sound/soc/codecs/wm1250-ev1.c:155:34: warning: type defaults to ‘int’ in type name
sound/soc/codecs/wm1250-ev1.c:155:34: error: negative width in bit-field ‘<anonymous>’
make[3]: *** [sound/soc/codecs/wm1250-ev1.o] Error 1
make[2]: *** [sound/soc/codecs] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I got the build error while trying to build for SND_MFLD_MACHINE and SND_SST_PLATFORM.
( "Enable ALSA for SoC audio support" and "Build all ASoC CODEC drivers" on X86 )

Axel
 sound/soc/codecs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 3449431..0ad80fe 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -58,7 +58,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_UDA134X
 	select SND_SOC_UDA1380 if I2C
 	select SND_SOC_WL1273 if MFD_WL1273_CORE
-	select SND_SOC_WM1250_EV1 if I2C
+	select SND_SOC_WM1250_EV1 if I2C && GPIOLIB
 	select SND_SOC_WM2000 if I2C
 	select SND_SOC_WM5100 if I2C
 	select SND_SOC_WM8350 if MFD_WM8350
-- 
1.7.4.1



