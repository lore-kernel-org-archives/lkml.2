Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab1C3VSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:18:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:24598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965233Ab1C3VJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673448704"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [243/275] ALSA: hda - Fix SPDIF out regression on ALC889
Message-Id: <20110330210809.8ED8E3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 20b67dddcc5f29d3d0c900225d85e0ac655bc69d upstream.

The commit 5a8cfb4e8ae317d283f84122ed20faa069c5e0c4
    ALSA: hda - Use ALC_INIT_DEFAULT for really default initialization
changed to use the default initialization method for ALC889, but
this caused a regression on SPDIF output on some machines.
This seems due to the COEF setup included in the default init procedure.
For making SPDIF working again, the COEF-setup has to be avoided for
the id 0889.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=24342
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/sound/pci/hda/patch_realtek.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/patch_realtek.c	2011-03-29 22:50:15.688856979 -0700
+++ linux-2.6.35.y/sound/pci/hda/patch_realtek.c	2011-03-29 23:03:03.274216391 -0700
@@ -1161,7 +1161,7 @@
 		case 0x10ec0883:
 		case 0x10ec0885:
 		case 0x10ec0887:
-		case 0x10ec0889:
+		/*case 0x10ec0889:*/ /* this causes an SPDIF problem */
 			alc889_coef_init(codec);
 			break;
 		case 0x10ec0888:
