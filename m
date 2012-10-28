Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab2J1Xj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:39:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42025 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756772Ab2J1X1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:47 -0400
Message-Id: <20121028231556.417886246@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:39 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Stef=C3=A1n=20Freyr?= <stefan.freyr@gmail.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 063/105] ALSA: hda - add dock support for Thinkpad T430
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefán Freyr <stefan.freyr@gmail.com>

commit 84f98fdf7865fbd35b312eb39ea91e5618c514c7 upstream.

I have a Lenovo ThinkPad T430 and an UltraBase Series 3 docking
station.

Without this patch, if I plug my headphones into the jack on the
computer, everything works fine. The computer speakers mute and the
audio is played in the headphones. However, if I plug into the docking
station headphone jack the computer speakers are muted but there is no
audio in the headphones.

Addresses https://bugs.launchpad.net/bugs/1060372

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 48d9d60..2c62edd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6188,6 +6188,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x21e9, "Thinkpad Edge 15", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21f6, "Thinkpad T530", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x21fa, "Thinkpad X230", ALC269_FIXUP_LENOVO_DOCK),
+	SND_PCI_QUIRK(0x17aa, 0x21f3, "Thinkpad T430", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x21fb, "Thinkpad T430s", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x2203, "Thinkpad X230 Tablet", ALC269_FIXUP_LENOVO_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_FIXUP_PCM_44K),


