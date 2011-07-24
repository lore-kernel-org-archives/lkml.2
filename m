Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1GXJkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 05:40:31 -0400
Received: from nm13-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.248]:47636
	"HELO nm13-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752039Ab1GXJkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 05:40:21 -0400
X-Yahoo-Newman-Id: 891086.7044.bm@omp1017.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=DKIM-Signature:Message-ID:X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:To:Cc:Subject;
  b=gRRA5aQlt6rKz9ZVgEdCjIUIHeQp+Sal5YNQ6xh9LSY0IXaAXchoXpZee9pWEAE9VMMnSs5XVlhLc91ayI0d5MnwakAUhZko3uZDPG9/zhWtBGm+92vlbmUlDdlnI/hPD7Qe3jabA5+K+BgVsBkgMWVi14z4RcJxIfTIC2Bt1q0=  ;
Message-ID: <781352.27434.qm@smtp128.mail.ukl.yahoo.com>
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: X0nVlm8VM1mC2bMdnb5amGGkvXZSry6Z_o_TgGTTCOU0.uA
 o2v2t7spD0ow.vgkGDHknzpLuJ4fWRHuSGfx4FYde4vPna3y5yEAVlP6hcPo
 obtAJ7MhXUOJjHs6eBDqRX1b59dHLsbASTh7U_BHW2pDhJAHgVUT7.KIy5xW
 HFjQ82c8rgLt6b5k977pM_9IchAJQc5gCDS_OZnuZRZ8EetW6Q6mDQdyelGw
 zEz.AnC1ODmeCrOGTHXiLKyjwa5oxiRJUJGN0Cd_vxvdx_kI3TUuqntwMGnT
 k73eR1KQiTVUn1bCUONV3.FDgCnduf1LIT4FQCGd5HgcjJsClwG6SVxmhV97
 vlpPVRFSogeUYi8zNQ6KWUK_8Ev8icnSIpngMHMoXFEDa3Ud4LKXzYJsJiRW
 3RBg4R_bEghrDiU3fYI7HxtEnYIAs
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
Date: Sun, 24 Jul 2011 11:40:37 +0200
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Kees Cook <kees.cook@canonical.com>, Emese Revfy <re.emese@gmail.com>,
        kernel-janitors@vger.kernel.org
Subject: sound: constify snd_device_ops
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

>From b79b8b4c8a3fce3d5eb84988af44d6819ae5590d Mon Sep 17 00:00:00 2001
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Date: Sun, 24 Jul 2011 10:25:54 +0200
Subject: sound: constify snd_device_ops

Inspired by hunks of the PaX/grsecurity patch.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 drivers/hid/hid-prodikeys.c          |    2 +-
 drivers/staging/go7007/snd-go7007.c  |    2 +-
 drivers/staging/intel_sst/intelmid.c |    2 +-
 drivers/staging/line6/midi.c         |    2 +-
 drivers/staging/line6/pcm.c          |    2 +-
 drivers/staging/solo6x10/g723.c      |    2 +-
 drivers/usb/gadget/gmidi.c           |    2 +-
 include/sound/core.h                 |    4 ++--
 sound/aoa/aoa.h                      |    2 +-
 sound/aoa/codecs/onyx.c              |    2 +-
 sound/aoa/codecs/tas.c               |    2 +-
 sound/aoa/codecs/toonie.c            |    2 +-
 sound/aoa/core/alsa.c                |    2 +-
 sound/core/control.c                 |    2 +-
 sound/core/device.c                  |    2 +-
 sound/core/hwdep.c                   |    2 +-
 sound/core/info.c                    |    2 +-
 sound/core/jack.c                    |    2 +-
 sound/core/pcm.c                     |    2 +-
 sound/core/rawmidi.c                 |    2 +-
 sound/core/seq/seq_device.c          |    2 +-
 sound/core/timer.c                   |    2 +-
 sound/drivers/ml403-ac97cr.c         |    2 +-
 sound/drivers/opl3/opl3_lib.c        |    2 +-
 sound/drivers/opl4/opl4_lib.c        |    2 +-
 sound/drivers/pcsp/pcsp.c            |    2 +-
 sound/drivers/serial-u16550.c        |    2 +-
 sound/i2c/i2c.c                      |    2 +-
 sound/i2c/other/ak4113.c             |    2 +-
 sound/i2c/other/ak4114.c             |    2 +-
 sound/i2c/other/ak4117.c             |    2 +-
 sound/isa/ad1816a/ad1816a_lib.c      |    2 +-
 sound/isa/es1688/es1688_lib.c        |    2 +-
 sound/isa/es18xx.c                   |    2 +-
 sound/isa/gus/gus_main.c             |    2 +-
 sound/isa/msnd/msnd_pinnacle.c       |    2 +-
 sound/isa/sb/emu8000.c               |    2 +-
 sound/isa/sb/sb_common.c             |    2 +-
 sound/isa/wss/wss_lib.c              |    2 +-
 sound/mips/hal2.c                    |    2 +-
 sound/mips/sgio2audio.c              |    2 +-
 sound/parisc/harmony.c               |    2 +-
 sound/pci/ac97/ac97_codec.c          |    4 ++--
 sound/pci/ad1889.c                   |    2 +-
 sound/pci/ak4531_codec.c             |    2 +-
 sound/pci/ali5451/ali5451.c          |    2 +-
 sound/pci/als300.c                   |    2 +-
 sound/pci/atiixp.c                   |    2 +-
 sound/pci/atiixp_modem.c             |    2 +-
 sound/pci/au88x0/au88x0.c            |    2 +-
 sound/pci/aw2/aw2-alsa.c             |    2 +-
 sound/pci/azt3328.c                  |    2 +-
 sound/pci/bt87x.c                    |    2 +-
 sound/pci/ca0106/ca0106_main.c       |    2 +-
 sound/pci/cmipci.c                   |    2 +-
 sound/pci/cs4281.c                   |    2 +-
 sound/pci/cs46xx/cs46xx_lib.c        |    2 +-
 sound/pci/cs5530.c                   |    2 +-
 sound/pci/cs5535audio/cs5535audio.c  |    2 +-
 sound/pci/ctxfi/ctatc.c              |    2 +-
 sound/pci/echoaudio/echoaudio.c      |    2 +-
 sound/pci/emu10k1/emu10k1_main.c     |    2 +-
 sound/pci/emu10k1/emu10k1x.c         |    2 +-
 sound/pci/ens1370.c                  |    2 +-
 sound/pci/es1938.c                   |    2 +-
 sound/pci/es1968.c                   |    2 +-
 sound/pci/fm801.c                    |    2 +-
 sound/pci/hda/hda_codec.c            |    2 +-
 sound/pci/hda/hda_intel.c            |    2 +-
 sound/pci/ice1712/ice1712.c          |    2 +-
 sound/pci/ice1712/ice1724.c          |    2 +-
 sound/pci/intel8x0.c                 |    2 +-
 sound/pci/intel8x0m.c                |    2 +-
 sound/pci/korg1212/korg1212.c        |    2 +-
 sound/pci/lola/lola.c                |    2 +-
 sound/pci/lx6464es/lx6464es.c        |    2 +-
 sound/pci/maestro3.c                 |    2 +-
 sound/pci/mixart/mixart.c            |    2 +-
 sound/pci/nm256/nm256.c              |    2 +-
 sound/pci/pcxhr/pcxhr.c              |    2 +-
 sound/pci/riptide/riptide.c          |    2 +-
 sound/pci/sis7019.c                  |    2 +-
 sound/pci/sonicvibes.c               |    2 +-
 sound/pci/trident/trident_main.c     |    2 +-
 sound/pci/via82xx.c                  |    2 +-
 sound/pci/via82xx_modem.c            |    2 +-
 sound/pci/vx222/vx222.c              |    2 +-
 sound/pci/ymfpci/ymfpci_main.c       |    2 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.c   |    2 +-
 sound/pcmcia/vx/vxpocket.c           |    2 +-
 sound/ppc/pmac.c                     |    2 +-
 sound/sh/sh_dac_audio.c              |    2 +-
 sound/sparc/amd7930.c                |    2 +-
 sound/sparc/cs4231.c                 |    4 ++--
 sound/spi/at73c213.c                 |    2 +-
 sound/usb/card.c                     |    2 +-
 sound/usb/mixer.c                    |    2 +-
 97 files changed, 100 insertions(+), 100 deletions(-)

diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index 158b389..34bef53 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -608,7 +608,7 @@ static int pcmidi_snd_initialise(struct pcmidi_snd *pm)
 	struct snd_rawmidi *rwmidi;
 	int err;
 
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = pcmidi_snd_free,
 	};
 
diff --git a/drivers/staging/go7007/snd-go7007.c b/drivers/staging/go7007/snd-go7007.c
index deac938..ac69c57 100644
--- a/drivers/staging/go7007/snd-go7007.c
+++ b/drivers/staging/go7007/snd-go7007.c
@@ -227,7 +227,7 @@ static int go7007_snd_free(struct snd_device *device)
 	return 0;
 }
 
-static struct snd_device_ops go7007_snd_device_ops = {
+static const struct snd_device_ops go7007_snd_device_ops = {
 	.dev_free	= go7007_snd_free,
 };
 
diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index 25656ad..6087499 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -798,7 +798,7 @@ static int __devinit snd_intelmad_create(
 		struct snd_card *card)
 {
 	int ret_val;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_intelmad_dev_free,
 	};
 
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index e554a2d..9cc0fb1 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -373,7 +373,7 @@ static int snd_line6_midi_free(struct snd_device *device)
 */
 int line6_init_midi(struct usb_line6 *line6)
 {
-	static struct snd_device_ops midi_ops = {
+	static const struct snd_device_ops midi_ops = {
 		.dev_free = snd_line6_midi_free,
 	};
 
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 9d4c8a6..bf31522 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -384,7 +384,7 @@ void line6_pcm_disconnect(struct snd_line6_pcm *line6pcm)
 int line6_init_pcm(struct usb_line6 *line6,
 		   struct line6_pcm_properties *properties)
 {
-	static struct snd_device_ops pcm_ops = {
+	static const struct snd_device_ops pcm_ops = {
 		.dev_free = snd_line6_pcm_free,
 	};
 
diff --git a/drivers/staging/solo6x10/g723.c b/drivers/staging/solo6x10/g723.c
index bd8eb92..cf17b6c 100644
--- a/drivers/staging/solo6x10/g723.c
+++ b/drivers/staging/solo6x10/g723.c
@@ -334,7 +334,7 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
 
 int solo_g723_init(struct solo_dev *solo_dev)
 {
-	static struct snd_device_ops ops = { NULL };
+	static const struct snd_device_ops ops = { NULL, NULL, NULL };
 	struct snd_card *card;
 	struct snd_kcontrol_new kctl;
 	char name[32];
diff --git a/drivers/usb/gadget/gmidi.c b/drivers/usb/gadget/gmidi.c
index 47b86b9..620a70e 100644
--- a/drivers/usb/gadget/gmidi.c
+++ b/drivers/usb/gadget/gmidi.c
@@ -1091,7 +1091,7 @@ static int gmidi_register_card(struct gmidi_device *dev)
 	int err;
 	int out_ports = 1;
 	int in_ports = 1;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = gmidi_snd_free,
 	};
 
diff --git a/include/sound/core.h b/include/sound/core.h
index 1fa2407..185b840 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -88,7 +88,7 @@ struct snd_device {
 	snd_device_state_t state;	/* state of the device */
 	snd_device_type_t type;		/* device type */
 	void *device_data;		/* device structure */
-	struct snd_device_ops *ops;	/* operations */
+	const struct snd_device_ops *ops;	/* operations */
 };
 
 #define snd_device(n) list_entry(n, struct snd_device, list)
@@ -301,7 +301,7 @@ int snd_card_file_remove(struct snd_card *card, struct file *file);
 /* device.c */
 
 int snd_device_new(struct snd_card *card, snd_device_type_t type,
-		   void *device_data, struct snd_device_ops *ops);
+		   void *device_data, const struct snd_device_ops *ops);
 int snd_device_register(struct snd_card *card, void *device_data);
 int snd_device_register_all(struct snd_card *card);
 int snd_device_disconnect(struct snd_card *card, void *device_data);
diff --git a/sound/aoa/aoa.h b/sound/aoa/aoa.h
index e087894..639213b 100644
--- a/sound/aoa/aoa.h
+++ b/sound/aoa/aoa.h
@@ -117,7 +117,7 @@ struct aoa_card {
 };
         
 extern int aoa_snd_device_new(snd_device_type_t type,
-	void * device_data, struct snd_device_ops * ops);
+	void * device_data, const struct snd_device_ops * ops);
 extern struct snd_card *aoa_get_card(void);
 extern int aoa_snd_ctl_add(struct snd_kcontrol* control);
 
diff --git a/sound/aoa/codecs/onyx.c b/sound/aoa/codecs/onyx.c
index 3687a6c..d246826 100644
--- a/sound/aoa/codecs/onyx.c
+++ b/sound/aoa/codecs/onyx.c
@@ -98,7 +98,7 @@ static int onyx_dev_register(struct snd_device *dev)
 	return 0;
 }
 
-static struct snd_device_ops ops = {
+static const struct snd_device_ops ops = {
 	.dev_register = onyx_dev_register,
 };
 
diff --git a/sound/aoa/codecs/tas.c b/sound/aoa/codecs/tas.c
index fd2188c..d357e77 100644
--- a/sound/aoa/codecs/tas.c
+++ b/sound/aoa/codecs/tas.c
@@ -218,7 +218,7 @@ static int tas_dev_register(struct snd_device *dev)
 	return 0;
 }
 
-static struct snd_device_ops ops = {
+static const struct snd_device_ops ops = {
 	.dev_register = tas_dev_register,
 };
 
diff --git a/sound/aoa/codecs/toonie.c b/sound/aoa/codecs/toonie.c
index 69d2cb6..375c649 100644
--- a/sound/aoa/codecs/toonie.c
+++ b/sound/aoa/codecs/toonie.c
@@ -32,7 +32,7 @@ static int toonie_dev_register(struct snd_device *dev)
 	return 0;
 }
 
-static struct snd_device_ops ops = {
+static const struct snd_device_ops ops = {
 	.dev_register = toonie_dev_register,
 };
 
diff --git a/sound/aoa/core/alsa.c b/sound/aoa/core/alsa.c
index 0fa3855..1cb9248 100644
--- a/sound/aoa/core/alsa.c
+++ b/sound/aoa/core/alsa.c
@@ -61,7 +61,7 @@ void aoa_alsa_cleanup(void)
 }
 
 int aoa_snd_device_new(snd_device_type_t type,
-		       void * device_data, struct snd_device_ops * ops)
+		       void * device_data, const struct snd_device_ops * ops)
 {
 	struct snd_card *card = aoa_get_card();
 	int err;
diff --git a/sound/core/control.c b/sound/core/control.c
index f8c5be4..5935638 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1583,7 +1583,7 @@ static int snd_ctl_dev_free(struct snd_device *device)
  */
 int snd_ctl_create(struct snd_card *card)
 {
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_ctl_dev_free,
 		.dev_register =	snd_ctl_dev_register,
 		.dev_disconnect = snd_ctl_dev_disconnect,
diff --git a/sound/core/device.c b/sound/core/device.c
index 2d1ad4b..6a60067 100644
--- a/sound/core/device.c
+++ b/sound/core/device.c
@@ -41,7 +41,7 @@
  * Returns zero if successful, or a negative error code on failure.
  */
 int snd_device_new(struct snd_card *card, snd_device_type_t type,
-		   void *device_data, struct snd_device_ops *ops)
+		   void *device_data, const struct snd_device_ops *ops)
 {
 	struct snd_device *dev;
 
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index a70ee7f..ce20fd6 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -348,7 +348,7 @@ int snd_hwdep_new(struct snd_card *card, char *id, int device,
 {
 	struct snd_hwdep *hwdep;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_hwdep_dev_free,
 		.dev_register = snd_hwdep_dev_register,
 		.dev_disconnect = snd_hwdep_dev_disconnect,
diff --git a/sound/core/info.c b/sound/core/info.c
index 7077f60..ddb66a3 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -897,7 +897,7 @@ static int snd_info_dev_register_entry(struct snd_device *device)
 int snd_card_proc_new(struct snd_card *card, const char *name,
 		      struct snd_info_entry **entryp)
 {
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_info_dev_free_entry,
 		.dev_register =	snd_info_dev_register_entry,
 		/* disconnect is done via snd_info_card_disconnect() */
diff --git a/sound/core/jack.c b/sound/core/jack.c
index 53b53e9..7773346 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -105,7 +105,7 @@ int snd_jack_new(struct snd_card *card, const char *id, int type,
 	struct snd_jack *jack;
 	int err;
 	int i;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_jack_dev_free,
 		.dev_register = snd_jack_dev_register,
 	};
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index ee9abb2..fc489bf 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -717,7 +717,7 @@ int snd_pcm_new(struct snd_card *card, const char *id, int device,
 {
 	struct snd_pcm *pcm;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_pcm_dev_free,
 		.dev_register =	snd_pcm_dev_register,
 		.dev_disconnect = snd_pcm_dev_disconnect,
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 849a0ed..fecaa40 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1434,7 +1434,7 @@ int snd_rawmidi_new(struct snd_card *card, char *id, int device,
 {
 	struct snd_rawmidi *rmidi;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_rawmidi_dev_free,
 		.dev_register = snd_rawmidi_dev_register,
 		.dev_disconnect = snd_rawmidi_dev_disconnect,
diff --git a/sound/core/seq/seq_device.c b/sound/core/seq/seq_device.c
index 1f99767..042733d 100644
--- a/sound/core/seq/seq_device.c
+++ b/sound/core/seq/seq_device.c
@@ -178,7 +178,7 @@ int snd_seq_device_new(struct snd_card *card, int device, char *id, int argsize,
 	struct snd_seq_device *dev;
 	struct ops_list *ops;
 	int err;
-	static struct snd_device_ops dops = {
+	static const struct snd_device_ops dops = {
 		.dev_free = snd_seq_device_dev_free,
 		.dev_register = snd_seq_device_dev_register,
 		.dev_disconnect = snd_seq_device_dev_disconnect,
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 7c1cbf0..2160376 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -756,7 +756,7 @@ int snd_timer_new(struct snd_card *card, char *id, struct snd_timer_id *tid,
 {
 	struct snd_timer *timer;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_timer_dev_free,
 		.dev_register = snd_timer_dev_register,
 		.dev_disconnect = snd_timer_dev_disconnect,
diff --git a/sound/drivers/ml403-ac97cr.c b/sound/drivers/ml403-ac97cr.c
index 5cfcb90..6a05462 100644
--- a/sound/drivers/ml403-ac97cr.c
+++ b/sound/drivers/ml403-ac97cr.c
@@ -1114,7 +1114,7 @@ snd_ml403_ac97cr_create(struct snd_card *card, struct platform_device *pfdev,
 {
 	struct snd_ml403_ac97cr *ml403_ac97cr;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_ml403_ac97cr_dev_free,
 	};
 	struct resource *resource;
diff --git a/sound/drivers/opl3/opl3_lib.c b/sound/drivers/opl3/opl3_lib.c
index 6e31e46..227ab3a 100644
--- a/sound/drivers/opl3/opl3_lib.c
+++ b/sound/drivers/opl3/opl3_lib.c
@@ -346,7 +346,7 @@ int snd_opl3_new(struct snd_card *card,
 		 unsigned short hardware,
 		 struct snd_opl3 **ropl3)
 {
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_opl3_dev_free,
 	};
 	struct snd_opl3 *opl3;
diff --git a/sound/drivers/opl4/opl4_lib.c b/sound/drivers/opl4/opl4_lib.c
index f07e38d..a67216b 100644
--- a/sound/drivers/opl4/opl4_lib.c
+++ b/sound/drivers/opl4/opl4_lib.c
@@ -198,7 +198,7 @@ int snd_opl4_create(struct snd_card *card,
 	struct snd_opl4 *opl4;
 	struct snd_opl3 *opl3;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_opl4_dev_free
 	};
 
diff --git a/sound/drivers/pcsp/pcsp.c b/sound/drivers/pcsp/pcsp.c
index f165c77..9596fc3 100644
--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -41,7 +41,7 @@ struct snd_pcsp pcsp_chip;
 
 static int __devinit snd_pcsp_create(struct snd_card *card)
 {
-	static struct snd_device_ops ops = { };
+	static const struct snd_device_ops ops = { };
 	struct timespec tp;
 	int err;
 	int div, min_div, order;
diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
index a25fb7b..11e122c 100644
--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -792,7 +792,7 @@ static int __devinit snd_uart16550_create(struct snd_card *card,
 				       int droponfull,
 				       struct snd_uart16550 **ruart)
 {
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_uart16550_dev_free,
 	};
 	struct snd_uart16550 *uart;
diff --git a/sound/i2c/i2c.c b/sound/i2c/i2c.c
index eb7c7d0..450eba7 100644
--- a/sound/i2c/i2c.c
+++ b/sound/i2c/i2c.c
@@ -80,7 +80,7 @@ int snd_i2c_bus_create(struct snd_card *card, const char *name,
 {
 	struct snd_i2c_bus *bus;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_i2c_bus_dev_free,
 	};
 
diff --git a/sound/i2c/other/ak4113.c b/sound/i2c/other/ak4113.c
index c424d32..8ff4d3a 100644
--- a/sound/i2c/other/ak4113.c
+++ b/sound/i2c/other/ak4113.c
@@ -75,7 +75,7 @@ int snd_ak4113_create(struct snd_card *card, ak4113_read_t *read,
 	struct ak4113 *chip;
 	int err = 0;
 	unsigned char reg;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =     snd_ak4113_dev_free,
 	};
 
diff --git a/sound/i2c/other/ak4114.c b/sound/i2c/other/ak4114.c
index d9fb537..1e2ea28 100644
--- a/sound/i2c/other/ak4114.c
+++ b/sound/i2c/other/ak4114.c
@@ -86,7 +86,7 @@ int snd_ak4114_create(struct snd_card *card,
 	struct ak4114 *chip;
 	int err = 0;
 	unsigned char reg;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =     snd_ak4114_dev_free,
 	};
 
diff --git a/sound/i2c/other/ak4117.c b/sound/i2c/other/ak4117.c
index 2cad2d6..c646fb7 100644
--- a/sound/i2c/other/ak4117.c
+++ b/sound/i2c/other/ak4117.c
@@ -78,7 +78,7 @@ int snd_ak4117_create(struct snd_card *card, ak4117_read_t *read, ak4117_write_t
 	struct ak4117 *chip;
 	int err = 0;
 	unsigned char reg;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =     snd_ak4117_dev_free,
 	};
 
diff --git a/sound/isa/ad1816a/ad1816a_lib.c b/sound/isa/ad1816a/ad1816a_lib.c
index 05aef8b..17ee6ee 100644
--- a/sound/isa/ad1816a/ad1816a_lib.c
+++ b/sound/isa/ad1816a/ad1816a_lib.c
@@ -575,7 +575,7 @@ int __devinit snd_ad1816a_create(struct snd_card *card,
 				 unsigned long port, int irq, int dma1, int dma2,
 				 struct snd_ad1816a **rchip)
 {
-        static struct snd_device_ops ops = {
+        static const struct snd_device_ops ops = {
 		.dev_free =	snd_ad1816a_dev_free,
 	};
 	int error;
diff --git a/sound/isa/es1688/es1688_lib.c b/sound/isa/es1688/es1688_lib.c
index 0767620..9333adf 100644
--- a/sound/isa/es1688/es1688_lib.c
+++ b/sound/isa/es1688/es1688_lib.c
@@ -646,7 +646,7 @@ int snd_es1688_create(struct snd_card *card,
 		      int dma8,
 		      unsigned short hardware)
 {
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_es1688_dev_free,
 	};
                                 
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index fb4d6b3..ba36e9e 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1784,7 +1784,7 @@ static int __devinit snd_es18xx_new_device(struct snd_card *card,
 					   int irq, int dma1, int dma2)
 {
 	struct snd_es18xx *chip = card->private_data;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_es18xx_dev_free,
         };
 	int err;
diff --git a/sound/isa/gus/gus_main.c b/sound/isa/gus/gus_main.c
index 12eb98f..b878a62 100644
--- a/sound/isa/gus/gus_main.c
+++ b/sound/isa/gus/gus_main.c
@@ -139,7 +139,7 @@ int snd_gus_create(struct snd_card *card,
 {
 	struct snd_gus_card *gus;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_gus_dev_free,
 	};
 
diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index 91d6023..5756c0a 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -539,7 +539,7 @@ static int __devinit snd_msnd_attach(struct snd_card *card)
 {
 	struct snd_msnd *chip = card->private_data;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =      snd_msnd_dev_free,
 		};
 
diff --git a/sound/isa/sb/emu8000.c b/sound/isa/sb/emu8000.c
index 5d61f5a..1e45ce5 100644
--- a/sound/isa/sb/emu8000.c
+++ b/sound/isa/sb/emu8000.c
@@ -1079,7 +1079,7 @@ snd_emu8000_new(struct snd_card *card, int index, long port, int seq_ports,
 	struct snd_seq_device *awe;
 	struct snd_emu8000 *hw;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_emu8000_dev_free,
 	};
 
diff --git a/sound/isa/sb/sb_common.c b/sound/isa/sb/sb_common.c
index eae6c1c..3ddf962 100644
--- a/sound/isa/sb/sb_common.c
+++ b/sound/isa/sb/sb_common.c
@@ -218,7 +218,7 @@ int snd_sbdsp_create(struct snd_card *card,
 {
 	struct snd_sb *chip;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_sbdsp_dev_free,
 	};
 
diff --git a/sound/isa/wss/wss_lib.c b/sound/isa/wss/wss_lib.c
index 2a42cc3..a62ed15 100644
--- a/sound/isa/wss/wss_lib.c
+++ b/sound/isa/wss/wss_lib.c
@@ -1801,7 +1801,7 @@ int snd_wss_create(struct snd_card *card,
 		      unsigned short hwshare,
 		      struct snd_wss **rchip)
 {
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_wss_dev_free,
 	};
 	struct snd_wss *chip;
diff --git a/sound/mips/hal2.c b/sound/mips/hal2.c
index 453d343..0630d98 100644
--- a/sound/mips/hal2.c
+++ b/sound/mips/hal2.c
@@ -766,7 +766,7 @@ static int hal2_dev_free(struct snd_device *device)
 	return 0;
 }
 
-static struct snd_device_ops hal2_ops = {
+static const struct snd_device_ops hal2_ops = {
 	.dev_free = hal2_dev_free,
 };
 
diff --git a/sound/mips/sgio2audio.c b/sound/mips/sgio2audio.c
index 717604c..4fe6115 100644
--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -829,7 +829,7 @@ static int snd_sgio2audio_dev_free(struct snd_device *device)
 	return snd_sgio2audio_free(chip);
 }
 
-static struct snd_device_ops ops = {
+static const struct snd_device_ops ops = {
 	.dev_free = snd_sgio2audio_dev_free,
 };
 
diff --git a/sound/parisc/harmony.c b/sound/parisc/harmony.c
index f47f9e2..8b6d532 100644
--- a/sound/parisc/harmony.c
+++ b/sound/parisc/harmony.c
@@ -922,7 +922,7 @@ snd_harmony_create(struct snd_card *card,
 {
 	int err;
 	struct snd_harmony *h;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_harmony_dev_free,
 	};
 
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 7f4d619..d38d623 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1915,7 +1915,7 @@ int snd_ac97_bus(struct snd_card *card, int num, struct snd_ac97_bus_ops *ops,
 {
 	int err;
 	struct snd_ac97_bus *bus;
-	static struct snd_device_ops dev_ops = {
+	static const struct snd_device_ops dev_ops = {
 		.dev_free =	snd_ac97_bus_dev_free,
 	};
 
@@ -2015,7 +2015,7 @@ int snd_ac97_mixer(struct snd_ac97_bus *bus, struct snd_ac97_template *template,
 	unsigned long end_time;
 	unsigned int reg;
 	const struct ac97_codec_id *pid;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_ac97_dev_free,
 		.dev_register =	snd_ac97_dev_register,
 		.dev_disconnect =	snd_ac97_dev_disconnect,
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index 2015036..8396298 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -899,7 +899,7 @@ snd_ad1889_create(struct snd_card *card,
 	int err;
 
 	struct snd_ad1889 *chip;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_ad1889_dev_free,
 	};
 
diff --git a/sound/pci/ak4531_codec.c b/sound/pci/ak4531_codec.c
index fd135e3..a719b7b 100644
--- a/sound/pci/ak4531_codec.c
+++ b/sound/pci/ak4531_codec.c
@@ -389,7 +389,7 @@ int __devinit snd_ak4531_mixer(struct snd_card *card,
 	unsigned int idx;
 	int err;
 	struct snd_ak4531 *ak4531;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_ak4531_dev_free,
 	};
 
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index b444b74..6ad0aa3 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -2114,7 +2114,7 @@ static int __devinit snd_ali_create(struct snd_card *card,
 	struct snd_ali *codec;
 	int i, err;
 	unsigned short cmdw;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_ali_dev_free,
         };
 
diff --git a/sound/pci/als300.c b/sound/pci/als300.c
index 736c8e9..460f1e3 100644
--- a/sound/pci/als300.c
+++ b/sound/pci/als300.c
@@ -680,7 +680,7 @@ static int __devinit snd_als300_create(struct snd_card *card,
 	void *irq_handler;
 	int err;
 
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_als300_dev_free,
 	};
 	*rchip = NULL;
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 537e0a2..9737bd8 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1590,7 +1590,7 @@ static int __devinit snd_atiixp_create(struct snd_card *card,
 				      struct pci_dev *pci,
 				      struct atiixp **r_chip)
 {
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_atiixp_dev_free,
 	};
 	struct atiixp *chip;
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 45df275..4044ee2 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1226,7 +1226,7 @@ static int __devinit snd_atiixp_create(struct snd_card *card,
 				       struct pci_dev *pci,
 				       struct atiixp_modem **r_chip)
 {
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_atiixp_dev_free,
 	};
 	struct atiixp_modem *chip;
diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index a384699..fd9a54f 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -142,7 +142,7 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci, vortex_t ** rchip)
 {
 	vortex_t *chip;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_vortex_dev_free,
 	};
 
diff --git a/sound/pci/aw2/aw2-alsa.c b/sound/pci/aw2/aw2-alsa.c
index f8569b1..ee4bce1 100644
--- a/sound/pci/aw2/aw2-alsa.c
+++ b/sound/pci/aw2/aw2-alsa.c
@@ -263,7 +263,7 @@ static int __devinit snd_aw2_create(struct snd_card *card,
 {
 	struct aw2 *chip;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_aw2_dev_free,
 	};
 
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index e4d76a2..1d0e7a6 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -2497,7 +2497,7 @@ snd_azf3328_create(struct snd_card *card,
 {
 	struct snd_azf3328 *chip;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =     snd_azf3328_dev_free,
 	};
 	u8 dma_init;
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 3918033..610f9c5 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -720,7 +720,7 @@ static int __devinit snd_bt87x_create(struct snd_card *card,
 {
 	struct snd_bt87x *chip;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_bt87x_dev_free
 	};
 
diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index 061b7e6..6591353 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1629,7 +1629,7 @@ static int __devinit snd_ca0106_create(int dev, struct snd_card *card,
 	struct snd_ca0106 *chip;
 	struct snd_ca0106_details *c;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_ca0106_dev_free,
 	};
 
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 9cf99fb..f20a5d7 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -3011,7 +3011,7 @@ static int __devinit snd_cmipci_create(struct snd_card *card, struct pci_dev *pc
 {
 	struct cmipci *cm;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_cmipci_dev_free,
 	};
 	unsigned int val;
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 07f04e3..39ef894 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -1343,7 +1343,7 @@ static int __devinit snd_cs4281_create(struct snd_card *card,
 	struct cs4281 *chip;
 	unsigned int tmp;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_cs4281_dev_free,
 	};
 
diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index 9546bf0..df72ebf 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -3722,7 +3722,7 @@ int __devinit snd_cs46xx_create(struct snd_card *card,
 	struct snd_cs46xx_region *region;
 	struct cs_card_type *cp;
 	u16 ss_card, ss_vendor;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_cs46xx_dev_free,
 	};
 	
diff --git a/sound/pci/cs5530.c b/sound/pci/cs5530.c
index a466934..1b30161 100644
--- a/sound/pci/cs5530.c
+++ b/sound/pci/cs5530.c
@@ -107,7 +107,7 @@ static int __devinit snd_cs5530_create(struct snd_card *card,
 	void __iomem *mem;
 	int err;
 
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_cs5530_dev_free,
 	};
 	*rchip = NULL;
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 10d22ed..c4a104f 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -277,7 +277,7 @@ static int __devinit snd_cs5535audio_create(struct snd_card *card,
 	struct cs5535audio *cs5535au;
 
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_cs5535audio_dev_free,
 	};
 
diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index d8a4423..31160e6 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1671,7 +1671,7 @@ int __devinit ct_atc_create(struct snd_card *card, struct pci_dev *pci,
 			    struct ct_atc **ratc)
 {
 	struct ct_atc *atc;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = atc_dev_free,
 	};
 	int err;
diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index d730698..d5e811e 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -1945,7 +1945,7 @@ static __devinit int snd_echo_create(struct snd_card *card,
 	struct echoaudio *chip;
 	int err;
 	size_t sz;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_echo_dev_free,
 	};
 
diff --git a/sound/pci/emu10k1/emu10k1_main.c b/sound/pci/emu10k1/emu10k1_main.c
index fcd4935..e931bae 100644
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -1730,7 +1730,7 @@ int __devinit snd_emu10k1_create(struct snd_card *card,
 	int is_audigy;
 	unsigned int silent_page;
 	const struct snd_emu_chip_details *c;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_emu10k1_dev_free,
 	};
 
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index d4fde1b..6a011b7 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -888,7 +888,7 @@ static int __devinit snd_emu10k1x_create(struct snd_card *card,
 	struct emu10k1x *chip;
 	int err;
 	int ch;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_emu10k1x_dev_free,
 	};
 
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index f02e2f8..b11d276 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -2096,7 +2096,7 @@ static int __devinit snd_ensoniq_create(struct snd_card *card,
 {
 	struct ensoniq *ensoniq;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_ensoniq_dev_free,
 	};
 
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index 26a5a2f..f60ba8e 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -1598,7 +1598,7 @@ static int __devinit snd_es1938_create(struct snd_card *card,
 {
 	struct es1938 *chip;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_es1938_dev_free,
 	};
 
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 99ea932..98a9753 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2657,7 +2657,7 @@ static int __devinit snd_es1968_create(struct snd_card *card,
 				       int do_pm,
 				       struct es1968 **chip_ret)
 {
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_es1968_dev_free,
 	};
 	struct es1968 *chip;
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index f9123f0..76a6714 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1174,7 +1174,7 @@ static int __devinit snd_fm801_create(struct snd_card *card,
 {
 	struct fm801 *chip;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_fm801_dev_free,
 	};
 
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 9c27a3a..0000557 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -727,7 +727,7 @@ int /*__devinit*/ snd_hda_bus_new(struct snd_card *card,
 {
 	struct hda_bus *bus;
 	int err;
-	static struct snd_device_ops dev_ops = {
+	static const struct snd_device_ops dev_ops = {
 		.dev_register = snd_hda_bus_dev_register,
 		.dev_free = snd_hda_bus_dev_free,
 	};
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index be69822..c45f3dc 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2511,7 +2511,7 @@ static int __devinit azx_create(struct snd_card *card, struct pci_dev *pci,
 	struct azx *chip;
 	int i, err;
 	unsigned short gcap;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = azx_dev_free,
 	};
 
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index be06fb3..f9c5344 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2541,7 +2541,7 @@ static int __devinit snd_ice1712_create(struct snd_card *card,
 {
 	struct snd_ice1712 *ice;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_ice1712_dev_free,
 	};
 
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index c2b7f8b..25b5596 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2463,7 +2463,7 @@ static int __devinit snd_vt1724_create(struct snd_card *card,
 {
 	struct snd_ice1712 *ice;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_vt1724_dev_free,
 	};
 
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 6a5b387..5013374 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2927,7 +2927,7 @@ static int __devinit snd_intel8x0_create(struct snd_card *card,
 	unsigned int i;
 	unsigned int int_sta_masks;
 	struct ichdev *ichdev;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_intel8x0_dev_free,
 	};
 
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 7c16164..c63e618 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -1116,7 +1116,7 @@ static int __devinit snd_intel8x0m_create(struct snd_card *card,
 	unsigned int i;
 	unsigned int int_sta_masks;
 	struct ichdev *ichdev;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_intel8x0m_dev_free,
 	};
 	static struct ich_reg_info intel_regs[2] = {
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index fc1d573..72dd7d7 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -2164,7 +2164,7 @@ static int __devinit snd_korg1212_create(struct snd_card *card, struct pci_dev *
         struct snd_korg1212 * korg1212;
 	const struct firmware *dsp_code;
 
-        static struct snd_device_ops ops = {
+        static const struct snd_device_ops ops = {
                 .dev_free = snd_korg1212_dev_free,
         };
 
diff --git a/sound/pci/lola/lola.c b/sound/pci/lola/lola.c
index 3e92e5b..7875574 100644
--- a/sound/pci/lola/lola.c
+++ b/sound/pci/lola/lola.c
@@ -574,7 +574,7 @@ static int __devinit lola_create(struct snd_card *card, struct pci_dev *pci,
 	struct lola *chip;
 	int err;
 	unsigned int dever;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = lola_dev_free,
 	};
 
diff --git a/sound/pci/lx6464es/lx6464es.c b/sound/pci/lx6464es/lx6464es.c
index 04ae84b..224a47a 100644
--- a/sound/pci/lx6464es/lx6464es.c
+++ b/sound/pci/lx6464es/lx6464es.c
@@ -971,7 +971,7 @@ static int __devinit snd_lx6464es_create(struct snd_card *card,
 	struct lx6464es *chip;
 	int err;
 
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_lx6464es_dev_free,
 	};
 
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 0378126..7931f07 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2602,7 +2602,7 @@ snd_m3_create(struct snd_card *card, struct pci_dev *pci,
 	struct snd_m3 *chip;
 	int i, err;
 	const struct snd_pci_quirk *quirk;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_m3_dev_free,
 	};
 
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index dbee599..613fd03 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1008,7 +1008,7 @@ static int __devinit snd_mixart_create(struct mixart_mgr *mgr, struct snd_card *
 {
 	int err;
 	struct snd_mixart *chip;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_mixart_chip_dev_free,
 	};
 
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index 83ea7a7..f49969c 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -1471,7 +1471,7 @@ snd_nm256_create(struct snd_card *card, struct pci_dev *pci,
 {
 	struct nm256 *chip;
 	int err, pval;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_nm256_dev_free,
 	};
 	u32 addr;
diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index 046578d..092048e 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -1184,7 +1184,7 @@ static int __devinit pcxhr_create(struct pcxhr_mgr *mgr,
 {
 	int err;
 	struct snd_pcxhr *chip;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = pcxhr_chip_dev_free,
 	};
 
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index e34ae14..530a589 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -1857,7 +1857,7 @@ snd_riptide_create(struct snd_card *card, struct pci_dev *pci,
 	struct snd_riptide *chip;
 	struct riptideport *hwport;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = snd_riptide_dev_free,
 	};
 
diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
index bcf6152..e47da32 100644
--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -1293,7 +1293,7 @@ static int __devinit sis_chip_create(struct snd_card *card,
 {
 	struct sis7019 *sis = card->private_data;
 	struct voice *voice;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free = sis_dev_free,
 	};
 	int rc;
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index 2571a67..e8d51c4 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -1255,7 +1255,7 @@ static int __devinit snd_sonicvibes_create(struct snd_card *card,
 	struct sonicvibes *sonic;
 	unsigned int dmaa, dmac;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_sonicvibes_dev_free,
 	};
 
diff --git a/sound/pci/trident/trident_main.c b/sound/pci/trident/trident_main.c
index 5bd57a7..2e949e0 100644
--- a/sound/pci/trident/trident_main.c
+++ b/sound/pci/trident/trident_main.c
@@ -3549,7 +3549,7 @@ int __devinit snd_trident_create(struct snd_card *card,
 	int i, err;
 	struct snd_trident_voice *voice;
 	struct snd_trident_pcm_mixer *tmix;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_trident_dev_free,
 	};
 
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index f03fd62..1a190e2 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2340,7 +2340,7 @@ static int __devinit snd_via82xx_create(struct snd_card *card,
 {
 	struct via82xx *chip;
 	int err;
-        static struct snd_device_ops ops = {
+        static const struct snd_device_ops ops = {
 		.dev_free =	snd_via82xx_dev_free,
         };
 
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index a386dd9..a6191e1 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -1105,7 +1105,7 @@ static int __devinit snd_via82xx_create(struct snd_card *card,
 {
 	struct via82xx_modem *chip;
 	int err;
-        static struct snd_device_ops ops = {
+        static const struct snd_device_ops ops = {
 		.dev_free =	snd_via82xx_dev_free,
         };
 
diff --git a/sound/pci/vx222/vx222.c b/sound/pci/vx222/vx222.c
index 5342d5e..5980ade 100644
--- a/sound/pci/vx222/vx222.c
+++ b/sound/pci/vx222/vx222.c
@@ -141,7 +141,7 @@ static int __devinit snd_vx222_create(struct snd_card *card, struct pci_dev *pci
 	struct vx_core *chip;
 	struct snd_vx222 *vx;
 	int i, err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_vx222_dev_free,
 	};
 	struct snd_vx_ops *vx_ops;
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index f3260e6..ec962ca 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -2344,7 +2344,7 @@ int __devinit snd_ymfpci_create(struct snd_card *card,
 {
 	struct snd_ymfpci *chip;
 	int err;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_ymfpci_dev_free,
 	};
 	
diff --git a/sound/pcmcia/pdaudiocf/pdaudiocf.c b/sound/pcmcia/pdaudiocf/pdaudiocf.c
index 66488a7..9e9a54a 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf.c
@@ -94,7 +94,7 @@ static int snd_pdacf_probe(struct pcmcia_device *link)
 	int i, err;
 	struct snd_pdacf *pdacf;
 	struct snd_card *card;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_pdacf_dev_free,
 	};
 
diff --git a/sound/pcmcia/vx/vxpocket.c b/sound/pcmcia/vx/vxpocket.c
index 31777d1..4bcbe10 100644
--- a/sound/pcmcia/vx/vxpocket.c
+++ b/sound/pcmcia/vx/vxpocket.c
@@ -137,7 +137,7 @@ static int snd_vxpocket_new(struct snd_card *card, int ibl,
 {
 	struct vx_core *chip;
 	struct snd_vxpocket *vxp;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_vxpocket_dev_free,
 	};
 	int err;
diff --git a/sound/ppc/pmac.c b/sound/ppc/pmac.c
index 3ecbd67..e60e9d6 100644
--- a/sound/ppc/pmac.c
+++ b/sound/ppc/pmac.c
@@ -1186,7 +1186,7 @@ int __devinit snd_pmac_new(struct snd_card *card, struct snd_pmac **chip_return)
 	int i, err;
 	unsigned int irq;
 	unsigned long ctrl_addr, txdma_addr, rxdma_addr;
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_pmac_dev_free,
 	};
 
diff --git a/sound/sh/sh_dac_audio.c b/sound/sh/sh_dac_audio.c
index 68e0dee..de87368 100644
--- a/sound/sh/sh_dac_audio.c
+++ b/sound/sh/sh_dac_audio.c
@@ -352,7 +352,7 @@ static int __devinit snd_sh_dac_create(struct snd_card *card,
 	struct snd_sh_dac *chip;
 	int err;
 
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		   .dev_free = snd_sh_dac_dev_free,
 	};
 
diff --git a/sound/sparc/amd7930.c b/sound/sparc/amd7930.c
index ad7d4d7..3160ef7 100644
--- a/sound/sparc/amd7930.c
+++ b/sound/sparc/amd7930.c
@@ -929,7 +929,7 @@ static int snd_amd7930_dev_free(struct snd_device *device)
 	return snd_amd7930_free(amd);
 }
 
-static struct snd_device_ops snd_amd7930_dev_ops = {
+static const struct snd_device_ops snd_amd7930_dev_ops = {
 	.dev_free	=	snd_amd7930_dev_free,
 };
 
diff --git a/sound/sparc/cs4231.c b/sound/sparc/cs4231.c
index 0e618f8..feb1610 100644
--- a/sound/sparc/cs4231.c
+++ b/sound/sparc/cs4231.c
@@ -1789,7 +1789,7 @@ static int snd_cs4231_sbus_dev_free(struct snd_device *device)
 	return snd_cs4231_sbus_free(cp);
 }
 
-static struct snd_device_ops snd_cs4231_sbus_dev_ops = {
+static const struct snd_device_ops snd_cs4231_sbus_dev_ops = {
 	.dev_free	=	snd_cs4231_sbus_dev_free,
 };
 
@@ -1955,7 +1955,7 @@ static int snd_cs4231_ebus_dev_free(struct snd_device *device)
 	return snd_cs4231_ebus_free(cp);
 }
 
-static struct snd_device_ops snd_cs4231_ebus_dev_ops = {
+static const struct snd_device_ops snd_cs4231_ebus_dev_ops = {
 	.dev_free	=	snd_cs4231_ebus_dev_free,
 };
 
diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index 4dd051b..f8fda21 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -882,7 +882,7 @@ static int snd_at73c213_dev_free(struct snd_device *device)
 static int __devinit snd_at73c213_dev_init(struct snd_card *card,
 					 struct spi_device *spi)
 {
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free	= snd_at73c213_dev_free,
 	};
 	struct snd_at73c213 *chip = get_chip(card);
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 781d9e6..928726c 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -306,7 +306,7 @@ static int snd_usb_audio_create(struct usb_device *dev, int idx,
 	struct snd_usb_audio *chip;
 	int err, len;
 	char component[14];
-	static struct snd_device_ops ops = {
+	static const struct snd_device_ops ops = {
 		.dev_free =	snd_usb_audio_dev_free,
 	};
 
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index c22fa76..99a6a30 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2197,7 +2197,7 @@ static int snd_usb_mixer_status_create(struct usb_mixer_interface *mixer)
 int snd_usb_create_mixer(struct snd_usb_audio *chip, int ctrlif,
 			 int ignore_error)
 {
-	static struct snd_device_ops dev_ops = {
+	static const struct snd_device_ops dev_ops = {
 		.dev_free = snd_usb_mixer_dev_free
 	};
 	struct usb_mixer_interface *mixer;
-- 
1.7.6.345.g5c2f8

