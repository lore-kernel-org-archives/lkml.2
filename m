Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab2APSrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:47:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab2APSrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:47:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:16 2012
Message-Id: <20120116184516.692570699@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [11/48] ALSA: hda - Use auto-parser for HP laptops with cx20459 codec
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit de4da59e480cdf1075b33dbaf8078fc87bc52241 upstream.

These laptops can work well with the auto-parser and their BIOS setups,
and in addition, the auto-parser fixes the problem with S3/S4 where
the unsol event handling is killed after resume due to fallback to the
single-cmd mode.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=740115

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1119,8 +1119,6 @@ static const char * const cxt5045_models
 
 static const struct snd_pci_quirk cxt5045_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x30d5, "HP 530", CXT5045_LAPTOP_HP530),
-	SND_PCI_QUIRK_MASK(0x103c, 0xff00, 0x3000, "HP DV Series",
-			   CXT5045_LAPTOP_HPSENSE),
 	SND_PCI_QUIRK(0x1179, 0xff31, "Toshiba P105", CXT5045_LAPTOP_MICSENSE),
 	SND_PCI_QUIRK(0x152d, 0x0753, "Benq R55E", CXT5045_BENQ),
 	SND_PCI_QUIRK(0x1734, 0x10ad, "Fujitsu Si1520", CXT5045_LAPTOP_MICSENSE),


