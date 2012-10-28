Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2J1XwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:52:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41750 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756149Ab2J1X05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:57 -0400
Message-Id: <20121028231540.148356860@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:46 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 010/105] drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

commit 9756fe38d10b2bf90c81dc4d2f17d5632e135364 upstream.

This box claims to have an LVDS interface but doesn't
actually have one.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index ab4d647..05fcadb 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -778,6 +778,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
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


