Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab2BAVKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:10:47 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40019 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932656Ab2BAVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:40 -0500
X-Sasl-enc: GRQMmLCz9ZFUVa7plBZ/ffDichtYnIja+ML7MgvwCmPc 1328130639
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:46 2012
Message-Id: <20120201210046.477401847@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [29/89] ALSA: hda - Fix silent output on Haier W18 laptop
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b3a81520bd37a28f77cb0f7002086fb14061824d upstream.

The very same problem is seen on Haier W18 laptop with ALC861 as seen
on ASUS A6Rp, which was fixed by the commit 3b25eb69.
Now we just need to add a new SSID entry pointing to the same fixup.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=42656

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5247,6 +5247,7 @@ static const struct alc_fixup alc861_fix
 
 static const struct snd_pci_quirk alc861_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", PINFIX_ASUS_A6RP),
+	SND_PCI_QUIRK(0x1584, 0x2b01, "Haier W18", PINFIX_ASUS_A6RP),
 	SND_PCI_QUIRK(0x1734, 0x10c7, "FSC Amilo Pi1505", PINFIX_FSC_AMILO_PI1505),
 	{}
 };


