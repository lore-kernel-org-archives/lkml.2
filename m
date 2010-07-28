Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0G1Qlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:41:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52947 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab0G1Qlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bEZ9OBP0ohfmZFKHA7OZ3XZAAEARXsbfKJR6uu+Akhx8KjK5aklZqHqCz/reQdL68W
         93TH0ld9geoPCtTO6B8AGkHgJNYXhu243sPcNhSslMJXVUCwWCrVD3O9ucb23BC336IY
         40hJV45f2wt7RIw7N7nvVjM1xYd9Jki8wBL4k=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Roel Kluin <roel.kluin@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] oss: midi_synth: check get_user() return value
Date: Wed, 28 Jul 2010 20:41:17 +0400
Message-Id: <1280335277-23435-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_user() may fail, if so return -EFAULT.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/oss/midi_synth.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sound/oss/midi_synth.c b/sound/oss/midi_synth.c
index 3bc7104..3c09374 100644
--- a/sound/oss/midi_synth.c
+++ b/sound/oss/midi_synth.c
@@ -523,7 +523,9 @@ midi_synth_load_patch(int dev, int format, const char __user *addr,
 	{
 		unsigned char   data;
 
-		get_user(*(unsigned char *) &data, (unsigned char __user *) &((addr)[hdr_size + i]));
+		if (get_user(data,
+		    (unsigned char __user *)(addr + hdr_size + i)))
+			return -EFAULT;
 
 		eox_seen = (i > 0 && data & 0x80);	/* End of sysex */
 
-- 
1.7.0.4

