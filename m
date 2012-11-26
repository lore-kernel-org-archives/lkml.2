Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab2KZRDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:03:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab2KZRDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 064/270] ALSA: hda - Add missing hda_gen_spec to struct via_spec
Date: Mon, 26 Nov 2012 14:55:54 -0200
Message-Id: <1353949160-26803-65-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 7819d1c70eb6a57e43554d86e10b39d1e106ed65 upstream.

The commit [4b527b65 ALSA: hda - limit internal mic boost for Asus
X202E] introduced the use of auto-parser code, but it forgot to add
struct hda_gen_spec at the head of codec->spec which the auto-parser
assumes silently.  Without this record, it may result in memory
corruption.

This patch adds the missing piece.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_via.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 9c35043..92dff3e 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -118,6 +118,8 @@ enum {
 };
 
 struct via_spec {
+	struct hda_gen_spec gen;
+
 	/* codec parameterization */
 	const struct snd_kcontrol_new *mixers[6];
 	unsigned int num_mixers;
@@ -246,6 +248,7 @@ static struct via_spec * via_new_spec(struct hda_codec *codec)
 	/* VT1708BCE & VT1708S are almost same */
 	if (spec->codec_type == VT1708BCE)
 		spec->codec_type = VT1708S;
+	snd_hda_gen_init(&spec->gen);
 	return spec;
 }
 
@@ -1628,6 +1631,7 @@ static void via_free(struct hda_codec *codec)
 	vt1708_stop_hp_work(spec);
 	kfree(spec->bind_cap_vol);
 	kfree(spec->bind_cap_sw);
+	snd_hda_gen_free(&spec->gen);
 	kfree(spec);
 }
 
-- 
1.7.9.5

