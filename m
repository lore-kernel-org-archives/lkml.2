Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0GELU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 07:20:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55320 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0GELU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 07:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YF6oUPeW1mA+DKq6+s5ZZuj9ym3Gmks8WD3hQrjg7Q5N0kWCPidT7OGaSepXjWqPfZ
         aMo1zguCB/Tcgw0l5Ib0lRTIuBx2PCLGuSt7aW+fLqyjvUEbvwJrYbMnCOB/OI0T/1aX
         AysveMG2ZBe3uqDAroFH/xg4F+DACDtq3J56s=
MIME-Version: 1.0
Date: Mon, 5 Jul 2010 12:20:24 +0100
Message-ID: <AANLkTild_NZP5B33ITuaS67bvuREiukbQCtcguKEO4XG@mail.gmail.com>
Subject: re: PC Beeps not working with HDA Intel module
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: =?ISO-8859-1?B?U2jpcmFi?= <Sebastien.Hinderer@ens-lyon.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 26, 12:40 pm, Shérab <Sebastien.Hinderer@ens-lyon.org> wrote:
> Dear all,
>
> The problem is on a computer with an HDA Intel sound card, Intel G45
> DEVCTG chip and appears will all version s of the kernel.
>
> Running e.g.
> beep 440
> produces a beep whose audible frequency is very low, definitely not 440
> Hz.
>
> However, it is worth notiing that grub is able to produce a beep of the
> right frequency at boot time.
>
> Can this problem be fixed ?
>
> Should you need any additional bit of information or testing, please ask.

I was finding the same with my Dell Studio 1557.

It may be worth using some printk calls [1] showing what frequency
value is sent to the codec, then checking with the codec datasheet -
we'll need to know which one, eg from 'dmesg' or 'alsa-info.sh' (from
http://www.alsa-project.org/alsa-info.sh).

We'll probably need to check the configuration registers of the beep
widget to check what divider it's using...

Thanks,
  Daniel

--- [1]

diff --git a/sound/pci/hda/hda_beep.c b/sound/pci/hda/hda_beep.c
index 29714c8..98d0d6c 100644
--- a/sound/pci/hda/hda_beep.c
+++ b/sound/pci/hda/hda_beep.c
@@ -69,6 +69,7 @@ static int beep_linear_tone(struct hda_beep *beep, int hz)
 		hz /= DIGBEEP_HZ_STEP;
 		hz = 255 - hz;
 	}
+	printk(KERN_ERR "HDA beep: linear value %d\n", hz);
 	return hz;
 }

@@ -87,6 +88,7 @@ static int beep_standard_tone(struct hda_beep *beep, int hz)
 		return 0xff;
 	if (hz <= 0)
 		return 1;
+	printk(KERN_ERR "HDA beep: standard value %d\n", hz);
 	return hz;
 }

-- 
Daniel J Blueman
