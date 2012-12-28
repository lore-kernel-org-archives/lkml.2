Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2L1TQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:16:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54840 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711Ab2L1TQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:41 -0500
Message-Id: <20121228190331.745415727@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Calvin Walton <calvin.walton@kepstin.ca>
Subject: [ 008/173] i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index e05c0d3..e9a6f6a 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -780,6 +780,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
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


