Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab1EFAu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:50:26 -0400
Received: from kroah.org ([198.145.64.141]:36967 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946Ab1EFAZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:13 2011
Message-Id: <20110506002212.977811738@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>, Takashi Iwai <tiwai@suse.de>
Subject: [079/143] ALSA: emux: Add trivial compat ioctl handler
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit a254dba37c5a372fc8b44ba29509ba052d4e859d upstream.

Reported-by: Carmen Cru <carmen.cru@belgacom.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/synth/emux/emux_hwdep.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/synth/emux/emux_hwdep.c
+++ b/sound/synth/emux/emux_hwdep.c
@@ -128,6 +128,9 @@ snd_emux_init_hwdep(struct snd_emux *emu
 	strcpy(hw->name, SNDRV_EMUX_HWDEP_NAME);
 	hw->iface = SNDRV_HWDEP_IFACE_EMUX_WAVETABLE;
 	hw->ops.ioctl = snd_emux_hwdep_ioctl;
+	/* The ioctl parameter types are compatible between 32- and
+	 * 64-bit architectures, so use the same function. */
+	hw->ops.ioctl_compat = snd_emux_hwdep_ioctl;
 	hw->exclusive = 1;
 	hw->private_data = emu;
 	if ((err = snd_card_register(emu->card)) < 0)


