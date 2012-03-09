Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031800Ab2CIUDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:03:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54260 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031696Ab2CITwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:52:54 -0500
Message-Id: <20120309190203.616981798@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 16/95] ALSA: hda/realtek - Fix resume of multiple input sources
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 068b939431486f524438330b0848a8222e33d421 upstream.

When there are multiple input sources, the driver wrongly overwrites with
the value of the last input source on other slots at resume.  Thus the
primary input source may be shown wrongly.

Reported-and-tested-by: Julian Sikorski <belegdol@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3695,7 +3695,7 @@ static void alc_auto_init_input_src(stru
 	else
 		nums = spec->num_adc_nids;
 	for (c = 0; c < nums; c++)
-		alc_mux_select(codec, 0, spec->cur_mux[c], true);
+		alc_mux_select(codec, c, spec->cur_mux[c], true);
 }
 
 /* add mic boosts if needed */


