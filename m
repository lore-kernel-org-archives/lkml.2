Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2KNFuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54941 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320Ab2KNFt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:49:58 -0500
Message-Id: <20121114053935.669195306@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:46 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 13/82] drm/radeon: fix typo in evergreen_mc_resume()
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 695ddeb457584a602f2ba117d08ce37cf6ec1589 upstream.

Add missing index that may have led us to enabling
more crtcs than necessary.

May also fix:
https://bugs.freedesktop.org/show_bug.cgi?id=56139

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/evergreen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1164,7 +1164,7 @@ void evergreen_mc_resume(struct radeon_d
 	WREG32(BIF_FB_EN, FB_READ_EN | FB_WRITE_EN);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
-		if (save->crtc_enabled) {
+		if (save->crtc_enabled[i]) {
 			tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 			tmp &= ~EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
 			WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);


