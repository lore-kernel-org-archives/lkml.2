Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936587Ab0COTdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:33:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42345 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0COTdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:33:16 -0400
From: Surbhi Palande <surbhi.palande@canonical.com>
To: dri-devel@lists.sourceforge.net
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, airlied@linux.ie, yakui.zhao@intel.com,
       jbarnes@virtuousgeek.org, zhenyuw@linux.intel.com, stable@kernel.org
Subject: [PATCH 2/2] drm/i915: blacklist lid status: Elite Co. G335
Date: Mon, 15 Mar 2010 21:33:06 +0200
Message-Id: <ce705907d4c925bc2efa92a9b6854a2b42cbaa75.1268680514.git.surbhi.palande@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1268680514.git.surbhi.palande@canonical.com>
References: <cover.1268680514.git.surbhi.palande@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://launchpad.net/bug/515246

Elite Computers G335 reports the lid status as closed when it is open. This
leads to a "no connectors reported" error at startup. Blacklisting
it to always return a connected status for the default lvds connector.

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index afd0ee7..b75a941 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -650,6 +650,13 @@ static const struct dmi_system_id bad_lid_status[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "VGN-BX196VP"),
 		},
 	},
+	{
+		.ident = "Elitegroup ECS G335",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Elitegroup Co."),
+			DMI_MATCH(DMI_BOARD_NAME, "ECS G335"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.3.3

