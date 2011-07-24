Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1GXJkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 05:40:42 -0400
Received: from nm16-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.254]:46182
	"HELO nm16-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752291Ab1GXJkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 05:40:32 -0400
X-Yahoo-Newman-Id: 208430.5747.bm@smtp121.mail.ukl.yahoo.com
Message-ID: <208430.5747.bm@smtp121.mail.ukl.yahoo.com>
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: S_yq470VM1lNP760xP2QGqFu8dQ8DC3L1tDGAvkfMGKfiBH
 AIN030OdLyKIFpy.JUJ76HHLhzYaogIH9kqXP6Ymf7.MF6.KaEWtbF6lQcLv
 gdJZ.ujQKpBzjZ0DL0.78EkO93DHfrdsVAAoag6xx9.4rBSZRYb2P9fj1hx.
 D6ntOJIgnewyvdalKBZb.mtL0cF7KNTs.6p8pdIlbpE_25LS3Jq3PksExkrY
 9B8doItmRzmOPsiQ2FiyAhwjNtMEA6Mz82_WYVVaCmV2aFxEw4s8YGo0jMWl
 4qUJrgR0Hta115pcVF_taciQJ1jvtnvbnfCLpHb_FlZoMxcI5qjkz7c44L7a
 6BGyWh6U599g5jbDyt33Q1PtbJT7kFDmjUmyw.k2Li8Y2.3iHbvcUlZbu1XJ
 VysGawdxh5mSfC5kj3cUDxBJzmvCF
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
Date: Sun, 24 Jul 2011 11:40:48 +0200
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Kees Cook <kees.cook@canonical.com>, Emese Revfy <re.emese@gmail.com>,
        kernel-janitors@vger.kernel.org
Subject: sound: constify snd_ac97_bus_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fields of this struct type don't seem to be used as rvalues, besides
the initialization of struct instances. Let's make const the struct
instances.

Maybe the Documentation/DocBook/writing-an-alsa-driver.tmpl, and
checkpatch.pl should be updated to reflect this change ?

Patch against current Linus tree.

---

>From 742dd9a07b644838f5505b98c8ceb90bfeeae8e4 Mon Sep 17 00:00:00 2001
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Date: Sun, 24 Jul 2011 10:26:15 +0200
Subject: sound: constify snd_ac97_bus_ops

Inspired by hunks of the PaX/grsecurity patch.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 include/sound/ac97_codec.h          |    4 ++--
 include/sound/soc.h                 |    4 ++--
 sound/arm/aaci.c                    |    2 +-
 sound/arm/pxa2xx-ac97.c             |    2 +-
 sound/atmel/ac97c.c                 |    2 +-
 sound/drivers/ml403-ac97cr.c        |    2 +-
 sound/mips/au1x00.c                 |    2 +-
 sound/pci/ac97/ac97_codec.c         |    2 +-
 sound/pci/ad1889.c                  |    2 +-
 sound/pci/ali5451/ali5451.c         |    2 +-
 sound/pci/als300.c                  |    2 +-
 sound/pci/atiixp.c                  |    2 +-
 sound/pci/atiixp_modem.c            |    2 +-
 sound/pci/au88x0/au88x0_mixer.c     |    2 +-
 sound/pci/azt3328.c                 |    2 +-
 sound/pci/ca0106/ca0106_main.c      |    2 +-
 sound/pci/cs4281.c                  |    2 +-
 sound/pci/cs46xx/cs46xx_lib.c       |    2 +-
 sound/pci/cs5535audio/cs5535audio.c |    2 +-
 sound/pci/emu10k1/emu10k1x.c        |    2 +-
 sound/pci/emu10k1/emumixer.c        |    2 +-
 sound/pci/ens1370.c                 |    2 +-
 sound/pci/es1968.c                  |    2 +-
 sound/pci/fm801.c                   |    2 +-
 sound/pci/ice1712/ice1712.c         |    4 ++--
 sound/pci/ice1712/ice1724.c         |    2 +-
 sound/pci/intel8x0.c                |    6 +++---
 sound/pci/intel8x0m.c               |    2 +-
 sound/pci/maestro3.c                |    2 +-
 sound/pci/nm256/nm256.c             |    2 +-
 sound/pci/riptide/riptide.c         |    2 +-
 sound/pci/sis7019.c                 |    2 +-
 sound/pci/trident/trident_main.c    |    2 +-
 sound/pci/via82xx.c                 |    2 +-
 sound/pci/via82xx_modem.c           |    2 +-
 sound/pci/ymfpci/ymfpci_main.c      |    2 +-
 sound/soc/au1x/psc-ac97.c           |    2 +-
 sound/soc/blackfin/bf5xx-ac97.c     |    2 +-
 sound/soc/blackfin/bf5xx-ac97.h     |    2 +-
 sound/soc/ep93xx/ep93xx-ac97.c      |    2 +-
 sound/soc/fsl/mpc5200_psc_ac97.c    |    2 +-
 sound/soc/imx/imx-ssi.c             |    2 +-
 sound/soc/nuc900/nuc900-ac97.c      |    2 +-
 sound/soc/pxa/pxa2xx-ac97.c         |    2 +-
 sound/soc/pxa/pxa2xx-ac97.h         |    2 +-
 sound/soc/samsung/ac97.c            |    2 +-
 sound/soc/sh/hac.c                  |    2 +-
 sound/soc/soc-core.c                |    2 +-
 sound/soc/txx9/txx9aclc-ac97.c      |    2 +-
 49 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/include/sound/ac97_codec.h b/include/sound/ac97_codec.h
index 02cbb50..e33a864 100644
--- a/include/sound/ac97_codec.h
+++ b/include/sound/ac97_codec.h
@@ -446,7 +446,7 @@ struct snd_ac97_bus_ops {
 
 struct snd_ac97_bus {
 	/* -- lowlevel (hardware) driver specific -- */
-	struct snd_ac97_bus_ops *ops;
+	const struct snd_ac97_bus_ops *ops;
 	void *private_data;
 	void (*private_free) (struct snd_ac97_bus *bus);
 	/* --- */
@@ -556,7 +556,7 @@ static inline int ac97_can_spdif(struct snd_ac97 * ac97)
 
 /* functions */
 /* create new AC97 bus */
-int snd_ac97_bus(struct snd_card *card, int num, struct snd_ac97_bus_ops *ops,
+int snd_ac97_bus(struct snd_card *card, int num, const struct snd_ac97_bus_ops *ops,
 		 void *private_data, struct snd_ac97_bus **rbus);
 /* create mixer controls */
 int snd_ac97_mixer(struct snd_ac97_bus *bus, struct snd_ac97_template *template,
diff --git a/include/sound/soc.h b/include/sound/soc.h
index aa19f5a..aa6bddc 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -255,7 +255,7 @@ struct snd_soc_jack_gpio;
 
 typedef int (*hw_write_t)(void *,const char* ,int);
 
-extern struct snd_ac97_bus_ops soc_ac97_ops;
+extern const struct snd_ac97_bus_ops soc_ac97_ops;
 
 enum snd_soc_control_type {
 	SND_SOC_I2C = 1,
@@ -357,7 +357,7 @@ int snd_soc_test_bits(struct snd_soc_codec *codec, unsigned short reg,
 				unsigned int mask, unsigned int value);
 
 int snd_soc_new_ac97_codec(struct snd_soc_codec *codec,
-	struct snd_ac97_bus_ops *ops, int num);
+	const struct snd_ac97_bus_ops *ops, int num);
 void snd_soc_free_ac97_codec(struct snd_soc_codec *codec);
 
 /*
diff --git a/sound/arm/aaci.c b/sound/arm/aaci.c
index d0cead3..20b6713 100644
--- a/sound/arm/aaci.c
+++ b/sound/arm/aaci.c
@@ -827,7 +827,7 @@ static struct ac97_pcm ac97_defs[] __devinitdata = {
 	}
 };
 
-static struct snd_ac97_bus_ops aaci_bus_ops = {
+static const struct snd_ac97_bus_ops aaci_bus_ops = {
 	.write	= aaci_ac97_write,
 	.read	= aaci_ac97_read,
 };
diff --git a/sound/arm/pxa2xx-ac97.c b/sound/arm/pxa2xx-ac97.c
index 5d94118..506b38c 100644
--- a/sound/arm/pxa2xx-ac97.c
+++ b/sound/arm/pxa2xx-ac97.c
@@ -34,7 +34,7 @@ static void pxa2xx_ac97_reset(struct snd_ac97 *ac97)
 	pxa2xx_ac97_finish_reset(ac97);
 }
 
-static struct snd_ac97_bus_ops pxa2xx_ac97_ops = {
+static const struct snd_ac97_bus_ops pxa2xx_ac97_ops = {
 	.read	= pxa2xx_ac97_read,
 	.write	= pxa2xx_ac97_write,
 	.reset	= pxa2xx_ac97_reset,
diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index ac35222..03d9a8f 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -909,7 +909,7 @@ static int __devinit atmel_ac97c_probe(struct platform_device *pdev)
 	struct resource			*regs;
 	struct ac97c_platform_data	*pdata;
 	struct clk			*pclk;
-	static struct snd_ac97_bus_ops	ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write	= atmel_ac97c_write,
 		.read	= atmel_ac97c_read,
 	};
diff --git a/sound/drivers/ml403-ac97cr.c b/sound/drivers/ml403-ac97cr.c
index 6a05462..db95055 100644
--- a/sound/drivers/ml403-ac97cr.c
+++ b/sound/drivers/ml403-ac97cr.c
@@ -1210,7 +1210,7 @@ snd_ml403_ac97cr_mixer(struct snd_ml403_ac97cr *ml403_ac97cr)
 	struct snd_ac97_bus *bus;
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_ml403_ac97cr_codec_write,
 		.read = snd_ml403_ac97cr_codec_read,
 	};
diff --git a/sound/mips/au1x00.c b/sound/mips/au1x00.c
index 446cf97..8fd073b 100644
--- a/sound/mips/au1x00.c
+++ b/sound/mips/au1x00.c
@@ -557,7 +557,7 @@ snd_au1000_ac97_new(struct snd_au1000 *au1000)
 	int err;
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
- 	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_au1000_ac97_write,
 		.read = snd_au1000_ac97_read,
 	};
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index d38d623..53dbe2d 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1910,7 +1910,7 @@ static int ac97_reset_wait(struct snd_ac97 *ac97, int timeout, int with_modem)
  *
  * Returns zero if successful, or a negative error code on failure.
  */
-int snd_ac97_bus(struct snd_card *card, int num, struct snd_ac97_bus_ops *ops,
+int snd_ac97_bus(struct snd_card *card, int num, const struct snd_ac97_bus_ops *ops,
 		 void *private_data, struct snd_ac97_bus **rbus)
 {
 	int err;
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index 8396298..1c4ec8c 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -809,7 +809,7 @@ snd_ad1889_ac97_init(struct snd_ad1889 *chip, const char *quirk_override)
 {
 	int err;
 	struct snd_ac97_template ac97;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_ad1889_ac97_write,
 		.read = snd_ad1889_ac97_read,
 	};
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 6ad0aa3..6005ac5 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -1847,7 +1847,7 @@ static int __devinit snd_ali_mixer(struct snd_ali * codec)
 	struct snd_ac97_template ac97;
 	unsigned int idx;
 	int i, err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_ali_codec_write,
 		.read = snd_ali_codec_read,
 	};
diff --git a/sound/pci/als300.c b/sound/pci/als300.c
index 460f1e3..db3676e 100644
--- a/sound/pci/als300.c
+++ b/sound/pci/als300.c
@@ -319,7 +319,7 @@ static int snd_als300_ac97(struct snd_als300 *chip)
 	struct snd_ac97_bus *bus;
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_als300_ac97_write,
 		.read = snd_als300_ac97_read,
 	};
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 9737bd8..984f507 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1410,7 +1410,7 @@ static int __devinit snd_atiixp_mixer_new(struct atiixp *chip, int clock,
 	struct snd_ac97_template ac97;
 	int i, err;
 	int codec_count;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_atiixp_ac97_write,
 		.read = snd_atiixp_ac97_read,
 	};
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 4044ee2..5afda11 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1067,7 +1067,7 @@ static int __devinit snd_atiixp_mixer_new(struct atiixp_modem *chip, int clock)
 	struct snd_ac97_template ac97;
 	int i, err;
 	int codec_count;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_atiixp_ac97_write,
 		.read = snd_atiixp_ac97_read,
 	};
diff --git a/sound/pci/au88x0/au88x0_mixer.c b/sound/pci/au88x0/au88x0_mixer.c
index 557c782..2666dca 100644
--- a/sound/pci/au88x0/au88x0_mixer.c
+++ b/sound/pci/au88x0/au88x0_mixer.c
@@ -15,7 +15,7 @@ static int __devinit snd_vortex_mixer(vortex_t * vortex)
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = vortex_codec_write,
 		.read = vortex_codec_read,
 	};
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 1d0e7a6..6492d1b 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -822,7 +822,7 @@ snd_azf3328_mixer_new(struct snd_azf3328 *chip)
 {
 	struct snd_ac97_bus *bus;
 	struct snd_ac97_template ac97;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_azf3328_mixer_ac97_write,
 		.read = snd_azf3328_mixer_ac97_read,
 	};
diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index 6591353..b96b929 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1223,7 +1223,7 @@ static int snd_ca0106_ac97(struct snd_ca0106 *chip)
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_ca0106_ac97_write,
 		.read = snd_ca0106_ac97_read,
 	};
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 39ef894..bbc10cc 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -1098,7 +1098,7 @@ static int __devinit snd_cs4281_mixer(struct cs4281 * chip)
 	struct snd_card *card = chip->card;
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_cs4281_ac97_write,
 		.read = snd_cs4281_ac97_read,
 	};
diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index df72ebf..1d4d0c1 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -2316,7 +2316,7 @@ int __devinit snd_cs46xx_mixer(struct snd_cs46xx *chip, int spdif_device)
 	struct snd_ctl_elem_id id;
 	int err;
 	unsigned int idx;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
 		.reset = snd_cs46xx_codec_reset,
 #endif
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index c4a104f..8864db5 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -150,7 +150,7 @@ static int __devinit snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_cs5535audio_ac97_codec_write,
 		.read = snd_cs5535audio_ac97_codec_read,
 	};
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 6a011b7..a133965 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -731,7 +731,7 @@ static int snd_emu10k1x_ac97(struct emu10k1x *chip)
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_emu10k1x_ac97_write,
 		.read = snd_emu10k1x_ac97_read,
 	};
diff --git a/sound/pci/emu10k1/emumixer.c b/sound/pci/emu10k1/emumixer.c
index 9d890a5..5a0f564 100644
--- a/sound/pci/emu10k1/emumixer.c
+++ b/sound/pci/emu10k1/emumixer.c
@@ -1837,7 +1837,7 @@ int __devinit snd_emu10k1_mixer(struct snd_emu10k1 *emu,
 	if (emu->card_capabilities->ac97_chip) {
 		struct snd_ac97_bus *pbus;
 		struct snd_ac97_template ac97;
-		static struct snd_ac97_bus_ops ops = {
+		static const struct snd_ac97_bus_ops ops = {
 			.write = snd_emu10k1_ac97_write,
 			.read = snd_emu10k1_ac97_read,
 		};
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index b11d276..6de30b5 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -1633,7 +1633,7 @@ static int __devinit snd_ensoniq_1371_mixer(struct ensoniq *ensoniq,
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_es1371_codec_write,
 		.read = snd_es1371_codec_read,
 		.wait = snd_es1371_codec_wait,
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 98a9753..d7a4b14 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2020,7 +2020,7 @@ snd_es1968_mixer(struct es1968 *chip)
 	struct snd_ctl_elem_id elem_id;
 #endif
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_es1968_ac97_write,
 		.read = snd_es1968_ac97_read,
 	};
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 76a6714..3a0c1f8 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1014,7 +1014,7 @@ static int __devinit snd_fm801_mixer(struct fm801 *chip)
 	struct snd_ac97_template ac97;
 	unsigned int i;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_fm801_codec_write,
 		.read = snd_fm801_codec_read,
 	};
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index f9c5344..8d62220 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -1517,11 +1517,11 @@ static int __devinit snd_ice1712_ac97_mixer(struct snd_ice1712 *ice)
 	int err, bus_num = 0;
 	struct snd_ac97_template ac97;
 	struct snd_ac97_bus *pbus;
-	static struct snd_ac97_bus_ops con_ops = {
+	static const struct snd_ac97_bus_ops con_ops = {
 		.write = snd_ice1712_ac97_write,
 		.read = snd_ice1712_ac97_read,
 	};
-	static struct snd_ac97_bus_ops pro_ops = {
+	static const struct snd_ac97_bus_ops pro_ops = {
 		.write = snd_ice1712_pro_ac97_write,
 		.read = snd_ice1712_pro_ac97_read,
 	};
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 25b5596..3a70572 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -1461,7 +1461,7 @@ static int __devinit snd_vt1724_ac97_mixer(struct snd_ice1712 *ice)
 	if (!(ice->eeprom.data[ICE_EEP2_ACLINK] & VT1724_CFG_PRO_I2S)) {
 		struct snd_ac97_bus *pbus;
 		struct snd_ac97_template ac97;
-		static struct snd_ac97_bus_ops ops = {
+		static const struct snd_ac97_bus_ops ops = {
 			.write = snd_vt1724_ac97_write,
 			.read = snd_vt1724_ac97_read,
 		};
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 5013374..bb65314 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2158,12 +2158,12 @@ static int __devinit snd_intel8x0_mixer(struct intel8x0 *chip, int ac97_clock,
 	int err;
 	unsigned int i, codecs;
 	unsigned int glob_sta = 0;
-	struct snd_ac97_bus_ops *ops;
-	static struct snd_ac97_bus_ops standard_bus_ops = {
+	const struct snd_ac97_bus_ops *ops;
+	static const struct snd_ac97_bus_ops standard_bus_ops = {
 		.write = snd_intel8x0_codec_write,
 		.read = snd_intel8x0_codec_read,
 	};
-	static struct snd_ac97_bus_ops ali_bus_ops = {
+	static const struct snd_ac97_bus_ops ali_bus_ops = {
 		.write = snd_intel8x0_ali_codec_write,
 		.read = snd_intel8x0_ali_codec_read,
 	};
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index c63e618..ba5f568 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -826,7 +826,7 @@ static int __devinit snd_intel8x0m_mixer(struct intel8x0m *chip, int ac97_clock)
 	struct snd_ac97 *x97;
 	int err;
 	unsigned int glob_sta = 0;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_intel8x0m_codec_write,
 		.read = snd_intel8x0m_codec_read,
 	};
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 7931f07..08d9bc6 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2107,7 +2107,7 @@ static int __devinit snd_m3_mixer(struct snd_m3 *chip)
 	struct snd_ctl_elem_id elem_id;
 #endif
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_m3_ac97_write,
 		.read = snd_m3_ac97_read,
 	};
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index f49969c..e0ce57d 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -1301,7 +1301,7 @@ snd_nm256_mixer(struct nm256 *chip)
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.reset = snd_nm256_ac97_reset,
 		.write = snd_nm256_ac97_write,
 		.read = snd_nm256_ac97_read,
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 530a589..de066aa 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -1999,7 +1999,7 @@ static int __devinit snd_riptide_mixer(struct snd_riptide *chip)
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
 	int err = 0;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_riptide_codec_write,
 		.read = snd_riptide_codec_read,
 	};
diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
index e47da32..8957eb3 100644
--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -1011,7 +1011,7 @@ static int __devinit sis_mixer_create(struct sis7019 *sis)
 {
 	struct snd_ac97_bus *bus;
 	struct snd_ac97_template ac97;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = sis_ac97_write,
 		.read = sis_ac97_read,
 	};
diff --git a/sound/pci/trident/trident_main.c b/sound/pci/trident/trident_main.c
index 2e949e0..fa28dfa 100644
--- a/sound/pci/trident/trident_main.c
+++ b/sound/pci/trident/trident_main.c
@@ -2978,7 +2978,7 @@ static int __devinit snd_trident_mixer(struct snd_trident * trident, int pcm_spd
 	struct snd_kcontrol *kctl;
 	struct snd_ctl_elem_value *uctl;
 	int idx, err, retries = 2;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_trident_codec_write,
 		.read = snd_trident_codec_read,
 	};
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 1a190e2..053b9ce 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -1868,7 +1868,7 @@ static int __devinit snd_via82xx_mixer_new(struct via82xx *chip, const char *qui
 {
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_via82xx_codec_write,
 		.read = snd_via82xx_codec_read,
 		.wait = snd_via82xx_codec_wait,
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index a6191e1..38c7773 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -889,7 +889,7 @@ static int __devinit snd_via82xx_mixer_new(struct via82xx_modem *chip)
 {
 	struct snd_ac97_template ac97;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_via82xx_codec_write,
 		.read = snd_via82xx_codec_read,
 		.wait = snd_via82xx_codec_wait,
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index ec962ca..ca3d59b 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -1795,7 +1795,7 @@ int __devinit snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 	struct snd_pcm_substream *substream;
 	unsigned int idx;
 	int err;
-	static struct snd_ac97_bus_ops ops = {
+	static const struct snd_ac97_bus_ops ops = {
 		.write = snd_ymfpci_codec_write,
 		.read = snd_ymfpci_codec_read,
 	};
diff --git a/sound/soc/au1x/psc-ac97.c b/sound/soc/au1x/psc-ac97.c
index d0db66f..d5f2d6d 100644
--- a/sound/soc/au1x/psc-ac97.c
+++ b/sound/soc/au1x/psc-ac97.c
@@ -201,7 +201,7 @@ static void au1xpsc_ac97_cold_reset(struct snd_ac97 *ac97)
 }
 
 /* AC97 controller operations */
-struct snd_ac97_bus_ops soc_ac97_ops = {
+const struct snd_ac97_bus_ops soc_ac97_ops = {
 	.read		= au1xpsc_ac97_read,
 	.write		= au1xpsc_ac97_write,
 	.reset		= au1xpsc_ac97_cold_reset,
diff --git a/sound/soc/blackfin/bf5xx-ac97.c b/sound/soc/blackfin/bf5xx-ac97.c
index 6d21625..3eebd30 100644
--- a/sound/soc/blackfin/bf5xx-ac97.c
+++ b/sound/soc/blackfin/bf5xx-ac97.c
@@ -198,7 +198,7 @@ static void bf5xx_ac97_cold_reset(struct snd_ac97 *ac97)
 #endif
 }
 
-struct snd_ac97_bus_ops soc_ac97_ops = {
+const struct snd_ac97_bus_ops soc_ac97_ops = {
 	.read	= bf5xx_ac97_read,
 	.write	= bf5xx_ac97_write,
 	.warm_reset	= bf5xx_ac97_warm_reset,
diff --git a/sound/soc/blackfin/bf5xx-ac97.h b/sound/soc/blackfin/bf5xx-ac97.h
index 15c635e..e87519e 100644
--- a/sound/soc/blackfin/bf5xx-ac97.h
+++ b/sound/soc/blackfin/bf5xx-ac97.h
@@ -9,7 +9,7 @@
 #ifndef _BF5XX_AC97_H
 #define _BF5XX_AC97_H
 
-extern struct snd_ac97_bus_ops bf5xx_ac97_ops;
+extern const struct snd_ac97_bus_ops bf5xx_ac97_ops;
 extern struct snd_ac97 *ac97;
 /* Frame format in memory, only support stereo currently */
 struct ac97_frame {
diff --git a/sound/soc/ep93xx/ep93xx-ac97.c b/sound/soc/ep93xx/ep93xx-ac97.c
index c7417c7..91d3144 100644
--- a/sound/soc/ep93xx/ep93xx-ac97.c
+++ b/sound/soc/ep93xx/ep93xx-ac97.c
@@ -239,7 +239,7 @@ static irqreturn_t ep93xx_ac97_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-struct snd_ac97_bus_ops soc_ac97_ops = {
+const struct snd_ac97_bus_ops soc_ac97_ops = {
 	.read		= ep93xx_ac97_read,
 	.write		= ep93xx_ac97_write,
 	.reset		= ep93xx_ac97_cold_reset,
diff --git a/sound/soc/fsl/mpc5200_psc_ac97.c b/sound/soc/fsl/mpc5200_psc_ac97.c
index ad36b09..84710ab 100644
--- a/sound/soc/fsl/mpc5200_psc_ac97.c
+++ b/sound/soc/fsl/mpc5200_psc_ac97.c
@@ -131,7 +131,7 @@ static void psc_ac97_cold_reset(struct snd_ac97 *ac97)
 	psc_ac97_warm_reset(ac97);
 }
 
-struct snd_ac97_bus_ops soc_ac97_ops = {
+const struct snd_ac97_bus_ops soc_ac97_ops = {
 	.read		= psc_ac97_read,
 	.write		= psc_ac97_write,
 	.reset		= psc_ac97_cold_reset,
diff --git a/sound/soc/imx/imx-ssi.c b/sound/soc/imx/imx-ssi.c
index 10a8e27..78163ab 100644
--- a/sound/soc/imx/imx-ssi.c
+++ b/sound/soc/imx/imx-ssi.c
@@ -584,7 +584,7 @@ static void imx_ssi_ac97_warm_reset(struct snd_ac97 *ac97)
 		imx_ssi->ac97_warm_reset(ac97);
 }
 
-struct snd_ac97_bus_ops soc_ac97_ops = {
+const struct snd_ac97_bus_ops soc_ac97_ops = {
 	.read		= imx_ssi_ac97_read,
 	.write		= imx_ssi_ac97_write,
 	.reset		= imx_ssi_ac97_reset,
diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index 9c0edad..4289a51 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -197,7 +197,7 @@ static void nuc900_ac97_cold_reset(struct snd_ac97 *ac97)
 }
 
 /* AC97 controller operations */
-struct snd_ac97_bus_ops soc_ac97_ops = {
+const struct snd_ac97_bus_ops soc_ac97_ops = {
 	.read		= nuc900_ac97_read,
 	.write		= nuc900_ac97_write,
 	.reset		= nuc900_ac97_cold_reset,
diff --git a/sound/soc/pxa/pxa2xx-ac97.c b/sound/soc/pxa/pxa2xx-ac97.c
index ac51c6d..7edb05b 100644
--- a/sound/soc/pxa/pxa2xx-ac97.c
+++ b/sound/soc/pxa/pxa2xx-ac97.c
@@ -40,7 +40,7 @@ static void pxa2xx_ac97_cold_reset(struct snd_ac97 *ac97)
 	pxa2xx_ac97_finish_reset(ac97);
 }
 
-struct snd_ac97_bus_ops soc_ac97_ops = {
+const struct snd_ac97_bus_ops soc_ac97_ops = {
 	.read	= pxa2xx_ac97_read,
 	.write	= pxa2xx_ac97_write,
 	.warm_reset	= pxa2xx_ac97_warm_reset,
diff --git a/sound/soc/pxa/pxa2xx-ac97.h b/sound/soc/pxa/pxa2xx-ac97.h
index eda891e..4ca9ee7 100644
--- a/sound/soc/pxa/pxa2xx-ac97.h
+++ b/sound/soc/pxa/pxa2xx-ac97.h
@@ -15,6 +15,6 @@
 #define PXA2XX_DAI_AC97_MIC		2
 
 /* platform data */
-extern struct snd_ac97_bus_ops pxa2xx_ac97_ops;
+extern const struct snd_ac97_bus_ops pxa2xx_ac97_ops;
 
 #endif
diff --git a/sound/soc/samsung/ac97.c b/sound/soc/samsung/ac97.c
index f97110e..8b565d4 100644
--- a/sound/soc/samsung/ac97.c
+++ b/sound/soc/samsung/ac97.c
@@ -213,7 +213,7 @@ static irqreturn_t s3c_ac97_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-struct snd_ac97_bus_ops soc_ac97_ops = {
+const struct snd_ac97_bus_ops soc_ac97_ops = {
 	.read       = s3c_ac97_read,
 	.write      = s3c_ac97_write,
 	.warm_reset = s3c_ac97_warm_reset,
diff --git a/sound/soc/sh/hac.c b/sound/soc/sh/hac.c
index c87e3ff..32e78ed 100644
--- a/sound/soc/sh/hac.c
+++ b/sound/soc/sh/hac.c
@@ -227,7 +227,7 @@ static void hac_ac97_coldrst(struct snd_ac97 *ac97)
 	hac_ac97_warmrst(ac97);
 }
 
-struct snd_ac97_bus_ops soc_ac97_ops = {
+const struct snd_ac97_bus_ops soc_ac97_ops = {
 	.read	= hac_ac97_read,
 	.write	= hac_ac97_write,
 	.reset	= hac_ac97_coldrst,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index e44267f..dd13b94 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1695,7 +1695,7 @@ EXPORT_SYMBOL_GPL(snd_soc_platform_write);
  * Initialises AC97 codec resources for use by ad-hoc devices only.
  */
 int snd_soc_new_ac97_codec(struct snd_soc_codec *codec,
-	struct snd_ac97_bus_ops *ops, int num)
+	const struct snd_ac97_bus_ops *ops, int num)
 {
 	mutex_lock(&codec->mutex);
 
diff --git a/sound/soc/txx9/txx9aclc-ac97.c b/sound/soc/txx9/txx9aclc-ac97.c
index 743d07b..b884623 100644
--- a/sound/soc/txx9/txx9aclc-ac97.c
+++ b/sound/soc/txx9/txx9aclc-ac97.c
@@ -119,7 +119,7 @@ static void txx9aclc_ac97_cold_reset(struct snd_ac97 *ac97)
 }
 
 /* AC97 controller operations */
-struct snd_ac97_bus_ops soc_ac97_ops = {
+const struct snd_ac97_bus_ops soc_ac97_ops = {
 	.read		= txx9aclc_ac97_read,
 	.write		= txx9aclc_ac97_write,
 	.reset		= txx9aclc_ac97_cold_reset,
-- 
1.7.6.345.g5c2f8

