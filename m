Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030252Ab2JSCtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:49:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:52719 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030202Ab2JSCtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 75/76] ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()
Date: Thu, 18 Oct 2012 19:47:39 -0700
Message-Id: <20121019024402.165043692@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 733a48e5ae5bf28b046fad984d458c747cbb8c21 upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=44721

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


