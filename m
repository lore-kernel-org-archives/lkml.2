Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab0EJXfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:35:22 -0400
Received: from kroah.org ([198.145.64.141]:33199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434Ab0EJWwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:24 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:22 2010
Message-Id: <20100510223322.724974026@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [061/117] ALSA: hda: Fix 0 dB for Packard Bell models using Conexant CX20549 (Venice)
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 8f0f5ff6777104084b4b2e1ae079541c2a6ed6d9 upstream.

BugLink: https://launchpad.net/bugs/541802

The OR's hardware distorts at PCM 100% because it does not correspond to
0 dB. Fix this in patch_cxt5045() for all Packard Bell models.

Reported-by: Valombre
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1174,9 +1174,10 @@ static int patch_cxt5045(struct hda_code
 
 	switch (codec->subsystem_id >> 16) {
 	case 0x103c:
+	case 0x1631:
 	case 0x1734:
-		/* HP & Fujitsu-Siemens laptops have really bad sound over 0dB
-		 * on NID 0x17. Fix max PCM level to 0 dB
+		/* HP, Packard Bell, & Fujitsu-Siemens laptops have really bad
+		 * sound over 0dB on NID 0x17. Fix max PCM level to 0 dB
 		 * (originally it has 0x2b steps with 0dB offset 0x14)
 		 */
 		snd_hda_override_amp_caps(codec, 0x17, HDA_INPUT,


