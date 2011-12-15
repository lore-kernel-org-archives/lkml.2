Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab1LOD1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:27:09 -0500
Received: from ozlabs.org ([203.10.76.45]:52020 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654Ab1LODXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:23:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
Subject: [PATCH 13/15] module_param: make bool parameters really bool (sound)
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 15 Dec 2011 13:49:36 +1030
Message-ID: <87boraserb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_param(bool) used to counter-intuitively take an int.  In
fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
trick.

It's time to remove the int/unsigned int option.  For this version
it'll simply give a warning, but it'll break next kernel version.

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/DocBook/writing-an-alsa-driver.tmpl |    2 +-
 sound/core/oss/pcm_oss.c                          |    2 +-
 sound/core/seq/seq_dummy.c                        |    2 +-
 sound/drivers/aloop.c                             |    2 +-
 sound/drivers/dummy.c                             |    6 +++---
 sound/drivers/ml403-ac97cr.c                      |    2 +-
 sound/drivers/mpu401/mpu401.c                     |    6 +++---
 sound/drivers/mts64.c                             |    2 +-
 sound/drivers/opl3/opl3_midi.c                    |    2 +-
 sound/drivers/opl3/opl3_seq.c                     |    2 +-
 sound/drivers/pcsp/pcsp.c                         |    4 ++--
 sound/drivers/pcsp/pcsp_lib.c                     |    2 +-
 sound/drivers/portman2x4.c                        |    2 +-
 sound/drivers/serial-u16550.c                     |    4 ++--
 sound/drivers/virmidi.c                           |    2 +-
 sound/isa/ad1816a/ad1816a.c                       |    2 +-
 sound/isa/ad1848/ad1848.c                         |    4 ++--
 sound/isa/adlib.c                                 |    2 +-
 sound/isa/als100.c                                |    2 +-
 sound/isa/azt2320.c                               |    2 +-
 sound/isa/cmi8330.c                               |    4 ++--
 sound/isa/cs423x/cs4231.c                         |    2 +-
 sound/isa/cs423x/cs4236.c                         |    4 ++--
 sound/isa/es1688/es1688.c                         |    4 ++--
 sound/isa/es18xx.c                                |    4 ++--
 sound/isa/galaxy/galaxy.c                         |    2 +-
 sound/isa/gus/gusclassic.c                        |    2 +-
 sound/isa/gus/gusextreme.c                        |    2 +-
 sound/isa/gus/gusmax.c                            |    2 +-
 sound/isa/gus/interwave.c                         |    4 ++--
 sound/isa/msnd/msnd_pinnacle.c                    |    2 +-
 sound/isa/opl3sa2.c                               |    4 ++--
 sound/isa/opti9xx/miro.c                          |    2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                |    2 +-
 sound/isa/sb/jazz16.c                             |    2 +-
 sound/isa/sb/sb16.c                               |    4 ++--
 sound/isa/sb/sb8.c                                |    2 +-
 sound/isa/sc6000.c                                |    2 +-
 sound/isa/wavefront/wavefront.c                   |    6 +++---
 sound/oss/ad1848.c                                |    8 ++++----
 sound/oss/msnd_pinnacle.c                         |    2 +-
 sound/oss/pas2_card.c                             |   12 ++++++------
 sound/oss/pss.c                                   |   10 +++++-----
 sound/oss/trix.c                                  |    2 +-
 sound/pci/ac97/ac97_codec.c                       |    2 +-
 sound/pci/ad1889.c                                |    2 +-
 sound/pci/ali5451/ali5451.c                       |    4 ++--
 sound/pci/als4000.c                               |    2 +-
 sound/pci/asihpi/asihpi.c                         |    4 ++--
 sound/pci/atiixp.c                                |    4 ++--
 sound/pci/atiixp_modem.c                          |    2 +-
 sound/pci/au88x0/au88x0.c                         |    2 +-
 sound/pci/aw2/aw2-alsa.c                          |    2 +-
 sound/pci/azt3328.c                               |    2 +-
 sound/pci/bt87x.c                                 |    4 ++--
 sound/pci/ca0106/ca0106_main.c                    |    2 +-
 sound/pci/cmipci.c                                |    4 ++--
 sound/pci/cs4281.c                                |    4 ++--
 sound/pci/cs46xx/cs46xx.c                         |    8 ++++----
 sound/pci/cs5535audio/cs5535audio.c               |    2 +-
 sound/pci/ctxfi/cttimer.c                         |    4 ++--
 sound/pci/ctxfi/xfi.c                             |    2 +-
 sound/pci/echoaudio/echoaudio.c                   |    2 +-
 sound/pci/emu10k1/emu10k1.c                       |    4 ++--
 sound/pci/emu10k1/emu10k1x.c                      |    2 +-
 sound/pci/ens1370.c                               |    4 ++--
 sound/pci/es1938.c                                |    2 +-
 sound/pci/es1968.c                                |    4 ++--
 sound/pci/fm801.c                                 |    2 +-
 sound/pci/hda/hda_intel.c                         |    8 ++++----
 sound/pci/ice1712/ice1712.c                       |    4 ++--
 sound/pci/ice1712/ice1724.c                       |    2 +-
 sound/pci/intel8x0.c                              |    6 +++---
 sound/pci/intel8x0m.c                             |    2 +-
 sound/pci/korg1212/korg1212.c                     |    2 +-
 sound/pci/lola/lola.c                             |    2 +-
 sound/pci/lx6464es/lx6464es.c                     |    2 +-
 sound/pci/maestro3.c                              |    4 ++--
 sound/pci/mixart/mixart.c                         |    2 +-
 sound/pci/nm256/nm256.c                           |   12 ++++++------
 sound/pci/oxygen/oxygen.c                         |    2 +-
 sound/pci/oxygen/virtuoso.c                       |    2 +-
 sound/pci/pcxhr/pcxhr.c                           |    4 ++--
 sound/pci/riptide/riptide.c                       |    2 +-
 sound/pci/rme32.c                                 |    4 ++--
 sound/pci/rme96.c                                 |    2 +-
 sound/pci/rme9652/hdsp.c                          |    2 +-
 sound/pci/rme9652/hdspm.c                         |    2 +-
 sound/pci/rme9652/rme9652.c                       |    4 ++--
 sound/pci/sis7019.c                               |    2 +-
 sound/pci/sonicvibes.c                            |    6 +++---
 sound/pci/trident/trident.c                       |    2 +-
 sound/pci/via82xx.c                               |    4 ++--
 sound/pci/via82xx_modem.c                         |    2 +-
 sound/pci/vx222/vx222.c                           |    4 ++--
 sound/pci/ymfpci/ymfpci.c                         |    4 ++--
 sound/pcmcia/pdaudiocf/pdaudiocf.c                |    2 +-
 sound/pcmcia/vx/vxpocket.c                        |    2 +-
 sound/ppc/powermac.c                              |    2 +-
 sound/sh/aica.c                                   |    2 +-
 sound/sparc/amd7930.c                             |    2 +-
 sound/sparc/cs4231.c                              |    2 +-
 sound/sparc/dbri.c                                |    2 +-
 sound/usb/6fire/chip.c                            |    2 +-
 sound/usb/caiaq/device.c                          |    2 +-
 sound/usb/card.c                                  |    6 +++---
 sound/usb/misc/ua101.c                            |    2 +-
 sound/usb/usx2y/us122l.c                          |    2 +-
 sound/usb/usx2y/usbusx2y.c                        |    2 +-
 109 files changed, 172 insertions(+), 172 deletions(-)

diff --git a/Documentation/DocBook/writing-an-alsa-driver.tmpl b/Documentation/DocBook/writing-an-alsa-driver.tmpl
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -404,7 +404,7 @@
   /* SNDRV_CARDS: maximum number of cards supported by this module */
   static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
   static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-  static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+  static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
   /* definition of the chip-specific record */
   struct mychip {
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -47,7 +47,7 @@
 
 static int dsp_map[SNDRV_CARDS];
 static int adsp_map[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)] = 1};
-static int nonblock_open = 1;
+static bool nonblock_open = 1;
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>, Abramo Bagnara <abramo@alsa-project.org>");
 MODULE_DESCRIPTION("PCM OSS emulation for ALSA.");
diff --git a/sound/core/seq/seq_dummy.c b/sound/core/seq/seq_dummy.c
--- a/sound/core/seq/seq_dummy.c
+++ b/sound/core/seq/seq_dummy.c
@@ -65,7 +65,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("snd-seq-client-" __stringify(SNDRV_SEQ_CLIENT_DUMMY));
 
 static int ports = 1;
-static int duplex;
+static bool duplex;
 
 module_param(ports, int, 0444);
 MODULE_PARM_DESC(ports, "number of ports to be created");
diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -51,7 +51,7 @@ MODULE_SUPPORTED_DEVICE("{{ALSA,Loopback
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 0};
+static bool enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 0};
 static int pcm_substreams[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 8};
 static int pcm_notify[SNDRV_CARDS];
 
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -60,15 +60,15 @@ MODULE_SUPPORTED_DEVICE("{{ALSA,Dummy so
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 0};
+static bool enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 0};
 static char *model[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = NULL};
 static int pcm_devs[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 static int pcm_substreams[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 8};
 //static int midi_devs[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 2};
 #ifdef CONFIG_HIGH_RES_TIMERS
-static int hrtimer = 1;
+static bool hrtimer = 1;
 #endif
-static int fake_buffer = 1;
+static bool fake_buffer = 1;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for dummy soundcard.");
diff --git a/sound/drivers/ml403-ac97cr.c b/sound/drivers/ml403-ac97cr.c
--- a/sound/drivers/ml403-ac97cr.c
+++ b/sound/drivers/ml403-ac97cr.c
@@ -73,7 +73,7 @@ MODULE_SUPPORTED_DEVICE("{{Xilinx,ML403 
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for ML403 AC97 Controller Reference.");
diff --git a/sound/drivers/mpu401/mpu401.c b/sound/drivers/mpu401/mpu401.c
--- a/sound/drivers/mpu401/mpu401.c
+++ b/sound/drivers/mpu401/mpu401.c
@@ -35,13 +35,13 @@ MODULE_LICENSE("GPL");
 
 static int index[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = -2}; /* exclude the first card */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 #ifdef CONFIG_PNP
-static int pnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool pnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 #endif
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* MPU-401 port number */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* MPU-401 IRQ */
-static int uart_enter[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool uart_enter[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for MPU-401 device.");
diff --git a/sound/drivers/mts64.c b/sound/drivers/mts64.c
--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -36,7 +36,7 @@
 
 static int index[SNDRV_CARDS]  = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS]   = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 static struct platform_device *platform_devices[SNDRV_CARDS]; 
 static int device_count;
diff --git a/sound/drivers/opl3/opl3_midi.c b/sound/drivers/opl3/opl3_midi.c
--- a/sound/drivers/opl3/opl3_midi.c
+++ b/sound/drivers/opl3/opl3_midi.c
@@ -27,7 +27,7 @@
 
 extern char snd_opl3_regmap[MAX_OPL2_VOICES][4];
 
-extern int use_internal_drums;
+extern bool use_internal_drums;
 
 static void snd_opl3_note_off_unsafe(void *p, int note, int vel,
 				     struct snd_midi_channel *chan);
diff --git a/sound/drivers/opl3/opl3_seq.c b/sound/drivers/opl3/opl3_seq.c
--- a/sound/drivers/opl3/opl3_seq.c
+++ b/sound/drivers/opl3/opl3_seq.c
@@ -32,7 +32,7 @@ MODULE_AUTHOR("Uros Bizjak <uros@kss-lok
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ALSA driver for OPL3 FM synth");
 
-int use_internal_drums = 0;
+bool use_internal_drums = 0;
 module_param(use_internal_drums, bool, 0444);
 MODULE_PARM_DESC(use_internal_drums, "Enable internal OPL2/3 drums.");
 
diff --git a/sound/drivers/pcsp/pcsp.c b/sound/drivers/pcsp/pcsp.c
--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -25,8 +25,8 @@ MODULE_ALIAS("platform:pcspkr");
 
 static int index = SNDRV_DEFAULT_IDX1;	/* Index 0-MAX */
 static char *id = SNDRV_DEFAULT_STR1;	/* ID for this card */
-static int enable = SNDRV_DEFAULT_ENABLE1;	/* Enable this card */
-static int nopcm;	/* Disable PCM capability of the driver */
+static bool enable = SNDRV_DEFAULT_ENABLE1;	/* Enable this card */
+static bool nopcm;	/* Disable PCM capability of the driver */
 
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for pcsp soundcard.");
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c
--- a/sound/drivers/pcsp/pcsp_lib.c
+++ b/sound/drivers/pcsp/pcsp_lib.c
@@ -14,7 +14,7 @@
 #include <asm/io.h>
 #include "pcsp.h"
 
-static int nforce_wa;
+static bool nforce_wa;
 module_param(nforce_wa, bool, 0444);
 MODULE_PARM_DESC(nforce_wa, "Apply NForce chipset workaround "
 		"(expect bad sound)");
diff --git a/sound/drivers/portman2x4.c b/sound/drivers/portman2x4.c
--- a/sound/drivers/portman2x4.c
+++ b/sound/drivers/portman2x4.c
@@ -55,7 +55,7 @@
 
 static int index[SNDRV_CARDS]  = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS]   = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 static struct platform_device *platform_devices[SNDRV_CARDS]; 
 static int device_count;
diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -69,7 +69,7 @@ static char *adaptor_names[] = {
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE; /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE; /* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT; /* 0x3f8,0x2f8,0x3e8,0x2e8 */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ; 	/* 3,4,5,7,9,10,11,14,15 */
 static int speed[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 38400}; /* 9600,19200,38400,57600,115200 */
@@ -77,7 +77,7 @@ static int base[SNDRV_CARDS] = {[0 ... (
 static int outs[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};	 /* 1 to 16 */
 static int ins[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};	/* 1 to 16 */
 static int adaptor[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = SNDRV_SERIAL_SOUNDCANVAS};
-static int droponfull[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS -1)] = SNDRV_SERIAL_NORMALBUFF };
+static bool droponfull[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS -1)] = SNDRV_SERIAL_NORMALBUFF };
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Serial MIDI.");
diff --git a/sound/drivers/virmidi.c b/sound/drivers/virmidi.c
--- a/sound/drivers/virmidi.c
+++ b/sound/drivers/virmidi.c
@@ -63,7 +63,7 @@ MODULE_SUPPORTED_DEVICE("{{ALSA,Virtual 
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 0};
+static bool enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 0};
 static int midi_devs[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 4};
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/isa/ad1816a/ad1816a.c b/sound/isa/ad1816a/ad1816a.c
--- a/sound/isa/ad1816a/ad1816a.c
+++ b/sound/isa/ad1816a/ad1816a.c
@@ -44,7 +44,7 @@ MODULE_SUPPORTED_DEVICE("{{Highscreen,So
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 1-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP;	/* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static long mpu_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static long fm_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
diff --git a/sound/isa/ad1848/ad1848.c b/sound/isa/ad1848/ad1848.c
--- a/sound/isa/ad1848/ad1848.c
+++ b/sound/isa/ad1848/ad1848.c
@@ -43,11 +43,11 @@ MODULE_SUPPORTED_DEVICE("{{Analog Device
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* 5,7,9,11,12,15 */
 static int dma1[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;	/* 0,1,3,5,6,7 */
-static int thinkpad[SNDRV_CARDS];			/* Thinkpad special case */
+static bool thinkpad[SNDRV_CARDS];			/* Thinkpad special case */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for " CRD_NAME " soundcard.");
diff --git a/sound/isa/adlib.c b/sound/isa/adlib.c
--- a/sound/isa/adlib.c
+++ b/sound/isa/adlib.c
@@ -18,7 +18,7 @@ MODULE_LICENSE("GPL");
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/isa/als100.c b/sound/isa/als100.c
--- a/sound/isa/als100.c
+++ b/sound/isa/als100.c
@@ -54,7 +54,7 @@ MODULE_LICENSE("GPL");
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static long mpu_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static long fm_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
diff --git a/sound/isa/azt2320.c b/sound/isa/azt2320.c
--- a/sound/isa/azt2320.c
+++ b/sound/isa/azt2320.c
@@ -55,7 +55,7 @@ MODULE_SUPPORTED_DEVICE("{{Aztech System
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static long wss_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static long mpu_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -69,9 +69,9 @@ MODULE_SUPPORTED_DEVICE("{{C-Media,CMI83
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP;
 #ifdef CONFIG_PNP
-static int isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 #endif
 static long sbport[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;
 static int sbirq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;
diff --git a/sound/isa/cs423x/cs4231.c b/sound/isa/cs423x/cs4231.c
--- a/sound/isa/cs423x/cs4231.c
+++ b/sound/isa/cs423x/cs4231.c
@@ -41,7 +41,7 @@ MODULE_SUPPORTED_DEVICE("{{Crystal Semic
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static long mpu_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* 5,7,9,11,12,15 */
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -74,9 +74,9 @@ MODULE_ALIAS("snd_cs4232");
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
 #ifdef CONFIG_PNP
-static int isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 #endif
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static long cport[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
diff --git a/sound/isa/es1688/es1688.c b/sound/isa/es1688/es1688.c
--- a/sound/isa/es1688/es1688.c
+++ b/sound/isa/es1688/es1688.c
@@ -51,9 +51,9 @@ MODULE_ALIAS("snd_es968");
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 #ifdef CONFIG_PNP
-static int isapnp[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP;
+static bool isapnp[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP;
 #endif
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x220,0x240,0x260 */
 static long fm_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* Usually 0x388 */
 static long mpu_port[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = -1};
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1964,9 +1964,9 @@ MODULE_SUPPORTED_DEVICE("{{ESS,ES1868 Pn
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
 #ifdef CONFIG_PNP
-static int isapnp[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP;
+static bool isapnp[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP;
 #endif
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x220,0x240,0x260,0x280 */
 #ifndef CONFIG_PNP
diff --git a/sound/isa/galaxy/galaxy.c b/sound/isa/galaxy/galaxy.c
--- a/sound/isa/galaxy/galaxy.c
+++ b/sound/isa/galaxy/galaxy.c
@@ -35,7 +35,7 @@ MODULE_LICENSE("GPL");
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for " CRD_NAME " soundcard.");
diff --git a/sound/isa/gus/gusclassic.c b/sound/isa/gus/gusclassic.c
--- a/sound/isa/gus/gusclassic.c
+++ b/sound/isa/gus/gusclassic.c
@@ -42,7 +42,7 @@ MODULE_SUPPORTED_DEVICE("{{Gravis,UltraS
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x220,0x230,0x240,0x250,0x260 */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* 3,5,9,11,12,15 */
 static int dma1[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;	/* 1,3,5,6,7 */
diff --git a/sound/isa/gus/gusextreme.c b/sound/isa/gus/gusextreme.c
--- a/sound/isa/gus/gusextreme.c
+++ b/sound/isa/gus/gusextreme.c
@@ -46,7 +46,7 @@ MODULE_SUPPORTED_DEVICE("{{Gravis,UltraS
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x220,0x240,0x260 */
 static long gf1_port[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS) - 1] = -1}; /* 0x210,0x220,0x230,0x240,0x250,0x260,0x270 */
 static long mpu_port[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS) - 1] = -1}; /* 0x300,0x310,0x320 */
diff --git a/sound/isa/gus/gusmax.c b/sound/isa/gus/gusmax.c
--- a/sound/isa/gus/gusmax.c
+++ b/sound/isa/gus/gusmax.c
@@ -40,7 +40,7 @@ MODULE_SUPPORTED_DEVICE("{{Gravis,UltraS
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x220,0x230,0x240,0x250,0x260 */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* 2,3,5,9,11,12,15 */
 static int dma1[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;	/* 1,3,5,6,7 */
diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
--- a/sound/isa/gus/interwave.c
+++ b/sound/isa/gus/interwave.c
@@ -55,9 +55,9 @@ MODULE_SUPPORTED_DEVICE("{{AMD,InterWave
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
 #ifdef CONFIG_PNP
-static int isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 #endif
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x210,0x220,0x230,0x240,0x250,0x260 */
 #ifdef SNDRV_STB
diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -785,7 +785,7 @@ static int write_ndelay[SNDRV_CARDS] = {
 static int calibrate_signal;
 
 #ifdef CONFIG_PNP
-static int isapnp[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool isapnp[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 module_param_array(isapnp, bool, NULL, 0444);
 MODULE_PARM_DESC(isapnp, "ISA PnP detection for specified soundcard.");
 #define has_isapnp(x) isapnp[x]
diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -46,9 +46,9 @@ MODULE_SUPPORTED_DEVICE("{{Yamaha,YMF719
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
 #ifdef CONFIG_PNP
-static int isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 #endif
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0xf86,0x370,0x100 */
 static long sb_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x220,0x240,0x260 */
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -61,7 +61,7 @@ static int dma2 = SNDRV_DEFAULT_DMA1;		/
 static int wss;
 static int ide;
 #ifdef CONFIG_PNP
-static int isapnp = 1;				/* Enable ISA PnP detection */
+static bool isapnp = 1;				/* Enable ISA PnP detection */
 #endif
 
 module_param(index, int, 0444);
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -63,7 +63,7 @@ MODULE_SUPPORTED_DEVICE("{{OPTi,82C924 (
 
 static int index = SNDRV_DEFAULT_IDX1;	/* Index 0-MAX */
 static char *id = SNDRV_DEFAULT_STR1;		/* ID for this card */
-//static int enable = SNDRV_DEFAULT_ENABLE1;	/* Enable this card */
+//static bool enable = SNDRV_DEFAULT_ENABLE1;	/* Enable this card */
 #ifdef CONFIG_PNP
 static int isapnp = 1;			/* Enable ISA PnP detection */
 #endif
diff --git a/sound/isa/sb/jazz16.c b/sound/isa/sb/jazz16.c
--- a/sound/isa/sb/jazz16.c
+++ b/sound/isa/sb/jazz16.c
@@ -36,7 +36,7 @@ MODULE_LICENSE("GPL");
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 static unsigned long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;
 static unsigned long mpu_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;
diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c
--- a/sound/isa/sb/sb16.c
+++ b/sound/isa/sb/sb16.c
@@ -68,9 +68,9 @@ MODULE_SUPPORTED_DEVICE("{{Creative Labs
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
 #ifdef CONFIG_PNP
-static int isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 #endif
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x220,0x240,0x260,0x280 */
 static long mpu_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x330,0x300 */
diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -36,7 +36,7 @@ MODULE_SUPPORTED_DEVICE("{{Creative Labs
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x220,0x240,0x260 */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* 5,7,9,10 */
 static int dma8[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;	/* 1,3 */
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -48,7 +48,7 @@ MODULE_SUPPORTED_DEVICE("{{Gallant, SC-6
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x220, 0x240 */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* 5, 7, 9, 10, 11 */
 static long mss_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x530, 0xe80 */
diff --git a/sound/isa/wavefront/wavefront.c b/sound/isa/wavefront/wavefront.c
--- a/sound/isa/wavefront/wavefront.c
+++ b/sound/isa/wavefront/wavefront.c
@@ -38,9 +38,9 @@ MODULE_SUPPORTED_DEVICE("{{Turtle Beach,
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	    /* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	    /* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	    /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	    /* Enable this card */
 #ifdef CONFIG_PNP
-static int isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 #endif
 static long cs4232_pcm_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static int cs4232_pcm_irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ; /* 5,7,9,11,12,15 */
@@ -51,7 +51,7 @@ static int ics2115_irq[SNDRV_CARDS] = SN
 static long fm_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	    /* PnP setup */
 static int dma1[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;	    /* 0,1,3,5,6,7 */
 static int dma2[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;	    /* 0,1,3,5,6,7 */
-static int use_cs4232_midi[SNDRV_CARDS];
+static bool use_cs4232_midi[SNDRV_CARDS];
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for WaveFront soundcard.");
diff --git a/sound/oss/ad1848.c b/sound/oss/ad1848.c
--- a/sound/oss/ad1848.c
+++ b/sound/oss/ad1848.c
@@ -119,9 +119,9 @@ ad1848_port_info;
 static struct address_info cfg;
 static int nr_ad1848_devs;
 
-static int deskpro_xl;
-static int deskpro_m;
-static int soundpro;
+static bool deskpro_xl;
+static bool deskpro_m;
+static bool soundpro;
 
 static volatile signed char irq2dev[17] = {
 	-1, -1, -1, -1, -1, -1, -1, -1,
@@ -177,7 +177,7 @@ static struct {
 #ifdef CONFIG_PNP
 static int isapnp	= 1;
 static int isapnpjump;
-static int reverse;
+static bool reverse;
 
 static int audio_activated;
 #else
diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -1701,7 +1701,7 @@ static int joystick_io __initdata =	CONF
 #ifndef CONFIG_MSNDPIN_DIGITAL
 #  define CONFIG_MSNDPIN_DIGITAL	0
 #endif
-static int digital __initdata =		CONFIG_MSNDPIN_DIGITAL;
+static bool digital __initdata =	CONFIG_MSNDPIN_DIGITAL;
 
 #endif /* MSND_CLASSIC */
 
diff --git a/sound/oss/pas2_card.c b/sound/oss/pas2_card.c
--- a/sound/oss/pas2_card.c
+++ b/sound/oss/pas2_card.c
@@ -41,19 +41,19 @@ static int      pas_irq;
 static int      pas_sb_base;
 DEFINE_SPINLOCK(pas_lock);
 #ifndef CONFIG_PAS_JOYSTICK
-static int	joystick;
+static bool	joystick;
 #else
-static int 	joystick = 1;
+static bool 	joystick = 1;
 #endif
 #ifdef SYMPHONY_PAS
-static int 	symphony = 1;
+static bool 	symphony = 1;
 #else
-static int 	symphony;
+static bool 	symphony;
 #endif
 #ifdef BROKEN_BUS_CLOCK
-static int	broken_bus_clock = 1;
+static bool	broken_bus_clock = 1;
 #else
-static int	broken_bus_clock;
+static bool	broken_bus_clock;
 #endif
 
 static struct address_info cfg;
diff --git a/sound/oss/pss.c b/sound/oss/pss.c
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -117,9 +117,9 @@
 
 /* If compiled into kernel, it enable or disable pss mixer */
 #ifdef CONFIG_PSS_MIXER
-static int pss_mixer = 1;
+static bool pss_mixer = 1;
 #else
-static int pss_mixer;
+static bool pss_mixer;
 #endif
 
 
@@ -147,7 +147,7 @@ static DEFINE_SPINLOCK(lock);
 static int      pss_initialized;
 static int      nonstandard_microcode;
 static int	pss_cdrom_port = -1;	/* Parameter for the PSS cdrom port */
-static int	pss_enable_joystick;    /* Parameter for enabling the joystick */
+static bool	pss_enable_joystick;    /* Parameter for enabling the joystick */
 static coproc_operations pss_coproc_operations;
 
 static void pss_write(pss_confdata *devc, int data)
@@ -1133,8 +1133,8 @@ static int mss_irq __initdata	= -1;
 static int mss_dma __initdata	= -1;
 static int mpu_io __initdata	= -1;
 static int mpu_irq __initdata	= -1;
-static int pss_no_sound = 0;	/* Just configure non-sound components */
-static int pss_keep_settings  = 1;	/* Keep hardware settings at module exit */
+static bool pss_no_sound = 0;	/* Just configure non-sound components */
+static bool pss_keep_settings  = 1;	/* Keep hardware settings at module exit */
 static char *pss_firmware = "/etc/sound/pss_synth";
 
 module_param(pss_io, int, 0);
diff --git a/sound/oss/trix.c b/sound/oss/trix.c
--- a/sound/oss/trix.c
+++ b/sound/oss/trix.c
@@ -31,7 +31,7 @@
 
 static int mpu;
 
-static int joystick;
+static bool joystick;
 
 static unsigned char trix_read(int addr)
 {
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -42,7 +42,7 @@ MODULE_AUTHOR("Jaroslav Kysela <perex@pe
 MODULE_DESCRIPTION("Universal interface for Audio Codec '97");
 MODULE_LICENSE("GPL");
 
-static int enable_loopback;
+static bool enable_loopback;
 
 module_param(enable_loopback, bool, 0444);
 MODULE_PARM_DESC(enable_loopback, "Enable AC97 ADC/DAC Loopback Control");
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -66,7 +66,7 @@ static char *id[SNDRV_CARDS] = SNDRV_DEF
 module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for the AD1889 soundcard.");
 
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable AD1889 soundcard.");
 
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -48,7 +48,7 @@ MODULE_SUPPORTED_DEVICE("{{ALI,M5451,pci
 static int index = SNDRV_DEFAULT_IDX1;	/* Index */
 static char *id = SNDRV_DEFAULT_STR1;	/* ID for this card */
 static int pcm_channels = 32;
-static int spdif;
+static bool spdif;
 
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for ALI M5451 PCI Audio.");
@@ -60,7 +60,7 @@ module_param(spdif, bool, 0444);
 MODULE_PARM_DESC(spdif, "Support SPDIF I/O");
 
 /* just for backward compatibility */
-static int enable;
+static bool enable;
 module_param(enable, bool, 0444);
 
 
diff --git a/sound/pci/als4000.c b/sound/pci/als4000.c
--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -90,7 +90,7 @@ MODULE_SUPPORTED_DEVICE("{{Avance Logic,
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 #ifdef SUPPORT_JOYSTICK
 static int joystick_port[SNDRV_CARDS];
 #endif
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -63,8 +63,8 @@ MODULE_DESCRIPTION("AudioScience ALSA AS
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
-static int enable_hpi_hwdep = 1;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable_hpi_hwdep = 1;
 
 module_param_array(index, int, NULL, S_IRUGO);
 MODULE_PARM_DESC(index, "ALSA index value for AudioScience soundcard.");
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -43,7 +43,7 @@ static int index = SNDRV_DEFAULT_IDX1;	/
 static char *id = SNDRV_DEFAULT_STR1;	/* ID for this card */
 static int ac97_clock = 48000;
 static char *ac97_quirk;
-static int spdif_aclink = 1;
+static bool spdif_aclink = 1;
 static int ac97_codec = -1;
 
 module_param(index, int, 0444);
@@ -60,7 +60,7 @@ module_param(spdif_aclink, bool, 0444);
 MODULE_PARM_DESC(spdif_aclink, "S/PDIF over AC-link.");
 
 /* just for backward compatibility */
-static int enable;
+static bool enable;
 module_param(enable, bool, 0444);
 
 
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -51,7 +51,7 @@ module_param(ac97_clock, int, 0444);
 MODULE_PARM_DESC(ac97_clock, "AC'97 codec clock (default 48000Hz).");
 
 /* just for backward compatibility */
-static int enable;
+static bool enable;
 module_param(enable, bool, 0444);
 
 
diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -26,7 +26,7 @@
 // module parameters (see "Module Parameters")
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 static int pcifix[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 255 };
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/pci/aw2/aw2-alsa.c b/sound/pci/aw2/aw2-alsa.c
--- a/sound/pci/aw2/aw2-alsa.c
+++ b/sound/pci/aw2/aw2-alsa.c
@@ -153,7 +153,7 @@ static int snd_aw2_control_switch_captur
  ********************************/
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Audiowerk2 soundcard.");
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -301,7 +301,7 @@ static char *id[SNDRV_CARDS] = SNDRV_DEF
 module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for AZF3328 soundcard.");
 
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable AZF3328 soundcard.");
 
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -42,9 +42,9 @@ MODULE_SUPPORTED_DEVICE("{{Brooktree,Bt8
 
 static int index[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = -2}; /* Exclude the first card */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 static int digital_rate[SNDRV_CARDS];	/* digital input rate */
-static int load_all;	/* allow to load the non-whitelisted cards */
+static bool load_all;	/* allow to load the non-whitelisted cards */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Bt87x soundcard");
diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -156,7 +156,7 @@ MODULE_SUPPORTED_DEVICE("{{Creative,SB C
 // module parameters (see "Module Parameters")
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 static uint subsystem[SNDRV_CARDS]; /* Force card subsystem model */
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -54,10 +54,10 @@ MODULE_SUPPORTED_DEVICE("{{C-Media,CMI87
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
 static long mpu_port[SNDRV_CARDS];
 static long fm_port[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)]=1};
-static int soft_ac3[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)]=1};
+static bool soft_ac3[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)]=1};
 #ifdef SUPPORT_JOYSTICK
 static int joystick_port[SNDRV_CARDS];
 #endif
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -44,8 +44,8 @@ MODULE_SUPPORTED_DEVICE("{{Cirrus Logic,
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
-static int dual_codec[SNDRV_CARDS];	/* dual codec */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
+static bool dual_codec[SNDRV_CARDS];	/* dual codec */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for CS4281 soundcard.");
diff --git a/sound/pci/cs46xx/cs46xx.c b/sound/pci/cs46xx/cs46xx.c
--- a/sound/pci/cs46xx/cs46xx.c
+++ b/sound/pci/cs46xx/cs46xx.c
@@ -46,10 +46,10 @@ MODULE_SUPPORTED_DEVICE("{{Cirrus Logic,
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
-static int external_amp[SNDRV_CARDS];
-static int thinkpad[SNDRV_CARDS];
-static int mmap_valid[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool external_amp[SNDRV_CARDS];
+static bool thinkpad[SNDRV_CARDS];
+static bool mmap_valid[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for the CS46xx soundcard.");
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -57,7 +57,7 @@ static struct ac97_quirk ac97_quirks[] _
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for " DRIVER_NAME);
diff --git a/sound/pci/ctxfi/cttimer.c b/sound/pci/ctxfi/cttimer.c
--- a/sound/pci/ctxfi/cttimer.c
+++ b/sound/pci/ctxfi/cttimer.c
@@ -15,8 +15,8 @@
 #include "cthardware.h"
 #include "cttimer.h"
 
-static int use_system_timer;
-MODULE_PARM_DESC(use_system_timer, "Foce to use system-timer");
+static bool use_system_timer;
+MODULE_PARM_DESC(use_system_timer, "Force to use system-timer");
 module_param(use_system_timer, bool, S_IRUGO);
 
 struct ct_timer_ops {
diff --git a/sound/pci/ctxfi/xfi.c b/sound/pci/ctxfi/xfi.c
--- a/sound/pci/ctxfi/xfi.c
+++ b/sound/pci/ctxfi/xfi.c
@@ -32,7 +32,7 @@ module_param(multiple, uint, S_IRUGO);
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 static unsigned int subsystem[SNDRV_CARDS];
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -26,7 +26,7 @@ MODULE_DEVICE_TABLE(pci, snd_echo_ids);
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for " ECHOCARD_NAME " soundcard.");
diff --git a/sound/pci/emu10k1/emu10k1.c b/sound/pci/emu10k1/emu10k1.c
--- a/sound/pci/emu10k1/emu10k1.c
+++ b/sound/pci/emu10k1/emu10k1.c
@@ -44,13 +44,13 @@ MODULE_SUPPORTED_DEVICE("{{Creative Labs
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 static int extin[SNDRV_CARDS];
 static int extout[SNDRV_CARDS];
 static int seq_ports[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 4};
 static int max_synth_voices[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 64};
 static int max_buffer_size[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 128};
-static int enable_ir[SNDRV_CARDS];
+static bool enable_ir[SNDRV_CARDS];
 static uint subsystem[SNDRV_CARDS]; /* Force card subsystem model */
 static uint delay_pcm_irq[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 2};
 
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -50,7 +50,7 @@ MODULE_SUPPORTED_DEVICE("{{Dell Creative
 // module parameters (see "Module Parameters")
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for the EMU10K1X soundcard.");
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -83,12 +83,12 @@ MODULE_SUPPORTED_DEVICE("{{Ensoniq,Audio
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
 #ifdef SUPPORT_JOYSTICK
 #ifdef CHIP1371
 static int joystick_port[SNDRV_CARDS];
 #else
-static int joystick[SNDRV_CARDS];
+static bool joystick[SNDRV_CARDS];
 #endif
 #endif
 #ifdef CHIP1371
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -79,7 +79,7 @@ MODULE_SUPPORTED_DEVICE("{{ESS,ES1938},"
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for ESS Solo-1 soundcard.");
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -132,7 +132,7 @@ MODULE_SUPPORTED_DEVICE("{{ESS,Maestro 2
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 1-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 static int total_bufsize[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1024 };
 static int pcm_substreams_p[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 4 };
 static int pcm_substreams_c[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1 };
@@ -140,7 +140,7 @@ static int clock[SNDRV_CARDS];
 static int use_pm[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 2};
 static int enable_mpu[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 2};
 #ifdef SUPPORT_JOYSTICK
-static int joystick[SNDRV_CARDS];
+static bool joystick[SNDRV_CARDS];
 #endif
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -48,7 +48,7 @@ MODULE_SUPPORTED_DEVICE("{{ForteMedia,FM
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 /*
  *  Enable TEA575x tuner
  *    1 = MediaForte 256-PCS
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -58,13 +58,13 @@
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 static char *model[SNDRV_CARDS];
 static int position_fix[SNDRV_CARDS];
 static int bdl_pos_adj[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)] = -1};
 static int probe_mask[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)] = -1};
 static int probe_only[SNDRV_CARDS];
-static int single_cmd;
+static bool single_cmd;
 static int enable_msi = -1;
 #ifdef CONFIG_SND_HDA_PATCH_LOADER
 static char *patch[SNDRV_CARDS];
@@ -116,12 +116,12 @@ MODULE_PARM_DESC(power_save, "Automatic 
  * this may give more power-saving, but will take longer time to
  * wake up.
  */
-static int power_save_controller = 1;
+static bool power_save_controller = 1;
 module_param(power_save_controller, bool, 0644);
 MODULE_PARM_DESC(power_save_controller, "Reset controller in power save mode.");
 #endif
 
-static int align_buffer_size = 1;
+static bool align_buffer_size = 1;
 module_param(align_buffer_size, bool, 0644);
 MODULE_PARM_DESC(align_buffer_size,
 		"Force buffer and period sizes to be multiple of 128 bytes.");
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -84,9 +84,9 @@ MODULE_SUPPORTED_DEVICE("{"
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;/* Enable this card */
 static char *model[SNDRV_CARDS];
-static int omni[SNDRV_CARDS];				/* Delta44 & 66 Omni I/O support */
+static bool omni[SNDRV_CARDS];				/* Delta44 & 66 Omni I/O support */
 static int cs8427_timeout[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)] = 500}; /* CS8427 S/PDIF transceiver reset timeout value in msec */
 static int dxr_enable[SNDRV_CARDS];			/* DXR enable for DMX6FIRE */
 
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -80,7 +80,7 @@ MODULE_SUPPORTED_DEVICE("{"
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;		/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;		/* Enable this card */
 static char *model[SNDRV_CARDS];
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -79,9 +79,9 @@ static int index = SNDRV_DEFAULT_IDX1;	/
 static char *id = SNDRV_DEFAULT_STR1;	/* ID for this card */
 static int ac97_clock;
 static char *ac97_quirk;
-static int buggy_semaphore;
+static bool buggy_semaphore;
 static int buggy_irq = -1; /* auto-check */
-static int xbox;
+static bool xbox;
 static int spdif_aclink = -1;
 static int inside_vm = -1;
 
@@ -105,7 +105,7 @@ module_param(inside_vm, bint, 0444);
 MODULE_PARM_DESC(inside_vm, "KVM/Parallels optimization.");
 
 /* just for backward compatibility */
-static int enable;
+static bool enable;
 module_param(enable, bool, 0444);
 static int joystick;
 module_param(joystick, int, 0444);
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -68,7 +68,7 @@ module_param(ac97_clock, int, 0444);
 MODULE_PARM_DESC(ac97_clock, "AC'97 codec clock (0 = auto-detect).");
 
 /* just for backward compatibility */
-static int enable;
+static bool enable;
 module_param(enable, bool, 0444);
 
 /*
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -408,7 +408,7 @@ MODULE_FIRMWARE("korg/k1212.dsp");
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;     /* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	   /* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE; /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE; /* Enable this card */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Korg 1212 soundcard.");
diff --git a/sound/pci/lola/lola.c b/sound/pci/lola/lola.c
--- a/sound/pci/lola/lola.c
+++ b/sound/pci/lola/lola.c
@@ -35,7 +35,7 @@
 /* Standard options */
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Digigram Lola driver.");
diff --git a/sound/pci/lx6464es/lx6464es.c b/sound/pci/lx6464es/lx6464es.c
--- a/sound/pci/lx6464es/lx6464es.c
+++ b/sound/pci/lx6464es/lx6464es.c
@@ -42,7 +42,7 @@ MODULE_SUPPORTED_DEVICE("{digigram lx646
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Digigram LX6464ES interface.");
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -64,8 +64,8 @@ MODULE_FIRMWARE("ess/maestro3_assp_minis
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP; /* all enabled */
-static int external_amp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP; /* all enabled */
+static bool external_amp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 static int amp_gpio[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = -1};
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -49,7 +49,7 @@ MODULE_SUPPORTED_DEVICE("{{Digigram," CA
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;             /* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;              /* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;     /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;     /* Enable this card */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Digigram " CARD_NAME " soundcard.");
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -57,12 +57,12 @@ static int index = SNDRV_DEFAULT_IDX1;	/
 static char *id = SNDRV_DEFAULT_STR1;	/* ID for this card */
 static int playback_bufsize = 16;
 static int capture_bufsize = 16;
-static int force_ac97;			/* disabled as default */
+static bool force_ac97;			/* disabled as default */
 static int buffer_top;			/* not specified */
-static int use_cache;			/* disabled */
-static int vaio_hack;			/* disabled */
-static int reset_workaround;
-static int reset_workaround_2;
+static bool use_cache;			/* disabled */
+static bool vaio_hack;			/* disabled */
+static bool reset_workaround;
+static bool reset_workaround_2;
 
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for " CARD_NAME " soundcard.");
@@ -86,7 +86,7 @@ module_param(reset_workaround_2, bool, 0
 MODULE_PARM_DESC(reset_workaround_2, "Enable extended AC97 RESET workaround for some other laptops.");
 
 /* just for backward compatibility */
-static int enable;
+static bool enable;
 module_param(enable, bool, 0444);
 
 
diff --git a/sound/pci/oxygen/oxygen.c b/sound/pci/oxygen/oxygen.c
--- a/sound/pci/oxygen/oxygen.c
+++ b/sound/pci/oxygen/oxygen.c
@@ -74,7 +74,7 @@ MODULE_SUPPORTED_DEVICE("{{C-Media,CMI87
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "card index");
diff --git a/sound/pci/oxygen/virtuoso.c b/sound/pci/oxygen/virtuoso.c
--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -32,7 +32,7 @@ MODULE_SUPPORTED_DEVICE("{{Asus,AV66},{A
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "card index");
diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -52,8 +52,8 @@ MODULE_SUPPORTED_DEVICE("{{Digigram," DR
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;/* Enable this card */
-static int mono[SNDRV_CARDS];				/* capture  mono only */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;/* Enable this card */
+static bool mono[SNDRV_CARDS];				/* capture  mono only */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Digigram " DRIVER_NAME " soundcard");
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -122,7 +122,7 @@ MODULE_FIRMWARE("riptide.hex");
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;
 
 #ifdef SUPPORT_JOYSTICK
 static int joystick_port[SNDRV_CARDS] = { [0 ... (SNDRV_CARDS - 1)] = 0x200 };
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -89,8 +89,8 @@
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
-static int fullduplex[SNDRV_CARDS]; // = {[0 ... (SNDRV_CARDS - 1)] = 1};
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool fullduplex[SNDRV_CARDS]; // = {[0 ... (SNDRV_CARDS - 1)] = 1};
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for RME Digi32 soundcard.");
diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -53,7 +53,7 @@ MODULE_SUPPORTED_DEVICE("{{RME,Digi96},"
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for RME Digi96 soundcard.");
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -45,7 +45,7 @@
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for RME Hammerfall DSP interface.");
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -61,7 +61,7 @@
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	  /* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	  /* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;/* Enable this card */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for RME HDSPM interface.");
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -38,8 +38,8 @@
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
-static int precise_ptr[SNDRV_CARDS];			/* Enable precise pointer */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool precise_ptr[SNDRV_CARDS];			/* Enable precise pointer */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for RME Digi9652 (Hammerfall) soundcard.");
diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -40,7 +40,7 @@ MODULE_SUPPORTED_DEVICE("{{SiS,SiS7019 A
 
 static int index = SNDRV_DEFAULT_IDX1;	/* Index 0-MAX */
 static char *id = SNDRV_DEFAULT_STR1;	/* ID for this card */
-static int enable = 1;
+static bool enable = 1;
 
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for SiS7019 Audio Accelerator.");
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -52,9 +52,9 @@ MODULE_SUPPORTED_DEVICE("{{S3,SonicVibes
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
-static int reverb[SNDRV_CARDS];
-static int mge[SNDRV_CARDS];
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool reverb[SNDRV_CARDS];
+static bool mge[SNDRV_CARDS];
 static unsigned int dmaio = 0x7a00;	/* DDMA i/o address */
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/pci/trident/trident.c b/sound/pci/trident/trident.c
--- a/sound/pci/trident/trident.c
+++ b/sound/pci/trident/trident.c
@@ -47,7 +47,7 @@ MODULE_SUPPORTED_DEVICE("{{Trident,4DWav
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 static int pcm_channels[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 32};
 static int wavetable_size[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 8192};
 
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -80,7 +80,7 @@ static int index = SNDRV_DEFAULT_IDX1;	/
 static char *id = SNDRV_DEFAULT_STR1;	/* ID for this card */
 static long mpu_port;
 #ifdef SUPPORT_JOYSTICK
-static int joystick;
+static bool joystick;
 #endif
 static int ac97_clock = 48000;
 static char *ac97_quirk;
@@ -110,7 +110,7 @@ module_param(nodelay, int, 0444);
 MODULE_PARM_DESC(nodelay, "Disable 500ms init delay");
 
 /* just for backward compatibility */
-static int enable;
+static bool enable;
 module_param(enable, bool, 0444);
 
 
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -66,7 +66,7 @@ module_param(ac97_clock, int, 0444);
 MODULE_PARM_DESC(ac97_clock, "AC'97 codec clock (default 48000Hz).");
 
 /* just for backward compatibility */
-static int enable;
+static bool enable;
 module_param(enable, bool, 0444);
 
 
diff --git a/sound/pci/vx222/vx222.c b/sound/pci/vx222/vx222.c
--- a/sound/pci/vx222/vx222.c
+++ b/sound/pci/vx222/vx222.c
@@ -37,8 +37,8 @@ MODULE_SUPPORTED_DEVICE("{{Digigram," CA
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
-static int mic[SNDRV_CARDS]; /* microphone */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool mic[SNDRV_CARDS]; /* microphone */
 static int ibl[SNDRV_CARDS]; /* microphone */
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -41,13 +41,13 @@ MODULE_SUPPORTED_DEVICE("{{Yamaha,YMF724
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 static long fm_port[SNDRV_CARDS];
 static long mpu_port[SNDRV_CARDS];
 #ifdef SUPPORT_JOYSTICK
 static long joystick_port[SNDRV_CARDS];
 #endif
-static int rear_switch[SNDRV_CARDS];
+static bool rear_switch[SNDRV_CARDS];
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for the Yamaha DS-1 PCI soundcard.");
diff --git a/sound/pcmcia/pdaudiocf/pdaudiocf.c b/sound/pcmcia/pdaudiocf/pdaudiocf.c
--- a/sound/pcmcia/pdaudiocf/pdaudiocf.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf.c
@@ -39,7 +39,7 @@ MODULE_SUPPORTED_DEVICE("{{Sound Core," 
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for " CARD_NAME " soundcard.");
diff --git a/sound/pcmcia/vx/vxpocket.c b/sound/pcmcia/vx/vxpocket.c
--- a/sound/pcmcia/vx/vxpocket.c
+++ b/sound/pcmcia/vx/vxpocket.c
@@ -39,7 +39,7 @@ MODULE_SUPPORTED_DEVICE("{{Digigram,VXPo
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
 static int ibl[SNDRV_CARDS];
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/ppc/powermac.c b/sound/ppc/powermac.c
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -36,7 +36,7 @@ MODULE_LICENSE("GPL");
 
 static int index = SNDRV_DEFAULT_IDX1;		/* Index 0-MAX */
 static char *id = SNDRV_DEFAULT_STR1;		/* ID for this card */
-static int enable_beep = 1;
+static bool enable_beep = 1;
 
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for " CHIP_NAME " soundchip.");
diff --git a/sound/sh/aica.c b/sound/sh/aica.c
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -55,7 +55,7 @@ MODULE_FIRMWARE("aica_firmware.bin");
 #define CARD_NAME "AICA"
 static int index = -1;
 static char *id;
-static int enable = 1;
+static bool enable = 1;
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for " CARD_NAME " soundcard.");
 module_param(id, charp, 0444);
diff --git a/sound/sparc/amd7930.c b/sound/sparc/amd7930.c
--- a/sound/sparc/amd7930.c
+++ b/sound/sparc/amd7930.c
@@ -50,7 +50,7 @@
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Sun AMD7930 soundcard.");
diff --git a/sound/sparc/cs4231.c b/sound/sparc/cs4231.c
--- a/sound/sparc/cs4231.c
+++ b/sound/sparc/cs4231.c
@@ -40,7 +40,7 @@
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 /* Enable this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Sun CS4231 soundcard.");
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -80,7 +80,7 @@ MODULE_SUPPORTED_DEVICE("{{Sun,DBRI}}");
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 /* Enable this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Sun DBRI soundcard.");
diff --git a/sound/usb/6fire/chip.c b/sound/usb/6fire/chip.c
--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -35,7 +35,7 @@ MODULE_SUPPORTED_DEVICE("{{TerraTec, DMX
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX; /* Index 0-max */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR; /* Id for card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP; /* Enable card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP; /* Enable card */
 static struct sfire_chip *chips[SNDRV_CARDS] = SNDRV_DEFAULT_PTR;
 static struct usb_device *devices[SNDRV_CARDS] = SNDRV_DEFAULT_PTR;
 
diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -55,7 +55,7 @@ MODULE_SUPPORTED_DEVICE("{{Native Instru
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX; /* Index 0-max */
 static char* id[SNDRV_CARDS] = SNDRV_DEFAULT_STR; /* Id for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP; /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP; /* Enable this card */
 static int snd_card_used[SNDRV_CARDS];
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/usb/card.c b/sound/usb/card.c
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -78,14 +78,14 @@ MODULE_SUPPORTED_DEVICE("{{Generic,USB A
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;/* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;/* Enable this card */
 /* Vendor/product IDs for this card */
 static int vid[SNDRV_CARDS] = { [0 ... (SNDRV_CARDS-1)] = -1 };
 static int pid[SNDRV_CARDS] = { [0 ... (SNDRV_CARDS-1)] = -1 };
 static int nrpacks = 8;		/* max. number of packets per urb */
-static int async_unlink = 1;
+static bool async_unlink = 1;
 static int device_setup[SNDRV_CARDS]; /* device parameter for this card */
-static int ignore_ctl_error;
+static bool ignore_ctl_error;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for the USB audio adapter.");
diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -52,7 +52,7 @@ MODULE_SUPPORTED_DEVICE("{{Edirol,UA-101
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 static unsigned int queue_length = 21;
 
 module_param_array(index, int, NULL, 0444);
diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -37,7 +37,7 @@ MODULE_LICENSE("GPL");
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-max */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* Id for this card */
 							/* Enable this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for "NAME_ALLCAPS".");
diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -154,7 +154,7 @@ MODULE_SUPPORTED_DEVICE("{{TASCAM(0x1604
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX; /* Index 0-max */
 static char* id[SNDRV_CARDS] = SNDRV_DEFAULT_STR; /* Id for this card */
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP; /* Enable this card */
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP; /* Enable this card */
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for "NAME_ALLCAPS".");
