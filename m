Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab1KJF3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:29:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933703Ab1KJDUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:20:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:02 2011
Message-Id: <20111109212702.500748134@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [022/262] drm/radeon/kms: bail early in dvi_detect for digital only connectors
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5f0a26128d66ef81613fe923d5c288942844ccdc upstream.

DVI-D and HDMI-A are digital only, so there's no need to
attempt analog load detect.  Also, skip bail before the
!force check, or we fail to get a disconnect events.
The next patches in the series attempt to fix disconnect
events for connectors with analog support (DVI-I, HDMI-B,
DVI-A).

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=41561

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -950,6 +950,11 @@ radeon_dvi_detect(struct drm_connector *
 	if ((ret == connector_status_connected) && (radeon_connector->use_digital == true))
 		goto out;
 
+	/* DVI-D and HDMI-A are digital only */
+	if ((connector->connector_type == DRM_MODE_CONNECTOR_DVID) ||
+	    (connector->connector_type == DRM_MODE_CONNECTOR_HDMIA))
+		goto out;
+
 	if (!force) {
 		ret = connector->status;
 		goto out;


