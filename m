Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761014Ab2BJXS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:18:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760561Ab2BJWlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:25 -0500
MIME-Version: 1.0
Message-Id: <20120210222945.298714576@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 03/86] ALSA: HDA: Remove quirk for Asus N53Jq
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit a389d67cf9849aff1722ed73186a584e2196a873 upstream.

The user reports that he needs to add model=auto for audio to
work properly. In fact, since node 0x15 is not even a pin node,
the existing fixup is definitely wrong. Relevant information can
be found in the buglink below.

BugLink: https://bugs.launchpad.net/bugs/918254
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5011,7 +5011,6 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x8330, "ASUS Eeepc P703 P900A",
 		      ALC269_FIXUP_AMIC),
 	SND_PCI_QUIRK(0x1043, 0x1013, "ASUS N61Da", ALC269_FIXUP_AMIC),
-	SND_PCI_QUIRK(0x1043, 0x1113, "ASUS N63Jn", ALC269_FIXUP_AMIC),
 	SND_PCI_QUIRK(0x1043, 0x1143, "ASUS B53f", ALC269_FIXUP_AMIC),
 	SND_PCI_QUIRK(0x1043, 0x1133, "ASUS UJ20ft", ALC269_FIXUP_AMIC),
 	SND_PCI_QUIRK(0x1043, 0x1183, "ASUS K72DR", ALC269_FIXUP_AMIC),


