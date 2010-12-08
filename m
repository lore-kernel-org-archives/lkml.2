Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab0LHB10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:27:26 -0500
Received: from kroah.org ([198.145.64.141]:33462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab0LHBC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:27 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:39 2010
Message-Id: <20101208005739.280398979@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [178/289] drm/radeon/kms: fix thermal sensor reporting on rv6xx
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit b2298fd27127f872881048fd37cb9217a648ae06 upstream.

Temperature is not shifted as on newer asics.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -97,14 +97,8 @@ u32 rv6xx_get_temp(struct radeon_device
 {
 	u32 temp = (RREG32(CG_THERMAL_STATUS) & ASIC_T_MASK) >>
 		ASIC_T_SHIFT;
-	u32 actual_temp = 0;
 
-	if ((temp >> 7) & 1)
-		actual_temp = 0;
-	else
-		actual_temp = (temp >> 1) & 0xff;
-
-	return actual_temp * 1000;
+	return temp * 1000;
 }
 
 void r600_pm_get_dynpm_state(struct radeon_device *rdev)


