Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab0GAVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:09:56 -0400
Received: from kroah.org ([198.145.64.141]:47716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932765Ab0GAUut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:49 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:35 2010
Message-Id: <20100701173435.311028209@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 101/164] ALSA: hda: Use LPIB for ASUS M2V
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 9f75c1b12c5ef392ddcea575b13560842c28b1b3 upstream.

BugLink: https://launchpad.net/bugs/587546

Symptom: On the reporter's ASUS M2V, using PulseAudio in Ubuntu 10.04 LTS
results in the PA daemon crashing shortly after attempting playback of an
audio file.

Test case: Using Ubuntu 10.04 LTS (Linux 2.6.32.12), Linux 2.6.33, or
Linux 2.6.34, attempt playback of an audio file while PulseAudio is
active.

Resolution: add SSID for this machine to the position_fix quirk table,
explicitly specifying the LPIB method.

Reported-and-Tested-By: D Tangman
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2270,6 +2270,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x103c, 0x306d, "HP dv3", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x81b3, "ASUS", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1043, 0x81e7, "ASUS M2V", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x104d, 0x9069, "Sony VPCS11V9E", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1106, 0x3288, "ASUS M2V-MX SE", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1179, 0xff10, "Toshiba A100-259", POS_FIX_LPIB),


