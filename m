Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab1ELUSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:18:20 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41562 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758590Ab1ELUSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:18:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH 2/3] tea575x: remove unused card from struct
Date: Thu, 12 May 2011 22:18:09 +0200
User-Agent: KMail/1.9.10
Cc: linux-media@vger.kernel.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105122218.11969.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct snd_card *card is present in struct snd_tea575x but never used.
Remove it.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/include/sound/tea575x-tuner.h	2011-05-12 21:22:35.000000000 +0200
+++ linux-2.6.39-rc2/include/sound/tea575x-tuner.h	2011-05-12 21:21:37.000000000 +0200
@@ -42,7 +42,6 @@ struct snd_tea575x_ops {
 };
 
 struct snd_tea575x {
-	struct snd_card *card;
 	struct video_device *vd;	/* video device */
 	bool tea5759;			/* 5759 chip is present */
 	bool mute;			/* Device is muted? */
--- linux-2.6.39-rc2-/sound/pci/es1968.c	2011-05-12 21:22:35.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/es1968.c	2011-05-12 21:22:09.000000000 +0200
@@ -2793,7 +2793,6 @@ static int __devinit snd_es1968_create(s
 	snd_card_set_dev(card, &pci->dev);
 
 #ifdef CONFIG_SND_ES1968_RADIO
-	chip->tea.card = card;
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_es1968_tea_ops;
 	if (!snd_tea575x_init(&chip->tea))
--- linux-2.6.39-rc2-/sound/pci/fm801.c	2011-05-12 21:22:35.000000000 +0200
+++ linux-2.6.39-rc2/sound/pci/fm801.c	2011-05-12 21:22:05.000000000 +0200
@@ -1230,7 +1230,6 @@ static int __devinit snd_fm801_create(st
 	snd_card_set_dev(card, &pci->dev);
 
 #ifdef TEA575X_RADIO
-	chip->tea.card = card;
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_fm801_tea_ops;
 	if ((tea575x_tuner & TUNER_TYPE_MASK) > 0 &&


-- 
Ondrej Zary
