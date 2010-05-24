Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab0EXX2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:28:48 -0400
Received: from kroah.org ([198.145.64.141]:59427 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537Ab0EXXXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:44 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:15 2010
Message-Id: <20100524231815.267471855@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [23/39] ALSA: hda: Fix 0 dB for Lenovo models using Conexant CX20549 (Venice)
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Daniel T Chen <crimsun@ubuntu.com>

commit 0ebf9e3692d640917fb792a7494d05e1f5b1058f upstream.

Reference: http://mailman.alsa-project.org/pipermail/alsa-devel/2010-May/027525.html

As reported on the mailing list, we also need to cap to the 0 dB offset
for Lenovo models, else the sound will be distorted.

Reported-and-Tested-by: Tim Starling <tstarling@wikimedia.org>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1176,9 +1176,10 @@ static int patch_cxt5045(struct hda_code
 	case 0x103c:
 	case 0x1631:
 	case 0x1734:
-		/* HP, Packard Bell, & Fujitsu-Siemens laptops have really bad
-		 * sound over 0dB on NID 0x17. Fix max PCM level to 0 dB
-		 * (originally it has 0x2b steps with 0dB offset 0x14)
+	case 0x17aa:
+		/* HP, Packard Bell, Fujitsu-Siemens & Lenovo laptops have
+		 * really bad sound over 0dB on NID 0x17. Fix max PCM level to
+		 * 0 dB (originally it has 0x2b steps with 0dB offset 0x14)
 		 */
 		snd_hda_override_amp_caps(codec, 0x17, HDA_INPUT,
 					  (0x14 << AC_AMPCAP_OFFSET_SHIFT) |


