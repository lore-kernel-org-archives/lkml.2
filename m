Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab0EJXCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:02:07 -0400
Received: from kroah.org ([198.145.64.141]:51834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab0EJW6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:10 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:39 2010
Message-Id: <20100510223539.359853556@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [55/98] ALSA: hda: Fix max PCM level to 0 dB for Fujitsu-Siemens laptops using CX20549 (Venice)
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 0b587fc4d35afb1bc0fc3d890084bb14c78372dc upstream.

BugLink: https://bugtrack.alsa-project.org/alsa-bug/view.php?id=4792

Cristian reported that these models have really bad sound above 6 dB
and proposed the original patch. I've updated the comment to reflect
this change.

Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Reported-by: Cristian Klein
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1175,9 +1175,10 @@ static int patch_cxt5045(struct hda_code
 
 	switch (codec->subsystem_id >> 16) {
 	case 0x103c:
-		/* HP laptop has a really bad sound over 0dB on NID 0x17.
-		 * Fix max PCM level to 0 dB
-		 * (originall it has 0x2b steps with 0dB offset 0x14)
+	case 0x1734:
+		/* HP & Fujitsu-Siemens laptops have really bad sound over 0dB
+		 * on NID 0x17. Fix max PCM level to 0 dB
+		 * (originally it has 0x2b steps with 0dB offset 0x14)
 		 */
 		snd_hda_override_amp_caps(codec, 0x17, HDA_INPUT,
 					  (0x14 << AC_AMPCAP_OFFSET_SHIFT) |


