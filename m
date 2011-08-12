Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1HNQHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:07:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab1HNQHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:55 2011
Message-Id: <20110812210555.525113147@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolai Krakowiak <nicolai.krakowiak@gmail.com>,
        Daniel Mack <zonque@gmail.com>, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [39/90] ALSA: snd-usb: avoid dividing by zero on invalid input
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolai Krakowiak <nicolai.krakowiak@gmail.com>

commit 60c961a9e1ed879a4d151df6076bf1203f595f73 upstream.

Signed-off-by: Nicolai Krakowiak <nicolai.krakowiak@gmail.com>
Acked-by: Daniel Mack <zonque@gmail.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/mixer.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1191,6 +1191,11 @@ static int parse_audio_feature_unit(stru
 
 	if (state->mixer->protocol == UAC_VERSION_1) {
 		csize = hdr->bControlSize;
+		if (!csize) {
+			snd_printdd(KERN_ERR "usbaudio: unit %u: "
+				    "invalid bControlSize == 0\n", unitid);
+			return -EINVAL;
+		}
 		channels = (hdr->bLength - 7) / csize - 1;
 		bmaControls = hdr->bmaControls;
 	} else {


