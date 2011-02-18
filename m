Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab1BRJFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:05:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56381 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab1BRJE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:04:59 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 2/7] drm/radeon/kms: make the mac rv630 quirk generic" has been added to staging queue
Date: Fri, 18 Feb 2011 10:04:57 +0100
Message-Id: <1298019897-2344-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Alex Deucher <alexdeucher@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 2/7] drm/radeon/kms: make the mac rv630 quirk generic

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From a1921ef3545677c33e0806e65023a505fa393e26 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 18 Jan 2011 18:26:11 +0000
Subject: [PATCH 2/7] drm/radeon/kms: make the mac rv630 quirk generic

commit be23da8ad219650517cbbb7acbeaeb235667113a upstream.

Seems some other boards do this as well.

Reported-by: Andrea Merello <andrea.merello@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 42eb4a8..38631f6 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -262,15 +262,11 @@ static bool radeon_atom_apply_quirks(struct drm_device *dev,
 			*line_mux = 0x90;
 	}

-	/* mac rv630 */
-	if ((dev->pdev->device == 0x9588) &&
-	    (dev->pdev->subsystem_vendor == 0x106b) &&
-	    (dev->pdev->subsystem_device == 0x00a6)) {
-		if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
-		    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
-			*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
-			*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
-		}
+	/* mac rv630, rv730, others */
+	if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
+	    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
+		*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
+		*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
 	}

 	/* ASUS HD 3600 XT board lists the DVI port as HDMI */
--
1.7.0.4

