Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457Ab1CEBMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:12:30 -0500
Received: from kroah.org ([198.145.64.141]:50286 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760420Ab1CEBAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:38 2011
Message-Id: <20110305005638.302603953@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [38/73] ALSA: HDA: Fix mic initialization in VIA auto parser
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 306496761745942d8167e9193a738b559a7fb0b3 upstream.

This typo caused some microphone inputs not to be correctly
initialized on VIA codecs.

Reported-By: Mark Goldstein <goldstein.mark@gmail.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_via.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -568,7 +568,7 @@ static void via_auto_init_analog_input(s
 		hda_nid_t nid = cfg->inputs[i].pin;
 		if (spec->smart51_enabled && is_smart51_pins(spec, nid))
 			ctl = PIN_OUT;
-		else if (i == AUTO_PIN_MIC)
+		else if (cfg->inputs[i].type == AUTO_PIN_MIC)
 			ctl = PIN_VREF50;
 		else
 			ctl = PIN_IN;


