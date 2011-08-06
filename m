Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795Ab1HFAMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:12:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab1HFAMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:16 2011
Message-Id: <20110806000416.329324388@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:04:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>, Takashi Iwai <tiwai@suse.de>
Subject: [47/50] ALSA: sound/core/pcm_compat.c: adjust array index
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit ca9380fd68514c7bc952282c1b4fc70607e9fe43 upstream.

Convert array index from the loop bound to the loop index.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,ar;
@@

for(e1 = 0; e1 < e2; e1++) { <...
  ar[
- e2
+ e1
  ]
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/pcm_compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -341,7 +341,7 @@ static int snd_pcm_ioctl_xfern_compat(st
 			kfree(bufs);
 			return -EFAULT;
 		}
-		bufs[ch] = compat_ptr(ptr);
+		bufs[i] = compat_ptr(ptr);
 		bufptr++;
 	}
 	if (dir == SNDRV_PCM_STREAM_PLAYBACK)


