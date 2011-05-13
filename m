Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab1EMS0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:26:50 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:46156 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755731Ab1EMS0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:26:48 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH] fm801: clean-up radio-related Kconfig
Date: Fri, 13 May 2011 20:26:38 +0200
User-Agent: KMail/1.9.10
Cc: linux-media@vger.kernel.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105132026.40643.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the weird SND_FM801_TEA575X_BOOL define in Kconfig to SND_FM801_RADIO
and remove TEA575X_RADIO define from fm801.c.
Also update help text to include all supported cards.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/sound/pci/Kconfig	2011-05-13 19:36:27.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/Kconfig	2011-05-13 19:23:00.000000000 +0200
@@ -554,18 +554,18 @@ config SND_FM801
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-fm801.
 
-config SND_FM801_TEA575X_BOOL
+config SND_FM801_RADIO
 	bool "ForteMedia FM801 + TEA5757 tuner"
 	depends on SND_FM801
 	depends on VIDEO_V4L2=y || VIDEO_V4L2=SND_FM801
 	help
 	  Say Y here to include support for soundcards based on the ForteMedia
-	  FM801 chip with a TEA5757 tuner connected to GPIO1-3 pins (Media
-	  Forte SF256-PCS-02) into the snd-fm801 driver.
+	  FM801 chip with a TEA5757 tuner (MediaForte SF256-PCS, SF256-PCP and
+	  SF64-PCR) into the snd-fm801 driver.
 
 config SND_TEA575X
 	tristate
-	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO
+	depends on SND_FM801_RADIO || SND_ES1968_RADIO
 	default SND_FM801 || SND_ES1968
 
 source "sound/pci/hda/Kconfig"
--- linux-2.6.39-rc2-/sound/pci/fm801.c	2011-05-13 19:39:23.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/fm801.c	2011-05-13 19:22:20.000000000 +0200
@@ -36,9 +36,8 @@
 
 #include <asm/io.h>
 
-#ifdef CONFIG_SND_FM801_TEA575X_BOOL
+#ifdef CONFIG_SND_FM801_RADIO
 #include <sound/tea575x-tuner.h>
-#define TEA575X_RADIO 1
 #endif
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
@@ -196,7 +195,7 @@ struct fm801 {
 	spinlock_t reg_lock;
 	struct snd_info_entry *proc_entry;
 
-#ifdef TEA575X_RADIO
+#ifdef CONFIG_SND_FM801_RADIO
 	struct snd_tea575x tea;
 #endif
 
@@ -715,7 +714,7 @@ static int __devinit snd_fm801_pcm(struc
  *  TEA5757 radio
  */
 
-#ifdef TEA575X_RADIO
+#ifdef CONFIG_SND_FM801_RADIO
 
 /* GPIO to TEA575x maps */
 struct snd_fm801_tea575x_gpio {
@@ -1150,7 +1149,7 @@ static int snd_fm801_free(struct fm801 *
 	outw(cmdw, FM801_REG(chip, IRQ_MASK));
 
       __end_hw:
-#ifdef TEA575X_RADIO
+#ifdef CONFIG_SND_FM801_RADIO
 	snd_tea575x_exit(&chip->tea);
 #endif
 	if (chip->irq >= 0)
@@ -1229,7 +1228,7 @@ static int __devinit snd_fm801_create(st
 
 	snd_card_set_dev(card, &pci->dev);
 
-#ifdef TEA575X_RADIO
+#ifdef CONFIG_SND_FM801_RADIO
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_fm801_tea_ops;
 	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));


-- 
Ondrej Zary
