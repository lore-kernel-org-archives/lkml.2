Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab0HLASb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:18:31 -0400
Received: from kroah.org ([198.145.64.141]:60506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817Ab0HLAIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:09 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:14 2010
Message-Id: <20100812000614.307283370@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [18/67] ALSA: hda - Add PC-beep whitelist for an Intel board
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e096c8e6d5ed965f346d94befbbec2275dde3621 upstream.

An Intel board needs a white-list entry to enable PC-beep.
Otherwise the driver misdetects (due to bogus BIOS info) and ignores
the PC-beep on 2.6.35.

Reported-and-tested-by: Leandro Lucarella <luca@llucax.com.ar>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5183,6 +5183,7 @@ static void fillup_priv_adc_nids(struct
 
 static struct snd_pci_quirk beep_white_list[] = {
 	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
+	SND_PCI_QUIRK(0x8086, 0xd613, "Intel", 1),
 	{}
 };
 


