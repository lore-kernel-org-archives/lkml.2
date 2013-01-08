Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab3AHXiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:38:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:63637 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab3AHXhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 44/77] ALSA: hda/realtek - Fix Oops in alc_mux_select()
Date: Tue, 8 Jan 2013 18:35:23 -0500
Message-ID: <1357688156-25387-45-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cce4aa378a049f4275416ee6302dd24f37b289df upstream.

When no imux is available (e.g. a single capture source),
alc_auto_init_input_src() may trigger an Oops due to the access to -1.
Add a proper zero-check to avoid it.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[PG: in mainline, 21268961d3 rewrites and creates alc_mux_select, but the
code that needed the check still existed prior to that in alc_mux_enum_put]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 94f1a80..28118fd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -444,6 +444,8 @@ static int alc_mux_enum_put(struct snd_kcontrol *kcontrol,
 	imux = &spec->input_mux[mux_idx];
 	if (!imux->num_items && mux_idx > 0)
 		imux = &spec->input_mux[0];
+	if (!imux->num_items)
+		return 0;
 
 	type = get_wcaps_type(get_wcaps(codec, nid));
 	if (type == AC_WID_AUD_MIX) {
-- 
1.7.12.1

