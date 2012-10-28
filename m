Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab2J1XeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:34:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42182 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756987Ab2J1X2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:24 -0400
Message-Id: <20121028231548.824652288@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:14 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Da Fox <da.fox.mail@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 038/105] ALSA: hda - do not detect jack on internal speakers for Realtek
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit f7f4b2322bf7b8c5929b7eb5a667091f32592580 upstream.

This caused the internal speaker to mute itself because it was
present, which happened after powersave.
It was found on Dell XPS 15 (L502x), ALC665.

Reported-by: Da Fox <da.fox.mail@gmail.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7bec68c..8253b4e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -611,6 +611,8 @@ static void alc_line_automute(struct hda_codec *codec, struct hda_jack_tbl *jack
 {
 	struct alc_spec *spec = codec->spec;
 
+	if (spec->autocfg.line_out_type == AUTO_PIN_SPEAKER_OUT)
+		return;
 	/* check LO jack only when it's different from HP */
 	if (spec->autocfg.line_out_pins[0] == spec->autocfg.hp_pins[0])
 		return;


