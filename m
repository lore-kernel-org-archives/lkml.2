Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2LMOMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:12:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44926 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab2LMOMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>, Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 190/241] drm/radeon: fix typo in evergreen_mc_resume()
Date: Thu, 13 Dec 2012 11:59:15 -0200
Message-Id: <1355407206-17100-191-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index cb7d2e0..9c61b96 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1208,7 +1208,7 @@ void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *s
 	WREG32(BIF_FB_EN, FB_READ_EN | FB_WRITE_EN);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
-		if (save->crtc_enabled) {
+		if (save->crtc_enabled[i]) {
 			if (ASIC_IS_DCE6(rdev)) {
 				tmp = RREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i]);
 				tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
-- 
1.7.9.5

