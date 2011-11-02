Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab1KCCJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:09:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933331Ab1KCBgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:53 2011
Message-Id: <20111102221453.685056749@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [039/107] ALSA: hda/realtek - Avoid bogus HP-pin assignment
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5fe6e0151dbd969f5fbcd94d05c968b76d76952b upstream.

When the headphone pin is assigned as primary output to line_out_pins[],
the automatic HP-pin assignment by ASSID must be suppressed.  Otherwise
a wrong pin might be assigned to the headphone and breaks the auto-mute.

Reference: https://bugzilla.novell.com/show_bug.cgi?id=716104

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1337,7 +1337,9 @@ do_sku:
 	 * 15   : 1 --> enable the function "Mute internal speaker
 	 *	        when the external headphone out jack is plugged"
 	 */
-	if (!spec->autocfg.hp_pins[0]) {
+	if (!spec->autocfg.hp_pins[0] &&
+	    !(spec->autocfg.line_out_pins[0] &&
+	      spec->autocfg.line_out_type == AUTO_PIN_HP_OUT)) {
 		hda_nid_t nid;
 		tmp = (ass >> 11) & 0x3;	/* HP to chassis */
 		if (tmp == 0)


