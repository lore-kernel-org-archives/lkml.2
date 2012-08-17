Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030794Ab2HQDaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:30:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46826 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030676Ab2HQD1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:06 -0400
Message-Id: <20120817030248.169429259@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 28/37] ALSA: hda - Fix double quirk for Quanta FL1 / Lenovo Ideapad
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 012e7eb1e501d0120e0383b81477f63091f5e365 upstream.

The same ID is twice in the quirk table, so the second one is not used.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4981,6 +4981,8 @@ static const struct alc_fixup alc269_fix
 	[ALC269_FIXUP_PCM_44K] = {
 		.type = ALC_FIXUP_FUNC,
 		.v.func = alc269_fixup_pcm_44k,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_QUANTA_MUTE
 	},
 	[ALC269_FIXUP_STEREO_DMIC] = {
 		.type = ALC_FIXUP_FUNC,
@@ -5080,8 +5082,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x21fa, "Thinkpad X230", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x21fb, "Thinkpad T430s", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x2203, "Thinkpad X230 Tablet", ALC269_FIXUP_LENOVO_DOCK),
-	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_FIXUP_QUANTA_MUTE),
-	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Lenovo Ideapd", ALC269_FIXUP_PCM_44K),
+	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_FIXUP_PCM_44K),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 
 #if 1


