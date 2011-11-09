Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935294Ab1KJE5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:57:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934858Ab1KJDaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:20 2011
Message-Id: <20111109212720.227398344@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Charles Chin <Charles.Chin@idt.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [195/262] ALSA: hda - Disable power-widget control for IDT 92HD83/93 as default
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Chin <Charles.Chin@idt.com>

commit 35c11777b906042eca9e6f1c03e464726c7faa07 upstream.

The power-widget control in patch_stac92hd83xxx() never worked properly,
thus it's safer to turn it off as default for now.

Signed-off-by: Charles Chin <Charles.Chin@idt.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -5465,26 +5465,8 @@ again:
 		stac92xx_set_config_regs(codec,
 				stac92hd83xxx_brd_tbl[spec->board_config]);
 
-	switch (codec->vendor_id) {
-	case 0x111d76d1:
-	case 0x111d76d9:
-	case 0x111d76df:
-	case 0x111d76e5:
-	case 0x111d7666:
-	case 0x111d7667:
-	case 0x111d7668:
-	case 0x111d7669:
-	case 0x111d76e3:
-	case 0x111d7604:
-	case 0x111d76d4:
-	case 0x111d7605:
-	case 0x111d76d5:
-	case 0x111d76e7:
-		if (spec->board_config == STAC_92HD83XXX_PWR_REF)
-			break;
+	if (spec->board_config != STAC_92HD83XXX_PWR_REF)
 		spec->num_pwrs = 0;
-		break;
-	}
 
 	codec->patch_ops = stac92xx_patch_ops;
 


