Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2ACWjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:39:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab2ACWjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:39:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:21 2012
Message-Id: <20120103223321.435623278@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [05/75] ALSA: HDA: Set position fix to LPIB for an Atom/Poulsbo based device
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 1c89fe3b51a2f8068f2f9faa9c48584151416583 upstream.

For the Asus 1101HA, reporting position by reading the DMA position
buffer map seems unstable and often wrong. The reporter says that
position_fix=LPIB works much better (although not 100%, but this is
probably due to other issues).

The controller chip is an Intel Poulsbo 8086:811b (rev 07) controller,
and complete alsa-info is available here:
https://launchpadlibrarian.net/86691768/alsa-info.txt.1TNwyE5Ea7

BugLink: http://bugs.launchpad.net/bugs/825709
Tested-by: Stefano Lodi
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2375,6 +2375,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x81b3, "ASUS", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x81e7, "ASUS M2V", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1043, 0x83ce, "ASUS 1101HA", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x104d, 0x9069, "Sony VPCS11V9E", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1106, 0x3288, "ASUS M2V-MX SE", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1297, 0x3166, "Shuttle", POS_FIX_LPIB),


