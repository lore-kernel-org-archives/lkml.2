Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab2BJXBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:01:55 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760696Ab2BJWo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:28 -0500
MIME-Version: 1.0
Message-Id: <20120210223440.506003629@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 02/55] ALSA: HDA: Fix duplicated output to more than one codec
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 54c2a89f60fd71b924d0f848ac892442951401a6 upstream.

This typo caused the wrong codec's nid to be checked for wcaps type.
As a result, sometimes speakers would duplicate the output sent to
HDMI output.

BugLink: https://bugs.launchpad.net/bugs/924320
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1328,7 +1328,7 @@ void snd_hda_codec_setup_stream(struct h
 		for (i = 0; i < c->cvt_setups.used; i++) {
 			p = snd_array_elem(&c->cvt_setups, i);
 			if (!p->active && p->stream_tag == stream_tag &&
-			    get_wcaps_type(get_wcaps(codec, p->nid)) == type)
+			    get_wcaps_type(get_wcaps(c, p->nid)) == type)
 				p->dirty = 1;
 		}
 	}


