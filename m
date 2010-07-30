Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab0G3SrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:47:08 -0400
Received: from kroah.org ([198.145.64.141]:35785 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759416Ab0G3Ret (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:08 2010
Message-Id: <20100730173108.030172538@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [059/140] drm/radeon/kms: fix legacy LVDS dpms sequence
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 15cb02c0a0338ee724bf23e31c7c410ecbffeeba upstream.

Add delay after turning off the LVDS encoder.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=16389

Tested-by: Jan Kreuzer <kontrollator@gmx.de>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -108,6 +108,7 @@ static void radeon_legacy_lvds_dpms(stru
 		udelay(panel_pwr_delay * 1000);
 		WREG32(RADEON_LVDS_GEN_CNTL, lvds_gen_cntl);
 		WREG32_PLL(RADEON_PIXCLKS_CNTL, pixclks_cntl);
+		udelay(panel_pwr_delay * 1000);
 		break;
 	}
 


