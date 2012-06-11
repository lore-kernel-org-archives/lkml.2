Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2FKUAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:00:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40828 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2FKUAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:00:16 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 2/3] swarm_cs4297: Rename AC97 registers to use sound/ac97_codec.h definitions
Date: Mon, 11 Jun 2012 16:58:50 -0300
Message-Id: <1339444731-15678-2-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1339444731-15678-1-git-send-email-elezegarcia@gmail.com>
References: <1339444731-15678-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the last usage of linux/ac97_codec.h
by renaming ac97 registers to use sound/ac97_codec.h definitions.
This will enable us to remove linux/ac97_codec.h.

Not even compilation tested.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Hi all,

This patch is important so we can remove linux/ac97_codec.h usage.
Since this driver is mips related, I can't test it until I install
a mips toolchain.
If someone can compile this for me, or even test it with real
hardware I think it would be better.
If not then I can install a mips toolchain and compile it myself,
but I won't be able to test it on real hardware.

This patch should be treated with carefully and be applied only
if someone manages to test it.

Regards,
Ezequiel.
---
 sound/oss/swarm_cs4297a.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 09d4648..d0a1000 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -69,7 +69,6 @@
 #include <linux/sound.h>
 #include <linux/slab.h>
 #include <linux/soundcard.h>
-#include <linux/ac97_codec.h>
 #include <linux/pci.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
@@ -77,6 +76,7 @@
 #include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/kernel.h>
+#include <sound/ac97_codec.h>
 
 #include <asm/byteorder.h>
 #include <asm/dma.h>
@@ -1162,10 +1162,10 @@ static int mixer_ioctl(struct cs4297a_state *s, unsigned int cmd,
 	};
 
 	static const unsigned mixreg[] = {
-		AC97_PCMOUT_VOL,
-		AC97_AUX_VOL,
-		AC97_CD_VOL,
-		AC97_LINEIN_VOL
+		AC97_PCM,
+		AC97_AUX,
+		AC97_CD,
+		AC97_LINE
 	};
 	unsigned char l, r, rl, rr, vidx;
 	unsigned char attentbl[11] =
@@ -1264,7 +1264,7 @@ static int mixer_ioctl(struct cs4297a_state *s, unsigned int cmd,
 	if (_SIOC_DIR(cmd) == _SIOC_READ) {
 		switch (_IOC_NR(cmd)) {
 		case SOUND_MIXER_RECSRC:	// Arg contains a bit for each recording source 
-			cs4297a_read_ac97(s, AC97_RECORD_SELECT,
+			cs4297a_read_ac97(s, AC97_REC_SEL,
 					 &temp1);
 			return put_user(mixer_src[temp1 & 7], (int *) arg);
 
@@ -1314,7 +1314,7 @@ static int mixer_ioctl(struct cs4297a_state *s, unsigned int cmd,
 			if (val == mixer_src[i]) {
 				temp1 = (i << 8) | i;
 				cs4297a_write_ac97(s,
-						  AC97_RECORD_SELECT,
+						  AC97_REC_SEL,
 						  temp1);
 				return 0;
 			}
@@ -1349,8 +1349,8 @@ static int mixer_ioctl(struct cs4297a_state *s, unsigned int cmd,
 
 		temp1 |= (rl << 8) | rr;
 
-		cs4297a_write_ac97(s, AC97_MASTER_VOL_STEREO, temp1);
-		cs4297a_write_ac97(s, AC97_PHONE_VOL, temp1);
+		cs4297a_write_ac97(s, AC97_MASTER, temp1);
+		cs4297a_write_ac97(s, AC97_PHONE, temp1);
 
 #ifdef OSS_DOCUMENTED_MIXER_SEMANTICS
 		s->mix.vol[8] = ((unsigned int) r << 8) | l;
@@ -1380,7 +1380,7 @@ static int mixer_ioctl(struct cs4297a_state *s, unsigned int cmd,
 			temp1 = 0;
 		rl = 15 - rl;	// Convert volume to attenuation.
 		temp1 |= rl << 1;
-		cs4297a_write_ac97(s, AC97_PCBEEP_VOL, temp1);
+		cs4297a_write_ac97(s, AC97_PC_BEEP, temp1);
 
 #ifdef OSS_DOCUMENTED_MIXER_SEMANTICS
 		s->mix.vol[6] = l << 8;
@@ -1406,7 +1406,7 @@ static int mixer_ioctl(struct cs4297a_state *s, unsigned int cmd,
 			temp1 = 0;
 
 		temp1 = temp1 | (rl << 8) | rr;
-		cs4297a_write_ac97(s, AC97_RECORD_GAIN, temp1);
+		cs4297a_write_ac97(s, AC97_REC_GAIN, temp1);
 
 #ifdef OSS_DOCUMENTED_MIXER_SEMANTICS
 		s->mix.vol[7] = ((unsigned int) r << 8) | l;
@@ -1428,7 +1428,7 @@ static int mixer_ioctl(struct cs4297a_state *s, unsigned int cmd,
 			rl = ((unsigned) l * 5 - 4) / 16;	// Convert 0-100 range to 0-31.
 			l = (rl * 16 + 4) / 5;
 		}
-		cs4297a_read_ac97(s, AC97_MIC_VOL, &temp1);
+		cs4297a_read_ac97(s, AC97_MIC, &temp1);
 		temp1 &= 0x40;	// Isolate 20db gain bit.
 		if (rl < 3) {
 			temp1 |= 0x8000;
@@ -1436,7 +1436,7 @@ static int mixer_ioctl(struct cs4297a_state *s, unsigned int cmd,
 		}
 		rl = 31 - rl;	// Convert volume to attenuation.
 		temp1 |= rl;
-		cs4297a_write_ac97(s, AC97_MIC_VOL, temp1);
+		cs4297a_write_ac97(s, AC97_MIC, temp1);
 
 #ifdef OSS_DOCUMENTED_MIXER_SEMANTICS
 		s->mix.vol[5] = val << 8;
@@ -2690,7 +2690,7 @@ static int __init cs4297a_init(void)
 
         do {
                 udelay(4000);
-                rval = cs4297a_read_ac97(s, AC97_POWER_CONTROL, &pwr);
+		 rval = cs4297a_read_ac97(s, AC97_POWERDOWN, &pwr);
         } while (!rval && (pwr != 0xf));
 
         if (!rval) {
-- 
1.7.4.4

