Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab0G3SaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:30:21 -0400
Received: from kroah.org ([198.145.64.141]:58190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759874Ab0G3RzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:11 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:39 2010
Message-Id: <20100730175139.398983528@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [064/205] drm/radeon/kms: fix shared ddc handling
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit b2ea4aa67bfd084834edd070e0a4a47857d6db59 upstream.

Connectors with a shared ddc line can be connected to different
encoders.

Reported by Pasi Kärkkäinen <pasik@iki.fi> on dri-devel

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -785,7 +785,9 @@ static enum drm_connector_status radeon_
 					if (connector == list_connector)
 						continue;
 					list_radeon_connector = to_radeon_connector(list_connector);
-					if (radeon_connector->devices == list_radeon_connector->devices) {
+					if (list_radeon_connector->shared_ddc &&
+					    (list_radeon_connector->ddc_bus->rec.i2c_id ==
+					     radeon_connector->ddc_bus->rec.i2c_id)) {
 						if (drm_detect_hdmi_monitor(radeon_connector->edid)) {
 							if (connector->connector_type == DRM_MODE_CONNECTOR_DVID) {
 								kfree(radeon_connector->edid);


