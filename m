Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab0EXX2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:28:53 -0400
Received: from kroah.org ([198.145.64.141]:59420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab0EXXXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:43 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:15 2010
Message-Id: <20100524231815.177254651@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>
Subject: [22/39] ALSA: virtuoso: fix Xonar D1/DX front panel microphone
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit 6a45f7822544c54a2cf070d84f4e85f2fb32ec02 upstream.

Commit 65c3ac885ce9852852b895a4a62212f62cb5f2e9 in 2.6.33 accidentally
left out the initialization of the AC97 codec FMIC2MIC bit, which broke
recording from the front panel microphone.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/xonar_cs43xx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/oxygen/xonar_cs43xx.c
+++ b/sound/pci/oxygen/xonar_cs43xx.c
@@ -56,6 +56,7 @@
 #include <sound/pcm_params.h>
 #include <sound/tlv.h>
 #include "xonar.h"
+#include "cm9780.h"
 #include "cs4398.h"
 #include "cs4362a.h"
 
@@ -172,6 +173,8 @@ static void xonar_d1_init(struct oxygen
 	oxygen_clear_bits16(chip, OXYGEN_GPIO_DATA,
 			    GPIO_D1_FRONT_PANEL | GPIO_D1_INPUT_ROUTE);
 
+	oxygen_ac97_set_bits(chip, 0, CM9780_JACK, CM9780_FMIC2MIC);
+
 	xonar_init_cs53x1(chip);
 	xonar_enable_output(chip);
 


