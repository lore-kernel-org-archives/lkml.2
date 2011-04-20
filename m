Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1DTTEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:04:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54996 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab1DTTEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:04:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Nf4YctVPjNLifyXIRQYAk/sz7O/ouWtTz/fglWeJcms7C+l+nNblPwgxeSkQXuYMt
	ddkoXdFerAO4J1rRBoycg==
From: Mike Waychison <mikew@google.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Raymond Yau <superquad.vortex2@gmail.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Luke Yelavich <luke.yelavich@canonical.com>
Cc: Mike Waychison <mikew@google.com>
Subject: [PATCH] ALSA: hda - Fix unused warnings when !SND_HDA_NEEDS_RESUME
Date: Wed, 20 Apr 2011 12:04:36 -0700
Message-Id: <1303326276-20645-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303246937-11302-1-git-send-email-mikew@google.com>
References: <1303246937-11302-1-git-send-email-mikew@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SND_HDA_NEEDS_RESUME is not defined, the compiler identifies that
the following symbols are static but not used:

 restore_shutup_pins
 hda_cleanup_all_streams

Fix warnings by adding SND_HDA_NEEDS_RESUME guards.

Signed-off-by: Mike Waychison <mikew@google.com>
---
v2:
- Applies to v2.6.39-rc4.
- Dropped moving ad198x_power_eapd and ad198x_power_eapd_write at
  Takashi Iwai <tiwai@suse.de>'s request.
---
 sound/pci/hda/hda_codec.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 430f41d..759ade1 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -937,6 +937,7 @@ void snd_hda_shutup_pins(struct hda_codec *codec)
 }
 EXPORT_SYMBOL_HDA(snd_hda_shutup_pins);
 
+#ifdef SND_HDA_NEEDS_RESUME
 /* Restore the pin controls cleared previously via snd_hda_shutup_pins() */
 static void restore_shutup_pins(struct hda_codec *codec)
 {
@@ -953,6 +954,7 @@ static void restore_shutup_pins(struct hda_codec *codec)
 	}
 	codec->pins_shutup = 0;
 }
+#endif
 
 static void init_hda_cache(struct hda_cache_rec *cache,
 			   unsigned int record_size);
@@ -1329,6 +1331,7 @@ static void purify_inactive_streams(struct hda_codec *codec)
 	}
 }
 
+#ifdef SND_HDA_NEEDS_RESUME
 /* clean up all streams; called from suspend */
 static void hda_cleanup_all_streams(struct hda_codec *codec)
 {
@@ -1340,6 +1343,7 @@ static void hda_cleanup_all_streams(struct hda_codec *codec)
 			really_cleanup_stream(codec, p);
 	}
 }
+#endif
 
 /*
  * amp access functions
-- 
1.7.3.1

