Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab1DNSZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:25:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:38188 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122Ab1DNRqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 061/209] ALSA: HDA: Add an extra DAC for Realtek ALC887-VD
Date: Thu, 14 Apr 2011 13:41:31 -0400
Message-Id: <1302803039-9400-62-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Henningsson <david.henningsson@canonical.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit cc1c452e509aefc28f7ad2deed75bc69d4f915f7 upstream.

The patch enables ALC887-VD to use the DAC at nid 0x26,
which makes it possible to use this DAC for e g Headphone
volume.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7b516f1..a1d30d3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -18198,6 +18198,8 @@ static inline hda_nid_t alc662_mix_to_dac(hda_nid_t nid)
 		return 0x02;
 	else if (nid >= 0x0c && nid <= 0x0e)
 		return nid - 0x0c + 0x02;
+	else if (nid == 0x26) /* ALC887-VD has this DAC too */
+		return 0x25;
 	else
 		return 0;
 }
@@ -18206,7 +18208,7 @@ static inline hda_nid_t alc662_mix_to_dac(hda_nid_t nid)
 static hda_nid_t alc662_dac_to_mix(struct hda_codec *codec, hda_nid_t pin,
 				   hda_nid_t dac)
 {
-	hda_nid_t mix[4];
+	hda_nid_t mix[5];
 	int i, num;
 
 	num = snd_hda_get_connections(codec, pin, mix, ARRAY_SIZE(mix));
-- 
1.7.4.4

