Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab2J1X1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:27:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41834 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756372Ab2J1X1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:06 -0400
Message-Id: <20121028231608.981114433@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:19 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 103/105] ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 733a48e5ae5bf28b046fad984d458c747cbb8c21 upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=44721

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/ac97/ac97_codec.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1271,6 +1271,8 @@ static int snd_ac97_cvol_new(struct snd_
 		tmp.index = ac97->num;
 		kctl = snd_ctl_new1(&tmp, ac97);
 	}
+	if (!kctl)
+		return -ENOMEM;
 	if (reg >= AC97_PHONE && reg <= AC97_PCM)
 		set_tlv_db_scale(kctl, db_scale_5bit_12db_max);
 	else


