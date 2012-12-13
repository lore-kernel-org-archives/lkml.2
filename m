Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2LMODb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:03:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab2LMOD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Egbert Eich <eich@suse.de>, Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 044/241] DRM/Radeon: Fix Load Detection on legacy primary DAC.
Date: Thu, 13 Dec 2012 11:56:49 -0200
Message-Id: <1355407206-17100-45-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.de>

commit 83325d072185899b706de2956170b246585aaec9 upstream.

An uninitialized variable led to broken load detection.

Signed-off-by: Egbert Eich <eich@suse.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index 9e62325..8148cf8 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -651,6 +651,7 @@ static enum drm_connector_status radeon_legacy_primary_dac_detect(struct drm_enc
 	tmp |= RADEON_DAC_RANGE_CNTL_PS2 | RADEON_DAC_CMP_EN;
 	WREG32(RADEON_DAC_CNTL, tmp);
 
+	tmp = dac_macro_cntl;
 	tmp &= ~(RADEON_DAC_PDWN_R |
 		 RADEON_DAC_PDWN_G |
 		 RADEON_DAC_PDWN_B);
-- 
1.7.9.5

