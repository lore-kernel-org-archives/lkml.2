Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1K2KNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:13:24 -0500
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:41606 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753589Ab1K2KNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:13:22 -0500
Date: Tue, 29 Nov 2011 11:13:19 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH] ALSA: hda_intel - revert a quirk that breaks all VIA
 chipsets
Message-ID: <4ed4b03f.B0tSFYR8f3fW5ehj%marc.vertes@sigfox.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12699869475596715962
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

1) It breaks the default setup of all VIA chipset models (vendor
0x1106, product 0x3288), at least a dozen models are concerned, from VIA-VT82xx
to VIA-VT17xx and VT20xx. All those chips rely on azx_via_get_position()
to handle correctly dma transfers during capture. Using POS_FIX_LPIB
instead of POS_FIX_VIACOMBO leads to partially corrupted input buffers
during capture. The effects of this bug are not immediately visible,
it took strong DSP expertise, some expensive signal generator and a spectrum
analyzer to identify it and verify correct behaviour using original default.

2) The string "ASUS MV2-MX SE" refers to a motherboard, not a sound chipset
family, which is misleading on the impact of the quirk.

3) It's almost certain that the quirk did not fix the real problem, if there
was one. Refer to original submission:
http://mailman.alsa-project.org/pipermail/alsa-devel/2010-February/025109.html

Thanks,

Marc
--

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
