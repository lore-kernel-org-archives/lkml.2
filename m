Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2BAVwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:52:14 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55592 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757077Ab2BAVIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:21 -0500
X-Sasl-enc: VBJhQ6sU9+KTKrI7Vue4PNWF/hoO7Z4Qjnho4fruFflT 1328130500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:39 2012
Message-Id: <20120201205739.221278590@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [20/65] ALSA: hda - Fix silent output on Haier W18 laptop
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -16443,6 +16443,7 @@ static const struct alc_fixup alc861_fix
 
 static const struct snd_pci_quirk alc861_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", PINFIX_ASUS_A6RP),
+	SND_PCI_QUIRK(0x1584, 0x2b01, "Haier W18", PINFIX_ASUS_A6RP),
 	SND_PCI_QUIRK(0x1734, 0x10c7, "FSC Amilo Pi1505", PINFIX_FSC_AMILO_PI1505),
 	{}
 };


