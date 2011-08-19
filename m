Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1HSV7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:59:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11796 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1HSV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:59:34 -0400
Date: Sat, 20 Aug 2011 00:00:06 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: alsa-devel@alsa-project.org, "Edgar (gimli) Hucek" <gimli@dark-green.com>,
        Tim Howe <tim.howe@cirrus.com>, Stephen Warren <swarren@nvidia.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] Sound, Cirrus: Remove redundant check
Message-ID: <alpine.LNX.2.00.1108192358510.31857@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'idxp' is a pointer to 'unsigned int', so the value
obtained when dereferencing it is always greater than or equal to
0. Testing this is redundant.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/pci/hda/patch_cirrus.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 47d6ffc..3bd8721 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -385,8 +385,7 @@ static hda_nid_t get_adc(struct hda_codec *codec, hda_nid_t pin,
 		if (type != AC_WID_AUD_IN)
 			continue;
 		*idxp = snd_hda_get_conn_index(codec, nid, pin, false);
-		if (*idxp >= 0)
-			return nid;
+		return nid;
 	}
 	return 0;
 }
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

