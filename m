Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1G1Mqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:46:32 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39760 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab1G1MqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:46:17 -0400
From: Julia Lawall <julia@diku.dk>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] sound/core/pcm_compat.c: adjust array index
Date: Thu, 28 Jul 2011 14:46:05 +0200
Message-Id: <1311857165-14780-6-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1311857165-14780-1-git-send-email-julia@diku.dk>
References: <1311857165-14780-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

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

---
Not tested.

 sound/core/pcm_compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -342,7 +342,7 @@ static int snd_pcm_ioctl_xfern_compat(st
 			kfree(bufs);
 			return -EFAULT;
 		}
-		bufs[ch] = compat_ptr(ptr);
+		bufs[i] = compat_ptr(ptr);
 		bufptr++;
 	}
 	if (dir == SNDRV_PCM_STREAM_PLAYBACK)

