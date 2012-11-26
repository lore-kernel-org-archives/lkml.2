Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab2KZRKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:10:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47785 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489Ab2KZRKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 166/270] ALSA: hda - Always check array bounds in alc_get_line_out_pfx
Date: Mon, 26 Nov 2012 14:57:36 -0200
Message-Id: <1353949160-26803-167-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 71aa5ebe36a4e936eff281b375a4707b6a8320f2 upstream.

Even when CONFIG_SND_DEBUG is not enabled, we don't want to
return an arbitrary memory location when the channel count is
larger than we expected.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f6784d7..2549f0b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2486,8 +2486,10 @@ static const char *alc_get_line_out_pfx(struct alc_spec *spec, int ch,
 			return "PCM";
 		break;
 	}
-	if (snd_BUG_ON(ch >= ARRAY_SIZE(channel_name)))
+	if (ch >= ARRAY_SIZE(channel_name)) {
+		snd_BUG();
 		return "PCM";
+	}
 
 	return channel_name[ch];
 }
-- 
1.7.9.5

