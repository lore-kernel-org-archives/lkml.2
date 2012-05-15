Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496Ab2EOCeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:34:44 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53525 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965422Ab2EOCR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 145/179] ALSA: sound/core/pcm_compat.c: adjust array index
Date: Mon, 14 May 2012 22:14:01 -0400
Message-ID: <1337048075-6132-146-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/core/pcm_compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index 5fb2e28..91cdf94 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -342,7 +342,7 @@ static int snd_pcm_ioctl_xfern_compat(struct snd_pcm_substream *substream,
 			kfree(bufs);
 			return -EFAULT;
 		}
-		bufs[ch] = compat_ptr(ptr);
+		bufs[i] = compat_ptr(ptr);
 		bufptr++;
 	}
 	if (dir == SNDRV_PCM_STREAM_PLAYBACK)
-- 
1.7.9.6

