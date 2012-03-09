Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030505Ab2CIU0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:26:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030427Ab2CITqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:46:24 -0500
Message-Id: <20120309190203.766367972@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 18/95] ALSA: hda - Always set HP pin in unsol handler for STAC/IDT codecs
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 7bff172a352a2fbe9856bba517d71a2072aab041 upstream.

A bug report with an old Sony laptop showed that we can't rely on BIOS
setting the pins of headphones but the driver should set always by
itself.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4719,7 +4719,7 @@ static void stac92xx_hp_detect(struct hd
 		unsigned int val = AC_PINCTL_OUT_EN | AC_PINCTL_HP_EN;
 		if (no_hp_sensing(spec, i))
 			continue;
-		if (presence)
+		if (1 /*presence*/)
 			stac92xx_set_pinctl(codec, cfg->hp_pins[i], val);
 #if 0 /* FIXME */
 /* Resetting the pinctl like below may lead to (a sort of) regressions


