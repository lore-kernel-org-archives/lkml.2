Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab1LPUCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:02:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab1LPTvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:51:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:07 2011
Message-Id: <20111216194207.068961326@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [02/45] ALSA: hda/realtek - Fix Oops in alc_mux_select()
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit cce4aa378a049f4275416ee6302dd24f37b289df upstream.

When no imux is available (e.g. a single capture source),
alc_auto_init_input_src() may trigger an Oops due to the access to -1.
Add a proper zero-check to avoid it.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -509,6 +509,8 @@ static int alc_mux_enum_put(struct snd_k
 	imux = &spec->input_mux[mux_idx];
 	if (!imux->num_items && mux_idx > 0)
 		imux = &spec->input_mux[0];
+	if (!imux->num_items)
+		return 0;
 
 	type = get_wcaps_type(get_wcaps(codec, nid));
 	if (type == AC_WID_AUD_MIX) {


