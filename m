Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab1BPBiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:38:09 -0500
Received: from kroah.org ([198.145.64.141]:39077 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122Ab1BPAUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:33 2011
Message-Id: <20110216001433.818197337@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [087/272] ALSA: hda - Dont refer ELD when unplugged
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6661702f2e803b55b50cc0471eb6b9254e99eef2 upstream.

When unplugged, we shouldn't refer to ELD information for PCM open
any more.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -827,7 +827,7 @@ static int hdmi_pcm_open(struct hda_pcm_
 		*codec_pars = *hinfo;
 
 	eld = &spec->sink_eld[idx];
-	if (eld->sad_count > 0) {
+	if (eld->eld_valid && eld->sad_count > 0) {
 		hdmi_eld_update_pcm_info(eld, hinfo, codec_pars);
 		if (hinfo->channels_min > hinfo->channels_max ||
 		    !hinfo->rates || !hinfo->formats)


