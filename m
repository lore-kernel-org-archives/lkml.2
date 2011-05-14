Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab1ENUvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 16:51:11 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:59094 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754614Ab1ENUvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 16:51:10 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH v2] fm801: clean-up radio-related Kconfig
Date: Sat, 14 May 2011 22:51:01 +0200
User-Agent: KMail/1.9.10
Cc: alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
References: <201105132026.40643.linux@rainbow-software.org> <s5hiptd4nrp.wl%tiwai@suse.de>
In-Reply-To: <s5hiptd4nrp.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105142251.03823.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove TEA575X_RADIO define from fm801.c.
Also update Kconfig help text to include all supported cards.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/sound/pci/Kconfig	2011-05-14 22:22:11.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/Kconfig	2011-05-14 22:24:29.000000000 +0200
@@ -560,8 +560,8 @@ config SND_FM801_TEA575X_BOOL
 	depends on VIDEO_V4L2=y || VIDEO_V4L2=SND_FM801
 	help
 	  Say Y here to include support for soundcards based on the ForteMedia
-	  FM801 chip with a TEA5757 tuner connected to GPIO1-3 pins (Media
-	  Forte SF256-PCS-02) into the snd-fm801 driver.
+	  FM801 chip with a TEA5757 tuner (MediaForte SF256-PCS, SF256-PCP and
+	  SF64-PCR) into the snd-fm801 driver.
 
 config SND_TEA575X
 	tristate
--- linux-2.6.39-rc2-/sound/pci/fm801.c	2011-05-14 22:22:11.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/fm801.c	2011-05-14 22:26:01.000000000 +0200
@@ -38,7 +38,6 @@
 
 #ifdef CONFIG_SND_FM801_TEA575X_BOOL
 #include <sound/tea575x-tuner.h>
-#define TEA575X_RADIO 1
 #endif
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
@@ -196,7 +195,7 @@ struct fm801 {
 	spinlock_t reg_lock;
 	struct snd_info_entry *proc_entry;
 
-#ifdef TEA575X_RADIO
+#ifdef CONFIG_SND_FM801_TEA575X_BOOL
 	struct snd_tea575x tea;
 #endif
 
@@ -715,7 +714,7 @@ static int __devinit snd_fm801_pcm(struc
  *  TEA5757 radio
  */
 
-#ifdef TEA575X_RADIO
+#ifdef CONFIG_SND_FM801_TEA575X_BOOL
 
 /* GPIO to TEA575x maps */
 struct snd_fm801_tea575x_gpio {
@@ -1150,7 +1149,7 @@ static int snd_fm801_free(struct fm801 *
 	outw(cmdw, FM801_REG(chip, IRQ_MASK));
 
       __end_hw:
-#ifdef TEA575X_RADIO
+#ifdef CONFIG_SND_FM801_TEA575X_BOOL
 	snd_tea575x_exit(&chip->tea);
 #endif
 	if (chip->irq >= 0)
@@ -1229,7 +1228,7 @@ static int __devinit snd_fm801_create(st
 
 	snd_card_set_dev(card, &pci->dev);
 
-#ifdef TEA575X_RADIO
+#ifdef CONFIG_SND_FM801_TEA575X_BOOL
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_fm801_tea_ops;
 	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));


-- 
Ondrej Zary
