Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1DZM04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:56 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57514 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1DZM0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:51 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Eric Anholt <eric@anholt.net>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 20/21] drm/i915: Stop trying to use ACPI lid status to determine LVDS connection." has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:49 +0200
Message-Id: <1303820809-4001-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 20/21] drm/i915: Stop trying to use ACPI lid status to determine LVDS connection.

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 0e6d2fb296c34ffee64796b0adf6a3dee9321e41 Mon Sep 17 00:00:00 2001
From: Eric Anholt <eric@anholt.net>
Date: Wed, 17 Mar 2010 13:48:06 -0700
Subject: [PATCH 20/21] drm/i915: Stop trying to use ACPI lid status to determine LVDS connection.

commit 6e6c822868f113dabe3c33bdd91e883cc28fa11b upstream.

I've been getting more and more quirk reports about this.  It seems
clear at this point that other OSes are not using this for determining
whether the integrated panel should be turned on, and it is not
reliable for doing so.  Better to light up an unintended panel than to
not light up the only usable output on the system.

Signed-off-by: Eric Anholt <eric@anholt.net>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |   52 +------------------------------------
 1 files changed, 1 insertions(+), 51 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 49c724e..d34c09f 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -599,53 +599,6 @@ static void intel_lvds_mode_set(struct drm_encoder *encoder,
 	I915_WRITE(PFIT_CONTROL, lvds_priv->pfit_control);
 }

-/* Some lid devices report incorrect lid status, assume they're connected */
-static const struct dmi_system_id bad_lid_status[] = {
-	{
-		.ident = "Compaq nx9020",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_NAME, "3084"),
-		},
-	},
-	{
-		.ident = "Samsung SX20S",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Samsung Electronics"),
-			DMI_MATCH(DMI_BOARD_NAME, "SX20S"),
-		},
-	},
-	{
-		.ident = "Aspire One",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire one"),
-		},
-	},
-	{
-		.ident = "Aspire 1810T",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1810T"),
-		},
-	},
-	{
-		.ident = "PC-81005",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MALATA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PC-81005"),
-		},
-	},
-	{
-		.ident = "Clevo M5x0N",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
-			DMI_MATCH(DMI_BOARD_NAME, "M5x0N"),
-		},
-	},
-	{ }
-};
-
 /**
  * Detect the LVDS connection.
  *
@@ -661,12 +614,9 @@ static enum drm_connector_status intel_lvds_detect(struct drm_connector *connect
 	/* ACPI lid methods were generally unreliable in this generation, so
 	 * don't even bother.
 	 */
-	if (IS_GEN2(dev))
+	if (IS_GEN2(dev) || IS_GEN3(dev))
 		return connector_status_connected;

-	if (!dmi_check_system(bad_lid_status) && !acpi_lid_open())
-		status = connector_status_disconnected;
-
 	return status;
 }

--
1.7.0.4

