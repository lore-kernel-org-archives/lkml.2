Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2L1TRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:17:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55075 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549Ab2L1TRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:42 -0500
Message-Id: <20121228190358.063252052@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 137/173] ALSA: hda - Fix the wrong pincaps set in ALC861VD dallas/hp fixup
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b78562b10fa66175e30b76073e32a0ad8d92aa83 upstream.

The workaround to force VREF50 for dallas/hp model with ALC861VD
was introduced in commit 8fdcb6fe4204bdb4c6991652717ab5063751414e,
but it contained wrong pincap override bits.

This patch fixes to exclude VREF80 pincap bit correctly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 16d210a..6ee3459 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6570,8 +6570,8 @@ static void alc861vd_fixup_dallas(struct hda_codec *codec,
 				  const struct alc_fixup *fix, int action)
 {
 	if (action == ALC_FIXUP_ACT_PRE_PROBE) {
-		snd_hda_override_pin_caps(codec, 0x18, 0x00001714);
-		snd_hda_override_pin_caps(codec, 0x19, 0x0000171c);
+		snd_hda_override_pin_caps(codec, 0x18, 0x00000734);
+		snd_hda_override_pin_caps(codec, 0x19, 0x0000073c);
 	}
 }
 


