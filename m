Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab1LPTun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:50:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746Ab1LPTty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:49:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:46:00 2011
Message-Id: <20111216194600.379936316@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [39/53] drm/radeon/kms: fix DP setup on TRAVIS bridges
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cf2aff6eff251b6fbdaf8c253e65ff7c693de8cd upstream.

Supposedly both NUTMEG and TRAVIS should use the same
panel mode, but switching the panel mode for TRAVIS
gets things working.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=41569

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_dp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -560,9 +560,12 @@ static void radeon_dp_set_panel_mode(str
 	if (!ASIC_IS_DCE4(rdev))
 		return;
 
-	if (radeon_connector_encoder_get_dp_bridge_encoder_id(connector) !=
-	    ENCODER_OBJECT_ID_NONE)
+	if (radeon_connector_encoder_get_dp_bridge_encoder_id(connector) ==
+	    ENCODER_OBJECT_ID_NUTMEG)
 		panel_mode = DP_PANEL_MODE_INTERNAL_DP1_MODE;
+	else if (radeon_connector_encoder_get_dp_bridge_encoder_id(connector) ==
+		 ENCODER_OBJECT_ID_TRAVIS)
+		panel_mode = DP_PANEL_MODE_INTERNAL_DP2_MODE;
 	else if (connector->connector_type == DRM_MODE_CONNECTOR_eDP) {
 		u8 tmp = radeon_read_dpcd_reg(radeon_connector, DP_EDP_CONFIGURATION_CAP);
 		if (tmp & 1)


