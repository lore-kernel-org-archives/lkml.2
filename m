Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603Ab2FVHx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:53:29 -0400
Received: from cube.ipv4.spacelabs.nl ([192.87.65.66]:52801 "EHLO
	cube.luon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761589Ab2FVHxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:53:25 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2012 03:53:25 EDT
From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Subject: [PATCH] drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13
Date: Fri, 22 Jun 2012 09:43:07 +0200
Message-Id: <1340350987-24699-1-git-send-email-sjoerd.simons@collabora.co.uk>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This box claims to have an LVDS interface but doesn't
actually have one.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 08eb04c..9393860 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -777,6 +777,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "MS-7469"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "ZOTAC ZBOXSD-ID12/ID13",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ZOTAC"),
+			DMI_MATCH(DMI_BOARD_NAME, "ZBOXSD-ID12/ID13"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
-- 
1.7.10

