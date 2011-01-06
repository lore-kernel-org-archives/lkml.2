Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1AFA2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:28:51 -0500
Received: from kroah.org ([198.145.64.141]:35379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab1AFA2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:50 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:57 2011
Message-Id: <20110106002257.360351720@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [007/152] ALSA: hda: Use position_fix=1 for Acer Aspire 5538 to enable capture on internal mic
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit dd5a089edfa51a74692604b4b427953d8e16bc35 upstream.

BugLink: https://launchpad.net/bugs/685161

The reporter of the bug states that he must use position_fix=1 to enable
capture for the internal microphone, so set it for his machine's PCI
SSID.  Verified using 2.6.35 and the 2010-12-04 alsa-driver build.

Reported-and-tested-by: Ralph Wabel <rwabel@gmx.net>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2298,6 +2298,7 @@ static int azx_dev_free(struct snd_devic
  */
 static struct snd_pci_quirk position_fix_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1025, 0x009f, "Acer Aspire 5110", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1025, 0x026f, "Acer Aspire 5538", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),


