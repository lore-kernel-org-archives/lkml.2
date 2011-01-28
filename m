Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1A1Wfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:35:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1A1Wfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:35:37 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: David Airlie <airlied@linux.ie>
Cc: Stefan Weil <weil@mail.berlios.de>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexdeucher@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] radeon: Fix wrong boolean operator
Date: Fri, 28 Jan 2011 23:35:18 +0100
Message-Id: <1296254118-7845-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:nj3/w7O6x6rA6g3ImYJ7FmB95qqW3/bItCDn1fRqKeo
 qbBGL+DmPJKAiGP5/+mr9sIApxIgXfNP/hEVnTLKut8GwHfw1h
 /76Fjcpho1wI02t+7iM6maSxhAnp9C03ATuprO+LQcG8ri61ee
 AffrNX+tIkRhwdNfu5xs8BsUBhH4to7lvlbFT88xDgCVfmnKFN
 SEtGi9VF0b94B6RKjcUa3miXYSwd5fsvkwc7WF6TbUI2pQX/ZO
 UE+Gik4QrRCPs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error is reported by cppcheck:
drivers/gpu/drm/radeon/radeon_encoders.c:1066: warning: Mutual exclusion over || always evaluates to true. Did you intend to use && instead?

It looks like cppcheck is correct, so fix this. No test was run.

Cc: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/gpu/drm/radeon/radeon_encoders.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/radeon/radeon_encoders.c
index 5e90984..d4a5422 100644
--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -1063,7 +1063,7 @@ atombios_set_edp_panel_power(struct drm_connector *connector, int action)
 	if (!ASIC_IS_DCE4(rdev))
 		return;
 
-	if ((action != ATOM_TRANSMITTER_ACTION_POWER_ON) ||
+	if ((action != ATOM_TRANSMITTER_ACTION_POWER_ON) &&
 	    (action != ATOM_TRANSMITTER_ACTION_POWER_OFF))
 		return;
 
-- 
1.7.2.3

