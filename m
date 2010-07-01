Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab0GAVkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:40:43 -0400
Received: from kroah.org ([198.145.64.141]:32958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759183Ab0GAVOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:34 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:57 2010
Message-Id: <20100701174257.397874111@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [130/200] ALSA: hda: Use LPIB for an ASUS device
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit dd37f8e8659bc617c3f2a84e007a4824ccdac458 upstream.

BugLink: https://launchpad.net/bugs/465942

Symptom: On the reporter's ASUS device, using PulseAudio in Ubuntu 10.04
LTS results in the PA daemon crashing shortly after attempting to select
capture or to configure the audio hardware profile.

Test case: Using Ubuntu 10.04 LTS (Linux 2.6.32.12), Linux 2.6.33, or
Linux 2.6.34, adjust the HDA device's capture volume with PulseAudio.

Resolution: add SSID for this machine to the position_fix quirk table,
explicitly specifying the LPIB method.

Reported-and-Tested-By: Irihapeti
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2269,6 +2269,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x103c, 0x306d, "HP dv3", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1043, 0x81b3, "ASUS", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x104d, 0x9069, "Sony VPCS11V9E", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1106, 0x3288, "ASUS M2V-MX SE", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1179, 0xff10, "Toshiba A100-259", POS_FIX_LPIB),


