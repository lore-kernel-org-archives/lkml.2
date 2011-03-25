Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119Ab1CZA3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:29:54 -0400
Received: from kroah.org ([198.145.64.141]:41397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab1CYXwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:08 2011
Message-Id: <20110325234508.597332060@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:43:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lydia Wang <lydiawang@viatech.com.cn>, Takashi Iwai <tiwai@suse.de>
Subject: [07/63] ALSA: hda - VIA: Fix VT1708 cant build up Headphone control issue
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1266,9 +1266,12 @@ static int via_hp_build(struct hda_codec
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


