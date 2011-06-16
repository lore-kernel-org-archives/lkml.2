Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab1FPHOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:14:50 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57600 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932068Ab1FPHL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:26 -0400
X-Sasl-enc: HvXdl5PmOhtd0yAPzjI/ZwhTIAieA7MA/AryeEVSfVWr 1308208284
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:11 2011
Message-Id: <20110616002911.071255932@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [72/85] ALSA: hda: Fix quirk for Dell Inspiron 910
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 0a1896b27b030529ec770aefd790544a1bdb7d5a upstream.

BugLink: https://launchpad.net/bugs/792712

The original reporter states that sound from the internal speakers is
inaudible until using the model=auto quirk. This symptom is due to an
existing quirk mask for 0x102802b* that uses the model=dell quirk. To
limit the possible regressions, leave the existing quirk mask but add
a higher priority specific mask for the reporter's PCI SSID.

Reported-and-tested-by: rodni hipp
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12824,6 +12824,7 @@ static struct snd_pci_quirk alc268_cfg_t
 	SND_PCI_QUIRK(0x1025, 0x015b, "Acer Aspire One",
 						ALC268_ACER_ASPIRE_ONE),
 	SND_PCI_QUIRK(0x1028, 0x0253, "Dell OEM", ALC268_DELL),
+	SND_PCI_QUIRK(0x1028, 0x02b0, "Dell Inspiron 910", ALC268_AUTO),
 	SND_PCI_QUIRK_MASK(0x1028, 0xfff0, 0x02b0,
 			"Dell Inspiron Mini9/Vostro A90", ALC268_DELL),
 	/* almost compatible with toshiba but with optional digital outs;


