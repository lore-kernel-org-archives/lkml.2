Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab2FQScB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:32:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50300 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757952Ab2FQSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:48 -0400
Message-Id: <20120617175946.971901223@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 40/69] ALSA: hda - Add codec->no_jack_detect flag
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 71b1e9e43d5199f57c109e20c0f4dffc5c048130 upstream.

Add a new flag to indicate that the codec has no jack-detection cap.
This flag should be set for hardwares that have no jack-detect
implementation although the codec chip itself supports it.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust filename and context for is_jack_detectable()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/sound/pci/hda/hda_codec.h
+++ b/sound/pci/hda/hda_codec.h
@@ -858,6 +858,7 @@
 	unsigned int pins_shutup:1;	/* pins are shut up */
 	unsigned int no_trigger_sense:1; /* don't trigger at pin-sensing */
 	unsigned int ignore_misc_bit:1; /* ignore MISC_NO_PRESENCE bit */
+	unsigned int no_jack_detect:1;	/* Machine has no jack-detection */
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	unsigned int power_on :1;	/* current (global) power-state */
 	unsigned int power_transition :1; /* power-state in transition */
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -515,6 +515,8 @@
 
 static inline bool is_jack_detectable(struct hda_codec *codec, hda_nid_t nid)
 {
+	if (codec->no_jack_detect)
+		return false;
 	if (!(snd_hda_query_pin_caps(codec, nid) & AC_PINCAP_PRES_DETECT))
 		return false;
 	if (!codec->ignore_misc_bit &&


