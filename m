Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066Ab2CMAnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:43:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:48445 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758940Ab2CMAYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 133/196] ALSA: emux: Add trivial compat ioctl handler
Date: Mon, 12 Mar 2012 20:20:46 -0400
Message-Id: <1331598109-31424-88-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a254dba37c5a372fc8b44ba29509ba052d4e859d upstream.

Reported-by: Carmen Cru <carmen.cru@belgacom.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/synth/emux/emux_hwdep.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/synth/emux/emux_hwdep.c b/sound/synth/emux/emux_hwdep.c
index ff0b2a8..5ae1eae 100644
--- a/sound/synth/emux/emux_hwdep.c
+++ b/sound/synth/emux/emux_hwdep.c
@@ -128,6 +128,9 @@ snd_emux_init_hwdep(struct snd_emux *emu)
 	strcpy(hw->name, SNDRV_EMUX_HWDEP_NAME);
 	hw->iface = SNDRV_HWDEP_IFACE_EMUX_WAVETABLE;
 	hw->ops.ioctl = snd_emux_hwdep_ioctl;
+	/* The ioctl parameter types are compatible between 32- and
+	 * 64-bit architectures, so use the same function. */
+	hw->ops.ioctl_compat = snd_emux_hwdep_ioctl;
 	hw->exclusive = 1;
 	hw->private_data = emu;
 	if ((err = snd_card_register(emu->card)) < 0)
-- 
1.7.9.3

