Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab3AIVso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:48:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:41607 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517Ab3AIUhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 023/123] ALSA: hda - Fix the wrong pincaps set in ALC861VD dallas/hp fixup
Date: Wed,  9 Jan 2013 12:34:22 -0800
Message-Id: <20130109201501.485382920@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b78562b10fa66175e30b76073e32a0ad8d92aa83 upstream.

The workaround to force VREF50 for dallas/hp model with ALC861VD
was introduced in commit 8fdcb6fe4204bdb4c6991652717ab5063751414e,
but it contained wrong pincap override bits.

This patch fixes to exclude VREF80 pincap bit correctly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6535,8 +6535,8 @@ static void alc861vd_fixup_dallas(struct
 				  const struct alc_fixup *fix, int action)
 {
 	if (action == ALC_FIXUP_ACT_PRE_PROBE) {
-		snd_hda_override_pin_caps(codec, 0x18, 0x00001714);
-		snd_hda_override_pin_caps(codec, 0x19, 0x0000171c);
+		snd_hda_override_pin_caps(codec, 0x18, 0x00000734);
+		snd_hda_override_pin_caps(codec, 0x19, 0x0000073c);
 	}
 }
 


