Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab2BAQJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:09:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49500 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab2BAQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:09:28 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH] drm/radeon/kms: disable output polling when suspended
Date: Wed,  1 Feb 2012 10:09:24 -0600
Message-Id: <1328112564-17508-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Polling the outputs when the device is suspended can result in erroneous
status updates. Disable output polling during suspend to prevent this
from happening.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/radeon/radeon_device.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index cec51a5..49f7cb7 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -883,6 +883,8 @@ int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
+	drm_kms_helper_poll_disable(dev);
+
 	/* turn off display hw */
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
@@ -972,6 +974,8 @@ int radeon_resume_kms(struct drm_device *dev)
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
 	}
+
+	drm_kms_helper_poll_enable(dev);
 	return 0;
 }
 
-- 
1.7.8.3

