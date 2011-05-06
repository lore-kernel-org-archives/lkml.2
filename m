Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1EFAUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:20:30 -0400
Received: from kroah.org ([198.145.64.141]:32800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab1EFANP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:08 2011
Message-Id: <20110506001207.974127355@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 07/38] ALSA: hda - Fix Realteks chained fixup checks
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 24af2b1cc418d6791b1d9e56bf6070cccb752db3 upstream.

The check of chained fixup list entry was done against the wrong element.
A stupid mistake during refactoring.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1774,11 +1774,11 @@ static void alc_apply_fixup(struct hda_c
 				   codec->chip_name, fix->type);
 			break;
 		}
-		if (!fix[id].chained)
+		if (!fix->chained)
 			break;
 		if (++depth > 10)
 			break;
-		id = fix[id].chain_id;
+		id = fix->chain_id;
 	}
 }
 


