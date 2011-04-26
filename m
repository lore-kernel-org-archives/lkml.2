Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab1DZVd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:33:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:44123 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab1DZVOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425951074"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: segooon@gmail.com, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [39/106] sound: oss: midi_synth: check get_user() return value
Message-Id: <20110426211318.C6B353E1887@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kulikov Vasiliy <segooon@gmail.com>

commit b3390ceab95601afc12213c3ec5551d3bc7b638f upstream.

get_user() may fail, if so return -EFAULT.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/oss/midi_synth.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/sound/oss/midi_synth.c
===================================================================
--- linux-2.6.35.y.orig/sound/oss/midi_synth.c
+++ linux-2.6.35.y/sound/oss/midi_synth.c
@@ -519,7 +519,9 @@ midi_synth_load_patch(int dev, int forma
 	{
 		unsigned char   data;
 
-		get_user(*(unsigned char *) &data, (unsigned char __user *) &((addr)[hdr_size + i]));
+		if (get_user(data,
+		    (unsigned char __user *)(addr + hdr_size + i)))
+			return -EFAULT;
 
 		eox_seen = (i > 0 && data & 0x80);	/* End of sysex */
 
