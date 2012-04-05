Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2DENtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 09:49:41 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:38342 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab2DENtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 09:49:40 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 09:49:40 EDT
Message-ID: <1333632635.4159.15.camel@localhost>
Subject: [PATCH 5/6] sound/pci/hda: CX20549 doesn't need pin_amp_workaround.
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Date: Thu, 05 Apr 2012 15:30:35 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Originating-IP: 89.247.230.181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CX20549 (ctx5045) doesn't accept data on index 1 for output pins,
as shown in the following hda-var transaction:

  $ hda-verb /dev/snd/hwC0D0 0x10 set_amp_gain 0xb126
  nid = 0x10, verb = 0x300, param = 0xb126
  value = 0x0
  $ hda-verb /dev/snd/hwC0D0 0x10 get_amp_gain 0x8001
  nid = 0x10, verb = 0xb00, param = 0x8001
  value = 0x0

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 8d7a977..3ab7b25 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1087,7 +1087,6 @@ static int patch_cxt5045(struct hda_codec *codec)
 	if (!spec)
 		return -ENOMEM;
 	codec->spec = spec;
-	codec->pin_amp_workaround = 1;
 
 	spec->multiout.max_channels = 2;
 	spec->multiout.num_dacs = ARRAY_SIZE(cxt5045_dac_nids);
-- 
1.7.9.1



