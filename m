Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2KZRD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:03:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47330 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab2KZRDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 066/270] ALSA: hda - do not detect jack on internal speakers for Realtek
Date: Mon, 26 Nov 2012 14:55:56 -0200
Message-Id: <1353949160-26803-67-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit f7f4b2322bf7b8c5929b7eb5a667091f32592580 upstream.

This caused the internal speaker to mute itself because it was
present, which happened after powersave.
It was found on Dell XPS 15 (L502x), ALC665.

Reported-by: Da Fox <da.fox.mail@gmail.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 95b9090..f6784d7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -588,6 +588,8 @@ static void alc_line_automute(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 
+	if (spec->autocfg.line_out_type == AUTO_PIN_SPEAKER_OUT)
+		return;
 	/* check LO jack only when it's different from HP */
 	if (spec->autocfg.line_out_pins[0] == spec->autocfg.hp_pins[0])
 		return;
-- 
1.7.9.5

