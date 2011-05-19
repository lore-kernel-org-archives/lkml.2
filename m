Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1ESDxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:53:03 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:32799 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932317Ab1ESDxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U+djO/9/O0Dqc45vqQeanvL8OKQDNakS+tpOzEL62c0SpD6QXntnlQNUW+9c2SLLUl
         Ae5t3yILou5h/GU0cgQ6vEjIipUz7pg6JPOQPYk1cJtY7FP3iU/KlAngWY1MeAJYkTYN
         9ecqXorEnL1gqeALxqbdxsVgPhRIO0SMd87Gc=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH] ALSA: sound, core, pcm_lib: fix xrun_log
Date: Wed, 18 May 2011 23:52:38 -0400
Message-Id: <1305777158-21361-1-git-send-email-bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110519111557.f147fc1e.sfr@canb.auug.org.au>
References: <20110519111557.f147fc1e.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xrun_log function was augmented with the in_interrupt parameter whereas the
empty macro definition used when xrun logging is disabled was not.

Add a third parameter to the empty macro definition so as to not cause compiler
errors when xrun logging (CONFIG_SND_PCM_XRUN_DEBUG) is disabled.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>

---
This fixes the build error caused by ec08b14483de ("ALSA: sound, core, pcm_lib:
xrun_log: log also in_interrupt") -- which was my patch. Sorry for the breakage.

---
 sound/core/pcm_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index c8c8091..abfeff16 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -266,7 +266,7 @@ static void xrun_log_show(struct snd_pcm_substream *substream)
 #else /* ! CONFIG_SND_PCM_XRUN_DEBUG */
 
 #define hw_ptr_error(substream, fmt, args...) do { } while (0)
-#define xrun_log(substream, pos)	do { } while (0)
+#define xrun_log(substream, pos, in_interrupt)	do { } while (0)
 #define xrun_log_show(substream)	do { } while (0)
 
 #endif
-- 
1.7.4.1

