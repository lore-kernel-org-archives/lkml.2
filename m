Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0LHBmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:42:32 -0500
Received: from kroah.org ([198.145.64.141]:48809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081Ab0LHBAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:33 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:31 2010
Message-Id: <20101208005731.054610671@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [097/289] ALSA: hda: Use hp-laptop quirk to enable headphones automute for Asus A52J
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 673f7a8984c3a9e2cb1108ce221da1ebbd9e5d09 upstream.

BugLink: https://launchpad.net/bugs/677652

The original reporter states that, in 2.6.35, headphones do not appear
to work, nor does inserting them mute the A52J's onboard speakers.  Upon
inspecting the codec dump, it appears that the newly committed hp-laptop
quirk will suffice to enable this basic functionality.  Testing was done
with an alsa-driver build from 2010-11-21.

Reported-and-tested-by: Joan Creus
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3092,6 +3092,7 @@ static struct snd_pci_quirk cxt5066_cfg_
 	SND_PCI_QUIRK(0x1028, 0x0402, "Dell Vostro", CXT5066_DELL_VOSTO),
 	SND_PCI_QUIRK(0x1028, 0x0408, "Dell Inspiron One 19T", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x103c, 0x360b, "HP G60", CXT5066_HP_LAPTOP),
+	SND_PCI_QUIRK(0x1043, 0x13f3, "Asus A52J", CXT5066_HP_LAPTOP),
 	SND_PCI_QUIRK(0x1179, 0xff1e, "Toshiba Satellite C650D", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x1179, 0xff50, "Toshiba Satellite P500-PSPGSC-01800T", CXT5066_OLPC_XO_1_5),
 	SND_PCI_QUIRK(0x1179, 0xffe0, "Toshiba Satellite Pro T130-15F", CXT5066_OLPC_XO_1_5),


