Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab1CUX1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:27:30 -0400
Received: from kroah.org ([198.145.64.141]:52647 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab1CUXSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:25 2011
Message-Id: <20110321230325.727853948@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [39/78] ALSA: HDA: Fix volume control naming for surround speakers on Realtek auto-parser
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit ebbeb3d6aa22433c218da6f29fd7b3ebc89b87ea upstream.

When more than one pair of internal speakers is present, allow names
according to their channels.

Tested-by: Bartłomiej Żogała <nusch88@gmail.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5151,7 +5151,9 @@ static const char *alc_get_line_out_pfx(
 
 	switch (cfg->line_out_type) {
 	case AUTO_PIN_SPEAKER_OUT:
-		return "Speaker";
+		if (cfg->line_outs == 1)
+			return "Speaker";
+		break;
 	case AUTO_PIN_HP_OUT:
 		return "Headphone";
 	default:


