Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0KNUIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:08:37 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64657 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab0KNUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:08:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=x3DS4uv8azgwDv2KcjQvqdlujXT3T+XEn2oZWt+MdVoQ2Edgz1kVXCOpRVOFc8Cjxl
         oP9ZvtFt9+xhS2QDoQh6O3lXBInXcuwTQXpgqwkcwf1pPEK+JBi/WY0WIveFZ2af+Ie1
         HjysQupJM47nCdjOspv0e2z6wbvLPuM6NeuX0=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Darren Jenkins <darrenrjenkins@gmail.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: radeon: fix error value sign
Date: Sun, 14 Nov 2010 23:08:27 +0300
Message-Id: <1289765309-5983-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable_vblank implementations should use negative result to indicate error.
radeon_enable_vblank() returns EINVAL in this case.  Change this to -EINVAL.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested.

 drivers/gpu/drm/radeon/radeon_irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_irq.c b/drivers/gpu/drm/radeon/radeon_irq.c
index 2f349a3..465746b 100644
--- a/drivers/gpu/drm/radeon/radeon_irq.c
+++ b/drivers/gpu/drm/radeon/radeon_irq.c
@@ -76,7 +76,7 @@ int radeon_enable_vblank(struct drm_device *dev, int crtc)
 		default:
 			DRM_ERROR("tried to enable vblank on non-existent crtc %d\n",
 				  crtc);
-			return EINVAL;
+			return -EINVAL;
 		}
 	} else {
 		switch (crtc) {
@@ -89,7 +89,7 @@ int radeon_enable_vblank(struct drm_device *dev, int crtc)
 		default:
 			DRM_ERROR("tried to enable vblank on non-existent crtc %d\n",
 				  crtc);
-			return EINVAL;
+			return -EINVAL;
 		}
 	}
 
-- 
1.7.0.4

