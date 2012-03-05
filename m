Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab2CENkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:40:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36309 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2CENkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:40:11 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Keith Packard <keithp@keithp.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/i915: no lvds quirk for AOpen MP45" has been added to staging queue
Date: Mon,  5 Mar 2012 14:40:05 +0100
Message-Id: <1330954805-5789-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/i915: no lvds quirk for AOpen MP45

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next
  or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 0f896131dfc21ce0f4baad21db7672eaf6a183d2 Mon Sep 17 00:00:00 2001
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Wed, 8 Feb 2012 16:42:52 +0100
Subject: [PATCH] drm/i915: no lvds quirk for AOpen MP45

commit e57b6886f555ab57f40a01713304e2053efe51ec upstream.

According to a bug report, it doesn't have one.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44263
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 96b39fc..6476022 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -892,6 +892,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+                .ident = "AOpen i45GMx-I",
+                .matches = {
+                        DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
+                        DMI_MATCH(DMI_BOARD_NAME, "i45GMx-I"),
+                },
+        },
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Aopen i945GTt-VFA",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),
--
1.7.9

