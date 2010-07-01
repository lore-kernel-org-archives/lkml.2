Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab0GASiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:38:00 -0400
Received: from kroah.org ([198.145.64.141]:40615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757991Ab0GASXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:47 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:14 2010
Message-Id: <20100701173214.316070109@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 089/149] ALSA: hda: Use mb31 quirk for an iMac model
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 26fd74fc01991a18f0e3bd54f8b1b75945ee3dbb upstream.

BugLink: https://launchpad.net/bugs/542550

Symptom: On the reporter's iMac, in Ubuntu 10.04 LTS neither playback
nor capture appear audible out-of-the-box.

Test case: Boot from an Ubuntu 10.04 LTS live cd or from an installed
configuration and attempt to play or capture audio.

Resolution: Specify the mb31 quirk for this machine in the codec SSID
table.

Reported-and-Tested-By: f3a97
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8937,6 +8937,7 @@ static struct snd_pci_quirk alc882_ssid_
 	SND_PCI_QUIRK(0x106b, 0x1000, "iMac 24", ALC885_IMAC24),
 	SND_PCI_QUIRK(0x106b, 0x2800, "AppleTV", ALC885_IMAC24),
 	SND_PCI_QUIRK(0x106b, 0x2c00, "MacbookPro rev3", ALC885_MBP3),
+	SND_PCI_QUIRK(0x106b, 0x3000, "iMac", ALC889A_MB31),
 	SND_PCI_QUIRK(0x106b, 0x3600, "Macbook 3,1", ALC889A_MB31),
 	SND_PCI_QUIRK(0x106b, 0x3800, "MacbookPro 4,1", ALC885_MBP3),
 	SND_PCI_QUIRK(0x106b, 0x3e00, "iMac 24 Aluminum", ALC885_IMAC24),


