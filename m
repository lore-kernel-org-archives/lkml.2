Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab1DZVPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:15:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:22884 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500Ab1DZVPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483891"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: lydiawang@viatech.com.cn, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [99/106] ALSA: hda - VIA: Add missing support for VT1718S in A-A path
Message-Id: <20110426211421.D14BC3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Lydia Wang <lydiawang@viatech.com.cn>

commit ab657e0cacc39d88145871c6a3c844597c02d406 upstream.

Modify mute_aa_path() function to support VT1718S codec.

Signed-off-by: Lydia Wang <lydiawang@viatech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_via.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.35.y/sound/pci/hda/patch_via.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/patch_via.c
+++ linux-2.6.35.y/sound/pci/hda/patch_via.c
@@ -1300,6 +1300,11 @@ static void mute_aa_path(struct hda_code
 		start_idx = 2;
 		end_idx = 4;
 		break;
+	case VT1718S:
+		nid_mixer = 0x21;
+		start_idx = 1;
+		end_idx = 3;
+		break;
 	default:
 		return;
 	}
