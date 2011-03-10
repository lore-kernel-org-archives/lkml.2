Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1CKADb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:03:31 -0500
Received: from kroah.org ([198.145.64.141]:46815 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab1CJX5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:36 2011
Message-Id: <20110310235536.525351587@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 05/29] ALSA: HDA: Realtek: Fixup jack detection to input subsystem
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit f0ce27996217d06207c8bfda1b1bbec2fbab48c6 upstream.

This patch fixes an error in the jack detection reporting,
causing the jack detection sometimes not to be reported
correctly to the input subsystem. It should apply to several
Realtek codecs.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1127,11 +1127,8 @@ static void alc_automute_speaker(struct
 		nid = spec->autocfg.hp_pins[i];
 		if (!nid)
 			break;
-		if (snd_hda_jack_detect(codec, nid)) {
-			spec->jack_present = 1;
-			break;
-		}
-		alc_report_jack(codec, spec->autocfg.hp_pins[i]);
+		alc_report_jack(codec, nid);
+		spec->jack_present |= snd_hda_jack_detect(codec, nid);
 	}
 
 	mute = spec->jack_present ? HDA_AMP_MUTE : 0;


