Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1BPAUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:20:33 -0500
Received: from kroah.org ([198.145.64.141]:39082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128Ab1BPAUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:34 2011
Message-Id: <20110216001433.933050994@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [088/272] ALSA: hda - Fix NULL-derefence with a single mic in STAC auto-mic detection
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 80c678526d7da73bde4d46a4622449c2b3c88409 upstream.

When only one mic is available and it's an analog mic, the current
IDT/STAC parser may give an Oops.

Reference: bko#25692
	https://bugzilla.kernel.org/show_bug.cgi?id=25692

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -3591,7 +3591,7 @@ static int stac_check_auto_mic(struct hd
 		if (check_mic_pin(codec, spec->dmic_nids[i],
 		    &fixed, &ext, &dock))
 			return 0;
-	if (!fixed && !ext && !dock)
+	if (!fixed || (!ext && !dock))
 		return 0; /* no input to switch */
 	if (!(get_wcaps(codec, ext) & AC_WCAP_UNSOL_CAP))
 		return 0; /* no unsol support */


