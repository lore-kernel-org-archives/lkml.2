Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab2LMOLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:11:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44792 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab2LMOLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 165/241] drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13
Date: Thu, 13 Dec 2012 11:58:50 -0200
Message-Id: <1355407206-17100-166-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

commit 9756fe38d10b2bf90c81dc4d2f17d5632e135364 upstream.

This box claims to have an LVDS interface but doesn't
actually have one.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
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
1.7.9.5

