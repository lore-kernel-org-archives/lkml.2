Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1CKKiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 05:38:01 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:33774 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1CKKh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 05:37:59 -0500
Subject: [PATCH] intel8x0m: add 'm' as "suffix" to static functions
From: Paul Bolle <pebolle@tiscali.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Fri, 11 Mar 2011 11:37:55 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.91 (2.91.91-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1299839878.12153.8.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding an 'm' will distinguish them from identical names in intel8x0.c.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 sound/pci/intel8x0m.c |   98 ++++++++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 9abff7b..e16b3e9 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -341,9 +341,9 @@ static int snd_intel8x0m_codec_semaphore(struct intel8x0m *chip, unsigned int co
 	return -EBUSY;
 }
  
-static void snd_intel8x0_codec_write(struct snd_ac97 *ac97,
-				     unsigned short reg,
-				     unsigned short val)
+static void snd_intel8x0m_codec_write(struct snd_ac97 *ac97,
+				      unsigned short reg,
+				      unsigned short val)
 {
 	struct intel8x0m *chip = ac97->private_data;
 	
@@ -354,8 +354,8 @@ static void snd_intel8x0_codec_write(struct snd_ac97 *ac97,
 	iaputword(chip, reg + ac97->num * 0x80, val);
 }
 
-static unsigned short snd_intel8x0_codec_read(struct snd_ac97 *ac97,
-					      unsigned short reg)
+static unsigned short snd_intel8x0m_codec_read(struct snd_ac97 *ac97,
+					       unsigned short reg)
 {
 	struct intel8x0m *chip = ac97->private_data;
 	unsigned short res;
@@ -385,7 +385,7 @@ static unsigned short snd_intel8x0_codec_read(struct snd_ac97 *ac97,
 /*
  * DMA I/O
  */
-static void snd_intel8x0_setup_periods(struct intel8x0m *chip, struct ichdev *ichdev) 
+static void snd_intel8x0m_setup_periods(struct intel8x0m *chip, struct ichdev *ichdev)
 {
 	int idx;
 	u32 *bdbar = ichdev->bdbar;
@@ -437,7 +437,7 @@ static void snd_intel8x0_setup_periods(struct intel8x0m *chip, struct ichdev *ic
  *  Interrupt handler
  */
 
-static inline void snd_intel8x0_update(struct intel8x0m *chip, struct ichdev *ichdev)
+static inline void snd_intel8x0m_update(struct intel8x0m *chip, struct ichdev *ichdev)
 {
 	unsigned long port = ichdev->reg_offset;
 	int civ, i, step;
@@ -489,7 +489,7 @@ static inline void snd_intel8x0_update(struct intel8x0m *chip, struct ichdev *ic
 	iputbyte(chip, port + ichdev->roff_sr, ICH_FIFOE | ICH_BCIS | ICH_LVBCI);
 }
 
-static irqreturn_t snd_intel8x0_interrupt(int irq, void *dev_id)
+static irqreturn_t snd_intel8x0m_interrupt(int irq, void *dev_id)
 {
 	struct intel8x0m *chip = dev_id;
 	struct ichdev *ichdev;
@@ -512,7 +512,7 @@ static irqreturn_t snd_intel8x0_interrupt(int irq, void *dev_id)
 	for (i = 0; i < chip->bdbars_count; i++) {
 		ichdev = &chip->ichd[i];
 		if (status & ichdev->int_sta_mask)
-			snd_intel8x0_update(chip, ichdev);
+			snd_intel8x0m_update(chip, ichdev);
 	}
 
 	/* ack them */
@@ -526,7 +526,7 @@ static irqreturn_t snd_intel8x0_interrupt(int irq, void *dev_id)
  *  PCM part
  */
 
-static int snd_intel8x0_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+static int snd_intel8x0m_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 {
 	struct intel8x0m *chip = snd_pcm_substream_chip(substream);
 	struct ichdev *ichdev = get_ichdev(substream);
@@ -561,18 +561,18 @@ static int snd_intel8x0_pcm_trigger(struct snd_pcm_substream *substream, int cmd
 	return 0;
 }
 
-static int snd_intel8x0_hw_params(struct snd_pcm_substream *substream,
+static int snd_intel8x0m_hw_params(struct snd_pcm_substream *substream,
 				  struct snd_pcm_hw_params *hw_params)
 {
 	return snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(hw_params));
 }
 
-static int snd_intel8x0_hw_free(struct snd_pcm_substream *substream)
+static int snd_intel8x0m_hw_free(struct snd_pcm_substream *substream)
 {
 	return snd_pcm_lib_free_pages(substream);
 }
 
-static snd_pcm_uframes_t snd_intel8x0_pcm_pointer(struct snd_pcm_substream *substream)
+static snd_pcm_uframes_t snd_intel8x0m_pcm_pointer(struct snd_pcm_substream *substream)
 {
 	struct intel8x0m *chip = snd_pcm_substream_chip(substream);
 	struct ichdev *ichdev = get_ichdev(substream);
@@ -600,7 +600,7 @@ static int snd_intel8x0m_pcm_prepare(struct snd_pcm_substream *substream)
 	ichdev->fragsize = snd_pcm_lib_period_bytes(substream);
 	snd_ac97_write(ichdev->ac97, AC97_LINE1_RATE, runtime->rate);
 	snd_ac97_write(ichdev->ac97, AC97_LINE1_LEVEL, 0);
-	snd_intel8x0_setup_periods(chip, ichdev);
+	snd_intel8x0m_setup_periods(chip, ichdev);
 	return 0;
 }
 
@@ -682,22 +682,22 @@ static struct snd_pcm_ops snd_intel8x0m_playback_ops = {
 	.open =		snd_intel8x0m_playback_open,
 	.close =	snd_intel8x0m_playback_close,
 	.ioctl =	snd_pcm_lib_ioctl,
-	.hw_params =	snd_intel8x0_hw_params,
-	.hw_free =	snd_intel8x0_hw_free,
+	.hw_params =	snd_intel8x0m_hw_params,
+	.hw_free =	snd_intel8x0m_hw_free,
 	.prepare =	snd_intel8x0m_pcm_prepare,
-	.trigger =	snd_intel8x0_pcm_trigger,
-	.pointer =	snd_intel8x0_pcm_pointer,
+	.trigger =	snd_intel8x0m_pcm_trigger,
+	.pointer =	snd_intel8x0m_pcm_pointer,
 };
 
 static struct snd_pcm_ops snd_intel8x0m_capture_ops = {
 	.open =		snd_intel8x0m_capture_open,
 	.close =	snd_intel8x0m_capture_close,
 	.ioctl =	snd_pcm_lib_ioctl,
-	.hw_params =	snd_intel8x0_hw_params,
-	.hw_free =	snd_intel8x0_hw_free,
+	.hw_params =	snd_intel8x0m_hw_params,
+	.hw_free =	snd_intel8x0m_hw_free,
 	.prepare =	snd_intel8x0m_pcm_prepare,
-	.trigger =	snd_intel8x0_pcm_trigger,
-	.pointer =	snd_intel8x0_pcm_pointer,
+	.trigger =	snd_intel8x0m_pcm_trigger,
+	.pointer =	snd_intel8x0m_pcm_pointer,
 };
 

@@ -710,7 +710,7 @@ struct ich_pcm_table {
 	int ac97_idx;
 };
 
-static int __devinit snd_intel8x0_pcm1(struct intel8x0m *chip, int device,
+static int __devinit snd_intel8x0m_pcm1(struct intel8x0m *chip, int device,
 				       struct ich_pcm_table *rec)
 {
 	struct snd_pcm *pcm;
@@ -759,7 +759,7 @@ static struct ich_pcm_table intel_pcms[] __devinitdata = {
 	},
 };
 
-static int __devinit snd_intel8x0_pcm(struct intel8x0m *chip)
+static int __devinit snd_intel8x0m_pcm(struct intel8x0m *chip)
 {
 	int i, tblsize, device, err;
 	struct ich_pcm_table *tbl, *rec;
@@ -791,7 +791,7 @@ static int __devinit snd_intel8x0_pcm(struct intel8x0m *chip)
 			if (! chip->ichd[rec->ac97_idx].ac97)
 				continue;
 		}
-		err = snd_intel8x0_pcm1(chip, device, rec);
+		err = snd_intel8x0m_pcm1(chip, device, rec);
 		if (err < 0)
 			return err;
 		device++;
@@ -806,20 +806,20 @@ static int __devinit snd_intel8x0_pcm(struct intel8x0m *chip)
  *  Mixer part
  */
 
-static void snd_intel8x0_mixer_free_ac97_bus(struct snd_ac97_bus *bus)
+static void snd_intel8x0m_mixer_free_ac97_bus(struct snd_ac97_bus *bus)
 {
 	struct intel8x0m *chip = bus->private_data;
 	chip->ac97_bus = NULL;
 }
 
-static void snd_intel8x0_mixer_free_ac97(struct snd_ac97 *ac97)
+static void snd_intel8x0m_mixer_free_ac97(struct snd_ac97 *ac97)
 {
 	struct intel8x0m *chip = ac97->private_data;
 	chip->ac97 = NULL;
 }
 

-static int __devinit snd_intel8x0_mixer(struct intel8x0m *chip, int ac97_clock)
+static int __devinit snd_intel8x0m_mixer(struct intel8x0m *chip, int ac97_clock)
 {
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
@@ -827,22 +827,22 @@ static int __devinit snd_intel8x0_mixer(struct intel8x0m *chip, int ac97_clock)
 	int err;
 	unsigned int glob_sta = 0;
 	static struct snd_ac97_bus_ops ops = {
-		.write = snd_intel8x0_codec_write,
-		.read = snd_intel8x0_codec_read,
+		.write = snd_intel8x0m_codec_write,
+		.read = snd_intel8x0m_codec_read,
 	};
 
 	chip->in_ac97_init = 1;
 	
 	memset(&ac97, 0, sizeof(ac97));
 	ac97.private_data = chip;
-	ac97.private_free = snd_intel8x0_mixer_free_ac97;
+	ac97.private_free = snd_intel8x0m_mixer_free_ac97;
 	ac97.scaps = AC97_SCAP_SKIP_AUDIO | AC97_SCAP_POWER_SAVE;
 
 	glob_sta = igetdword(chip, ICHREG(GLOB_STA));
 
 	if ((err = snd_ac97_bus(chip->card, 0, &ops, chip, &pbus)) < 0)
 		goto __err;
-	pbus->private_free = snd_intel8x0_mixer_free_ac97_bus;
+	pbus->private_free = snd_intel8x0m_mixer_free_ac97_bus;
 	if (ac97_clock >= 8000 && ac97_clock <= 48000)
 		pbus->clock = ac97_clock;
 	chip->ac97_bus = pbus;
@@ -959,7 +959,7 @@ static int snd_intel8x0m_ich_chip_init(struct intel8x0m *chip, int probing)
       	return 0;
 }
 
-static int snd_intel8x0_chip_init(struct intel8x0m *chip, int probing)
+static int snd_intel8x0m_chip_init(struct intel8x0m *chip, int probing)
 {
 	unsigned int i;
 	int err;
@@ -980,7 +980,7 @@ static int snd_intel8x0_chip_init(struct intel8x0m *chip, int probing)
 	return 0;
 }
 
-static int snd_intel8x0_free(struct intel8x0m *chip)
+static int snd_intel8x0m_free(struct intel8x0m *chip)
 {
 	unsigned int i;
 
@@ -1045,7 +1045,7 @@ static int intel8x0m_resume(struct pci_dev *pci)
 		return -EIO;
 	}
 	pci_set_master(pci);
-	if (request_irq(pci->irq, snd_intel8x0_interrupt,
+	if (request_irq(pci->irq, snd_intel8x0m_interrupt,
 			IRQF_SHARED, card->shortname, chip)) {
 		printk(KERN_ERR "intel8x0m: unable to grab IRQ %d, "
 		       "disabling device\n", pci->irq);
@@ -1053,7 +1053,7 @@ static int intel8x0m_resume(struct pci_dev *pci)
 		return -EIO;
 	}
 	chip->irq = pci->irq;
-	snd_intel8x0_chip_init(chip, 0);
+	snd_intel8x0m_chip_init(chip, 0);
 	snd_ac97_resume(chip->ac97);
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
@@ -1094,10 +1094,10 @@ static void __devinit snd_intel8x0m_proc_init(struct intel8x0m * chip)
 #endif /* CONFIG_PROC_FS */
 

-static int snd_intel8x0_dev_free(struct snd_device *device)
+static int snd_intel8x0m_dev_free(struct snd_device *device)
 {
 	struct intel8x0m *chip = device->device_data;
-	return snd_intel8x0_free(chip);
+	return snd_intel8x0m_free(chip);
 }
 
 struct ich_reg_info {
@@ -1116,7 +1116,7 @@ static int __devinit snd_intel8x0m_create(struct snd_card *card,
 	unsigned int int_sta_masks;
 	struct ichdev *ichdev;
 	static struct snd_device_ops ops = {
-		.dev_free =	snd_intel8x0_dev_free,
+		.dev_free =	snd_intel8x0m_dev_free,
 	};
 	static struct ich_reg_info intel_regs[2] = {
 		{ ICH_MIINT, 0 },
@@ -1158,7 +1158,7 @@ static int __devinit snd_intel8x0m_create(struct snd_card *card,
 		chip->addr = pci_iomap(pci, 0, 0);
 	if (!chip->addr) {
 		snd_printk(KERN_ERR "AC'97 space ioremap problem\n");
-		snd_intel8x0_free(chip);
+		snd_intel8x0m_free(chip);
 		return -EIO;
 	}
 	if (pci_resource_flags(pci, 3) & IORESOURCE_MEM) /* ICH4 */
@@ -1167,15 +1167,15 @@ static int __devinit snd_intel8x0m_create(struct snd_card *card,
 		chip->bmaddr = pci_iomap(pci, 1, 0);
 	if (!chip->bmaddr) {
 		snd_printk(KERN_ERR "Controller space ioremap problem\n");
-		snd_intel8x0_free(chip);
+		snd_intel8x0m_free(chip);
 		return -EIO;
 	}
 
  port_inited:
-	if (request_irq(pci->irq, snd_intel8x0_interrupt, IRQF_SHARED,
+	if (request_irq(pci->irq, snd_intel8x0m_interrupt, IRQF_SHARED,
 			card->shortname, chip)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
-		snd_intel8x0_free(chip);
+		snd_intel8x0m_free(chip);
 		return -EBUSY;
 	}
 	chip->irq = pci->irq;
@@ -1210,7 +1210,7 @@ static int __devinit snd_intel8x0m_create(struct snd_card *card,
 	if (snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV, snd_dma_pci_data(pci),
 				chip->bdbars_count * sizeof(u32) * ICH_MAX_FRAGS * 2,
 				&chip->bdbars) < 0) {
-		snd_intel8x0_free(chip);
+		snd_intel8x0m_free(chip);
 		return -ENOMEM;
 	}
 	/* tables must be aligned to 8 bytes here, but the kernel pages
@@ -1225,13 +1225,13 @@ static int __devinit snd_intel8x0m_create(struct snd_card *card,
 	chip->int_sta_reg = ICH_REG_GLOB_STA;
 	chip->int_sta_mask = int_sta_masks;
 
-	if ((err = snd_intel8x0_chip_init(chip, 1)) < 0) {
-		snd_intel8x0_free(chip);
+	if ((err = snd_intel8x0m_chip_init(chip, 1)) < 0) {
+		snd_intel8x0m_free(chip);
 		return err;
 	}
 
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
-		snd_intel8x0_free(chip);
+		snd_intel8x0m_free(chip);
 		return err;
 	}
 
@@ -1295,11 +1295,11 @@ static int __devinit snd_intel8x0m_probe(struct pci_dev *pci,
 	}
 	card->private_data = chip;
 
-	if ((err = snd_intel8x0_mixer(chip, ac97_clock)) < 0) {
+	if ((err = snd_intel8x0m_mixer(chip, ac97_clock)) < 0) {
 		snd_card_free(card);
 		return err;
 	}
-	if ((err = snd_intel8x0_pcm(chip)) < 0) {
+	if ((err = snd_intel8x0m_pcm(chip)) < 0) {
 		snd_card_free(card);
 		return err;
 	}
-- 
1.7.4.1




