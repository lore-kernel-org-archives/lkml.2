Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1GAJSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:18:36 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33249 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab1GAJSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:18:34 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Keith Packard <keithp@keithp.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 09/10] drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007" has been added to staging queue
Date: Fri,  1 Jul 2011 10:18:27 +0100
Message-Id: <1309511907-3150-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 09/10] drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From b0088882c63a9bdec8f3671438928ac7ab4bbcd8 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 4 Jun 2011 15:39:21 +0200
Subject: [PATCH 09/10] drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007

commit 6a574b5b9b186e28abd3e571dfd1700c5220b510 upstream.

I found this while figuring out why gnome-shell would not run on my
Asus EeeBox PC EB1007. As a standalone "pc" this device cleary does not have
an internal panel, yet it claims it does. Add a quirk to fix this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index d34c09f..7cfc814 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -865,6 +865,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "U800"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Asus EeeBox PC EB1007",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EB1007"),
+		},
+	},

 	{ }	/* terminating entry */
 };
--
1.7.4.1

