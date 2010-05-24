Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab0EXXXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:23:42 -0400
Received: from kroah.org ([198.145.64.141]:59342 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab0EXXXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:31 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:13 2010
Message-Id: <20100524231813.914835500@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexey Fisher <bug-track@fisher-privat.net>,
       Wu Fengguang <fengguang.wu@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [08/39] ALSA: hda - fix DG45ID SPDIF output
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wu Fengguang <fengguang.wu@intel.com>

commit 4d26f44657915f082806abfe3624aeded4c121fa upstream.

This reverts part of commit 52dc438606d1e, in order to fix a regression:
broken SPDIF output on Intel DG45FC motherboard (IDT 92HD73E1X5 codec).

	--- DG45FC-IDT-codec-2.6.32  (SPDIF OK)
	+++ DG45FC-IDT-codec-2.6.33  (SPDIF broken)

	 Node 0x22 [Pin Complex] wcaps 0x400301: Stereo Digital
	   Pincap 0x00000010: OUT
	-  Pin Default 0x40f000f0: [N/A] Other at Ext N/A
	-    Conn = Unknown, Color = Unknown
	-    DefAssociation = 0xf, Sequence = 0x0
	-  Pin-ctls: 0x00:
	+  Pin Default 0x014510a0: [Jack] SPDIF Out at Ext Rear
	+    Conn = Optical, Color = Black
	+    DefAssociation = 0xa, Sequence = 0x0
	+  Pin-ctls: 0x40: OUT
	   Connection: 3
	      0x25* 0x20 0x21
	 Node 0x23 [Pin Complex] wcaps 0x400301: Stereo Digital
	   Pincap 0x00000010: OUT
	-  Pin Default 0x01451140: [Jack] SPDIF Out at Ext Rear
	+  Pin Default 0x074510b0: [Jack] SPDIF Out at Ext Rear Panel
	     Conn = Optical, Color = Black
	-    DefAssociation = 0x4, Sequence = 0x0
	-    Misc = NO_PRESENCE
	-  Pin-ctls: 0x40: OUT
	+    DefAssociation = 0xb, Sequence = 0x0
	+  Pin-ctls: 0x00:
	   Connection: 3
	      0x26* 0x20 0x21

Cc: Alexey Fisher <bug-track@fisher-privat.net>
Tested-by: David Härdeman <david@hardeman.nu>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1539,11 +1539,9 @@ static unsigned int alienware_m17x_pin_c
 	0x904601b0,
 };
 
-static unsigned int intel_dg45id_pin_configs[14] = {
+static unsigned int intel_dg45id_pin_configs[13] = {
 	0x02214230, 0x02A19240, 0x01013214, 0x01014210,
-	0x01A19250, 0x01011212, 0x01016211, 0x40f000f0,
-	0x40f000f0, 0x40f000f0, 0x40f000f0, 0x014510A0,
-	0x074510B0, 0x40f000f0
+	0x01A19250, 0x01011212, 0x01016211
 };
 
 static unsigned int *stac92hd73xx_brd_tbl[STAC_92HD73XX_MODELS] = {


