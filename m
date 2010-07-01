Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab0GAWAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:00:17 -0400
Received: from kroah.org ([198.145.64.141]:33837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758879Ab0GAVNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:06 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:48 2010
Message-Id: <20100701174248.867715733@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [029/200] ALSA: hda: Use LPIB for Sony VPCS11V9E
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit e96d3127760a2fc509bca6bf7e61e8bc61497aeb upstream.

BugLink: https://launchpad.net/bugs/586347

Symptom: On the Sony VPCS11V9E, using GStreamer-based applications with
PulseAudio in Ubuntu 10.04 LTS results in stuttering audio. It appears
to worsen with increased I/O.

Test case: use Rhythmbox under increased I/O pressure. This symptom is
reproducible in the current daily stable alsa-driver snapshots (at least
up until 21 May 2010; later snapshots fail to build from source due to
missing preprocessor directives when compiled against 2.6.32).

Resolution: add SSID for this machine to the position_fix quirk table,
explicitly specifying the LPIB method.

Reported-and-Tested-By: Lauri Kainulainen <lauri@sokkelo.net>
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
+	SND_PCI_QUIRK(0x104d, 0x9069, "Sony VPCS11V9E", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1106, 0x3288, "ASUS M2V-MX SE", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1179, 0xff10, "Toshiba A100-259", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1458, 0xa022, "ga-ma770-ud3", POS_FIX_LPIB),


