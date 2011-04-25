Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab1DYUjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:39:17 -0400
Received: from 1wt.eu ([62.212.114.60]:34435 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab1DYUZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:01 -0400
Message-Id: <20110425200239.293862452@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Kulikov Vasiliy <segooon@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 145/173] sound: oss: midi_synth: check get_user() return value
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kulikov Vasiliy <segooon@gmail.com>

commit b3390ceab95601afc12213c3ec5551d3bc7b638f upstream.

get_user() may fail, if so return -EFAULT.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/oss/midi_synth.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/oss/midi_synth.c
+++ b/sound/oss/midi_synth.c
@@ -519,7 +519,9 @@ midi_synth_load_patch(int dev, int forma
 	{
 		unsigned char   data;
 
-		get_user(*(unsigned char *) &data, (unsigned char __user *) &((addr)[hdr_size + i]));
+		if (get_user(data,
+		    (unsigned char __user *)(addr + hdr_size + i)))
+			return -EFAULT;
 
 		eox_seen = (i > 0 && data & 0x80);	/* End of sysex */
 


