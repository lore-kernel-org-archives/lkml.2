Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab1DMQC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:02:28 -0400
Received: from kroah.org ([198.145.64.141]:54475 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191Ab1DMPzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:48 2011
Message-Id: <20110413155148.428854810@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kulikov Vasiliy <segooon@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [51/74] sound: oss: midi_synth: check get_user() return value
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
 


