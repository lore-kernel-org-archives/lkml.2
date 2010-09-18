Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0IRTCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:31 -0400
Received: from kroah.org ([198.145.64.141]:51260 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab0IRTBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:31 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:55 2010
Message-Id: <20100918185955.735836180@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>
Subject: [034/123] ALSA: hda - Fix auto-parser of ALC269vb for HP pin NID 0x21
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=alsa-hda-fix-auto-parser-of-alc269vb-for-hp-pin-nid-0x21.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 531d8791accf1464bc6854ff69d08dd866189d17 upstream.

ALC269vb has an alternative HP pin 0x21 in addition.
Fix the parser to recognize it.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12389,6 +12389,7 @@ static int alc268_new_analog_output(stru
 		dac = 0x02;
 		break;
 	case 0x15:
+	case 0x21: /* ALC269vb has this pin, too */
 		dac = 0x03;
 		break;
 	default:


