Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab1FWOsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:48:10 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:58421 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753335Ab1FWOsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:48:08 -0400
Date: Thu, 23 Jun 2011 15:47:50 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mips@linux-mips.org
Subject: [PATCH] SOUND: Fix non-ISA_DMA_API build failure
Message-ID: <20110623144750.GA10180@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A build with ISA && ISA_DMA && !ISA_DMA_API results in:

  CC      sound/isa/es18xx.o
sound/isa/es18xx.c: In function ‘snd_es18xx_playback1_prepare’:
sound/isa/es18xx.c:501:9: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/es18xx.c: In function ‘snd_es18xx_playback_pointer’:
sound/isa/es18xx.c:818:3: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[2]: *** [sound/isa/es18xx.o] Error 1
  CC      sound/isa/sscape.o
sound/isa/sscape.c: In function ‘upload_dma_data’:
sound/isa/sscape.c:481:3: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[2]: *** [sound/isa/sscape.o] Error 1
  CC      sound/isa/ad1816a/ad1816a_lib.o
sound/isa/ad1816a/ad1816a_lib.c: In function ‘snd_ad1816a_playback_prepare’:
sound/isa/ad1816a/ad1816a_lib.c:244:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/ad1816a/ad1816a_lib.c: In function ‘snd_ad1816a_playback_pointer’:
sound/isa/ad1816a/ad1816a_lib.c:302:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
sound/isa/ad1816a/ad1816a_lib.c: In function ‘snd_ad1816a_free’:
sound/isa/ad1816a/ad1816a_lib.c:544:3: error: implicit declaration of function ‘snd_dma_disable’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/ad1816a/ad1816a_lib.o] Error 1
make[3]: Target `__build' not remade because of errors.
make[2]: *** [sound/isa/ad1816a] Error 2
  CC      sound/isa/es1688/es1688_lib.o
sound/isa/es1688/es1688_lib.c: In function ‘snd_es1688_playback_prepare’:
sound/isa/es1688/es1688_lib.c:417:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/es1688/es1688_lib.c: In function ‘snd_es1688_playback_pointer’:
sound/isa/es1688/es1688_lib.c:509:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/es1688/es1688_lib.o] Error 1
make[3]: Target `__build' not remade because of errors.
make[2]: *** [sound/isa/es1688] Error 2
  CC      sound/isa/gus/gus_dma.o
sound/isa/gus/gus_dma.c: In function ‘snd_gf1_dma_program’:
sound/isa/gus/gus_dma.c:79:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/gus/gus_dma.c: In function ‘snd_gf1_dma_done’:
sound/isa/gus/gus_dma.c:177:3: error: implicit declaration of function ‘snd_dma_disable’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/gus/gus_dma.o] Error 1
  CC      sound/isa/gus/gus_pcm.o
sound/isa/gus/gus_pcm.c: In function ‘snd_gf1_pcm_capture_prepare’:
sound/isa/gus/gus_pcm.c:591:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/gus/gus_pcm.c: In function ‘snd_gf1_pcm_capture_pointer’:
sound/isa/gus/gus_pcm.c:619:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/gus/gus_pcm.o] Error 1
make[3]: Target `__build' not remade because of errors.
make[2]: *** [sound/isa/gus] Error 2
  CC      sound/isa/sb/sb16_csp.o
sound/isa/sb/sb16_csp.c: In function ‘snd_sb_csp_ioctl’:
sound/isa/sb/sb16_csp.c:228:227: error: case label does not reduce to an integer constant
make[3]: *** [sound/isa/sb/sb16_csp.o] Error 1
  CC      sound/isa/sb/sb16_main.o
sound/isa/sb/sb16_main.c: In function ‘snd_sb16_playback_prepare’:
sound/isa/sb/sb16_main.c:276:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/sb/sb16_main.c: In function ‘snd_sb16_playback_pointer’:
sound/isa/sb/sb16_main.c:456:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/sb/sb16_main.o] Error 1
  CC      sound/isa/sb/sb8_main.o
sound/isa/sb/sb8_main.c: In function ‘snd_sb8_playback_prepare’:
sound/isa/sb/sb8_main.c:172:3: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/sb/sb8_main.c: In function ‘snd_sb8_playback_pointer’:
sound/isa/sb/sb8_main.c:425:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/sb/sb8_main.o] Error 1
make[3]: Target `__build' not remade because of errors.
make[2]: *** [sound/isa/sb] Error 2
  CC      sound/isa/wss/wss_lib.o
sound/isa/wss/wss_lib.c: In function ‘snd_wss_playback_prepare’:
sound/isa/wss/wss_lib.c:1025:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
sound/isa/wss/wss_lib.c: In function ‘snd_wss_playback_pointer’:
sound/isa/wss/wss_lib.c:1160:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
sound/isa/wss/wss_lib.c: In function ‘snd_wss_free’:
sound/isa/wss/wss_lib.c:1695:3: error: implicit declaration of function ‘snd_dma_disable’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [sound/isa/wss/wss_lib.o] Error 1

Disabling these in Kconfig by adding a dependency on ISA_DMA_API then
results in:

warning: (RADIO_MIROPCM20) selects SND_ISA which has unmet direct dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API)
warning: (RADIO_MIROPCM20) selects SND_MIRO which has unmet direct dependencies (SOUND && !M68K && SND && SND_ISA && ISA_DMA_API)
#
[...]
  LD      .tmp_vmlinux1
sound/built-in.o: In function `snd_miro_probe':
/home/ralf/src/linux/linux-mips/sound/isa/opti9xx/miro.c:1321: undefined reference to `snd_wss_create'
/home/ralf/src/linux/linux-mips/sound/isa/opti9xx/miro.c:1327: undefined reference to `snd_wss_pcm'
/home/ralf/src/linux/linux-mips/sound/isa/opti9xx/miro.c:1331: undefined reference to `snd_wss_mixer'
/home/ralf/src/linux/linux-mips/sound/isa/opti9xx/miro.c:1335: undefined reference to `snd_wss_timer'
/home/ralf/src/linux/linux-mips/sound/isa/opti9xx/miro.c:1391: undefined reference to `snd_opl4_create'
make: *** [.tmp_vmlinux1] Error 1

Which makes also touching drivers/media/radio/Kconfig necessary.

Fixed by adding an explicit dependency on ISA_DMA_API for all of the
config statment that either result in the direction inclusion of code that
calls the ISA DMA API or selects something which in turn would use the ISA
DMA API.

The sole ISA sound driver that does not use the ISA DMA API is the Adlib
driver so replaced the dependency of SND_ISA on ISA_DMA_API and add it to
each of the drivers individually.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

---
With this (and a separate MIPS-specific patch) I can get all audio drivers
in allyesconfig to build.

The generated i386/x86_64 allyesconfigs remain unchanged by this patch.

 drivers/media/radio/Kconfig |    2 +-
 sound/isa/Kconfig           |   40 ++++++++++++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index e4c97fd..0aeed28 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -168,7 +168,7 @@ config RADIO_MAXIRADIO
 
 config RADIO_MIROPCM20
 	tristate "miroSOUND PCM20 radio"
-	depends on ISA && VIDEO_V4L2 && SND
+	depends on ISA && ISA_DMA_API && VIDEO_V4L2 && SND
 	select SND_ISA
 	select SND_MIRO
 	---help---
diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index 52064cf..25230c8 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -19,7 +19,7 @@ config SND_SB16_DSP
 
 menuconfig SND_ISA
 	bool "ISA sound devices"
-	depends on ISA && ISA_DMA_API
+	depends on ISA
 	default y
 	help
 	  Support for sound devices connected via the ISA bus.
@@ -37,7 +37,7 @@ config SND_ADLIB
 
 config SND_AD1816A
 	tristate "Analog Devices SoundPort AD1816A"
-	depends on PNP
+	depends on ISA_DMA_API && PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -52,6 +52,7 @@ config SND_AD1816A
 config SND_AD1848
 	tristate "Generic AD1848/CS4248 driver"
 	select SND_WSS_LIB
+	depends on ISA_DMA_API
 	help
 	  Say Y here to include support for AD1848 (Analog Devices) or
 	  CS4248 (Cirrus Logic - Crystal Semiconductors) chips.
@@ -64,7 +65,7 @@ config SND_AD1848
 
 config SND_ALS100
 	tristate "Diamond Tech. DT-019x and Avance Logic ALSxxx"
-	depends on PNP
+	depends on ISA_DMA_API && PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -79,7 +80,7 @@ config SND_ALS100
 
 config SND_AZT1605
 	tristate "Aztech AZT1605 Driver"
-	depends on SND
+	depends on ISA_DMA_API && SND
 	select SND_WSS_LIB
 	select SND_MPU401_UART
 	select SND_OPL3_LIB
@@ -92,7 +93,7 @@ config SND_AZT1605
 
 config SND_AZT2316
 	tristate "Aztech AZT2316 Driver"
-	depends on SND
+	depends on ISA_DMA_API && SND
 	select SND_WSS_LIB
 	select SND_MPU401_UART
 	select SND_OPL3_LIB
@@ -105,7 +106,7 @@ config SND_AZT2316
 
 config SND_AZT2320
 	tristate "Aztech Systems AZT2320"
-	depends on PNP
+	depends on ISA_DMA_API && PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -119,6 +120,7 @@ config SND_AZT2320
 
 config SND_CMI8330
 	tristate "C-Media CMI8330"
+	depends on ISA_DMA_API
 	select SND_WSS_LIB
 	select SND_SB16_DSP
 	select SND_OPL3_LIB
@@ -132,6 +134,7 @@ config SND_CMI8330
 
 config SND_CS4231
 	tristate "Generic Cirrus Logic CS4231 driver"
+	depends on ISA_DMA_API
 	select SND_MPU401_UART
 	select SND_WSS_LIB
 	help
@@ -143,6 +146,7 @@ config SND_CS4231
 
 config SND_CS4236
 	tristate "Generic Cirrus Logic CS4232/CS4236+ driver"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_WSS_LIB
@@ -156,6 +160,7 @@ config SND_CS4236
 
 config SND_ES1688
 	tristate "Generic ESS ES688/ES1688 and ES968 PnP driver"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -168,6 +173,7 @@ config SND_ES1688
 
 config SND_ES18XX
 	tristate "Generic ESS ES18xx driver"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -179,7 +185,7 @@ config SND_ES18XX
 
 config SND_SC6000
 	tristate "Gallant SC-6000/6600/7000 and Audio Excel DSP 16"
-	depends on HAS_IOPORT
+	depends on ISA_DMA_API && HAS_IOPORT
 	select SND_WSS_LIB
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -195,6 +201,7 @@ config SND_SC6000
 
 config SND_GUSCLASSIC
 	tristate "Gravis UltraSound Classic"
+	depends on ISA_DMA_API
 	select SND_RAWMIDI
 	select SND_PCM
 	help
@@ -206,6 +213,7 @@ config SND_GUSCLASSIC
 
 config SND_GUSEXTREME
 	tristate "Gravis UltraSound Extreme"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -218,6 +226,7 @@ config SND_GUSEXTREME
 
 config SND_GUSMAX
 	tristate "Gravis UltraSound MAX"
+	depends on ISA_DMA_API
 	select SND_RAWMIDI
 	select SND_WSS_LIB
 	help
@@ -229,7 +238,7 @@ config SND_GUSMAX
 
 config SND_INTERWAVE
 	tristate "AMD InterWave, Gravis UltraSound PnP"
-	depends on PNP
+	depends on ISA_DMA_API && PNP
 	select SND_RAWMIDI
 	select SND_WSS_LIB
 	help
@@ -242,7 +251,7 @@ config SND_INTERWAVE
 
 config SND_INTERWAVE_STB
 	tristate "AMD InterWave + TEA6330T (UltraSound 32-Pro)"
-	depends on PNP
+	depends on ISA_DMA_API && PNP
 	select SND_RAWMIDI
 	select SND_WSS_LIB
 	help
@@ -255,6 +264,7 @@ config SND_INTERWAVE_STB
 
 config SND_JAZZ16
 	tristate "Media Vision Jazz16 card and compatibles"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_SB8_DSP
@@ -271,6 +281,7 @@ config SND_JAZZ16
 
 config SND_OPL3SA2
 	tristate "Yamaha OPL3-SA2/SA3"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_WSS_LIB
@@ -283,6 +294,7 @@ config SND_OPL3SA2
 
 config SND_OPTI92X_AD1848
 	tristate "OPTi 82C92x - AD1848"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_OPL4_LIB
 	select SND_MPU401_UART
@@ -296,6 +308,7 @@ config SND_OPTI92X_AD1848
 
 config SND_OPTI92X_CS4231
 	tristate "OPTi 82C92x - CS4231"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_OPL4_LIB
 	select SND_MPU401_UART
@@ -309,6 +322,7 @@ config SND_OPTI92X_CS4231
 
 config SND_OPTI93X
 	tristate "OPTi 82C93x"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_WSS_LIB
@@ -321,6 +335,7 @@ config SND_OPTI93X
 
 config SND_MIRO
 	tristate "Miro miroSOUND PCM1pro/PCM12/PCM20radio driver"
+	depends on ISA_DMA_API
 	select SND_OPL4_LIB
 	select SND_WSS_LIB
 	select SND_MPU401_UART
@@ -334,6 +349,7 @@ config SND_MIRO
 
 config SND_SB8
 	tristate "Sound Blaster 1.0/2.0/Pro (8-bit)"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_RAWMIDI
 	select SND_SB8_DSP
@@ -346,6 +362,7 @@ config SND_SB8
 
 config SND_SB16
 	tristate "Sound Blaster 16 (PnP)"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_SB16_DSP
@@ -358,6 +375,7 @@ config SND_SB16
 
 config SND_SBAWE
 	tristate "Sound Blaster AWE (32,64) (PnP)"
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_SB16_DSP
@@ -370,7 +388,7 @@ config SND_SBAWE
 
 config SND_SB16_CSP
 	bool "Sound Blaster 16/AWE CSP support"
-	depends on (SND_SB16 || SND_SBAWE) && (BROKEN || !PPC)
+	depends on ISA_DMA_API && (SND_SB16 || SND_SBAWE) && (BROKEN || !PPC)
 	select FW_LOADER
 	help
 	  Say Y here to include support for the CSP core.  This special
@@ -379,6 +397,7 @@ config SND_SB16_CSP
 
 config SND_SSCAPE
 	tristate "Ensoniq SoundScape driver"
+	depends on ISA_DMA_API
 	select SND_MPU401_UART
 	select SND_WSS_LIB
 	select FW_LOADER
@@ -400,6 +419,7 @@ config SND_SSCAPE
 
 config SND_WAVEFRONT
 	tristate "Turtle Beach Maui,Tropez,Tropez+ (Wavefront)"
+	depends on ISA_DMA_API
 	select FW_LOADER
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
