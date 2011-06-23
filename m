Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab1FWSYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:24:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:34143 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab1FWRfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:35:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 074/247] drm/radeon/kms: make the mac rv630 quirk generic
Date: Thu, 23 Jun 2011 13:32:22 -0400
Message-Id: <1308850515-15242-15-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit be23da8ad219650517cbbb7acbeaeb235667113a upstream.

Seems some other boards do this as well.

Reported-by: Andrea Merello <andrea.merello@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 8e4031f..139f8ad 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -272,15 +272,11 @@ static bool radeon_atom_apply_quirks(struct drm_device *dev,
 			*line_mux = 0x90;
 	}
 
-	/* mac rv630 */
-	if ((dev->pdev->device == 0x9588) &&
-	    (dev->pdev->subsystem_vendor == 0x106b) &&
-	    (dev->pdev->subsystem_device == 0x00a6)) {
-		if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
-		    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
-			*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
-			*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
-		}
+	/* mac rv630, rv730, others */
+	if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
+	    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
+		*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
+		*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
 	}
 
 	/* ASUS HD 3600 XT board lists the DVI port as HDMI */
-- 
1.7.4.4

