Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab1BRJFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:05:06 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56362 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab1BRJE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:04:58 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 1/7] drm/radeon/kms: add quirk for Mac Radeon HD 2600 card" has been added to staging queue
Date: Fri, 18 Feb 2011 10:04:56 +0100
Message-Id: <1298019896-2312-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Alex Deucher <alexdeucher@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 1/7] drm/radeon/kms: add quirk for Mac Radeon HD 2600 card

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 022c682fa1f1a40a3670ca155912074b5023d2cf Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 4 Jan 2011 00:43:39 -0500
Subject: [PATCH 1/7] drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit f598aa7593427ffe3a61e7767c34bd695a5e7ed0 upstream.

Reported-by: 屋国遥 <hyagni@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index b57e4a8..42eb4a8 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -262,6 +262,17 @@ static bool radeon_atom_apply_quirks(struct drm_device *dev,
 			*line_mux = 0x90;
 	}

+	/* mac rv630 */
+	if ((dev->pdev->device == 0x9588) &&
+	    (dev->pdev->subsystem_vendor == 0x106b) &&
+	    (dev->pdev->subsystem_device == 0x00a6)) {
+		if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
+		    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
+			*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
+			*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
+		}
+	}
+
 	/* ASUS HD 3600 XT board lists the DVI port as HDMI */
 	if ((dev->pdev->device == 0x9598) &&
 	    (dev->pdev->subsystem_vendor == 0x1043) &&
--
1.7.0.4

