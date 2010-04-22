Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab0DVUX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:23:29 -0400
Received: from kroah.org ([198.145.64.141]:59684 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705Ab0DVUAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:17 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:10 2010
Message-Id: <20100422195409.926136021@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [051/139] drm/radeon/kms/combios: verify dac_adj values are valid
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 3a89b4a9ca7ce11e3b7d5119aea917b9fc29a302 upstream.

Some vbios dac_adj tables are all zeros.  Check for that
case and use the default table if so.

Should fix fdo bug 27478.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_combios.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -670,7 +670,9 @@ struct radeon_encoder_primary_dac *radeo
 			dac = RBIOS8(dac_info + 0x3) & 0xf;
 			p_dac->ps2_pdac_adj = (bg << 8) | (dac);
 		}
-		found = 1;
+		/* if the values are all zeros, use the table */
+		if (p_dac->ps2_pdac_adj)
+			found = 1;
 	}
 
 out:
@@ -812,7 +814,9 @@ struct radeon_encoder_tv_dac *radeon_com
 			bg = RBIOS8(dac_info + 0x10) & 0xf;
 			dac = RBIOS8(dac_info + 0x11) & 0xf;
 			tv_dac->ntsc_tvdac_adj = (bg << 16) | (dac << 20);
-			found = 1;
+			/* if the values are all zeros, use the table */
+			if (tv_dac->ps2_tvdac_adj)
+				found = 1;
 		} else if (rev > 1) {
 			bg = RBIOS8(dac_info + 0xc) & 0xf;
 			dac = (RBIOS8(dac_info + 0xc) >> 4) & 0xf;
@@ -825,7 +829,9 @@ struct radeon_encoder_tv_dac *radeon_com
 			bg = RBIOS8(dac_info + 0xe) & 0xf;
 			dac = (RBIOS8(dac_info + 0xe) >> 4) & 0xf;
 			tv_dac->ntsc_tvdac_adj = (bg << 16) | (dac << 20);
-			found = 1;
+			/* if the values are all zeros, use the table */
+			if (tv_dac->ps2_tvdac_adj)
+				found = 1;
 		}
 		tv_dac->tv_std = radeon_combios_get_tv_info(rdev);
 	}
@@ -842,7 +848,9 @@ struct radeon_encoder_tv_dac *radeon_com
 				    (bg << 16) | (dac << 20);
 				tv_dac->pal_tvdac_adj = tv_dac->ps2_tvdac_adj;
 				tv_dac->ntsc_tvdac_adj = tv_dac->ps2_tvdac_adj;
-				found = 1;
+				/* if the values are all zeros, use the table */
+				if (tv_dac->ps2_tvdac_adj)
+					found = 1;
 			} else {
 				bg = RBIOS8(dac_info + 0x4) & 0xf;
 				dac = RBIOS8(dac_info + 0x5) & 0xf;
@@ -850,7 +858,9 @@ struct radeon_encoder_tv_dac *radeon_com
 				    (bg << 16) | (dac << 20);
 				tv_dac->pal_tvdac_adj = tv_dac->ps2_tvdac_adj;
 				tv_dac->ntsc_tvdac_adj = tv_dac->ps2_tvdac_adj;
-				found = 1;
+				/* if the values are all zeros, use the table */
+				if (tv_dac->ps2_tvdac_adj)
+					found = 1;
 			}
 		} else {
 			DRM_INFO("No TV DAC info found in BIOS\n");


