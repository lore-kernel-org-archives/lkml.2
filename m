Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1K2LVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:21:22 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:53109 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751975Ab1K2LVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:21:20 -0500
Date: Tue, 29 Nov 2011 12:21:17 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: ALSA: hda_intel - revert a quirk that affect VIA chipsets
Message-ID: <4ed4c02d.IYpKuLbAirLT4yfU%marc.vertes@sigfox.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 13847724431156889530
X-Ovh-Remote: 92.103.90.130 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -80
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrudejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegfrhhlucfvnfffucdlvddtmdenucfjughrpeffhffvuffkfgggtgfgsehtjeertddtredvnecuhfhrohhmpeforghrtgcugggvrhhtvghsuceomhgrrhgtrdhvvghrthgvshesshhighhfohigrdgtohhmqeenucffohhmrghinheprghlshgrqdhprhhojhgvtghtrdhorhhgne
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegfrhhlucfvnfffucdlvddtmdenlhhinhhugidvgiculddqvddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quirk sould be reverted. It has the following probems:

1) The quirk was intended to "ASUS MV2-MX SE" motherboards only, but the
ID used matches a much broader range, potentially all boards containing a
VIA chipset model in the family of vendor VIA 0x1106 and audio device ID
0x3288, which encompasses VIA-VT82xx, VIA-VT1xx and VIA-VT20xx chipsets.

2) VIA chipsets rely on azx_via_get_position() to handle correctly dma
transfers during capture. Using POS_FIX_LPIB instead of POS_FIX_VIACOMBO
leads to partially corrupted input buffers during capture. The effects
of this bug are not immediately visible, it took strong DSP expertise,
some expensive signal generator and a spectrum analyzer to identify it
and verify correct behaviour using original default.

3) It's almost certain that the quirk did not fix the real problem,
if there was one. Refer to original submission:
http://mailman.alsa-project.org/pipermail/alsa-devel/2010-February/025109.html

Signed-of-by: Marc Vertes <mvertes@sigfox.com>

--- linux-3.2-rc3/sound/pci/hda/hda_intel.c.orig	2011-11-24 05:20:28.000000000 +0100
+++ linux-3.2-rc3/sound/pci/hda/hda_intel.c	2011-11-28 17:29:01.044095455 +0100
@@ -2508,7 +2508,6 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1043, 0x81b3, "ASUS", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x81e7, "ASUS M2V", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x104d, 0x9069, "Sony VPCS11V9E", POS_FIX_LPIB),
-	SND_PCI_QUIRK(0x1106, 0x3288, "ASUS M2V-MX SE", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1297, 0x3166, "Shuttle", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1458, 0xa022, "ga-ma770-ud3", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1462, 0x1002, "MSI Wind U115", POS_FIX_LPIB),
