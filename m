Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1BKMi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:38:26 -0500
Received: from ni.piap.pl ([195.187.100.4]:40292 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab1BKMiW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:38:22 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ben Collins <bcollins@bluecherry.net>, linux-kernel@vger.kernel.org
References: <m3sjvurd2f.fsf@t19.piap.pl>
Date: Fri, 11 Feb 2011 13:38:20 +0100
In-Reply-To: <m3sjvurd2f.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 11 Feb 2011 13:05:44 +0100")
MIME-Version: 1.0
Message-ID: <m3vd0qpwzn.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 7/7] Solo6x10: Changed solo6010* -> solo*, solo6x10* etc.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20101209 #4187514, check: 20110211 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/solo6x10/core.c b/drivers/staging/solo6x10/core.c
index 37e6fda..7677994 100644
--- a/drivers/staging/solo6x10/core.c
+++ b/drivers/staging/solo6x10/core.c
@@ -25,27 +25,27 @@
 #include "solo6x10.h"
 #include "tw28.h"
 
-MODULE_DESCRIPTION("Softlogic 6010 MP4 Encoder/Decoder V4L2/ALSA Driver");
+MODULE_DESCRIPTION("Softlogic 6x10 MP4/H.264 Encoder/Decoder V4L2/ALSA Driver");
 MODULE_AUTHOR("Ben Collins <bcollins@bluecherry.net>");
-MODULE_VERSION(SOLO6010_VERSION);
+MODULE_VERSION(SOLO6X10_VERSION);
 MODULE_LICENSE("GPL");
 
-void solo6010_irq_on(struct solo6010_dev *solo_dev, u32 mask)
+void solo_irq_on(struct solo_dev *solo_dev, u32 mask)
 {
 	solo_dev->irq_mask |= mask;
 	solo_reg_write(solo_dev, SOLO_IRQ_ENABLE, solo_dev->irq_mask);
 }
 
-void solo6010_irq_off(struct solo6010_dev *solo_dev, u32 mask)
+void solo_irq_off(struct solo_dev *solo_dev, u32 mask)
 {
 	solo_dev->irq_mask &= ~mask;
 	solo_reg_write(solo_dev, SOLO_IRQ_ENABLE, solo_dev->irq_mask);
 }
 
 /* XXX We should check the return value of the sub-device ISR's */
-static irqreturn_t solo6010_isr(int irq, void *data)
+static irqreturn_t solo_isr(int irq, void *data)
 {
-	struct solo6010_dev *solo_dev = data;
+	struct solo_dev *solo_dev = data;
 	u32 status;
 	int i;
 
@@ -88,7 +88,7 @@ static irqreturn_t solo6010_isr(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void free_solo_dev(struct solo6010_dev *solo_dev)
+static void free_solo_dev(struct solo_dev *solo_dev)
 {
 	struct pci_dev *pdev;
 
@@ -116,7 +116,7 @@ static void free_solo_dev(struct solo6010_dev *solo_dev)
 
 	/* Now cleanup the PCI device */
 	if (solo_dev->reg_base) {
-		solo6010_irq_off(solo_dev, ~0);
+		solo_irq_off(solo_dev, ~0);
 		pci_iounmap(pdev, solo_dev->reg_base);
 		free_irq(pdev->irq, solo_dev);
 	}
@@ -128,10 +128,10 @@ static void free_solo_dev(struct solo6010_dev *solo_dev)
 	kfree(solo_dev);
 }
 
-static int __devinit solo6010_pci_probe(struct pci_dev *pdev,
-					const struct pci_device_id *id)
+static int __devinit solo_pci_probe(struct pci_dev *pdev,
+				    const struct pci_device_id *id)
 {
-	struct solo6010_dev *solo_dev;
+	struct solo_dev *solo_dev;
 	int ret;
 	int sdram;
 	u8 chip_id;
@@ -151,7 +151,7 @@ static int __devinit solo6010_pci_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	ret = pci_request_regions(pdev, SOLO6010_NAME);
+	ret = pci_request_regions(pdev, SOLO6X10_NAME);
 	if (ret)
 		goto fail_probe;
 
@@ -184,7 +184,7 @@ static int __devinit solo6010_pci_probe(struct pci_dev *pdev,
 	solo_dev->flags = id->driver_data;
 
 	/* Disable all interrupts to start */
-	solo6010_irq_off(solo_dev, ~0);
+	solo_irq_off(solo_dev, ~0);
 
 	reg = SOLO_SYS_CFG_SDRAM64BIT;
 	/* Initial global settings */
@@ -223,13 +223,13 @@ static int __devinit solo6010_pci_probe(struct pci_dev *pdev,
 	/* PLL locking time of 1ms */
 	mdelay(1);
 
-	ret = request_irq(pdev->irq, solo6010_isr, IRQF_SHARED, SOLO6010_NAME,
+	ret = request_irq(pdev->irq, solo_isr, IRQF_SHARED, SOLO6X10_NAME,
 			  solo_dev);
 	if (ret)
 		goto fail_probe;
 
 	/* Handle this from the start */
-	solo6010_irq_on(solo_dev, SOLO_IRQ_PCI_ERR);
+	solo_irq_on(solo_dev, SOLO_IRQ_PCI_ERR);
 
 	ret = solo_i2c_init(solo_dev);
 	if (ret)
@@ -283,14 +283,14 @@ fail_probe:
 	return ret;
 }
 
-static void __devexit solo6010_pci_remove(struct pci_dev *pdev)
+static void __devexit solo_pci_remove(struct pci_dev *pdev)
 {
-	struct solo6010_dev *solo_dev = pci_get_drvdata(pdev);
+	struct solo_dev *solo_dev = pci_get_drvdata(pdev);
 
 	free_solo_dev(solo_dev);
 }
 
-static struct pci_device_id solo6010_id_table[] = {
+static struct pci_device_id solo_id_table[] = {
 	/* 6010 based cards */
 	{PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6010)},
 	{PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6110),
@@ -308,24 +308,24 @@ static struct pci_device_id solo6010_id_table[] = {
 	{0,}
 };
 
-MODULE_DEVICE_TABLE(pci, solo6010_id_table);
+MODULE_DEVICE_TABLE(pci, solo_id_table);
 
-static struct pci_driver solo6010_pci_driver = {
-	.name = SOLO6010_NAME,
-	.id_table = solo6010_id_table,
-	.probe = solo6010_pci_probe,
-	.remove = solo6010_pci_remove,
+static struct pci_driver solo_pci_driver = {
+	.name = SOLO6X10_NAME,
+	.id_table = solo_id_table,
+	.probe = solo_pci_probe,
+	.remove = solo_pci_remove,
 };
 
-static int __init solo6010_module_init(void)
+static int __init solo_module_init(void)
 {
-	return pci_register_driver(&solo6010_pci_driver);
+	return pci_register_driver(&solo_pci_driver);
 }
 
-static void __exit solo6010_module_exit(void)
+static void __exit solo_module_exit(void)
 {
-	pci_unregister_driver(&solo6010_pci_driver);
+	pci_unregister_driver(&solo_pci_driver);
 }
 
-module_init(solo6010_module_init);
-module_exit(solo6010_module_exit);
+module_init(solo_module_init);
+module_exit(solo_module_exit);
diff --git a/drivers/staging/solo6x10/disp.c b/drivers/staging/solo6x10/disp.c
index 1b0cfa8..884c0eb 100644
--- a/drivers/staging/solo6x10/disp.c
+++ b/drivers/staging/solo6x10/disp.c
@@ -37,7 +37,7 @@ static unsigned video_type;
 module_param(video_type, uint, 0644);
 MODULE_PARM_DESC(video_type, "video_type (0 = NTSC/Default, 1 = PAL)");
 
-static void solo_vin_config(struct solo6010_dev *solo_dev)
+static void solo_vin_config(struct solo_dev *solo_dev)
 {
 	solo_dev->vin_hstart = 8;
 	solo_dev->vin_vstart = 2;
@@ -97,7 +97,7 @@ static void solo_vin_config(struct solo6010_dev *solo_dev)
 		       SOLO_VI_PB_HSTOP(16 + 720));
 }
 
-static void solo_disp_config(struct solo6010_dev *solo_dev)
+static void solo_disp_config(struct solo_dev *solo_dev)
 {
 	solo_dev->vout_hstart = 6;
 	solo_dev->vout_vstart = 8;
@@ -145,7 +145,7 @@ static void solo_disp_config(struct solo6010_dev *solo_dev)
 	solo_reg_write(solo_dev, SOLO_WATCHDOG, 0);
 }
 
-static int solo_dma_vin_region(struct solo6010_dev *solo_dev, u32 off,
+static int solo_dma_vin_region(struct solo_dev *solo_dev, u32 off,
 			       u16 val, int reg_size)
 {
 	u16 buf[64];
@@ -163,7 +163,7 @@ static int solo_dma_vin_region(struct solo6010_dev *solo_dev, u32 off,
 	return ret;
 }
 
-void solo_set_motion_threshold(struct solo6010_dev *solo_dev, u8 ch, u16 val)
+void solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val)
 {
 	if (ch > solo_dev->nr_chans)
 		return;
@@ -177,7 +177,7 @@ void solo_set_motion_threshold(struct solo6010_dev *solo_dev, u8 ch, u16 val)
  * threshold and working table for each channel. Atleast that's what the
  * spec says. However, this code (take from rdk) has some mystery 8k
  * block right after the flag area, before the first thresh table. */
-static void solo_motion_config(struct solo6010_dev *solo_dev)
+static void solo_motion_config(struct solo_dev *solo_dev)
 {
 	int i;
 
@@ -209,7 +209,7 @@ static void solo_motion_config(struct solo6010_dev *solo_dev)
 	solo_reg_write(solo_dev, SOLO_VI_MOTION_BAR, 0);
 }
 
-int solo_disp_init(struct solo6010_dev *solo_dev)
+int solo_disp_init(struct solo_dev *solo_dev)
 {
 	int i;
 
@@ -234,11 +234,11 @@ int solo_disp_init(struct solo6010_dev *solo_dev)
 	return 0;
 }
 
-void solo_disp_exit(struct solo6010_dev *solo_dev)
+void solo_disp_exit(struct solo_dev *solo_dev)
 {
 	int i;
 
-	solo6010_irq_off(solo_dev, SOLO_IRQ_MOTION);
+	solo_irq_off(solo_dev, SOLO_IRQ_MOTION);
 
 	solo_reg_write(solo_dev, SOLO_VO_DISP_CTRL, 0);
 	solo_reg_write(solo_dev, SOLO_VO_ZOOM_CTRL, 0);
diff --git a/drivers/staging/solo6x10/enc.c b/drivers/staging/solo6x10/enc.c
index 755626c..285f7f3 100644
--- a/drivers/staging/solo6x10/enc.c
+++ b/drivers/staging/solo6x10/enc.c
@@ -27,7 +27,7 @@
 #define VI_PROG_HSIZE			(1280 - 16)
 #define VI_PROG_VSIZE			(1024 - 16)
 
-static void solo_capture_config(struct solo6010_dev *solo_dev)
+static void solo_capture_config(struct solo_dev *solo_dev)
 {
 	int i, j;
 	unsigned long height;
@@ -115,7 +115,7 @@ static void solo_capture_config(struct solo6010_dev *solo_dev)
 
 int solo_osd_print(struct solo_enc_dev *solo_enc)
 {
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	char *str = solo_enc->osd_text;
 	u8 *buf;
 	u32 reg = solo_reg_read(solo_dev, SOLO_VE_OSD_CH);
@@ -151,7 +151,7 @@ int solo_osd_print(struct solo_enc_dev *solo_enc)
 	return 0;
 }
 
-static void solo_jpeg_config(struct solo6010_dev *solo_dev)
+static void solo_jpeg_config(struct solo_dev *solo_dev)
 {
 	u32 reg;
 	if (solo_dev->flags & FLAGS_6110)
@@ -169,7 +169,7 @@ static void solo_jpeg_config(struct solo6010_dev *solo_dev)
 	solo_reg_write(solo_dev, 0x0688, (0 << 16) | (30 << 8) | 60);
 }
 
-static void solo_mp4e_config(struct solo6010_dev *solo_dev)
+static void solo_mp4e_config(struct solo_dev *solo_dev)
 {
 	int i;
 	u32 reg;
@@ -206,7 +206,7 @@ static void solo_mp4e_config(struct solo6010_dev *solo_dev)
 		solo_reg_write(solo_dev, 0x0634, 0x00040008); /* ? */
 }
 
-int solo_enc_init(struct solo6010_dev *solo_dev)
+int solo_enc_init(struct solo_dev *solo_dev)
 {
 	int i;
 
@@ -219,16 +219,16 @@ int solo_enc_init(struct solo6010_dev *solo_dev)
 		solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(i), 0);
 	}
 
-	solo6010_irq_on(solo_dev, SOLO_IRQ_ENCODER);
+	solo_irq_on(solo_dev, SOLO_IRQ_ENCODER);
 
 	return 0;
 }
 
-void solo_enc_exit(struct solo6010_dev *solo_dev)
+void solo_enc_exit(struct solo_dev *solo_dev)
 {
 	int i;
 
-	solo6010_irq_off(solo_dev, SOLO_IRQ_ENCODER);
+	solo_irq_off(solo_dev, SOLO_IRQ_ENCODER);
 
 	for (i = 0; i < solo_dev->nr_chans; i++) {
 		solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(i), 0);
diff --git a/drivers/staging/solo6x10/g723.c b/drivers/staging/solo6x10/g723.c
index 4aba8f3..bd8eb92 100644
--- a/drivers/staging/solo6x10/g723.c
+++ b/drivers/staging/solo6x10/g723.c
@@ -50,13 +50,13 @@
 #define PERIODS_MAX		G723_FDMA_PAGES
 
 struct solo_snd_pcm {
-	int				on;
-	spinlock_t			lock;
-	struct solo6010_dev		*solo_dev;
-	unsigned char			g723_buf[G723_PERIOD_BYTES];
+	int		on;
+	spinlock_t	lock;
+	struct solo_dev	*solo_dev;
+	unsigned char	g723_buf[G723_PERIOD_BYTES];
 };
 
-static void solo_g723_config(struct solo6010_dev *solo_dev)
+static void solo_g723_config(struct solo_dev *solo_dev)
 {
 	int clk_div;
 
@@ -76,7 +76,7 @@ static void solo_g723_config(struct solo6010_dev *solo_dev)
 		       SOLO_AUDIO_I2S_MULTI(3) | SOLO_AUDIO_MODE(OUTMODE_MASK));
 }
 
-void solo_g723_isr(struct solo6010_dev *solo_dev)
+void solo_g723_isr(struct solo_dev *solo_dev)
 {
 	struct snd_pcm_str *pstr =
 		&solo_dev->snd_pcm->streams[SNDRV_PCM_STREAM_CAPTURE];
@@ -133,7 +133,7 @@ static struct snd_pcm_hardware snd_solo_pcm_hw = {
 
 static int snd_solo_pcm_open(struct snd_pcm_substream *ss)
 {
-	struct solo6010_dev *solo_dev = snd_pcm_substream_chip(ss);
+	struct solo_dev *solo_dev = snd_pcm_substream_chip(ss);
 	struct solo_snd_pcm *solo_pcm;
 
 	solo_pcm = kzalloc(sizeof(*solo_pcm), GFP_KERNEL);
@@ -162,7 +162,7 @@ static int snd_solo_pcm_close(struct snd_pcm_substream *ss)
 static int snd_solo_pcm_trigger(struct snd_pcm_substream *ss, int cmd)
 {
 	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
-	struct solo6010_dev *solo_dev = solo_pcm->solo_dev;
+	struct solo_dev *solo_dev = solo_pcm->solo_dev;
 	int ret = 0;
 
 	spin_lock(&solo_pcm->lock);
@@ -172,7 +172,7 @@ static int snd_solo_pcm_trigger(struct snd_pcm_substream *ss, int cmd)
 		if (solo_pcm->on == 0) {
 			/* If this is the first user, switch on interrupts */
 			if (atomic_inc_return(&solo_dev->snd_users) == 1)
-				solo6010_irq_on(solo_dev, SOLO_IRQ_G723);
+				solo_irq_on(solo_dev, SOLO_IRQ_G723);
 			solo_pcm->on = 1;
 		}
 		break;
@@ -180,7 +180,7 @@ static int snd_solo_pcm_trigger(struct snd_pcm_substream *ss, int cmd)
 		if (solo_pcm->on) {
 			/* If this was our last user, switch them off */
 			if (atomic_dec_return(&solo_dev->snd_users) == 0)
-				solo6010_irq_off(solo_dev, SOLO_IRQ_G723);
+				solo_irq_off(solo_dev, SOLO_IRQ_G723);
 			solo_pcm->on = 0;
 		}
 		break;
@@ -201,7 +201,7 @@ static int snd_solo_pcm_prepare(struct snd_pcm_substream *ss)
 static snd_pcm_uframes_t snd_solo_pcm_pointer(struct snd_pcm_substream *ss)
 {
 	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
-	struct solo6010_dev *solo_dev = solo_pcm->solo_dev;
+	struct solo_dev *solo_dev = solo_pcm->solo_dev;
 	snd_pcm_uframes_t idx = solo_reg_read(solo_dev, SOLO_AUDIO_STA) & 0x1f;
 
 	return idx * G723_FRAMES_PER_PAGE;
@@ -212,7 +212,7 @@ static int snd_solo_pcm_copy(struct snd_pcm_substream *ss, int channel,
 			     snd_pcm_uframes_t count)
 {
 	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
-	struct solo6010_dev *solo_dev = solo_pcm->solo_dev;
+	struct solo_dev *solo_dev = solo_pcm->solo_dev;
 	int err, i;
 
 	for (i = 0; i < (count / G723_FRAMES_PER_PAGE); i++) {
@@ -264,7 +264,7 @@ static int snd_solo_capture_volume_info(struct snd_kcontrol *kcontrol,
 static int snd_solo_capture_volume_get(struct snd_kcontrol *kcontrol,
 				       struct snd_ctl_elem_value *value)
 {
-	struct solo6010_dev *solo_dev = snd_kcontrol_chip(kcontrol);
+	struct solo_dev *solo_dev = snd_kcontrol_chip(kcontrol);
 	u8 ch = value->id.numid - 1;
 
 	value->value.integer.value[0] = tw28_get_audio_gain(solo_dev, ch);
@@ -275,7 +275,7 @@ static int snd_solo_capture_volume_get(struct snd_kcontrol *kcontrol,
 static int snd_solo_capture_volume_put(struct snd_kcontrol *kcontrol,
 				       struct snd_ctl_elem_value *value)
 {
-	struct solo6010_dev *solo_dev = snd_kcontrol_chip(kcontrol);
+	struct solo_dev *solo_dev = snd_kcontrol_chip(kcontrol);
 	u8 ch = value->id.numid - 1;
 	u8 old_val;
 
@@ -296,7 +296,7 @@ static struct snd_kcontrol_new snd_solo_capture_volume = {
 	.put = snd_solo_capture_volume_put,
 };
 
-static int solo_snd_pcm_init(struct solo6010_dev *solo_dev)
+static int solo_snd_pcm_init(struct solo_dev *solo_dev)
 {
 	struct snd_card *card = solo_dev->snd_card;
 	struct snd_pcm *pcm;
@@ -332,7 +332,7 @@ static int solo_snd_pcm_init(struct solo6010_dev *solo_dev)
 	return 0;
 }
 
-int solo_g723_init(struct solo6010_dev *solo_dev)
+int solo_g723_init(struct solo_dev *solo_dev)
 {
 	static struct snd_device_ops ops = { NULL };
 	struct snd_card *card;
@@ -352,8 +352,8 @@ int solo_g723_init(struct solo6010_dev *solo_dev)
 
 	card = solo_dev->snd_card;
 
-	strcpy(card->driver, SOLO6010_NAME);
-	strcpy(card->shortname, "SOLO-6010 Audio");
+	strcpy(card->driver, SOLO6X10_NAME);
+	strcpy(card->shortname, "SOLO-6x10 Audio");
 	sprintf(card->longname, "%s on %s IRQ %d", card->shortname,
 		pci_name(solo_dev->pdev), solo_dev->pdev->irq);
 	snd_card_set_dev(card, &solo_dev->pdev->dev);
@@ -363,7 +363,7 @@ int solo_g723_init(struct solo6010_dev *solo_dev)
 		goto snd_error;
 
 	/* Mixer controls */
-	strcpy(card->mixername, "SOLO-6010");
+	strcpy(card->mixername, "SOLO-6x10");
 	kctl = snd_solo_capture_volume;
 	kctl.count = solo_dev->nr_chans;
 	ret = snd_ctl_add(card, snd_ctl_new1(&kctl, solo_dev));
@@ -389,10 +389,10 @@ snd_error:
 	return ret;
 }
 
-void solo_g723_exit(struct solo6010_dev *solo_dev)
+void solo_g723_exit(struct solo_dev *solo_dev)
 {
 	solo_reg_write(solo_dev, SOLO_AUDIO_CONTROL, 0);
-	solo6010_irq_off(solo_dev, SOLO_IRQ_G723);
+	solo_irq_off(solo_dev, SOLO_IRQ_G723);
 
 	snd_card_free(solo_dev->snd_card);
 }
diff --git a/drivers/staging/solo6x10/gpio.c b/drivers/staging/solo6x10/gpio.c
index efd88ba..0925e6f 100644
--- a/drivers/staging/solo6x10/gpio.c
+++ b/drivers/staging/solo6x10/gpio.c
@@ -22,7 +22,7 @@
 #include <asm/uaccess.h>
 #include "solo6x10.h"
 
-static void solo_gpio_mode(struct solo6010_dev *solo_dev,
+static void solo_gpio_mode(struct solo_dev *solo_dev,
 			   unsigned int port_mask, unsigned int mode)
 {
 	int port;
@@ -57,19 +57,19 @@ static void solo_gpio_mode(struct solo6010_dev *solo_dev,
 	solo_reg_write(solo_dev, SOLO_GPIO_CONFIG_1, ret);
 }
 
-static void solo_gpio_set(struct solo6010_dev *solo_dev, unsigned int value)
+static void solo_gpio_set(struct solo_dev *solo_dev, unsigned int value)
 {
 	solo_reg_write(solo_dev, SOLO_GPIO_DATA_OUT,
 		       solo_reg_read(solo_dev, SOLO_GPIO_DATA_OUT) | value);
 }
 
-static void solo_gpio_clear(struct solo6010_dev *solo_dev, unsigned int value)
+static void solo_gpio_clear(struct solo_dev *solo_dev, unsigned int value)
 {
 	solo_reg_write(solo_dev, SOLO_GPIO_DATA_OUT,
 		       solo_reg_read(solo_dev, SOLO_GPIO_DATA_OUT) & ~value);
 }
 
-static void solo_gpio_config(struct solo6010_dev *solo_dev)
+static void solo_gpio_config(struct solo_dev *solo_dev)
 {
 	/* Video reset */
 	solo_gpio_mode(solo_dev, 0x30, 1);
@@ -89,13 +89,13 @@ static void solo_gpio_config(struct solo6010_dev *solo_dev)
 	solo_gpio_clear(solo_dev, 0xff00);
 }
 
-int solo_gpio_init(struct solo6010_dev *solo_dev)
+int solo_gpio_init(struct solo_dev *solo_dev)
 {
 	solo_gpio_config(solo_dev);
 	return 0;
 }
 
-void solo_gpio_exit(struct solo6010_dev *solo_dev)
+void solo_gpio_exit(struct solo_dev *solo_dev)
 {
 	solo_gpio_clear(solo_dev, 0x30);
 	solo_gpio_config(solo_dev);
diff --git a/drivers/staging/solo6x10/i2c.c b/drivers/staging/solo6x10/i2c.c
index fba4247..ef95a50 100644
--- a/drivers/staging/solo6x10/i2c.c
+++ b/drivers/staging/solo6x10/i2c.c
@@ -17,7 +17,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-/* XXX: The SOLO6010 i2c does not have separate interrupts for each i2c
+/* XXX: The SOLO6x10 i2c does not have separate interrupts for each i2c
  * channel. The bus can only handle one i2c event at a time. The below handles
  * this all wrong. We should be using the status registers to see if the bus
  * is in use, and have a global lock to check the status register. Also,
@@ -28,7 +28,7 @@
 #include <linux/kernel.h>
 #include "solo6x10.h"
 
-u8 solo_i2c_readbyte(struct solo6010_dev *solo_dev, int id, u8 addr, u8 off)
+u8 solo_i2c_readbyte(struct solo_dev *solo_dev, int id, u8 addr, u8 off)
 {
 	struct i2c_msg msgs[2];
 	u8 data;
@@ -48,7 +48,7 @@ u8 solo_i2c_readbyte(struct solo6010_dev *solo_dev, int id, u8 addr, u8 off)
 	return data;
 }
 
-void solo_i2c_writebyte(struct solo6010_dev *solo_dev, int id, u8 addr,
+void solo_i2c_writebyte(struct solo_dev *solo_dev, int id, u8 addr,
 			u8 off, u8 data)
 {
 	struct i2c_msg msgs;
@@ -64,7 +64,7 @@ void solo_i2c_writebyte(struct solo6010_dev *solo_dev, int id, u8 addr,
 	i2c_transfer(&solo_dev->i2c_adap[id], &msgs, 1);
 }
 
-static void solo_i2c_flush(struct solo6010_dev *solo_dev, int wr)
+static void solo_i2c_flush(struct solo_dev *solo_dev, int wr)
 {
 	u32 ctrl;
 
@@ -87,7 +87,7 @@ static void solo_i2c_flush(struct solo6010_dev *solo_dev, int wr)
 	solo_reg_write(solo_dev, SOLO_IIC_CTRL, ctrl);
 }
 
-static void solo_i2c_start(struct solo6010_dev *solo_dev)
+static void solo_i2c_start(struct solo_dev *solo_dev)
 {
 	u32 addr = solo_dev->i2c_msg->addr << 1;
 
@@ -99,15 +99,15 @@ static void solo_i2c_start(struct solo6010_dev *solo_dev)
 	solo_i2c_flush(solo_dev, 1);
 }
 
-static void solo_i2c_stop(struct solo6010_dev *solo_dev)
+static void solo_i2c_stop(struct solo_dev *solo_dev)
 {
-	solo6010_irq_off(solo_dev, SOLO_IRQ_IIC);
+	solo_irq_off(solo_dev, SOLO_IRQ_IIC);
 	solo_reg_write(solo_dev, SOLO_IIC_CTRL, 0);
 	solo_dev->i2c_state = IIC_STATE_STOP;
 	wake_up(&solo_dev->i2c_wait);
 }
 
-static int solo_i2c_handle_read(struct solo6010_dev *solo_dev)
+static int solo_i2c_handle_read(struct solo_dev *solo_dev)
 {
 prepare_read:
 	if (solo_dev->i2c_msg_ptr != solo_dev->i2c_msg->len) {
@@ -136,7 +136,7 @@ prepare_read:
 	return 0;
 }
 
-static int solo_i2c_handle_write(struct solo6010_dev *solo_dev)
+static int solo_i2c_handle_write(struct solo_dev *solo_dev)
 {
 retry_write:
 	if (solo_dev->i2c_msg_ptr != solo_dev->i2c_msg->len) {
@@ -168,7 +168,7 @@ retry_write:
 	return 0;
 }
 
-int solo_i2c_isr(struct solo6010_dev *solo_dev)
+int solo_i2c_isr(struct solo_dev *solo_dev)
 {
 	u32 status = solo_reg_read(solo_dev, SOLO_IIC_CTRL);
 	int ret = -EINVAL;
@@ -212,7 +212,7 @@ int solo_i2c_isr(struct solo6010_dev *solo_dev)
 static int solo_i2c_master_xfer(struct i2c_adapter *adap,
 				struct i2c_msg msgs[], int num)
 {
-	struct solo6010_dev *solo_dev = adap->algo_data;
+	struct solo_dev *solo_dev = adap->algo_data;
 	unsigned long timeout;
 	int ret;
 	int i;
@@ -233,7 +233,7 @@ static int solo_i2c_master_xfer(struct i2c_adapter *adap,
 	solo_dev->i2c_msg_ptr = 0;
 
 	solo_reg_write(solo_dev, SOLO_IIC_CTRL, 0);
-	solo6010_irq_on(solo_dev, SOLO_IRQ_IIC);
+	solo_irq_on(solo_dev, SOLO_IRQ_IIC);
 	solo_i2c_start(solo_dev);
 
 	timeout = HZ / 2;
@@ -272,7 +272,7 @@ static struct i2c_algorithm solo_i2c_algo = {
 	.functionality	= solo_i2c_functionality,
 };
 
-int solo_i2c_init(struct solo6010_dev *solo_dev)
+int solo_i2c_init(struct solo_dev *solo_dev)
 {
 	int i;
 	int ret;
@@ -288,8 +288,7 @@ int solo_i2c_init(struct solo6010_dev *solo_dev)
 	for (i = 0; i < SOLO_I2C_ADAPTERS; i++) {
 		struct i2c_adapter *adap = &solo_dev->i2c_adap[i];
 
-		snprintf(adap->name, I2C_NAME_SIZE, "%s I2C %d",
-			 SOLO6010_NAME, i);
+		snprintf(adap->name, I2C_NAME_SIZE, "%s I2C %d", SOLO6X10_NAME, i);
 		adap->algo = &solo_i2c_algo;
 		adap->algo_data = solo_dev;
 		adap->retries = 1;
@@ -318,7 +317,7 @@ int solo_i2c_init(struct solo6010_dev *solo_dev)
 	return 0;
 }
 
-void solo_i2c_exit(struct solo6010_dev *solo_dev)
+void solo_i2c_exit(struct solo_dev *solo_dev)
 {
 	int i;
 
diff --git a/drivers/staging/solo6x10/jpeg.h b/drivers/staging/solo6x10/jpeg.h
index fb0507e..50defec 100644
--- a/drivers/staging/solo6x10/jpeg.h
+++ b/drivers/staging/solo6x10/jpeg.h
@@ -17,8 +17,8 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#ifndef __SOLO6010_JPEG_H
-#define __SOLO6010_JPEG_H
+#ifndef __SOLO6X10_JPEG_H
+#define __SOLO6X10_JPEG_H
 
 static unsigned char jpeg_header[] = {
 	0xff, 0xd8, 0xff, 0xfe, 0x00, 0x0d, 0x42, 0x6c,
@@ -102,4 +102,4 @@ static unsigned char jpeg_header[] = {
 /* This is the byte marker for the start of SOF0: 0xffc0 marker */
 #define SOF0_START	575
 
-#endif /* __SOLO6010_JPEG_H */
+#endif /* __SOLO6X10_JPEG_H */
diff --git a/drivers/staging/solo6x10/offsets.h b/drivers/staging/solo6x10/offsets.h
index b176003..3d7e569 100644
--- a/drivers/staging/solo6x10/offsets.h
+++ b/drivers/staging/solo6x10/offsets.h
@@ -17,8 +17,8 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#ifndef __SOLO6010_OFFSETS_H
-#define __SOLO6010_OFFSETS_H
+#ifndef __SOLO6X10_OFFSETS_H
+#define __SOLO6X10_OFFSETS_H
 
 /* Offsets and sizes of the external address */
 #define SOLO_DISP_EXT_ADDR			0x00000000
@@ -71,4 +71,4 @@
 		 (SOLO_MP4D_EXT_SIZE * __solo->nr_chans))
 #define SOLO_JPEG_EXT_SIZE(__solo)		(0x00080000 * __solo->nr_chans)
 
-#endif /* __SOLO6010_OFFSETS_H */
+#endif /* __SOLO6X10_OFFSETS_H */
diff --git a/drivers/staging/solo6x10/osd-font.h b/drivers/staging/solo6x10/osd-font.h
index d72efbb..591e0e8 100644
--- a/drivers/staging/solo6x10/osd-font.h
+++ b/drivers/staging/solo6x10/osd-font.h
@@ -17,8 +17,8 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#ifndef __SOLO6010_OSD_FONT_H
-#define __SOLO6010_OSD_FONT_H
+#ifndef __SOLO6X10_OSD_FONT_H
+#define __SOLO6X10_OSD_FONT_H
 
 static const unsigned int solo_osd_font[] = {
 	0x00000000, 0x0000c0c8, 0xccfefe0c, 0x08000000,
@@ -151,4 +151,4 @@ static const unsigned int solo_osd_font[] = {
 	0x00000000, 0x0010386c, 0xc6c6fe00, 0x00000000
 };
 
-#endif /* __SOLO6010_OSD_FONT_H */
+#endif /* __SOLO6X10_OSD_FONT_H */
diff --git a/drivers/staging/solo6x10/p2m.c b/drivers/staging/solo6x10/p2m.c
index 1b88d10..5717eab 100644
--- a/drivers/staging/solo6x10/p2m.c
+++ b/drivers/staging/solo6x10/p2m.c
@@ -23,7 +23,7 @@
 
 /* #define SOLO_TEST_P2M */
 
-int solo_p2m_dma(struct solo6010_dev *solo_dev, u8 id, int wr,
+int solo_p2m_dma(struct solo_dev *solo_dev, u8 id, int wr,
 		 void *sys_addr, u32 ext_addr, u32 size)
 {
 	dma_addr_t dma_addr;
@@ -46,7 +46,7 @@ int solo_p2m_dma(struct solo6010_dev *solo_dev, u8 id, int wr,
 	return ret;
 }
 
-int solo_p2m_dma_t(struct solo6010_dev *solo_dev, u8 id, int wr,
+int solo_p2m_dma_t(struct solo_dev *solo_dev, u8 id, int wr,
 		   dma_addr_t dma_addr, u32 ext_addr, u32 size)
 {
 	struct p2m_desc *desc = kzalloc(sizeof(*desc) * 2, GFP_DMA);
@@ -80,7 +80,7 @@ void solo_p2m_push_desc(struct p2m_desc *desc, int wr, dma_addr_t dma_addr,
 	}
 }
 
-int solo_p2m_dma_desc(struct solo6010_dev *solo_dev, u8 id,
+int solo_p2m_dma_desc(struct solo_dev *solo_dev, u8 id,
 		      struct p2m_desc *desc, int desc_count)
 {
 	struct solo_p2m_dev *p2m_dev;
@@ -136,7 +136,7 @@ int solo_p2m_dma_desc(struct solo6010_dev *solo_dev, u8 id,
 	return ret;
 }
 
-int solo_p2m_dma_sg(struct solo6010_dev *solo_dev, u8 id,
+int solo_p2m_dma_sg(struct solo_dev *solo_dev, u8 id,
 		    struct p2m_desc *pdesc, int wr,
 		    struct scatterlist *sg, u32 sg_off,
 		    u32 ext_addr, u32 size)
@@ -185,7 +185,7 @@ int solo_p2m_dma_sg(struct solo6010_dev *solo_dev, u8 id,
 
 #define P2M_TEST_CHAR		0xbe
 
-static unsigned long long p2m_test(struct solo6010_dev *solo_dev, u8 id,
+static unsigned long long p2m_test(struct solo_dev *solo_dev, u8 id,
 				   u32 base, int size)
 {
 	u8 *wr_buf;
@@ -195,13 +195,13 @@ static unsigned long long p2m_test(struct solo6010_dev *solo_dev, u8 id,
 
 	wr_buf = kmalloc(size, GFP_KERNEL);
 	if (!wr_buf) {
-		printk(SOLO6010_NAME ": Failed to malloc for p2m_test\n");
+		printk(SOLO6X10_NAME ": Failed to malloc for p2m_test\n");
 		return size;
 	}
 
 	rd_buf = kmalloc(size, GFP_KERNEL);
 	if (!rd_buf) {
-		printk(SOLO6010_NAME ": Failed to malloc for p2m_test\n");
+		printk(SOLO6X10_NAME ": Failed to malloc for p2m_test\n");
 		kfree(wr_buf);
 		return size;
 	}
@@ -224,21 +224,21 @@ static unsigned long long p2m_test(struct solo6010_dev *solo_dev, u8 id,
 
 #define TEST_CHUNK_SIZE		(8 * 1024)
 
-static void run_p2m_test(struct solo6010_dev *solo_dev)
+static void run_p2m_test(struct solo_dev *solo_dev)
 {
 	unsigned long long errs = 0;
 	u32 size = SOLO_JPEG_EXT_ADDR(solo_dev) + SOLO_JPEG_EXT_SIZE(solo_dev);
 	int i, d;
 
 	printk(KERN_WARNING "%s: Testing %u bytes of external ram\n",
-	       SOLO6010_NAME, size);
+	       SOLO6X10_NAME, size);
 
 	for (i = 0; i < size; i += TEST_CHUNK_SIZE)
 		for (d = 0; d < 4; d++)
 			errs += p2m_test(solo_dev, d, i, TEST_CHUNK_SIZE);
 
 	printk(KERN_WARNING "%s: Found %llu errors during p2m test\n",
-	       SOLO6010_NAME, errs);
+	       SOLO6X10_NAME, errs);
 
 	return;
 }
@@ -246,7 +246,7 @@ static void run_p2m_test(struct solo6010_dev *solo_dev)
 #define run_p2m_test(__solo)	do {} while (0)
 #endif
 
-void solo_p2m_isr(struct solo6010_dev *solo_dev, int id)
+void solo_p2m_isr(struct solo_dev *solo_dev, int id)
 {
 	struct solo_p2m_dev *p2m_dev = &solo_dev->p2m_dev[id];
 
@@ -255,7 +255,7 @@ void solo_p2m_isr(struct solo6010_dev *solo_dev, int id)
 	complete(&p2m_dev->completion);
 }
 
-void solo_p2m_error_isr(struct solo6010_dev *solo_dev, u32 status)
+void solo_p2m_error_isr(struct solo_dev *solo_dev, u32 status)
 {
 	struct solo_p2m_dev *p2m_dev;
 	int i;
@@ -271,15 +271,15 @@ void solo_p2m_error_isr(struct solo6010_dev *solo_dev, u32 status)
 	}
 }
 
-void solo_p2m_exit(struct solo6010_dev *solo_dev)
+void solo_p2m_exit(struct solo_dev *solo_dev)
 {
 	int i;
 
 	for (i = 0; i < SOLO_NR_P2M; i++)
-		solo6010_irq_off(solo_dev, SOLO_IRQ_P2M(i));
+		solo_irq_off(solo_dev, SOLO_IRQ_P2M(i));
 }
 
-int solo_p2m_init(struct solo6010_dev *solo_dev)
+int solo_p2m_init(struct solo_dev *solo_dev)
 {
 	struct solo_p2m_dev *p2m_dev;
 	int i;
@@ -296,7 +296,7 @@ int solo_p2m_init(struct solo6010_dev *solo_dev)
 			       SOLO_P2M_DMA_INTERVAL(3) |
 			       SOLO_P2M_DESC_INTR_OPT |
 			       SOLO_P2M_PCI_MASTER_MODE);
-		solo6010_irq_on(solo_dev, SOLO_IRQ_P2M(i));
+		solo_irq_on(solo_dev, SOLO_IRQ_P2M(i));
 	}
 
 	run_p2m_test(solo_dev);
diff --git a/drivers/staging/solo6x10/registers.h b/drivers/staging/solo6x10/registers.h
index edf77e8..aca5444 100644
--- a/drivers/staging/solo6x10/registers.h
+++ b/drivers/staging/solo6x10/registers.h
@@ -17,12 +17,12 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#ifndef __SOLO6010_REGISTERS_H
-#define __SOLO6010_REGISTERS_H
+#ifndef __SOLO6X10_REGISTERS_H
+#define __SOLO6X10_REGISTERS_H
 
 #include "offsets.h"
 
-/* Global 6010 system configuration */
+/* Global 6X10 system configuration */
 #define SOLO_SYS_CFG				0x0000
 #define   SOLO6010_SYS_CFG_FOUT_EN		0x00000001 /* 6010 only */
 #define   SOLO6010_SYS_CFG_PLL_BYPASS		0x00000002 /* 6010 only */
@@ -634,4 +634,4 @@
 #define WATCHDOG_STAT(status)			(status<<8)
 #define WATCHDOG_TIME(sec)			(sec&0xff)
 
-#endif /* __SOLO6010_REGISTERS_H */
+#endif /* __SOLO6X10_REGISTERS_H */
diff --git a/drivers/staging/solo6x10/solo6x10.h b/drivers/staging/solo6x10/solo6x10.h
index 1730f4d..fd59b09 100644
--- a/drivers/staging/solo6x10/solo6x10.h
+++ b/drivers/staging/solo6x10/solo6x10.h
@@ -17,8 +17,8 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#ifndef __SOLO6010_H
-#define __SOLO6010_H
+#ifndef __SOLO6X10_H
+#define __SOLO6X10_H
 
 #include <linux/version.h>
 #include <linux/pci.h>
@@ -57,22 +57,22 @@
 #define PCI_DEVICE_ID_BC_6110_16	0x5310
 #endif /* Bluecherry */
 
-#define SOLO6010_NAME			"solo6010"
+#define SOLO6X10_NAME			"solo6x10"
 
 #define SOLO_MAX_CHANNELS		16
 
 /* Make sure these two match */
-#define SOLO6010_VERSION		"2.0.0"
-#define SOLO6010_VER_MAJOR		2
-#define SOLO6010_VER_MINOR		0
-#define SOLO6010_VER_SUB		0
-#define SOLO6010_VER_NUM \
-	KERNEL_VERSION(SOLO6010_VER_MAJOR, SOLO6010_VER_MINOR, SOLO6010_VER_SUB)
+#define SOLO6X10_VERSION		"2.1.0"
+#define SOLO6X10_VER_MAJOR		2
+#define SOLO6X10_VER_MINOR		0
+#define SOLO6X10_VER_SUB		0
+#define SOLO6X10_VER_NUM \
+	KERNEL_VERSION(SOLO6X10_VER_MAJOR, SOLO6X10_VER_MINOR, SOLO6X10_VER_SUB)
 
 #define FLAGS_6110			1
 
 /*
- * The SOLO6010 actually has 8 i2c channels, but we only use 2.
+ * The SOLO6x10 actually has 8 i2c channels, but we only use 2.
  * 0 - Techwell chip(s)
  * 1 - SAA7128
  */
@@ -148,7 +148,7 @@ enum solo_enc_types {
 };
 
 struct solo_enc_dev {
-	struct solo6010_dev	*solo_dev;
+	struct solo_dev		*solo_dev;
 	/* V4L2 Items */
 	struct video_device	*vfd;
 	/* General accounting */
@@ -177,8 +177,8 @@ struct solo_enc_buf {
 	struct timeval		ts;
 };
 
-/* The SOLO6010 PCI Device */
-struct solo6010_dev {
+/* The SOLO6x10 PCI Device */
+struct solo_dev {
 	/* General stuff */
 	struct pci_dev		*pdev;
 	u8 __iomem		*reg_base;
@@ -236,7 +236,7 @@ struct solo6010_dev {
 	int			g723_hw_idx;
 };
 
-static inline u32 solo_reg_read(struct solo6010_dev *solo_dev, int reg)
+static inline u32 solo_reg_read(struct solo_dev *solo_dev, int reg)
 {
 	unsigned long flags;
 	u32 ret;
@@ -254,8 +254,7 @@ static inline u32 solo_reg_read(struct solo6010_dev *solo_dev, int reg)
 	return ret;
 }
 
-static inline void solo_reg_write(struct solo6010_dev *solo_dev, int reg,
-				      u32 data)
+static inline void solo_reg_write(struct solo_dev *solo_dev, int reg, u32 data)
 {
 	unsigned long flags;
 	u16 val;
@@ -270,67 +269,67 @@ static inline void solo_reg_write(struct solo6010_dev *solo_dev, int reg,
 	spin_unlock_irqrestore(&solo_dev->reg_io_lock, flags);
 }
 
-void solo6010_irq_on(struct solo6010_dev *solo_dev, u32 mask);
-void solo6010_irq_off(struct solo6010_dev *solo_dev, u32 mask);
+void solo_irq_on(struct solo_dev *solo_dev, u32 mask);
+void solo_irq_off(struct solo_dev *solo_dev, u32 mask);
 
 /* Init/exit routeines for subsystems */
-int solo_disp_init(struct solo6010_dev *solo_dev);
-void solo_disp_exit(struct solo6010_dev *solo_dev);
+int solo_disp_init(struct solo_dev *solo_dev);
+void solo_disp_exit(struct solo_dev *solo_dev);
 
-int solo_gpio_init(struct solo6010_dev *solo_dev);
-void solo_gpio_exit(struct solo6010_dev *solo_dev);
+int solo_gpio_init(struct solo_dev *solo_dev);
+void solo_gpio_exit(struct solo_dev *solo_dev);
 
-int solo_i2c_init(struct solo6010_dev *solo_dev);
-void solo_i2c_exit(struct solo6010_dev *solo_dev);
+int solo_i2c_init(struct solo_dev *solo_dev);
+void solo_i2c_exit(struct solo_dev *solo_dev);
 
-int solo_p2m_init(struct solo6010_dev *solo_dev);
-void solo_p2m_exit(struct solo6010_dev *solo_dev);
+int solo_p2m_init(struct solo_dev *solo_dev);
+void solo_p2m_exit(struct solo_dev *solo_dev);
 
-int solo_v4l2_init(struct solo6010_dev *solo_dev);
-void solo_v4l2_exit(struct solo6010_dev *solo_dev);
+int solo_v4l2_init(struct solo_dev *solo_dev);
+void solo_v4l2_exit(struct solo_dev *solo_dev);
 
-int solo_enc_init(struct solo6010_dev *solo_dev);
-void solo_enc_exit(struct solo6010_dev *solo_dev);
+int solo_enc_init(struct solo_dev *solo_dev);
+void solo_enc_exit(struct solo_dev *solo_dev);
 
-int solo_enc_v4l2_init(struct solo6010_dev *solo_dev);
-void solo_enc_v4l2_exit(struct solo6010_dev *solo_dev);
+int solo_enc_v4l2_init(struct solo_dev *solo_dev);
+void solo_enc_v4l2_exit(struct solo_dev *solo_dev);
 
-int solo_g723_init(struct solo6010_dev *solo_dev);
-void solo_g723_exit(struct solo6010_dev *solo_dev);
+int solo_g723_init(struct solo_dev *solo_dev);
+void solo_g723_exit(struct solo_dev *solo_dev);
 
 /* ISR's */
-int solo_i2c_isr(struct solo6010_dev *solo_dev);
-void solo_p2m_isr(struct solo6010_dev *solo_dev, int id);
-void solo_p2m_error_isr(struct solo6010_dev *solo_dev, u32 status);
-void solo_enc_v4l2_isr(struct solo6010_dev *solo_dev);
-void solo_g723_isr(struct solo6010_dev *solo_dev);
-void solo_motion_isr(struct solo6010_dev *solo_dev);
-void solo_video_in_isr(struct solo6010_dev *solo_dev);
+int solo_i2c_isr(struct solo_dev *solo_dev);
+void solo_p2m_isr(struct solo_dev *solo_dev, int id);
+void solo_p2m_error_isr(struct solo_dev *solo_dev, u32 status);
+void solo_enc_v4l2_isr(struct solo_dev *solo_dev);
+void solo_g723_isr(struct solo_dev *solo_dev);
+void solo_motion_isr(struct solo_dev *solo_dev);
+void solo_video_in_isr(struct solo_dev *solo_dev);
 
 /* i2c read/write */
-u8 solo_i2c_readbyte(struct solo6010_dev *solo_dev, int id, u8 addr, u8 off);
-void solo_i2c_writebyte(struct solo6010_dev *solo_dev, int id, u8 addr, u8 off,
+u8 solo_i2c_readbyte(struct solo_dev *solo_dev, int id, u8 addr, u8 off);
+void solo_i2c_writebyte(struct solo_dev *solo_dev, int id, u8 addr, u8 off,
 			u8 data);
 
 /* P2M DMA */
-int solo_p2m_dma_t(struct solo6010_dev *solo_dev, u8 id, int wr,
+int solo_p2m_dma_t(struct solo_dev *solo_dev, u8 id, int wr,
 		   dma_addr_t dma_addr, u32 ext_addr, u32 size);
-int solo_p2m_dma(struct solo6010_dev *solo_dev, u8 id, int wr,
+int solo_p2m_dma(struct solo_dev *solo_dev, u8 id, int wr,
 		 void *sys_addr, u32 ext_addr, u32 size);
-int solo_p2m_dma_sg(struct solo6010_dev *solo_dev, u8 id,
+int solo_p2m_dma_sg(struct solo_dev *solo_dev, u8 id,
 		    struct p2m_desc *pdesc, int wr,
 		    struct scatterlist *sglist, u32 sg_off,
 		    u32 ext_addr, u32 size);
 void solo_p2m_push_desc(struct p2m_desc *desc, int wr, dma_addr_t dma_addr,
 			u32 ext_addr, u32 size, int repeat, u32 ext_size);
-int solo_p2m_dma_desc(struct solo6010_dev *solo_dev, u8 id,
+int solo_p2m_dma_desc(struct solo_dev *solo_dev, u8 id,
 		      struct p2m_desc *desc, int desc_count);
 
 /* Set the threshold for motion detection */
-void solo_set_motion_threshold(struct solo6010_dev *solo_dev, u8 ch, u16 val);
+void solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val);
 #define SOLO_DEF_MOT_THRESH		0x0300
 
 /* Write text on OSD */
 int solo_osd_print(struct solo_enc_dev *solo_enc);
 
-#endif /* __SOLO6010_H */
+#endif /* __SOLO6X10_H */
diff --git a/drivers/staging/solo6x10/tw28.c b/drivers/staging/solo6x10/tw28.c
index 0f3d1e4..db56b42 100644
--- a/drivers/staging/solo6x10/tw28.c
+++ b/drivers/staging/solo6x10/tw28.c
@@ -140,7 +140,7 @@ static u8 tbl_tw2865_pal_template[] = {
 
 #define is_tw286x(__solo, __id) (!(__solo->tw2815 & (1 << __id)))
 
-static u8 tw_readbyte(struct solo6010_dev *solo_dev, int chip_id, u8 tw6x_off,
+static u8 tw_readbyte(struct solo_dev *solo_dev, int chip_id, u8 tw6x_off,
 		      u8 tw_off)
 {
 	if (is_tw286x(solo_dev, chip_id))
@@ -153,7 +153,7 @@ static u8 tw_readbyte(struct solo6010_dev *solo_dev, int chip_id, u8 tw6x_off,
 					 tw_off);
 }
 
-static void tw_writebyte(struct solo6010_dev *solo_dev, int chip_id,
+static void tw_writebyte(struct solo_dev *solo_dev, int chip_id,
 			 u8 tw6x_off, u8 tw_off, u8 val)
 {
 	if (is_tw286x(solo_dev, chip_id))
@@ -166,7 +166,7 @@ static void tw_writebyte(struct solo6010_dev *solo_dev, int chip_id,
 				   tw_off, val);
 }
 
-static void tw_write_and_verify(struct solo6010_dev *solo_dev, u8 addr, u8 off,
+static void tw_write_and_verify(struct solo_dev *solo_dev, u8 addr, u8 off,
 				u8 val)
 {
 	int i;
@@ -180,11 +180,11 @@ static void tw_write_and_verify(struct solo6010_dev *solo_dev, u8 addr, u8 off,
 		msleep_interruptible(1);
 	}
 
-/*	printk("solo6010/tw28: Error writing register: %02x->%02x [%02x]\n",
+/*	printk("solo6x10/tw28: Error writing register: %02x->%02x [%02x]\n",
 		addr, off, val); */
 }
 
-static int tw2865_setup(struct solo6010_dev *solo_dev, u8 dev_addr)
+static int tw2865_setup(struct solo_dev *solo_dev, u8 dev_addr)
 {
 	u8 tbl_tw2865_common[256];
 	int i;
@@ -234,7 +234,7 @@ static int tw2865_setup(struct solo6010_dev *solo_dev, u8 dev_addr)
 	return 0;
 }
 
-static int tw2864_setup(struct solo6010_dev *solo_dev, u8 dev_addr)
+static int tw2864_setup(struct solo_dev *solo_dev, u8 dev_addr)
 {
 	u8 tbl_tw2864_common[sizeof(tbl_tw2864_template)];
 	int i;
@@ -320,7 +320,7 @@ static int tw2864_setup(struct solo6010_dev *solo_dev, u8 dev_addr)
 	return 0;
 }
 
-static int tw2815_setup(struct solo6010_dev *solo_dev, u8 dev_addr)
+static int tw2815_setup(struct solo_dev *solo_dev, u8 dev_addr)
 {
 	u8 tbl_ntsc_tw2815_common[] = {
 		0x00, 0xc8, 0x20, 0xd0, 0x06, 0xf0, 0x08, 0x80,
@@ -481,7 +481,7 @@ static int tw2815_setup(struct solo6010_dev *solo_dev, u8 dev_addr)
 #define FIRST_ACTIVE_LINE	0x0008
 #define LAST_ACTIVE_LINE	0x0102
 
-static void saa7128_setup(struct solo6010_dev *solo_dev)
+static void saa7128_setup(struct solo_dev *solo_dev)
 {
 	int i;
 	unsigned char regs[128] = {
@@ -539,7 +539,7 @@ static void saa7128_setup(struct solo6010_dev *solo_dev)
 	return;
 }
 
-int solo_tw28_init(struct solo6010_dev *solo_dev)
+int solo_tw28_init(struct solo_dev *solo_dev)
 {
 	int i;
 	u8 value;
@@ -602,7 +602,7 @@ int solo_tw28_init(struct solo6010_dev *solo_dev)
  * (address 0x012C) of the SOLO6010 chip doesn't give the correct video
  * status signal values.
  */
-int tw28_get_video_status(struct solo6010_dev *solo_dev, u8 ch)
+int tw28_get_video_status(struct solo_dev *solo_dev, u8 ch)
 {
 	u8 val, chip_num;
 
@@ -619,7 +619,7 @@ int tw28_get_video_status(struct solo6010_dev *solo_dev, u8 ch)
 #if 0
 /* Status of audio from up to 4 techwell chips are combined into 1 variable.
  * See techwell datasheet for details. */
-u16 tw28_get_audio_status(struct solo6010_dev *solo_dev)
+u16 tw28_get_audio_status(struct solo_dev *solo_dev)
 {
 	u8 val;
 	u16 status = 0;
@@ -635,8 +635,7 @@ u16 tw28_get_audio_status(struct solo6010_dev *solo_dev)
 }
 #endif
 
-int tw28_set_ctrl_val(struct solo6010_dev *solo_dev, u32 ctrl, u8 ch,
-		      s32 val)
+int tw28_set_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch, s32 val)
 {
 	char sval;
 	u8 chip_num;
@@ -708,7 +707,7 @@ int tw28_set_ctrl_val(struct solo6010_dev *solo_dev, u32 ctrl, u8 ch,
 	return 0;
 }
 
-int tw28_get_ctrl_val(struct solo6010_dev *solo_dev, u32 ctrl, u8 ch,
+int tw28_get_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch,
 		      s32 *val)
 {
 	u8 rval, chip_num;
@@ -768,7 +767,7 @@ int tw28_get_ctrl_val(struct solo6010_dev *solo_dev, u32 ctrl, u8 ch,
  * don't need to offset TW_CHIP_OFFSET_ADDR. The TW_CHIP_OFFSET_ADDR used
  * is the base address of the techwell chip.
  */
-void tw2815_Set_AudioOutVol(struct solo6010_dev *solo_dev, unsigned int u_val)
+void tw2815_Set_AudioOutVol(struct solo_dev *solo_dev, unsigned int u_val)
 {
 	unsigned int val;
 	unsigned int chip_num;
@@ -785,7 +784,7 @@ void tw2815_Set_AudioOutVol(struct solo6010_dev *solo_dev, unsigned int u_val)
 }
 #endif
 
-u8 tw28_get_audio_gain(struct solo6010_dev *solo_dev, u8 ch)
+u8 tw28_get_audio_gain(struct solo_dev *solo_dev, u8 ch)
 {
 	u8 val;
 	u8 chip_num;
@@ -801,7 +800,7 @@ u8 tw28_get_audio_gain(struct solo6010_dev *solo_dev, u8 ch)
 	return (ch % 2) ? (val >> 4) : (val & 0x0f);
 }
 
-void tw28_set_audio_gain(struct solo6010_dev *solo_dev, u8 ch, u8 val)
+void tw28_set_audio_gain(struct solo_dev *solo_dev, u8 ch, u8 val)
 {
 	u8 old_val;
 	u8 chip_num;
diff --git a/drivers/staging/solo6x10/tw28.h b/drivers/staging/solo6x10/tw28.h
index 4862ac9..a44a03a 100644
--- a/drivers/staging/solo6x10/tw28.h
+++ b/drivers/staging/solo6x10/tw28.h
@@ -17,8 +17,8 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#ifndef __SOLO6010_TW28_H
-#define __SOLO6010_TW28_H
+#ifndef __SOLO6X10_TW28_H
+#define __SOLO6X10_TW28_H
 
 #include "solo6x10.h"
 
@@ -46,20 +46,18 @@
 #define TW286x_AUDIO_OUTPUT_VOL_ADDR		0xdf
 #define TW286x_AUDIO_INPUT_GAIN_ADDR(n)		(0xD0 + ((n > 1) ? 1 : 0))
 
-int solo_tw28_init(struct solo6010_dev *solo_dev);
+int solo_tw28_init(struct solo_dev *solo_dev);
 
-int tw28_set_ctrl_val(struct solo6010_dev *solo_dev, u32 ctrl, u8 ch,
-		      s32 val);
-int tw28_get_ctrl_val(struct solo6010_dev *solo_dev, u32 ctrl, u8 ch,
-		      s32 *val);
+int tw28_set_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch, s32 val);
+int tw28_get_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch, s32 *val);
 
-u8 tw28_get_audio_gain(struct solo6010_dev *solo_dev, u8 ch);
-void tw28_set_audio_gain(struct solo6010_dev *solo_dev, u8 ch, u8 val);
-int tw28_get_video_status(struct solo6010_dev *solo_dev, u8 ch);
+u8 tw28_get_audio_gain(struct solo_dev *solo_dev, u8 ch);
+void tw28_set_audio_gain(struct solo_dev *solo_dev, u8 ch, u8 val);
+int tw28_get_video_status(struct solo_dev *solo_dev, u8 ch);
 
 #if 0
-unsigned int tw2815_get_audio_status(struct SOLO6010 *solo6010);
-void tw2815_Set_AudioOutVol(struct SOLO6010 *solo6010, unsigned int u_val);
+unsigned int tw2815_get_audio_status(struct SOLO *solo);
+void tw2815_Set_AudioOutVol(struct SOLO *solo, unsigned int u_val);
 #endif
 
-#endif /* __SOLO6010_TW28_H */
+#endif /* __SOLO6X10_TW28_H */
diff --git a/drivers/staging/solo6x10/v4l2-enc.c b/drivers/staging/solo6x10/v4l2-enc.c
index 4c8d62d..542b43b 100644
--- a/drivers/staging/solo6x10/v4l2-enc.c
+++ b/drivers/staging/solo6x10/v4l2-enc.c
@@ -84,7 +84,7 @@ static const u32 *solo_ctrl_classes[] = {
 
 static int solo_is_motion_on(struct solo_enc_dev *solo_enc)
 {
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	u8 ch = solo_enc->ch;
 
 	if (solo_dev->motion_mask & (1 << ch))
@@ -94,7 +94,7 @@ static int solo_is_motion_on(struct solo_enc_dev *solo_enc)
 
 static void solo_motion_toggle(struct solo_enc_dev *solo_enc, int on)
 {
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	u8 ch = solo_enc->ch;
 
 	spin_lock(&solo_enc->lock);
@@ -114,9 +114,9 @@ static void solo_motion_toggle(struct solo_enc_dev *solo_enc, int on)
 		       (SOLO_MOTION_EXT_ADDR(solo_dev) >> 16));
 
 	if (solo_dev->motion_mask)
-		solo6010_irq_on(solo_dev, SOLO_IRQ_MOTION);
+		solo_irq_on(solo_dev, SOLO_IRQ_MOTION);
 	else
-		solo6010_irq_off(solo_dev, SOLO_IRQ_MOTION);
+		solo_irq_off(solo_dev, SOLO_IRQ_MOTION);
 
 	spin_unlock(&solo_enc->lock);
 }
@@ -124,7 +124,7 @@ static void solo_motion_toggle(struct solo_enc_dev *solo_enc, int on)
 /* Should be called with solo_enc->lock held */
 static void solo_update_mode(struct solo_enc_dev *solo_enc)
 {
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	assert_spin_locked(&solo_enc->lock);
 
@@ -151,7 +151,7 @@ static int solo_enc_on(struct solo_enc_fh *fh)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
 	u8 ch = solo_enc->ch;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	u8 interval;
 
 	assert_spin_locked(&solo_enc->lock);
@@ -212,7 +212,7 @@ static int solo_enc_on(struct solo_enc_fh *fh)
 static void solo_enc_off(struct solo_enc_fh *fh)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	if (!fh->enc_on)
 		return;
@@ -236,7 +236,7 @@ static int solo_start_fh_thread(struct solo_enc_fh *fh)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
 
-	fh->kthread = kthread_run(solo_enc_thread, fh, SOLO6010_NAME "_enc");
+	fh->kthread = kthread_run(solo_enc_thread, fh, SOLO6X10_NAME "_enc");
 
 	/* Oops, we had a problem */
 	if (IS_ERR(fh->kthread)) {
@@ -250,14 +250,14 @@ static int solo_start_fh_thread(struct solo_enc_fh *fh)
 	return 0;
 }
 
-static void enc_reset_gop(struct solo6010_dev *solo_dev, u8 ch)
+static void enc_reset_gop(struct solo_dev *solo_dev, u8 ch)
 {
 	BUG_ON(ch >= solo_dev->nr_chans);
 	solo_reg_write(solo_dev, SOLO_VE_CH_GOP(ch), 1);
 	solo_dev->v4l2_enc[ch]->reset_gop = 1;
 }
 
-static int enc_gop_reset(struct solo6010_dev *solo_dev, u8 ch, u8 vop)
+static int enc_gop_reset(struct solo_dev *solo_dev, u8 ch, u8 vop)
 {
 	BUG_ON(ch >= solo_dev->nr_chans);
 	if (!solo_dev->v4l2_enc[ch]->reset_gop)
@@ -285,7 +285,7 @@ static void enc_write_sg(struct scatterlist *sglist, void *buf, int size)
 	}
 }
 
-static int enc_get_mpeg_dma_sg(struct solo6010_dev *solo_dev,
+static int enc_get_mpeg_dma_sg(struct solo_dev *solo_dev,
 			       struct p2m_desc *desc,
 			       struct scatterlist *sglist, int skip,
 			       unsigned int off, unsigned int size)
@@ -314,7 +314,7 @@ static int enc_get_mpeg_dma_sg(struct solo6010_dev *solo_dev,
 	return ret;
 }
 
-static int enc_get_mpeg_dma_t(struct solo6010_dev *solo_dev,
+static int enc_get_mpeg_dma_t(struct solo_dev *solo_dev,
 			      dma_addr_t buf, unsigned int off,
 			      unsigned int size)
 {
@@ -341,7 +341,7 @@ static int enc_get_mpeg_dma_t(struct solo6010_dev *solo_dev,
 	return ret;
 }
 
-static int enc_get_mpeg_dma(struct solo6010_dev *solo_dev, void *buf,
+static int enc_get_mpeg_dma(struct solo_dev *solo_dev, void *buf,
 			    unsigned int off, unsigned int size)
 {
 	int ret;
@@ -354,7 +354,7 @@ static int enc_get_mpeg_dma(struct solo6010_dev *solo_dev, void *buf,
 	return ret;
 }
 
-static int enc_get_jpeg_dma_sg(struct solo6010_dev *solo_dev,
+static int enc_get_jpeg_dma_sg(struct solo_dev *solo_dev,
 			       struct p2m_desc *desc,
 			       struct scatterlist *sglist, int skip,
 			       unsigned int off, unsigned int size)
@@ -421,7 +421,7 @@ static int solo_fill_jpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
 			  struct videobuf_buffer *vb,
 			  struct videobuf_dmabuf *vbuf)
 {
-	struct solo6010_dev *solo_dev = fh->enc->solo_dev;
+	struct solo_dev *solo_dev = fh->enc->solo_dev;
 	int size = enc_buf->jpeg_size;
 
 	/* Copy the header first (direct write) */
@@ -515,7 +515,7 @@ static void write_h264_end(u8 **out, unsigned *bits, int align)
 			write_bits(out, bits, 0, 1);
 }
 
-static void mpeg4_write_vol(u8 **out, struct solo6010_dev *solo_dev,
+static void mpeg4_write_vol(u8 **out, struct solo_dev *solo_dev,
 			    __le32 *vh, unsigned fps, unsigned interval)
 {
 	static const u8 hdr[] = {
@@ -569,7 +569,7 @@ static void mpeg4_write_vol(u8 **out, struct solo6010_dev *solo_dev,
 	write_mpeg4_end(out, &bits);
 }
 
-static void h264_write_vol(u8 **out, struct solo6010_dev *solo_dev, __le32 *vh)
+static void h264_write_vol(u8 **out, struct solo_dev *solo_dev, __le32 *vh)
 {
 	static const u8 sps[] = {
 		0, 0, 0, 1 /* start code */, 0x67, 66 /* profile_idc */,
@@ -622,7 +622,7 @@ static int solo_fill_mpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
 			  struct videobuf_dmabuf *vbuf)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 #define VH_WORDS 16
 #define MAX_VOL_HEADER_LENGTH 64
@@ -678,7 +678,7 @@ static void solo_enc_fillbuf(struct solo_enc_fh *fh,
 			    struct videobuf_buffer *vb)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct solo_enc_buf *enc_buf = NULL;
 	struct videobuf_dmabuf *vbuf;
 	int ret;
@@ -746,7 +746,7 @@ buf_err:
 static void solo_enc_thread_try(struct solo_enc_fh *fh)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct videobuf_buffer *vb;
 
 	for (;;) {
@@ -797,7 +797,7 @@ static int solo_enc_thread(void *data)
 	return 0;
 }
 
-void solo_motion_isr(struct solo6010_dev *solo_dev)
+void solo_motion_isr(struct solo_dev *solo_dev)
 {
 	u32 status;
 	int i;
@@ -820,7 +820,7 @@ void solo_motion_isr(struct solo6010_dev *solo_dev)
 	}
 }
 
-void solo_enc_v4l2_isr(struct solo6010_dev *solo_dev)
+void solo_enc_v4l2_isr(struct solo_dev *solo_dev)
 {
 	struct solo_enc_buf *enc_buf;
 	u32 mpeg_current, mpeg_next, mpeg_size;
@@ -1056,14 +1056,14 @@ static int solo_enc_querycap(struct file *file, void  *priv,
 {
 	struct solo_enc_fh *fh = priv;
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	strcpy(cap->driver, SOLO6010_NAME);
-	snprintf(cap->card, sizeof(cap->card), "Softlogic 6010 Enc %d",
+	strcpy(cap->driver, SOLO6X10_NAME);
+	snprintf(cap->card, sizeof(cap->card), "Softlogic 6x10 Enc %d",
 		 solo_enc->ch);
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI %s",
 		 pci_name(solo_dev->pdev));
-	cap->version = SOLO6010_VER_NUM;
+	cap->version = SOLO6X10_VER_NUM;
 	cap->capabilities =     V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_READWRITE |
 				V4L2_CAP_STREAMING;
@@ -1075,7 +1075,7 @@ static int solo_enc_enum_input(struct file *file, void *priv,
 {
 	struct solo_enc_fh *fh = priv;
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	if (input->index)
 		return -EINVAL;
@@ -1137,7 +1137,7 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 {
 	struct solo_enc_fh *fh = priv;
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	if (pix->pixelformat != V4L2_PIX_FMT_MPEG &&
@@ -1179,7 +1179,7 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 {
 	struct solo_enc_fh *fh = priv;
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
@@ -1335,7 +1335,7 @@ static int solo_enum_framesizes(struct file *file, void *priv,
 				struct v4l2_frmsizeenum *fsize)
 {
 	struct solo_enc_fh *fh = priv;
-	struct solo6010_dev *solo_dev = fh->enc->solo_dev;
+	struct solo_dev *solo_dev = fh->enc->solo_dev;
 
 	if (fsize->pixel_format != V4L2_PIX_FMT_MPEG)
 		return -EINVAL;
@@ -1362,7 +1362,7 @@ static int solo_enum_frameintervals(struct file *file, void *priv,
 				    struct v4l2_frmivalenum *fintv)
 {
 	struct solo_enc_fh *fh = priv;
-	struct solo6010_dev *solo_dev = fh->enc->solo_dev;
+	struct solo_dev *solo_dev = fh->enc->solo_dev;
 
 	if (fintv->pixel_format != V4L2_PIX_FMT_MPEG || fintv->index)
 		return -EINVAL;
@@ -1386,7 +1386,7 @@ static int solo_g_parm(struct file *file, void *priv,
 {
 	struct solo_enc_fh *fh = priv;
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
 	cp->capability = V4L2_CAP_TIMEPERFRAME;
@@ -1404,7 +1404,7 @@ static int solo_s_parm(struct file *file, void *priv,
 {
 	struct solo_enc_fh *fh = priv;
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
 	spin_lock(&solo_enc->lock);
@@ -1444,7 +1444,7 @@ static int solo_queryctrl(struct file *file, void *priv,
 {
 	struct solo_enc_fh *fh = priv;
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	qc->id = v4l2_ctrl_next(solo_ctrl_classes, qc->id);
 	if (!qc->id)
@@ -1522,7 +1522,7 @@ static int solo_g_ctrl(struct file *file, void *priv,
 {
 	struct solo_enc_fh *fh = priv;
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
@@ -1556,7 +1556,7 @@ static int solo_s_ctrl(struct file *file, void *priv,
 {
 	struct solo_enc_fh *fh = priv;
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo6010_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
@@ -1714,7 +1714,7 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 };
 
 static struct video_device solo_enc_template = {
-	.name			= SOLO6010_NAME,
+	.name			= SOLO6X10_NAME,
 	.fops			= &solo_enc_fops,
 	.ioctl_ops		= &solo_enc_ioctl_ops,
 	.minor			= -1,
@@ -1724,7 +1724,7 @@ static struct video_device solo_enc_template = {
 	.current_norm		= V4L2_STD_NTSC_M,
 };
 
-static struct solo_enc_dev *solo_enc_alloc(struct solo6010_dev *solo_dev, u8 ch)
+static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 {
 	struct solo_enc_dev *solo_enc;
 	int ret;
@@ -1755,7 +1755,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo6010_dev *solo_dev, u8 ch)
 	video_set_drvdata(solo_enc->vfd, solo_enc);
 
 	snprintf(solo_enc->vfd->name, sizeof(solo_enc->vfd->name),
-		 "%s-enc (%i/%i)", SOLO6010_NAME, solo_dev->vfd->num,
+		 "%s-enc (%i/%i)", SOLO6X10_NAME, solo_dev->vfd->num,
 		 solo_enc->vfd->num);
 
 	if (video_nr != -1)
@@ -1787,7 +1787,7 @@ static void solo_enc_free(struct solo_enc_dev *solo_enc)
 	kfree(solo_enc);
 }
 
-int solo_enc_v4l2_init(struct solo6010_dev *solo_dev)
+int solo_enc_v4l2_init(struct solo_dev *solo_dev)
 {
 	int i;
 
@@ -1814,11 +1814,11 @@ int solo_enc_v4l2_init(struct solo6010_dev *solo_dev)
 	return 0;
 }
 
-void solo_enc_v4l2_exit(struct solo6010_dev *solo_dev)
+void solo_enc_v4l2_exit(struct solo_dev *solo_dev)
 {
 	int i;
 
-	solo6010_irq_off(solo_dev, SOLO_IRQ_MOTION);
+	solo_irq_off(solo_dev, SOLO_IRQ_MOTION);
 
 	for (i = 0; i < solo_dev->nr_chans; i++)
 		solo_enc_free(solo_dev->v4l2_enc[i]);
diff --git a/drivers/staging/solo6x10/v4l2.c b/drivers/staging/solo6x10/v4l2.c
index e9d620a..571c3a3 100644
--- a/drivers/staging/solo6x10/v4l2.c
+++ b/drivers/staging/solo6x10/v4l2.c
@@ -40,7 +40,7 @@
 
 /* Simple file handle */
 struct solo_filehandle {
-	struct solo6010_dev	*solo_dev;
+	struct solo_dev		*solo_dev;
 	struct videobuf_queue	vidq;
 	struct task_struct      *kthread;
 	spinlock_t		slock;
@@ -54,14 +54,14 @@ unsigned video_nr = -1;
 module_param(video_nr, uint, 0644);
 MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect (default)");
 
-static void erase_on(struct solo6010_dev *solo_dev)
+static void erase_on(struct solo_dev *solo_dev)
 {
 	solo_reg_write(solo_dev, SOLO_VO_DISP_ERASE, SOLO_VO_DISP_ERASE_ON);
 	solo_dev->erasing = 1;
 	solo_dev->frame_blank = 0;
 }
 
-static int erase_off(struct solo6010_dev *solo_dev)
+static int erase_off(struct solo_dev *solo_dev)
 {
 	if (!solo_dev->erasing)
 		return 0;
@@ -76,13 +76,13 @@ static int erase_off(struct solo6010_dev *solo_dev)
 	return 1;
 }
 
-void solo_video_in_isr(struct solo6010_dev *solo_dev)
+void solo_video_in_isr(struct solo_dev *solo_dev)
 {
 	solo_reg_write(solo_dev, SOLO_IRQ_STAT, SOLO_IRQ_VIDEO_IN);
 	wake_up_interruptible(&solo_dev->disp_thread_wait);
 }
 
-static void solo_win_setup(struct solo6010_dev *solo_dev, u8 ch,
+static void solo_win_setup(struct solo_dev *solo_dev, u8 ch,
 			   int sx, int sy, int ex, int ey, int scale)
 {
 	if (ch >= solo_dev->nr_chans)
@@ -100,7 +100,7 @@ static void solo_win_setup(struct solo6010_dev *solo_dev, u8 ch,
 		       SOLO_VI_WIN_EY(ey));
 }
 
-static int solo_v4l2_ch_ext_4up(struct solo6010_dev *solo_dev, u8 idx, int on)
+static int solo_v4l2_ch_ext_4up(struct solo_dev *solo_dev, u8 idx, int on)
 {
 	u8 ch = idx * 4;
 
@@ -132,7 +132,7 @@ static int solo_v4l2_ch_ext_4up(struct solo6010_dev *solo_dev, u8 idx, int on)
 	return 0;
 }
 
-static int solo_v4l2_ch_ext_16up(struct solo6010_dev *solo_dev, int on)
+static int solo_v4l2_ch_ext_16up(struct solo_dev *solo_dev, int on)
 {
 	int sy, ysize, hsize, i;
 
@@ -162,7 +162,7 @@ static int solo_v4l2_ch_ext_16up(struct solo6010_dev *solo_dev, int on)
 	return 0;
 }
 
-static int solo_v4l2_ch(struct solo6010_dev *solo_dev, u8 ch, int on)
+static int solo_v4l2_ch(struct solo_dev *solo_dev, u8 ch, int on)
 {
 	u8 ext_ch;
 
@@ -187,7 +187,7 @@ static int solo_v4l2_ch(struct solo6010_dev *solo_dev, u8 ch, int on)
 	return solo_v4l2_ch_ext_16up(solo_dev, on);
 }
 
-static int solo_v4l2_set_ch(struct solo6010_dev *solo_dev, u8 ch)
+static int solo_v4l2_set_ch(struct solo_dev *solo_dev, u8 ch)
 {
 	if (ch >= solo_dev->nr_chans + solo_dev->nr_ext)
 		return -EINVAL;
@@ -242,7 +242,7 @@ static int disp_push_desc(struct solo_filehandle *fh, dma_addr_t dma_addr,
 static void solo_fillbuf(struct solo_filehandle *fh,
 			 struct videobuf_buffer *vb)
 {
-	struct solo6010_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = fh->solo_dev;
 	struct videobuf_dmabuf *vbuf;
 	unsigned int fdma_addr;
 	int error = 1;
@@ -392,7 +392,7 @@ static void solo_thread_try(struct solo_filehandle *fh)
 static int solo_thread(void *data)
 {
 	struct solo_filehandle *fh = data;
-	struct solo6010_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = fh->solo_dev;
 	DECLARE_WAITQUEUE(wait, current);
 
 	set_freezable();
@@ -413,7 +413,7 @@ static int solo_thread(void *data)
 
 static int solo_start_thread(struct solo_filehandle *fh)
 {
-	fh->kthread = kthread_run(solo_thread, fh, SOLO6010_NAME "_disp");
+	fh->kthread = kthread_run(solo_thread, fh, SOLO6X10_NAME "_disp");
 
 	if (IS_ERR(fh->kthread))
 		return PTR_ERR(fh->kthread);
@@ -433,7 +433,7 @@ static int solo_buf_setup(struct videobuf_queue *vq, unsigned int *count,
 			  unsigned int *size)
 {
 	struct solo_filehandle *fh = vq->priv_data;
-	struct solo6010_dev *solo_dev  = fh->solo_dev;
+	struct solo_dev *solo_dev  = fh->solo_dev;
 
 	*size = solo_image_size(solo_dev);
 
@@ -447,7 +447,7 @@ static int solo_buf_prepare(struct videobuf_queue *vq,
 			    struct videobuf_buffer *vb, enum v4l2_field field)
 {
 	struct solo_filehandle *fh  = vq->priv_data;
-	struct solo6010_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = fh->solo_dev;
 
 	vb->size = solo_image_size(solo_dev);
 	if (vb->baddr != 0 && vb->bsize < vb->size)
@@ -478,7 +478,7 @@ static void solo_buf_queue(struct videobuf_queue *vq,
 			   struct videobuf_buffer *vb)
 {
 	struct solo_filehandle *fh = vq->priv_data;
-	struct solo6010_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = fh->solo_dev;
 
 	vb->state = VIDEOBUF_QUEUED;
 	list_add_tail(&vb->queue, &fh->vidq_active);
@@ -519,7 +519,7 @@ static int solo_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 
 static int solo_v4l2_open(struct file *file)
 {
-	struct solo6010_dev *solo_dev = video_drvdata(file);
+	struct solo_dev *solo_dev = video_drvdata(file);
 	struct solo_filehandle *fh;
 	int ret;
 
@@ -572,20 +572,20 @@ static int solo_querycap(struct file *file, void  *priv,
 			 struct v4l2_capability *cap)
 {
 	struct solo_filehandle  *fh  = priv;
-	struct solo6010_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = fh->solo_dev;
 
-	strcpy(cap->driver, SOLO6010_NAME);
-	strcpy(cap->card, "Softlogic 6010");
+	strcpy(cap->driver, SOLO6X10_NAME);
+	strcpy(cap->card, "Softlogic 6x10");
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI %s",
 		 pci_name(solo_dev->pdev));
-	cap->version = SOLO6010_VER_NUM;
+	cap->version = SOLO6X10_VER_NUM;
 	cap->capabilities =     V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_READWRITE |
 				V4L2_CAP_STREAMING;
 	return 0;
 }
 
-static int solo_enum_ext_input(struct solo6010_dev *solo_dev,
+static int solo_enum_ext_input(struct solo_dev *solo_dev,
 			       struct v4l2_input *input)
 {
 	static const char *dispnames_1[] = { "4UP" };
@@ -615,7 +615,7 @@ static int solo_enum_input(struct file *file, void *priv,
 			   struct v4l2_input *input)
 {
 	struct solo_filehandle *fh  = priv;
-	struct solo6010_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = fh->solo_dev;
 
 	if (input->index >= solo_dev->nr_chans) {
 		int ret = solo_enum_ext_input(solo_dev, input);
@@ -672,7 +672,7 @@ static int solo_try_fmt_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
 	struct solo_filehandle *fh = priv;
-	struct solo6010_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = fh->solo_dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int image_size = solo_image_size(solo_dev);
 
@@ -713,7 +713,7 @@ static int solo_get_fmt_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
 	struct solo_filehandle *fh = priv;
-	struct solo6010_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = fh->solo_dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	pix->width = solo_dev->video_hsize;
@@ -819,7 +819,7 @@ static int solo_disp_g_ctrl(struct file *file, void *priv,
 			    struct v4l2_control *ctrl)
 {
 	struct solo_filehandle *fh = priv;
-	struct solo6010_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = fh->solo_dev;
 
 	switch (ctrl->id) {
 	case V4L2_CID_MOTION_TRACE:
@@ -834,7 +834,7 @@ static int solo_disp_s_ctrl(struct file *file, void *priv,
 			    struct v4l2_control *ctrl)
 {
 	struct solo_filehandle *fh = priv;
-	struct solo6010_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = fh->solo_dev;
 
 	switch (ctrl->id) {
 	case V4L2_CID_MOTION_TRACE:
@@ -894,7 +894,7 @@ static const struct v4l2_ioctl_ops solo_v4l2_ioctl_ops = {
 };
 
 static struct video_device solo_v4l2_template = {
-	.name			= SOLO6010_NAME,
+	.name			= SOLO6X10_NAME,
 	.fops			= &solo_v4l2_fops,
 	.ioctl_ops		= &solo_v4l2_ioctl_ops,
 	.minor			= -1,
@@ -904,7 +904,7 @@ static struct video_device solo_v4l2_template = {
 	.current_norm		= V4L2_STD_NTSC_M,
 };
 
-int solo_v4l2_init(struct solo6010_dev *solo_dev)
+int solo_v4l2_init(struct solo_dev *solo_dev)
 {
 	int ret;
 	int i;
@@ -928,7 +928,7 @@ int solo_v4l2_init(struct solo6010_dev *solo_dev)
 	video_set_drvdata(solo_dev->vfd, solo_dev);
 
 	snprintf(solo_dev->vfd->name, sizeof(solo_dev->vfd->name), "%s (%i)",
-		 SOLO6010_NAME, solo_dev->vfd->num);
+		 SOLO6X10_NAME, solo_dev->vfd->num);
 
 	if (video_nr != -1)
 		video_nr++;
@@ -949,14 +949,14 @@ int solo_v4l2_init(struct solo6010_dev *solo_dev)
 	while (erase_off(solo_dev))
 		;/* Do nothing */
 
-	solo6010_irq_on(solo_dev, SOLO_IRQ_VIDEO_IN);
+	solo_irq_on(solo_dev, SOLO_IRQ_VIDEO_IN);
 
 	return 0;
 }
 
-void solo_v4l2_exit(struct solo6010_dev *solo_dev)
+void solo_v4l2_exit(struct solo_dev *solo_dev)
 {
-	solo6010_irq_off(solo_dev, SOLO_IRQ_VIDEO_IN);
+	solo_irq_off(solo_dev, SOLO_IRQ_VIDEO_IN);
 	if (solo_dev->vfd) {
 		video_unregister_device(solo_dev->vfd);
 		solo_dev->vfd = NULL;

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
