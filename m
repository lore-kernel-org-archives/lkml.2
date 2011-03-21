Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab1CUX1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:27:11 -0400
Received: from kroah.org ([198.145.64.141]:52652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab1CUXSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:25 2011
Message-Id: <20110321230325.835334141@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [40/78] ALSA: HDA: Fixup unnecessary volume control index on Realtek ALC88x
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 7e59e097c09b82760bb0fe08b0fa2b704d76c3f4 upstream.

Without this change, a volume control named "Surround" or "Side" would
get an unnecessary index, causing it to be ignored by the vmaster and
PulseAudio.

Tested-by: Bartłomiej Żogała <nusch88@gmail.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5207,16 +5207,19 @@ static int alc880_auto_create_multi_out_
 				return err;
 		} else {
 			const char *name = pfx;
-			if (!name)
+			int index = i;
+			if (!name) {
 				name = chname[i];
+				index = 0;
+			}
 			err = __add_pb_vol_ctrl(spec, ALC_CTL_WIDGET_VOL,
-						name, i,
+						name, index,
 					  HDA_COMPOSE_AMP_VAL(nid, 3, 0,
 							      HDA_OUTPUT));
 			if (err < 0)
 				return err;
 			err = __add_pb_sw_ctrl(spec, ALC_CTL_BIND_MUTE,
-					       name, i,
+					       name, index,
 					  HDA_COMPOSE_AMP_VAL(nid, 3, 2,
 							      HDA_INPUT));
 			if (err < 0)


