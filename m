Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab2LMOR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:17:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45156 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933502Ab2LMOPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 232/241] i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard
Date: Thu, 13 Dec 2012 11:59:57 -0200
Message-Id: <1355407206-17100-233-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Walton <calvin.walton@kepstin.ca>

commit a51d4ed01e5bb39d2cf36a12f9976ab08872c192 upstream.

This board is incorrectly detected as having an LVDS connector,
resulting in the VGA output (the only available output on the board)
showing the console only in the top-left 1024x768 pixels, and an extra
LVDS connector appearing in X.

It's a desktop Mini-ITX board using an Atom D525 CPU with an NM10
chipset.

I've had this board for about a year, but this is the first time I
noticed the issue because I've been running it headless for most of its
life.

Signed-off-by: Calvin Walton <calvin.walton@kepstin.ca>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 9393860..7af9258 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -785,6 +785,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "ZBOXSD-ID12/ID13"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Gigabyte GA-D525TUD",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
+			DMI_MATCH(DMI_BOARD_NAME, "D525TUD"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
-- 
1.7.9.5

