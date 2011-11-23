Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab1KWAdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:33:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757209Ab1KWAdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:08 2011
Message-Id: <20111123002208.115058840@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [12/25] Revert "ALSA: hda: Fix quirk for Dell Inspiron 910"
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1031
Lines: 27


From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

This reverts commit fdb1e4e9d85b973679d56f23ccf9017ff85fd11f.

It was wrong included in 2.6.32 stable (was intended for 2.6.38+ in the
original commit changelog in Linus tree), and causes a regression on
2.6.32 (https://launchpad.net/bugs/875300).

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12664,7 +12664,6 @@ static struct snd_pci_quirk alc268_cfg_t
 	SND_PCI_QUIRK(0x1025, 0x015b, "Acer Aspire One",
 						ALC268_ACER_ASPIRE_ONE),
 	SND_PCI_QUIRK(0x1028, 0x0253, "Dell OEM", ALC268_DELL),
-	SND_PCI_QUIRK(0x1028, 0x02b0, "Dell Inspiron 910", ALC268_AUTO),
 	SND_PCI_QUIRK_MASK(0x1028, 0xfff0, 0x02b0,
 			"Dell Inspiron Mini9/Vostro A90", ALC268_DELL),
 	/* almost compatible with toshiba but with optional digital outs;


