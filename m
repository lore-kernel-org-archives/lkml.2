Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab2JSCsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:48:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:52057 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964844Ab2JSCsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 13/76] ALSA: hda - Add missing hda_gen_spec to struct via_spec
Date: Thu, 18 Oct 2012 19:46:37 -0700
Message-Id: <20121019024352.234090591@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |    4 ++++
 1 file changed, 4 insertions(+)

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
@@ -246,6 +248,7 @@ static struct via_spec * via_new_spec(st
 	/* VT1708BCE & VT1708S are almost same */
 	if (spec->codec_type == VT1708BCE)
 		spec->codec_type = VT1708S;
+	snd_hda_gen_init(&spec->gen);
 	return spec;
 }
 
@@ -1628,6 +1631,7 @@ static void via_free(struct hda_codec *c
 	vt1708_stop_hp_work(spec);
 	kfree(spec->bind_cap_vol);
 	kfree(spec->bind_cap_sw);
+	snd_hda_gen_free(&spec->gen);
 	kfree(spec);
 }
 


