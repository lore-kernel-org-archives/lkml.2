Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab0EJXgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:36:05 -0400
Received: from kroah.org ([198.145.64.141]:33170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab0EJWwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:19 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:22 2010
Message-Id: <20100510223322.166993037@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [055/117] ALSA: hda - Add PCI quirk for HP dv6-1110ax.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>

commit e3d2530a6cea80987f77b75d8784a00f3aaf22ff upstream.

Adding this PCI quirk fixes the board config detection.
This also fixes jack sensing by using "hp_detect=1" via properly detected
board config.

Signed-off-by: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1725,6 +1725,8 @@ static struct snd_pci_quirk stac92hd71bx
 		      "HP HDX", STAC_HP_HDX),  /* HDX16 */
 	SND_PCI_QUIRK_MASK(PCI_VENDOR_ID_HP, 0xfff0, 0x3620,
 		      "HP dv6", STAC_HP_DV5),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x3061,
+		      "HP dv6", STAC_HP_DV5), /* HP dv6-1110ax */
 	SND_PCI_QUIRK_MASK(PCI_VENDOR_ID_HP, 0xfff0, 0x7010,
 		      "HP", STAC_HP_DV5),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0233,


