Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab0EXX25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:28:57 -0400
Received: from kroah.org ([198.145.64.141]:59414 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529Ab0EXXXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:42 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:15 2010
Message-Id: <20100524231815.086466064@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [21/39] ALSA: ice1724 - Fix ESI Maya44 capture source control
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 8213466596bf10b75887754773ee13c10cf86f5c upstream.

The capture source control of maya44 was wrongly coded with the bit
shift instead of the bit mask.  Also, the slot for line-in was
wrongly assigned (slot 5 instead of 4).

Reported-by: Alex Chernyshoff <alexdsp@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ice1712/maya44.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/ice1712/maya44.c
+++ b/sound/pci/ice1712/maya44.c
@@ -347,7 +347,7 @@ static int maya_gpio_sw_put(struct snd_k
 
 /* known working input slots (0-4) */
 #define MAYA_LINE_IN	1	/* in-2 */
-#define MAYA_MIC_IN	4	/* in-5 */
+#define MAYA_MIC_IN	3	/* in-4 */
 
 static void wm8776_select_input(struct snd_maya44 *chip, int idx, int line)
 {
@@ -393,8 +393,8 @@ static int maya_rec_src_put(struct snd_k
 	int changed;
 
 	mutex_lock(&chip->mutex);
-	changed = maya_set_gpio_bits(chip->ice, GPIO_MIC_RELAY,
-				     sel ? GPIO_MIC_RELAY : 0);
+	changed = maya_set_gpio_bits(chip->ice, 1 << GPIO_MIC_RELAY,
+				     sel ? (1 << GPIO_MIC_RELAY) : 0);
 	wm8776_select_input(chip, 0, sel ? MAYA_MIC_IN : MAYA_LINE_IN);
 	mutex_unlock(&chip->mutex);
 	return changed;


