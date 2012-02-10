Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923Ab2BJXLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:11:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab2BJWmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:44 -0500
MIME-Version: 1.0
Message-Id: <20120210222947.989333740@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Seth Forshee <seth.forshee@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [patch 33/86] drm/radeon/kms: disable output polling when suspended
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit 86698c20f71d488b32c49ed4687fb3cf8a88a5ca upstream.

Polling the outputs when the device is suspended can result in erroneous
status updates. Disable output polling during suspend to prevent this
from happening.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_device.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -864,6 +864,8 @@ int radeon_suspend_kms(struct drm_device
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
+	drm_kms_helper_poll_disable(dev);
+
 	/* turn off display hw */
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
@@ -950,6 +952,8 @@ int radeon_resume_kms(struct drm_device
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
 	}
+
+	drm_kms_helper_poll_enable(dev);
 	return 0;
 }
 


