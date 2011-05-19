Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab1ESQbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:31:38 -0400
Received: from postkast.cyber.ee ([195.50.202.7]:58305 "EHLO postkast.cyber.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab1ESQbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:31:37 -0400
Date: Thu, 19 May 2011 19:31:36 +0300 (EEST)
From: Madis Janson <madis@cyber.ee>
X-X-Sender: madis@paabel.itsise
To: Takashi Iwai <tiwai@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable Realtek ALC269 codec input layer beep
In-Reply-To: <s5htycqu0j8.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.2.00.1105191925570.2046@paabel.itsise>
References: <alpine.DEB.2.00.1105191717530.2046@paabel.itsise> <s5htycqu0j8.wl%tiwai@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Respect: HAZ NONE
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 19 May 2011, Takashi Iwai wrote:

> The change look good, but could you give your sign-off?
> See Documentation/SubmittingPatches section 12 "Sign your work" for
> details.
>
> Also, at the next time, please try to send the patch to the
> corresponding subsystem maintainers.  scripts/get_maintainer.pl is
> your friend.

Ok. Would this sign-off suffice? :)
---

This fixes the input layer beep not working on some EeePC 1000 models by
adding the subsystem id into whitelist. Otherwise the corresponding ALSA
mixer is not enabled and stays muted, resulting in no console beep.

Signed-off-by: Madis Janson <madis@cyber.ee>

diff -u linux-2.6.39/sound/pci/hda/patch_realtek.c lohe-2.6.39/sound/pci/hda/patch_realtek.c
--- linux-2.6.39/sound/pci/hda/patch_realtek.c	2011-05-19 07:06:34.000000000 +0300
+++ lohe-2.6.39/sound/pci/hda/patch_realtek.c	2011-05-19 11:58:28.415669828 +0300
@@ -5646,6 +5646,7 @@
  	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
  	SND_PCI_QUIRK(0x1043, 0x83ce, "EeePC", 1),
  	SND_PCI_QUIRK(0x1043, 0x831a, "EeePC", 1),
+	SND_PCI_QUIRK(0x1043, 0x834a, "EeePC", 1),
  	SND_PCI_QUIRK(0x8086, 0xd613, "Intel", 1),
  	{}
  };

