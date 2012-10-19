Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab2JSCse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:48:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:51944 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722Ab2JSCsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Da Fox <da.fox.mail@gmail.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 14/76] ALSA: hda - do not detect jack on internal speakers for Realtek
Date: Thu, 18 Oct 2012 19:46:38 -0700
Message-Id: <20121019024352.392071184@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit f7f4b2322bf7b8c5929b7eb5a667091f32592580 upstream.

This caused the internal speaker to mute itself because it was
present, which happened after powersave.
It was found on Dell XPS 15 (L502x), ALC665.

Reported-by: Da Fox <da.fox.mail@gmail.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -611,6 +611,8 @@ static void alc_line_automute(struct hda
 {
 	struct alc_spec *spec = codec->spec;
 
+	if (spec->autocfg.line_out_type == AUTO_PIN_SPEAKER_OUT)
+		return;
 	/* check LO jack only when it's different from HP */
 	if (spec->autocfg.line_out_pins[0] == spec->autocfg.hp_pins[0])
 		return;


