Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab0DVUs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:48:58 -0400
Received: from kroah.org ([198.145.64.141]:37125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab0DVT1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:31 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:08 2010
Message-Id: <20100422190908.045925075@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [007/197] drm/radeon/kms: fix pal tv-out support on legacy IGP chips
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 15f7207761cfcf8f53fb6e5cacffe060478782c3 upstream.

Based on ddx patch by Andrzej Hajda.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_legacy_tv.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_legacy_tv.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_tv.c
@@ -57,6 +57,10 @@
 #define NTSC_TV_PLL_N_14 693
 #define NTSC_TV_PLL_P_14 7
 
+#define PAL_TV_PLL_M_14 19
+#define PAL_TV_PLL_N_14 353
+#define PAL_TV_PLL_P_14 5
+
 #define VERT_LEAD_IN_LINES 2
 #define FRAC_BITS 0xe
 #define FRAC_MASK 0x3fff
@@ -205,9 +209,24 @@ static const struct radeon_tv_mode_const
 		630627,             /* defRestart */
 		347,                /* crtcPLL_N */
 		14,                 /* crtcPLL_M */
-			8,                  /* crtcPLL_postDiv */
+		8,                  /* crtcPLL_postDiv */
 		1022,               /* pixToTV */
 	},
+	{ /* PAL timing for 14 Mhz ref clk */
+		800,                /* horResolution */
+		600,                /* verResolution */
+		TV_STD_PAL,         /* standard */
+		1131,               /* horTotal */
+		742,                /* verTotal */
+		813,                /* horStart */
+		840,                /* horSyncStart */
+		633,                /* verSyncStart */
+		708369,             /* defRestart */
+		211,                /* crtcPLL_N */
+		9,                  /* crtcPLL_M */
+		8,                  /* crtcPLL_postDiv */
+		759,                /* pixToTV */
+	},
 };
 
 #define N_AVAILABLE_MODES ARRAY_SIZE(available_tv_modes)
@@ -242,7 +261,7 @@ static const struct radeon_tv_mode_const
 		if (pll->reference_freq == 2700)
 			const_ptr = &available_tv_modes[1];
 		else
-			const_ptr = &available_tv_modes[1]; /* FIX ME */
+			const_ptr = &available_tv_modes[3];
 	}
 	return const_ptr;
 }
@@ -685,9 +704,9 @@ void radeon_legacy_tv_mode_set(struct dr
 			n = PAL_TV_PLL_N_27;
 			p = PAL_TV_PLL_P_27;
 		} else {
-			m = PAL_TV_PLL_M_27;
-			n = PAL_TV_PLL_N_27;
-			p = PAL_TV_PLL_P_27;
+			m = PAL_TV_PLL_M_14;
+			n = PAL_TV_PLL_N_14;
+			p = PAL_TV_PLL_P_14;
 		}
 	}
 


