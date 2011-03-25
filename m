Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1CYXwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:52:18 -0400
Received: from kroah.org ([198.145.64.141]:41367 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab1CYXwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:39 2011
Message-Id: <20110325234839.517978523@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:46:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lydia Wang <lydiawang@viatech.com.cn>, Takashi Iwai <tiwai@suse.de>
Subject: [06/55] ALSA: hda - VIA: Fix VT1708 cant build up Headphone control issue
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lydia Wang <lydiawang@viatech.com.cn>

commit ee3c35c0827de02de414d08b2ddcbb910c2263ab upstream.

Since VT1708 didn't support the control of getting connection number,
building of headphone control will fail in via_hp_build() function.

Signed-off-by: Lydia Wang <lydiawang@viatech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_via.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1267,9 +1267,12 @@ static int via_hp_build(struct hda_codec
 		break;
 	}
 
-	nums = snd_hda_get_connections(codec, nid, conn, HDA_MAX_CONNECTIONS);
-	if (nums <= 1)
-		return 0;
+	if (spec->codec_type != VT1708) {
+		nums = snd_hda_get_connections(codec, nid,
+					       conn, HDA_MAX_CONNECTIONS);
+		if (nums <= 1)
+			return 0;
+	}
 
 	knew = via_clone_control(spec, &via_hp_mixer[0]);
 	if (knew == NULL)


