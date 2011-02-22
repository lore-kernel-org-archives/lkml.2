Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab1BVW21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:28:27 -0500
Received: from kroah.org ([198.145.64.141]:46812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab1BVWWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:41 2011
Message-Id: <20110222221841.479159371@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [45/70] ALSA: HDA: Do not announce false surround in Conexant auto
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 89724958e5d596bb91328644c97dd80399443e87 upstream.

Without this patch, one line-out and one speaker and
Conexant's auto parser would announce (non-working) surround
capabilities.

BugLink: http://bugs.launchpad.net/bugs/721126
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3401,7 +3401,7 @@ static void cx_auto_parse_output(struct
 		}
 	}
 	spec->multiout.dac_nids = spec->private_dac_nids;
-	spec->multiout.max_channels = nums * 2;
+	spec->multiout.max_channels = spec->multiout.num_dacs * 2;
 
 	if (cfg->hp_outs > 0)
 		spec->auto_mute = 1;


