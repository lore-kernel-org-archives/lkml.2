Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab1CZAcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:32:48 -0400
Received: from kroah.org ([198.145.64.141]:44150 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab1CYXwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:08 2011
Message-Id: <20110325234507.935918310@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:43:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [01/63] ALSA: HDA: Realtek: Avoid unnecessary volume control index on Surround/Side
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 5a8826463c19b0d1a2fc60b2adac0ec318047844 upstream.

Similar to commit 7e59e097c09b82760bb0fe08b0fa2b704d76c3f4, this patch
avoids unnecessary volume control indices for more
Realtek auto-parsers, e g the ALC66x family, on the "Surround" and "Side"
controls.
These indices cause these volume controls to be ignored by PulseAudio and
vmaster and should be removed whenever possible.

Reported-by: Jan Losinski <losinski@wh2.tu-dresden.de>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -16085,9 +16085,12 @@ static int alc861_auto_create_multi_out_
 				return err;
 		} else {
 			const char *name = pfx;
-			if (!name)
+			int index = i;
+			if (!name) {
 				name = chname[i];
-			err = __alc861_create_out_sw(codec, name, nid, i, 3);
+				index = 0;
+			}
+			err = __alc861_create_out_sw(codec, name, nid, index, 3);
 			if (err < 0)
 				return err;
 		}
@@ -17238,16 +17241,19 @@ static int alc861vd_auto_create_multi_ou
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
 					  HDA_COMPOSE_AMP_VAL(nid_v, 3, 0,
 							      HDA_OUTPUT));
 			if (err < 0)
 				return err;
 			err = __add_pb_sw_ctrl(spec, ALC_CTL_BIND_MUTE,
-					       name, i,
+					       name, index,
 					  HDA_COMPOSE_AMP_VAL(nid_s, 3, 2,
 							      HDA_INPUT));
 			if (err < 0)
@@ -19296,12 +19302,15 @@ static int alc662_auto_create_multi_out_
 				return err;
 		} else {
 			const char *name = pfx;
-			if (!name)
+			int index = i;
+			if (!name) {
 				name = chname[i];
-			err = __alc662_add_vol_ctl(spec, name, nid, i, 3);
+				index = 0;
+			}
+			err = __alc662_add_vol_ctl(spec, name, nid, index, 3);
 			if (err < 0)
 				return err;
-			err = __alc662_add_sw_ctl(spec, name, mix, i, 3);
+			err = __alc662_add_sw_ctl(spec, name, mix, index, 3);
 			if (err < 0)
 				return err;
 		}


